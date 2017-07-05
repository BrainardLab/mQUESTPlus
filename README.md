# mQUESTPlus
MATLAB implementation of Watson's QUEST+.

The method and Mathematica code are described in the paper:
Watson, A. B. (2017).  "QUEST+: A general multidimensional Bayesian adaptive psychometric method".
Journal of Vision, 17(3):10, 1-27.

This implementation is due to David Brainard.  Sources include the paper above, the Mathematica
notebook provide as supplemental material for the paper (an updated version of which was 
provided to me by Watson), and a separate earlier Matlab implementation of QUEST+ written
by  P R Jones <petejonze@gmail.com> in Joshua Soloman's laboratory.  The Jones implementation
is organized somewhat differently from this one, but was useful for thinking about ways to translate
Mathematic data structures into Matlab. The few places where there was fairly direct carryover
are noted specifically by comments in the code.

See issues section of this (https://github.com/brainardlab/mQuestPlus) gitHub site for a list known issues,
limitations and possible future enhancements.