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
stimParams = linspace(-9,9,100)';
outcomeProportions = qpPFWeibull(stimParams,[0 3 0.5 0.01]);
figure; clf; hold on
plot(stimParams,outcomeProportions(:,1),'-','Color',[0.8 0.6 0.0],'LineWidth',3);
plot(stimParams,outcomeProportions(:,2),'-','Color',[0.0 0.0 0.8],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion');
xlim([-10 10]); ylim([0 1]);
title('qpPFWeibull');
legend({'Outcome 1','Outcome 2'},'Location','NorthWest');

fprintf('*** qpSimulatedObserver:\n');
qpObserverFunction = @(x) (qpSimulatedObserver(x,@qpPFWeibull,[0, 3, 0, .01]));
for tt = 1:length(stimParams);
    simulatedOutcomes(tt) = qpObserverFunction(stimParams(tt));
end
