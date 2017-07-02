function questData = qpUpdate(questData,stim,outcome,varargin)
% qpUpdate  Update the quest data structure for the trial stimulus and outcome.
%
% Usage: 
%     questData = qpUpdate(questData,stim,outcome
%
% Description:
%     Update the questData strucgure given the stimulus and outcome of
%     a trial.  Computes the new likelihood of the whole data stream given
%     the stimulus/outcomes so far, updates the posterior, ...
%
% Inputs:
%     questData       Quest data structure before trial.
%     stimIndex       Index into questData.stimParamsDomain for stimulus parameters of the trial
%     outcome         What happened on the trial.
%
% Outputs:
%     questData       Updated quest data structure.
%
% Optional key/value pairs
%   None

% 07/01/17  dhb  Started writing.

%% Add trial data to list
%
% Create first element of the array if necessary.
if (isfield(questData,'trialData'))
    questData.trialData(end+1).stim = stim;
    questData.trialData(end+1).outcome = outcome;
else
    questData.trialData.stim = stim;
    questData.trialData.outcome = outcome;
end

%% Update posterior
%
% We have the predicted proportions precomputed for every combintation of
% stimulus parmameters, psi parameters and outcome. So given stimulus index
% and outcome, we just look up the likelihood of the outcome for every set of
% psychometric parameters, multiply by the previous posterior (which we
% take as our prior here, and then normalize to get new posterior.)
questData.posterior = qpUnitizeArray(questData.posterior .* questData.precomputedOutcomeProportions(stimIndex,:,outcome));

% QpUpdate::usage = 
%   "QpUpdate[structure_,outcome_]\nUsing the outcome from the previous \
% trial, update the QUEST+ data structure. The function updates the \
% elements data and posterior.";
% 
% QpUpdate[structure_, outcome_] := 
%  ReplacePart[
%   structure, {1 -> Append[structure[[1]], {structure[[5]], outcome}], 
%    2 -> structure[[3]][[outcome, Sequence @@ structure[[4]]]]}]