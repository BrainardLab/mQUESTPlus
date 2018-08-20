function predictedProportions = qpPFRating(stimParams,psiParams,varargin)
% qpPFRating  Psychometric function for categorization/rating tasks
%
% Usage:
%     predictedProportions = qpPFRating(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for categorization.
%
%     This code parameterizes the boundaries as boundaries, rather
%     than first boundary and widths as in Mathematica code.
%
% Inputs:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here that "row vector" is just a single number giving
%                    the stimulus level
%
%     psiParams      Row vector of parameters.  Each row has.
%                      concentration       Mean of normal
%                      boundaries          N-1 angles giving category boundaries in radians.
%                                          Reponse 1 corresponds to boundary1 <= stim < boundary2.
%                                          Response N corresponds to boundaryN-1 <= stim < boundary1,
%                                          Boundaries must be in increasing order.  Otherwise this
%                                          routine returns a vector of NaN.
%
% Output:
%     predictedProportions  Matrix, where each row is a vector of predicted proportions
%                           for each outcome.
%                             First entry of each row is for first category (outcome == 1)
%                             Second entry of each row is second category (outcome == 2)
%                             Nth entry is for nth category (outcome -- n)

% 08/17/18  mna  Wrote it. Heavily inspired by qpPFCircular function.

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
if (size(psiParams,1) ~= 1)
    error('Expected a row vector of parameters');
end
if (size(psiParams,2) < 2)
    error('Parameters vector has wrong length for qpPFRating');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end


%% Grab params
sd = psiParams(:,1);
nStim = size(stimParams,1);
nOutcomes = length(psiParams);

%% Check whether boundary parameters are OK
%
paramsOK = qpPFRatingParamsCheck(psiParams);
if (~paramsOK)
    predictedProportions = NaN*ones(nStim,nOutcomes);
    return;
end

% Get boundaries that are guaranteed to be increasing order because the
% check above passed.
boundaries = psiParams(2:end);


%% Compute
%
predictedProportions = zeros(nStim,nOutcomes);
predictedProportions(:,1) = 1-myNormCdf(stimParams,boundaries(1),sd);
predictedProportions(:,2) = myNormCdf(stimParams,boundaries(1),sd);
if nOutcomes > 2
    for ii = 3:nOutcomes
        predictedProportions(:,ii) = myNormCdf(stimParams,boundaries(ii-1),sd);
        predictedProportions(:,ii-1) = predictedProportions(:,ii-1) - predictedProportions(:,ii);
    end
end

end



function proportions = myNormCdf(stimParams,mu,sd,lapse)

if nargin < 4
    lapse = 0;
end

% The use of erf is faster than normcdf, and gets a step towards not
% needing the stats toolbox.
nStim = length(stimParams);
proportions = nan(nStim,1);
if (length(mu) > 1)
    for ii = 1:nStim 
        adjustedSd = sd(ii)*sqrt(2);
        p2 = lapse(ii) + (1-2*lapse(ii))*0.5*(1+erf((stimParams(ii)-mu(ii))/adjustedSd));
        proportions(ii) = p2;
    end 
else
    adjustedSd = sd*sqrt(2);
    for ii = 1:nStim 
        p2 = lapse + (1-2*lapse)*0.5*(1+erf((stimParams(ii)-mu)/adjustedSd));
        proportions(ii) = p2;
    end 
end

end
