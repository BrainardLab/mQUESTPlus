function qpQuestPlusCSFDemo
%qpQuestPlusCSFDemo  Demonstrate QUEST+ at work on parametric CSF estimation.
%
% Description:
%    This script shows QUEST+ employed to estimate parametric spatial and
%    temporal CSFs.
%
%    Reprises Figure 6 of the paper.

% 07/03/17  dhb  Created.

%% Close out stray figures
close all;

%% qpRun estimating spatial CSF
%
% This uses the more general qpPFSTCSF, but the temporal frequency
% and its parameter are locked to zero in all places where they come up.
%
% This reprises Figure 6 of the 2017 QUEST+ paper.
fprintf('*** qpRun, Estimate parametric spatial CSF:\n');
rng(3008);
simulatedPsiParams = [-35, -50, 1.2 0];
questData = qpRun(128, ...
    'stimParamsDomainList',{0:2:40, 0, -50:2:0}, ...
    'psiParamsDomainList',{-50:2:-30, -60:2:-40, 0.8:0.2:1.6 0}, ...
    'qpPF',@qpPFSTCSF, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFSTCSF,simulatedPsiParams), ...
    'nOutcomes', 2, ...
    'verbose',true);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Simulated parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3),simulatedPsiParams(4));
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3),psiParamsQuest(4));
psiParamsCheck = [-360000 -500000 12000 0];
assert(all(psiParamsCheck == round(10000*psiParamsQuest)),'No longer get same QUEST+ estimate for this case');

% Maximum likelihood fit.  Use psiParams from QUEST+ as the starting
% parameter for the search, and impose as parameter bounds the range
% provided to QUEST+.
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [-50 -60 0.8 0],'upperBounds',[-30 -40 1.6 0]);
fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    psiParamsFit(1),psiParamsFit(2),psiParamsFit(3),psiParamsFit(4));
psiParamsCheck = [-359123 -485262 11325 0];
assert(all(psiParamsCheck == round(10000*psiParamsFit)),'No longer get same ML estimate for this case');
 
% Plot trial locations together with maximum likelihood fit.
%
% Point transparancy visualizes number of trials (more opaque -> more
% trials), while point color visualizes percent correct (more blue -> more
% correct).
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = zeros(length(stimCounts),questData.nStimParams);
for cc = 1:length(stimCounts)
    stim(cc,:) = stimCounts(cc).stim;
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc,1),stim(cc,3),100,'o','MarkerEdgeColor',[1-pCorrect(cc) 0 pCorrect(cc)],'MarkerFaceColor',[1-pCorrect(cc) 0 pCorrect(cc)],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end
plotSfs = (0:2:40)';
[~,plotFitThresholds] = qpPFSTCSF(...
    [plotSfs zeros(size(plotSfs)) zeros(size(plotSfs))], ...
    psiParamsFit);
plot(plotSfs,plotFitThresholds,'-','Color',[1 0.2 0.0],'LineWidth',3);
xlabel('Spatial Frequency (c/deg)');
ylabel('Contrast (dB)');
xlim([0 40]); ylim([-50 0]);
title({'Estimate spatial CSF', ''});
drawnow;

