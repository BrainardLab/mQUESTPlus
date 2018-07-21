function outcome = qpSimulatedObserver(stimParams,qpPF,psiParams,varargin)
%qpSimulatedObserver  Simulate a trial of an experiment for a passed psychometric funtion 
%
% Usage:
%     outcome = qpSimulatedObserver(stimParams,qpPF,psiParams
%
% Description:
%     Simulate a trial of an experiment to produce an outcome.
%
% Input:
%     stimParams     Row vector of stimulus parameters
%
%     qpPF           Handle to a qpPF routine (e.g. qpPFWeibull).   
%
%     psiParams      Row vector of parameters for the passed psychometric
%                    function.
%
% Output:
%     outcome        Integer specifying outcome, integer in range 1 to N
%                    where N is the number of possible outcomes.  The
%                    number and meaning of the outcomes is determined by
%                    the passed psychometric funtion.
%
% Optional key/value pairs
%     None.

% 6/27/17  dhb  Wrote it.
% 6/22/18  dhb  Improve help comments.

%% Parse input
p = inputParser;
p.addRequired('stimParams',@isnumeric);
p.addRequired('qpPF',@(x) isa(x,'function_handle'));
p.addRequired('psiParams',@isnumeric);
p.parse(stimParams,qpPF,psiParams,varargin{:});

outcomeProportions = qpPF(stimParams,psiParams);
outcomeVector = mnrnd(1,outcomeProportions);
outcome = find(outcomeVector);