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
%     n              Number of trials
%     p              Probability or likelihood
%
% Output:
%     nLogP          n*log(p)
%                      Returns -1*real max if p == 0 && n > 0.
%                      Returns 0 if p == 0 && n == 0.
%
% Optional key/value pairs
%     None

% 6/27/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('n',@isscalar);
p.addRequired('p',@isscalar);
p.parse(n,p,varargin{:});

%% Sanity check
if (n < 0)
    error('n must be non-negative');
end
if (p < 0)
    error('p must be non-negative');
end

%% Follow the conditionals
if (p > 0)
    nLogP = n*log(p);
else
    if (n > 0)
        nLogP = -1*realmax;
    else
        nLogP = 0;
    end
end

%% Mathematica original code
%
% QpNLogP[n_, p_] :=
%  If[p > 0, n Log[p], If[n > 0, -$MaxMachineNumber, 0]]