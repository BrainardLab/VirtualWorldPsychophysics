% AnalyzeOriginalPaintShadow
%
% Run full analysis over original paint shadow image data.
%
% These are conditions 31 and 32 for aqr, baf, and cnj,
% plus conditions 51 and 52 for aqr, cnj, and eje.
%
% This is a little bit 'by hand' but at least the program documents
% what is done here.
%
% 2/22/14  dhb  Wrote it.

%% Clear
clear; close all;

%% Parameters
%
% Set compute to false if you just want to fuss with the figures produced
% by this file and you've already run it once with COMPUTE set true.
analysisFitType = 'gain';
COMPUTE = false;

%% Figure directory
outputBaseDir = getpref('LightnessPopCode','outputBaseDir');
 switch (analysisFitType)
        case 'intercept'
            outputDir = fullfile(outputBaseDir,'xPsychoSummary','Intercept');
        case 'gain'
            outputDir = fullfile(outputBaseDir,'xPsychoSummary','Gain');
        otherwise
            error('Unknown analysisFitType specified');
    end
if (~exist(outputDir,'file'))
    mkdir(outputDir);
end

%% Make sure all data is processed by current scripts.
if (COMPUTE)
    % AQR - subject 1 for parametric conditions 2
    aqrSummaryDataStructControl{1} = AnalyzeParametricConditions(2,1,31,analysisFitType);
    aqrSummaryDataStructPaintShadow{1} = AnalyzeParametricConditions(2,1,32,analysisFitType);
    
    % AQR - subject 2 for parametric conditions 3
    aqrSummaryDataStructControl{2} = AnalyzeParametricConditions(3,2,51,analysisFitType);
    aqrSummaryDataStructPaintShadow{2} = AnalyzeParametricConditions(3,2,52,analysisFitType);
    
    % BAF - subject 2 for parametric conditions 2
    bafSummaryDataStructControl{1} = AnalyzeParametricConditions(2,2,31,analysisFitType);
    bafSummaryDataStructPaintShadow{1} = AnalyzeParametricConditions(2,2,32,analysisFitType);
    
    % CNJ - - subject 3 for parametric conditions 2
    cnjSummaryDataStructControl{1} = AnalyzeParametricConditions(2,3,31,analysisFitType);
    cnjSummaryDataStructPaintShadow{1} = AnalyzeParametricConditions(2,3,32,analysisFitType);
    
    % CNJ - subject 3 for parametric conditions 3
    cnjSummaryDataStructControl{2} = AnalyzeParametricConditions(3,3,51,analysisFitType);
    cnjSummaryDataStructPaintShadow{2} = AnalyzeParametricConditions(3,3,52,analysisFitType);
    
    % EJE - subject 4 for parametric conditions 3
    ejeSummaryDataStructControl{1} = AnalyzeParametricConditions(3,4,51,analysisFitType);
    ejeSummaryDataStructPaintShadow{1} = AnalyzeParametricConditions(3,4,52,analysisFitType);
    
    %% Collect up the analysis
    theData.analysisFitType = analysisFitType;
    theData.aqrControl = [aqrSummaryDataStructControl{1}{1}.theFit(1) aqrSummaryDataStructControl{2}{1}.theFit(1)];
    theData.aqrControlMean = mean(theData.aqrControl);
    theData.aqrPaintShadow = [aqrSummaryDataStructPaintShadow{1}{1}.theFit(1) aqrSummaryDataStructPaintShadow{2}{1}.theFit(1)];
    theData.aqrPaintShadowMean = mean(theData.aqrPaintShadow);
    
    theData.bafControl = [bafSummaryDataStructControl{1}{1}.theFit(1)];
    theData.bafControlMean = mean(theData.bafControl);
    theData.bafPaintShadow = [bafSummaryDataStructPaintShadow{1}{1}.theFit(1)];
    theData.bafPaintShadowMean = mean(theData.bafPaintShadow);
    
    theData.cnjControl = [cnjSummaryDataStructControl{1}{1}.theFit(1) cnjSummaryDataStructControl{2}{1}.theFit(1)];
    theData.cnjControlMean = mean(theData.cnjControl);
    theData.cnjPaintShadow = [cnjSummaryDataStructPaintShadow{1}{1}.theFit(1) cnjSummaryDataStructPaintShadow{2}{1}.theFit(1)];
    theData.cnjPaintShadowMean = mean(theData.cnjPaintShadow);
    
    theData.ejeControl = [ejeSummaryDataStructControl{1}{1}.theFit(1)];
    theData.ejeControlMean = mean(theData.ejeControl);
    theData.ejePaintShadow = [ejeSummaryDataStructPaintShadow{1}{1}.theFit(1)];
    theData.ejePaintShadowMean = mean(theData.ejePaintShadow);
    
    theData.allControl = [theData.aqrControl theData.bafControl theData.cnjControl theData.ejeControl];
    theData.allPaintShadow = [theData.aqrPaintShadow theData.bafPaintShadow theData.cnjPaintShadow theData.ejePaintShadow];
    
    theData.meanControl = [theData.aqrControlMean theData.bafControlMean theData.cnjControlMean theData.ejeControlMean];
    theData.meanPaintShadow = [theData.aqrPaintShadowMean theData.bafPaintShadowMean theData.cnjPaintShadowMean theData.ejePaintShadowMean];
    
    % Save summary info
    save(fullfile(outputDir,'OriginalPaintShadow'),'theData');
    save(fullfile(outputDir,'OriginalPaintShadowSummaryStructs'),'aqrSummaryDataStructControl','aqrSummaryDataStructPaintShadow', ...
        'bafSummaryDataStructControl','bafSummaryDataStructPaintShadow', ...
        'cnjSummaryDataStructControl','cnjSummaryDataStructPaintShadow', ...
        'ejeSummaryDataStructControl','ejeSummaryDataStructPaintShadow');
    
