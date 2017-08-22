%  AnalyzeInitialLightnessData
%
% Script that tracks data and makes summary plots of various conditions.
%
% 1/8/13  dhb  Wrote it.
% 2/20/13 dhb  More flexible subject/file handling
% 6/23/13 dhb  Look for data in subfolder initialLightnessData

%% Clear all
clear; close all;

%% Initialization
% Dynamically add the program code to the path if it isn't already on it.
% We do this so we have access to the enumeration classes for this
% experiment.
codeDir = fullfile(fileparts(fileparts(which(mfilename))), 'code');
if isempty(strfind(path, codeDir))
    fprintf('- Adding %s dynamically to the path...', mfilename);
    addpath(RemoveSVNPaths(genpath(codeDir)), '-end');
    fprintf('Done\n');
end

% Figure out where the top level data directory is.
dataSubDir = 'initialLightness';
dataDir = fullfile(fileparts(fileparts(which(mfilename))), 'data', dataSubDir,'');
curDir = pwd;

% x values for linear predictions
predX = linspace(0,1,100);
theColors = ['r' 'b' 'g' 'k' 'c' 'y'];

%% Subject names initialize
subjectNames = {};
theSubjectNumber = 0;

%% Subject DHB
theSubjectNumber = theSubjectNumber+1;
subjectNames = {subjectNames{1:end} 'dhb'};
conditionStructs{theSubjectNumber,1,1} = 'pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_time1';
conditionStructs{theSubjectNumber,1,2} = [1];
conditionStructs{theSubjectNumber,2,1} = 'pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_time1';
conditionStructs{theSubjectNumber,2,2} = [1 2];

%% Subject KRD
theSubjectNumber = theSubjectNumber+1;
subjectNames = {subjectNames{1:end} 'krd'};
conditionStructs{theSubjectNumber,1,1} = 'pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_time1';
conditionStructs{theSubjectNumber,1,2} = [];
conditionStructs{theSubjectNumber,2,1} = 'pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_time1';
conditionStructs{theSubjectNumber,2,2} = [1];

%% Subject ZZL
theSubjectNumber = theSubjectNumber+1;
subjectNames = {subjectNames{1:end} 'zzl'};
conditionStructs{theSubjectNumber,1,1} = 'pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_time1';
conditionStructs{theSubjectNumber,1,2} = [2 3];
conditionStructs{theSubjectNumber,2,1} = 'pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_time1';
conditionStructs{theSubjectNumber,2,2} = [1 2];
conditionStructs{theSubjectNumber,3,1} ='pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad8_blk10_cen30_time1';
conditionStructs{theSubjectNumber,3,2} = [1];

%% Subject JNE
theSubjectNumber = theSubjectNumber+1;
subjectNames = {subjectNames{1:end} 'jne'};
conditionStructs{theSubjectNumber,1,1} = 'pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_time1';
conditionStructs{theSubjectNumber,1,2} = [3 4 5 6];
conditionStructs{theSubjectNumber,2,1} = 'pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_time1';
conditionStructs{theSubjectNumber,2,2} = [2 3 4];
conditionStructs{theSubjectNumber,3,1} ='pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad8_blk10_cen30_time1';
conditionStructs{theSubjectNumber,3,2} = [1];
conditionStructs{theSubjectNumber,4,1} ='pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad8_blk10_cen30_time1b';
conditionStructs{theSubjectNumber,4,2} = [1 2 3 4]; 
conditionStructs{theSubjectNumber,5,1} ='pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad8_blk10_cen89_time1';
conditionStructs{theSubjectNumber,5,2} = [1 2];

% Analyze each individual file and build up summary
for s = 1:length(subjectNames)
    subjectName = subjectNames{s};
    fprintf('Analyzing data for subject %s\n',subjectName);
    clear dataStruct
    for c = 1:size(conditionStructs,2)
        whichFixedData = [];
        refData = [];
        testData = [];
        whichRun = [];
        if (length(conditionStructs{s,c,2}) > 0)
            
            fprintf('\tCondition %d, %s, %d files\n',c,conditionStructs{s,c,1},length(conditionStructs{s,c,2}));
            for j = 1:length(conditionStructs{s,c,2})
                fileNumber = conditionStructs{s,c,2}(j);
                fprintf('\t\tFile: %s\n',[conditionStructs{s,c,1} '-' num2str(fileNumber)]);
                dataStruct{c,j} = LV4AnalyzeDataFile(conditionStructs{s,c,1},subjectName,fileNumber,dataSubDir);
                whichFixedData = [whichFixedData dataStruct{c,j}.whichFixed];
                refData = [refData dataStruct{c,j}.refIntensity];
                testData = [testData dataStruct{c,j}.testIntensity];
                whichRun = [whichRun j*ones(size([dataStruct{c,j}.refIntensity]))];
            end
            whichFixedData = whichFixedData'; refData = refData'; testData = testData'; whichRun = whichRun';
            theSlope = refData\testData;
            
            dataFig = figure; clf;
            set(dataFig,'Position',[1000 950 800 400]);
            subplot(1,2,1); hold on
            for j = 1:length(conditionStructs{s,c,2})
                theIndex = find(whichFixedData == 1 & whichRun == j);
                plot(refData(theIndex),testData(theIndex),[theColors(j) 'o'],'MarkerFaceColor',theColors(j),'MarkerSize',8);
            end
            plot(predX,theSlope*predX,'r');
            plot([0 1],[0 1],'k:');
            axis([0 1 0 1]);
            axis('square');
            xlabel('Reference context value','FontSize',12);
            ylabel('Test context value','FontSize',12);
            title(sprintf('Ref context stim fixed'),'FontSize',12);
            
            subplot(1,2,2); hold on
            for j = 1:length(conditionStructs{s,c,2})
                theIndex = find(whichFixedData == 2 & whichRun == j);
                plot(refData(theIndex),testData(theIndex),[theColors(j) 'o'],'MarkerFaceColor',theColors(j),'MarkerSize',8);
            end
            plot(predX,theSlope*predX,'r');
            plot([0 1],[0 1],'k:');
            axis([0 1 0 1]);
            axis('square');
            xlabel('Reference context value','FontSize',12);
            ylabel('Test context value','FontSize',12);
            title(sprintf('Test context stim fixed'),'FontSize',12);
            
            [~,h] = suplabel(sprintf('%s: Slope %0.2f',LiteralUnderscore([conditionStructs{s,c,1} ', ', subjectName]),theSlope),'t');
            set(h,'FontSize',14);
            
            dataFigDir = fullfile(dataDir,conditionStructs{s,c,1},subjectName,'');
            cd(dataFigDir);
            savefig('Summary',dataFig,'pdf');
            cd(curDir);
            close(dataFig);
        else
            fprintf('\tNo files for condition %d, %s\n',c,conditionStructs{s,c,1});
        end
    end
end

