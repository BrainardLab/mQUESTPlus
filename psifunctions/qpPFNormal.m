function predictedProportions = qpPFNormal(stimParams,psiParams,varargin)
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
%                    Here the row vector is just a single number giving
%                    the stimulus level. 
%
%     psiParams      Row vector of parameters
%                      mean       Mean of normal
%                      sd         Standard deviation of normal
%                      lapse      Lapse rate
%                    Parameterization matches the Mathematica code from the paper.
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
p = inputParser;
p.addRequired('stimParams',@isnumeric);
p.addRequired('psiParams',@isnumeric);
p.parse(stimParams,psiParams,varargin{:}); 

%% Here is the Matlab version
if (length(psiParams) ~= 3)
    error('Parameters vector has wrong length for qpPFWeibull');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
mean = psiParams(1);
sd = psiParams(2);
lapse = psiParams(3);
predictedProportions = zeros(length(stimParams),2);
for ii = 1:length(stimParams)
    p2 = lapse + (1-2*lapse)*normcdf(stimParams(ii),mean,sd);
    predictedProportions(ii,:) = [1-p2 p2];
end
