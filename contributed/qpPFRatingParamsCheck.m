function paramsOK = qpPFRatingParamsCheck(psiParams)
% qpPFRatingParamsCheck  Parameter check for qpPFRating
%
% Usage:
%     paramsOK = qpPFRatingParamsCheck(psiParams)
%
% Description:
%     Check whether passed parameters are valid for qpPFRating
%
% Inputs:
%     psiParams      See qpPFRating.
%
% Output:
%     paramsOK       Boolean, true if parameters are OK and false otherwise.

% 08/18/18  mna  Wrote it.

%% Assume ok
paramsOK = true;

%% Check that sd is non-negative
if (psiParams(1) < 0)
    paramsOK = false;
end

%% Check whether boundary parameters are OK
%
% This is signaled by returning NaN when the boundaries are
% not in increasing order.
[boundaries,sortIndex] = sort(psiParams(2:end),'ascend');
nOutcomes = length(boundaries);
if (any(sortIndex ~= 1:nOutcomes))
    paramsOK = false;
end

