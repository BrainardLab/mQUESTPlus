function predictedProportions = qpPFWeibull(stimParams,psiParams)
%qpPFUTM  Uncertain template matching psychometric function
%
% Usage:
%     predictedProportions = qpPFUTM(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for the UTM psychometric
%     function described by Geisler, W. S. (2018), "Psychomtric functions of
%     uncertain template matching observers", Journal of Vision, 18(2):1,
%     1-10.
%
%     This function implements equation 17 of the paper, with the addition
%     of guess and lapse parameters.
%
% Input:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here the row vector is just a single number giving
%                    the stimulus level.
%
%     psiParams      Row vector or matrix of parameters
%                      alpha      Alpha parameter
%                      beta       Beta parameter
%                      guess      Guess rate
%                      lapse      Lapse rate
%                      u          Stimulus origin
%                    Parameterization of alpha, beta, and matches Equation
%                    Parameterization of alpha, beta, and matches Equation
%                    17 of Geisler 2018.  Psychomtric function ranges from
%                    guess to lapse.
%
% Output:
%     predictedProportions  Matrix, where each row is a vector of predicted proportions
%                           for each outcome.
%                             First entry of each row is for no/incorrect (outcome == 1)
%                             Second entry of each row is for yes/correct (outcome == 2)
%
% Optional key/value pairs
%     None

% 02/04/18  dhb  Wrote it.

%% Here is the Matlab version
if (size(psiParams,2) ~= 4)
    error('Parameters vector has wrong length for qpPFWeibull');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
threshold = psiParams(:,1);
slope = psiParams(:,2);
guess = psiParams(:,3);
lapse = psiParams(:,4);
nStim = size(stimParams,1);
predictedProportions = zeros(nStim,2);

%% Compute, handling the two calling cases.
if (length(threshold) > 1)
    if (length(threshold) ~= nStim )
        error('Number of parameter vectors passed is not one and does not match number of stimuli passed');
    end
    
    for ii = 1:nStim 
        p1 = lapse(ii) - (guess(ii) + lapse(ii) - 1)*exp(-10^(slope(ii)*(stimParams(ii) - threshold(ii))/20));
        predictedProportions(ii,:) = [p1 1-p1];
    end 
else
    for ii = 1:nStim
        p1 = lapse - (guess + lapse - 1)*exp(-10^(slope*(stimParams(ii) - threshold)/20));
        predictedProportions(ii,:) = [p1 1-p1];
    end 
end
