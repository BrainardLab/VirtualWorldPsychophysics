function multispectralStructToRGBStruct(varargin)
% multispectralStructToRGBStruct Convert multispectral struct to gamma corrected RGB struct
%
% Usage: 
%   multispectralStructToRGBStruct();
%
% Description:
%   Convert the multispectral struct to the gamma corrected RGB struct
%   using the calibration file and cone response files. The multispectral
%   struct will be loaded from the directoryName and the new struct will be
%   stored in the same directory. (We should change this)
%
% Input:
%
% Output:
%    S : Struct with additional fields LMSCalFormatImage and RGBCalFormatImage.
%
% Optional key/value pairs:
%    'directoryName' : 'ExampleDirectory'
%    'nameOfConeSensitivityFile' : (string) Name of cone sensitivity file used (defalult 'T_cones_ss2')
%    'whichCalibration' : (scalar) Which calibration in file to use (default Inf -> most recent)
%    'nameOfCalibrationFile : (string) Name of calibration file (default 'NEC_MultisyncPA241W.mat')
%    'outputFileName': Name of output file (default 'RGBStruct')

% 10/16/2017 VS wrote this
%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('outputFileName', 'RGBStruct', @ischar);
parser.addParameter('whichCalibration', Inf, @isscalar); 
parser.addParameter('nameOfCalibrationFile', 'NEC_MultisyncPA241W', @ischar);
parser.addParameter('nameOfConeSensitivityFile', 'T_cones_ss2', @ischar);
parser.parse(varargin{:});


directoryName = parser.Results.directoryName;
outputFileName = parser.Results.outputFileName;
whichCalibration = parser.Results.whichCalibration;
nameOfCalibrationFile = parser.Results.nameOfCalibrationFile;
nameOfConeSensitivityFile = parser.Results.nameOfConeSensitivityFile;

projectName = 'VirtualWorldPsychophysics';

%% Load the struct with multispectral image
% The load call needs to be changed use pref for VWP directory on dropbox
pathToMultispectralFile = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                    directoryName,'multispectralStruct.mat');
load(pathToMultispectralFile);

%% Load calibration file
cal = LoadCalFile(nameOfCalibrationFile,whichCalibration,fullfile(getpref('VirtualWorldPsychophysics','calibrationDir')));
if (isempty(cal))
    error('Could not find specified calibration file');
end

%% Load the cone sensitivity
T_conesLoaded = load(nameOfConeSensitivityFile);
T_cones = SplineCmf(T_conesLoaded.S_cones_ss2,T_conesLoaded.T_cones_ss2,S.wavelengths);


%% Convert all multispectral images to LMS
[k, nPixels, nImages] = size(S.multispectralImage);
allMultispectralImagesReshaped = reshape(S.multispectralImage,k,nPixels*nImages);
LMSImageReshaped = T_cones*allMultispectralImagesReshaped;
S.LMSImageInCalFormat = reshape(LMSImageReshaped,size(LMSImageReshaped,1),nPixels,nImages);

%% Initialize calibration structure for the cones
cal = SetSensorColorSpace(cal,T_cones,S.wavelengths);
cal = SetGammaMethod(cal,0);

%% Use calibration machinery to get RGB
RGBImagesReshaped = SensorToSettings(cal,LMSImageReshaped);
S.RGBImageInCalFormat = reshape(RGBImagesReshaped,size(RGBImagesReshaped,1),nPixels,nImages);

%% Save the RGB struct
path2RGBOutputDirectory = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                                parser.Results.directoryName);
outputfileName = fullfile(path2RGBOutputDirectory,[outputFileName,'.mat']);
save(outputfileName,'S','-v7.3');
