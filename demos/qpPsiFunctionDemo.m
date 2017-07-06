function qpPsiFunctionDemo
%qpPsiFunctionDemo  Demonstrate/test the psychometric function routines
%
% Description:
%    This script shows the usage for the qp psychometric function routines, and checks
%    some basic assertions about what they should do.
%
%    These do their best to follow the examples in the QuestPlus.nb
%    Mathematica notebook.

% 6/27/17  dhb  Created.

%% Weibull PF
fprintf('*** qpPFWeibull:\n');
stimParams = linspace(-9,9,100)';
outcomeProportions = qpPFWeibull(stimParams,[0 3 0.5 0.01]);
figure; clf; hold on
plot(stimParams,outcomeProportions(:,1),'-','Color',[0.8 0.6 0.0],'LineWidth',3);
plot(stimParams,outcomeProportions(:,2),'-','Color',[0.0 0.0 0.8],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion');
xlim([-10 10]); ylim([0 1]);
title({'qpPFWeibull' ; ''});
legend({'Outcome 1','Outcome 2'},'Location','NorthWest');

%% Normal PF
fprintf('*** qpPFNormal:\n');
stimParams = linspace(-9,9,100)';
outcomeProportions = qpPFNormal(stimParams,[0 3 0.01]);
figure; clf; hold on
plot(stimParams,outcomeProportions(:,1),'-','Color',[0.8 0.6 0.0],'LineWidth',3);
plot(stimParams,outcomeProportions(:,2),'-','Color',[0.0 0.0 0.8],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion');
xlim([-10 10]); ylim([0 1]);
title({'qpPFNormal' ; ''});
legend({'Outcome 1','Outcome 2'},'Location','NorthWest');

%% Simulate Weibull PF
fprintf('*** qpSimulatedObserver:\n');

% Stimulus parameters and number simulated trials
stimParams = linspace(-9,9,20)';
nTrialsPerStim = 10;

% Set up function to pass to SimulatedObserver
nOutcomes = 2;
qpObserverFunction = @(x) (qpSimulatedObserver(x,@qpPFWeibull,[0, 3, 0, .01]));

% Simulate each trial and build up trial data structure.
%
% Need to transpose structure because of Matlab defaults for vectors
theTrial = 1;
for tt = 1:length(stimParams);
    for jj = 1:nTrialsPerStim
        trialData(theTrial).stim = stimParams(tt);
        trialData(theTrial).outcome = qpObserverFunction(stimParams(tt));
        theTrial = theTrial + 1;
    end
end
trialData = trialData';

% Process to get proportions of each outcome for each stimulus value and
% then pull out second outcome, as that corresponds to correct
stimProportions = qpProportions(qpCounts(qpData(trialData),nOutcomes),nOutcomes);
for ss = 1:length(stimProportions)
    stim(ss) = stimProportions(ss).stim;
    proportionCorrect(ss) = stimProportions(ss).outcomeProportions(2);
end

% Plot
figure; clf; hold on
plot(stim,proportionCorrect,'o','Color',[0.0 0.0 0.8],'MarkerFaceColor',[0.0 0.0 0.8],'MarkerSize',10);
xlabel('Stimulus Value');
ylabel('Proportion Correct');
xlim([-10 10]); ylim([0 1]);
title({'qpPFWeibull' ; ''});

%% Weibull with multiple parameter rows
fprintf('*** qpPFWeibull and qpPFNormal with multiple parameter rows:\n');
stimParams = linspace(-9,9,2)';
outcomeProportions = qpPFWeibull(stimParams,[-9 3 0.5 0.01 ; 9 3 0.5 0.01]);
assert(outcomeProportions(1,1) == outcomeProportions(2,1),'Problem with multiple parameter rows in qpPFWeibull');
outcomeProportions = qpPFNormal(stimParams,[-9 3 0.01 ; 9 3 0.01]);
assert(outcomeProportions(1,1) == outcomeProportions(2,1),'Problem with multiple parameter rows in qpPFNormal');

