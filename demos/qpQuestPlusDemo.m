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
questData = qpQuestPlus(30)

fprintf('\n');

