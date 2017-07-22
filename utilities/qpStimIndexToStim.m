function stim= qpStimIndexToStim(stimIndex,stimDomain,varargin)
%qpStimIndexToStim  Find stimulus in stimDomain corresonding to stimIndex
%
% Usage:
%     stim = qpStimIndexToStim(stimIndex,stimDomain)
%
% Description:
%     Take the passed stimulus index and grab out the stimulus.  This is
%     so trivial that it is not clear it is worth having a function, but
%     there you go.
%
% Input:
%     stimIndex      Row index into stimDomain where stimulus lives.  
%
%     stimDomain     Matrix where each row describes one of the possible
%                    stimuli that quest is dealing with.   
%
% Output:
%     stim           Row vector of stimulus parameters.
%
% Optional key/value pairs
%     None
%
% See also: qpStimToStimIndex, , qpFindNearestStimInDomain

% 7/22/17  dhb  Wrote it.

%% Grab stim
stim = stimDomain(stimIndex,:);
