function arrayEntropy = qpArrayEntropy(probArray)
%qpArrayEntropy  Compute the zero order entropy of an array of probabilities
%
% Usage:
%     arrayEntropy = qpArrayEntropy(probArray,varargin)
%
% Description:
%     Compute the entropy of the probability values in the passed array,
%     with repsect to base 2 (i.e. entropy in bits).
%
%     Each column is handled separately.
%
% Input:
%     probArray      An array of probabilities for the possible outcomes.
%                    These should sum to 1.
%
% Output:
%     arrayEntropy   The computed entropy of the array.
%
% Optional key/value pairs
%     None

% 6/23/17  dhb  Wrote it.
% 07/04/17 dhb  Remove key value pairs to speed this up.
% 01/25/18 dhb  Handle each column separately.

%% Parse input
%
% This routine gets called many many times and should be as fast as
% possible.  The input parser is slow.  So we forego arg checking and
% optional key/value pairs.  The code below shows how they would look.
%
% p = inputParser;
% p.addRequired('probArray',@isnumeric);
% p.parse(probArray,varargin{:});

%% Check that probabilities sum to something close to 1
% tolerance = 1e-7;
% assert(abs(sum(probArray(:))-1) < tolerance);

%% Compute the log probs
logProbs = log2(probArray);

%% Compute the entropy
%
% Using the nansum skips adding in any terms where the
% probability is zero, where log2(0) returns NaN.  This
% is the fastest way I've found of doing this.
arrayEntropy = -nansum(probArray .* logProbs,1);
