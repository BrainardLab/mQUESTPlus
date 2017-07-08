function qpQuestPlusCircularCatDemo
%qpQuestPlusCircularCatDemo  Demonstrate/test QUEST+ at work on categorization of a circular variable.
%
% Description:
%    This script shows QUEST+ employed to estimate categorization
%    boundaries and precision on a circular variable.
%
%    This reprises Figure 16 of the paper, but uses a different
%    parameterization.  Rather than the first criterion and widths of
%    subsequent criteria, the psychometric function used here
%    (qpPFCircular) takes a list of the criterion locations. These must be
%    in increasing order, which is not possible to express using a grid.
%    The way this is handled is that the underlying qpPFCircular
%    psychometric function returns a vector of NaN when the parameters are
%    not in increasing order.  As described in qpInitialize, such a return
%    is taken there to indicate invalid parameters, and the psiParamsDomain
%    is filtered to remove any such parameter values. This differs from the
%    Mathematica implementation.
%
%    Routine qpFit also handles the NaN return from pychometric functions.
%
%    There would be approaches to writing the psychometric function that did not
%    require the use of NaNs, but these would have been a little more complicated
%    and I didn't think of them until after I finished this example.
%
%    Reprises Figure 16 of the paper, although it differs in detail because
%    I didn't get as fancy about the plot, because of the different
%    parameterization, because of a different choice of parameters and
%    number of trials, and because of the filtering method above invoked in
%    the underlying routine.

% 07/07/17  dhb  Created.

%% Close out stray figures
close all;

%% qpRun estimating circular categorization parameters.
%
% This code parameterizes the boundaries as boundaries, rather
% than first boundary and widths as in Mathematica code.
%
% This reprises Figure 16 of the 2017 QUEST+ paper.
fprintf('*** qpRun, Estimate circular categorization parameters:\n');
rng(3010);
simulatedPsiParams = [4, 2*pi/3 4*pi/3-0.5 2*pi-pi/8];
questData = qpRun(200, ...
    'stimParamsDomainList',{0:pi/9:2*pi}, ...
    'psiParamsDomainList',{1:8, 0:pi/9:2*pi 0:pi/9:2*pi 0:pi/9:2*pi}, ...
    'qpPF',@qpPFCircular, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFCircular,simulatedPsiParams), ...
    'nOutcomes', 3, ...
    'verbose',true);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Simulated parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3),simulatedPsiParams(4));
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3),psiParamsQuest(4));
psiParamsCheck = [30000 20944 38397 59341];
assert(all(psiParamsCheck == round(10000*psiParamsQuest)),'No longer get same QUEST+ estimate for this case');

% Maximum likelihood fit.  Use psiParams from QUEST+ as the starting
% parameter for the search, and impose as parameter bounds the range
% provided to QUEST+.
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [-1 0 4*pi/3 2*pi],'upperBounds',[8 2*pi 4*pi/3 2*pi]);
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [-1 0 0 0],'upperBounds',[8 2*pi 2*pi 2*pi]);
fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.1f, %0.1f\n', ...
    psiParamsFit(1),psiParamsFit(2),psiParamsFit(3),psiParamsFit(4));
psiParamsCheck = [38831 21951 37488 58822];
assert(all(psiParamsCheck == round(10000*psiParamsFit)),'No longer get same ML estimate for this case');
 
% Plot trial locations together with maximum likelihood fit.
%
% Point transparancy visualizes number of trials (more opaque -> more
% trials), while point color visualizes dominant response.  The proportion plotted
% for each angle is the proportion of the dominant response.  This isn't as fancy
% as the Mathematica plot showin in Figure 17 of the paper, but conveys the same
% general idea of what happened.
figure; clf; hold on
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
plotStimParams = linspace(0,2*pi,100)';
outcomeProportions = qpPFCircular(plotStimParams,psiParamsFit);
for jj = 2:length(psiParamsFit)
    plot([psiParamsFit(jj) psiParamsFit(jj)],[0 1],'k:');
end
plot(plotStimParams,outcomeProportions(:,1),'r','LineWidth',3);
plot(plotStimParams,outcomeProportions(:,2),'g','LineWidth',3);
plot(plotStimParams,outcomeProportions(:,3),'b','LineWidth',3);
xlim([0 2*pi]);
ylim([0 1]);
xlabel('Angle (rad)');
ylabel('Proportion');
title({'Categories on a Circle',''});
drawnow;

