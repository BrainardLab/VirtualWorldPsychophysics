function [stimValues,pStimValues,stdErrPStimValues] = AveragePsychometricFunctions(summaryDataStruct,whichCondition,whichRun)
% [stimValues,pStimValues,stdErrPStimValues] = AveragePsychometricFunctions(summaryDataStruct,whichCondition,whichRun)
%
% Aggregate psychometric functions for each base level.  We only really
% care about this for the paint-paint (control) condition.
%
% This code is fairly fragile and is tied to some specific symmetries in
% the experimental design.

%% Find cases where test in paint and test in shadow.  This is specified
% also for paint/paint case, even though there is really no difference
% there.
index1 = find(summaryDataStruct{whichCondition}{whichRun}.whichFixedData == 1);
index2 = find(summaryDataStruct{whichCondition}{whichRun}.whichFixedData == 2);

%% Reference values come back in either ref or test field, depending on where reference was.  This keeps the nominal
% reference value roughly constant and was useful for PSE plots, but is a
% little confusing here.
allRefXVals = [summaryDataStruct{whichCondition}{whichRun}.refData(index1) ; summaryDataStruct{whichCondition}{whichRun}.testData(index2)];

%% Get unique reference values and then pull out x values we are using (the pse values) and 
% corresponding thresholds
uniqueRefXVals = unique(allRefXVals);
for kk = 1:length(uniqueRefXVals)
    xTemp{kk} = [];
    yTemp{kk} = [];
    index = find(summaryDataStruct{whichCondition}{whichRun}.whichFixedData == 1 & summaryDataStruct{whichCondition}{whichRun}.refData == uniqueRefXVals(kk));
    xTemp{kk} = [xTemp{kk} summaryDataStruct{whichCondition}{whichRun}.stimValues(:,index)];
    yTemp{kk} = [yTemp{kk} summaryDataStruct{whichCondition}{whichRun}.pStimValues(:,index)];
    index = find(summaryDataStruct{whichCondition}{whichRun}.whichFixedData == 2 & summaryDataStruct{whichCondition}{whichRun}.testData == uniqueRefXVals(kk));
    xTemp{kk} = [xTemp{kk} summaryDataStruct{whichCondition}{whichRun}.stimValues(:,index)];
    yTemp{kk} = [yTemp{kk} summaryDataStruct{whichCondition}{whichRun}.pStimValues(:,index)];
end

%% Average stimulus and predicted values for each base stimulus
stimValues = zeros(length(xTemp{1}(:,1)),length(uniqueRefXVals));
pStimValues = zeros(length(xTemp{1}(:,1)),length(uniqueRefXVals));
stdErrXTemp = zeros(length(xTemp{1}(:,1)),length(uniqueRefXVals));
stdErrPStimValues= zeros(length(xTemp{1}(:,1)),length(uniqueRefXVals));
for kk = 1:length(uniqueRefXVals)
    stimValues(:,kk) = mean(xTemp{kk},2);
    stdErrXTemp(:,kk) = std(xTemp{kk},[],2)/sqrt(length(xTemp{kk}(1,:)));
    if (any(stdErrXTemp(:,kk) ~= 0))
        error('Oops');
    end
    pStimValues(:,kk) = mean(yTemp{kk},2);
    stdErrPStimValues(:,kk) = std(yTemp{kk},[],2)/sqrt(length(yTemp{kk}(1,:)));
end
