% QpPFCircular::usage = 
%   "QpPFCircular[{x_},s_]\nPsychometric function for circular \
% categorization, based on a von Mises distribution. The argument x is \
% the stimulus parameter, which must be between 0 and 2 Pi. The \
% argument s is a list of parameters of the form {concentration, first, \
% width1, width2, ...widthn}, where first is the first criterion and \
% the widths are the widths of the successive categories. The number of \
% categories is the number of widths plus 1 (alternatively, the length \
% of s minus 1).";
% 
% QpPFCircular[{x_}, s_] :=  
%  Block[{concentration, crit, first, widths, tmp},
%   concentration = First[s];
%   first = s[[2]];
%   widths = Drop[s, 2];
%   crit = first + Accumulate[Prepend[widths, 0]];
%   crit = Transpose[{crit, RotateLeft[crit]}];
%   tmp = CDFVonMises[#, {x, concentration}] & /@ Most[crit];
%   Append[tmp, 1 - Total[tmp]]
%   ]