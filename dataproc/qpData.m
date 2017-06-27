function stimData = qpData(trialData,varargin)
%qpData  Convert trial data array to stimulus data array.
%
% Usage:
%     stimData = qpData(trialData)
%
% Description:
%     Take an trial data array describing what happened on each trial and
%     convert to a stimulus data array describing what happened for each
%     unique stimulus.
%
% Input:
%     trialData      A trial data struct array:
%                      trialData(i).stim - Row vector of stimulus parameters.
%                      trialData(i).outcome - Outcome of the trial.
%
% Output:
%     stimData       A struct array with each stimulus value presented
%                    in sorted order, and a vector of outcomes that happened
%                    on trials for that stimulus value:
%                      stimData(i).stim - Row vector of stimulus parameters
%                      stimData(i).outcomes - Row vector of outcomes on
%                        each trial where the corresponding stimulus was
%                        presented.
%
% Optional key/value pairs
%     None

% 6/23/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('trialData',@isstruct);
p.parse(trialData,varargin{:});

%% Get the unique stimulus vectors
for jj = 1:size(trialData,1)
    stimulusVectors(jj,:) = trialData(jj).stim;
end

% We'll accept however unique sorts these vectors as sorted.
uniqueStimulusVectors = unique(stimulusVectors,'rows');

%% Go through and build the stimulus data array
for ii = 1:size(uniqueStimulusVectors,1)
    stimData(ii).stim = uniqueStimulusVectors(ii,:);
    stimData(ii).outcomes = [];
    for jj = 1:size(stimulusVectors,1)
        if all(stimulusVectors(jj,:) == uniqueStimulusVectors(ii,:))
            stimData(ii).outcomes = [stimData(ii).outcomes trialData(jj).outcome];
        end
    end
end
