function paramEstimates = qpFit(trialData,qpPF,varargin)
%qpFit  Fit a psychometric function to a set of data 
%
% Usage:
%     paramEstimates = qpFit(tria.lData,qpPF,varargin)
%
% Description:
%     Maximum likelihood fit of parameters to the data.  This is performed
%     using numerical optimization, with Matlab's fmincon.
%
% Input:
%     trialData      A trial data struct array:
%                      trialData(i).stim - Row vector of stimulus parameters.
%                      trialData(i).outcome - Outcome of the trial.
%
%     qpPF           Handle to a qpPF routine (e.g. qpPFWeibull).   
%
% Output:
%     paramEstimates Row vector of parameter estimates.
%
% Optional key/value pairs
%     None

% 6/27/17  dhb  Wrote it.

%% Parse input
p = inputParser;
p.addRequired('trialData',@isstruct);
p.addRequired('qpPF',@(x) isa(x,'function_handle'));
p.parse(trialData,qpPF,varargin{:});

% QpFit::usage = 
%   "QpFit[result_,options___Rule]\n Fits a psychometric function to a \
% set of data. The input is the structure returned by QuestPlus. It \
% responds to the QuestPlus options QpPSamples and QpPsi. The function \
% accepts any number of outcomes and of stimulus dimensions.";
% 
% QpFit[result_, options___Rule] := 
%  Block[{fit, names, psamples, constraints, psi, pbounds, counts, 
%    noutcomes},
%   {psamples, psi} = {QpPSamples, QpPsi} /. {options} /. 
%     Options[QuestPlus];
%   noutcomes = Max[result[[2, All, 2]]];
%   pbounds = MinMax /@ psamples;
%   counts = QpCounts[QpData[result[[2]]], noutcomes];
%   names = Symbol["QpTmp" <> ToString[#]] & /@ Range[Length[pbounds]];
%   constraints = 
%    MapThread[(#2[[1]] <= #1 <= #2[[2]]) &, {names, pbounds}];
%   fit = NMaximize[{QpLogLikelihoodNumeric[counts, psi, names], 
%      constraints}, names];
%   names /. fit[[2]]]