function [vlb, vub] = qpGetBoundsFromDomainList(domainList)
% Get parameter bounds from cell array of domain for each parameter
%
% Syntax:
%   [vlb, vub] = qpGetBoundsFromDomainList(domainList)
%
% Description:
%    Determine lower and upper parameter bound for each parameter from the
%    domain list.
%
% Inputs:
%    domainList                           - Cell array where each entry is
%                                           the domain for the
%                                           corresponding parameter, in the
%                                           form used by qpInitialize.
%
% Outputs:
%    vlb                                  - Lower bound in row vector form.
%    vub                                  - Upper bound in row vector form.
%
% Optional key/value pairs:
%    None.
%
% See also:  qpDrawFromDomainList, qpInitialize
%

% History:
%   08/25/19  dhb  Wrote it

% Examples:
%{
    psiParamsDomainList = {0, 0, -20:5:20, -20:5:20, 0, -4:1:4, -4:1:4, 0, 0.02};
    [vlb, vub] = GetBoundsFromDomainList(psiParamsDomainList)
%}

for ii = 1:length(domainList)
    vlb(ii) = min(domainList{ii});
    vub(ii) = max(domainList{ii});
end