else
    % Load summary info
    load(fullfile(outputDir,'OriginalPaintShadow'),'theData');
    load(fullfile(outputDir,'OriginalPaintShadowSummaryStructs'),'aqrSummaryDataStructControl','aqrSummaryDataStructPaintShadow', ...
        'bafSummaryDataStructControl','bafSummaryDataStructPaintShadow', ...
        'cnjSummaryDataStructControl','cnjSummaryDataStructPaintShadow', ...
        'ejeSummaryDataStructControl','ejeSummaryDataStructPaintShadow');
    
    if (~strcmp(analysisFitType,theData.analysisFitType))
        error('Loaded data analysisFitType does not match that specified currently');
    end
end

%% Figure parameters
figParams = SetFigParams([],'psychophysics');
%figParams.baseSize = 850;
%figParams.position = [100 100 figParams.baseSize round(420/560*figParams.baseSize)];
%figParams.sqPosition = [100 100 figParams.baseSize figParams.baseSize];
figParams.xLimLow = 0;
figParams.xLimHigh = 7;
figParams.yLimLow = -0.1;
figParams.yLimHigh = 0.02;
figParams.xTicks = [1 2 3 4 5 6];
figParams.xTickLabels = {'AQR (1)' 'AQR (2)' 'BAF (1)' 'CNJ (1)' 'CNJ (2)' 'EJE (1)'};
figParams.yTicks = [-0.1 -0.05 0.0];
figParams.yTickLabels = {'-0.10 ' '-0.05 ' ' 0.00 '};

