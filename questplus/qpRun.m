% QpRun::usage = 
%   "QpRun[ntrials_,options___Rule]\nRun some trials of a QUEST+ \
% experiment. This version illustrates the use of functions \
% QpInitialize, QpQuery, and QpUpdate. It is an alternative to the \
% integrated function QuestPlus. It takes the same options as \
% QuestPlus.";
% 
% QpRun[ntrials_, options___Rule] := 
%  Block[{response, outcome, structure, psamples},
%   {response, psamples} = {QpOutcome, QpPSamples} /. {options} /. 
%     Options[QuestPlus];
%   structure = QpInitialize[options];
%   Do[(
%     structure = QpQuery[structure];
%     outcome = response[structure[[5]]];
%     structure = QpUpdate[structure, outcome];)
%    , {ntrials}];
%   {MapThread[#1[[#2]] &, {psamples, ListArgMax[structure[[2]]]}], 
%    structure[[1]]}]

