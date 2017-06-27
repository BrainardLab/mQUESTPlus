function predictedProportions = qpPFWeibull(stimMat,paramsVec,varargin)
%qpPFWeibull  Compute outcome proportions for Weibull psychometric function 
%
% Usage:
%     predictedProportions = qpPFWeibull(stimMat,paramsVec)
%
% Description:
%     Compute the proportions of each outcome for the Weibull psychometric
%     function
%
% Input:
%     stimMat        Matrix, with each row being a vector of stimulus parameters.
%                    Here the row vector is just a single number giving
%                    the stimulus level.  Units are those of the 
%                    Mathematica code from the paper.
%
%     paramsVec      Row vector of parameters
%                      threshold  Threshold
%                      slope      Slope
%                      guess      Guess rate
%                      lapse      Lapse rate
%                    Parameterization matches the Mathematica code from the
%                    paper.
%
% Output:
%     predictedProportions  Matrix, where each row is a vector of predicted proportions
%                           for each outcome.
%                             First entry of each row is for yes/correct (outcome == 1)
%                             Second entry of each row is for no/incorrect (outcome == 2)
%
% Optional key/value pairs
%     None

% 6/27/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stimMat',@isnumeric);
p.addRequired('paramsVec',@isnumeric);
p.parse(stimMat,paramsVec,varargin{:});

%% Here is the original Mathematica code.
%
% QpPFWeibull[{x_}, {threshold_, slope_, guess_, lapse_}] := 
%  {#, 1 - #} &@(lapse - (guess + lapse - 1) Exp[- 
%        10^(slope (x - threshold)/20) ])
% Compute it.  

%% Here is the Matlab version
if (length(paramsVec) ~= 4)
    error('Parameters vector has wrong length for qpPFWeibull');
end
if (size(stimMat,2) ~= 1)
    error('Each row of stimMat should have only one entry');
end
threshold = paramsVec(1);
slope = paramsVec(2);
guess = paramsVec(3);
lapse = paramsVec(4);
for ii = 1:length(stimMat)
    p2 = lapse - (guess + lapse - 1)*exp(-10^(slope*(stimMat(ii) - threshold)/20));
    predictedProportions(ii,:) = [1-p2 p2];
end