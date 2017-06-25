function qpUtilityDemo
%qpUtilityDemo  Demonstrate and test the qp utility routines.
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
% This first call is like the Mathematic notebook example and does not
% require that the values sum to 1.  It gives a similar number.  Round
% to three places so we can check that the code still does the same thing
% later in life.  Note setting of rng seed so this is replicable.
fprintf('*** qpArrayEntropy:\n');
rng(1);
theArray = rand(10,10);
theEntropy = qpArrayEntropy(theArray,'tolerance',Inf);
theEntropy = round(theEntropy*1000)/1000
assert(theEntropy == 35.513,'qpArrayEntropy: Computed entropy of unnormalized array is no longer what it used to be');

% A version that enforces that the probailities sum to 1.
unitizedArray = qpUnitizeArray(theArray);
theEntropy = qpArrayEntropy(unitizedArray);
theEntropy = round(theEntropy*10000)/10000
assert(theEntropy == 6.3334,'qpArrayEntropy: Computed entropy is no longer what it used to be');

% Change base
theEntropy = qpArrayEntropy(unitizedArray,'base',10);
theEntropy10 = round(theEntropy*10000)/10000
assert(theEntropy10 == 1.9066,'qpArrayEntropy: Computed entropy base 10 is no longer what it used to be');
handCheck10 = -sum(unitizedArray(:) .* log10(unitizedArray(:)));
handCheck10 = round(handCheck10*10000)/10000;
assert(handCheck10 == theEntropy10,'qpArrayEntropy: Hand computation of log base 10 version does not match qpArrayEntropy');

%% qpListMinArg/qpListMaxArg
fprintf('*** qpListMinArg/qpListMaxArg:\n');
theArray = [2 3 4 ; 1 2 6];
minIndex = qpListMinArg(theArray)
assert(theArray(minIndex) == min(theArray(:)),'qpListMinArg: Indexing into array with return value does not retrieve minimum');
maxIndex = qpListMaxArg(theArray)
assert(theArray(maxIndex) == max(theArray(:)),'qpListMaxArg: Indexing into array with return value does not retrieve maximum');
