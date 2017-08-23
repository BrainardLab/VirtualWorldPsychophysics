function summaryDataStruct = AnalyzeParametricConditions(pcCode,subjectToAnalyze,conditionToAnalyze,analysisFitType)
% summaryStruct = AnalyzeParametricConditions(pcCode,subjectToAnalyze,conditionToAnalyze)
%
% Function tracks data and makes summary plots of various conditions.
%
% pcCode
%   2 - parametricConditions2
%   3 - parametricConditions3
%   4 - parametricConditions4
%
% Will prompt for subject/condition to analyze if not passed.
% For condition, 0 means analyze all subjects/conditions.
%
% Argument analysisFitType determines how inferred matches are fit
%   intercept (default)
%   gain
%   affine
%
% 7/2/13        dhb Wrote from InitialStaircase version.
% 11/17/13      dhb Change thresholding params to have separate ref/test values.
% 2/22/14       dhb Better control over figure look.
%                   Intercept only fit option.
% 5/12/14       dhb Pass analysisFitType.
%               dhb Consolidate different parametric conditions analysis

%% Clear all
close all;

%% Check third arg
if (nargin < 4 || isempty(analysisFitType))
    analysisFitType = 'intercept';
end

%% Psychometric analysis params
psychoAnalysisParams = SetFigParams([],'psychophysics');
psychoAnalysisParams.generateExampleFigure = false;

%% Analysis parameters
analysisParams.lowerRefThresh = 0.25;
analysisParams.upperRefThresh = 0.75;
analysisParams.lowerTestThresh = 0;
analysisParams.upperTestThresh = 1;
analysisParams.threshold = false;
analysisParams.fitType = analysisFitType;
analysisParams = SetFigParams(analysisParams,'psychophysics');

%% Initialization
% Dynamically add the program code to the path if it isn't already on it.
% We do this so we have access to the enumeration classes for this
% experiment.
% codeDir = fullfile(fileparts(fileparts(which(mfilename))), 'code');
% AddToMatlabPathDynamically(codeDir);

% Figure out where the top level data directory is.
psychoInputBaseDir = getpref('VirtualWorldPsychophysics','psychoInputBaseDir');
dataSubDir = ['parametricConditions' num2str(pcCode)];
dataDir = fullfile(psychoInputBaseDir, dataSubDir,'');

curDir = pwd;

% Figure directory
figTopLevelDir = fullfile(getpref('VirtualWorldPsychophysics','outputBaseDir'),'xPsychoBasic');
if (~exist(figTopLevelDir,'dir'))
    mkdir(figTopLevelDir);
end
figDir = fullfile(figTopLevelDir,dataSubDir,'');
if (~exist(figDir,'dir'))
    mkdir(figDir);
end

% x values for linear predictions
predX = linspace(analysisParams.lowerRefThresh,analysisParams.upperRefThresh,100)';

%% Get condition information
switch (pcCode)
    case 2
        [subjectNames,protocolNumbers,protocalNames,conditionStructs] = SetParametricConditions2;
    case 3
        [subjectNames,protocolNumbers,protocalNames,conditionStructs] = SetParametricConditions3;
    case 4
        [subjectNames,protocolNumbers,protocalNames,conditionStructs] = SetParametricConditions4;
    otherwise
        error('Unknown condition code');
end

%% Figure out which subject to analyze
if (nargin < 2 || isempty(subjectToAnalyze))
    fprintf('Available subjects:\n');
    for s = 1:length(subjectNames)
        fprintf('\t%d - %s\n',s,subjectNames{s});
    end
    subjectToAnalyze = -1;
    while ((subjectToAnalyze ~= 0 & subjectToAnalyze < 1) | subjectToAnalyze > length(subjectNames))
        subjectToAnalyze = GetWithDefault('Enter subject number to analyze (0 for all subjects/conditions)',1);
    end
end
if (subjectToAnalyze == 0)
    subjectToAnalyze = 1:length(subjectNames);
end

%% Get conditions to analyze
% 
% If you ask for more than one subject, you get
% all conditions for all subjects.
if (length(subjectToAnalyze) > 1)
    conditionToAnalyzeList{1} = 0;
