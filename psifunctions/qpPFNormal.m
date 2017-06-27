% QpPFNormal[{x_}, {mean_, sd_, 
%    lapse_}] := {1 - #, #} &@(lapse + (1 - 2 lapse) CDF[
%       NormalDistribution[mean, sd], x])