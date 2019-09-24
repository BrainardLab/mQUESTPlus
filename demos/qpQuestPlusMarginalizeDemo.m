function qpQuestPlusMarginalizeDemo
%qpQuestPlusMarginalizeDemo  Show how to margnialize over nuisance parameters
%
% Description:
%    This script shows how to initialize quest so that it optimizes
%    information about some of the PF parameters, by marginalizing the
%    posteriors computed as part of obtaining the expected entrop after the
%    next trial.  The idea is to marginalize over nuisance parameters (e.g.
%    lapse rate) that are not of interest.
%
%    The simulation is looped over, with parameters drawn from the prior
%    provided to quest on each loop, and the results of running both a
%    marginalized and not marginalized (normal) version of quest are
%    compared.
%
%    For the example here, the marginalized quest does a little einsy bit
%    better in a squared error sense.
%
%    The script also compares various ways of making a post estimate at
%    the end of a run.  Using the posterior mean works best in a squared
%    error sense, although as with marginalized versus not marginalized
%    quest, the difference is small in an absolute sense.
%

%% Close old figures
close all;

%% Initialize
%
% Set parameters, using key value pairs to override defaults
% as needed.  (See "help qpParams" for what is available.)
%
% Here we set the range for the stimulus (contrast in dB) and the
% psychometric function parameters (see qpPFWeibull).
%
% Note that the space on which the stimulus is gridded affects the
% prior used by QUEST+.  QUEST+ assigns equal probability to each
% listed stimulus, so that the prior implied if you grid contrast in
% dB is different from that if you grid contrast on a linear scale.
%
% Key thing in this call is the 'marginalize' key/value pair.  The passed
% vector of indices gives which parameters in the psiParamsDomainList to
% marginalize over.  The slope and lapse reat
psiParamsDomainList = {-40:0, 1:5, 0.5, 0:0.01:0.1};
questDataMarginalizedRaw = qpInitialize('stimParamsDomainList',{[-40:1:0]}, ...
    'psiParamsDomainList',psiParamsDomainList,'marginalize',[2 4]);

% Also do it in the standard quest manner
questDataNotMarginalizedRaw = qpInitialize('stimParamsDomainList',{[-40:1:0]}, ...
    'psiParamsDomainList',psiParamsDomainList);

% Freeze random number generator so output is repeatable
rng('default'); rng(2004,'twister');
nParamSets = 50;
nRunsPerParamSet = 1;
nTrials = 64;

