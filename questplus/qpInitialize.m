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

%% Start with the parameters
% Pass any key/value pairs through qpParams.
questData = qpParams(varargin{:});

%% Convert list specifying stimlus parameters domain list
% to a matrix, where each row of the matrix
% is the parameters for one of the possible stimuli in
% the domain.
questData.stimParamsDomain = combvec(questData.stimParamsDomainList{:})';
[questData.nStimParamsDomain,questData.nStimParams] = size(questData.stimParamsDomain);

%% Convert psi params domain list to a matrix, where
% each row of the matrix is the parameters for one of
% the possibilities in the domain.
questData.psiParamsDomain = combvec(questData.psiParamsDomainList{:})';
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
for ii = 1:questData.nStimParamsDomain
    for jj = 1:questData.nPsiParamsDomain
        questData.precomputedOutcomeProportions(ii,jj,:) = ....
            questData.qpPF(questData.stimParamsDomain(ii,:),questData.psiParamsDomain(jj,:));
    end
end

%% Initialize table of expected entropies
questData.expectedNextEntropiesByStim  = qpUpdateExpectedNextEnropiesByStim(questData);

end

% {QpOutcome -> (SimulatedObserver[#1, 
%      QpPFWeibull, {-20, 3.5, 0.5, 0.02}] &), 
%  QpPNames -> {"Threshold (dB)", "Slope", "Guess", "Lapse"}, 
%  QpXNames -> {"Contrast (dB)"}, 
%  QpXSamples -> {{-40, -39, -38, -37, -36, -35, -34, -33, -32, -31, \
% -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, \
% -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1,
%      0}}, QpPSamples -> {{-40, -39, -38, -37, -36, -35, -34, -33, \
% -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, \
% -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, \
% -3, -2, -1, 0}, {3.5}, {0.5}, {0.02}}, QpPsi -> QpPFWeibull, 
%  QpPrior -> "Constant", Verbose -> False}


% QpInitialize::usage = 
%   "QpInitialize[options___Rule]\nInitialize the data structure for a \
% QUEST+ experiment. The options determine the configuration of the \
% experiment. The function returns a large data structure consisting of \
% the elements: {data, posterior, posteriors, nextindex, xnext, depth, \
% likelihood, {options}}. When there is more than one condition, a \
% structure can be created for each.";
% 
% QpInitialize[options___Rule] := Block[
%   {pnames, xsamples, psamples, psi, outcome, prior, response, data, 
%    depth, nxd, npd, nld, likelihood, likexprior, probability, 
%    posteriors, entropies, nextindex, xnext, posterior, verbose},
%   
%   {xsamples, psamples, psi, response, prior, 
%     verbose} = {QpXSamples, QpPSamples, QpPsi, QpOutcome, QpPrior, 
%       Verbose} /. {options} /. Options[QuestPlus];
%   
%   data = {};
%   nxd = Length[xsamples];
%   npd = Length[psamples];
%   nld = nxd + npd + 1;
%   depth = nxd + 1;
%   If[prior === "Constant",
%    prior = UniformArray[Length /@ psamples]];
%   prior = Developer`ToPackedArray[prior];
%   likelihood = 
%    Chop[N[Outer[psi[Take[{##}, nxd], Drop[{##}, nxd]] &, 
%       Sequence @@ Join[xsamples, psamples]]]];
%   likelihood = Transpose[likelihood, RotateLeft[Range[nld]]];
%   likelihood = Developer`ToPackedArray[likelihood];
%   If[verbose, Print["samples = ", Times @@ Dimensions[likelihood]]];
%   posterior = prior;
%   xnext = nextindex = posteriors = 0;
%   {data, posterior, posteriors, nextindex, xnext, depth, 
%    likelihood, {options}}
%   ]