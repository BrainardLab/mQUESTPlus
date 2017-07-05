function logLikelihood = qpLogLikelihood(stimCounts,qpPF,psiParams,varargin)
%qpLogLikelihood  Compute log likelihood of listed outcomes 
%
% Usage:
%     logLikelihood = qpLogLikelihood(stimCounts,qpPF,psiParams)
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
%     qpPF           Handle to a qpPF routine (e.g. qpPFWeibull).   
%
%     psiParams      Row vector of parameters for the passed psychometric
%                    function.
%
% Output:
%     logLikelihood  Log likelihood of the data.
%
% Optional key/value pairs
%     check  boolean (false) - Run some checks on the data upacking. Slows
%                             things down.

% 6/27/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('stimCounts',@isstruct);
p.addRequired('qpPF',@(x) isa(x,'function_handle'));
p.addRequired('psiParams',@isnumeric);
p.addParameter('check',false,@islogical);
p.parse(stimCounts,qpPF,psiParams,varargin{:});

%% Get number of stimuli, stimulus parameter dimension and number of outcomes
nStim = size(stimCounts,1);
stimDim = size(stimCounts(1).stim,2);
nOutcomes = length(stimCounts(1).outcomeCounts);

%% Get stimulus matrix with parameters along each column.
%
if (stimDim == 1)
    stimMat = [stimCounts.stim]';
else
    stimMat = reshape([stimCounts.stim],stimDim,nStim)';
end

%% Get predicted proportions for each stimulus
predictedProportions = qpPF(stimMat,psiParams);

%% Get the outcomes
%
% The reshape here might require a little tweaking.  It is slick but
% tricky.
nStim = length(stimCounts);
outcomeCounts = reshape([stimCounts(:).outcomeCounts],nOutcomes,nStim)';

% Here is a slower way to do it, but that seems likely to be correct
if (p.Results.check)
    outcomeCounts1 = zeros(nStim,nOutcomes);
    for ii = 1:nStim
        outcomeCounts1(ii,:) = stimCounts(ii).outcomeCounts;
    end
    if (any(outcomeCounts ~= outcomeCounts1))
        error('Two ways of unpacking outcome counts do not match.');
    end
end

% Compute the log likilihood
nLogP = qpNLogP(outcomeCounts,predictedProportions);
logLikelihood = sum(nLogP(:));

% Mathematica original
%
% QpLogLikelihood::usage = 
%   "QpLogLikelihood[data_,psi_,parameters_List]\nCompute the log \
% likelihood of a set of data, given a psychometric function and a set \
% of parameters. Data is a list of the form returned by QpCounts.";
% 
% QpLogLikelihood[counts_, psi_, parameters_List] := Block[{p},
%   p =  N[psi[#, parameters]] & /@ counts[[All, 1]];
%   Total[MapThread[QpNLogP, {counts[[All, 2]], p}, 2], Infinity]]

