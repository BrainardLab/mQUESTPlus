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
% Input:
%     probArray      An array of probabilities for the possible outcomes.
%                    Although the Mathematica routine does not enforce that
%                    these are probabilities and sum to 1, that check seems
%                    like a good idea and is enforced here.  Override by passing
%                    tolerance key/value pair.
%
% Output:
%     arrayEntropy   The computed entropy of the array.
%
% Optional key/value pairs
%     None

% 6/23/17  dhb  Wrote it.
% 07/04/17 dhb  Remove key value pairs to speed this up.

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
logProbs = log2(probArray(:));
index = (probArray == 0);
logProbs(index) = -1*realmax;

%% Compute the entropy
arrayEntropy = -sum(probArray(:) .* logProbs(:));