function questData = qpRun(nTrials,varargin)
%qpRun  High level function that runs a QUEST+ experiment
%
% Usage:
%   questData = qpQuestPlus(nTrials)
%
% Description:
%   Run an experiment using QUEST+.  This demonstrates the use of QUEST+
%   and may be used to model other code that employs it.
%
%   The parameters of the experiment are set with key/value pairs using qpParams.
%
% Inputs:
%   nTrials       Number of trials to run.
%
% Outputs:
%   questData        Structure containing results of the run.
%
% Optional key/value pairs
%     See qpParams for list of key/value pairs that may be specified.
%
% See also: qpParams, qpInitialize, qpUpdate, qpQuery.

% 6/30/17  dhb  Started on this. Don't quite have design clear yet.


%% Parse parameters
questData = qpParams(varargin{:});

%% Say hello if in verbose mode
if (questData.verbose) fprintf('qpRun:\n'); end

%% Initialize
if (questData.verbose); fprintf('\tInitializing ...'); end
questData = qpInitialize(questData);
if (questData.verbose); fprintf('done\n'); end

%% Loop over trials doing smart things each time
for tt = 1:nTrials
    % Get stimulus for this trial
    if (questData.verbose & rem(tt,10) == 0) fprintf('\tTrial %d, query ...',tt); end
    [stimIndex,stim] = qpQuery(questData);
    
    % Get outcome
    if (questData.verbose & rem(tt,10) == 0); fprintf('simulate ...'); end
    outcome = questData.qpOutcomeF(stim);
    
    % Update quest data structure
    if (questData.verbose & rem(tt,10) == 0); fprintf('update ...'); end
    questData = qpUpdate(questData,stimIndex,outcome); 
    if (questData.verbose & rem(tt,10) == 0); fprintf('done\n'); end

end

%% Pack up data for return
%
% Could do any necessary finish up here.

end

% QuestPlus::usage = 
%   "QuestPlus[ntrials_,options___Rule]\nRun an experiment of \!\(\*
% StyleBox[\"ntrials\",\nFontSlant->\"Italic\"]\) trials using the \
% QUEST+ method. The options determine the configuration of the \
% experiment.";
% 
% Options[QuestPlus] = {QpOutcome -> (SimulatedObserver[#, 
%        QpPFWeibull, {-20, 3.5, .5, .02}] &)
%    , QpPNames -> {"Threshold (dB)", "Slope", "Guess", "Lapse"}
%    , QpXNames -> {"Contrast (dB)"}
%    , QpXSamples -> {Range[-40, 0]}
%    , QpPSamples -> {Range[-40, 0], {3.5}, {.5}, {0.02}}
%    , QpPsi -> QpPFWeibull
%    , QpPrior -> "Constant"
%    , QpColors -> {Red, Green, Blue, Orange, Purple, Brown, Pink, Cyan,
%       Gray, Black}
%    , Verbose -> False};
% 
% QuestPlus[ntrials_, options___Rule] := Block[
%   {pnames, xsamples, psamples, psi, outcome, prior, response, data, 
%    depth, nxd, npd, nld, likelihood, likexprior, probability, 
%    posteriors, entropies, nextindex, xnext, posterior, verbose},
%   {xsamples, psamples, psi, response, prior, 
%     verbose} = {QpXSamples, QpPSamples, QpPsi, QpOutcome, QpPrior, 
%       Verbose} /. {options} /. Options[QuestPlus];
%   
%   data = {};
%   QpSeconds = 0;
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
%   Do[(
%     likexprior = Map[(# posterior) & , likelihood, {depth}];
%     likexprior = Developer`ToPackedArray[likexprior];
%     probability = Map[Total[#, Infinity] & , likexprior, {depth}];
%     posteriors = Map[UnitizeArray , likexprior, {depth}]  ;
%     entropies = Total[MapThread[
%        (ArrayEntropy[#1] #2) &, {posteriors, probability}, depth]];
%     nextindex = ListArgMin[entropies];
%     xnext = MapThread[#1[[#2]] &, {xsamples, nextindex}];
%     outcome = response[xnext];
%     data = Append[data, {xnext, outcome}];
%     posterior = posteriors[[outcome, Sequence @@ nextindex]];
%     )
%    , {ntrials}];
%   If[verbose, Print[" seconds = ", QpSeconds]];
%   {MapThread[#1[[#2]] &, {psamples, ListArgMax[posterior]}], data}]