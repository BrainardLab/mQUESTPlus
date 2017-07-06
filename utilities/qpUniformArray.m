function uniformArray = qpUniformArray(sz,varargin)
%qpUniformArray  Create an array of passed size whose values sum to 1
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
%
% Optional key/value pairs
%     None

% 6/23/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.parse(varargin{:});

uniformArray = ones(sz);
uniformArray = qpUnitizeArray(uniformArray);

