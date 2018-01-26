function uniformArray = qpUnitizeArray(inputArray)
%qpUnitizeArray  Scale the passed vector/matrix so that the sum of its entries is 1
%
% Usage:
%     uniformArray = qpUnitizeArray(inputArray)
%
% Description:
%     Scale the passed array so that the sum of its entries is 1.
%
%     If the entries of the passed array sum to 0, then a uniform array of
%     the same size, whose entries sum to 1, is returned.
%
%     This operates independently on the columns of its input.
%
% Input:
%     inputArray     An array of values.
%
% Output:
%     uniformArray   The normalized array.
%
% Optional key/value pairs
%     None

% 6/23/17  dhb  Wrote it.
% 01/25/18 dhb  Make it work columnwise.

%% Parse input
%
% This routine gets called many many times and should be as fast as
% possible.  The input parser is slow.  So we forego arg checking and
% optional key/value pairs.  The code below shows how they would look.
%
% p = inputParser;
% p.parse(varargin{:});

%% Get summed values for each column
%
% I fussed with this code in the profiler, but couldn't get it to run
% much faster than it does.  The code inside the if doesn't get used very
% often, in cases I tried.  I suppose one could live dangerously and not do
% the check for the zero divide.  But I don't think pain if it ever failed
% to be caught is worth the risk.
sumOfValues = sum(inputArray,1);
uniformArray = bsxfun(@rdivide,inputArray,sumOfValues);
if (any(sumOfValues == 0))
    index = find(sumOfValues == 0);
    [m,~] = size(inputArray);
    uniformColumn = qpUniformArray([m 1]);
    uniformArray(:,index) = repmat(uniformColumn,1,length(index));
end    
