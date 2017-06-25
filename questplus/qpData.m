function stimulusDataArray = qpData(trialDataArray,varargin)
%qpData  Convert trial data array to stimulus data array.
%
% Usage:
%     stimulusDataArray = qpData(trialDataArray)

% Description:
%     Take an trial data array describing what happened on each trial and
%     convert to a stimulus data array describing what happened for each
%     unique stimulus.
%
% Input:
%     trialDataArray A struct array with each entry containing information
%                    for a single trial.
%
%
% Output:
%     stimulusDataArray A struct array with each stimulus value presented
%                    in sorted order, and a vector of outcomes that happened
%                    on trials for that stimulus value.
%
% Optional key/value pairs
%     None

% 6/23/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('trialDataArray',@isstruct);
p.parse(trialDataArray,varargin{:});

%% Get the unique stimulus vectors
%
% Have to special case when there is just one stimulus parameter.
if (length(trialDataArray(1).stim) == 1)
    stimulusVectors = [trialDataArray(:).stim]';
else
    stimulusVectors = [trialDataArray(:).stim];
end

% We'll accept however unique sorts these vectors as sorted.
uniqueStimulusVectors = unique(stimulusVectors,'rows');

%% Go through and build the stimulus data array
for ii = 1:size(uniqueStimulusVectors,1)
    stimulusDataArray(ii).stim = uniqueStimulusVectors(ii,:);
    stimulusDataArray(ii).outcomes = [];
    for jj = 1:size(stimulusVectors,1)
        if all(stimulusVectors(jj,:) == uniqueStimulusVectors(ii,:))
            stimulusDataArray(ii).outcomes = [stimulusDataArray(ii).outcomes trialDataArray(jj).outcome];
        end
    end
end
