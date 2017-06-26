function stimCounts = qpCounts(stimData,nOutcomes,varargin)
%qpCounts  Convert stim data array to count data array.
%
% Usage:
%     stimCounts = qpCounts(stimData)
%
% Description:
%     Take an stim data array as produced by qpData and convert the list
%     of trial by trial outcomes to a list ofhow many times each possible
%     outcome was chosen, for each stimulus.
%
% Input:
%     stimData       A struct array with each stimulus value presented
%                    in sorted order, and a vector of outcomes that happened
%                    on trials for that stimulus value:
%                      stimData(i).stim - Row vector of stimulus parameters
%                      stimData(i).outcomes - Row vector of outcomes on
%                        each trial where the corresponding stimulus was
%                        presented.
%                    This is what qpData produces as output
%
% Output:
%     stimCounts     A struct array with each stimulus value presented
%                    in sorted order, and a vector of the counts of each possible
%                    outcome type that happened on trials for that stimulus value:
%                      stimCounts(i).stim - Row vector of stimulus parameters
%                      stimCounts(i).outcomeCounts - Row vector of length
%                        nOutcomes with the number of times each outcome
%                        happend for the given stimulus.
%
% Optional key/value pairs
%     None

% 6/26/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stimData',@isstruct);
p.addRequired('nOutcomes',@isscalar);
p.parse(stimData,nOutcomes,varargin{:});

%% Get number of stimuli
nStimuli = length(stimData);

%% Go through and build the stimulus data array
for ii = 1:nStimuli
    stimCounts(ii).stim = stimData(ii).stim;
    for jj = 1:nOutcomes
        stimCounts(ii).outcomeCounts(jj) = length(find(stimData(ii).outcomes == jj));
    end
end
