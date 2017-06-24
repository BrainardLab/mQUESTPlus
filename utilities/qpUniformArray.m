function uniformArray = qpUniformArray(sz)
%qpUniformArray - Create an array of passed size whose values sum to 1
%
% Usage:
%     uniformArray = qpUniformArray(sz)
%
% Description:
%     Create an array of passed size whose values sum to 1.
%
% Input:
%     sz             N-dimensional row vector with array size along of its N dimensions.
%
% Output:
%     uniformArray   The desired array.

% 6/22/17  dhb  Wrote it.

uniformArray = ones(sz);
uniformArray = qpUnitizeArray(uniformArray);

