function qpQuestPlusRatingDemo
%qpQuestPlusRatingDemo  Demonstrate/test QUEST+ at work on categorization variable.
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
% rng('default'); rng(3010,'twister');
simulatedPsiParams = [.6 2.3 4.7];
stimParams = linspace(0,8,20)';
questData = qpRun(64, ...
    'stimParamsDomainList',{stimParams}, ...
    'psiParamsDomainList',{0.2:0.2:2, 0:.25:6 0:.25:6}, ...
    'qpPF',@qpPFRating, ...
    'filterPsiParamsDomainFun',@qpPFRatingParamsCheck, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFRating,simulatedPsiParams), ...
    'nOutcomes', length(simulatedPsiParams), ...
    'verbose',true);

psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Simulated parameters: %0.1f, %0.1f, %0.1f\n', ...
    simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3));
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3));

% Maximum likelihood fit.  Use psiParams from QUEST+ as the starting
% parameter for the search, and impose as parameter bounds the range
% provided to QUEST+.
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [0 0 0],'upperBounds',[2 10 10]);
fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.1f\n', ...
    psiParamsFit(1),psiParamsFit(2),psiParamsFit(3));

% Plot trial locations together with maximum likelihood fit.
%
% Point transparancy visualizes number of trials (more opaque -> more
% trials), while point color visualizes dominant response.  The proportion plotted
% for each angle is the proportion of the dominant response.  This isn't as fancy
% as the Mathematica plot showin in Figure 17 of the paper, but conveys the same
% general idea of what happened.
figure; clf; hold on
set(gca,'Color',[1 1 1]*.9);
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stimProportions = qpProportions(stimCounts,questData.nOutcomes);
stim = zeros(length(stimCounts),questData.nStimParams);
for cc = 1:length(stimCounts)
    stim(cc,:) = stimCounts(cc).stim;
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
end
for cc = 1:length(stimCounts)
    for jj = 1:questData.nOutcomes
    switch (jj)
        case 1
            theColor = 'r';
        case 2
            theColor = 'g';
        case 3
            theColor = 'b';
        otherwise
            error('Oops');
    end
    h = scatter(stim(cc),stimProportions(cc).outcomeProportions(jj),100,'o','MarkerEdgeColor',theColor,'MarkerFaceColor',theColor,...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
    end
end
plotStimParams = linspace(0,max(stimParams),100)';
outcomeProportions = qpPFRating(plotStimParams,psiParamsFit);
for jj = 2:length(psiParamsFit)
    plot([psiParamsFit(jj) psiParamsFit(jj)],[0 1],'k:','linewidth',2);
end
cols = [240 133 125; 255 251 139; 149 246 136]/255;
for i=1:size(outcomeProportions,2)
    plot(plotStimParams,outcomeProportions(:,i),'-','Color',cols(i,:),'LineWidth',3);
end
ylim([0 1]);
xlabel('stim value');
ylabel('Proportion');
title({'Rating',''});
drawnow;

