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

% 06/30/17  dhb  Started on this. Don't quite have design clear yet.
% 07/07/17  dhb  Tidy up.

%% Parse questData parameters
questData = qpParams(varargin{:});

%% Say hello if in verbose mode
if (questData.verbose) fprintf('qpRun:\n'); end

%% Initialize.
%
% This can be slow to compute. For a particular project you could save
% it out in a .mat file and load it back in each time it is needed, rather
% than recomputing each time.
if (questData.verbose); fprintf('\tInitializing ...'); end
questData = qpInitialize(questData);
if (questData.verbose); fprintf('done\n'); end

%% Loop over trials doing smart things each time
for tt = 1:nTrials
    % Get stimulus for this trial
    if (questData.verbose & rem(tt,10) == 0) fprintf('\tTrial %d, query ...',tt); end
    switch (questData.chooseRule)
        case 'best'
            [stimIndex,stim] = qpQuery(questData);
        case 'randomFromBestN'
            [~,~,sortedNextEntropies,sortedStimIndices] = qpQuery(questData);
            if (size(questData.stimParamsDomain,1) < questData.chooseRuleN)
                error('Chosen chooseRuleN is larger than number of available stimuli');
            end
            stimIndex = sortedStimIndices(randi(questData.chooseRuleN));
            stim = questData.stimParamsDomain(stimIndex,:);
            if (questData.verbose & rem(tt,10) == 0)
                fprintf('\n\t\tChoosing stimulus with expected next entropy %0.1f, best would be %0.1f, worst would be %0.1f\n\t\t...', ...
                    sortedNextEntropies(stimIndex),sortedNextEntropies(1),sortedNextEntropies(end));
            end

        otherwise
            error('Unknown choose rule specified');
    end
    
    % Get outcome
    if (questData.verbose & rem(tt,10) == 0); fprintf('simulate ...'); end
    outcome = questData.qpOutcomeF(stim);
    if (length(outcome) > 1)
        error('Hunter Thompson level weirdness');
    end
    
    % Update quest data structure
    if (questData.verbose & rem(tt,10) == 0); fprintf('update ...'); end
    questData = qpUpdate(questData,stimIndex,outcome); 
    if (questData.verbose & rem(tt,10) == 0); fprintf('done\n'); end
end

end

