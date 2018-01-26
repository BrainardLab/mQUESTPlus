function expectedNextEntropiesByStim = qpUpdateExpectedNextEntropiesByStim(questData)
% qpUpdateExpectedNextEntropiesByStim  Update the table of expected next entropies for each stimulus
%
% Usage:
%     expectedNextEntropiesByStim = qpUpdateExpectedNextEntropiesByStim(questData)
%
% Description:
%     Uses posterior and precomputed elements of questData to update the
%     table that gives expected entropy after a trial of each stimulus in
%     the stimulus parameter domain.
%
%     This is broken out into a separate routine so we can call it both
%     from qpInitialize and qpUpdate.
%
%     This in fact the guts of the QUEST+ method.
%
% Input:
%     questData                           The questData structure.
%
% Output:
%     expectedNextEntropiesByStim         The updated table.
%
% Optional key/value pairs
%   None

% 07/04/17  dhb  Try to make this faster using profile.
% 01/26/18  dhb  Vectorized/profiled to optimize execution time.

%% Compute the expected outcomes for each stimulus by averaging over the posterior.
%   
% This is vectorized and reasonably optimized. The precompued variable is
% also used below.
precomputedPosteriorTimesProportions = ...
    bsxfun(@times,questData.posterior',questData.precomputedOutcomeProportions);
expectedOutcomesByStim = squeeze(sum(precomputedPosteriorTimesProportions,2));

%% Compute the entropy for each outcome
%
% This is the entropy we'd get if we run a trial and update assuming that
% outcome. Given an outcome, we can say what the posterior will be.  From
% that we can compute the expected entropy given that outcome.  We do this
% here.

% This takes advantage of the precomputed variable from above.
%
% Vectorizing the loop might gain a little time, but qpUnitizeArray and
% qpArrayEntropy each only know about 2-D matrices.  Usually nOutcomes is
% small, so the loop doesn't cost too much.
nextEntropiesByStimOutcome = zeros(questData.nStimParamsDomain,questData.nOutcomes);
for oo = 1:questData.nOutcomes
    nextPosteriorsByStimOutcome1 = qpUnitizeArray(precomputedPosteriorTimesProportions(:,:,oo)');
    nextEntropiesByStimOutcome(:,oo) = qpArrayEntropy(nextPosteriorsByStimOutcome1);
end

%% Compute the expected entropy for each stimulus by averaging entropies over each outcome
%
% For each stimulus, we know the probability of each outcome from the first calculation above.
% And for each outcome, we know the entropy we'd get.  So we can get the expected entropy
% corresponding to each stimulus, which is what we want.
expectedNextEntropiesByStim = sum(expectedOutcomesByStim .* nextEntropiesByStimOutcome,2);

end
