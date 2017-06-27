% QpFit::usage = 
%   "QpFit[result_,options___Rule]\n Fits a psychometric function to a \
% set of data. The input is the structure returned by QuestPlus. It \
% responds to the QuestPlus options QpPSamples and QpPsi. The function \
% accepts any number of outcomes and of stimulus dimensions.";
% 
% QpFit[result_, options___Rule] := 
%  Block[{fit, names, psamples, constraints, psi, pbounds, counts, 
%    noutcomes},
%   {psamples, psi} = {QpPSamples, QpPsi} /. {options} /. 
%     Options[QuestPlus];
%   noutcomes = Max[result[[2, All, 2]]];
%   pbounds = MinMax /@ psamples;
%   counts = QpCounts[QpData[result[[2]]], noutcomes];
%   names = Symbol["QpTmp" <> ToString[#]] & /@ Range[Length[pbounds]];
%   constraints = 
%    MapThread[(#2[[1]] <= #1 <= #2[[2]]) &, {names, pbounds}];
%   fit = NMaximize[{QpLogLikelihoodNumeric[counts, psi, names], 
%      constraints}, names];
%   names /. fit[[2]]]