else
    if (nargin < 3 || isempty(conditionToAnalyze))
        fprintf('Available conditions:\n');
        for c = theBaseConditionNumber+1:theBaseConditionNumber + length({protocolNumbers{subjectToAnalyze,theBaseConditionNumber+1:end}})
            fprintf('\t%d - %d - %s\n',c,protocolNumbers{subjectToAnalyze,c},protocolNames{subjectToAnalyze,c});
        end
        conditionToAnalyzeList{subjectToAnalyze} = -1;
        while ((conditionToAnalyzeList{subjectToAnalyze} ~= 0 & ...
                conditionToAnalyzeList{subjectToAnalyze} < theBaseConditionNumber + 1) | ...
                (conditionToAnalyzeList{subjectToAnalyze} ~= 0 & ...
                conditionToAnalyzeList{subjectToAnalyze} > theBaseConditionNumber + length({protocolNumbers{subjectToAnalyze,theBaseConditionNumber+1:end}})))
            conditionToAnalyzeList{subjectToAnalyze} = GetWithDefault('Enter condition number to analyze (0 for all)',0);
        end
    else
        conditionToAnalyzeList{subjectToAnalyze} = conditionToAnalyze;
    end
end
if (length(subjectToAnalyze) > 1 || conditionToAnalyzeList{subjectToAnalyze} == 0)
    for s = subjectToAnalyze
        conditionToAnalyzeList{s} = theBaseConditionNumber+1:theBaseConditionNumber + length({protocolNumbers{s,theBaseConditionNumber+1:end}});
    end
end

