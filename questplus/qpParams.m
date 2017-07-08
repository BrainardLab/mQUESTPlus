function questData = qpParams(varargin)
%qpParams  Set user defined parameters for a QUEST+ run.  Called by qpInitialize.
%
% Usage:
%     questData = qpParams(varargin)
%
% Description:
%     Set the user defined parameters needed for a run of QUEST+. These are specified by
%     key/value pairs.  The defaults are for a simple Weibull threshold
%     estimation example.
%
%     This works by allowing the user to pass a set of key value pairs for each possible
%     user defined parameter.
%
%     This routine is not intended to be called directly.  Rather, it is invoked by qpInitialize,
%     which accepts the same set of key/value pairs and passes them through.  In addition, qpRun
%     takes the same set of parameters and passes them through to qpInitialize.
%
% Inputs:
%     None required.     See key/value pairs below for what can be set
%  
% Outputs:
%     questData          Structure with one field each corresponding to the keys below.
%                        Each filed has the same name as the key.
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
%   chooseRule            String specifying how to choose next stimulus (default 'best').
%                           'best' - Take stimulus that maximally reduces expected entropy.
%                           'randomFromBestN' - Take stimulus at random from the top N
%                              with respect to expected next entropy.  N is determined by
%                              chooseRuleN field.
%   choseRuleN            Integer given the N to choose from, if chooseRule is 'randomFromBestN'
%                            (default 1).
%   verbose               Boolean, true for more printout (default false).
%
% See also: qpInitialize, qpUpdate, qpQuery, qpRun.


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
p.addParameter('chooseRule','best',@ischar);
p.addParameter('chooseRuleN',1,@isnumeric);
p.addParameter('verbose',false,@islogical);
p.parse(varargin{:});

%% Return structure
questData = p.Results;