%% Figures
switch (analysisFitType)
    case 'intercept'
        % Make a figure showing intercepts for paint/shadow conditions.
        interceptFig = figure; clf; hold on
        set(gcf,'Position',figParams.position);
        set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
        plot(theData.allPaintShadow,'b^','MarkerFaceColor','b','MarkerSize',figParams.markerSize);
        plot(zeros(size(theData.allControl)),'k:','LineWidth',figParams.lineWidth);
        plot(mean(theData.allPaintShadow)*ones(size(theData.allControl)),'b','LineWidth',figParams.lineWidth);
        axis([figParams.xLimLow figParams.xLimHigh figParams.yLimLow figParams.yLimHigh]);
        set(gca,'XTick',figParams.xTicks,'XTickLabel',figParams.xTickLabels,'FontSize',figParams.axisFontSize-3);
        set(gca,'YTick',figParams.yTicks,'YTickLabel',figParams.yTickLabels);
        xlabel('Subject (Replication)','FontSize',figParams.labelFontSize);
        ylabel('Paint/Shadow Offset Effect','FontSize',figParams.labelFontSize);
        % legend({sprintf('Paint/Shadow, Mean %0.2f',mean(theData.allPaintShadow))},'Location','NorthWest','FontSize',figParams.legendFontSize);
        text(0.25,0.012,sprintf('Mean: %0.2f',mean(theData.allPaintShadow)),'FontSize',figParams.legendFontSize);
        FigureSave(fullfile(outputDir,'OriginalPaintShadowIntercepts'),interceptFig,figParams.figType);
        
        % Version with control conditions.
        %
        % Remake whole figure so that legend work right
        interceptFig1 = figure; clf; hold on
        set(gcf,'Position',figParams.position);
        set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
        plot(theData.allPaintShadow,'b^','MarkerFaceColor','b','MarkerSize',figParams.markerSize);
        plot(theData.allControl,'k^','MarkerFaceColor','k','MarkerSize',figParams.markerSize);
        plot(zeros(size(theData.allControl)),'k:','LineWidth',figParams.lineWidth);
        plot(mean(theData.allPaintShadow)*ones(size(theData.allControl)),'b','LineWidth',figParams.lineWidth);
        plot(mean(theData.allControl)*ones(size(theData.allControl)),'k','LineWidth',figParams.lineWidth);
        axis([figParams.xLimLow figParams.xLimHigh figParams.yLimLow figParams.yLimHigh]);
        set(gca,'XTick',figParams.xTicks,'XTickLabel',figParams.xTickLabels,'FontSize',figParams.axisFontSize-3);
        set(gca,'YTick',figParams.yTicks,'YTickLabel',figParams.yTickLabels);
        xlabel('Subject (Replication)','FontSize',figParams.labelFontSize);
        ylabel('Paint Shadow Offset Effect','FontSize',figParams.labelFontSize);
        legend({'Paint/Shadow' 'Paint/Paint'},'Location','NorthWest','FontSize',figParams.legendFontSize);
        FigureSave(fullfile(outputDir,'OriginalPaintShadowInterceptsWithControl'),interceptFig1,figParams.figType);
        
    case 'gain'
        % Make a figure showing gains for paint/shadow conditions.
        gainFig = figure; clf; hold on
        set(gcf,'Position',figParams.position);
        set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
        plot(log10(theData.allPaintShadow),'b^','MarkerFaceColor','b','MarkerSize',figParams.markerSize);
        plot(zeros(size(theData.allControl)),'k:','LineWidth',figParams.lineWidth);
        plot(mean(log10(theData.allPaintShadow))*ones(size(theData.allControl)),'b','LineWidth',figParams.lineWidth);
        axis([figParams.xLimLow figParams.xLimHigh -0.3 0.3]);
        set(gca,'XTick',figParams.xTicks,'XTickLabel',figParams.xTickLabels,'FontSize',figParams.axisFontSize-3);
        set(gca,'YTick',[-.3 -.2 -.1 0 .1 .2 .3],'YTickLabel',{'-0.3 ' '-0.2 ' '-0.1  ' '0.0 ' '0.1 ' '0.2 ' '0.3 '});
        xlabel('Subject (Replication)','FontSize',figParams.labelFontSize);
        ylabel('Paint/Shadow Gain Effect','FontSize',figParams.labelFontSize);
        % legend({sprintf('Paint/Shadow, Mean %0.2f',mean(theData.allPaintShadow))},'Location','NorthWest','FontSize',figParams.legendFontSize);
        text(0.25,0.27,sprintf('Mean: %0.2f',mean(log10(theData.allPaintShadow))),'FontSize',figParams.legendFontSize);
        FigureSave(fullfile(outputDir,'OriginalPaintShadowGains'),gainFig,figParams.figType);
        
        % Version with control conditions.
        %
        % Remake whole figure so that legend work right
        gainFig1 = figure; clf; hold on
        %set(gcf,'Position',figParams.position);
        %set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
        plot(log10(theData.allPaintShadow),'bo','MarkerFaceColor','b'); %,'MarkerSize',figParams.markerSize);
        plot(log10(theData.allControl),'ko','MarkerFaceColor','k'); %,'MarkerSize',figParams.markerSize);
        plot(zeros(size(theData.allControl)),'k:'); %,'LineWidth',figParams.lineWidth);
        plot(mean(log10(theData.allPaintShadow))*ones(size(theData.allControl)),'b'); %,'LineWidth',figParams.lineWidth);
        plot(mean(log10(theData.allControl))*ones(size(theData.allControl)),'k'); %,'LineWidth',figParams.lineWidth);
        xlim([figParams.xLimLow figParams.xLimHigh]);
        ylim([-0.15 0.15]);
        set(gca,'XTick',figParams.xTicks,'XTickLabel',figParams.xTickLabels); %,'FontSize',figParams.axisFontSize-3);
        set(gca,'YTick',[-.15 -.10 -.05 0 .05 .1 .15],'YTickLabel',{'-0.15 ' '-0.10 ' '-0.05  ' '0.00 ' '0.05 ' '0.10 ' '0.15 '});
        ylabel('Paint-Shadow Effect'); %,'FontName',figParams.fontName,'FontSize',figParams.labelFontSize);  
        xlabel('Subject (Replication)'); %,'FontSize',figParams.labelFontSize);
        ylabel('Paint-Shadow Effect'); %,'FontSize',figParams.labelFontSize);
        %legend({'Paint-Shadow Effect' 'Paint-Paint Control'},'Location','NorthWest','FontSize',figParams.legendFontSize);
        set(gca(gainFig1),'tickdir','out');
        a=get(gca(gainFig1),'ticklength');
        set(gca(gainFig1),'ticklength',[a(1)*2,a(2)*2]);
        box off
        FigureSave(fullfile(outputDir,'OriginalPaintShadowGainsWithControl'),gainFig1,figParams.figType);
        exportfig(gainFig1,fullfile(outputDir,'OriginalPaintShadowGainsWithControl.eps'),'Format','eps','Width',4,'Height',4,'FontMode','fixed','FontSize',10,'color','cmyk');

        fprintf('Mean paint-shadow effect = %0.3f, control = %0.3f\n',mean(log10(theData.allPaintShadow)),mean(log10(theData.allControl)));
        fprintf('Standard error paint-shadow effect = %0.4f, control = %0.4f\n', ...
            std(log10(theData.allPaintShadow))/sqrt(length(theData.allPaintShadow)),std(log10(theData.allControl))/sqrt(length(theData.allControl)));
    otherwise
        error('Unknown analysisFitType specified');
