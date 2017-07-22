function nearestStim = qpFindNearestStimInDomain(stim,stimDomain,varargin)
%qpFindNearestStimInDomain  Find stimulus in the stimulus domain nearest to the passed stimulus
%
% Usage:
%     nearestStim = qpFindNearestStimInDomain(stim,stimDomain)
%
% Description:
%     Take the passed stimulus parameters (row vector) and find out which
%     stimulus with the domain is nearest to it, in a squared error sense.
%
% Input:
%     stim           Row vector of stimulus parameters.
%
%     stimDomain     Matrix where each row describes one of the possible
%                    stimuli that quest is dealing with.   
%
% Output:
%     nearestStim    Row vector of nearest stim params.  
%
% Optional key/value pairs
%     None
%
% See also: qpStimIndexToStim, qpStimToStimIndex

% 7/22/17  dhb  Wrote it.

%% Initialize
nStim = size(stimDomain,1);
minDistance = Inf;

%% Search
for ii = 1:nStim
    theDistance = norm(stim-stimDomain(ii,:));
    if (theDistance < minDistance)
        minDistance = theDistance;
        nearestStim = stimDomain(ii,:);
    end
end
