% sensoryscale[x_, {max_, threshold_, power_}] := 
%  max (Max[0, x - threshold]/(1 - threshold))^power