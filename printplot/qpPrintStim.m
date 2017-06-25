function qpPrintStim(stim,varargin)
%qpPrintStim  Print out stimulus vector
%
% Usage:
%     qpPrintStim(stim,varargin)

% Description:
%     Print out stimulus vector.
%
% Input:
%     stim          Row vector with stimulus parameters

% Output:
%     None
%
% Optional key/value pairs
%     None

% 6/25/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stim',@isnumeric);
p.parse(stim,varargin{:});

%% Print out each  inside of [ ]
fprintf('Stimulus:[ ');
for jj = 1:length(stim)
    if (jj > 1)
        fprintf(' ');
    end
    fprintf('%0.2g',stim(jj));
end
fprintf(']\n');
end

