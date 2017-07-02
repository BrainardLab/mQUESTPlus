

% QpQuery::usage = 
%   "QpQuery[structure_]\nQuery the QUEST+ data structure. The function \
% updates the elements posteriors, nextindex, and xnext. The last is \
% the vector of stimulus parameters that may be used to conduct the \
% next trial. It returns the updated structure.";
% 
% QpQuery[structure_] := Block[
%   {data, depth, likelihood, likexprior, probability, posteriors, 
%    entropies, nextindex, xnext, posterior, options, xsamples, 
%    optionslist},
%   {data, posterior, posteriors, nextindex, xnext, depth, likelihood, 
%     optionslist} = structure;
%   {xsamples} = {QpXSamples} /. optionslist /. Options[QuestPlus];
%   likexprior = Map[(# posterior) & , likelihood, {depth}];
%   likexprior = Developer`ToPackedArray[likexprior];
%   probability = Map[Total[#, Infinity] & , likexprior, {depth}];
%   posteriors = Map[UnitizeArray , likexprior, {depth}]  ;
%   entropies = Total[MapThread[
%      (ArrayEntropy[#1] #2) &, {posteriors, probability}, depth]];
%   nextindex = ListArgMin[entropies];
%   xnext = MapThread[#1[[#2]] &, {xsamples, nextindex}];
%   {data, posterior, posteriors, nextindex, xnext, depth, likelihood, 
%    optionslist}]