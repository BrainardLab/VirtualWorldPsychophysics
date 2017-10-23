function data = runLightnessExperiment(varargin)
%%runExperiment : run lightness estimation experiment and record data
%
% Usage: 
%   data = runLightnessExperiment();
%
% Description:
%   Run the lightness estimation psychophysics experiment given the
%   calibration file, trial struct and LMS stimulus struct. Record the
%   responses and save the responses in the specified directory.
%
% Input:
%   None
%
% Output:
%   None
%
% Optional key/value pairs:
%    'directoryName' : (string) Directory name of the case which will be studied (default 'ExampleDirectory')
%    'nameOfTrialStruct' : (string) Name of trail stuct to be used in experiment (defalult 'exampleTrial')
%    'nameOfLMSStruct' : (string) Name of LMS stuct to be used in experiment (defalult 'LMSStruct')
%    'nameOfCalibrationFile : (string) Name of calibration file (default 'NEC_MultisyncPA241W.mat')
%    'whichCalibration' : (scalar) Which calibration in file to use (default Inf -> most recent)
%    'subjectName' : (string) Name of subject (default 'testSubject')

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('nameOfTrialStruct', 'exampleTrial', @ischar);
parser.addParameter('nameOfLMSStruct', 'LMSStruct', @ischar);
parser.addParameter('nameOfCalibrationFile', 'NEC_MultisyncPA241W', @ischar);
parser.addParameter('whichCalibration', Inf, @isscalar); 
parser.addParameter('subjectName', 'testSubject', @ischar);
parser.parse(varargin{:});

directoryName = parser.Results.directoryName;
nameOfTrialStruct = parser.Results.nameOfTrialStruct;
nameOfLMSStruct = parser.Results.nameOfLMSStruct;
nameOfCalibrationFile = parser.Results.nameOfCalibrationFile;
whichCalibration = parser.Results.whichCalibration;
subjectName = parser.Results.subjectName;

projectName = 'VirtualWorldPsychophysics';

%% Load the trial struct
pathToTrialStruct = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                    directoryName,[nameOfTrialStruct '.mat']);
temp = load(pathToTrialStruct); trialStruct = temp.trialStruct; clear temp;

%% Load the LMS struct
pathToLMSStruct = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                    directoryName,[nameOfLMSStruct '.mat']);
temp = load(pathToLMSStruct); LMSStruct = temp.LMSStruct; clear temp;

%% Load calibration file
cal = LoadCalFile(nameOfCalibrationFile,whichCalibration,fullfile(getpref('VirtualWorldPsychophysics','calibrationDir')));
if (isempty(cal))
    error('Could not find specified calibration file');
end

%% Load the cone sensitivity
%
% This is eventually going to draw from the loaded struct.
T_conesLoaded = load('T_cones_ss2');                                                             % Load this using the LMS struct option 
T_cones = SplineCmf(T_conesLoaded.S_cones_ss2,T_conesLoaded.T_cones_ss2, LMSStruct.wavelengths); % Fix the last option

%% Initialize calibration structure for the cones
cal = SetSensorColorSpace(cal, T_cones, LMSStruct.wavelengths); % Fix the last option
cal = SetGammaMethod(cal,0);

%% Now loop over the images for presentation on screen
% Before that figure out how long it takes to convert two LMS to RGB and
% present on screen. Shouldn't be very long

%% Use calibration machinery to get RGB
tic
stdIndex = trialStruct.trialStdIndex(1);
cmpIndex =  trialStruct.trialCmpIndex(1);
stdRGBImage = CalFormatToImage(SensorToSettings(cal,LMSStruct.LMSImageInCalFormat(:,:,stdIndex)),LMSStruct.cropImageSize,LMSStruct.cropImageSize);
cmpRGBImage = CalFormatToImage(SensorToSettings(cal,LMSStruct.LMSImageInCalFormat(:,:,cmpIndex)),LMSStruct.cropImageSize,LMSStruct.cropImageSize);
toc

% 
% %% Save the response struct
% path2RGBOutputDirectory = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
%                                 parser.Results.directoryName);
% outputfileName = fullfile(path2RGBOutputDirectory,[outputFileName,'.mat']);
% save(outputfileName,'S','-v7.3');

