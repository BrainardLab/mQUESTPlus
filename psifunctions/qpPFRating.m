% QpPFRating::usage = 
%   "QpPFRating[{x_},s_]\nPschometric function for a rating experiment. \
% There is one stimulus dimension, and a number of parameters equal to \
% the number of outcomes. The argument s is a list of parameters \
% consisting of the standard deviation followed by the \!\(\*
% StyleBox[\"differences\",\nFontSlant->\"Italic\"]\) between several \
% criteria.";
% 
% QpPFRating[{x_}, s_] := Block[{vals, crit},
%   crit = Accumulate[Rest[s]];
%   vals = Chop[CDF[NormalDistribution[#, First[s]], x] & /@ crit];
%   vals = Append[-Differences[vals], Last[vals]];
%   Prepend[vals, 1. - Total[vals]]
%   ]