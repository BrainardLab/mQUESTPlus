% QpPFWeibull[{x_}, {threshold_, slope_, guess_, lapse_}] := 
%  {#, 1 - #} &@(lapse - (guess + lapse - 1) Exp[- 
%        10^(slope (x - threshold)/20) ])