%% Simulate over and over and over
[domainVlb,domainVub] = qpGetBoundsFromDomainList(psiParamsDomainList);
for ss = 1:nParamSets
    % Set up parameters for this run by random draw.  But keep noise
    % fixed, as we can probably establish that separately. We define
    % the simulated observer fun here so it has the right parameters each
    % time through the loop.
    simulatedPsiParamsVecCell{ss} = qpDrawFromDomainList(psiParamsDomainList);
    simulatedPsiParamsVec = simulatedPsiParamsVecCell{ss};
    simulatedObserverFun = @(stimParamsVec) qpSimulatedObserver(stimParamsVec,@qpPFWeibull,simulatedPsiParamsVec);
    
    % Do the runs
    for rr = 1:nRunsPerParamSet
        % Simulate run
        fprintf('*** Simluated run %d of %d for parameters set %d of %d:\n',rr,nRunsPerParamSet,ss,nParamSets);
        
        % Get a fresh quest structure
        questDataMarginalized{ss,rr} = questDataMarginalizedRaw;
        questDataNotMarginalized{ss,rr} = questDataNotMarginalizedRaw;
        
        % Run simulated trials, using QUEST+ to tell us what contrast to
        % use
        for tt = 1:nTrials
            % Simulate marginalized trial
            stim = qpQuery(questDataMarginalized{ss,rr});
            outcome = simulatedObserverFun(stim);
            questDataMarginalized{ss,rr} = qpUpdate(questDataMarginalized{ss,rr},stim,outcome);
            
            % Simulate non marginalized trial
            stim = qpQuery(questDataNotMarginalized{ss,rr});
            outcome = simulatedObserverFun(stim);
            questDataNotMarginalized{ss,rr} = qpUpdate(questDataNotMarginalized{ss,rr},stim,outcome);
        end
        
        % Find out QUEST+'s estimate of the stimulus parameters,
        % marginalized version.  There are various ways to make the
        % estimate.  
        %
        % Note that the mean of the posterior and the mean of the
        % marginalized posterior are the same for parameters they have
        % in common.
        %
        % Max of posterior
        tempIndex = qpListMaxArg(questDataMarginalized{ss,rr}.posterior);
        posteriorMaxMarginalized{ss,rr} = questDataMarginalized{ss,rr}.psiParamsDomain(tempIndex,:);
        
        % Mean of posterior
        posteriorMeanMarginalized{ss,rr} = ...
            qpPosteriorMean(questDataMarginalized{ss,rr}.posterior,questDataMarginalized{ss,rr}.psiParamsDomain);
        
        % Max/mean of marginal posterior
        [marginalPosterior,marginalPsiParamsDomain] = ...
            qpMarginalizePosterior(questDataMarginalized{ss,rr}.posterior,questDataMarginalized{ss,rr}.psiParamsDomain, ...
            questDataMarginalized{ss,rr}.marginalize);
        tempIndex = qpListMaxArg(marginalPosterior);                 
        marginalPosteriorMaxMarginalized{ss,rr} = marginalPsiParamsDomain(tempIndex,:);
        marginalPosteriorMeanMarginalized{ss,rr} = qpPosteriorMean(marginalPosterior,marginalPsiParamsDomain);
        
        % Maximum likelihood fit
        maxLikeliFitMarginalized{ss,rr} = qpFit(questDataMarginalized{ss,rr}.trialData,questDataMarginalized{ss,rr}.qpPF, ...
            posteriorMaxMarginalized{ss,rr},questDataMarginalized{ss,rr}.nOutcomes,...
            'lowerBounds',domainVlb,'upperBounds',domainVub);
        % fprintf('\tSimulated parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
        %     simulatedPsiParamsVec(1),simulatedPsiParamsVec(2),simulatedPsiParamsVec(3),simulatedPsiParamsVec(4));
        % fprintf('\tMax posterior QUEST+ parameters, marginalized: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
        %     psiParamsQuestMarginalized{ss,rr}(1),psiParamsQuestMarginalized{ss,rr}(2),psiParamsQuestMarginalized{ss,rr}(3),psiParamsQuestMarginalized{ss,rr}(4));
        % fprintf('\tMaximum likelihood fit parameters, marginalized: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
        %     psiParamsFitMarginalized{ss,rr}(1),psiParamsFitMarginalized{ss,rr}(2),psiParamsFitMarginalized{ss,rr}(3),psiParamsFitMarginalized{ss,rr}(4));
        % fprintf('\tMarginal posterior mean, marginalized: %0.1f\n',posteriorMeanMarginalized{ss,rr}(1));
        
        % And then same estimates for the not marginalized version
        tempIndex = qpListMaxArg(questDataNotMarginalized{ss,rr}.posterior);
        posteriorMaxNotMarginalized{ss,rr} = questDataNotMarginalized{ss,rr}.psiParamsDomain(tempIndex,:);
        posteriorMeanNotMarginalized{ss,rr} = ...
            qpPosteriorMean(questDataNotMarginalized{ss,rr}.posterior,questDataNotMarginalized{ss,rr}.psiParamsDomain);
        [marginalPosterior,marginalPsiParamsDomain] = ...
            qpMarginalizePosterior(questDataNotMarginalized{ss,rr}.posterior,questDataNotMarginalized{ss,rr}.psiParamsDomain, ...
            questDataMarginalized{ss,rr}.marginalize);
        tempIndex = qpListMaxArg(marginalPosterior);                 
        marginalPosteriorMaxNotMarginalized{ss,rr} = marginalPsiParamsDomain(tempIndex,:);
        marginalPosteriorMeanNotMarginalized{ss,rr} = qpPosteriorMean(marginalPosterior,marginalPsiParamsDomain);
        maxLikeliFitNotMarginalized{ss,rr} = qpFit(questDataNotMarginalized{ss,rr}.trialData,questDataNotMarginalized{ss,rr}.qpPF, ...
            posteriorMaxNotMarginalized{ss,rr},questDataNotMarginalized{ss,rr}.nOutcomes,...
            'lowerBounds',domainVlb,'upperBounds',domainVub);
        % fprintf('\tMax posterior QUEST+ parameters, not marginalized: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
        %     psiParamsQuestNotMarginalized{ss,rr}(1),psiParamsQuestNotMarginalized{ss,rr}(2),psiParamsQuestNotMarginalized{ss,rr}(3),psiParamsQuestNotMarginalized{ss,rr}(4)); 
        % fprintf('\tMaximum likelihood fit parameters, not marginalized: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
        %     psiParamsFitNotMarginalized{ss,rr}(1),psiParamsFitNotMarginalized{ss,rr}(2),psiParamsFitNotMarginalized{ss,rr}(3),psiParamsFitNotMarginalized{ss,rr}(4));
        % fprintf('\tMarginal posterior mean,not marginalized %0.1f\n',posteriorMeanNotMarginalized{ss,rr}(1));
    end
