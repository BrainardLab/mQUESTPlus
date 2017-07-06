function questData = qpInitialize(varargin)
%qpInitialize  Initialize the data structure for QUEST+ experiment.
%
% Usage:
%     questData = qpInitialize(questParams);
%
% Description:
%     Initialize the data structure for QUEST+ experiment from the options.
%
% Inputs:
%     questParams     Optional parameter structure, typically generated with
%                     function qpParams.  The fields need to be keys
%                     accepted by qpParams.
%
% Outputs:
%     questData        A structure with all of the fields in qpParams, plus:
%                        stimParamsDomain
%                        nStimParamsDomain
%                        nStimParams
%                        psiParamsDomain
%                        nPsiParamsDomain
%                        nPsiParams
%                        logLikelihood
%                        logPosterior
%                        precomputedOutcomeProportions
%
% Optional key/value pairs
%     Accepts those accepted by qpParams
%
% See also: qpParams.

% 07/04/17  dhb  Sped up using profiler.

%% Start with the parameters
% Pass any key/value pairs through qpParams.
questData = qpParams(varargin{:});

%% Convert list specifying stimlus parameters domain ...
% to a matrix, where each row of the matrix is the parameters for one of
% the possible stimuli in the domain.
%
% The idea of using combvec to convert the domain list to this particular
% matrix format, here and just below, originated with a separate and
% earlier (2016) Matlab implementation% of QUEST+ written by P R Jones
% <petejonze@gmail.com>.  I subsequently switched to the allcomb function
% from Matlab Central, to avoid making people own the nnet toolbox just to
% have combvec.
questData.stimParamsDomain = allcomb(questData.stimParamsDomainList{:});
[questData.nStimParamsDomain,questData.nStimParams] = size(questData.stimParamsDomain);

%% Convert psi params domain list to a matrix, where
% each row of the matrix is the parameters for one of
% the possibilities in the domain.
questData.psiParamsDomain = allcomb(questData.psiParamsDomainList{:});
[questData.nPsiParamsDomain,questData.nPsiParams] = size(questData.psiParamsDomain);

%% Initilize logLikeihood and posterior
questData.logLikelihood = zeros(questData.nPsiParamsDomain,1);
switch(questData.priorType)
    case 'constant'
        questData.posterior = qpUnitizeArray(ones(questData.nPsiParamsDomain,1));
    otherwise
        error('Unknown prior type specified');
end

%% Precompute table with expected proportions for each outcome given each stimulus
questData.precomputedOutcomeProportions = ...
    zeros(questData.nStimParamsDomain,questData.nPsiParamsDomain,questData.nOutcomes);
for jj = 1:questData.nPsiParamsDomain
    questData.precomputedOutcomeProportions(:,jj,:) = ....
        questData.qpPF(questData.stimParamsDomain,questData.psiParamsDomain(jj,:));
end

%% Initialize table of expected entropies
questData.expectedNextEntropiesByStim  = qpUpdateExpectedNextEnropiesByStim(questData);

end
