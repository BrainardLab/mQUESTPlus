function predictedProportions = qpPFWeibull(stimParams,psiParams)
%qpPFWeibull  Weibull cdf psychometric function 
%
% Usage:
%     predictedProportions = qpPFWeibull(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for the Weibull psychometric
%     function.
%
%     See docuent qpPF_GuessLapseParameterization.pdf for a discussion of
%     various ways to parameterize the lapse rate and how to convert
%     between them.  In particular, that document describes the
%     parameterization used in this function.
% 
%     Note that this version works in stimulus units of dB (20*log10(x))
%     where x is the stimulus value.  Use qpPFWeibullLog for log units, and
%     qpPFStandardWeibull for linear units.
%
% Input:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here the row vector is just a single number giving
%                    the stimulus level in dB.  dB defined as
%                    20*log10(x).
%
%     psiParams      Row vector or matrix of parameters
%                      threshold  Threshold in dB
%                      slope      Slope
%                      guess      Guess rate
%                      lapse      Lapse rate
%                    Parameterization matches the Mathematica code from the
%                    Watson QUEST+ paper. If this is passed as a matrix,
%                    must have same number of rows as stimParams and the
%                    parameters are used from corresponding rows. If it is
%                    passed as a row vector, that vector is taken as the
%                    parameters for each stimulus row.
%
% Output:
%     predictedProportions  Matrix, where each row is a vector of predicted proportions
%                           for each outcome.
%                             First entry of each row is for no/incorrect (outcome == 1)
%                             Second entry of each row is for yes/correct (outcome == 2)
%
% Optional key/value pairs
%     None
%
% See also: qpPFWeibullInv, qpPFWeibullLog, qpPFWeibullLogInv, qpPFStandardWeibull.
%           qpPFStandardWeibullInv.

% 6/27/17  dhb  Wrote it.
% 07/21/18 dhb  Added note about qpPF_GuessLapseParameterization document
%               that I added to this directory.

% Examples:
%{
    stim = 20*0.5;
    params = [stim 2.2 0.5 0];
    predProportions = qpPFWeibull(stim,params);
    check = qpPFWeibullInv(predProportions(2),params);
    if (abs(check-stim) > 1e-10)
        error('PF does not invert properly');
    end
%}

%% Parse input
%
% This routine gets called many many times and should be as fast as
% possible.  The input parser is slow.  So we forego arg checking and
% optional key/value pairs.  The code below shows how they would look.
%
% p = inputParser;
% p.addRequired('stimParams',@isnumeric);
% p.addRequired('psiParams',@isnumeric);
% p.parse(stimParams,psiParams,varargin{:}); 

%% Here is the Matlab version
if (size(psiParams,2) ~= 4)
    error('Parameters vector has wrong length for qpPFWeibull');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
threshold = psiParams(:,1);
slope = psiParams(:,2);
guess = psiParams(:,3);
lapse = psiParams(:,4);
nStim = size(stimParams,1);
predictedProportions = zeros(nStim,2);

%% Compute, handling the two calling cases.
if (length(threshold) > 1)
    if (length(threshold) ~= nStim )
        error('Number of parameter vectors passed is not one and does not match number of stimuli passed');
    end
    
    for ii = 1:nStim 
        p1 = lapse(ii) - (guess(ii) + lapse(ii) - 1)*exp(-10^(slope(ii)*(stimParams(ii) - threshold(ii))/20));
        predictedProportions(ii,:) = [p1 1-p1];
    end 
else
    for ii = 1:nStim
        p1 = lapse - (guess + lapse - 1)*exp(-10^(slope*(stimParams(ii) - threshold)/20));
        predictedProportions(ii,:) = [p1 1-p1];
    end 
end
