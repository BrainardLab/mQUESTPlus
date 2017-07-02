function questParams = qpParams(varargin)
%qpParams  Set parameters for a QUEST+ run
%
% Usage:
%
% Description:
%   Set the parameters needed for a run of QUEST+.
%   These are specified by key/value pairs.  The
%   defaults are for a simple Weibull threshold estimation
%   example.
%
% Inputs:
%   None required.  See key/value pairs below.
%
% Outputs:
%   qpParams         Structure with fields for each of the keys below.
%
% Optional key/value pairs.
%   qpPF                  Handle to psychometric function.
%   qpOutcomeF            Handle to function for performaing a trial and reporting outcome.
%   nOutcomes             Number of possible response outcomes for qpPF and
%                         qpOutcomeF, which should be the same as each other.
%   stimParamsDomainList  Cell array of row vectors, specifing the domain of each
%                         stimulus parameter.  
%   psiParamsDomainList   Cell array of row vectors, specifying the domain of each
%                         parameter of the psychometric function.
%   priorType             String specifiying type of prior to use.
%                           'constant' - Equal values over all parameter combinations
%   stopRule              String specifying rule for stopping the run
%                           'nTrials' - After specified number of trials.
%   verbose               Boolean, true for more printout (default false).

% 6/30/17  dhb  Started on this.

%% Parse inputs and set defaults
p = inputParser;
p.addParameter('qpPF',@qpPFWeibull,@(x) isa(x,'function_handle'));
p.addParameter('qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,[-20, 3.5, .5, .02]),@(x) isa(x,'function_handle'));
p.addParameter('nOutcomes',2,@isscalar);
p.addParameter('stimParamsDomainList',{[-40:1:0]},@iscell);
p.addParameter('psiParamsDomainList',{[-40:1:0], [3.5], [.5], [0.02]},@iscell);
p.addParameter('priorType','constant',@ischar);
p.addParameter('stopRule','nTrials',@ischar);
p.addParameter('verbose',false,@islogical);
p.parse(varargin{:});

%% Return structure
questParams = p.Results;
