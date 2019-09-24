function posteriorMean = qpPosteriorMean(posterior,psiParamsDomainList,varargin)
%qpPosteriorMean  Compute the posterior mean of the PF parameters
%
% Usage:
%     posteriorMean = qpPosteriorMean(posterior,psiParamsDomain)
%
% Description:
%     Compute the posterior mean
%
% Input:
%     posterior        Column vector giving posterior over parameters
%                      This should sum to 1.
%     psiParamsDomain  Matrix. Each row gives a vector of PF
%                      parameters.  The number of rows should match
%                      the number of entries in posterior.
%
% Output:
%     posteriorMean    The mean of the posterior
%
% Optional key/value pairs
%     None

% 09/23/19 dhb  Wrote it.

%% Parse input
%
% This routine gets called many many times and should be as fast as
% possible.  The input parser is slow.  So we forego arg checking and
% optional key/value pairs.  The code below shows how they would look.
%
% p = inputParser;
% p.addRequired('posterior',@isnumeric);
% p.addRequired('psiParamsDomainList',@isnumeric);
% p.parse(probArray,varargin{:});

%% Check that probabilities sum to something close to 1
tolerance = 1e-7;
assert(abs(sum(posterior(:))-1) < tolerance);

%% Dimension checks
if (~iscolumn(posterior))
    error('Passed posterior must be a column vector');
end
if (length(posterior) ~= size(psiParamsDomainList,1))
    error('Posterior and psiParamsDomainList are not matched in dimensions');
end

%% Compute the posterior mean
posteriorMean = sum(bsxfun(@times,psiParamsDomainList,posterior),1);

