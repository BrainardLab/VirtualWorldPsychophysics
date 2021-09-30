% this script can be used to find the scale factor for a given LMSStruct

nameOfCalibrationFile = 'VirtualWorldCalibration';
whichCalibration = Inf;
dir = fullfile(getpref('VirtualWorldPsychophysics','calibrationDir'));


%% Load the LMS struct
pathToLMSStruct = '/Volumes/G-DRIVE USB/VirtualWorldPsychophysics/VWP_materials/Experiment5/StimuliIlluminantScale_0_75_to_1_25/LMSStruct.mat';
temp = load(pathToLMSStruct); 
LMSStruct = temp.LMSStruct; 
clear temp;

%% Load the cal file
cal = LoadCalFile(nameOfCalibrationFile,whichCalibration, dir);

%% Initialize calibration structure for the cones
cal = SetSensorColorSpace(cal, LMSStruct.T_cones, LMSStruct.S); % Fix the last option

%% Find Scale factor

scaleFactor = findScaleFactor(cal, LMSStruct);

%% Experiment 5

% StimuliIlluminantScale_0_00_to_0_00; monitor scalefactor = 8.4978
% StimuliIlluminantScale_0_95_to_1_05; monitor scalefactor = 8.5559
% StimuliIlluminantScale_0_90_to_1_10; monitor scalefactor = 7.7803
% StimuliIlluminantScale_0_85_to_1_15; monitor scalefactor = 7.4562
% StimuliIlluminantScale_0_80_to_1_20; monitor scalefactor = 7.1677
% StimuliIlluminantScale_0_75_to_1_25; monitor scalefactor = 6.7950


%% Experiment 3

% CovScaleFactor = 0_00 ; monitor scalefactor = 14.9939
% CovScaleFactor = 0_01 ; monitor scalefactor = 12.9682
% CovScaleFactor = 0_03 ; monitor scalefactor = 10.9831
% CovScaleFactor = 0_10 ; monitor scalefactor = 9.1670
% CovScaleFactor = 0_30 ; monitor scalefactor = 7.9536
% CovScaleFactor = 1_00 ; monitor scalefactor = 5.4229

%% Experiment 3 AT NCAT

% CovScaleFactor = 0_00 ; monitor scalefactor = 22.8523
% CovScaleFactor = 0_01 ; monitor scalefactor = 19.5725
% CovScaleFactor = 0_03 ; monitor scalefactor = 17.1635
% CovScaleFactor = 0_10 ; monitor scalefactor = 13.4940
% CovScaleFactor = 0_30 ; monitor scalefactor = 11.5302
% CovScaleFactor = 1_00 ; monitor scalefactor = 8.4897

%% Experiment 2

% Condition = 1 ; monitor scalefactor = 6.3094
% Condition = 2 ; monitor scalefactor = 4.9302
% Condition = 2a ; monitor scalefactor = 4.6957
% Condition = 3 ; monitor scalefactor = 4.9302
% Condition = 3a ; monitor scalefactor = 4.6957