end

%% Put key values in vector form for error computation
inIndex = 1;
for ss = 1:nParamSets
    for rr = 1:nRunsPerParamSet
        simulatedThresh(inIndex) = simulatedPsiParamsVecCell{ss}(1);
        posteriorMaxMarginalizedThresh(inIndex) = posteriorMaxMarginalized{ss,rr}(1);
        posteriorMeanMarginalizedThresh(inIndex) = posteriorMeanMarginalized{ss,rr}(1);
        marginalPosteriorMaxMarginalizedThresh(inIndex) = marginalPosteriorMaxMarginalized{ss,rr}(1);
        marginalPosteriorMeanMarginalizedThresh(inIndex) = marginalPosteriorMeanMarginalized{ss,rr}(1);
        maxLikeliFitMarginalizedThresh(inIndex) = maxLikeliFitMarginalized{ss,rr}(1);
        
        posteriorMeanNotMarginalizedThresh(inIndex) = posteriorMeanNotMarginalized{ss,rr}(1);
        posteriorMaxNotMarginalizedThresh(inIndex) = posteriorMaxNotMarginalized{ss,rr}(1);
        marginalPosteriorMaxNotMarginalizedThresh(inIndex) = marginalPosteriorMaxNotMarginalized{ss,rr}(1);
        marginalPosteriorMeanNotMarginalizedThresh(inIndex) = marginalPosteriorMeanNotMarginalized{ss,rr}(1);
        maxLikeliFitNotMarginalizedThresh(inIndex) = maxLikeliFitNotMarginalized{ss,rr}(1);
        inIndex = inIndex+1;
    end
end

%% Check some theory
if (any(abs(posteriorMeanMarginalizedThresh-marginalPosteriorMeanMarginalizedThresh) > 1e-7))
    error('Do not understand mean estimates, marginalized and not');
end
if (any(abs(posteriorMeanNotMarginalizedThresh-marginalPosteriorMeanNotMarginalizedThresh) > 1e-7))
    error('Do not understand mean estimates, marginalized and not');
end

%% Compute rmse estimation error and print out
posteriorMaxMarginalizedErr = sqrt(sum((simulatedThresh(:) - posteriorMaxMarginalizedThresh(:)).^2)/length(simulatedThresh));
posteriorMeanMarginalizedErr = sqrt(sum((simulatedThresh(:) - posteriorMeanMarginalizedThresh(:)).^2)/length(simulatedThresh));
marginalPosteriorMaxMarginalizedErr = sqrt(sum((simulatedThresh(:) - marginalPosteriorMaxMarginalizedThresh(:)).^2)/length(simulatedThresh));
marginalPosteriorMeanMarginalizedErr = sqrt(sum((simulatedThresh(:) - marginalPosteriorMeanMarginalizedThresh(:)).^2)/length(simulatedThresh));
maxLikeliFitMarginalizedErr = sqrt(sum((simulatedThresh(:) - maxLikeliFitMarginalizedThresh(:)).^2)/length(simulatedThresh));

posteriorMaxNotMarginalizedErr = sqrt(sum((simulatedThresh(:) - posteriorMaxNotMarginalizedThresh(:)).^2)/length(simulatedThresh));
posteriorMeanNotMarginalizedErr = sqrt(sum((simulatedThresh(:) - posteriorMeanNotMarginalizedThresh(:)).^2)/length(simulatedThresh));
marginalPosteriorMaxNotMarginalizedErr = sqrt(sum((simulatedThresh(:) - marginalPosteriorMaxNotMarginalizedThresh(:)).^2)/length(simulatedThresh));
marginalPosteriorMeanNotMarginalizedErr = sqrt(sum((simulatedThresh(:) - marginalPosteriorMeanNotMarginalizedThresh(:)).^2)/length(simulatedThresh));
maxLikeliFitNotMarginalizedErr = sqrt(sum((simulatedThresh(:) - maxLikeliFitNotMarginalizedThresh(:)).^2)/length(simulatedThresh));

