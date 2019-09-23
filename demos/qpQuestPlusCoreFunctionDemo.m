function qpQuestPlusCoreFunctionDemo
%qpQuestPlusCoreFunctionDemo  Show basic use of QUEST+ core functions, called directly
%
% Description:
%    This script shows how to call qpInitialize, qpQuery, and qpUpdate
%    directly.
%
% Set parameters, using key value pairs to override defaults
% as needed.  (See "help qpParams" for what is available.)
%
% Here we set the range for the stimulus (contrast in dB) and the
% psychometric function parameters (see qpPFWeibull).
%
% Note that the space on which the stimulus is gridded affects the
% prior used by QUEST+.  QUEST+ assigns equal probability to each 
% listed stimulus, so that the prior implied if you grid contrast in
% dB is different from that if you grid contrast on a linear scale.
questData = qpInitialize('stimParamsDomainList',{[-40:1:0]}, ...
    'psiParamsDomainList',{-40:0, 2:5, 0.5, 0:0.01:0.04});

%% Set up simulated observer
%
% Parameters of the simulated Weibull
simulatedPsiParams = [-20, 3, .5, .02];

% Function handle that will take stimulus parameters x and simulate
% a trial according to the parameters above.
simulatedObserverFun = @(x) qpSimulatedObserver(x,@qpPFWeibull,simulatedPsiParams);

% Freeze random number generator so output is repeatable
rng('default'); rng(2004,'twister');

%% Run simulated trials, using QUEST+ to tell us what contrast to
nTrials = 64;
for tt = 1:nTrials
    % Get stimulus for this trial
    stim = qpQuery(questData);
    
    % Simulate outcome
    outcome = simulatedObserverFun(stim);
    
    % Update quest data structure
    questData = qpUpdate(questData,stim,outcome); 
end

%% Find out QUEST+'s estimate of the stimulus parameters, obtained
% on the gridded parameter domain.
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Simulated parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3),simulatedPsiParams(4));
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3),psiParamsQuest(4));

%% Find aximum likelihood fit.  Use psiParams from QUEST+ as the starting
% parameter for the search, and impose as parameter bounds the range
% provided to QUEST+.
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [-40 2 0.5 0],'upperBounds',[0 5 0.5 0.04]);
fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParamsFit(1),psiParamsFit(2),psiParamsFit(3),psiParamsFit(4));

% Little unit test that this routine still does what it used to.
psiParamsCheck = [-197856 20000 5000 0];
assert(all(psiParamsCheck == round(10000*psiParamsFit)),'No longer get same ML estimate for this case');

%% Plot of trial locations with maximum likelihood fit
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = [stimCounts.stim];
stimFine = linspace(-40,0,100)';
plotProportionsFit = qpPFWeibull(stimFine,psiParamsFit);
for cc = 1:length(stimCounts)
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end
plot(stimFine,plotProportionsFit(:,2),'-','Color',[1.0 0.2 0.0],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion Correct');
xlim([-40 00]); ylim([0 1]);
title({'Estimate Weibull threshold, slope, and lapse', ''});
drawnow;

