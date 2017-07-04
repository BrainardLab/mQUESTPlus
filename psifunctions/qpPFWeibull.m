function predictedProportions = qpPFWeibull(stimParams,psiParams)
%qpPFWeibull  Compute outcome proportions for Weibull psychometric function 
%
% Usage:
%     predictedProportions = qpPFWeibull(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for the Weibull psychometric
%     function
%
% Input:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here the row vector is just a single number giving
%                    the stimulus contrast level in dB.
%
%     psiParams      Row vector of parameters
%                      threshold  Threshold in dB
%                      slope      Slope
%                      guess      Guess rate
%                      lapse      Lapse rate
%                    Parameterization matches the Mathematica code from the Watson
%                    QUEST+ paper.
%
% Output:
%     predictedProportions  Matrix, where each row is a vector of predicted proportions
%                           for each outcome.
%                             First entry of each row is for no/incorrect (outcome == 1)
%                             Second entry of each row is for yes/correct (outcome == 2)
%
% Optional key/value pairs
%     None

% 6/27/17  dhb  Wrote it.

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
if (length(psiParams) ~= 4)
    error('Parameters vector has wrong length for qpPFWeibull');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
threshold = psiParams(1);
slope = psiParams(2);
guess = psiParams(3);
lapse = psiParams(4);
predictedProportions = zeros(length(stimParams),2);
for ii = 1:length(stimParams)
    p1 = lapse - (guess + lapse - 1)*exp(-10^(slope*(stimParams(ii) - threshold)/20));
    predictedProportions(ii,:) = [p1 1-p1];
end