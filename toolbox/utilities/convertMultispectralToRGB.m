function [rgbImage] = convertMultispectralToRGB(multispectralImage, SMultispectral, cropSize, varargin)
%%convertMultispectralToRGB  Converts multispectral image to RGB image using monitor calibration file
%
% Usage: 
%   [rgbImage] = convertMultispectralToRGB(multispectralImage, SMultispectral, cropSize)
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
%   cropSize : Scalar ... [DESCRIBE OR REMOVE]
%
% Output:
%   rgbImage : gamma corrected RGB image [m by n by 3]
%
% Optional key/value pairs:
%    'whichCalibration' : (scalar) Which calibration in file to use (default 0 -> most recent)
%    'nameOfCalibrationFile : (string) Name of calibration file (default 'NEC_MultisyncPA241W.mat')

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('whichCalibration', 0, @isscalar); 
parser.addParameter('nameOfCalibrationFile', 'NEC_MultisyncPA241W.mat', @isstring);
parser.parse(varargin{:});

whichCalibration = parser.Results.whichCalibration;
pathToCalibrationFile = parser.Results.pathToCalibrationFile;

%% Load calibration file
cal = LoadCalFile(fullfile(getpref('VirtualWorldPsychophysics','calibrationDir'),pathToCalibrationFile),whichCalibration);

%% Load

% %% Invert the device primaries 
P_deviceInv = pinv(cals.processedData.P_device);
P_deviceInv = SplineCmf(cals.rawData.S, P_deviceInv, SMultispectral);

% %% Make direct rgb conversion using inverse calibration file
RGBDirect = P_deviceInv*multispectralImage;
RGBDirect = CalFormatToImage(RGBDirect, cropSize, cropSize);

% Need to gamma correct and figure out if there needs to be some kind of
% scaling

%% Load some cone sensitivities
load T_cones_ss2

%% 
LMSImage = rtbMultispectralToSensorImage(reshape(multispectralImage',cropSize,cropSize,[]),...
    SMultispectral, T_cones_ss2, S_cones_ss2);
[LMScalFormat, nX, nY] = ImageToCalFormat(LMSImage);
T_Cones_Rescaled = SplineCmf(S_cones_ss2,T_cones_ss2,cals.rawData.S);
SPMatrixInv = inv(T_Cones_Rescaled*cals.processedData.P_device);
RGBFromLMS = SPMatrixInv*LMScalFormat;
RGBFromLMS = CalFormatToImage(RGBFromLMS, nX, nY);

rgbImage = RGBFromLMS;