%% Analyze each individual file and build up summary
for s = subjectToAnalyze
    subjectName = subjectNames{s};
    fprintf('Analyzing data for subject %s\n',subjectName);
    clear dataStruct
    for c = conditionToAnalyzeList{s}
        
        % Code to produce an example for poster/paper
        if (c == 31 || c == 32)
            psychoAnalysisParams.generateExampleFigure = true;
            psychoAnalysisParams.exampleFigNum = 2;
        end
                
        if (length(conditionToAnalyzeList{s}) == 1)
            c1 = 1;
        else
            c1 = c-theBaseConditionNumber;
        end
        whichFixedData = [];
        whichRun = [];
        refData = [];
        testData = [];
        thresholdData = [];
        stimValues = [];
        pStimValues = [];
        if (length(conditionStructs{s,c,2}) > 0)
            
            fprintf('\nCondition struct item %d, %s, %d files\n',c,conditionStructs{s,c,1},length(conditionStructs{s,c,2}));
            for j = 1:length(conditionStructs{s,c,2})
                fileNumber = conditionStructs{s,c,2}(j);
                fprintf('\nFile: %s\n',[conditionStructs{s,c,1} '-' num2str(fileNumber)]);

                % Analyze and store
                dataStruct{c,j} = LV4AnalyzeStaircaseDataFileWithSummary(conditionStructs{s,c,1},subjectName,fileNumber,dataDir,figDir,psychoAnalysisParams);
                whichFixedData = [whichFixedData dataStruct{c,j}.data.whichFixed];
                whichRun = [whichRun j*ones(size([dataStruct{c,j}.data.refIntensity]))];
                refData = [refData dataStruct{c,j}.data.refIntensity];
                testData = [testData dataStruct{c,j}.data.testIntensity];
                thresholdData = [thresholdData dataStruct{c,j}.data.threshold];
                stimValues = [stimValues dataStruct{c,j}.data.stimValues];
                pStimValues = [pStimValues dataStruct{c,j}.data.pStimValues];
                             
                % Could check here that condition fields of the returned data structs match as expected.
            end
            
            summaryDataStruct{c1} = dataStruct{c,1};
            summaryDataStruct{c1}.subject = subjectNames{s};
            summaryDataStruct{c1}.whichFixedData = whichFixedData';
            summaryDataStruct{c1}.whichRun = whichRun';
            summaryDataStruct{c1}.refData = refData';
            summaryDataStruct{c1}.testData = testData';
            summaryDataStruct{c1}.thresholdData = thresholdData';
            summaryDataStruct{c1}.stimValues = stimValues;
            summaryDataStruct{c1}.pStimValues = pStimValues;
            summaryDataStruct{c1}.analysisParams = analysisParams;
            clear whichFixedData whichRun refData testData
            
            %% Sometimes the PSE's are outside of the stimulus range.
            %
            % We don't want to trust them if they get too big or small,
            % because they are extrapolated.  Here we set any outside
            % a reasonable range to the edge of that range, for purposes
            % of finding the best fit.
            if (analysisParams.threshold)
                summaryDataStruct{c1}.refDataThresholded = summaryDataStruct{c1}.refData;
                summaryDataStruct{c1}.testDataThresholded = summaryDataStruct{c1}.testData;
                
                indexLow = summaryDataStruct{c1}.refData < analysisParams.lowerRefThresh;
                summaryDataStruct{c1}.refDataThresholded(indexLow) = analysisParams.lowerRefThresh;
                indexLow = summaryDataStruct{c1}.testData < analysisParams.lowerTestThresh;
                summaryDataStruct{c1}.testDataThresholded(indexLow) = analysisParams.lowerTestThresh;
                indexHigh = summaryDataStruct{c1}.refData > analysisParams.upperRefThresh;
                summaryDataStruct{c1}.refDataThresholded(indexHigh) = analysisParams.upperRefThresh;
                indexHigh = summaryDataStruct{c1}.testData > analysisParams.upperTestThresh;
                summaryDataStruct{c1}.testDataThresholded(indexHigh) = analysisParams.upperTestThresh;
                
                % The other option is just to exclude the data outside the reasonable range
            else
                index = find(summaryDataStruct{c1}.refData < analysisParams.upperRefThresh & summaryDataStruct{c1}.refData > analysisParams.lowerRefThresh & ...
                    summaryDataStruct{c1}.testData < analysisParams.upperTestThresh & summaryDataStruct{c1}.testData > analysisParams.lowerTestThresh);
                summaryDataStruct{c1}.refDataThresholded = summaryDataStruct{c1}.refData(index);
                summaryDataStruct{c1}.testDataThresholded = summaryDataStruct{c1}.testData(index);
            end
            
            % Fit the data
            summaryDataStruct{c1}.predX = predX;
            switch (analysisParams.fitType)
                case 'affine'
                    summaryDataStruct{c1}.theFit = [summaryDataStruct{c1}.refDataThresholded ones(size(summaryDataStruct{c1}.refDataThresholded))]\summaryDataStruct{c1}.testDataThresholded;
                    summaryDataStruct{c1}.predData = [summaryDataStruct{c1}.predX ones(size(predX))]*summaryDataStruct{c1}.theFit;
                case 'gain'
                    summaryDataStruct{c1}.theFit = summaryDataStruct{c1}.refDataThresholded\summaryDataStruct{c1}.testDataThresholded;
                    summaryDataStruct{c1}.predData = summaryDataStruct{c1}.predX*summaryDataStruct{c1}.theFit;
                case 'intercept'
                    summaryDataStruct{c1}.theFit = mean(summaryDataStruct{c1}.testDataThresholded) - mean(summaryDataStruct{c1}.refDataThresholded);
                    summaryDataStruct{c1}.predData = predX + summaryDataStruct{c1}.theFit;  
                otherwise
                    error('Unknown fit type specified');
            end
            
            % Summary plot of fit
            dataFig = figure; clf; hold on
            set(gcf,'Position',analysisParams.sqPosition);
            set(gca,'FontName',analysisParams.fontName,'FontSize',analysisParams.axisFontSize,'LineWidth',analysisParams.axisLineWidth);
            for j = 1:length(conditionStructs{s,c,2})
                theIndex = find(summaryDataStruct{c1}.whichRun == j);
                plot(summaryDataStruct{c1}.refData(theIndex),summaryDataStruct{c1}.testData(theIndex),[analysisParams.theColors(j) 'o'],'MarkerFaceColor',analysisParams.theColors(j),'MarkerSize',analysisParams.markerSize);
            end
            plot(summaryDataStruct{c1}.predX,summaryDataStruct{c1}.predData,'k','LineWidth',analysisParams.lineWidth);
            plot([analysisParams.intensityLimLow analysisParams.intensityLimHigh],[analysisParams.intensityLimLow analysisParams.intensityLimHigh],'k:','LineWidth',analysisParams.lineWidth);
            axis([analysisParams.intensityLimLow analysisParams.intensityLimHigh analysisParams.intensityLimLow analysisParams.intensityLimHigh]);
            set(gca,'XTick',analysisParams.intensityTicks,'XTickLabel',analysisParams.intensityTickLabels);
            set(gca,'YTick',analysisParams.intensityTicks,'YTickLabel',analysisParams.intensityTickLabels);
            xlabel('Reference Context Disk Luminance','FontSize',analysisParams.labelFontSize);
            ylabel('Comparison Context Disk Luminance','FontSize',analysisParams.labelFontSize);
            titleRoot = strrep([conditionStructs{s,c,1} ', ', subjectName],'_',' ');
            switch (analysisParams.fitType)
                case 'affine'
                    titleDetails = sprintf('Slope %0.2f, Intercept %0.2f',...
                        summaryDataStruct{c1}.theFit(1),summaryDataStruct{c1}.theFit(2));
                case 'gain'
                    titleDetails = sprintf('Slope %0.2f',summaryDataStruct{c1}.theFit(1));
                case 'intercept'
                    titleDetails = sprintf('Intercept %0.2f',summaryDataStruct{c1}.theFit(1));
                otherwise
                    error('Unknown fit type specified');
            end
            title({titleRoot ; titleDetails},'FontSize',analysisParams.titleFontSize);
            axis('square');
            
            % Save plot
            figFigDir = fullfile(figDir,conditionStructs{s,c,1},subjectName,'');
            cd(figFigDir);
            FigureSave(['Summary_' analysisParams.fitType '_' subjectNames{s} '_' num2str(protocolNumbers{s,c})],dataFig,analysisParams.figType);
            cd(curDir);
            close(dataFig);
            
            if (psychoAnalysisParams.generateExampleFigure)
                % Summary plot of fit
                dataFig1 = figure; clf; hold on
                %set(gcf,'Position',analysisParams.sqPosition);
                %set(gca,'FontName',analysisParams.fontName,'FontSize',analysisParams.axisFontSize,'LineWidth',analysisParams.axisLineWidth);
                for j = 1:length(conditionStructs{s,c,2})
                    theIndex = find(summaryDataStruct{c1}.whichRun == j);
                    plot(summaryDataStruct{c1}.refData(theIndex),summaryDataStruct{c1}.testData(theIndex),'bo','MarkerFaceColor','b'); %,'MarkerSize',analysisParams.markerSize);
                end
                plot(summaryDataStruct{c1}.predX,summaryDataStruct{c1}.predData,'b'); %,'LineWidth',analysisParams.lineWidth);
                plot([analysisParams.intensityLimLow analysisParams.intensityLimHigh],[analysisParams.intensityLimLow analysisParams.intensityLimHigh],'k:'); %,'LineWidth',analysisParams.lineWidth);
                axis([analysisParams.intensityLimLow analysisParams.intensityLimHigh analysisParams.intensityLimLow analysisParams.intensityLimHigh]);
                set(gca,'XTick',analysisParams.intensityTicks,'XTickLabel',analysisParams.intensityTickLabels);
                set(gca,'YTick',analysisParams.intensityTicks,'YTickLabel',analysisParams.intensityTickLabels);
                xlabel('Paint Disk Luminance'); %,'FontSize',analysisParams.labelFontSize);
                ylabel('Matched Shadow Disk Luminance'); %,'FontSize',analysisParams.labelFontSize);
                set(gca,'tickdir','out')
                a=get(gca,'ticklength');
                set(gca,'ticklength',[a(1)*2,a(2)*2])
                box off
                switch (analysisParams.fitType)
                    case 'affine'
                        textDetails = sprintf('Slope %0.2f, Intercept %0.2f',...
                            summaryDataStruct{c1}.theFit(1),summaryDataStruct{c1}.theFit(2));
                    case 'gain'
                        textDetails = sprintf('Paint-Shadow Effect: %0.2f',log10(summaryDataStruct{c1}.theFit(1)));
                    case 'intercept'
                        textDetails = sprintf('Paint-Shadow Effect: %0.2f',summaryDataStruct{c1}.theFit(1));
                    otherwise
                        error('Unknown fit type specified');
                end
                text(0,1,textDetails); %,'FontSize',analysisParams.labelFontSize);
                axis('square');
                
                % Save plot
                figFigDir = fullfile(figDir,conditionStructs{s,c,1},subjectName,'');
                cd(figFigDir);
                FigureSave(['Summary_' analysisParams.fitType '_' subjectNames{s} '_' num2str(protocolNumbers{s,c}) '_example'],dataFig1,analysisParams.figType);
                exportfig(dataFig1,['Summary_' analysisParams.fitType '_' subjectNames{s} '_' num2str(protocolNumbers{s,c}) '_example'],'Format','eps','Width',4,'Height',4,'FontMode','fixed','FontSize',10,'color','cmyk')

                cd(curDir);
                close(dataFig1);
                
                % Summary plot without the fit
                dataFig2 = figure; clf; hold on
                set(gcf,'Position',analysisParams.sqPosition);
                set(gca,'FontName',analysisParams.fontName,'FontSize',analysisParams.axisFontSize,'LineWidth',analysisParams.axisLineWidth);
                for j = 1:length(conditionStructs{s,c,2})
                    theIndex = find(summaryDataStruct{c1}.whichRun == j);
                    plot(summaryDataStruct{c1}.refData(theIndex),summaryDataStruct{c1}.testData(theIndex),'b^','MarkerFaceColor','b','MarkerSize',analysisParams.markerSize);
                end
                %plot(summaryDataStruct{c1}.predX,summaryDataStruct{c1}.predData,'k','LineWidth',analysisParams.lineWidth);
                plot([analysisParams.intensityLimLow analysisParams.intensityLimHigh],[analysisParams.intensityLimLow analysisParams.intensityLimHigh],'k:','LineWidth',analysisParams.lineWidth);
                axis([analysisParams.intensityLimLow analysisParams.intensityLimHigh analysisParams.intensityLimLow analysisParams.intensityLimHigh]);
                set(gca,'XTick',analysisParams.intensityTicks,'XTickLabel',analysisParams.intensityTickLabels);
                set(gca,'YTick',analysisParams.intensityTicks,'YTickLabel',analysisParams.intensityTickLabels);
                xlabel('Paint Disk Luminance','FontSize',analysisParams.labelFontSize);
                ylabel('Matched Shadow Disk Luminance','FontSize',analysisParams.labelFontSize);
                switch (analysisParams.fitType)
                    case 'affine'
                        textDetails = sprintf('Paint-Shadow Effect: %0.2f, Intercept %0.2f',...
                            summaryDataStruct{c1}.theFit(1),summaryDataStruct{c1}.theFit(2));
                    case 'gain'
                        textDetails = sprintf('Paint-Shadow Effect: %0.2f',log10(summaryDataStruct{c1}.theFit(1)));
                    case 'intercept'
                        textDetails = sprintf('Intercept of Fit Unity Slope Line: %0.2f',summaryDataStruct{c1}.theFit(1));
                    otherwise
                        error('Unknown fit type specified');
                end
                %text(0,1,textDetails,'FontSize',analysisParams.labelFontSize);
                axis('square');
                
                % Save plot
                figFigDir = fullfile(figDir,conditionStructs{s,c,1},subjectName,'');
                cd(figFigDir);
                FigureSave(['Summary_' analysisParams.fitType '_' subjectNames{s} '_' num2str(protocolNumbers{s,c}) '_example_noline'],dataFig2,analysisParams.figType);
                cd(curDir);
                close(dataFig2);
            end
        else
            fprintf('\tNo files for condition struct item %d for this subject\n',c);
        end 
        
        % Turn off example
        if (c == 31 || c == 32)
            psychoAnalysisParams.generateExampleFigure = false;
        end
                
    end
    
    % If we ran all the conditions in the analysis, save out the array of summary data
    if (length(conditionToAnalyzeList{s}) ~= 1)
        if (~exist(fullfile(dataDir,'Summary','')))
            mkdir(fullfile(dataDir,'Summary',''));
        end
        if (~exist(fullfile(dataDir,'Summary',subjectNames{s},'')))
            mkdir(fullfile(dataDir,'Summary',subjectNames{s},''));
        end
        save(fullfile(dataDir,'Summary',subjectNames{s},['SummaryData' analysisParams.fitType]),'summaryDataStruct');
    end
    
end

end


