function predictedProportions = qpPFCircular(stimParams,psiParams)
% qpPFCircular  Psychometric function for categorization of a circular variable
%
% Usage:
%     predictedProportions = qpPFCircular(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for categorization on a circle.
%
%     This code parameterizes the boundaries as boundaries, rather
%     than first boundary and widths as in Mathematica code.
%
%     This could deal more robustly with wrapping issues and argument
%     checking. It is good enough to allow the demo to run, but maybe
%     not for real work.
%
% Inputs:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here that "row vector" is just a single number giving
%                    the stimulus angle in radians
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
%
% Optional key/value pairs
%     None

% 07/07/17  dhb  Wrote it.

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
if (size(psiParams,2) < 2)
    error('Parameters vector has wrong length for qpPFCircular');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
if (any(stimParams < 0 | stimParams > 2*pi))
    error('Stimuli must be greater than or equal to zero and less than 2*pi');
end

%% Grab params
concentration = psiParams(:,1);
nStim = size(stimParams,1);

%% Filter out redundant parameters from grid
%
% This is signaled by returning NaN when the boundaries are
% not in increasing order.
[boundaries,sortIndex] = sort(psiParams(:,2:end),'ascend');
nOutcomes = length(boundaries);
if (any(sortIndex ~= 1:nOutcomes))
    predictedProportions = NaN*ones(nStim,nOutcomes);
    return;
end

%% Check that boundaries are within the circle, within tolerance.
if (any(boundaries < 0-1e-7 | boundaries > 2*pi+1e-7))
    error('Passed boundaries must be greater than or equal to zero and less than 2*pi');
end

% Convert to -pi origin for boundaries and stimuli for our internal calculations
stimParams = stimParams - pi;
boundaries = boundaries - pi;

%% Compute
%
% This is not terribly efficient, yet.
predictedProportions = zeros(nStim,nOutcomes);
for ii = 1:nStim
    prevProportion0 = von_mises_cdf(boundaries(1),stimParams(ii),concentration);
    prevProportion = prevProportion0;
    predictedProportions(ii,1) = von_mises_cdf(boundaries(2),stimParams(ii),concentration) - prevProportion;
    prevProportion = prevProportion + predictedProportions(ii,1);
    for jj = 2:nOutcomes-1
        predictedProportions(ii,jj) = von_mises_cdf(boundaries(jj+1),stimParams(ii),concentration) - prevProportion;
        prevProportion = prevProportion + predictedProportions(ii,jj);
    end
    predictedProportions(ii,nOutcomes) = von_mises_cdf(2*pi,stimParams(ii),concentration) - prevProportion + prevProportion0;
    predictedProportions(ii,:) = predictedProportions(ii,:)/sum(predictedProportions(ii,:));
end

end


