% QpNLogP[n_, p_] := 
%  If[p > 0, n Log[p], If[n > 0, -$MaxMachineNumber, 0]]