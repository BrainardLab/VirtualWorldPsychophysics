% this script can be used to find the scale factor for a given LMSStruct

nameOfCalibrationFile = 'VirtualWorldCalibration';
whichCalibration = Inf;
dir = fullfile(getpref('VirtualWorldPsychophysics','calibrationDir'));


%% Load the LMS struct
pathToLMSStruct = '/Users/colorlab/Dropbox (Aguirre-Brainard Lab)/CNST_materials/VirtualWorldPsychophysics/Experiment3/StimuliCondition2_covScaleFactor_1_00_NoReflection/LMSStruct.mat';
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

% CovScaleFactor = 0_00 ; monitor scalefactor = 14.9939
% CovScaleFactor = 0_01 ; monitor scalefactor = 12.9682
% CovScaleFactor = 0_03 ; monitor scalefactor = 10.9831
% CovScaleFactor = 0_10 ; monitor scalefactor = 9.1670
% CovScaleFactor = 0_30 ; monitor scalefactor = 7.9536
% CovScaleFactor = 1_00 ; monitor scalefactor = 5.4229

%% Experiment 2

% Condition = 1 ; monitor scalefactor = 6.3094
% Condition = 2 ; monitor scalefactor = 4.9302
% Condition = 2a ; monitor scalefactor = 4.6957
% Condition = 3 ; monitor scalefactor = 4.9302
% Condition = 3a ; monitor scalefactor = 4.6957