function stimContrast = qpPFWeibullLogInv(proportionCorrect,psiParams)
%qpPFWeibullLogInv  Inverse Weibull cdf psychometric function 
%
% Usage:
%     stimContrast  = qpPFWeibullLogInv(proportionCorrect,psiParams)
%
% Description:
%     Compute the stimulus proportions that lead to the desired proportion
%     correct.
%
%     Note that this version works in log units, log10(x)
%     where x is the stimulus value.  Use qpPFWeibullInv for units of dB, and
%     qpPFStandardWeibullInv for linear units.
%
% Input:
%     proportionCorrect Column vector, with each row being a proportion correct. 
%
%     psiParams      Row vector or matrix of parameters
%                      threshold  Threshold parameter in log units
%                      slope      Slope
%                      guess      Guess rate
%                      lapse      Lapse rate
%                    Parameterization matches the Mathematica code from the
%                    Watson QUEST+ paper. If this is passed as a matrix,
%                    must have same number of rows as proportionCorrect and the
%                    parameters are used from corresponding rows. If it is
%                    passed as a row vector, that vector is taken as the
%                    parameters for each stimulus row.
%
% Output:
%     stimContrast   Vector of stimulus values in log10 units. Often the
%                    stimulus value is contrast.
%                           
% Optional key/value pairs
%     None
%
% See also: qpPFWeibull, qpPFWeibullInv, qpPFWeibullLog,  qpPFStandardWeibull.
%           qpPFStandardWeibullInv.

% 12/13/21  dhb  Wrote it.

%% Here is the Matlab version
if (size(psiParams,2) ~= 4)
    error('Parameters vector has wrong length for qpPFWeibullInv');
end
if (size(proportionCorrect,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
threshold = psiParams(:,1);
slope = psiParams(:,2);
guess = psiParams(:,3);
lapse = psiParams(:,4);
nStim = size(proportionCorrect,1);
stimContrast = zeros(nStim,1);

%% Compute, handling the two calling cases.
if (length(threshold) > 1)
    if (length(threshold) ~= nStim )
        error('Number of parameter vectors passed is not one and does not match number of stimuli passed');
    end
    
    for ii = 1:nStim 
        p1 = 1-proportionCorrect(ii);
        stimContrast(ii) = (log10(-log(-(p1-lapse(ii))/(guess(ii)+lapse(ii)-1))))/slope(ii) + threshold(ii);
    end
else
    for ii = 1:nStim
        % This is the forward calculation from qpPFWeibull:
        %   p1 = lapse - (guess + lapse - 1)*exp(-10^(slope*(stimParams(ii) - threshold)/20));
        % A little algebra inverts it. p1 is proportion incorrect.
        p1 = 1-proportionCorrect(ii);
        stimContrast(ii) = (log10(-log(-(p1-lapse)/(guess+lapse-1))))/slope + threshold;
    end 
end
