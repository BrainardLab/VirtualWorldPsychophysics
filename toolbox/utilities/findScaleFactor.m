function scaleFactor = findScaleFactor(calStruct, LMSStruct, varargin)
%%scaleFactor : find scale factor for LMS images for display on monitor
%
% Usage:
%   findScaleFactor(calStruct, LMSStruct);
%
% Description:
%   Use the calibration struct and the LMS struct to find the scale factor
%   so that the LMS images can be properly scaled for display on the
%   monitor. This scaling is performed on the whole set of images that will
%   be presented in the experiment. This makes sure that the primaries do not
%   saturate while being presented on the monitor.
%
% Input:
%   calStruct : Calibration struct
%   LMSStruct : LMS image struct
%
% Output:
%   scaleFactor
%
% Optional key/value pairs:
%    'maxmimumOfMonitor' : (scalar) Maximum value of the monitor gamut that
%               the images can take after scaling (defalut 0.9)

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('maxmimumOfMonitor', 0.9, @isscalar);
parser.parse(varargin{:});

[m, n, k] = size(LMSStruct.LMSImageInCalFormat);
allImagesInCalFormat = reshape(LMSStruct.LMSImageInCalFormat,m,n*k);

primary = SensorToPrimary(calStruct, allImagesInCalFormat);

maxPrimary = max(primary(:));

scaleFactor = parser.Results.maxmimumOfMonitor/maxPrimary;