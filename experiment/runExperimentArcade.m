function numberOfCorrectResponse = runExperimentArcade(varargin)
%%runExperiment : run lightness estimation experiment for the arcade game
%
% Usage:
%   runExperimentArcade();
%
% Description:
%   Run the lightness estimation psychophysics experiment given the
%   calibration file, trial struct and LMS stimulus struct. Give the
%   resutls of how many correct responses in the end.
%
% Input:
%   None
%
% Output:
%   numberOfCorrectResponse
%
% Optional key/value pairs:
%    'directoryName' : (string) Directory name of the case which will be studied (default 'ExampleDirectory')
%    'nameOfTrialStruct' : (string) Name of trail stuct to be used in experiment (defalult 'exampleTrial')
%    'nameOfCalibrationFile : (string) Name of calibration file (default 'VirtualWorldCalibration.mat')
%    'whichCalibration' : (scalar) Which calibration in file to use (default Inf -> most recent)
%    'controlSignal' : (string) How to collect user response (options: 'gamePad', 'keyboard', default 'keyboard')
%    'subjectName' : (string) Name of subject (default 'testSubject')

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('nameOfTrialStruct', 'exampleTrial', @ischar);
parser.addParameter('nameOfCalibrationFile', 'VirtualWorldCalibration', @ischar);
parser.addParameter('scaleFactor', 0, @isscalar);
parser.addParameter('whichCalibration', Inf, @isscalar);
parser.addParameter('controlSignal', 'keyboard', @ischar);
parser.addParameter('interval1Key', '1', @ischar);
parser.addParameter('interval2Key', '2', @ischar);
parser.addParameter('feedback', 0, @isscalar);
parser.addParameter('isDemo', 0, @isscalar);
parser.addParameter('subjectName', 'testSubject', @ischar);
parser.addParameter('theoreticalPsychophysicsMode', 0, @isscalar);
parser.parse(varargin{:});

directoryName = parser.Results.directoryName;
nameOfTrialStruct = parser.Results.nameOfTrialStruct;
nameOfCalibrationFile = parser.Results.nameOfCalibrationFile;
whichCalibration = parser.Results.whichCalibration;
scaleFactor = parser.Results.scaleFactor;
controlSignal = parser.Results.controlSignal;
interval1Key = parser.Results.interval1Key;
interval2Key = parser.Results.interval2Key;
subjectName = parser.Results.subjectName;
theoreticalPsychophysicsMode = parser.Results.theoreticalPsychophysicsMode;

projectName = 'VirtualWorldPsychophysics';
ExperimentType = 'Lightness';
% May want to change this to name the experiment cases differently
caseName = directoryName;

rightSound = sin(2*pi*[1:1000]/10)/10;
wrongSound = rand(1,1000).*sin(2*pi*[1:1000]/10)/10;

numberOfCorrectResponse = 0;
%% Some experimental parameters.
%
% May want to read these from a file at
% some point.
params.screenDimsCm = [59.65 33.55];
params.fpSize = [0.1 0.1]; % fixation point size
params.fpColor = [34 70 34]/255; % fixation point color
params.bgColor = [0 0 0];
params.textColor = [0.6 0.2 0.2];
params.firstImageLoc = [0 0];
params.secondImageLoc = [0 0];
params.firstImageSize = [2.62 2.62];
params.secondImageSize = [2.62 2.62];
params.ISI = 0.25;
params.ITI = 0.25;
params.stimDuration = 0.25;
params.interval1Key = interval1Key;
params.interval2Key = interval2Key;
results = [0 0];

% If the game pad has symbol 1 2 3 4, instead of X A B Y
if strcmp(interval1Key,'GP:1') params.interval1Key = 'GP:UpperLeftTrigger'; end
if strcmp(interval2Key,'GP:2') params.interval2Key = 'GP:UpperRightTrigger'; end

%% Load the trial struct
pathToTrialStruct = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
    directoryName,[nameOfTrialStruct '.mat']);
temp = load(pathToTrialStruct); trialStruct = temp.trialStruct; clear temp;

%% Load the LMS struct
LMSstructName = trialStruct.LMSstructName;
pathToLMSStruct = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
    directoryName,[LMSstructName '.mat']);
temp = load(pathToLMSStruct); LMSStruct = temp.LMSStruct; clear temp;

%% Load calibration file
cal = LoadCalFile(nameOfCalibrationFile,whichCalibration,fullfile(getpref('VirtualWorldPsychophysics','calibrationDir')));
if (isempty(cal))
    error('Could not find specified calibration file');
end

%% Initialize calibration structure for the cones
cal = SetSensorColorSpace(cal, LMSStruct.T_cones, LMSStruct.S); % Fix the last option

%% Find the scale factor
if (scaleFactor == 0)
    scaleFactor = findScaleFactor(cal, LMSStruct);
end

%% Set Gamma Method
cal = SetGammaMethod(cal,0);

%% Start Time of Experiment
startTime = datestr(now);

%% Now loop over the images for presentation on screen
% Before that figure out how long it takes to convert two LMS to RGB and
% present on screen. Shouldn't be very long
response = struct('subjectName',subjectName, ...
    'correctResponse',[],...
    'actualResponse',[]);

%% Initiate display
[win, params] = initDisplay(params, results);

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
win.enableObject('TrialStartText');
win.enableObject('keyOptions');
win.draw;

%% Wait for key
% keyPress = GetChar;
key = [];
while (isempty(key))
    if (strcmp(controlSignal, 'keyboard'))
        key = mglGetKeyEvent;
    else
        key = gamePad.getKeyEvent();
    end
