function paramsOK = qpPairwiseStimCheck(stimParams)
% qpPairwiseStimCheck  stim params check
%
% Usage:
%     paramsOK = qpPairwiseStimCheck(psiParams)
%
% Description:
%     Check whether passed parameters are valid for qpPFRating
%
% Inputs:
%     psiParams      See qpPFRating.
%
% Output:
%     paramsOK       Boolean, true if parameters are OK and false otherwise.

% 02/07/18  mna  Wrote it.

%% Check that x1 is larger than x2
paramsOK = (diff(stimParams,1,2) < 0);

