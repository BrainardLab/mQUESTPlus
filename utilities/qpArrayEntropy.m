function arrayEntropy = qpArrayEntropy(probArray,varargin)
%qpArrayEntropy  Compute the zero order entropy of an array of probabilities
%
% Usage:
%     arrayEntropy = qpArrayEntropy(probArray,varargin)
%
% Description:
%     Compute the entropy of the probability values in the passed array,
%     with repsect to the specified base.  The default base is 2; change by
%     passing base key/value pair.
%
% Input:
%     probArray      An array of probabilities for the possible outcomes.
%                    Although the Mathematica routine does not enforce that
%                    these are probabilities and sum to 1, that check seems
%                    like a good idea and is enforced here.  Override by passing
%                    tolerance key/value pair.
%
% Optional key/value pairs
%     'base'         value (default 2) - Base with which 
%     'tolerance'    value (default 1e-7) - Array values should sum to
%                    within this of 1.  Set to Inf if you don't want a
%                    tolerance.

% 6/23/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('probArray',@isnumeric);
p.addParameter('base',2,@isscalar);
p.addParameter('tolerance',1e-7,@isscalar);
p.parse(probArray,varargin{:});

%% Check that probabilities sum to something close to 1
assert(abs(sum(probArray(:))-1) < p.Results.tolerance);

%% Compute the log probs
logProbs = log2(probArray(:))/log2(p.Results.base);

%% Compute the entropy
arrayEntropy = -sum(probArray(:) .* logProbs(:));