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
%   qpPF             Handle to psychometric function 
%   nOutcomes        Number of response outcomes.
%   stimParamsDomain Cell array of row vectors, specifing the domain of each
%                    stimulus parameter.  This is converted to a matrix in
%                    the returned structure, where each row of the matrix
%                    is the parameters for one of the possible stimuli in
%                    the domain.
%   psiParamsDomain  Cell array of row vectors, specifying the domain of each
%                    parameter of the psychometric function.  This is
%                    converted to a matrix in the returned structure, where
%                    each row of the matrix is the parameters for one of
%                    the possibilities in the domain.
%   priorType        String specifiying type of prior to use.
%                      'constant' - Equal values over all parameter combinations
%   stopRule         String specifying rule for stopping the run
%                      'nTrials' - After specified number of trials.

% 6/30/17  dhb  Started on this.

%% Parse inputs and set defaults
p = inputParser;
p.addParameter('qpPF',@qpPFWeibull,@(x) isa(x,'function_handle'));
p.addParameter('nOutcomes',2,@isscalar);
p.addParameter('stimParamsDomain',{[-40:1:0]},@iscell);
p.addParameter('psiParamsDomain',{[-40:1:0], [3.5], [.5], [0.02]},@iscell);
p.addParameter('priorType','constant',@ischar);
p.addParameter('stopRule','nTrials',@ischar);
p.parse;

%% Return structure
questParams = p.Results;
questParams.stimParamsDomain = combvec(questParams.stimParamsDomain{:})';
questParams.psiParamsDomain = combvec(questParams.psiParamsDomain{:})';