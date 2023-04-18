% qpRunAllDemos  Run through all of the QUEST+ demos
%
% Description:
%     Script to run all of the demos.  Useful as a test that everthing
%     still works.

% 07/06/17   dhb  Wrote it

%% Here we go
qpUtilityDemo;
qpDataProcDemo;
qpPsiFunctionDemo;
qpQuestPlusCoreFunctionDemo;
qpQuestPlusPaperSimpleExamplesDemo
qpQuestPlusCSFDemo;
qpQuestPlusCircularCatDemo;
qpQuestPlusMarginalizeDemo;

%% Contributed demos
qpQuestPlusRatingDemo;
qpQuestPlusRatingDemo2;
qpPairwiseComparisonDemo;

%% Close up
close all;