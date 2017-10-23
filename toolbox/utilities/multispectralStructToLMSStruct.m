function multispectralStructToLMSStruct(varargin)
%%multispectralStructToLMSStruct Convert multispectral struct to LMS struct
%
% Usage: 
%   multispectralStructToLMSStruct();
%
% Description:
%   Convert the multispectral struct to the LMS struct using cone response 
%   files. The multispectral struct will be loaded from the 
%   multipsectralImageFolder and the new struct will be stored in the same 
%   LMSStructFolder.
%
% Input:
%    None
% Output:
%    None
%
% Optional key/value pairs:
%    'multipsectralImageFolder' : 'ExampleCase'
%    'LMSStructFolder' : 'ExampleCase'
%    'nameOfConeSensitivityFile' : (string) Name of cone sensitivity file used (defalult 'T_cones_ss2')
%    'outputFileName': Name of output file (default 'LMSStruct')

% 10/16/2017 VS wrote this

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('multipsectralStructFolder', 'ExampleCase', @ischar);
parser.addParameter('LMSStructFolder', 'ExampleCase', @ischar);
parser.addParameter('outputFileName', 'LMSStruct', @ischar);
parser.addParameter('nameOfConeSensitivityFile', 'T_cones_ss2', @ischar);
parser.parse(varargin{:});

multipsectralStructFolder = parser.Results.multipsectralStructFolder;
outputFileName = parser.Results.outputFileName;
nameOfConeSensitivityFile = parser.Results.nameOfConeSensitivityFile;

projectName = 'VirtualWorldPsychophysics';

%% Load the struct with multispectral image
%
% The load call needs to be changed use pref for VWP directory on dropbox
pathToMultispectralFile = fullfile(getpref(projectName,'multispectralInputBaseDir'),...
                    multipsectralStructFolder,'multispectralStruct.mat');
temp = load(pathToMultispectralFile); multispectralStruct = temp.multispectralStruct; clear temp;

%% Load the cone sensitivity
T_conesLoaded = load(nameOfConeSensitivityFile);
T_cones = SplineCmf(T_conesLoaded.S_cones_ss2,T_conesLoaded.T_cones_ss2,multispectralStruct.S);

%% Convert all multispectral images to LMS
[k, nPixels, nImages] = size(multispectralStruct.multispectralImage);
allMultispectralImagesReshaped = reshape(multispectralStruct.multispectralImage,k,nPixels*nImages);
LMSImageReshaped = T_cones*allMultispectralImagesReshaped;
multispectralStruct.LMSImageInCalFormat = reshape(LMSImageReshaped,size(LMSImageReshaped,1),nPixels,nImages);

%% Remove the multispectralImage field from the struct
multispectralStruct = rmfield(multispectralStruct,'multispectralImage');
LMSStruct = multispectralStruct;
LMSStruct.T_cones = T_cones;
LMSStruct.nameOfConeSensitivityFile = nameOfConeSensitivityFile;

%% Save the struct
path2LMSOutputDirectory = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                                parser.Results.LMSStructFolder);
if (~exist(path2LMSOutputDirectory))
    mkdir(path2LMSOutputDirectory);
end
outputfileName = fullfile(path2LMSOutputDirectory,[outputFileName,'.mat']);
save(outputfileName,'LMSStruct','-v7.3');
