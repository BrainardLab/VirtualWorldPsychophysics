function data = runLightnessExperiment(varargin)
%%runExperiment : run lightness estimation experiment and record data
%
% Usage: 
%   data = runLightnessExperiment();
%
% Description:
%   Run the lightness estimation psychophysics experiment given the
%   calibration file, trial struct and LMS stimulus struct. Record the
%   responses and save the responses in the specified directory.
%
% Input:
%   None
%
% Output:
%   None
%
% Optional key/value pairs:
%    'directoryName' : (string) Directory name of the case which will be studied (default 'ExampleDirectory')
%    'nameOfTrialStruct' : (string) Name of trail stuct to be used in experiment (defalult 'exampleTrial')
%    'nameOfLMSStruct' : (string) Name of LMS stuct to be used in experiment (defalult 'LMSStruct')
%    'nameOfCalibrationFile : (string) Name of calibration file (default 'NEC_MultisyncPA241W.mat')
%    'whichCalibration' : (scalar) Which calibration in file to use (default Inf -> most recent)
%    'subjectName' : (string) Name of subject (default 'testSubject')

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('nameOfTrialStruct', 'exampleTrial', @ischar);
parser.addParameter('nameOfLMSStruct', 'LMSStruct', @ischar);
parser.addParameter('nameOfCalibrationFile', 'NEC_MultisyncPA241W', @ischar);
parser.addParameter('whichCalibration', Inf, @isscalar); 
parser.addParameter('subjectName', 'testSubject', @ischar);
parser.parse(varargin{:});

directoryName = parser.Results.directoryName;
nameOfTrialStruct = parser.Results.nameOfTrialStruct;
nameOfLMSStruct = parser.Results.nameOfLMSStruct;
nameOfCalibrationFile = parser.Results.nameOfCalibrationFile;
whichCalibration = parser.Results.whichCalibration;
subjectName = parser.Results.subjectName;

projectName = 'VirtualWorldPsychophysics';

%% Some experimental parameters.
%
% May want to read these from a file at
% some point.
params.screenDimsCm = [59.5 33.8];
params.fpSize = [1 1];
params.fpColor = [1 1 1];
params.bgColor = [0 0 0];
params.textColor = [1 0 0];
params.leftImageLoc = [-3 0];
params.rightImageLoc = [3 0];
params.leftImageSize = [3 3];
params.rightImageSize = [3 3];

%% Load the trial struct
pathToTrialStruct = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                    directoryName,[nameOfTrialStruct '.mat']);
temp = load(pathToTrialStruct); trialStruct = temp.trialStruct; clear temp;

%% Load the LMS struct
pathToLMSStruct = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
                    directoryName,[nameOfLMSStruct '.mat']);
temp = load(pathToLMSStruct); LMSStruct = temp.LMSStruct; clear temp;

%% Load calibration file
cal = LoadCalFile(nameOfCalibrationFile,whichCalibration,fullfile(getpref('VirtualWorldPsychophysics','calibrationDir')));
if (isempty(cal))
    error('Could not find specified calibration file');
end

%% Initialize calibration structure for the cones
cal = SetSensorColorSpace(cal, LMSStruct.T_cones, LMSStruct.S); % Fix the last option
cal = SetGammaMethod(cal,0);

%% Now loop over the images for presentation on screen
% Before that figure out how long it takes to convert two LMS to RGB and
% present on screen. Shouldn't be very long

%% Use calibration machinery to get RGB
tic
stdIndex = trialStruct.trialStdIndex(1);
cmpIndex =  trialStruct.trialCmpIndex(1);
stdRGBImage = CalFormatToImage(SensorToSettings(cal,LMSStruct.LMSImageInCalFormat(:,:,stdIndex)),LMSStruct.cropImageSizeX,LMSStruct.cropImageSizeY);
cmpRGBImage = CalFormatToImage(SensorToSettings(cal,LMSStruct.LMSImageInCalFormat(:,:,cmpIndex)),LMSStruct.cropImageSizeX,LMSStruct.cropImageSizeY);
toc

%% Example of initializing display and showing one trial
[win, params] = initDisplay(params);

%% Start key capture and clear keyboard queue before we draw the stimuli.
ListenChar(2);
FlushEvents;
    
%% Enable fixation and start text
win.enableObject('fp');
win.enableObject('startText');
win.draw;

%% Wait for key
keyPress = GetChar;

%% Turn off start text, add images and wait for another key
win.disableObject('startText');
win.addImage(params.leftImageLoc, params.leftImageSize, stdRGBImage(end:-1:1,:,:), 'Name', 'leftImage');
win.addImage(params.rightImageLoc, params.rightImageSize, cmpRGBImage(end:-1:1,:,:), 'Name', 'rightImage');
win.draw;

%% Wait for key
keyPress = GetChar;
fprintf('The character typed was %c\n',keyPress);

%% Done with experiment, close up
%
% Close our display.
win.close;
    
% Make sure key capture is off.
ListenChar(0);
    
% 
% %% Save the response struct
% path2RGBOutputDirectory = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
%                                 parser.Results.directoryName);
% outputfileName = fullfile(path2RGBOutputDirectory,[outputFileName,'.mat']);
% save(outputfileName,'S','-v7.3');


function [win, params] = initDisplay(params)

% Create the GLWindow object and linearize the clut.
win = GLWindow('SceneDimensions', params.screenDimsCm, ...
    'BackgroundColor', params.bgColor);

try
    % Open the display.
    win.open;
    
%     % Add the images.  The image center parameters are meaningless here as
%     % they'll be changed each trial.
%     if (params.numStims ~= 2)
%         error('Code assumes only two underlying images');
%     end
%     for i = 1:params.numStims
%         fprintf('Image %d, %s\n',i,params.stimInfo(i).imageName);
%         fileName = fullfile(params.stimuliDir, [params.stimInfo(i).imageName '.mat']);
%         data = load(fileName);
%         
%         % Convert the image data to RGB format.
%         rgbData = zeros([size(data.theImage), 3]);
%         for j = 1:3
%             rgbData(:,:,j) = data.theImage;
%         end
%         
%         imagePixHeight = size(rgbData,1);
%         imagePixWidth = size(rgbData,2);
%         params.imageSize{i} = [params.imageWidth params.imageWidth*imagePixHeight/imagePixWidth];
%         win.addImage([0 0], params.imageSize{i}, rgbData, 'Name', sprintf('im%d', i));
%         params.rgbData{i} = rgbData;
%         params.probeIndex{i} = data.probeIndex;
%         params.blankcolor(i) = data.blankcolor;
%     end
    
    % Add the fixation point.
    win.addOval([0 0], params.fpSize, params.fpColor, 'Name', 'fp');
    
    % Add text
    win.addText('Hit any button to start', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'startText');     % Identifier for the object.
    
    % Turn all objects off for now.
    win.disableAllObjects;
    
catch e
    win.close;
    rethrow(e);
end