end

%% Threshold figures
%
% This section analyzes the threshold data from the individual subjects,
% and for each subject computes the slope of threshold versus base
% luminance.  It then makes a summary plot of these slopes.
%
% It also makes plots and a table of the psychometric functions on evenly
% spaced stimulus samples, for the paint-paint conditions.
%
% AQR control
conditionColors = ['r' 'b'];
controlSlopes = [];
paintShadowSlopes = [];
stimValuesAll25 = [];
pStimValuesAll25 = [];
stimValuesAll50 = [];
pStimValuesAll50 = [];
stimValuesAll75 = [];
pStimValuesAll75 = [];
controlSlopeIndex = 1;
controlSlopeIndex = 1;
paintShadowSlopeIndex = 1;
theSummaryStruct = aqrSummaryDataStructControl;
aqrControlThresholdFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
for whichCondition = 1:length(theSummaryStruct)
    if (length(theSummaryStruct{whichCondition}) ~= 1)
        error('Surprising number of runs in summary struct');
    end
    controlSlopes(controlSlopeIndex) = AddThresholdDataToPlot(theSummaryStruct,whichCondition,1,conditionColors(whichCondition),figParams);
    
    % Average and save fit psychometric functions    
    [stimValues,pStimValues,stdErrPStimValues] = AveragePsychometricFunctions(theSummaryStruct,whichCondition,1);
    save(fullfile(outputDir,['OriginalPaintShadowAQRPsychometricControl_' num2str(whichCondition)]),'stimValues','pStimValues','stdErrPStimValues');
    stimValuesAll25 = [stimValuesAll25 stimValues(:,1)];
    pStimValuesAll25 = [pStimValuesAll25 pStimValues(:,1)];
    stimValuesAll50 = [stimValuesAll50 stimValues(:,2)];
    pStimValuesAll50 = [pStimValuesAll50 pStimValues(:,2)];  
    stimValuesAll75 = [stimValuesAll75 stimValues(:,3)];
    pStimValuesAll75 = [pStimValuesAll75 pStimValues(:,3)]; 
    
    controlSlopeIndex = controlSlopeIndex+1;
