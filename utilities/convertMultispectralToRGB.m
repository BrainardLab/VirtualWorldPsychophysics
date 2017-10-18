function [RGB RGBFromLMS RGBDirect] = convertMultispectralToRGB(multispectralImage, SMultispectral, cropSize, varargin)
%Converts multispectral image to RGB image using monitor calibration file
% USAGE: 
%   RGB = convertMultispectralToRGB(multispectralImage, [400 10 31])
%
% Description:
%   Convert the multispectral image to gamma corrected RGB image using the
%   monitor primaries given by the calibration file.
%
% Input:
%   multispectralImage : multi spectral image [k wavelengths x n Pixels]
%   SMultispectral : Wavelength sampling of multispectral images. Foramt: [start del N]
%   pathToCalibrationFile : path to monitor calibration file 
%
%  OptionalInput:
%    whichCalibration : which calibration to use, if more than one
%
% Output:
%   RGB : gamma corrected RGB image [3 x nPixels]
%

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('whichCalibration', 0, @isnumeric); 
parser.addParameter('pathToCalibrationFile', 'NEC_MultisyncPA241W.mat', @isstring);
parser.parse(varargin{:});

whichCalibration = parser.Results.whichCalibration;
pathToCalibrationFile = parser.Results.pathToCalibrationFile;

%% load calibration file
load(pathToCalibrationFile);
% choose the most recent calibration
if (whichCalibration == 0)
    cals = cals{end};
else
    cals = cals{whichCalibration};
end

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

RGB = RGBFromLMS;





