function questData = qpParams(varargin)
%qpParams  Set user defined parameters for a QUEST+ run.  Called by qpInitialize.
%
% Usage:
%     questData = qpParams(varargin)
%
% Description:
%     Set the user defined parameters needed for a run of QUEST+. These are
%     specified by key/value pairs.  The defaults are for a simple Weibull
%     threshold estimation example.
%
%     This works by allowing the user to pass a set of key value pairs for
%     each possible user defined parameter.
%
%     This routine is not intended to be called directly.  Rather, it is
%     invoked by qpInitialize, which accepts the same set of key/value
%     pairs and passes them through.  In addition, qpRun takes the same set
%     of parameters and passes them through to qpInitialize.
%
% Inputs:
%     None required.     See key/value pairs below for what can be set
%  
% Outputs:
%     questData          Structure with one field each corresponding to the
%                        keys below. Each field has the same name as the
%                        key.
%
% Optional key/value pairs.
%   qpPF                       Handle to psychometric function.
%   qpOutcomeF                 Handle to function for performaing a trial
%                              and reporting outcome. We think this is only
%                              used by qpRun and can be passed as empty if
%                              you are not using qpRun.
%   nOutcomes                  Number of possible response outcomes for qpPF and
%                              qpOutcomeF, which should be the same as each other.
%   stimParamsDomainList       Cell array of row vectors, specifing the domain of each
%                              stimulus parameter. Note that each stimulus
%                              on this list is assigned equal prior probability in the standard
%                              QUEST+ algorithm.  Thus the space in which you grid the stimuli
%                              (e.g. linear versus log) implicitly affects the prior, and it is
%                              worth a little thought about what space you choose to grid the stimuli
%                              on.
%   filterStimParamsDomainFun  Function handle for stimulus domain filtering (default []).
%   psiParamsDomainList        Cell array of row vectors, specifying the domain of each
%                              parameter of the psychometric function.
%   filterPsiParamDomainFun    Function handle for parameter domain filtering (default []).  See
%                              qpQuestPlusCircularCatDemo for a demonstration of the use of this
%                              key/value pair.
%   priorType                  String specifiying type of prior to use.
%                                'constant' - Equal values over all parameter combinations
%   stopRule                   String specifying rule for stopping the run
%                                'nTrials' - After specified number of trials.
%   chooseRule                 String specifying how to choose next stimulus (default 'best').
%                                'best' - Take stimulus that maximally reduces expected entropy.
%                                'randomFromBestN' - Take stimulus at random from the top N
%                                   with respect to expected next entropy.  N is determined by
%                                  chooseRuleN field.
%   choseRuleN                 Integer given the N to choose from, if chooseRule is 'randomFromBestN'
%                                (default 1).
%   verbose                    Boolean, true for more printout (default false).
%   noentropy                  Boolean (default false).  Skip entropy
%                              computation. This could be useful if you are
%                              just putting your actual trials into the
%                              QUEST+ structure, so that you can (e.g.)
%                              call qpFit.  Speeds things up for this case.
%                              One time you might want to do this is if you
%                              are running several interleaved quests and
%                              want to use a single overall quest to keep
%                              track of all the trials run for later
%                              analysis.
%  marginalize                 Default empty. If not empty, this is a row
%                              vector that contains the indices of the
%                              parameter vector to marginalize over before
%                              computing entropy.
%
% See also: qpInitialize, qpUpdate, qpQuery, qpRun.

% 6/30/17  dhb  Started on this.
% 7/22/17  dhb  Params filtering key/value pairs

%% Parse inputs and set defaults
p = inputParser;
p.addParameter('qpPF',@qpPFWeibull,@(x) isa(x,'function_handle'));
p.addParameter('qpOutcomeF',@(x) qpSimulatedObserver(x,@qpPFWeibull,[-20, 3.5, .5, .02]),@(x) (isempty(x) | isa(x,'function_handle')));
p.addParameter('nOutcomes',2,@isscalar);
p.addParameter('stimParamsDomainList',{[-40:1:0]},@iscell);
p.addParameter('filterStimParamsDomainFun',[],@(x) (isempty(x) | isa(x,'function_handle')));
p.addParameter('psiParamsDomainList',{[-40:1:0], [3.5], [.5], [0.02]},@iscell);
p.addParameter('filterPsiParamsDomainFun',[],@(x) (isempty(x) | isa(x,'function_handle')));
p.addParameter('priorType','constant',@ischar);
p.addParameter('stopRule','nTrials',@ischar);
p.addParameter('chooseRule','best',@ischar);
p.addParameter('chooseRuleN',1,@isnumeric);
p.addParameter('verbose',false,@islogical);
p.addParameter('noentropy',false,@islogical);
p.addParameter('marginalize',[],@(x) (isempty(x) | isnumeric(x)));
p.parse(varargin{:});

%% Return structure
questData = p.Results;
