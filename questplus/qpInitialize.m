function questData = qpInitialize(varargin)
%qpInitialize  Initialize the questData structure for a QUEST+ experiment
%
% Usage:
%     questData = qpInitialize(questParams);
%
% Description:
%     Initialize the data structure for QUEST+ experiment.  This begins by passing
%     the passed key value pairs through qpParams to set the user defined parameters
%     of the experiment.  It then initializes the necessary fields, starting with
%     those parameters. 
%
%     See qpParams for a description of the user defined parameters.
%
%     In some applications, it may be difficult to arrange a stimulus parameterization
%     where all the values on the grid are valid and/or represent unique states of the
%     observer.  If the psychometric function returns a vector of NaNs for these cases,
%     the initialization removes from the psychometric function parameter domain those
%     parameter sets that lead to a NaN return vector.  This convention differs from
%     the Mathematica implementation.
%
% Inputs:
%     questParams     Optional parameter structure, typically generated with
%                     function qpParams.  The fields need to be keys
%                     accepted by qpParams.
%
% Outputs:
%     questData        A structure with all of the fields set by qpParams, plus:
%                        stimParamsDomain - Matrix defining all of the possible combinations
%                          of stimulus parameters. This is the cartesian produce of the lists
%                          set in qpParams.  Each row is one possible set of stimulus parameters.
%                        nStimParamsDomain - The number of stimulus parameter combinations (row
%                          size of stimParamsDomain.
%                        nStimParams - Number of stimulus parameters (column size of stimParamsDomain).
%                        psiParamsDomain - Matrix defining all of the possible combinations
%                          of psychometric function parameters. This is the cartesian produce of
%                          the lists set in qpParams.  Each row is one possible set of psychometric
%                          function parameters.
%                        nPsiParamsDomain - Number of psychometric fuction parameter combinations (row
%                          size of psiParamsDomain.
%                        nPsiParams - Number of psychometric function parameters (column size of 
%                          psiParamsDomain).
%                        logLikelihood - nPsiParamsDomain dimensional column vector with Current natural log likelihood of the data
%                          for every choice of parameters in psiParamsDomain. Initialized to 0 for each parameter choice.
%                        posterior - nPsiParamsDomain dimensional column vector with osterior over the
%                          psychometric function parameters.  Initialized according to priorType field which
%                          is set in qpParams. Typically this is a uniform prior.
%                        precomputedOutcomeProportions - nStimDomainParams by nPsiParamsDomain by nOutcomes
%                          matrix giving the predicted proportion of each outcome for every combination of
%                          stimulus and psychometric function parameters. Initializing this can take a little
%                          while.
%                        expectedNextEntropiesByStim - nStimParamsDomain dimensional column vector with
%                          the expected entropy after presentation of each possible stimulus.  This is initialized
%                          with the initial prior.
%
% Optional key/value pairs
%     See qpParams for list of key/value pairs that may be specified.
%
% See also: qpParams, qpUpdate, qpQuery, qpRun.

% 07/04/17  dhb  Sped up using profiler.

%% Start with the parameters
%
% Pass any key/value pairs through qpParams to get the fields set by the
% user.
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
%
% This runs a check as to whether all the parameters return non-NaN
% proportions.  If one does not, the particular parameters are treated
% as invalid and removed from the domain.
psiParamsDomainRaw = allcomb(questData.psiParamsDomainList{:});
psiParamsDomainIndex = 1;
for jj = 1:size(psiParamsDomainRaw,1)
    checkParams = questData.qpPF(questData.stimParamsDomain(1,:),psiParamsDomainRaw(jj,:));
    if (~any(isnan(checkParams)))
        questData.psiParamsDomain(psiParamsDomainIndex,:) = psiParamsDomainRaw(jj,:);
        psiParamsDomainIndex = psiParamsDomainIndex + 1;
    end
end
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
