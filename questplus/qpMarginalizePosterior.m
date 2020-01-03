function [marginalPosterior,marginalPsiParamsDomain,marginalLabels] = qpMarginalizePosterior(posterior,psiParamsDomain,whichParamsToMarginalize,paramLabels)
% Marginalize a QUEST+ posterior
%
% Syntax:
%    [marginalPosterior,marginalPsiParamsDomain,marginalParamLabels] = qpMarginalizePosterio(posterior,psiParamsDomain,whichParamsToMarginalize,[paramLabels])
%
% Description:
%     Sum discretely sampled posterior over parameters indexed by whichParamsToMarginalize, to produce a
%     discretely sampled marginal posterior distribution. 
%
% Inputs:
%     posterior             - Matrix where each column give probability of each
%                             of N possible outcomes. Each column should sum to
%                             unity. If just one posterior is passed, it
%                             should be a column vector.
%     psiParamsDomain       - N by Nparams matrix. Each row gives the
%                             parameter values for the corresponding entry
%                             of the posterior.
%     whichParamsToMarginalize - Row vector giving K distinct indices in range
%                             [1,Nparams]. These specify the parameters to
%                             marginalize over.
%     paramLabels           - Cell array of string names for each parameter.
%
% Outputs:
%     marginalPosterior     - Column vector giving probability of each
%                             of the M outcomes in the marginal posterior.
%     marginalPsiParamsDomain - M by NParams-K matrix. Each row gives the
%                             parameter values for the corresponding entry
%                             of the marginal posterior.
%     marginalParamLabels   - If labels passed, this is a cell array of the
%                             labels for the remaining parameters. If
%                             labels not passed, returned as the empty cell
%                             array.
%
% Optional key/value pairs:
%     None.
%
% See also:
% 

% History
%   09/09/19  dhb  Pulled out of tutorial where I developed the basic code
%   09/22/19  dhb  Allow matrix input so we can marginalize multiple
%                  posteriors.

%%  Get remaining index and handle labels if passed
remainingParamsIndex = setdiff(1:size(psiParamsDomain,2),whichParamsToMarginalize);
if (nargin > 3 && ~isempty(paramLabels))
    marginalLabels = paramLabels{remainingParamsIndex};
else
    marginalLabels = {};
end

%% Get full psi params domain but without variables we're going to marginalize
% over
remainingPsiParamsDomain = psiParamsDomain(:,remainingParamsIndex);

%% Find unique rows in remainingPsiParamsDomain.
%
% Note that:
%   uniqueRemainingPsiParamsDomain = remainingPsiParamsDomain(IA,:)
%   remainingPsiParamsDomain = uniqueRemainingPsiParamsDomain(IC,:)
[marginalPsiParamsDomain,~,IC] = unique(remainingPsiParamsDomain,'rows','stable');

%% Marginalize
%
% Initialize posterior with zeros, and also a counter for a check.
marginalPosterior = zeros(size(marginalPsiParamsDomain,1),size(posterior,2));
ICEntriesAccountedFor = 0;
%marginalPosterior1 = zeros(size(marginalPsiParamsDomain,1),size(posterior,2));

% For each entry in the marginal posterior domain,
% we sum up probabilities over the entries in the full
% posterior that correspond to each entry.
for ii = 1:size(marginalPsiParamsDomain,1)
    % Get the index of the entries we need to sum.
    % There should always be at least one entry.
    startTime = tic;
    index = find(IC == ii);
    if (isempty(index))
        error('Oops.')
    end
    
    % Now do the summing. Add to the entry of the posterior we're working
    % on, and bump counter.
    for kk = 1:length(index)
        marginalPosterior(ii,:) = marginalPosterior(ii,:) + posterior(index(kk),:);
        ICEntriesAccountedFor = ICEntriesAccountedFor + 1;
    end
    
    % This vectorized way seems like it would be faster, but
    % it is about twice as slow.  There is variation depending
    % on the input, though.
    % marginalPosterior1(ii,:) = sum(posterior(IC == ii,:),1);
end

% Check two ways of computing marginal
% 
% This check passsed whenI had it in
% if (any(marginalPosterior ~= marginalPosterior1))
%     error('Faster way not working right');
% end

% Every entry of the full posterior should have been added once.
if (ICEntriesAccountedFor ~= size(posterior,1))
    error('Did not marginalize properly');
end

% The marginal posterior should sum to unity.
posteriorSums = sum(marginalPosterior,1);
if (any(abs(posteriorSums-1) > 1e-8))
    error('At least one computed marginal posterior does not sum to 1');
end
