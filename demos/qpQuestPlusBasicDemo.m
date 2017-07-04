function qpQuestPlusBasicDemo
%qpQuestPlusBasicDemo  Demonstrate QUEST+ and closely related.
%
% Description:
%    This script shows the usage for QUEST+ for some basic applications.
%   
%    In particular, it shows the default output of qpInitialize, which can
%    be useful for understanding the questData structure in this
%    implementation.
%
%    It then uses qpRun to produce figures that reprises Figures 2, 3
%    and 4 of the Watson (2017) QUEST+ paper.  Note that qpRun itself
%    has the primary purpose of demonstrating how to integrate QUEST+ into
%    an experimental program.  It is very short.

% 07/01/17  dhb  Created.
% 07/02/17  dhb  Added additional examples.

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
rng(2002);
questData = qpRun(32, ...
    'psiParamsDomainList',{-40:0, 3.5, 0.5, 0.02}, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,[-20, 3.5, .5, .02]), ...
    'verbose',false);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3),psiParams(4));

% Plot with fit from quest
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = [stimCounts.stim];
stimFine = linspace(-40,0,100)';
fitProportions = qpPFWeibull(stimFine,psiParams);
for cc = 1:length(stimCounts)
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end
plot(stimFine,fitProportions(:,2),'-','Color',[1 0.2 0.0],'LineWidth',3);
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
rng(2004);
questData = qpRun(64, ...
    'psiParamsDomainList',{-40:0, 2:5, 0.5, 0:0.01:0.04}, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,[-20, 3, .5, .02]), ...
    'verbose',false);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3),psiParams(4));

% Plot with fit from quest
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = [stimCounts.stim];
stimFine = linspace(-40,0,100)';
fitProportions = qpPFWeibull(stimFine,psiParams);
for cc = 1:length(stimCounts)
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end
plot(stimFine,fitProportions(:,2),'-','Color',[1 0.2 0.0],'LineWidth',3);
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
rng(2008);
questData = qpRun(128, ...
    'stimParamsDomainList',{-10:10}, ...
    'psiParamsDomainList',{-5:5, 1:10, 0.00:0.01:0.04}, ...
    'qpPF',@qpPFNormal, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFNormal,[1, 3, .02]), ...
    'nOutcomes', 2, ...
    'verbose',false);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3));

% Plot with fit from quest
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = [stimCounts.stim];
stimFine = linspace(-10,10,100)';
fitProportions = qpPFNormal(stimFine,psiParams);
for cc = 1:length(stimCounts)
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end
plot(stimFine,fitProportions(:,2),'-','Color',[1 0.2 0.0],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion Correct');
xlim([-10 10]); ylim([0 1]);
title({'Estimate Normal mean, sd and lapse', ''});
drawnow;



