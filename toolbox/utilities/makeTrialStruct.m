function makeTrialStruct(varargin)
%%makeTrialStruct Make a struct with trial information about one experiment
%
% Usage: 
%   makeTrialStruct();
%
% Description:
%   Use the LMS struct to make a trial struct. The LMS struct must have
%   fields LMSImageInCalFormat, luminanceLevels, uniqueLuminanceLevels, 
%   reflectanceNumber
%
% Input:
%   None
%
% Output:
%   None
%
% Fields in trialStruct
% trialStruct.trialStdIndex : Index of standard image to be used in the trials
% trialStruct.trialCmpIndex : Index of comparison image to be used in the trial, 
%               should be the same as S.trailStdIndex 
% trialStruct.stdY : standard lightness level
% trialStruct.cmpY : comparison lightness levels
% trialStruct.stdYInTrial : std lightness for each trial
% trialStruct.cmpYInTrial : cmp lightness for each trial
%
% Optional key/value pairs:
%    'directoryName' : Name of directory to read LMS struct (default 'ExampleCase')
%    'LMSstructName' : Name of RGB struct file (default LMSStruct)
%    'outputFileName': Name of file to save trial output struct (default 'exampleTrial')
%    'nTrails' : Number of trials (default -> 10)
%    'stdY' : Index of standard lightness level (default -> 5)
%    'cmpY' : Index of comparison lightness level (defalut -> [1:10])

% 10/19/2017 VS wrote this
%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('LMSstructName', 'LMSStruct', @ischar);
parser.addParameter('outputFileName', 'exampleTrial', @ischar);
parser.addParameter('nBlocks', 10, @isscalar);
parser.addParameter('stdYIndex', 5, @isnumeric);
parser.addParameter('cmpYIndex', (1:10), @isnumeric);
parser.addParameter('comparisionTargetSameSpectralShape', true, @islogical);
parser.parse(varargin{:});


directoryName = parser.Results.directoryName;
LMSstructName = parser.Results.LMSstructName;
outputFileName = parser.Results.outputFileName;
nBlocks = parser.Results.nBlocks;
stdYIndex = parser.Results.stdYIndex;
cmpYIndex = parser.Results.cmpYIndex;

projectName = 'VirtualWorldPsychophysics';

%% Load the LMS struct
pathToLMSStruct = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                directoryName,[LMSstructName,'.mat']);
load(pathToLMSStruct);

%%
trialStruct.LMSstructName = LMSstructName;
trialStruct.stdY = LMSStruct.uniqueLuminanceLevels(stdYIndex);
trialStruct.cmpY = LMSStruct.uniqueLuminanceLevels(cmpYIndex);
trialStruct.nBlocks = nBlocks;
nCmpLevels = length(cmpYIndex);

indexOfStandardImages = find(LMSStruct.luminanceLevelIndex == stdYIndex);

for iterBlocks = 1 : nBlocks
%     for iterCmpLevels = 1 : length()
    % Pick random indices for the standard image equal to the number of
    % comparison levels
    tempStdIndex = randi(length(indexOfStandardImages),1,nCmpLevels);
    trialStruct.trialStdIndex((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels) = ...
        indexOfStandardImages(tempStdIndex);
    trialStruct.stdYInTrial((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels) = ...
        LMSStruct.luminanceLevels(trialStruct.trialStdIndex((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels));
    
    % Pick a comparison level randomly for each randomly chosen standard
    % level
    tempCmpLvl = cmpYIndex(randperm(nCmpLevels));
    for ii = 1 : length(tempCmpLvl)
        indexOfCmpImages = find(LMSStruct.luminanceLevelIndex == tempCmpLvl(ii));
        if (parser.Results.comparisionTargetSameSpectralShape)
            trialStruct.trialCmpIndex((iterBlocks-1)*nCmpLevels+ii) = indexOfCmpImages(tempStdIndex(ii));
        else
            trialStruct.trialCmpIndex((iterBlocks-1)*nCmpLevels+ii) = indexOfCmpImages(randi(length(indexOfCmpImages)));
        end
    end
    trialStruct.cmpYInTrial((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels) = ...
        LMSStruct.luminanceLevels(trialStruct.trialCmpIndex((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels));
    trialStruct.luminanceLevelIndexInTrialCmp((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels) = ...
        LMSStruct.luminanceLevelIndex(trialStruct.trialCmpIndex((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels));
    trialStruct.luminanceLevelIndexInTrialStd((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels) = ...
        LMSStruct.luminanceLevelIndex(trialStruct.trialStdIndex((iterBlocks-1)*nCmpLevels+1:iterBlocks*nCmpLevels));

end

% Till now each block contains one data point at each comparison level.
% This is not good as the subject might learn that a particular levels is
% not going to come once it comes in a block. To fix this the trials need
% to be shuffled.

newIndex = randperm(nBlocks*nCmpLevels);
trialStruct.trialStdIndex = trialStruct.trialStdIndex(newIndex);
trialStruct.trialCmpIndex= trialStruct.trialCmpIndex(newIndex);
trialStruct.stdYInTrial= trialStruct.stdYInTrial(newIndex);
trialStruct.cmpYInTrial = trialStruct.cmpYInTrial(newIndex);
trialStruct.luminanceLevelIndexInTrialCmp = trialStruct.luminanceLevelIndexInTrialCmp(newIndex);
trialStruct.luminanceLevelIndexInTrialStd = trialStruct.luminanceLevelIndexInTrialStd(newIndex);

trialStruct.cmpInterval = zeros(1,nBlocks*nCmpLevels);
% tempIndex = randperm(nBlocks*nCmpLevels);
% trialStruct.cmpInterval(tempIndex(1:ceil((nBlocks*nCmpLevels)/2))) = 1;
    
save(fullfile(getpref(projectName,'stimulusInputBaseDir'),...
    parser.Results.directoryName,[outputFileName,'.mat']),...
    'trialStruct','-v7.3');
