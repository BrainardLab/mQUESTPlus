function predictedProportions = qpPFCircular(stimParams,psiParams)
% qpPFCircular  Psychometric function for categorization of a circular variable
%
% Usage:
%     predictedProportions = qpPFCircular(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for categorization on a circle.
%
%     This could deal more robustly with wrapping issues.
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
%                                          Boundary1 must be smallest relative to zero.
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
boundaries = psiParams(:,2:end);
nStim = size(stimParams,1);
nOutcomes = length(boundaries);
predictedProportions = zeros(nStim,nOutcomes);

% Zero origin for boundaries and stimuli
stimParams = stimParams-boundaries(1);
boundaries = boundaries-boundaries(1);

%% Compute
%
% This is not terribly efficient, yet.
predictedProportions = zeros(nStim,nOutcomes);
for ii = 1:nStim
    predictedProportions(ii,1) = circ_vmcdf(boundaries(2),stimParams(ii),concentration);
    prevProportion = predictedProportions(ii,1);
    for jj = 2:nOutcomes-1
        predictedProportions(ii,jj) = circ_vmcdf(boundaries(jj+1),stimParams(ii),concentration) - prevProportion;
        prevProportion = prevProportion + predictedProportions(ii,jj);
    end
    predictedProportions(ii,nOutcomes) = circ_vmcdf(2*pi,stimParams(ii),concentration) - prevProportion;
    predictedProportions(ii,:) = predictedProportions(ii,:)/sum(predictedProportions(ii,:));
end

end

%% The CircStat2012a toolbox doesn't have a von Mises cdf
%
% But this was posted in the comments section.
%
% It integrates the pdf from an angle of 0 to an angle alpha
function p = circ_vmcdf(alpha, mean, kappa)
F = @(x)circ_vmpdf(x, mean, kappa);
p = quad(F,0,alpha);
end

