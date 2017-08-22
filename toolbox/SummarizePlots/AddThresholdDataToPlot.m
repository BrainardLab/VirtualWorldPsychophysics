function slope = AddThresholdDataToPlot(summaryDataStruct,whichCondition,whichRun,theColor,figParams)
% slope = AddThresholdDataToPlot(summaryDataStruct,whichCondition,whichRun,theColor,figParams)
%
% Aggregate threshold data and add it to the current plot.  Also return
% threshold versus base intensity slope.
%
% There is a bit of a conceptual issue of what x value to use for the base
% intensity in the assymetric condtion.  What we do here is use the matched
% pse as the x value for each reference value, but average over the two cases
% (ref in paint, ref shadow) to get the x value.
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
    xTemp{kk} = [xTemp{kk} ; summaryDataStruct{whichCondition}{whichRun}.testData(index)];
    yTemp{kk} = [yTemp{kk} ; summaryDataStruct{whichCondition}{whichRun}.thresholdData(index)];
    index = find(summaryDataStruct{whichCondition}{whichRun}.whichFixedData == 2 & summaryDataStruct{whichCondition}{whichRun}.testData == uniqueRefXVals(kk));
    xTemp{kk} = [xTemp{kk} ; summaryDataStruct{whichCondition}{whichRun}.refData(index)];
    yTemp{kk} = [yTemp{kk} ; summaryDataStruct{whichCondition}{whichRun}.thresholdData(index)];
end

%% Average x-values and thresholds for each reference level, and add to plot with 
% both x and y error bars
meanXTemp = zeros(length(uniqueRefXVals),1);
meanYTemp = zeros(length(uniqueRefXVals),1);
stdErrXTemp = zeros(length(uniqueRefXVals),1);
stdErrYTemp = zeros(length(uniqueRefXVals),1);
for kk = 1:length(uniqueRefXVals)
    meanXTemp(kk) = mean(xTemp{kk});
    stdErrXTemp(kk) = std(xTemp{kk})/sqrt(length(xTemp{kk}));
    meanYTemp(kk) = mean(yTemp{kk});
    stdErrYTemp(kk) = std(yTemp{kk})/sqrt(length(yTemp{kk}));
    errorbarX(meanXTemp(kk),meanYTemp(kk),stdErrXTemp(kk),stdErrXTemp(kk),theColor);
    errorbar(meanXTemp(kk),meanYTemp(kk),stdErrYTemp(kk),stdErrYTemp(kk),[theColor 'o'],'MarkerSize',figParams.markerSize-4,'MarkerFaceColor',theColor);
end

%% Find the slope and add to plot
slope = meanXTemp\meanYTemp;
plot([0 ; meanXTemp ; 1],slope*[0 ; meanXTemp ; 1],theColor,'LineWidth',1);