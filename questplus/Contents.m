% mQUESTPlus - questplus
%
% MATLAB implementation of Watson's QUEST+. The core QUEST+ routines.
%
% The method and Mathematica code are described in the paper: Watson, A. B.
% (2017).  "QUEST+: A general multidimensional Bayesian adaptive
% psychometric method". Journal of Vision, 17(3):10, 1-27,
% http://jov.arvojournals.org/article.aspx?articleid=2611972.
%
% See README.md in the mQUESTPlus repository root directory for more info
% (or read it on github at https://github.com/BrainardLab/mQUESTPlus).
%
% A good way to get started with mQUESTPlus is with the demos. See
% "help mQUESTPlus/demos" for a complete list. Two key demos are:
%
%   1) qpQuestPlusPaperSimpleExampleDemo.  This runs several of the basic
%   demonstrations from the Watson (2017) QUEST+ paper, showing usage for
%   function qpRun.
%
%   2) qpQuestPlusCoreFunctionDemo. This illustrates how you can call the
%   core functions of mQUESTPlus directly, rather than letting qpRun
%   orchestrate your experiment.
%
% qpFit                         - Maximum likelihood fit of a psychometric
%                                 function to a trial data array.
% qpInitialize                  - Initialize the questData structure for a
%                                 QUEST+ experiment.
% qpParams                      - Set user defined parameters for a QUEST+
%                                 run.  Called by qpInitialize.
% qpMarginalizePosterior        - Marginalize a posterior over specified
%                                 parameters.
% qpQuery                       - Use questData structure to get next
%                                 recommended stimulus index and stimulus
% qpRun                         - High level function that runs a QUEST+
%                                 experiment. You can call this to run your
%                                 experiment, or you can call the pieces of
%                                 mQUESTPlus separately.  See the paper for
%                                 a longer discussion of the role of qpRun
%                                 and alternatives.  See
%                                 qpQuestPlusCoreFunctionDemo for example
%                                 of how to call the pieces separately.
% qpUpdate                      - Update the questData structure for the
%                                 trial stimulus and outcome.
% qpUpdateUpdateExpectedNextEntropiesByStim - Update the table of expected
%                                 next entropies for each stimulus.
