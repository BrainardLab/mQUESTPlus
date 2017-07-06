function qpDataProcDemo
% qpDataProcDemo  Demonstrate/test the data processsing routines.
%
% Description:
%    This script shows the usage for the qp data processing routines, and checks
%    some basic assertions about what they should do.  Key routines
%    demonstrated and tested are:
%      qpData
%      qpCounts
%      qpProportions
%
%    These make use of qpExampleData, which returns example datasets.
%
%    These demos/tests do their best to follow the examples in the QuestPlus.nb
%    Mathematica notebook that accompanies the Watson (2017) paper.  But, I
%    got a more recent version than that published with the paper, so there
%    will be some minor differences.

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
logLikelihood = qpLogLikelihood(stimCounts,@qpPFWeibull,[-20, 3, 0.5, 0.02]);
logLikelihood = round(logLikelihood*100000)/100000
assert(logLikelihood == -9.15883,'qpLogLikelihood: Did not get expected log likelihood');

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
