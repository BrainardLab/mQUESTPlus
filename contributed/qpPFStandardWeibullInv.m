function stimVal = qpPFStandardWeibullInv(proportionCorrect,psiParams)
%qpPFStandardWeibullInv  Inverse Weibull cdf psychometric function 
%
% Usage:
%     stimVal  = qpPFStandardWeibullInv(proportionCorrect,psiParams)
%
% Description:
%     Compute the stimulus values that lead to the desired proportion
%     correct. 
%
% Note:
%     This function doesn't use dB units for stimulus nor for
%     threshold.
%
% Input:
%     proportionCorrect Column vector, with each row being a proportion correct..
%                    Here the row vector is just a single number giving
%                    the stimulus level.  
%
%     psiParams      Row vector or matrix of parameters
%                      threshold  Threshold 
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
%     stimVal   Vector of stimulus values
%                           
% Optional key/value pairs
%     None
%
% See also: qpPFStandardWeibull

% 4/1/19   aer  Wrote it.

%% Here is the Matlab version
if (size(psiParams,2) ~= 4)
    error('Parameters vector has wrong length for qpPFStandardWeibullInv');
end
if (size(proportionCorrect,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
threshold = psiParams(:,1);
slope = psiParams(:,2);
guess = psiParams(:,3);
lapse = psiParams(:,4);
nStim = size(proportionCorrect,1);
stimVal = zeros(nStim,1);

%% Compute, handling the two calling cases.
if (length(threshold) > 1)
    if (length(threshold) ~= nStim )
        error('Number of parameter vectors passed is not one and does not match number of stimuli passed');
    end
    
    for ii = 1:nStim 
        p1 = 1-proportionCorrect(ii);
        stimVal(ii) = threshold(ii)*(log((1-lapse(ii)-guess(ii))/(p1-lapse(ii))))^(1/slope(ii));
    end
else
    for ii = 1:nStim
        % This is the forward calculation from qpPFStandardWeibull:
        p1 = 1-proportionCorrect(ii);
        stimVal(ii) = threshold*(log((1-lapse-guess)/(p1-lapse)))^(1/slope);
    end 
end