function qpUtilityDemo
%qpUtilityDemo  Demonstrate/test the qp utility routines
%
% Description:
%    This script shows the usage for the qp utility routines, and checks
%    some basic assertions about what they should do.
%
%    These do their best to follow the examples in the QuestPlus.nb
%    Mathematica notebook.

% 6/24/17  dhb  Created.

%% qpUnitizeArray
fprintf('*** qpUnitizeArray:\n');
testArray = qpUnitizeArray(zeros(2,2))
assert(sum(testArray(:)) == 1,'qpUnitizeArray: Created array from input of zeros does not sum to 1');

testArray = qpUnitizeArray([1 2 ; 3 4])
assert(sum(testArray(:)) == 1,'qpUnitizeArray: Created array from array input does not sum to 1');

%% qpUniformArray
fprintf('*** qpUniformArray:\n');
testArray = qpUniformArray([3 4])
assert(sum(testArray(:)) == 1,'qpUniformArray: Created uniform array input does not sum to 1');

%% qpArrayEntropy
%
% This first call is like the Mathematic notebook example.  It gives a similar number.  Round
% to three places so we can check that the code still does the same thing
% later in life.  Note setting of rng seed so this is replicable.
fprintf('*** qpArrayEntropy:\n');
rng('default'); rng(1,'twister');
theArray = rand(10,10);
theEntropy = qpArrayEntropy(theArray);
theEntropy = round(theEntropy*1000)/1000
assert(theEntropy == 35.513,'qpArrayEntropy: Computed entropy of unnormalized array is no longer what it used to be');

%% qpListMinArg/qpListMaxArg
fprintf('*** qpListMinArg/qpListMaxArg:\n');
theArray = [2 3 4 ; 1 2 6];
minIndex = qpListMinArg(theArray)
assert(theArray(minIndex) == min(theArray(:)),'qpListMinArg: Indexing into array with return value does not retrieve minimum');
maxIndex = qpListMaxArg(theArray)
assert(theArray(maxIndex) == max(theArray(:)),'qpListMaxArg: Indexing into array with return value does not retrieve maximum');

%% qpNLogP
fprintf('*** qpNLogP\n');
nLogP = qpNLogP([.1 0 2],[0 0 .1])
assert(nLogP(1) == -1*realmax,'qpNLogP: Value for input (.1,0) not as expected.');
assert(nLogP(2) == 0,'qpNLogP: Value for input (0,0) not as expected.');
