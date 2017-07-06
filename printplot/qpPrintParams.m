function qpPrintParams(params,varargin)
%qpPrintParams  Print out a parameters vector
%
% Usage:
%     qpPrintParams(params,varargin)

% Description:
%     Print out parameters vector.
%
% Input:
%     params          Row vector with parameters
%
% Output:
%     None
%
% Optional key/value pairs
%     None

% 6/25/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('params',@isnumeric);
p.parse(params,varargin{:});

%% Print out each inside of [ ]
fprintf('Parameters:[ ');
for jj = 1:length(params)
    if (jj > 1)
        fprintf(' ');
    end
    fprintf('%0.2g',params(jj));
end
fprintf(']\n');
end

