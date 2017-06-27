% QpUpdate::usage = 
%   "QpUpdate[structure_,outcome_]\nUsing the outcome from the previous \
% trial, update the QUEST+ data structure. The function updates the \
% elements data and posterior.";
% 
% QpUpdate[structure_, outcome_] := 
%  ReplacePart[
%   structure, {1 -> Append[structure[[1]], {structure[[5]], outcome}], 
%    2 -> structure[[3]][[outcome, Sequence @@ structure[[4]]]]}]