end
xlim([0 1]);
ylim([0 0.2]);
xlabel('Probe Luminance','FontSize',figParams.labelFontSize);
ylabel('Threshold Contrast','FontSize',figParams.labelFontSize);
title('AQR, Paint-Paint Condition');
FigureSave(fullfile(outputDir,'OriginalPaintShadowAQRThresholdsControl'),aqrControlThresholdFig,figParams.figType);

% AQR paint shadow
theSummaryStruct = aqrSummaryDataStructPaintShadow;
aqrPaintShadowThresholdFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
for whichCondition = 1:length(theSummaryStruct)
    if (length(theSummaryStruct{whichCondition}) ~= 1)
        error('Surprising number of runs in summary struct');
    end
    paintShadowSlopes(paintShadowSlopeIndex) = AddThresholdDataToPlot(theSummaryStruct,whichCondition,1,conditionColors(whichCondition),figParams);
    paintShadowSlopeIndex = paintShadowSlopeIndex+1;
end
xlim([0 1]);
ylim([0 0.2]);
xlabel('Probe Luminance','FontSize',figParams.labelFontSize);
ylabel('Threshold Contrast','FontSize',figParams.labelFontSize);
title('AQR, Paint-Shadow Condition');
FigureSave(fullfile(outputDir,'OriginalPaintShadowAQRThresholdsPaintShadow'),aqrPaintShadowThresholdFig,figParams.figType);

% BAF control
conditionColors = ['r' 'b'];
theSummaryStruct = bafSummaryDataStructControl;
bafControlThresholdFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
for whichCondition = 1:length(theSummaryStruct)
    if (length(theSummaryStruct{whichCondition}) ~= 1)
        error('Surprising number of runs in summary struct');
    end
    controlSlopes(controlSlopeIndex) = AddThresholdDataToPlot(theSummaryStruct,whichCondition,1,conditionColors(whichCondition),figParams);
    
    % Average and save fit psychometric functions
    [stimValues,pStimValues,stdErrPStimValues] = AveragePsychometricFunctions(theSummaryStruct,whichCondition,1);
    save(fullfile(outputDir,['OriginalPaintShadowBAFPsychometricControl_' num2str(whichCondition)]),'stimValues','pStimValues','stdErrPStimValues');
    stimValuesAll25 = [stimValuesAll25 stimValues(:,1)];
    pStimValuesAll25 = [pStimValuesAll25 pStimValues(:,1)];
    stimValuesAll50 = [stimValuesAll50 stimValues(:,2)];
    pStimValuesAll50 = [pStimValuesAll50 pStimValues(:,2)];  
    stimValuesAll75 = [stimValuesAll75 stimValues(:,3)];
    pStimValuesAll75 = [pStimValuesAll75 pStimValues(:,3)]; 
 
    controlSlopeIndex = controlSlopeIndex+1;
end
xlim([0 1]);
ylim([0 0.2]);
xlabel('Probe Luminance','FontSize',figParams.labelFontSize);
ylabel('Threshold Contrast','FontSize',figParams.labelFontSize);
title('BAF, Paint-Paint Condition');
FigureSave(fullfile(outputDir,'OriginalPaintShadowBAFThresholdsControl'),bafControlThresholdFig,figParams.figType);

% BAF paint shadow
theSummaryStruct = bafSummaryDataStructPaintShadow;
bafPaintShadowThresholdFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
for whichCondition = 1:length(theSummaryStruct)
    if (length(theSummaryStruct{whichCondition}) ~= 1)
        error('Surprising number of runs in summary struct');
    end
    paintShadowSlopes(paintShadowSlopeIndex) = AddThresholdDataToPlot(theSummaryStruct,whichCondition,1,conditionColors(whichCondition),figParams);
    paintShadowSlopeIndex = paintShadowSlopeIndex+1;
end
xlim([0 1]);
ylim([0 0.2]);
xlabel('Probe Luminance','FontSize',figParams.labelFontSize);
ylabel('Threshold Contrast','FontSize',figParams.labelFontSize);
title('BAF, Paint-Shadow Condition');
FigureSave(fullfile(outputDir,'OriginalPaintShadowBAFThresholdsPaintShadow'),bafPaintShadowThresholdFig,figParams.figType);