fprintf('Errors:\n');
fprintf('\tPosterior max, marginalized: %0.5f\n',posteriorMaxMarginalizedErr);
fprintf('\tPosterior mean, marginalized: %0.5f\n',posteriorMeanMarginalizedErr);
fprintf('\tMarginal posterior max, marginalized: %0.5f\n',marginalPosteriorMaxMarginalizedErr);
fprintf('\tMarginal posterior mean, marginalized: %0.5f\n',marginalPosteriorMeanMarginalizedErr);
fprintf('\tMax likelihood fit, marginalized: %0.5f\n',maxLikeliFitMarginalizedErr);

fprintf('\tPosterior max, not marginalized: %0.5f\n',posteriorMaxNotMarginalizedErr);
fprintf('\tPosterior mean, not marginalized: %0.5f\n',posteriorMeanNotMarginalizedErr);
fprintf('\tMarginal posterior max, marginalized: %0.5f\n',marginalPosteriorMaxMarginalizedErr);
fprintf('\tMarginal posterior mean, not marginalized: %0.5f\n',marginalPosteriorMeanNotMarginalizedErr);
fprintf('\tMax likelihood fit, not marginalized: %0.5f\n',maxLikeliFitNotMarginalizedErr);

% Threshold estimates versus simulated values, marginalized quest
theParamIndex = 1;
theParamName = 'Threshold, marginalized';
figure; clf; hold on
plot(simulatedThresh(:),marginalPosteriorMeanMarginalizedThresh(:),'ro','MarkerFaceColor','r','MarkerSize',8);
plot(simulatedThresh(:),posteriorMeanMarginalizedThresh(:),'ko','MarkerFaceColor','k','MarkerSize',4);
%plot(simulatedThresh(:),maxLikeliFitMarginalizedThresh(:),'bo','MarkerFaceColor','b','MarkerSize',8);
xlim([domainVlb(theParamIndex) domainVub(theParamIndex)]);
ylim([domainVlb(theParamIndex) domainVub(theParamIndex)]);
plot([domainVlb(theParamIndex) domainVub(theParamIndex)],[domainVlb(theParamIndex) domainVub(theParamIndex)],'k','LineWidth',1);
axis('square');
xlabel('Simulated');
ylabel('Estimated');
title(theParamName);

% Threshold estimates versus simulated values, not marginalized quest
theParamIndex = 1;
theParamName = 'Threshold, not marginalized';
figure; clf; hold on
plot(simulatedThresh(:),marginalPosteriorMeanNotMarginalizedThresh(:),'ro','MarkerFaceColor','r','MarkerSize',8);
plot(simulatedThresh(:),posteriorMeanNotMarginalizedThresh(:),'ko','MarkerFaceColor','k','MarkerSize',4);
%plot(simulatedThresh(:),maxLikeliFitNotMarginalizedThresh(:),'bo','MarkerFaceColor','b','MarkerSize',8);
xlim([domainVlb(theParamIndex) domainVub(theParamIndex)]);
ylim([domainVlb(theParamIndex) domainVub(theParamIndex)]);
plot([domainVlb(theParamIndex) domainVub(theParamIndex)],[domainVlb(theParamIndex) domainVub(theParamIndex)],'k','LineWidth',1);
axis('square');
xlabel('Simulated');
ylabel('Estimated');
title(theParamName);

% Plot abs estimation error from marginalized quest versus non-margialized.
% Mean abs error is the black circle.
theParamName = 'Effect of Marginalization';
figure; clf; hold on
plot(abs(marginalPosteriorMeanNotMarginalizedThresh(:)-simulatedThresh(:)), ...
    abs(marginalPosteriorMeanMarginalizedThresh(:)-simulatedThresh(:)),'ro','MarkerFaceColor','r','MarkerSize',8);
plot(mean(abs(marginalPosteriorMeanNotMarginalizedThresh(:)-simulatedThresh(:))), ...
    mean(abs(marginalPosteriorMeanMarginalizedThresh(:)-simulatedThresh(:))),'ko','MarkerFaceColor','k','MarkerSize',12);
xlim([0 5]);
ylim([0 5]);
plot([0 5],[0 5],'k','LineWidth',1);
axis('square');
xlabel('Not Marginalized Quest Abs Err');
ylabel('Marginalized Quest Abs Err');
title(theParamName);

% Little unit test that this routine still does what it used to.
assert(-924.0016 == round(sum(marginalPosteriorMeanMarginalizedThresh(:)),4),'No longer get same threshold estimate sum for marginalized case');
assert( -925.1793 == round(sum(marginalPosteriorMeanNotMarginalizedThresh(:)),4),'No longer get same threshold estimate sum for not marginalized case');

