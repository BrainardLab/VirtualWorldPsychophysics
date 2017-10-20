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
parser.addParameter('nTrials', 10, @isscalar);
parser.addParameter('stdY', 5, @isnumeric);
parser.addParameter('cmpY', (1:10), @isnumeric);
parser.parse(varargin{:});


directoryName = parser.Results.directoryName;
LMSstructName = parser.Results.LMSstructName;
outputFileName = parser.Results.outputFileName;
nTrials = parser.Results.nTrials;
stdY = parser.Results.stdY;
cmpY = parser.Results.cmpY;

projectName = 'VirtualWorldPsychophysics';

%% Load the RGB struct
% The load call needs to be changed use pref for VWP directory on dropbox
pathToRGBFile = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                directoryName,[LMSstructName,'.mat']);
load(pathToRGBFile);

%%
trialStruct.stdY = LMSStruct.uniqueLuminanceLevels(stdY);
trialStruct.cmpY = LMSStruct.uniqueLuminanceLevels(cmpY);
trialStruct.nTrials = nTrials;

indexOfStandardImages = find(LMSStruct.luminanceCategoryIndex == stdY);

for ii = 1 : nTrials
    % Pick a random index for the standard image
    tempStdIndex = randi(length(indexOfStandardImages));
    trialStruct.trialStdIndex(ii) = indexOfStandardImages(tempStdIndex);
    trialStruct.stdYInTrial(ii) = LMSStruct.luminanceLevels(trialStruct.trialStdIndex(ii));
    
    % Pick a comparison level
    tempCmpLvl = cmpY(randi(length(cmpY)));
    indexOfCmpImages = find(LMSStruct.luminanceCategoryIndex == tempCmpLvl);
    trialStruct.trialCmpIndex(ii) = indexOfCmpImages(tempStdIndex);
    trialStruct.cmpYInTrial(ii) = LMSStruct.luminanceLevels(trialStruct.trialCmpIndex(ii));
    trialStruct.luminanceCategoryIndexInTrial(ii) = LMSStruct.luminanceCategoryIndex(trialStruct.trialCmpIndex(ii));
end
    trialStruct.cmpInterval = zeros(1,nTrials);
    tempIndex = randperm(nTrials);
    trialStruct.cmpInterval(tempIndex(1:ceil(nTrials/2))) = 1;

save(fullfile(getpref(projectName,'stimulusInputBaseDir'),...
    parser.Results.directoryName,[outputFileName,'.mat']),...
    'trialStruct','-v7.3');
