function predictedProportions = qpPFNormal(stimParams,psiParams)
% qpPFNormal  Normal cdf psychometric function
%
% Usage:
%     predictedProportions = qpPFNormal(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for the Weibull psychometric
%     function
%
% Inputs:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here that "row vector" is just a single number giving
%                    the stimulus level. 
%
%     psiParams      Row vector or matrix of parameters.  Each row has.
%                      mean       Mean of normal
%                      sd         Standard deviation of normal
%                      lapse      Lapse rate
%                    Parameterization matches the Mathematica code from the paper.
%                    If this is passed as a matrix, must have same number
%                    of rows as stimParams and the parameters are used from
%                    corresponding rows. If it is passed as a row vector, that
%                    vector is taken as the parameters for each stimulus
%                    row.
%
% Output:
%     predictedProportions  Matrix, where each row is a vector of predicted proportions
%                           for each outcome.
%                             First entry of each row is for no/incorrect (outcome == 1)
%                             Second entry of each row is for yes/correct (outcome == 2)
%
% Optional key/value pairs
%     None

% 07/02/17  dhb  Wrote it.

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
if (size(psiParams,2) ~= 3)
    error('Parameters vector has wrong length for qpPFNormal');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end

%% Grab params
mean = psiParams(:,1);
sd = psiParams(:,2);
lapse = psiParams(:,3);
nStim = size(stimParams,1);
predictedProportions = zeros(nStim,2);

%% Compute, handling the two calling cases.
%
% The use of erf is faster than normcdf, and gets a step towards not
% needing the stats toolbox.
if (length(mean) > 1)
    if (length(mean) ~= nStim )
        error('Number of parameter vectors passed is not one and does not match number of stimuli passed');
    end
    
    for ii = 1:nStim 
        adjustedSd = sd(ii)*sqrt(2);
        p2 = lapse(ii) + (1-2*lapse(ii))*0.5*(1+erf((stimParams(ii)-mean(ii))/adjustedSd));
        predictedProportions(ii,:) = [1-p2 p2];
    end 
else
    adjustedSd = sd*sqrt(2);
    for ii = 1:nStim 
        p2 = lapse + (1-2*lapse)*0.5*(1+erf((stimParams(ii)-mean)/adjustedSd));
        predictedProportions(ii,:) = [1-p2 p2];
    end 
end


