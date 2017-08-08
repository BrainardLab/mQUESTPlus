function [stimParams,sortedNextEntropies,sortedStimIndices] = qpQuery(questData)
% qpQuery  Use questData structure to get next recommended stimulus index and stimulus
%
% Usage:
%     [stimParams] = qpQuery(questData)
%     [stimParams,sortedNextEntropies,sortedStimIndices] = qpQuery(questData)
%
% Description:
%     Use questData structure to get next recommended stimulus.
%     The data structure is assumed to be up to date, as after a call to
%     qpUpdate.
%
% Inputs:
%     questData              The questData structure.  See qpParams, qpInitialize and qpUpdate for
%                            description of what is in this structure.
%
% Outputs: 
%     stimParams             The corresponding row vector stimulus parameters.
%
%     sortedNextEntropies    The expected entropies after the next trial, sorted in 
%                            increasing order.
%
%     sortedStimIndices      List of indices into questData.stimParamsDomain.  First indexes stimulus the
%                            leads to minimum expected next entropy, second is next best,
%                            etc. sortedStimIndices(1) should generally be equal to stimIndex,
%                            unless there were ties in which case bets are off.
%
% Optional key/value pairs:
%   None.
%
% See also: qpParams, qpInitialize, qpUpdate, qpRun.

% 07/22/17  dhb  Change to work directly with stim, rather than using stimIndex as a middleman.

%% Find minimum entropy stimulus entry and get stimulus from index
stimIndex = qpListMinArg(questData.expectedNextEntropiesByStim);
stimParams = qpStimIndexToStim(stimIndex,questData.stimParamsDomain);

[sortedNextEntropies,sortedStimIndices] = sort(questData.expectedNextEntropiesByStim,'ascend');

end
