function uniformArray = qpUnitizeArray(inputArray)
%qpUnitizeArray  Scale the passed array so that the sum of its entries is 1.
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

% 6/22/17  dhb  Wrote it.

%% Get summed values
sumOfValues = sum(inputArray(:));

%% Make the appropriate array to return
if (sumOfValues == 0)
    uniformArray = qpUniformArray(size(inputArray));
else
    uniformArray = inputArray/sumOfValues;
end