function nLogP = qpNLogP(n,p,varargin)
%qpNLogP  Compute n*log(p) and handle cases where one or both args are zero.
%
% Usage:
%     stimData = qpNLogP(trialData)
%
% Description:
%     Compute n*log(p) and handle cases where one or both args are zero.
%
% Input:
%     n              Number of trials.  Can be a number, vector or match.
%     p              Probability. Needs to be the same size as n.
%
%     Both n and p must contain non-negative values.
%
% Output:
%     nLogP          n*log(p).  Same size as n and p.  For each entry:
%                      Returns -1*real max if p == 0 && n > 0.
%                      Returns 0 if p == 0 && n == 0.
%
% Optional key/value pairs
%     None

% 6/27/17  dhb  Wrote it.

%% Parse input
theP = inputParser;
theP.addRequired('n',@isnumeric);
theP.addRequired('p',@isnumeric);
theP.parse(n,p,varargin{:});

%% Sanity check
if (any(n < 0))
    error('Each passed n must be non-negative');
end
if (any(p < 0))
    error('Each passed p must be non-negative');
end
sizeN = size(n);
sizeP = size(p);
if (length(sizeN) ~= length(sizeP) | any(sizeN ~= sizeP))
    error('Passed n and p must have the same size');
end

%% Follow the conditionals
nLogP = n.*log(p);
index = p == 0 & n > 0;
nLogP(index) = -1*realmax;
index = p == 0 & n == 0;
nLogP(index) = 0;

%% Mathematica original code
%
% QpNLogP[n_, p_] :=
%  If[p > 0, n Log[p], If[n > 0, -$MaxMachineNumber, 0]]