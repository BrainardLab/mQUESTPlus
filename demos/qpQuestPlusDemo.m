function qpQuestPlusDemo
%qpQuestPlusDemo  Demonstrate QUEST+ and closely related.
%
% Description:
%    This script shows the usage for QUEST+.

% 07/01/17  dhb  Created.

%% qpInitialize
fprintf('*** qpInitialize:\n');
questData = qpInitialize

%% qpQuestPlus with its defaults
% This runs a test of estimating a Weibull threshold using
% TAFC trials.
fprintf('*** qpQuestPlus, Weibull estimate threshold:\n');
rng(2002);
questData = qpQuestPlus(32);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.1f %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3),psiParams(4));

%% qpQuestPlus estimating three parameters of a Weibull
% This runs a test of estimating a Weibull threshold, slope
% and lapse using TAFC trials.
fprintf('\n*** qpQuestPlus, Weibull estimate threshold, slope & lapse:\n');
rng(2004);
questData = qpQuestPlus(128, ...
    'psiParamsDomainList',{-40:0, 2:5, 0.5, 0:0.01:0.04}, ...
    'qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,[-20, 3, .5, .02]));
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.1f %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3),psiParams(4));



