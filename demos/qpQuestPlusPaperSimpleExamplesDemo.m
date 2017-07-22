function qpQuestPaperSimpleExamplesDemo
%qpQuestPlusPaperSimpleExamplesDemo  Demonstrate/test QUEST+ on some simple example problems
%
% Description:
%    This script shows the usage for QUEST+ for some basic applications.
%   
%    It also shows the default output of qpInitialize, which can
%    be useful for understanding the questData structure in this
%    implementation.
%
%    It then uses qpRun and qpFIt to produce figures that reprises Figures
%    2, 3 and 4 of the Watson (2017) QUEST+ paper.  Note that qpRun itself
%    has the primary purpose of demonstrating how to integrate QUEST+ into
%    an experimental program.  Don't panic: qpRun is very short.

% 07/01/17  dhb  Created.
% 07/02/17  dhb  Added additional examples.
% 07/04/17  dhb  Add qpFit.

%% Close out stray figures
close all;

%% qpInitialize
fprintf('*** qpInitialize:\n');
questData = qpInitialize

%% qpRun with its defaults
%
% This runs a test of estimating a Weibull threshold using
% TAFC trials.
fprintf('*** qpRun, Weibull estimate threshold:\n');
rng('default'); rng(2002,'twister');
simulatedPsiParams = [-20, 3.5, .5, .02];
questData = qpRun(32, ...
    'psiParamsDomainList',{-40:0, 3.5, 0.5, 0.02}, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,simulatedPsiParams), ...
    'verbose',false);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Simulated parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3),simulatedPsiParams(4));
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3),psiParamsQuest(4));

% Maximum likelihood fit.  Use psiParams from QUEST+ as the starting
% parameter for the search, and impose as parameter bounds the range
% provided to QUEST+.  You could also relax the bounds on slope and lapse,
% but if you did it would make more sense to let QUEST+ place trials to
% lock those down well.
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [-40 3.5 0.5 0.02],'upperBounds',[0 3.5 0.5 0.02]);
fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParamsFit(1),psiParamsFit(2),psiParamsFit(3),psiParamsFit(4));
psiParamsCheck = [-188163  35000 5000 200];
assert(all(psiParamsCheck == round(10000*psiParamsFit)),'No longer get same ML estimate for this case');
    
% Plot with maximum likelhood fit
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
plot(stimFine,plotProportionsFit(:,2),'-','Color',[1 0.2 0.0],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion Correct');
xlim([-40 00]); ylim([0 1]);
title({'Estimate Weibull threshold', ''});
drawnow;

%% qpRun estimating three parameters of a Weibull
%
% This runs a test of estimating a Weibull threshold, slope
% and lapse using TAFC trials.
fprintf('\n*** qpRun, Weibull estimate threshold, slope and lapse:\n');
rng('default'); rng(2004,'twister');
simulatedPsiParams = [-20, 3, .5, .02];
questData = qpRun(64, ...
    'psiParamsDomainList',{-40:0, 2:5, 0.5, 0:0.01:0.04}, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,simulatedPsiParams), ...
    'verbose',false);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Simulated parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3),simulatedPsiParams(4));
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3),psiParamsQuest(4));

% Maximum likelihood fit.  Use psiParams from QUEST+ as the starting
% parameter for the search, and impose as parameter bounds the range
% provided to QUEST+.
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [-40 2 0.5 0],'upperBounds',[0 5 0.5 0.04]);
fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParamsFit(1),psiParamsFit(2),psiParamsFit(3),psiParamsFit(4));
psiParamsCheck = [-197856 20000 5000 0];
assert(all(psiParamsCheck == round(10000*psiParamsFit)),'No longer get same ML estimate for this case');

% Plot with maximum likelihood fit
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

%% qpRun estimating normal mean and standard deviation
%
% This runs a test of estimating a Weibull threshold using
% y/n trials.
fprintf('\n*** qpRun, Normal estimate mean, sd and lapse:\n');
rng('default'); rng(2008,'twister');
simulatedPsiParams = [1, 3, .02];
questData = qpRun(128, ...
    'stimParamsDomainList',{-10:10}, ...
    'psiParamsDomainList',{-5:5, 1:10, 0.00:0.01:0.04}, ...
    'qpPF',@qpPFNormal, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFNormal,simulatedPsiParams), ...
    'nOutcomes', 2, ...
    'verbose',false);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Simulated parameters: %0.1f, %0.1f, %0.2f\n', ...
    simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3));
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.2f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3));
    
% Maximum likelihood fit.  Use psiParams from QUEST+ as the starting
% parameter for the search, and impose as parameter bounds the range
% provided to QUEST+.
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [-5 1 0],'upperBounds',[5 10 0.04]);
fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.2f\n', ...
    psiParamsFit(1),psiParamsFit(2),psiParamsFit(3));
psiParamsCheck = [13318 27742 0];
assert(all(psiParamsCheck == round(10000*psiParamsFit)),'No longer get same ML estimate for this case');

% Plot with maximum likelihood fit
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = [stimCounts.stim];
stimFine = linspace(-10,10,100)';
plotProportionsFit = qpPFNormal(stimFine,psiParamsFit);
for cc = 1:length(stimCounts)
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end
plot(stimFine,plotProportionsFit(:,2),'-','Color',[1 0.2 0.0],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion Correct');
xlim([-10 10]); ylim([0 1]);
title({'Estimate Normal mean, sd and lapse', ''});
drawnow;



