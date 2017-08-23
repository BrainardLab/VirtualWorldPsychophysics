function summaryStruct = AnalyzeParametricConditions1(subjectToAnalyze,conditionToAnalyze)
% summaryStruct = AnalyzeParametricConditions1(subjectToAnalyze,conditionToAnalyze)
%
% Script that tracks data and makes summary plots of various conditions.
%
% Will prompt for subject/condition to analyze if not passed.
% For condition, 0 means analyze all subjects/conditions.
%
% 7/2/13   dhb  Wrote from InitialStaircase version.
% 7/29/13  dhb  Move save of summary outside of condition loop, where it belongs. 

%% Clear all
close all;

%% Analysis parameters
analysisParams.lowerThresh = -0.2;
analysisParams.upperThresh = 1.2;
analysisParams.threshold = true;
analysisParams.affine = true;
analysisParams.theColors = ['r' 'b' 'g' 'k' 'c' 'y'];
analysisParams.limLow = -0.5;
analysisParams.limHigh = 1.5;
analysisParams.markerSize = 10;
analysisParams.axisFontSize = 14;
analysisParams.labelFontSize = 16;
analysisParams.titleFontSize = 12;

%% Initialization
% Dynamically add the program code to the path if it isn't already on it.
% We do this so we have access to the enumeration classes for this
% experiment.
codeDir = fullfile(fileparts(fileparts(which(mfilename))), 'code');
AddToMatlabPathDynamically(codeDir);

% Figure out where the top level data directory is.
dataSubDir = 'parametricConditions1';
dataDir = fullfile(fileparts(fileparts(which(mfilename))), 'data', dataSubDir,'');
curDir = pwd;

% x values for linear predictions
predX = linspace(analysisParams.lowerThresh,analysisParams.upperThresh,100)';

%% Condition numbering initialize
theBaseConditionNumber = 20;

%% Subject names initialize
subjectNames = {};
theSubjectNumber = 0;

%% Subject AQR
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'aqr'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 21;
protocolNames{theSubjectNumber,theConditionNumber} = 'c21_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 22;
protocolNames{theSubjectNumber,theConditionNumber} = 'c22_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 23;
protocolNames{theSubjectNumber,theConditionNumber} =  'c23_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 24;
protocolNames{theSubjectNumber,theConditionNumber} = 'c24_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 25;
protocolNames{theSubjectNumber,theConditionNumber} = 'c25_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 26;
protocolNames{theSubjectNumber,theConditionNumber} = 'c26_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];
theConditionNumber = theConditionNumber + 1;

protocolNumbers{theSubjectNumber,theConditionNumber} = 27;
protocolNames{theSubjectNumber,theConditionNumber} = 'c27_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 28;
protocolNames{theSubjectNumber,theConditionNumber} = 'c28_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 29;
protocolNames{theSubjectNumber,theConditionNumber} = 'c29_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen70_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 30;
protocolNames{theSubjectNumber,theConditionNumber} = 'c30_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen70_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject BAF

theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'baf'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 21;
protocolNames{theSubjectNumber,theConditionNumber} = 'c21_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 22;
protocolNames{theSubjectNumber,theConditionNumber} = 'c22_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 23;
protocolNames{theSubjectNumber,theConditionNumber} =  'c23_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 24;
protocolNames{theSubjectNumber,theConditionNumber} = 'c24_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 25;
protocolNames{theSubjectNumber,theConditionNumber} = 'c25_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 26;
protocolNames{theSubjectNumber,theConditionNumber} = 'c26_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];
theConditionNumber = theConditionNumber + 1;

protocolNumbers{theSubjectNumber,theConditionNumber} = 27;
protocolNames{theSubjectNumber,theConditionNumber} = 'c27_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 28;
protocolNames{theSubjectNumber,theConditionNumber} = 'c28_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 29;
protocolNames{theSubjectNumber,theConditionNumber} = 'c29_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen70_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 30;
protocolNames{theSubjectNumber,theConditionNumber} = 'c30_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen70_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];


%% Subject CNJ

theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'cnj'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 21;
protocolNames{theSubjectNumber,theConditionNumber} = 'c21_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 22;
protocolNames{theSubjectNumber,theConditionNumber} = 'c22_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 23;
protocolNames{theSubjectNumber,theConditionNumber} =  'c23_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 24;
protocolNames{theSubjectNumber,theConditionNumber} = 'c24_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 25;
protocolNames{theSubjectNumber,theConditionNumber} = 'c25_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 26;
protocolNames{theSubjectNumber,theConditionNumber} = 'c26_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];
theConditionNumber = theConditionNumber + 1;

