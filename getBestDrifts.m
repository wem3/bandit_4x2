% GETBESTDRIFTS%%%%%%.M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script generates drifting reward probabilities for a k-armed bandit
% by calling makeDrifts.m, computes correlations b/w arms for each set of 
% reward probabilities, and identifies the least correlated sets.
%
% Unless there is a specific reason to modify or directly call one of the 
% included functions, all relevant changes can be made within this script. 
%
% To generate drifts and identify the "best" ones, simply do
%
% >> getBestDrifts.m
%
% after making the appropriate adjustments within the script.
% 
% ~#wem3#~ [20170116]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of arms in the bandit for which to make drifting reward probabilities
numArms = 4;
% number of trials
numTrials = 360;
% rate of change for reward probabilities
driftRate = 0.2;
% number of sets of probabilities to generate
numDrifts = 1000;
% note: to make this generalizable for different numbers of arms is going to be
% nightmarish. Hardcoded for 4 arms (the number implemented in our experiment)
% initialize a [numTrials x numArms x numDrifts] matrix of NaNs to hold drifts
driftMat = nan(numTrials,numArms,numDrifts);
% initialize an empty matrix to hold drift correlations
corrMat = [];
% empty vector to hold summed correlations
corrSum = nan(numDrifts,1);

% loop over total number of drifts
for d = 1:numDrifts
    % actually generate the drifts
    [driftMat(:,:,d), ~] = makeDrifts(numTrials, driftRate, 0, 0);
    % get the absolute values of correlations b/w each set of drifts
    tmpCorr = abs(corr(driftMat(:,:,d)));
    % store correlations in corrMat
    corrVec = [tmpCorr(1,2),tmpCorr(1,3),tmpCorr(1,4),tmpCorr(2,3),tmpCorr(2,4),tmpCorr(3,4)];
    corrSum(d) = sum(corrVec);
    corrMat = [corrMat; corrVec];
end

% sort the matrix of summed correlations
corrSort = sort(corrSum);
% initialize an vector of nans to hold drift indices
driftDex = nan(1,8);
% loop for 8 drifts
for d = 1:length(driftDex)
    % get the indices of the 8 least correlated sets of drifts
    driftDex(d) = find(corrSum == corrSort(d));
end