end


%% Turn off start text, add images and wait for another key
win.disableObject('TrialStartText');
win.disableObject('keyOptions');

% Run easy trials
nEasyTrials = 5;

runEasyTrials(nEasyTrials, trialStruct, cal, scaleFactor, LMSStruct, params, controlSignal, win, gamePad, parser);

win.enableObject('fp');
win.enableObject('PracticeOverText');
win.draw;
pause(10);
win.disableObject('PracticeOverText');
win.disableObject('keyOptions');


% Clear out any previous keypresses.
FlushEvents;

%% Enable fixation and start text
win.enableObject('fp');
win.enableObject('RealSessionText');
win.enableObject('keyOptions');
win.draw;

%% Wait for key
% keyPress = GetChar;
key = [];
while (isempty(key))
    if (strcmp(controlSignal, 'keyboard'))
        key = mglGetKeyEvent;
    else
        key = gamePad.getKeyEvent();
    end
end


%% Turn off start text, add images and wait for another key
win.disableObject('RealSessionText');
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
    stdRGBImage = CalFormatToImage(SensorToSettings(cal, scaleFactor*LMSStruct.LMSImageInCalFormat(:,:,stdIndex)),LMSStruct.cropImageSizeX,LMSStruct.cropImageSizeY);
    cmpRGBImage = CalFormatToImage(SensorToSettings(cal, scaleFactor*LMSStruct.LMSImageInCalFormat(:,:,cmpIndex)),LMSStruct.cropImageSizeX,LMSStruct.cropImageSizeY);
    stdRGBImage(stdRGBImage < 0 ) = 0;
    cmpRGBImage(cmpRGBImage < 0 ) = 0;
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
    
    if theoreticalPsychophysicsMode
        meanRGBFirstImage = mean(mean(mean(firstImage(floor(LMSStruct.cropImageSizeX/2)-4:floor(LMSStruct.cropImageSizeX/2)+5, ...
                                                        floor(LMSStruct.cropImageSizeX/2)-4:floor(LMSStruct.cropImageSizeX/2)+5,:))));
        meanRGBSecondImage = mean(mean(mean(secondImage(floor(LMSStruct.cropImageSizeX/2)-4:floor(LMSStruct.cropImageSizeX/2)+5, ...
                                                        floor(LMSStruct.cropImageSizeX/2)-4:floor(LMSStruct.cropImageSizeX/2)+5,:))));
        keyPress(iterTrials) = (meanRGBSecondImage > meanRGBFirstImage) + 1;
        actualResponse(iterTrials) = keyPress(iterTrials);
    else
    % For testing, extract average RGB values from center of first and
    % second image, and figure out which is bigger
    
    % Write the images into the window and disable
    win.addImage(params.firstImageLoc, params.firstImageSize, firstImage, 'Name', 'firstImage');
    win.addImage(params.secondImageLoc, params.secondImageSize, secondImage, 'Name', 'secondImage');
    win.disableObject('firstImage');
    win.disableObject('secondImage');
    
    % Enable "left" image and draw
    win.enableObject('firstImage');
    win.draw;
    
    % Wait for duration
    mglWaitSecs(params.stimDuration);
    win.disableObject('firstImage');
    win.draw;
    
    % Wait for ISI and show "second" image
    mglWaitSecs(params.ISI);
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
        % Give feedback if option is on
        if parser.Results.feedback
            if (actualResponse(iterTrials) == correctResponse(iterTrials));
                sound(rightSound);
            else
                sound(wrongSound);
            end
        end
        mglWaitSecs(params.ITI);        
    else
        fprintf('Quitting without saving any data.\n');
        saveData = 0;
    end
            
% Check if end of experiment is reached
    end
    if (iterTrials == length(trialStruct.trialStdIndex))
        keepLooping = false;
    end
end
%% Done with experiment, close up
%
% Show end of experimetn text
results(1) = sum(actualResponse == correctResponse);
results(2) = length(actualResponse);
win.close;

[win, params] = initDisplay(params, results);

win.enableObject('Result');
win.draw;
pause(20);
win.disableObject('Result');

% Close our display.
win.close;

% Make sure key capture is off.
ListenChar(0);

end


function [win, params] = initDisplay(params, results)

% Create the GLWindow object and linearize the clut.
win = GLWindow('SceneDimensions', params.screenDimsCm, ...
    'BackgroundColor', params.bgColor);

try
    % Open the display.
    win.open;
    
    % Add the fixation point.
    win.addOval([0 0], params.fpSize, params.fpColor, 'Name', 'fp');
    
    % Add text
    win.addText('Practice Session: Hit any button to start', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'TrialStartText');     % Identifier for the object.
 
    win.addText('Practice Session Over.', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'PracticeOverText');     % Identifier for the object.
    
    % Add text
    win.addText('Real Session: Hit any button to start', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'RealSessionText');     % Identifier for the object.

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
    
    % Add text
    win.addText('One third of trials over. Take 1 minute rest.', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'oneThirdText');     % Identifier for the object.

    % Add text
    win.addText('Rest over. Hit any button to continue', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'restOver');     % Identifier for the object.

    % Add text
    win.addText('Two third of trials over. Take 1 minute rest.', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'twoThirdText');     % Identifier for the object.

    % Add text
    win.addText([num2str(results(1)), ' out of ', num2str(results(2))], ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', params.textColor, ...  % RGB color
        'Name', 'Result');     % Identifier for the object.

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

