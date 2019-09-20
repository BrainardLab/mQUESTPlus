function stimIndex = qpStimToStimIndex(stim,stimDomain,varargin)
%qpStimToStimIndex  Find index of passed stimulus in the stimulus domain
%
% Usage:
%     stimIndex = qpStimToStimIndex(stim,stimDomain)
%
% Description:
%     Take the passed stimulus parameters (row vector) and find out which
%     row they are found in, in the passed stimDomain matrix.  If there
%     is just one parameter, stimDomain must be a column vector and stim
%     stim is a scalar.
%
%     Does not check if more than one row of stimDomain has the same value,
%     just returns the row of the first instance in this case.
%
%     Comparison is done to precision significant digits to avoid numerical
%     precision weirdness.  Precision is set to 10 currently.
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

% 07/22/17      dhb  Wrote it.
% 09/19/19      dhb  Added Josh Solomon's fix for handling small numerical
%                    error in specification of stimDomain.
% 09/20/19      dhb  Move to 'significant' type in round, more robust I
%                    think.

% Examples:
%{
    stimDomain = (-5:0.2:0)';
    stim = -3.6;
    qpStimToStimIndex(stim,stimDomain)
%}

%% Initialize
nStim = size(stimDomain,1);
stimIndex = 0;
precision = 10;

%% Search
for ii = 1:nStim
    if (all(round(stim,precision,'significant') == round(stimDomain(ii,:),precision,'significant')))
        stimIndex = ii;
        return;
    end
end
