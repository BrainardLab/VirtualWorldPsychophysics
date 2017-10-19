function makeTrialStruct(varargin)
%%makeTrialStruct Make the structure for doing color comparison experiment
%
% Usage: 
%   makeTrialStruct();
%
% Description:
%   Use the RGB struct to make a trial struct. The RGB struct must have
%   fields RGBImageInCalFormat, luminanceLevels, uniqueLuminanceLevels, 
%   reflectanceNumber
%
% Input:
%
% Output:
%
% Fields in S
% S.trialStdIndex : Index of standard image to be used in the trials
% S.trialCmpIndex : Index of comparison image to be used in the trial, 
%               should be the same as S.trailStdIndex 
% S.stdY : standard lightness level
% S.cmpY : comparison lightness levels
% S.stdYInTrial : std lightness for each trial
% S.cmpYInTrial : cmp lightness for each trial
%
% Optional key/value pairs:
%    'directoryName' : Name of directory to read RGB struct (default 'ExampleDirectory')
%    'RGBstructName' : Name of RGB struct file (default RGBStruct)
%    'outputFileName': Name of file to save trial output struct (default 'exampleTrial')
%    'nTrails' : Number of trials (default -> 10)
%    'stdY' : Index of standard lightness level (default -> 5)
%    'cmpY' : Index of comparison lightness level (defalut -> [1:10])

% 10/19/2017 VS wrote this
%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('RGBstructName', 'RGBStruct', @ischar);
parser.addParameter('outputFileName', 'exampleTrial', @ischar);
parser.addParameter('nTrials', 10, @isscalar);
parser.addParameter('stdY', 5, @isnumeric);
parser.addParameter('cmpY', (1:10), @isnumeric);
parser.addParameter('coneSensitivity', 'T_cones_ss2', @isnumeric);
parser.parse(varargin{:});


directoryName = parser.Results.directoryName;
RGBstructName = parser.Results.RGBstructName;
outputFileName = parser.Results.outputFileName;
nTrials = parser.Results.nTrials;
stdY = parser.Results.stdY;
cmpY = parser.Results.cmpY;

projectName = 'VirtualWorldPsychophysics';

%% Load the RGB struct
% The load call needs to be changed use pref for VWP directory on dropbox
pathToRGBFile = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                directoryName,[RGBstructName,'.mat']);
load(pathToRGBFile);

%%
S.stdY = S.uniqueLuminanceLevels(stdY);
S.cmpY = S.uniqueLuminanceLevels(cmpY);
S.nTrials = nTrials;

indexOfStandardImages = find(S.ctgInd == stdY);

for ii = 1 : nTrials
    % Pick a random index for the standard image
    tempStdIndex = randi(length(indexOfStandardImages));
    S.trialStdIndex(ii) = indexOfStandardImages(tempStdIndex);
    S.stdYInTrial(ii) = S.luminanceLevels(S.trialStdIndex(ii));
    
    % Pick a comparison level
    tempCmpLvl = cmpY(randi(length(cmpY)));
    indexOfCmpImages = find(S.ctgInd == tempCmpLvl);
    S.trialCmpIndex(ii) = indexOfCmpImages(tempStdIndex);
    S.cmpYInTrial(ii) = S.luminanceLevels(S.trialCmpIndex(ii));
    S.ctgIndInTrial(ii) = S.ctgInd(S.trialCmpIndex(ii));
end
    S.cmpInterval = zeros(1,nTrials);
    tempIndex = randperm(nTrials);
    S.cmpInterval(tempIndex(1:ceil(nTrials/2))) = 1;

save(fullfile(getpref(projectName,'stimulusInputBaseDir'),...
    parser.Results.directoryName,[outputFileName,'.mat']),...
    'S','-v7.3');