% CNJ control
conditionColors = ['r' 'b'];
theSummaryStruct = cnjSummaryDataStructControl;
cnjControlThresholdFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
for whichCondition = 1:length(theSummaryStruct)
    if (length(theSummaryStruct{whichCondition}) ~= 1)
        error('Surprising number of runs in summary struct');
    end
    controlSlopes(controlSlopeIndex) = AddThresholdDataToPlot(theSummaryStruct,whichCondition,1,conditionColors(whichCondition),figParams);
    
    % Average and save fit psychometric functions
    [stimValues,pStimValues,stdErrPStimValues] = AveragePsychometricFunctions(theSummaryStruct,whichCondition,1);
    save(fullfile(outputDir,['OriginalPaintShadowCNJPsychometricControl_' num2str(whichCondition)]),'stimValues','pStimValues','stdErrPStimValues');
    stimValuesAll25 = [stimValuesAll25 stimValues(:,1)];
    pStimValuesAll25 = [pStimValuesAll25 pStimValues(:,1)];
    stimValuesAll50 = [stimValuesAll50 stimValues(:,2)];
    pStimValuesAll50 = [pStimValuesAll50 pStimValues(:,2)];  
    stimValuesAll75 = [stimValuesAll75 stimValues(:,3)];
    pStimValuesAll75 = [pStimValuesAll75 pStimValues(:,3)];  
    
    controlSlopeIndex = controlSlopeIndex+1;
end
xlim([0 1]);
ylim([0 0.2]);
xlabel('Probe Luminance','FontSize',figParams.labelFontSize);
ylabel('Threshold Contrast','FontSize',figParams.labelFontSize);
title('CNJ, Paint-Paint Condition');
FigureSave(fullfile(outputDir,'OriginalPaintShadowCNJThresholdsControl'),cnjControlThresholdFig,figParams.figType);

% CNJ paint shadow
theSummaryStruct = cnjSummaryDataStructPaintShadow;
cnjPaintShadowThresholdFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
for whichCondition = 1:length(theSummaryStruct)
    if (length(theSummaryStruct{whichCondition}) ~= 1)
        error('Surprising number of runs in summary struct');
    end
    paintShadowSlopes(paintShadowSlopeIndex) = AddThresholdDataToPlot(theSummaryStruct,whichCondition,1,conditionColors(whichCondition),figParams);
    paintShadowSlopeIndex = paintShadowSlopeIndex+1;
end
xlim([0 1]);
ylim([0 0.2]);
xlabel('Probe Luminance','FontSize',figParams.labelFontSize);
ylabel('Threshold Contrast','FontSize',figParams.labelFontSize);
title('CNJ, Paint-Shadow Condition');
FigureSave(fullfile(outputDir,'OriginalPaintShadowCNJThresholdsPaintShadow'),cnjPaintShadowThresholdFig,figParams.figType);

% EJE control
conditionColors = ['r' 'b'];
theSummaryStruct = ejeSummaryDataStructControl;
ejeControlThresholdFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
for whichCondition = 1:length(theSummaryStruct)
    if (length(theSummaryStruct{whichCondition}) ~= 1)
        error('Surprising number of runs in summary struct');
    end
    controlSlopes(controlSlopeIndex) = AddThresholdDataToPlot(theSummaryStruct,whichCondition,1,conditionColors(whichCondition),figParams);
    
    % Average and save fit psychometric functions
    [stimValues,pStimValues,stdErrPStimValues] = AveragePsychometricFunctions(theSummaryStruct,whichCondition,1);
    save(fullfile(outputDir,['OriginalPaintShadowEJEPsychometricControl_' num2str(whichCondition)]),'stimValues','pStimValues','stdErrPStimValues');
    stimValuesAll25 = [stimValuesAll25 stimValues(:,1)];
    pStimValuesAll25 = [pStimValuesAll25 pStimValues(:,1)];
    stimValuesAll50 = [stimValuesAll50 stimValues(:,2)];
    pStimValuesAll50 = [pStimValuesAll50 pStimValues(:,2)];  
    stimValuesAll75 = [stimValuesAll75 stimValues(:,3)];
    pStimValuesAll75 = [pStimValuesAll75 pStimValues(:,3)]; 
    
    controlSlopeIndex = controlSlopeIndex+1;
