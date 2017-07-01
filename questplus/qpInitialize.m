%qpInitialize  Initialize the data structure for QUEST+ experiment.
%
% Usage:
%
% Description:
%     Initialize the data structure for QUEST+ experiment. The options
%     determine the configuration of the experiment. The function returns
%     a large data structure consisting of the elements:
%       data
%       posterior
%       posteriors
%       nextindex
%       xnext
%       likelihoood
%
% Inputs:
%
% Outputs:
%
% Optional key/value pairs

% {QpOutcome -> (SimulatedObserver[#1, 
%      QpPFWeibull, {-20, 3.5, 0.5, 0.02}] &), 
%  QpPNames -> {"Threshold (dB)", "Slope", "Guess", "Lapse"}, 
%  QpXNames -> {"Contrast (dB)"}, 
%  QpXSamples -> {{-40, -39, -38, -37, -36, -35, -34, -33, -32, -31, \
% -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, \
% -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1,
%      0}}, QpPSamples -> {{-40, -39, -38, -37, -36, -35, -34, -33, \
% -32, -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, \
% -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, \
% -3, -2, -1, 0}, {3.5}, {0.5}, {0.02}}, QpPsi -> QpPFWeibull, 
%  QpPrior -> "Constant", Verbose -> False}


% QpInitialize::usage = 
%   "QpInitialize[options___Rule]\nInitialize the data structure for a \
% QUEST+ experiment. The options determine the configuration of the \
% experiment. The function returns a large data structure consisting of \
% the elements: {data, posterior, posteriors, nextindex, xnext, depth, \
% likelihood, {options}}. When there is more than one condition, a \
% structure can be created for each.";
% 
% QpInitialize[options___Rule] := Block[
%   {pnames, xsamples, psamples, psi, outcome, prior, response, data, 
%    depth, nxd, npd, nld, likelihood, likexprior, probability, 
%    posteriors, entropies, nextindex, xnext, posterior, verbose},
%   
%   {xsamples, psamples, psi, response, prior, 
%     verbose} = {QpXSamples, QpPSamples, QpPsi, QpOutcome, QpPrior, 
%       Verbose} /. {options} /. Options[QuestPlus];
%   
%   data = {};
%   nxd = Length[xsamples];
%   npd = Length[psamples];
%   nld = nxd + npd + 1;
%   depth = nxd + 1;
%   If[prior === "Constant",
%    prior = UniformArray[Length /@ psamples]];
%   prior = Developer`ToPackedArray[prior];
%   likelihood = 
%    Chop[N[Outer[psi[Take[{##}, nxd], Drop[{##}, nxd]] &, 
%       Sequence @@ Join[xsamples, psamples]]]];
%   likelihood = Transpose[likelihood, RotateLeft[Range[nld]]];
%   likelihood = Developer`ToPackedArray[likelihood];
%   If[verbose, Print["samples = ", Times @@ Dimensions[likelihood]]];
%   posterior = prior;
%   xnext = nextindex = posteriors = 0;
%   {data, posterior, posteriors, nextindex, xnext, depth, 
%    likelihood, {options}}
%   ]