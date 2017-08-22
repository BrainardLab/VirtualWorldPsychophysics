% ConditionLister
%
% Randomize condions and printout for listing on wiki
%
% 6/25/13  dhb  Wrote it.

%% Clear
clear

%% Condition list
theList = [71 72 73 74 75 76 77 78];
nRepeats = 2;

%% Randomize and print
for i = 1:nRepeats
    theOrder = Shuffle(theList);
    for i = 1:length(theOrder)
        fprintf('  * Protocol %d-- data file\n',theOrder(i));
    end
end