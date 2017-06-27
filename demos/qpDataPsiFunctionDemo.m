function qpDataProcDemo
%qpPsiFunctionDemo  Demonstrate the psychometric function routines
%
% Description:
%    This script shows the usage for the qp psychometric function routines, and checks
%    some basic assertions about what they should do.
%
%    These do their best to follow the examples in the QuestPlus.nb
%    Mathematica notebook.

% 6/27/17  dhb  Created.

%% Weibull
fprintf('*** qpWeibull:\n');
stimVals = linspace(-9,9,100)';
outcomeProportions = qpPFWeibull(stimVals,[0 3 0.5 0.01]);
figure; clf; hold on
plot(stimVals,outcomeProportions(:,1),'-','Color',[0.8 0.6 0.0],'LineWidth',3);
plot(stimVals,outcomeProportions(:,2),'-','Color',[0.0 0.0 0.8],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion');
xlim([-10 10]); ylim([0 1]);
title('qpPFWeibull');