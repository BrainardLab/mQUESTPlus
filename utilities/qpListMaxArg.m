function maxIndex = qpListMinArg(theArray)
%qpListMinArg  Return the index of the smallest element in a matrix.
%
% Usage:
%     maxIndex = qpListMinArg(theArray)
%
% Description:
%     Find the maxIndex to the maximum value in an array.
%
%     NOTE: This returns a single number, rather than a
%     vector of indices into each dimension into the array,
%     and thus differs from the Mathematica version.  This is
%     the more natural way in Matlab -- it is hard to index
%     N-dimensional arrays with a vector in Matlab.
%
% Input:
%     theArray       An array of values.
%
% Output:
%     maxIndex       Index to maximum value.

% 6/23/17  dhb  Wrote it.

%% Get the index
[maxVal,maxIndex] = max(theArray(:));
