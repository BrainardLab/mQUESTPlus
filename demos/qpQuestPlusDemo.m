function qpQuestPlusDemo
%qpQuestPlusDemo  Demonstrate QUEST+ and closely related.
%
% Description:
%    This script shows the usage for QUEST+.

% 07/01/17  dhb  Created.

%% qpInitialize
fprintf('*** qpInitialize:\n');
questData = qpInitialize

%% qpQuestPlus
fprintf('*** qpQuestPlus:\n');
rng(2002);
questData = qpQuestPlus(32);
psiParamsIndex = qpListMaxArg(questData.posterior);
psiParams = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior parameters: %0.1f, %0.1f, %0.1f %0.2f\n', ...
    psiParams(1),psiParams(2),psiParams(3),psiParams(4));