end
xlim([0 1]);
ylim([0 0.2]);
xlabel('Probe Luminance','FontSize',figParams.labelFontSize);
ylabel('Threshold Contrast','FontSize',figParams.labelFontSize);
title('EJE, Paint-Paint Condition');
FigureSave(fullfile(outputDir,'OriginalPaintShadowEJEThresholdsControl'),ejeControlThresholdFig,figParams.figType);

% EJE  paint shadow
theSummaryStruct = ejeSummaryDataStructPaintShadow;
ejePaintShadowThresholdFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
for whichCondition = 1:length(theSummaryStruct)
    if (length(theSummaryStruct{whichCondition}) ~= 1)
        error('Surprising number of runs in summary struct');
    end
    paintShadowSlopes(paintShadowSlopeIndex) = AddThresholdDataToPlot(theSummaryStruct,whichCondition,1,conditionColors(whichCondition),figParams);
    paintShadowSlopeIndex = paintShadowSlopeIndex+1;
end
xlim([0 1]);
ylim([0 0.2]);
xlabel('Probe Luminance','FontSize',figParams.labelFontSize);
ylabel('Threshold Contrast','FontSize',figParams.labelFontSize);
title('EJE, Paint-Shadow Condition');
FigureSave(fullfile(outputDir,'OriginalPaintShadowEJEThresholdsPaintShadow'),ejePaintShadowThresholdFig,figParams.figType);

% Slope figure with control conditions.
slopeFig1 = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
plot(paintShadowSlopes,'b^','MarkerFaceColor','b','MarkerSize',figParams.markerSize);
plot(controlSlopes,'k^','MarkerFaceColor','k','MarkerSize',figParams.markerSize);
plot(mean(paintShadowSlopes)*ones(size(paintShadowSlopes)),'b','LineWidth',figParams.lineWidth);
plot(mean(controlSlopes)*ones(size(controlSlopes)),'k','LineWidth',figParams.lineWidth);
axis([figParams.xLimLow figParams.xLimHigh 0 0.2]);
set(gca,'XTick',figParams.xTicks,'XTickLabel',figParams.xTickLabels,'FontSize',figParams.axisFontSize-3);
xlabel('Subject (Replication)','FontSize',figParams.labelFontSize);
ylabel('TVI Slope','FontSize',figParams.labelFontSize);
legend({'Paint/Shadow' 'Paint/Paint'},'Location','NorthWest','FontSize',figParams.legendFontSize);
FigureSave(fullfile(outputDir,'OriginalPaintShadowThresholdSlopesWithControl'),slopeFig1,figParams.figType);

% Average table of the one big overall psychometric function
stimValuesMean25 = mean(stimValuesAll25,2);
pStimValuesMean25 = mean(pStimValuesAll25,2);
stdErrPStimValuesMean25 = std(pStimValuesAll25,[],2)/sqrt(length(pStimValuesAll25(1,:)));
stimValuesMean50 = mean(stimValuesAll50,2);
pStimValuesMean50 = mean(pStimValuesAll50,2);
stdErrPStimValuesMean50 = std(pStimValuesAll50,[],2)/sqrt(length(pStimValuesAll50(1,:)));
stimValuesMean75 = mean(stimValuesAll75,2);
pStimValuesMean75 = mean(pStimValuesAll75,2);
stdErrPStimValuesMean75 = std(pStimValuesAll75,[],2)/sqrt(length(pStimValuesAll75(1,:)));
save(fullfile(outputDir,'OriginalPaintShadowPsychometricControl'),...
    'stimValuesMean25','pStimValuesMean25','stdErrPStimValuesMean25', ...
    'stimValuesMean50','pStimValuesMean50','stdErrPStimValuesMean50', ...
    'stimValuesMean75','pStimValuesMean75','stdErrPStimValuesMean75');

