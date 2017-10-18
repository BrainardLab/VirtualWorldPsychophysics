function [RGBImage] = convertMultispectralToRGB(multispectralImage, SMultispectral, varargin)
%%convertMultispectralToRGB  Converts multispectral image to RGB image using monitor calibration file
%
% Usage: 
%   [RGBImage] = convertMultispectralToRGB(multispectralImage, SMultispectral, cropSize)
%
% Description:
%   Convert the multispectral image to gamma corrected RGB image using the
%   monitor primaries and gamma functions given by the calibration file.
%
%   Calibration file directory is obtained by getpref('VirtualWorldPsychophysics','calibrationDir').
%   This preference is set in the local hook file.
%
% Input:
%   multispectralImage : multi spectral image [m by n by k wavelengths]
%   SMultispectral : Wavelength sampling of multispectral images. Foramt: [start del N]
%
% Output:
%   RGBImage : gamma corrected RGB image [m by n by 3]
%
% Optional key/value pairs:
%    'whichCalibration' : (scalar) Which calibration in file to use (default Inf -> most recent)
%    'nameOfCalibrationFile : (string) Name of calibration file (default 'NEC_MultisyncPA241W.mat')

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('whichCalibration', Inf, @isscalar); 
parser.addParameter('nameOfCalibrationFile', 'NEC_MultisyncPA241W', @isstring);
parser.parse(varargin{:});

whichCalibration = parser.Results.whichCalibration;
nameOfCalibrationFile = parser.Results.nameOfCalibrationFile;

%% Load calibration file
cal = LoadCalFile(nameOfCalibrationFile,whichCalibration,fullfile(getpref('VirtualWorldPsychophysics','calibrationDir')));
if (isempty(cal))
    error('Could not find specified calibration file');
end

%% Load some cone sensitivities
%
% Spline these to the same wavelength
% sampling as the image.
T_conesLoaded = load('T_cones_ss2');
T_cones = SplineCmf(T_conesLoaded.S_cones_ss2,T_conesLoaded.T_cones_ss2,SMultispectral);

%% Convert multispectral image to LMS
[multispectralImageCalFormat,nX,nY] = ImageToCalFormat(multispectralImage);
LMSImageCalFormat = T_cones*multispectralImageCalFormat;

%% Initialize calibration structure for the cones
cal = SetSensorColorSpace(cal,T_cones,SMultispectral);
cal = SetGammaMethod(cal,0);

%% Use calibration machinery to get RGB
RGBImageCalFormat = SensorToSettings(cal,LMSImageCalFormat);

%% Convert back to image format
RGBImage = CalFormatToImage(RGBImageCalFormat,nX,nY);

