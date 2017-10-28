function runLightnessExperiment(varargin)
%%runExperiment : run lightness estimation experiment and record data
%
% Usage:
%   runLightnessExperiment();
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
%    'controlSignal' : (string) How to collect user response (options: 'gamePad', 'keyboard', default 'keyboard')
%    'subjectName' : (string) Name of subject (default 'testSubject')

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('nameOfTrialStruct', 'exampleTrial', @ischar);
parser.addParameter('nameOfLMSStruct', 'LMSStruct', @ischar);
parser.addParameter('nameOfCalibrationFile', 'NEC_MultisyncPA241W', @ischar);
parser.addParameter('whichCalibration', Inf, @isscalar);
parser.addParameter('controlSignal', 'keyboard', @ischar);
parser.addParameter('interval1Key', '1', @ischar);
parser.addParameter('interval2Key', '2', @ischar);
parser.addParameter('subjectName', 'testSubject', @ischar);
parser.parse(varargin{:});

directoryName = parser.Results.directoryName;
nameOfTrialStruct = parser.Results.nameOfTrialStruct;
nameOfLMSStruct = parser.Results.nameOfLMSStruct;
nameOfCalibrationFile = parser.Results.nameOfCalibrationFile;
whichCalibration = parser.Results.whichCalibration;
controlSignal = parser.Results.controlSignal;
interval1Key = parser.Results.interval1Key;
interval2Key = parser.Results.interval2Key;
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
params.leftImageSize = [6 6];
params.rightImageSize = [6 6];
params.ISI = 0.25;
params.ITI = 0.25;
params.stimDuration = 0.5;
params.interval1Key = interval1Key;
params.interval2Key = interval2Key;

% If the game pad has symbol 1 2 3 4, instead of X A B Y
if strcmp(interval1Key,'GP:1') params.interval1Key = 'GP:X'; end
if strcmp(interval2Key,'GP:2') params.interval2Key = 'GP:A'; end

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

%% Initiale display
[win, params] = initDisplay(params);

%% Start key capture and clear keyboard queue before we draw the stimuli.
ListenChar(2);
mglGetKeyEvent;

% Instantiate a gamePad object
if (strcmp(controlSignal, 'gamePad'))
    gamePad = GamePad();
else
    gamePad = [];
end

% Clear out any previous keypresses.
FlushEvents;

%% Enable fixation and start text
win.enableObject('fp');
win.enableObject('startText');
win.enableObject('keyOptions');
win.draw;

%% Wait for key
% keyPress = GetChar;
key = [];
while (isempty(key))
    key = mglGetKeyEvent;
end

%% Turn off start text, add images and wait for another key
win.disableObject('startText');
win.disableObject('keyOptions');

% Reset the keyboard queue.
mglGetKeyEvent;

saveData = 1;
keepLooping = 1;
iterTrials = 0;

while keepLooping
    iterTrials = iterTrials + 1;
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
    FlushEvents;
    
    key =[];
    while (isempty(key))
        % Get user response from keyboard
        if (strcmp(controlSignal, 'keyboard'))
            key = mglGetKeyEvent;
            if (~isempty(key))
                switch key.charCode
                    case {params.interval1Key,params.interval2Key}
                        keyPress(iterTrials) = getUserResponse(params,key);
                    case {'q'}
                        fprintf('Do you want to quit? Press Y for Yes, otherwise give your response \n');
                        key2 = [];
                        while (isempty(key2))
                            key2 = mglGetKeyEvent;
                            if (~isempty(key2))
                                switch key2.charCode
                                    case {params.interval1Key,params.interval2Key}
                                        keyPress(iterTrials) = getUserResponse(params,key2);
                                    case {'y'}
                                        keepLooping = false;
                                    otherwise
                                        key2 = [];
                                end
                            end                            
                        end
                    otherwise
                        key = [];
                end
            end
            % Get user response from gamePad
        else
            key = gamePad.getKeyEvent();
            if (~isempty(key))
                switch key.charCode
                    case {params.interval1Key,params.interval2Key}
                        keyPress(iterTrials) = getUserResponse(params,key);
                    otherwise
                        key = [];
                end
            end
            pressedKeyboard = mglGetKeyEvent;
            if (~isempty(pressedKeyboard))
                switch pressedKeyboard.charCode
                    case {'q'}
                        fprintf('Do you want to quit? Press Y for Yes, otherwise give your response using gamepad \n');
                        key2 = [];
                        keyG = [];
                        FlushEvents;
                        while (isempty(key2) && isempty(keyG))
                            key2 = mglGetKeyEvent;
                            keyG = gamePad.getKeyEvent();
                            if (~isempty(key2))
                                switch key2.charCode
                                    case {'y'}
                                        keepLooping = false;
                                        key = 0; % set key = 0 in order to exit this loop
                                    otherwise
                                        key2 = [];
                                end
                            elseif (~isempty(keyG))
                                switch keyG.charCode
                                    case {params.interval1Key,params.interval2Key}
                                        key = keyG;
                                        keyPress(iterTrials) = getUserResponse(params,key);
                                    otherwise
                                        keyG = [];
                                end
                            end
                        end
                end
            end
        end
    end
    
% Check if the experiment continues, otherwise quit without saving data    
    if keepLooping
        actualResponse(iterTrials) = keyPress(iterTrials);
        fprintf('The character typed was %d\n',keyPress(iterTrials));
        mglWaitSecs(params.ISI);
    else
        fprintf('Quitting without saving any data.\n');
        saveData = 0;
    end

% Check if end of experiment is reached
    if (iterTrials == length(trialStruct.trialStdIndex))
        keepLooping = false;
    end
end
%% Done with experiment, close up
%
% Close our display.
win.close;

% Make sure key capture is off.
ListenChar(0);

if saveData
    %% correct response can be found as
    response.correctResponse = correctResponse;
    response.actualResponse = actualResponse;
    response.keyPress = keyPress;
    
    %% End Time of Experiment
    endTime = datestr(now);
    
    %% Make data struct
    data = struct;
    data.response = response;
    data.trialStruct = trialStruct;
    data.startTime = startTime;
    data.endTime = endTime;
    data.cal = cal;
    data.LMSStruct = LMSStruct;
    data.subjectName = subjectName;
    
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
    
    drawPsychometricFunction('directoryName',caseName,...
        'subjectName', subjectName,...
        'fileNumber', (GetNextDataFileNumber(dataFolder, '.mat')-1),...
        'threshold', 0.75);
end
end
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
    
    % Add the fixation point.
    win.addOval([0 0], params.fpSize, params.fpColor, 'Name', 'fp');
    
    % Add text
    win.addText('Hit any button to start', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'startText');     % Identifier for the object.
    
    % Add text
    win.addText(['Key :', 'Interval 1 -> ', params.interval1Key,' Interval 2 -> ',params.interval2Key ], ...        % Text to display
        'Center', [0 -8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'keyOptions');     % Identifier for the object.
    
    % Turn all objects off for now.
    win.disableAllObjects;
    
catch e
    win.close;
    rethrow(e);
end
end


function response = getUserResponse(params,key)
response = [];
switch key.charCode
    % Left/Down
    case params.interval1Key
        response = 1;
        
        % Right/Up
    case params.interval2Key
        response = 2;
end % switch
end

