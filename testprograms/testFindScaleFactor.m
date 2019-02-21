% this script can be used to find the scale factor for a given LMSStruct

nameOfCalibrationFile = 'VirtualWorldCalibration';
whichCalibration = Inf;
dir = fullfile(getpref('VirtualWorldPsychophysics','calibrationDir'));


%% Load the LMS struct
pathToLMSStruct = '/Users/colorlab/Dropbox (Aguirre-Brainard Lab)/CNST_materials/VirtualWorldPsychophysics/Experiment2/StimuliFixedFlatTargetShapeFixedIlluminantWithintrialBkGndVariationNoReflection/LMSStruct.mat';
temp = load(pathToLMSStruct); 
LMSStruct = temp.LMSStruct; 
clear temp;

%% Load the cal file
cal = LoadCalFile(nameOfCalibrationFile,whichCalibration, dir);

%% Initialize calibration structure for the cones
cal = SetSensorColorSpace(cal, LMSStruct.T_cones, LMSStruct.S); % Fix the last option

%% Find Scale factor

scaleFactor = findScaleFactor(cal, LMSStruct);

%% Experiment 3

% CovScaleFactor = 0_1 ; monitor scalefactor = 9.6869
% CovScaleFactor = 0_5 ; monitor scalefactor = 5.3691
% CovScaleFactor = 1 ; monitor scalefactor = 4.9302
% CovScaleFactor = 5 ; monitor scalefactor = 4.7015
% CovScaleFactor = 10 ; monitor scalefactor = 4.5460


%% Experiment 2

% Condition = 1 ; monitor scalefactor = 6.3094
% Condition = 2 ; monitor scalefactor = 4.9302
% Condition = 2a ; monitor scalefactor = 4.6957
% Condition = 3 ; monitor scalefactor = 4.9302
% Condition = 3a ; monitor scalefactor = 4.6957