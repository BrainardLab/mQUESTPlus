% questNormCdfDemo  Demonstrates basic use of the QUEST procedure
%
% Description:
%    This script illustrates the Quest procedure using a simple example -
%    finding the mean of a cumulative Normal distribution.  This does not
%    actually use the mQUESTPlus toolbox; rather it is meant to illustrate
%    the method from scratch.  To that end,  all core functionality is
%    implemented in the script itself rather than external functions. The
%    code is intended for demonstration purposes, and it is not optimized
%    for speed. It follows the mQuestPlus notes from dhb, and in certain
%    places borrows from the mQUESTPlus implementation.
% 
%    This is set up so that it does the same thing as
%    qpQuestPlusNormCdfDemo, but that program uses mQUESTPlus.
%
% See also:
%    qpQuestPlusNormCdfDemo

% History: 
%    09/29/20  dce  - Wrote it, based on the mQUESTPlus code
%    10/06/20  dhb  - Debugging and comments.

% Clear and close
clear; close all;

% Define initial values 
cVec = linspace(0,1,100);  % Possible values for stimulus intensity, ranging from 0 to 1 
muVec = linspace(0,1,100); % Possible parameter values for the mean
sigma = 0.1;               % Known standard deviation
guessRate = 0;             % Defines chance performance at low stimulus levels

% Define the actual mean and the resulting cumulative Normal distribution 
true_mu = 0.2; 
true_pdf = guessRate + (1-guessRate)*normcdf(cVec,true_mu,sigma); 

% Define the prior. The first trial uses the uniform prior p_mu, but
% this is updated for later trials.
prior = unifpdf(muVec,muVec(1),muVec(end))*1/100; % Uniform prior for mu
if (abs(sum(prior)-1) > 1e-8)
    error('Posterior does not sum to 1');
end

% % Compute the probabilities by outcome for each c-mu combination:  
% % p (r |c_i,mu_j). The third dimension of arrays follow the convention 
% % [P(false), P(true)]. 
outcomeProbs = zeros(length(cVec),length(muVec),2); 
for i = 1:length(cVec)
    % Calculate probabilities for a given value of c at each value of mu
    pCorrect = guessRate + (1-guessRate)*normcdf(cVec(i),muVec,sigma);
    outcomeProbs(i,:,1) = 1-pCorrect;    % P(incorrect)
    outcomeProbs(i,:,2) = pCorrect;      % P(correct)
end

% Initialize arrays for storing data. 
nTrials = 64;              % Number of trials 
trials = zeros(nTrials,2); % Trial data with format [c, outcome]
posteriorsByOutcome = zeros(length(cVec),length(muVec),2); 
expected_entropies = zeros(length(cVec),1); 
 
% % Set up Quest+ functions for testing
% questData = qpInitialize('stimParamsDomainList',{0:0.0101:1}, ...
%     'psiParamsDomainList',{0:0.0101:1, 0.1, 0},'qpPF',@qpPFNormal);
% simulatedObserverFun = @(x) qpSimulatedObserver(x,@qpPFNormal,[true_mu, 0.1 0]);

% Loop through trials 
outcomeProbsByC = zeros(length(muVec),2);  
for kk = 1:nTrials   
    % Marginalize the outcome probabilities over mu using prior, to get the
    % outcome probabilities for a given stimulus value c_i.
    for i = 1:length(cVec)
        outcomeProbsByC(i,:) = sum(squeeze(outcomeProbs(i,:,:).*prior))';
    end
    if (any(abs(sum(outcomeProbsByC,2)-1) > 1e-8))
        error('Outcome probabilties do not sum to 1 for some contrast');
    end

    % Compute posteriors by outcome for each c-mu combination: p(mu_j|c_i,r). 
    % Values of c are in the row index, values of mu are in the column 
    % index, and the third dimension indexes outcomes 
    % [P(false),P(true)]. 
    for i = 1:length(cVec)
        for j = 1:length(muVec)
            for k = 1:2
                posteriorsByOutcome(i,j,k) = (outcomeProbs(i,j,k) .* prior(j)) ...
                    ./ sum(outcomeProbs(i,:,k) .* prior);
            end
        end
    end
    for i = 1:length(cVec)
        for k = 1:2
            if (any(abs(sum(squeeze(posteriorsByOutcome(i,:,k)))-1) > 1e-8))
                error('Table of posteriors does not sum to 1 for some contrast/outcome');
            end
        end
    end
    
    % Compute expected entropies for each stimulus.
    %
    % e_false is the entropy for an incorrect response, e_correct is the entropy
    % for a correct response, and expected_entropy is an average of the two
    % weighted by their probabilities.
    for i = 1:length(cVec)
        e_incorrect = -nansum(posteriorsByOutcome(i,:,1).*log2(posteriorsByOutcome(i,:,1)));
        e_correct = -nansum(posteriorsByOutcome(i,:,2).*log2(posteriorsByOutcome(i,:,2)));
        
        
        expected_entropies(i) = e_incorrect*outcomeProbsByC(i,1)+e_correct*outcomeProbsByC(i,2); 
    end
    
    % Select the value of c which leads to the minimum expected entropy. 
    % This will be the stimulus value for the next trial. 
    [~,minCInd] = min(expected_entropies);
    
    % Using the chosen value of c, simulate a trial by sampling from a 
    % multinomial distribution with outcome proportions [P(false), P(true)] 
    pCorrect = guessRate + (1-guessRate)*normcdf(cVec(minCInd),true_mu,sigma);
    trialOutcomeProportions = [1 - pCorrect, pCorrect];
    outcomeVector = mnrnd(1,trialOutcomeProportions); 
    outcome = find(outcomeVector);               
    
    % Now that the outcome has been determined, we know which of the
    % posteriors by outcome represents the actual posterior. This posterior
    % is used as the prior in subsequent trials. 
    posterior = posteriorsByOutcome(minCInd,:,outcome);
    prior = posterior; 
    trials(kk,:) = [cVec(minCInd),outcome]; % Update trials data 
    
    % Check that posterior/new prior sums to 1
    if (abs(sum(posterior)-1) > 1e-8)
        error('Posterior does not sum to 1');
    end
    
%     % For testing
%     qStim = qpQuery(questData);
%     qOutcome = simulatedObserverFun(qStim);
%     questData = qpUpdate(questData,qStim,qOutcome);
%     qPrior = questData.posterior; 
end

% Once all trials are completed, estimate the threshold as the maximum of
% the posterior. 
[~,threshInd] = max(posterior); 
estThresh = muVec(threshInd); 

% Plot results. Trials are shown as open circles, with x positions
% representing the value of c. Their y positions are either 0 (false) or 1
% (true). 
figure; 
hold on;
plot(cVec,true_pdf); 
plot(trials(:,1), trials(:,2)-1, 'o ');
plot(true_mu,0.5,'m*');
plot(estThresh,0.5,'g*');
legend('True pdf','Trials','True Mean','Estimated Mean'); 
title('Quest Trial Sequence');
xlabel('Stimulus Value'); 
ylabel('Probability'); 