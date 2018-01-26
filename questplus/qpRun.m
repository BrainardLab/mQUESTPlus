function questData = qpRun(nTrials,varargin)
%qpRun  High level function that runs a QUEST+ experiment
%
% Usage:
%   questData = qpQuestPlus(nTrials)
%
% Description:
%   This function may be used to orchestrate an experiment using QUEST+.
%   The parameters of the experiment are set with key/value pairs.  See
%   "help qpParams" for more on parameters.
%
%   Mpte that qpRun is a high-level interface to QUEST+.  See the following demos for
%   exammples of its use:
%     qpQuestPlusPaperSimpleExamplesDemo
%     qpQuestPlusCSFDemo
%     qpQuestPlusCircularCatDemo
%
%   These demos follow the corresponding ones presented in the paper:
%     Watson, A. B. (2017).  "QUEST+: A general multidimensional Bayesian
%     adaptive psychometric method". Journal of Vision, 17(3):10, 1-27,
%     http://jov.arvojournals.org/article.aspx?articleid=2611972.
%
%   As also discussed in the paper, you may prefer not to use qpRun 
%   but rather call the pieces of QUEST+ directly.  The demo
%      qpQuestPlusCoreFunctionDemo
%   shows how to do this.  The source code of this function (qpRun) is also
%   illustrative in this regard.
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

%% Initialize.
%
% This can be slow to compute. For a particular project you could save
% it out in a .mat file and load it back in each time it is needed, rather
% than recomputing each time.
questData = qpInitialize(varargin{:});
if (questData.verbose), fprintf('qpRun:\n'); end

%% Loop over trials doing smart things each time
for tt = 1:nTrials
    % Get stimulus for this trial
    if (questData.verbose & rem(tt,10) == 0), fprintf('\tTrial %d, query ...',tt); end
    switch (questData.chooseRule)
        case 'best'
            stim = qpQuery(questData);
            
        case 'randomFromBestN'
            [~,sortedNextEntropies,sortedStimIndices] = qpQuery(questData);
            if (size(questData.stimParamsDomain,1) < questData.chooseRuleN)
                error('Chosen chooseRuleN is larger than number of available stimuli');
            end
            stimIndex = sortedStimIndices(randi(questData.chooseRuleN));
            stim = qpStimIndexToStim(stimIndex,questData.stimParamsDomain);
            if (questData.verbose & rem(tt,10) == 0)
                fprintf('\n\t\tChoosing stimulus with expected next entropy %0.1f, best would be %0.1f, second best %0.1f, worst %0.1f\n\t\t...', ...
                    sortedNextEntropies(stimIndex),sortedNextEntropies(1),sortedNextEntropies(2),sortedNextEntropies(end));
            end

        otherwise
            error('Unknown choose rule specified');
    end
    
    % Get outcome
    if (questData.verbose & rem(tt,10) == 0), fprintf('simulate ...'); end
    outcome = questData.qpOutcomeF(stim);
    if (length(outcome) > 1)
        error('More than one outcome returned for a single trial');
    end
    
    % Update quest data structure
    if (questData.verbose & rem(tt,10) == 0), fprintf('update ...'); end
    questData = qpUpdate(questData,stim,outcome); 
    if (questData.verbose & rem(tt,10) == 0), fprintf('done\n'); end
end

end

