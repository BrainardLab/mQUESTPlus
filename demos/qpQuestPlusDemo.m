function qpUtilityDemo
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
exampleResult = qpExampleData

fprintf('*** qpData:\n');
stimulusDataArray = qpData([exampleResult.trialData(:)])
