%% testConvertMultispectralToRGB
%
% Description:
%    Little test program to call our core routine converMultispectralRGB and make
%    sure it works as intended.
%
%    We have a test image to use with this program.  It lives in directory
%    getpref('VirtualWorldPsychophysics','testImageDir');

%% Clear
clear; close all;

%% Load an image
%
% The image itself comes in in field 'croppedImage' by convention.
testImageName = 'testMultispectralImage';
multispectralImageData = load(fullfile(getpref('VirtualWorldPsychophysics','testImageDir'),testImageName));
multispectralImageSize = size(multispectralImageData.croppedImage);

%% Specify wavelength sampling in test image. 
%
% We may someday want to change so that the wavelength sampling is stored with
% the generated hyperpsectral image, but for now we just know what it is.
SMultispectral = [400 10 31];
if (multispectralImageSize(3) ~= SMultispectral(3))
    error('Loaded image number of wavelengths does not match our view of what it should be');
end

%% Convert the image
tic
[rgbImage] = convertMultispectralToRGB(multispectralImageData.croppedImage, SMultispectral);
toc

