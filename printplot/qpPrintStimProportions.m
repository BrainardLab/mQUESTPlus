function qpPrintStimProportions(stimProportions,varargin)
%qpPrintStimProportions  Print out stim proportion array
%
% Usage:
%     qpPrintStimProportions(stimCounts,varargin)

% Description:
%     Print out stim proportion array.
%
% Input:
%     stimProportions  A struct array with each stimulus value presented
%                      in sorted order, and a vector of the proportions of each possible
%                      outcome type that happened on trials for that stimulus value:
%                      stimCounts(i).stim - Row vector of stimulus parameters
%                      stimCounts(i).outcomeProprotions - Row vector of length
%                        nOutcomes with the proportion of times each outcome
%                        happened for the given stimulus.  Each such vector
%                        sums to 1.
%                      This is what qpProportions produces.
%
% Output:
%     None
%
% Optional key/value pairs
%     None

% 6/25/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stimProportions',@isstruct);
p.parse(stimProportions,varargin{:});

%% Print out each entry
fprintf('Stimulus proportion data:');
counter = 0;
for ii = 1:length(stimProportions)
    if (counter == 0)
        fprintf('\n\t[');
    else
        fprintf('; [');
    end
    for jj = 1:length(stimProportions(ii).stim)
        if (jj > 1)
            fprintf(' ');
        end
        fprintf('%0.2g',stimProportions(ii).stim(jj));
    end
    fprintf('], [');
    
    for jj = 1:length(stimProportions(ii).outcomeProportions)
        if (jj > 1)
            fprintf(' ');
        end
        fprintf('%0.3f',stimProportions(ii).outcomeProportions(jj));
    end
    fprintf(']');
    
    counter = rem(counter+1,4);
end
fprintf('\n');
end
