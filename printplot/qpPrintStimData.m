function qpPrintStimData(stimData,varargin)
%qpPrintStimData  Print out stimulus data array
%
% Usage:
%     qpPrintStimData(stimData,varargin)

% Description:
%     Print out trial data array.
%
% Input:
%     stimData      A struct array with each stimulus value and a vector of outcomes
%                      stimData(i).stim - Row vector of stimulus parameters
%                      stimData(i).outcomes - Row vector of outcomes 
%
% Output:
%     None
%
% Optional key/value pairs
%     None

% 6/25/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stimData',@isstruct);
p.parse(stimData,varargin{:});

%% Print out each entry
fprintf('Stimulus data:');
counter = 0;
for ii = 1:length(stimData)
    if (counter == 0)
        fprintf('\n\t[');
    else
        fprintf('; [');
    end
    for jj = 1:length(stimData(ii).stim)
        if (jj > 1)
            fprintf(' ');
        end
        fprintf('%0.2g',stimData(ii).stim(jj));
    end
    fprintf('], [');
    
    for jj = 1:length(stimData(ii).outcomes)
        if (jj > 1)
            fprintf(' ');
        end
        fprintf('%d',stimData(ii).outcomes(jj));
    end
    fprintf(']');
    
    counter = rem(counter+1,4);
end
fprintf('\n');
end
