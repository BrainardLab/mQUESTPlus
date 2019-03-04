clearvars;
close all
clc;

numberOfTrials = 128;


theta = @(x,threshold, slope) max(1,slope*(-x-threshold));
myFun = @(stimPair,psiParams) ...
        qpPFNormal(abs(theta(stimPair(:,1),psiParams(1), psiParams(2)) - ...
                theta(stimPair(:,2),psiParams(1), psiParams(2)))/sqrt(2),...
        [0,1,psiParams(3)]);

% simulated parameters
simulatedPsiParams = [-3.9 2.7 .01];
stimParams = linspace(1,5,15)';

N = 1;
psiParamsFit = nan(N,length(simulatedPsiParams));
for i=1:N
    questData = qpRun(numberOfTrials, ...
        'stimParamsDomainList',{stimParams stimParams}, ...
        'psiParamsDomainList',{-(0:.2:4.8), 1:.5:5, 0:.01:0.02}, ...
        'qpPF',myFun, ...
        'filterStimParamsDomainFun',@qpPairwiseStimCheck, ...
        'qpOutcomeF',@(x) qpSimulatedObserver(x,myFun,simulatedPsiParams), ...
        'nOutcomes', 2, ...
        'verbose',true);


    psiParamsIndex = qpListMaxArg(questData.posterior);
    psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
    fprintf('Simulated parameters: %0.1f, %0.1f, %0.2f\n', ...
        simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3));
    fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.2f\n', ...
        psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3));

    % Maximum likelihood fit.  Use psiParams from QUEST+ as the starting
    % parameter for the search, and impose as parameter bounds the range
    % provided to QUEST+.
    psiParamsFit(i,:) = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,...
        questData.nOutcomes,'lowerBounds', [-5 0.5 0],'upperBounds',[0 10 0.03]);
    fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.2f\n', ...
        psiParamsFit(i,1),psiParamsFit(i,2),psiParamsFit(i,3));

end

figure;
yyaxis left
histogram(psiParamsFit(:,1)); hold on;
plot(simulatedPsiParams(1)*[1 1],[0 40],'--k','linewidth',2);
title('threshold')
set(gca,'fontsize',14);
yyaxis right
histogram(psiParamsFit(:,2));hold on;
plot(simulatedPsiParams(2)*[1 1],[0 50],'--k','linewidth',2);
title('slope')
set(gca,'fontsize',14);

% % plot results
% figure; 
% plot(-stimParams,theta(stimParams,simulatedPsiParams(1),simulatedPsiParams(2)),'-o')

%%
figure; 
[x1,x2] = meshgrid(linspace(1,5,100)');
x = [x1(:) x2(:)];
y = myFun(x,simulatedPsiParams);

surf(-x1,-x2,reshape(y(:,2),size(x1,1),size(x1,2)),...
    'Edgecolor','none','facealpha',.5); hold on;
view(2);
xlabel('x1'); ylabel('x2'); zlabel('prop. correct')
set(gca,'fontsize',14);
colormap(repmat(linspace(0.5,1,100)',1,3));
grid off;

stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = zeros(length(stimCounts),questData.nStimParams);
for cc = 1:length(stimCounts)
    stim(cc,:) = stimCounts(cc).stim;
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter3(-stim(cc,1),-stim(cc,2),pCorrect(cc), 150,'o','MarkerEdgeColor',...
        [1-pCorrect(cc) 0 pCorrect(cc)],'MarkerFaceColor',[1-pCorrect(cc) 0 pCorrect(cc)],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end


axes('Position',[.7 .2 .2 .2]);
plot(-stimParams, ...
    theta(stimParams,...
    median(psiParamsFit(:,1)),median(psiParamsFit(:,2))),'-o')
xlabel('-(log-field rate)');
ylabel('JND');
set(gca,'fontsize',11);
grid on;