protocolNumbers{theSubjectNumber,theConditionNumber} = 27;
protocolNames{theSubjectNumber,theConditionNumber} = 'c27_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 28;
protocolNames{theSubjectNumber,theConditionNumber} = 'c28_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 29;
protocolNames{theSubjectNumber,theConditionNumber} = 'c29_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk20_cen70_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 30;
protocolNames{theSubjectNumber,theConditionNumber} = 'c30_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk20_cen70_t1';
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
        conditionToAnalyzeList{1} = -1;
        while ((conditionToAnalyzeList{1} ~= 0 & ...
                conditionToAnalyzeList{1} < theBaseConditionNumber + 1) | ...
                (conditionToAnalyzeList{1} ~= 0 & ...
                conditionToAnalyzeList{1} > theBaseConditionNumber + length({protocolNumbers{subjectToAnalyze,theBaseConditionNumber+1:end}})))
            conditionToAnalyzeList{1} = GetWithDefault('Enter condition number to analyze (0 for all)',0);
        end
    else
        conditionToAnalyzeList{1} = conditionToAnalyze;
    end
end
if (conditionToAnalyzeList{1} == 0)
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
                dataStruct{c,j} = LV4AnalyzeStaircaseDataFileWithSummary(conditionStructs{s,c,1},subjectName,fileNumber,dataSubDir);
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
                
                indexLow = summaryDataStruct{c1}.refData < analysisParams.lowerThresh;
                summaryDataStruct{c1}.refDataThresholded(indexLow) = analysisParams.lowerThresh;
                indexLow = summaryDataStruct{c1}.testData < analysisParams.lowerThresh;
                summaryDataStruct{c1}.testDataThresholded(indexLow) = analysisParams.lowerThresh;
                indexHigh = summaryDataStruct{c1}.refData > analysisParams.upperThresh;
                summaryDataStruct{c1}.refDataThresholded(indexHigh) = analysisParams.upperThresh;
                indexHigh = summaryDataStruct{c1}.testData > analysisParams.upperThresh;
                summaryDataStruct{c1}.testDataThresholded(indexHigh) = analysisParams.upperThresh;
                
                % The other option is just to exclude the data outside the reasonable range
            else
                index = find(refData < analysisParams.upperThresh & refData > analysisParams.lowerThresh & testData < analysisParams.upperThresh & testData > analysisParams.lowerThresh);
                summaryDataStruct{c1}.refDataThresholded = summaryDataStruct{c1}.refData(index);
                summaryDataStruct{c1}.testDataThresholded = summaryDataStruct{c1}.testData(index);
            end
            
            % Fit the data
            summaryDataStruct{c1}.predX = predX;
            if (analysisParams.affine)
                summaryDataStruct{c1}.theFit = [summaryDataStruct{c1}.refDataThresholded ones(size(summaryDataStruct{c1}.refDataThresholded))]\summaryDataStruct{c1}.testDataThresholded;
                summaryDataStruct{c1}.predData = [summaryDataStruct{c1}.predX ones(size(predX))]*summaryDataStruct{c1}.theFit;
            else
                summaryDataStruct{c1}.theFit = summaryDataStruct{c1}.refDataThresholded\summaryDataStruct{c1}.testDataThresholded;
                summaryDataStruct{c1}.predData =summaryDataStruct{c1}.predX*summaryDataStruct{c1}.theFit;
            end
            
            % Summary plot of fit
            dataFig = figure; clf; hold on
            set(dataFig,'Position',[1000 950 800 800]);
            set(gca,'FontSize',analysisParams.axisFontSize);
            for j = 1:length(conditionStructs{s,c,2})
                theIndex = find(summaryDataStruct{c1}.whichRun == j);
                plot(summaryDataStruct{c1}.refData(theIndex),summaryDataStruct{c1}.testData(theIndex),[analysisParams.theColors(j) 'o'],'MarkerFaceColor',analysisParams.theColors(j),'MarkerSize',analysisParams.markerSize);
            end
            plot(summaryDataStruct{c1}.predX,summaryDataStruct{c1}.predData,'r');
            plot([analysisParams.limLow analysisParams.limHigh],[analysisParams.limLow analysisParams.limHigh],'k:');
            axis([analysisParams.limLow analysisParams.limHigh analysisParams.limLow analysisParams.limHigh]);
            xlabel('Reference context value','FontSize',analysisParams.labelFontSize);
            ylabel('Test context value','FontSize',analysisParams.labelFontSize);
            if (analysisParams.affine)
                title(sprintf('%s: Slope %0.2f, Intercept %0.2f',LiteralUnderscore([conditionStructs{s,c,1} ', ', subjectName]),...
                    summaryDataStruct{c1}.theFit(1),summaryDataStruct{c1}.theFit(2)),'FontSize',analysisParams.titleFontSize);
            else
                title(sprintf('%s: Slope %0.2f',LiteralUnderscore([conditionStructs{s,c,1} ', ', subjectName]),theFit(1)),'FontSize',analysisParams.titleFontSize);
            end
            
            % Save plot
            dataFigDir = fullfile(dataDir,conditionStructs{s,c,1},subjectName,'');
            cd(dataFigDir);
            savefig(['Summary_' subjectNames{s} '_' num2str(protocolNumbers{s,c})],dataFig,'pdf');
            savefig(['Summary_' subjectNames{s} '_' num2str(protocolNumbers{s,c})],dataFig,'png');
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
        save(fullfile(dataDir,'Summary',subjectNames{s},'SummaryData'),'summaryDataStruct');
    end
        
end




end


