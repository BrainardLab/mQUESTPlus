function [stimIndex,stimParams] = qpQuery(questData)
% qpQuery  Use questData structure to get next recommended stimulus index and stimulus
%
% Usage:
%     [stimIndex,stimParams] = qpQuery(questData)
%
% Description:
%     Use questData structure to get next recommended stimulus index and stimulus.
%     The data structure is assumed to be up to date, as after a call to
%     qpUpdate.
%
% Inputs:
%     questData              The questData structure.  See qpParams, qpInitialize and qpUpdate for
%                            description of what is in this structure.
%
% Outputs:
%     stimIndex              Row index into questData.stimParamsDomain field for next recommended stimulus.
% 
%     stimParams             The corresponding row vector stimulus parameters.
%
% Optional key/value pairs:
%   None.
%
% See also: qpParams, qpInitialize, qpUpdate, qpRun.

%% Find minimum entropy stimulus entry and get stimulus from index
stimIndex = qpListMinArg(questData.expectedNextEntropiesByStim);
stimParams = questData.stimParamsDomain(stimIndex,:);

end
