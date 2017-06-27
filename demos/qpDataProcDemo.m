function qpDataProcDemo
%qpDataProcDemo  Demonstrate and basic QuestPlus routines
%
% Description:
%    This script shows the usage for the qp data processing routines, and checks
%    some basic assertions about what they should do.
%
%    These do their best to follow the examples in the QuestPlus.nb
%    Mathematica notebook.

% 6/24/17  dhb  Created.

%% Get example results
fprintf('*** qpExampleData:\n');
exampleResult = qpExampleData;
qpPrintParams(exampleResult.paramEstimates);
qpPrintTrialData(exampleResult.trialData);

fprintf('\n*** qpData:\n');
stimData = qpData([exampleResult.trialData(:)]);
qpPrintStimData(stimData);

fprintf('\n*** qpCounts:\n');
stimCounts = qpCounts(stimData,exampleResult.nOutcomes);
qpPrintStimCounts(stimCounts);

fprintf('\n*** qpProportions:\n');
stimProortions = qpProportions(stimCounts,exampleResult.nOutcomes);
qpPrintStimProportions(stimProortions);

fprintf('\n*** qpLogLikelihood:\n');
logLikelihood = qpLogLikelihood(stimCounts,@qpPFWeibull,[-20, 3, 0.5, 0.02])


%% An example with multiple stimulus parameters
fprintf('\n*** qpExampleData (multiple stim params):\n');
exampleResult = qpExampleData('multipleStimParams',true);
qpPrintParams(exampleResult.paramEstimates);
qpPrintTrialData(exampleResult.trialData);

fprintf('\n*** qpData (multiple stim params):\n');
stimData = qpData([exampleResult.trialData(:)]);
qpPrintStimData(stimData);

fprintf('\n*** qpCounts (multiple stim params):\n');
stimCounts = qpCounts(stimData,exampleResult.nOutcomes);
qpPrintStimCounts(stimCounts);

fprintf('\n*** qpProportions (multiple stim params):\n');
stimProortions = qpProportions(stimCounts,exampleResult.nOutcomes);
qpPrintStimProportions(stimProortions);
