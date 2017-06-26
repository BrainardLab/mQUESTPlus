function qpPrintStimCounts(stimCounts,varargin)
%qpPrintStimCounts  Print out stim count array
%
% Usage:
%     qpPrintStimCounts(stimCounts,varargin)

% Description:
%     Print out stim count array.
%
% Input:
%     stimCounts     A struct array with each stimulus value presented
%                    in sorted order, and a vector of the counts of each possible
%                    outcome type that happened on trials for that stimulus value:
%                      stimCounts(i).stim - Row vector of stimulus parameters
%                      stimCounts(i).outcomeCounts - Row vector of length
%                        nOutcomes with the number of times each outcome
%                        happend for the given stimulus.
%                    This is what qpCounts produces.
%
% Output:
%     None
%
% Optional key/value pairs
%     None

% 6/25/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stimCounts',@isstruct);
p.parse(stimCounts,varargin{:});

%% Print out each entry
fprintf('Stimulus count data:');
counter = 0;
for ii = 1:length(stimCounts)
    if (counter == 0)
        fprintf('\n\t[');
    else
        fprintf('; [');
    end
    for jj = 1:length(stimCounts(ii).stim)
        if (jj > 1)
            fprintf(' ');
        end
        fprintf('%0.2g',stimCounts(ii).stim(jj));
    end
    fprintf('], [');
    
    for jj = 1:length(stimCounts(ii).outcomeCounts)
        if (jj > 1)
            fprintf(' ');
        end
        fprintf('%d',stimCounts(ii).outcomeCounts(jj));
    end
    fprintf(']');
    
    counter = rem(counter+1,4);
end
fprintf('\n');
end
