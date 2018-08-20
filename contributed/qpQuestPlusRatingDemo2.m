function qpQuestPlusRatingDemo2
%qpQuestPlusRatingDemo2  Demonstrate/test QUEST+ at work on categorization variable.
%
% Description:
%    This script shows QUEST+ employed to estimate categorization
%    boundaries and precision on a categorical variable.
%

% 08/18/18  mna  wrote it.

%% Close out stray figures
close all;
clc;

%% qpRun estimating categorization parameters.
%
% This code parameterizes the boundaries as boundaries, rather
% than first boundary and widths as in Mathematica code.
%
% This reprises Figure 16 of the 2017 QUEST+ paper.
fprintf('*** qpRun, Estimate categorization parameters:\n');
rng('default'); rng(400,'twister');
simulatedPsiParams = [1.8 0.8 1.2 2.5];
stimParams = linspace(0,8,20)';
myFun = @(x,y) qpPFRating(sqrt((x(:,1)/y(1)).^2 + (x(:,2)).^2),y(2:end));
questData = qpRun(30, ...
    'stimParamsDomainList',{stimParams stimParams}, ...
    'psiParamsDomainList',{logspace(log10(.2),log10(10),10), 0.5:0.5:3,...
                           logspace(log10(.1),log10(10),10), ...
                           logspace(log10(.1),log10(10),10)}, ...
    'qpPF',myFun, ...
    'filterPsiParamsDomainFun',@qpPFRatingParamsCheck2, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,myFun,simulatedPsiParams), ...
    'nOutcomes', length(simulatedPsiParams)-1, ...
    'verbose',true);

psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Simulated parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3),...
    simulatedPsiParams(4));
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3),...
    psiParamsQuest(4));

% Maximum likelihood fit.  Use psiParams from QUEST+ as the starting
% parameter for the search, and impose as parameter bounds the range
% provided to QUEST+.
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [.01 0.01 0 0],'upperBounds',[5 3 5 5]);
fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    psiParamsFit(1),psiParamsFit(2),psiParamsFit(3),...
    psiParamsFit(4));

% Plot trial locations together with maximum likelihood fit.
%
% Point transparancy visualizes number of trials (more opaque -> more
% trials), while point color visualizes dominant response.  The proportion plotted
% for each angle is the proportion of the dominant response.  This isn't as fancy
% as the Mathematica plot showin in Figure 17 of the paper, but conveys the same
% general idea of what happened.
figure; clf; hold on
set(gca,'Color',[1 1 1]*.7);
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stimProportions = qpProportions(stimCounts,questData.nOutcomes);
stim = zeros(length(stimCounts),questData.nStimParams);
for cc = 1:length(stimCounts)
    stim(cc,:) = stimCounts(cc).stim;
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
end
cols = [240 133 125; 255 251 139; 149 246 136]/255;
for cc = 1:length(stimCounts)
    for jj = 1:questData.nOutcomes
    switch (jj)
        case 1
            dx = 0.05;
            dy = 0.05;
        case 2
            dx = -0.05;
            dy = 0.05;
        case 3
            dx = 0;
            dy = -0.05;
        otherwise
            error('Oops');
    end
    theColor = cols(jj,:);
    h = scatter3(stim(cc,1)+dx,stim(cc,2)+dy,stimProportions(cc).outcomeProportions(jj),100,...
        'o','MarkerEdgeColor',theColor,'MarkerFaceColor',theColor,...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
    end
end
view(2);
plotStimParams = linspace(0,max(stimParams),100)';
[x,y] = meshgrid(plotStimParams);
outcomeProportions = myFun([x(:) y(:)],psiParamsFit);
% for jj = 4:length(psiParamsFit)
%     tempParam = linspace(0,psiParamsFit(jj),100);
%     plot3(tempParam/psiParamsFit(1), sqrt(psiParamsFit(jj).^2-((tempParam/psiParamsFit(2)).^2)),...
%         ones(size(tempParam)),'k:','linewidth',2);
% end
for i=1:size(outcomeProportions,2)
    mesh(x,y,reshape(outcomeProportions(:,i),size(x,1),size(x,2)),...
        'EdgeColor',cols(i,:));
end
% for jj = 1:length(psiParamsFit)-1
%     tempParam = linspace(0,psiParamsFit(jj),100);
%     plot3(tempParam, sqrt(psiParamsFit(jj).^2-(tempParam.^2)),...
%             ones(size(tempParam)),'-','Color',cols(jj,:));
% end

xlabel('Stim. value 1');
ylabel('Stim. value 2');
zlabel('Proportion');
title({'Rating',''});
set(gca,'fontsize',14);
drawnow;
% axis equal

