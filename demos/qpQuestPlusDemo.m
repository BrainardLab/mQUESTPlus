function qpQuestPlusDemo
%qpQuestPlusDemo  Demonstrate and basic QuestPlus routines
%
% Description:
%    This script shows the usage for the qp quest plus routines, and checks
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

%% An example with multiple stimulus parameters
fprintf('\n*** qpExampleData (multiple stim params):\n');
exampleResult = qpExampleData('multipleStimParams',true);
qpPrintParams(exampleResult.paramEstimates);
qpPrintTrialData(exampleResult.trialData);

fprintf('\n*** qpData (multiple stim params):\n');
stimData = qpData([exampleResult.trialData(:)]);
qpPrintStimData(stimData);
