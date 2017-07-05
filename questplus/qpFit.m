function psiParams = qpFit(trialData,qpPF,startingParams,nOutcomes,varargin)
%qpFit  Fit a psychometric function to a set of data
%
% Usage:
%     psiParams = qpFit(tria.lData,qpPF,varargin)
%
% Description:
%     Maximum likelihood fit of psychometric functdion parameters to the
%     data.  This is performed using numerical optimization, with Matlab's
%     fmincon.
%
%     It is highly recommended that you pass with key/value pairs 
%     sensible lower and upper and lower bounds on the parameters.  These
%     can be the range over which QUEST+ did its work.  Without sensible
%     bounds, strange and unfortunate things can happen in the search.
%
%     This routine requires that you have the Matlab optimization toolbox
%     installed.
%
% Input:
%     trialData        A trial data struct array:
%                        trialData(i).stim - Row vector of stimulus parameters.
%                        trialData(i).outcome - Outcome of the trial.
%
%     qpPF             Handle to a qpPF routine (e.g. qpPFWeibull).
%
%     startingParams   Where to start search. Typically this will be the parameter
%                       estimates obtained by QUEST+.
%
%     nOutcomes        Number of possible outcomes of the experiment.
%
% Output:
%     psiParams        Row vector of parameter estimates.
%
% Optional key/value pairs
%     'lowerBounds'      Lower bounds for parameters (default []).
%     'upperBounds'      Upper bounds for parameters (default []).

% 07/04/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('trialData',@isstruct);
p.addRequired('qpPF',@(x) isa(x,'function_handle'));
p.addRequired('startingParams',@isnumeric);
p.addRequired('nOutcomes',@isscalar)
p.addOptional('upperBounds',[],@isnumeric);
p.addOptional('lowerBounds',[],@isnumeric);
p.parse(trialData,qpPF,startingParams,nOutcomes,varargin{:});

%% Get stimulus counts
stimCounts = qpCounts(qpData(trialData),nOutcomes);

%% Set up fmincon
options = optimset('fmincon');
options = optimset(options,'Diagnostics','off','Display','off','LargeScale','off','Algorithm','active-set');

%% Run fmincon
psiParams = fmincon(@(x)qpFitError(x,stimCounts,qpPF),startingParams,[],[],[],[],p.Results.lowerBounds,p.Results.upperBounds,[],options);

end

%% Error function for fmincon to minimize
function f = qpFitError(psiParams,stimCounts,qpPF)

logLikelihood = qpLogLikelihood(stimCounts,qpPF,psiParams);
f = -logLikelihood;

end
