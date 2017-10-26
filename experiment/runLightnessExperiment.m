function runLightnessExperiment(varargin)
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

% May want to change this to name the experiment cases differently
caseName = directoryName;

%% Some experimental parameters.
%
% May want to read these from a file at
% some point.
params.screenDimsCm = [59.5 33.8];
params.fpSize = [0.1 0.1];
params.fpColor = [1 1 0];
params.bgColor = [0 0 0];
params.textColor = [1 0 0];
params.leftImageLoc = [0 0];
params.rightImageLoc = [0 0];
params.leftImageSize = [3 3];
params.rightImageSize = [3 3];
params.ISI = 0.25;
params.ITI = 0.25;
params.stimDuration = 0.5;

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

%% Start Time of Experiment
startTime = datestr(now);

%% Now loop over the images for presentation on screen
% Before that figure out how long it takes to convert two LMS to RGB and
% present on screen. Shouldn't be very long
response = struct('subjectName',subjectName, ...
    'correctResponse',[],...
    'actualResponse',[]);

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
for iterTrials = 1 : length(trialStruct.trialStdIndex)
    stdIndex = trialStruct.trialStdIndex(iterTrials);
    cmpIndex =  trialStruct.trialCmpIndex(iterTrials);
    stdRGBImage = CalFormatToImage(SensorToSettings(cal,LMSStruct.LMSImageInCalFormat(:,:,stdIndex)),LMSStruct.cropImageSizeX,LMSStruct.cropImageSizeY);
    cmpRGBImage = CalFormatToImage(SensorToSettings(cal,LMSStruct.LMSImageInCalFormat(:,:,cmpIndex)),LMSStruct.cropImageSizeX,LMSStruct.cropImageSizeY);
    standardYLarger = (trialStruct.stdYInTrial(iterTrials) >= trialStruct.cmpYInTrial(iterTrials));
    if trialStruct.cmpInterval(iterTrials) % comparison on the second interval
        firstImage = stdRGBImage(end:-1:1,:,:);
        secondImage = cmpRGBImage(end:-1:1,:,:); 
        if standardYLarger
            correctResponse(iterTrials) = 1;
        else
            correctResponse(iterTrials) = 2;
        end
    else                                   % comparison on the first
        firstImage = cmpRGBImage(end:-1:1,:,:);
        secondImage = stdRGBImage(end:-1:1,:,:);
        if standardYLarger
            correctResponse(iterTrials) = 2;
        else
            correctResponse(iterTrials) = 1;
        end
    end
    
    % Write the images into the window and disable
    win.addImage(params.leftImageLoc, params.leftImageSize, firstImage, 'Name', 'firstImage'); 
    win.addImage(params.rightImageLoc, params.rightImageSize, secondImage, 'Name', 'secondImage');
    win.disableObject('firstImage');
    win.disableObject('secondImage');
    
    % Enable "left" image and draw
    win.enableObject('firstImage');
    win.draw;  
    
    % Wait for duration
    mglWaitSecs(params.stimDuration);
    win.disableObject('firstImage');
    win.draw;
    
    % Wait for ITI and show "right" image
    mglWaitSecs(params.ITI);
    win.enableObject('secondImage');
    win.draw;
    
    % Wait for duration
    mglWaitSecs(params.stimDuration);
    win.disableObject('secondImage');
    win.draw;

    %% Wait for key
    keyPress(iterTrials) = GetChar;
    actualResponse(iterTrials) = str2num(keyPress(iterTrials));
    fprintf('The character typed was %c\n',keyPress(iterTrials));
end

%% correct response can be found as
% (trialStruct.stdYInTrial > trialStruct.cmpYInTrial).*(trialStruct.cmpInterval) + ...
% (~(trialStruct.stdYInTrial > trialStruct.cmpYInTrial)).*(~(trialStruct.cmpInterval))
response.correctResponse = correctResponse;
response.actualResponse = actualResponse;
response.keyPress = keyPress;

%% End Time of Experiment
endTime = datestr(now);

%% Make data struct
data = struct;
data.trialStruct = trialStruct;
data.startTime = startTime;
data.endTime = endTime;
data.cal = cal;
data.LMSStruct = LMSStruct;
data.subjectName = subjectName;

%% Done with experiment, close up
%
% Close our display.
win.close;
    
% Make sure key capture is off.
ListenChar(0);

%% Save data here

% Figure out some data saving parameters.
dataFolder = fullfile(getpref(projectName,'dataDir'), caseName, subjectName);
if ~exist(dataFolder, 'dir')
    mkdir(dataFolder);
end

dataFile = sprintf('%s/%s-%d.mat', dataFolder,subjectName, GetNextDataFileNumber(dataFolder, '.mat'));
fprintf('\nData will be saved in:\n%s\n', dataFile);

save(dataFile,'data','-v7.3');

fprintf('Data was saved.\n');

    
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

