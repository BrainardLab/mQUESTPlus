
function [marginalPosterior,marginalPsiParamsDomain,marginalLabels] = qpMarginalizePosterio(posterior,psiParamsDomain,whichParamsToMarginalize,labels)
% Marginalize a QUEST+ posterior
%
% Syntax:
%    [marginalPosterior,marginalPsiParamsDomain,marginalLabels] = qpMarginalizePosterio(posterior,psiParamsDomain,whichParamsToMarginalize,labels)
%
% Description:
%     Sum discretely sampled posterior over parameters indexed by whichParamsToMarginalize, to produce a
%     discretely sampled marginal posterior distribution. 
%
% Inputs:
%     posterior             - Column vector giving probability of each
%                             of N possible outcomes. This should sum to
%                             unity.
%     psiParamsDomain       - N by Nparams matrix. Each row gives the
%                             parameter values for the corresponding entry
%                             of the posterior.
%     whichParamsToMarginalize - Row vector giving K distinct indices in range
%                             [1,Nparams]. These specify the parameters to
%                             marginalize over.
%     labels                - Cell array of string names for each parameter.
%
% Outputs:
%     marginalPosterior     - Column vector giving probability of each
%                             of the M outcomes in the marginal posterior.
%     marginalPsiParamsDomain - M by NParams-K matrix. Each row gives the
%                             parameter values for the corresponding entry
%                             of the marginal posterior.
%     marginalLabels        - If labels passed, this is a cell array of the
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


%%  Get remaining index and handle labels if passed
remainingParamsIndex = setdiff(1:size(psiParamsDomain,2),whichParamsToMarginalize);
if (nargin > 3 && ~isempty(labels))
    marginalLabels = labels{remainingParamsIndex};
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
[marginalPsiParamsDomain,IA,IC] = unique(remainingPsiParamsDomain,'rows','stable');

%% Marginalize
%
% Initialize posterior with zeros, and also a counter for 
% a check.
marginalPosterior = zeros(size(marginalPsiParamsDomain,1),1);
ICEntriesAccountedFor = 0;

% For each entry in the marginal posterior domain,
% we sum up probabilities over the entries in the full
% posterior that correspond to each entry.
for ii = 1:size(marginalPsiParamsDomain,1)
    % Get the index of the entries we need to sum.
    % There should always be at least one entry.
    index = find(IC == ii);
    if (isempty(index))
        error('Oops.')
    end
    
    % Now do the summing. Add to the entry of the posterior we're working
    % on, and bump counter.
    for kk = 1:length(index)
        marginalPosterior(ii) = marginalPosterior(ii) + posterior(index(kk));
        ICEntriesAccountedFor = ICEntriesAccountedFor + 1;
    end
end

% Every entry of the full posterior should have been added once.
if (ICEntriesAccountedFor ~= length(posterior))
    error('Did not marginalize properly');
end

% The marginal posterior should sum to unity.
if (abs(sum(marginalPosterior(:))-1) > 1e-8)
    error('Marginal posterior does not sum to 1');
end
