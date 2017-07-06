function stimProportions = qpProportions(stimCounts,nOutcomes,varargin)
%qpProportions  Convert stim count data array to stim proportion data array.
%
% Usage:
%     stimProportions = qpProportions(stimCounts)
%
% Description:
%     Take an stim counts array as produced by qpCountes and convert the list
%     of counts of each outcome for each stimulus to a list of proportions
%     for each outcome for each stimulus.
%
% Input:
%     stimCounts       A struct array with each stimulus value presented
%                      in sorted order, and a vector of the counts of each possible
%                      outcome type that happened on trials for that stimulus value:
%                        stimCounts(i).stim - Row vector of stimulus parameters
%                        stimCounts(i).outcomeCounts - Row vector of length
%                          nOutcomes with the number of times each outcome
%                          happened for the given stimulus.
%                      This is produced by qpCounts.
%
% Output:
%     stimProportions  A struct array with each stimulus value presented
%                      in sorted order, and a vector of the proportions of each possible
%                      outcome type that happened on trials for that stimulus value:
%                      stimCounts(i).stim - Row vector of stimulus parameters
%                      stimCounts(i).outcomeProprotions - Row vector of length
%                        nOutcomes with the proportion of times each outcome
%                        happened for the given stimulus.  Each such vector
%                        sums to 1.
%
% Optional key/value pairs
%     None

% 6/26/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stimCounts',@isstruct);
p.addRequired('nOutcomes',@isscalar);
p.parse(stimCounts,nOutcomes,varargin{:});

%% Get number of stimuli
nStimuli = length(stimCounts);

%% Go through and build the stimulus data array
for ii = 1:nStimuli
    stimProportions(ii).stim = stimCounts(ii).stim;
    stimProportions(ii).outcomeProportions = stimCounts(ii).outcomeCounts/sum(stimCounts(ii).outcomeCounts);
end
stimProportions = stimProportions';
