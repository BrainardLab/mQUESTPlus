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
% Input:
%     inputArray     An array of values.
%
% Output:
%     uniformArray   The normalized array.
%
% Optional key/value pairs
%     None

% 6/23/17  dhb  Wrote it.

%% Parse input
%
% This routine gets called many many times and should be as fast as
% possible.  The input parser is slow.  So we forego arg checking and
% optional key/value pairs.  The code below shows how they would look.
%
% p = inputParser;
% p.parse(varargin{:});

%% Get summed values
sumOfValues = sum(inputArray(:));

%% Make the appropriate array to return
if (sumOfValues == 0)
    uniformArray = qpUniformArray(size(inputArray));
else
    uniformArray = inputArray/sumOfValues;
end