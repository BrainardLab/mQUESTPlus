function qpPrintTrialData(trialData,varargin)
%qpPrintTrialData  Print out trial data array
%
% Usage:
%     qpPrintTrialData(trialData,varargin)

% Description:
%     Print out trial data array.
%
% Input:
%     trialData      A trial data struct array:
%                      trialData(i).stim - Row vector of stimulus parameters.
%                      trialData(i).outcome - Outcome of the trial.
%
% Output:
%     None
%
% Optional key/value pairs
%     None

% 6/25/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('trialData',@isstruct);
p.parse(trialData,varargin{:});

%% Print out each entry
fprintf('Trial data:');
counter = 0;
for ii = 1:length(trialData)
    if (counter == 0)
        fprintf('\n\t[');
    else
        fprintf('; [');
    end
    for jj = 1:length(trialData(ii).stim)
        if (jj > 1)
            fprintf(' ');
        end
        fprintf('%0.2g',trialData(ii).stim(jj));
    end
    fprintf('], %d',trialData(ii).outcome);
    counter = rem(counter+1,4);
end
fprintf('\n');
end