% Figure of aggregate psychometric functions.  These are weighted by
% session, so subjects who ran multiple sessions are weighted more.
allPsychoFig = figure; clf; hold on
set(gcf,'Position',figParams.position);
set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);
plot(log10(stimValuesMean25),pStimValuesMean25,'r','LineWidth',figParams.lineWidth+1);
plot(log10(stimValuesMean50),pStimValuesMean50,'g','LineWidth',figParams.lineWidth+1);
plot(log10(stimValuesMean75),pStimValuesMean75,'b','LineWidth',figParams.lineWidth+1);
ylim([figParams.fractionLimLow figParams.fractionLimHigh]);
set(gca,'YTick',figParams.fractionTicks);
set(gca,'YTickLabels',figParams.fractionTickLabels);
xlabel('Log Comparison Luminance','FontSize',figParams.labelFontSize);
ylabel('Fraction Comparison Lighter','FontSize',figParams.labelFontSize);
title('Aggregate Paint-Paint Psychometric Functions','FontSize',figParams.labelFontSize);
legend({'Test Lum 0.25' 'Test Lum 0.50' 'Test Lum 0.75'},'Location','NorthWest','FontSize',figParams.legendFontSize);
FigureSave(fullfile(outputDir,'OriginalPaintShadowAveragePsychometricLog'),allPsychoFig,figParams.figType);

%% Figure of percent correct for various incremental step sizes
% as a function of base luminance.
%
% Same aggregate data as for the psychometric plot just above.
%
% Commented out my adjustments of sizes and fonts, so that this plays
% well with the way Doug would like to make the figures for the paper.
allProbFig = figure; clf; hold on
%set(gcf,'Position',figParams.position);
%set(gca,'FontName',figParams.fontName,'FontSize',figParams.axisFontSize,'LineWidth',figParams.axisLineWidth);

% Pull out the data we want
theBases = [0.25 0.50 0.75]';
theIncrs = 0.10;
for ii = 1:length(theBases)
    for jj = 1:length(theIncrs)
        base = theBases(ii);
        incr = theIncrs(jj);
        switch (base)
            case 0.25
                index = find(abs(stimValuesMean25-(base+incr)) < 1e-8);
                theProbs(ii,jj) = pStimValuesMean25(index);
                theStderrs(ii,jj) = stdErrPStimValuesMean25(index);
            case 0.50
                index = find(abs(stimValuesMean50-(base+incr)) < 1e-8);
                theProbs(ii,jj) = pStimValuesMean50(index);
                theStderrs(ii,jj) = stdErrPStimValuesMean50(index);
            case 0.75
                index = find(abs(stimValuesMean75-(base+incr)) < 1e-8);
                theProbs(ii,jj) = pStimValuesMean75(index);
                theStderrs(ii,jj) = stdErrPStimValuesMean75(index);
            otherwise
                error('This klugy code has gotten the better of you.');
        end
    end
end

% And make the plot
probColors = ['k' 'g' 'b'];
for jj = 1:length(theIncrs)
    errorbar(theBases,theProbs(:,jj),theStderrs(:,jj),theStderrs(:,jj),[probColors(jj) 'o'],'MarkerFaceColor',probColors(jj)); %,'MarkerSize',figParams.markerSize);
end
for jj = 1:length(theIncrs)
    plot(theBases,theProbs(:,jj),probColors(jj)); %,'LineWidth',figParams.lineWidth);
end
xlim([0 1]);
set(gca,'XTick',[0 0.25 0.5 0.75 1]);
set(gca,'XTickLabels',{'0.00' '0.25' '0.50' '0.75' '1.00'})
ylim([0.5 1.01]);
set(gca,'YTick',[0.5 0.75 1.00]);
set(gca,'YTickLabels',{'0.50 ' '0.75 ' '1.00 '});
xlabel('Test Luminance'); %,'FontSize',figParams.labelFontSize);
ylabel('Fraction Correct'); %,'FontSize',figParams.labelFontSize);
legend({'Increment 0.10'}); %,'Location','SouthWest','FontSize',figParams.legendFontSize);
set(gca(allProbFig),'tickdir','out')
a=get(gca(allProbFig),'ticklength');
set(gca(allProbFig),'ticklength',[a(1)*2,a(2)*2])
box off

% Save it out, including eps version.
FigureSave(fullfile(outputDir,'OriginalPaintShadowAverageProbCorrect'),allProbFig,figParams.figType);
exportfig(gcf,fullfile(outputDir,'OriginalPaintShadowAverageProbCorrect.eps'),'Format','eps','Width',4,'Height',4,'FontMode','fixed','FontSize',10,'color','cmyk')

