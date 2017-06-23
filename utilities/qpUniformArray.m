function uniformArray = qpUniformArray(sz)
%qpUniformArray - Create an array of passed size whose values sum to 1
%
% Usage:
%     uniformArray = qpUniformArray(sz)

% 6/22/17  dhb  Wrote it.

uniformArray = ones(sz);
uniformArray = qpUnitizeArray(uniformArray);

