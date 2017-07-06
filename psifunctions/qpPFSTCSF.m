function [predictedProportions,predictedContrastThreshold] = qpPFSTCSF(stimParams,psiParams,varargin)
% qpPFSTCSF   Psychometric function for parametric spatial/temporal CSF
%
% Usage:
%     [predictedProportions,predictedContrastThreshold] = qpPFWeibull(stimParams,psiParams);
%
% Description:
%     Psychometric function for spatial temporal CSF.  This computes
%     predicted response proportions given the parametric spatio-temporal
%     contrast sensitivity function described in Watson's 2017 QUEST+
%     paper.
%
% Input:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here the row vector is:
%                      f          Spatial frequency in c/deg
%                      w          Temporal frequency in Hz
%                      c          Contrast in dB
%
%     psiParams      Row vector of parameters
%                      minThresh  Minimum threshold (dB)
%                      c0         Intercept of rising portion
%                      cf         Slope of spatial frequency dependence
%                      cw         Slope of temportal frequency dependence
%                    Parameterization matches the Mathematica code from the paper.
%
% Output:
%     predictedProportions        Matrix, where each row is a vector of predicted proportions
%                                 for each outcome.
%                                   First entry of each row is for no/incorrect (outcome == 1)
%                                   Second entry of each row is for yes/correct (outcome == 2)
%
%     predictedContrastThreshold  As the name indicates, in dB.  This is not
%                                 needed for QUEST+ per se, but can be
%                                 useful when plotting. This is independent
%                                 of passed stimulus contrast.
%
% Optional key/value pairs
%     'slope'      Slope of underlying Weibull (default 3)
%     'guess'      Guess rate of underlying Weibull (default 0.5)
%     'lapse'      Lapse rate of underlying Weibull (default 0.01);

% 07/03/17  dhb  Wrote it

%% Parse input
p = inputParser;
p.addRequired('stimParams',@isnumeric);
p.addRequired('psiParams',@isnumeric);
p.addOptional('slope',3,@isscalar);
p.addOptional('guess',0.5,@isscalar);
p.addOptional('lapse',0.01,@isscalar);
p.parse(stimParams,psiParams,varargin{:});

%% Pull out parameters in readable form
f = stimParams(:,1);
w = stimParams(:,2);
c = stimParams(:,3);
nStim = length(c);

minThresh = psiParams(1);
c0 = psiParams(2);
cf = psiParams(3);
cw = psiParams(4);

%% Get CSF's contrast threshold using Eqn 8 of Watson QUEST+ paper
cpred = max([minThresh*ones(size(f)),c0 + cf*f + cw*w],[],2);

%% Call the Weibull to get the proportions
predictedProportions = zeros(nStim,2);
for ii = 1:nStim
    predictedProportions(ii,:) = qpPFWeibull(c(ii),[cpred(ii) p.Results.slope p.Results.guess p.Results.lapse]);
end

%% Return the predicted contrast threshold as well.
%
% This is independent of passed contrast.
predictedContrastThreshold = cpred;

