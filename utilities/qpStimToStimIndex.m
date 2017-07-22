function stimIndex = qpStimToStimIndex(stim,stimDomain,varargin)
%qpStimToStimIndex  Find index of passed stimulus in the stimulus domain
%
% Usage:
%     stimIndex = qpStimToStimIndex(stim,stimDomain)
%
% Description:
%     Take the passed stimulus parameters (row vector) and find out which
%     row they are found in, in the passed stimDomain matrix.
%
%     Does not check if more than one row of stimDomain has the same value,
%     just returns the row of the first instance in this case.
%
%     Return 0 if stimulus is not found.
%
% Input:
%     stim           Row vector of stimulus parameters.
%
%     stimDomain     Matrix where each row describes one of the possible
%                    stimuli that quest is dealing with.   
%
% Output:
%     stimIndex      Row index into stimDomain where stimulus lives.  
%
% Optional key/value pairs
%     None
%
% See also: qpStimIndexToStim, qpFindNearestStimInDomain

% 7/22/17  dhb  Wrote it.

%% Initialize
nStim = size(stimDomain,1);
stimIndex = 0;

%% Search
for ii = 1:nStim
    if (all(stim == stimDomain(ii,:)))
        stimIndex = ii;
        return;
    end
end
