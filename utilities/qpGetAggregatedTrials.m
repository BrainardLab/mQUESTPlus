function [meanValues,nCorrect,nTrials] = qpGetAggregatedTrials(values, responses, nPerBin)
% [meanValues,nCorrect,nTrials] = GetAggregatedStairTrials(values, responses, nPerBin)
%
% Description: Returns the values and responses for
%   trials run so far, but aggregated for nicer plotting
%
% Required Input:
%   values - array of trial values (aka levels)
%   responses - array of response values (typically 0 or 1 for each trial)
%   nPerBin - number of trials to aggregate into each bin
%
% Output:
%   meanValues - Vector of values
%   nCorrect - Vector of number of correct (aka 1) responses
%   nTrials - Vector of number of trials
%
% Dividing the number correct by the number of trials gives percent correct.
%
% 10/19/09  dhb  Wrote it.

% Sort 'em and bin
[sortValues,index] = sort(values);
sortResponses = responses(index);
outIndex = 1;
bin = 1;
while (outIndex <= length(sortValues))
    meanValues(bin) = 0;
    nCorrect(bin) = 0;
    nTrials(bin) = 0;
    binCounter = 0;
    for i = 1:nPerBin
        meanValues(bin) = meanValues(bin) + sortValues(outIndex);
        if (sortResponses(outIndex) == 1)
            nCorrect(bin) = nCorrect(bin) + 1;
        end
        nTrials(bin) = nTrials(bin) + 1;
        binCounter = binCounter + 1;
        outIndex = outIndex + 1;
        if (outIndex > length(sortValues))
            break;
        end
    end
    meanValues(bin) = meanValues(bin)/binCounter;
    bin = bin + 1;
end
        
