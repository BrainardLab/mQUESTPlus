function f = qpFitError(psiParams,stimCounts,qpPF)
% Error function minimized by qpFit to minimize
% 
% Syntax:
%     f = qpFitError(psiParams,stimCounts,qpPF)
%
% Description:
%     Compute negative log likelihood of the data given the parameters
%     and the psychometric function.  Used by qpFit but may be called
%     directly.
%
% Inputs:
%     psiParams        Psychometric function parameters.
%     stimCounts       Obtained from qp trial data structure via
%                        qpCounts(qpData(trialData),nOutcomes);
%     qpPF             Handle to a qpPF routine (e.g. qpPFWeibull).
%   
% Outputs:
%    f                The negative log likelihood (natural log)

% History:
%   03/14/18  dhb  Pulled out of qpFit so we can call it directly.

logLikelihood = qpLogLikelihood(stimCounts,qpPF,psiParams);

%% Handle case where search has wandered into an invalid portion of the parameter spact
%
% qpPF can return NaN to signal this, and that is propagated back through the logLikelihood.
if (isnan(logLikelihood))
    f = realmax;
else
    f = -logLikelihood;
end

end