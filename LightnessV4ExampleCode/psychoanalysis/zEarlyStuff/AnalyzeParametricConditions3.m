function summaryDataStruct = AnalyzeParametricConditions3(subjectToAnalyze,conditionToAnalyze,analysisFitType)
% summaryDataStruct = AnalyzeParametricConditions3(subjectToAnalyze,conditionToAnalyze)
%
% Script that tracks data and makes summary plots of various conditions.
%
% Will prompt for subject/condition to analyze if not passed.
% For condition, 0 means analyze all subjects/conditions.
%
% Argument analysisFitType determines how inferred matches are fit
%   gain
%   intercept (default)
%   affine
%
% 9/8/13        dhb Wrote from ParametricConditions2 version.
% 11/17/13      dhb Change thresholding params to have separate ref/test values.
% 2/22/14       dhb Better control over figure look.
%                   Intercept only fit option.
% 5/12/14       dhb Pass analysisFitType

%% Clear all
close all;

%% Check third arg
if (nargin < 3 | isempty(analysisFitType))
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
codeDir = fullfile(fileparts(fileparts(which(mfilename))), 'code');
AddToMatlabPathDynamically(codeDir);

% Figure out where the top level data directory is.
dataSubDir = 'parametricConditions3';
dataDir = fullfile(fileparts(fileparts(which(mfilename))), 'data', dataSubDir,'');
curDir = pwd;

% x values for linear predictions
predX = linspace(analysisParams.lowerRefThresh,analysisParams.upperRefThresh,100)';

%% Condition numbering initialize
theBaseConditionNumber = 50;

%% Subject names initialize
subjectNames = {};
theSubjectNumber = 0;

%% Subject DHB
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'dhb'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c51_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c52_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c53_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 ];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c54_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c55_shd_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

%% Subject AQR
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'aqr'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c51_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c52_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c53_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c54_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c55_shd_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject CNJ
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'cnj'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c51_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c52_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c53_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c54_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c55_shd_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject EJE
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'eje'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c51_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [3 4];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c52_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c53_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c54_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c55_shd_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];


%% Figure out which subject to analyze
if (nargin < 1 || isempty(subjectToAnalyze))
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
    if (nargin < 2 || isempty(conditionToAnalyze))
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
        if (length(conditionToAnalyzeList{s}) == 1)
            c1 = 1;
        else
            c1 = c-theBaseConditionNumber;
        end
        whichFixedData = [];
        whichRun = [];
        refData = [];
        testData = [];
        if (length(conditionStructs{s,c,2}) > 0)
            
            fprintf('\nCondition struct item %d, %s, %d files\n',c,conditionStructs{s,c,1},length(conditionStructs{s,c,2}));
            for j = 1:length(conditionStructs{s,c,2})
                fileNumber = conditionStructs{s,c,2}(j);
                fprintf('\nFile: %s\n',[conditionStructs{s,c,1} '-' num2str(fileNumber)]);
                dataStruct{c,j} = LV4AnalyzeStaircaseDataFileWithSummary(conditionStructs{s,c,1},subjectName,fileNumber,dataSubDir,psychoAnalysisParams);
                whichFixedData = [whichFixedData dataStruct{c,j}.data.whichFixed];
                whichRun = [whichRun j*ones(size([dataStruct{c,j}.data.refIntensity]))];
                refData = [refData dataStruct{c,j}.data.refIntensity];
                testData = [testData dataStruct{c,j}.data.testIntensity];
                
                % Could check here that condition fields of the returned data structs match as expected.
            end
            
            summaryDataStruct{c1} = dataStruct{c,1};
            summaryDataStruct{c1}.subject = subjectNames{s};
            summaryDataStruct{c1}.whichFixedData = whichFixedData';
            summaryDataStruct{c1}.whichRun = whichRun';
            summaryDataStruct{c1}.refData = refData';
            summaryDataStruct{c1}.testData = testData';
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
            %set(dataFig,'Position',[1000 950 1000 1000]);
            set(gca,'FontSize',analysisParams.axisFontSize);
            for j = 1:length(conditionStructs{s,c,2})
                theIndex = find(summaryDataStruct{c1}.whichRun == j);
                plot(summaryDataStruct{c1}.refData(theIndex),summaryDataStruct{c1}.testData(theIndex),[analysisParams.theColors(j) 'o'],'MarkerFaceColor',analysisParams.theColors(j),'MarkerSize',analysisParams.markerSize);
            end
            plot(summaryDataStruct{c1}.predX,summaryDataStruct{c1}.predData,'k','LineWidth',analysisParams.lineWidth);
            plot([analysisParams.intensityLimLow analysisParams.intensityLimHigh],[analysisParams.intensityLimLow analysisParams.intensityLimHigh],'k:','LineWidth',analysisParams.lineWidth);
            axis([analysisParams.intensityLimLow analysisParams.intensityLimHigh analysisParams.intensityLimLow analysisParams.intensityLimHigh]);
            set(gca,'XTick',analysisParams.intensityTicks,'XTickLabel',analysisParams.intensityTickLabels);
            set(gca,'YTick',analysisParams.intensityTicks,'XTickLabel',analysisParams.intensityTickLabels);
            xlabel('Reference Context Disk Luminance','FontSize',analysisParams.labelFontSize);
            ylabel('Comparison Context Disk Luminance','FontSize',analysisParams.labelFontSize);
            titleRoot = sprintf('%s',LiteralUnderscore([conditionStructs{s,c,1} ', ', subjectName]));
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
            title({titleRoot ; titleDetails},'FontSize',analysisParams.titleFontSize-4);
            axis('square');
            
            % Save plot
            dataFigDir = fullfile(dataDir,conditionStructs{s,c,1},subjectName,'');
            cd(dataFigDir);
            FigureSave(['Summary_' analysisParams.fitType '_' subjectNames{s} '_' num2str(protocolNumbers{s,c})],dataFig,analysisParams.figType);
            cd(curDir);
            close(dataFig);
        else
            fprintf('\tNo files for condition struct item %d for this subject\n',c);
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


