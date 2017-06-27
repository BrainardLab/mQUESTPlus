% QpLogLikelihood::usage = 
%   "QpLogLikelihood[data_,psi_,parameters_List]\nCompute the log \
% likelihood of a set of data, given a psychometric function and a set \
% of parameters. Data is a list of the form returned by QpCounts.";
% 
% QpLogLikelihood[counts_, psi_, parameters_List] := Block[{p},
%   p =  N[psi[#, parameters]] & /@ counts[[All, 1]];
%   Total[MapThread[QpNLogP, {counts[[All, 2]], p}, 2], Infinity]]