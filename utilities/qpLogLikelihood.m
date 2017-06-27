function logLikelihood = qpLogLikelihood(stimCounts,qpPF,paramsVec,varargin)
%qpLogLikelihood  Compute log likelihood of listed outcomes 
%
% Usage:
%     logLikelihood = qpLogLikelihood(stimCounts,psiFunction,paramsVec)
%
% Description:
%     Compute log likelihood of the data in stimCounts, with respect to the
%     passed psychometric function and paramsVec. 
%
% Input:
%     stimCounts     A struct array with each stimulus value presented
%                    in sorted order, and a vector of the counts of each possible
%                    outcome type that happened on trials for that stimulus value:
%                      stimCounts(i).stim - Row vector of stimulus parameters
%                      stimCounts(i).outcomeCounts - Row vector of length
%                        nOutcomes with the number of times each outcome
%                        happend for the given stimulus.
%
%     psiPF          Handle to a qpPF routine (e.g. qpPFWeibull).   
%
%     paramsVec      Row vector of parameters for the passed psychometric
%                    function.
%
% Output:
%     logLikelihood  Log likelihood of the data.
%
% Optional key/value pairs
%     None

% 6/27/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stimCounts',@isstruct);
p.addRequired('qpPF',@(x) isa(x,'function_handle'));
p.addRequired('paramsVec',@isnumeric);
p.parse(stimCounts,qpPF,paramsVec,varargin{:});

%% Get stimulus matrix with parameters along each column.
%
stimDim = size(stimCounts(1).stim,2);
if (stimDim == 1)
    stimMat = [stimCounts.stim]';
else
    stimMat = [stimCounts.stim];
end

%% Get predicted proportions for each stimulus
predictedProportions = qpPF(stimMat,paramsVec);

%% Sum up the log likelihood

logLikelihood = 0;
nStim = length(stim
for ii = 1:nStim


% QpLogLikelihood::usage = 
%   "QpLogLikelihood[data_,psi_,parameters_List]\nCompute the log \
% likelihood of a set of data, given a psychometric function and a set \
% of parameters. Data is a list of the form returned by QpCounts.";
% 
% QpLogLikelihood[counts_, psi_, parameters_List] := Block[{p},
%   p =  N[psi[#, parameters]] & /@ counts[[All, 1]];
%   Total[MapThread[QpNLogP, {counts[[All, 2]], p}, 2], Infinity]]

