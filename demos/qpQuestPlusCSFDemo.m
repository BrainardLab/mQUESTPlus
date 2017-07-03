function qpQuestPlusCSFDemo
%qpQuestPlusCSFDemo  Demonstrate QUEST+ at work on parametric CSF estimation.
%
% Description:
%    This script shows QUEST+ employed to estimate parametric spatial and
%    temporal CSFs.  Follows the examples in the Watson (2017) QUEST+
%    paper.

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
simulatedCSFParams = [-35, -50, 1.2 0];
questData = qpRun(128, ...
    'stimParamsDomainList',{0:2:40, 0, -50:2:0}, ...
    'psiParamsDomainList',{-30:-2:-50, -40:-2:-60, 0.8:0.2:1.6 0}, ...
    'qpPF',@qpPFSTCSF, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFSTCSF,simulatedCSFParams), ...
    'nOutcomes', 2, ...
    'verbose',true);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3));
 
% Plot trial locations together with fit from quest.
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
    psiParams);
plot(plotSfs,plotFitThresholds,'-','Color',[1 0.2 0.0],'LineWidth',3);
xlabel('Spatial Frequency (c/deg)');
ylabel('Contrast (dB)');
xlim([0 40]); ylim([-50 0]);
title({'Estimate spatial CSF', ''});
drawnow;

