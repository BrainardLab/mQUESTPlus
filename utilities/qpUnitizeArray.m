function uniformArray = qpUnitizeArray(inputArray)
%qpUnitizeArray  Scale the passed array so that the sum of its entries is 1. 
%
% Usage:
%     uniformArray = qpUnitizeArray(inputArray)

% 6/22/17  dhb  Wrote it.

uniformArray = inputArray/sum(inputArray(:));