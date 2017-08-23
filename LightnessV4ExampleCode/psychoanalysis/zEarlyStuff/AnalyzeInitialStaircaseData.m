% AnalyzeInitialStaircaseData
%
% Script that tracks data and makes summary plots of various conditions.
%
% 3/27/13  dhb  Wrote it.
% 5/21/12  dhb  Tune up bookkeeping.
% 6/23/13  dhb  Look for data in initialStaircaseData.

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
dataSubDir = 'initialStaircase';
dataDir = fullfile(fileparts(fileparts(which(mfilename))), 'data', dataSubDir,'');
curDir = pwd;

% x values for linear predictions
predX = linspace(0,1,100);
theColors = ['r' 'b' 'g' 'k' 'c' 'y'];

%% Subject names initialize
subjectNames = {};
theSubjectNumber = 0;

%% Subject JNE
% This subject has a lot of bizarre individual staircases and
% consequent huge variability in the summary numbers.  The
% subject was discontinued because this problem persisted.  Not
% clear what was going on.  
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = 0;
subjectNames = {subjectNames{1:end} 'jne'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 7;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 8;
protocolNames{theSubjectNumber,theConditionNumber} =  'sc_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad8_blk10_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad8_blk10_cen89_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 ];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 ];
theConditionNumber = theConditionNumber + 1;

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 ];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 ];

%% Subject FDP
% This subjects staircases look good and summary data are generally
% reliable.
theSubjectNumber = theSubjectNumber+1;
subjectNames = {subjectNames{1:end} 'fdp'};
theConditionNumber = 0;

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 7;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 8;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad8_blk10_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3 4];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_shd_rot0_shad8_blk10_cen89_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject AQR
% This subjects staircases ...
theSubjectNumber = theSubjectNumber+1;
subjectNames = {subjectNames{1:end} 'aqr'};
theConditionNumber = 0;

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [2 3 4];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3 4];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad2_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad16_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 19;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot70_shad4_blk30_cen30_vs_pnt_rot70_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 20;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot70_shad4_blk30_cen30_vs_shd_rot70_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject CNJ
% This subjects staircases ...
theSubjectNumber = theSubjectNumber+1;
subjectNames = {subjectNames{1:end} 'cnj'};
theConditionNumber = 0;

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [2 3 4];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad2_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad16_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];


%% Subject BAF
% This subjects staircases ...
theSubjectNumber = theSubjectNumber+1;
subjectNames = {subjectNames{1:end} 'baf'};
theConditionNumber = 0;

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [2 3 4];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_pnt_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot70_shad8_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad2_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot0_shad8_blk30_cen30_vs_shd_rot0_shad16_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 19;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot70_shad4_blk30_cen30_vs_pnt_rot70_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 20;
protocolNames{theSubjectNumber,theConditionNumber} = 'spe_pnt_rot70_shad4_blk30_cen30_vs_shd_rot70_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2 3];


%% Subject TEST (test data)
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = 0;
subjectNames = {subjectNames{1:end} 'test'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,1,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,1,2} = [1 2];

%% Subject DHB (test data)
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = 0;
subjectNames = {subjectNames{1:end} 'dhb'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'sc_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,1,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,1,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'spi_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1';
conditionStructs{theSubjectNumber,2,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,2,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = 10;
protocolNames{theSubjectNumber,theConditionNumber} = 'spi_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad8_blk10_cen89_t1';
conditionStructs{theSubjectNumber,3,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,3,2} = [1];


%% Figure out which subject to analyze
fprintf('Available subjects:\n');
for s = 1:length(subjectNames)
    fprintf('\t%d - %s\n',s,subjectNames{s});
end
subjectToAnalyze = 0;
while (subjectToAnalyze < 1 | subjectToAnalyze > length(subjectNames))
    subjectToAnalyze = GetWithDefault('Enter subject number to analyze',1);
end

% Analyze each individual file and build up summary
limLow = -0.2;
limHigh = 1.2;
for s = subjectToAnalyze
    subjectName = subjectNames{s};
    fprintf('Analyzing data for subject %s\n',subjectName);
    clear dataStruct
    for c = 1:size(conditionStructs,2)
        whichFixedData = [];
        refData = [];
        testData = [];
        whichRun = [];
        if (length(conditionStructs{s,c,2}) > 0)
            
            fprintf('\nCondition struct item %d, %s, %d files\n',c,conditionStructs{s,c,1},length(conditionStructs{s,c,2}));
            for j = 1:length(conditionStructs{s,c,2})
                fileNumber = conditionStructs{s,c,2}(j);
                fprintf('\nFile: %s\n',[conditionStructs{s,c,1} '-' num2str(fileNumber)]);
                dataStruct{c,j} = LV4AnalyzeStaircaseDataFile(conditionStructs{s,c,1},subjectName,fileNumber,dataSubDir);
                whichFixedData = [whichFixedData dataStruct{c,j}.whichFixed];
                refData = [refData dataStruct{c,j}.refIntensity];
                testData = [testData dataStruct{c,j}.testIntensity];
                whichRun = [whichRun j*ones(size([dataStruct{c,j}.refIntensity]))];
            end
            whichFixedData = whichFixedData'; refData = refData'; testData = testData'; whichRun = whichRun';
            index = find(refData < 1 & refData > 0 & testData < 1 & testData > 0);
            theSlope = refData(index)\testData(index);
            
            dataFig = figure; clf;
            set(dataFig,'Position',[1000 950 800 400]);
            subplot(1,2,1); hold on
            for j = 1:length(conditionStructs{s,c,2})
                theIndex = find(whichFixedData == 1 & whichRun == j);
                plot(refData(theIndex),testData(theIndex),[theColors(j) 'o'],'MarkerFaceColor',theColors(j),'MarkerSize',8);
            end
            plot(predX,theSlope*predX,'r');
            plot([limLow limHigh],[limLow limHigh],'k:');
            axis([limLow limHigh limLow limHigh]);
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
            plot([limLow limHigh],[limLow limHigh],'k:');
            axis([limLow limHigh limLow limHigh]);
            axis('square');
            xlabel('Reference context value','FontSize',12);
            ylabel('Test context value','FontSize',12);
            title(sprintf('Test context stim fixed'),'FontSize',12);
            
            [~,h] = suplabel(sprintf('%s: Slope %0.2f',LiteralUnderscore([conditionStructs{s,c,1} ', ', subjectName]),theSlope),'t');
            set(h,'FontSize',14);
            
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
end

