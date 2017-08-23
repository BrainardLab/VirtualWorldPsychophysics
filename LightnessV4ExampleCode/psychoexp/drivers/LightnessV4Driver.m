function params = LightnessV4Driver(exp)
% LightnessV4Driver - Driver for the LightnessV4 experiments.

% Seed the random number generator using the computer clock.
ClockRandSeed;

% Initialize the experimental parameters.
params = initParams(exp);

% Open up the display and load our images.
[win, params] = initDisplay(params);

try
    % Run the experiment.
    [params, responseStruct] = experimentLoop(win, params);
    
    % Stick the response struct into params so it's stored in the data file.
    params.responseStruct = responseStruct;
    
    % Close our display.
    win.close;
    
    % Make sure key capture is off.
    ListenChar(0);
catch e
    ListenChar(0);
    win.close;
    rethrow(e);
end

function [params, responseStruct] = experimentLoop(win, params)
responseStruct = [];

% Get the keyboard listener ready.
ListenChar(2);
FlushEvents;

% Show the fixation point
win.disableAllObjects('fp');
win.enableObject('startText');
win.draw;
GetChar;
win.disableObject('startText');

% Compute total number of trials
totalTrials = params.numPracticeTrials + params.numBlocks*params.stimsPerBlock;
trialsRun = 0;

% Run practice trials
if (params.numPracticeTrials > params.stimsPerBlock)
    error('Too many practice trials specified');
end
practiceBlock = params.stimBlock(Shuffle(1:params.stimsPerBlock));
for t = 1:params.numPracticeTrials
    % Set the locations for the stimuli images.
    for i = 1:params.numStims
        objName = sprintf('im%d', practiceBlock(t).order(i));
        win.setObjectProperty(objName, 'Center', params.imageLocations(i,:));
    end
    
    % Select the reference and test probe targets.
    refTarget = practiceBlock(t).stimID;
    if refTarget == 1
        testTarget = 2;
    else
        testTarget = 1;
    end
    
    % Set the probe locations and their intensity.
    objNameRef = sprintf('im%d', refTarget);
    win.setObjectProperty('refProbe', 'Center', win.getObjectProperty(objNameRef, 'Center'));
    win.setObjectColor('refProbe', ones(1,3)*params.blankcolor(refTarget));
    objNameTest = sprintf('im%d', testTarget);
    win.setObjectProperty('testProbe', 'Center', win.getObjectProperty(objNameTest, 'Center'));
    win.setObjectColor('testProbe', ones(1,3)*params.blankcolor(testTarget));
    
    % Clear the keyboard queue before we draw the stimuli.
    FlushEvents;
    
    % Enable all the objects and draw.
    win.enableAllObjects('startText');
    win.draw;
    
    % Set the probe locations and their intensity.
    win.setObjectColor('refProbe', ones(1,3)*practiceBlock(t).refIntensity);
    win.setObjectColor('testProbe', ones(1,3)*practiceBlock(t).testIntensity);
    
    % Wait for the right moment and pop in the probes
    mglWaitSecs(params.preprobeTime);
    win.draw;
    
    % Set the probe locations back to the background
    %
    % NOTE: Background color currently hard coded, needs to be
    % set in parameter file.
    win.setObjectColor('refProbe', ones(1,3)*params.blankcolor(refTarget));
    win.setObjectColor('testProbe', ones(1,3)*params.blankcolor(testTarget));
    
    % Leave the probes up the specified time
    mglWaitSecs(params.probeTime);
    win.draw;
    
    % Blank the screen and wait the inter-trial interval.
    win.disableAllObjects('fp');
    mglWaitSecs(params.postprobeTime);
    win.draw;
    
    if params.verbose
        fprintf('Stim ID: %d\n', practiceBlock(t).stimID);
        fprintf('Image order:');
        for i = 1:length(practiceBlock(t).order);
            fprintf(' %d', practiceBlock(t).order(i));
        end
        fprintf('\nRef intensity: %g\n', practiceBlock(t).refIntensity);
        fprintf('Test intensity: %g\n', practiceBlock(t).testIntensity);
    end
    
    % Wait for a keypress.
    while true
        keyPress = GetChar;
        switch keyPress
            case 'q'
                error('abort');
                
            case LV4KeyMap.Left.Key
                break;
                
            case LV4KeyMap.Right.Key
                break;
                
            otherwise
        end
    end
    
    % Blank the screen and wait the inter-trial interval.
    win.disableAllObjects('fp');
    win.draw;
    mglWaitSecs(params.iti);
    trialsRun = trialsRun + 1;
end

% Run real trials
for b = 1:params.numBlocks
    % Randomize the block of trial stimuli.
    stimBlock = params.stimBlock(Shuffle(1:params.stimsPerBlock));
    
    % Loop over all stimuli.
    for t = 1:params.stimsPerBlock
        % Set the locations for the stimuli images.
        for i = 1:params.numStims
            objName = sprintf('im%d', stimBlock(t).order(i));
            win.setObjectProperty(objName, 'Center', params.imageLocations(i,:));
        end
        
        % Select the reference and test probe targets.
        refTarget = stimBlock(t).stimID;
        if refTarget == 1
            testTarget = 2;
        else
            testTarget = 1;
        end
        
        % Set the probe locations and their intensity.
        objNameRef = sprintf('im%d', refTarget);
        win.setObjectProperty('refProbe', 'Center', win.getObjectProperty(objNameRef, 'Center'));
        win.setObjectColor('refProbe', ones(1,3)*params.blankcolor(refTarget));
        objNameTest = sprintf('im%d', testTarget);
        win.setObjectProperty('testProbe', 'Center', win.getObjectProperty(objNameTest, 'Center'));
        win.setObjectColor('testProbe', ones(1,3)*params.blankcolor(testTarget));
        
        % Clear the keyboard queue before we draw the stimuli.
        FlushEvents;
        
        % Enable all the objects and draw.
        win.enableAllObjects('startText');
        win.draw;
        
        % Set the probe locations and their intensity.
        win.setObjectColor('refProbe', ones(1,3)*stimBlock(t).refIntensity);
        win.setObjectColor('testProbe', ones(1,3)*stimBlock(t).testIntensity);
        
        % Wait for the right moment and pop in the probes
        mglWaitSecs(params.preprobeTime);
        win.draw;
        
        % Set the probe locations back to the background
        %
        % NOTE: Background color currently hard coded, needs to be
        % set in parameter file.
        win.setObjectColor('refProbe', ones(1,3)*params.blankcolor(refTarget));
        win.setObjectColor('testProbe', ones(1,3)*params.blankcolor(testTarget));
        
        % Leave the probes up the specified time
        mglWaitSecs(params.probeTime);
        win.draw;
        
        % Blank the screen and wait the inter-trial interval.
        win.disableAllObjects('fp');
        mglWaitSecs(params.postprobeTime);
        win.draw;
        
        if params.verbose
            fprintf('Stim ID: %d\n', stimBlock(t).stimID);
            fprintf('Image order:');
            for i = 1:length(stimBlock(t).order);
                fprintf(' %d', stimBlock(t).order(i));
            end
            fprintf('\nRef intensity: %g\n', stimBlock(t).refIntensity);
            fprintf('Test intensity: %g\n', stimBlock(t).testIntensity);
        end
        
        % Wait for a keypress.
        while true
            keyPress = GetChar;
            switch keyPress
                case 'q'
                    error('abort');
                    
                case LV4KeyMap.Left.Key
                    responseStruct(b,t).key = LV4KeyMap.Left;
                    break;
                    
                case LV4KeyMap.Right.Key
                    responseStruct(b,t).key = LV4KeyMap.Right;
                    break;
                    
                otherwise
            end
        end
        
        % Blank the screen and wait the inter-trial interval.
        win.disableAllObjects('fp');
        win.draw;
        mglWaitSecs(params.iti);
        
        % Store the trial info.
        fNames = fieldnames(stimBlock);
        for i = 1:length(fNames)
            responseStruct(b,t).(fNames{i}) = stimBlock(t).(fNames{i});
        end
        
        % Break?
        trialsRun = trialsRun + 1;
        if (rem(trialsRun,params.numTrialsBetweenBreaks) == 0 && totalTrials-trialsRun > 5)
            win.addText(sprintf('%d of %d trials done.  Hit any button to continue',...
                trialsRun,totalTrials), ...
                'Center', [0 8], ...% Where to center the text. (x,y)
                'FontSize', 75, ...   % Font size
                'Color', [0 0 0], ...  % RGB color
                'Name', 'startText');     % Identifier for the object.
            win.enableObject('startText');
            win.draw;
            GetChar;
            win.disableObject('startText');
        end
        
    end
    
    
end


function [win, params] = initDisplay(params)

% Load the calibration data, compute linearization table
cal = LoadCalFile(params.calFile);
assert(~isempty(cal), 'LightnessV4Driver:InvalidCal', ...
    'Could not load calibration file: %s', params.calFile);
cal = SetGammaMethod(cal, 0);
gammaTable = PrimaryToSettings(cal, mglGetIdentityGamma')';

% Create the GLWindow object and linearize the clut.
win = GLWindow('SceneDimensions', params.screenDims, ...
    'BackgroundColor', params.bgColor, ...
    'Gamma', gammaTable);

try
    % Open the display.
    win.open;
    
    % Add the images.  The image center parameters are meaningless here as
    % they'll be changed each trial.
    for i = 1:params.numStims
        fileName = fullfile(params.stimuliDir, [params.stimInfo(i).imageName '.mat']);
        data = load(fileName);
        
        % Convert the image data to RGB format.
        rgbData = zeros([size(data.theImage), 3]);
        for j = 1:3
            rgbData(:,:,j) = data.theImage;
        end
        
        imagePixHeight = size(rgbData,1);
        imagePixWidth = size(rgbData,2);
        imageSize = [params.imageWidth params.imageWidth*imagePixHeight/imagePixWidth];
        win.addImage([0 0], imageSize, rgbData, 'Name', sprintf('im%d', i));
        params.probeIndex{i} = data.probeIndex;
        params.blankcolor(i) = data.blankcolor;
    end
    
    % Add the probes.  The location and color are unimportant as they'll be
    % changed each trial.
    win.addOval([0 0], params.probeSize, [1 1 1], 'Name', 'testProbe');
    win.addOval([0 0], params.probeSize, [1 1 1], 'Name', 'refProbe');
    
    % Add the fixation point.
    win.addOval([0 0], params.fpSize, params.fpColor, 'Name', 'fp');
    
    % Add text
    win.addText('Hit any button to start', ...        % Text to display
        'Center', [0 8], ...% Where to center the text. (x,y)
        'FontSize', 75, ...   % Font size
        'Color', [0 0 0], ...  % RGB color
        'Name', 'startText');     % Identifier for the object.
    
    % Turn all objects off for now.
    win.disableAllObjects('fp');
catch e
    win.close;
    rethrow(e);
end


function params = initParams(exp)
% Read the config file and convert it into a struct.
cfgObj = ConfigFile(exp.configFileName);
params = cfgObj.convertToStruct;

% Read the stimulus definition file and convert it into a struct array.
% One struct element per stimulus.
csvFileName = fullfile(exp.configFileDir, 'stimuli', exp.conditionName, params.stimDefs);
params.stimInfo = LV4ParseStimDef(csvFileName, LV4StimBlockType.(params.stimBlockType));
params.numStims = length(params.stimInfo);

% Take the stimulus information turn it into a struct array defining one block's
% worth of trials.
params.stimBlock = LV4CreateStimBlock(params.stimInfo, LV4StimBlockType.(params.stimBlockType));
params.stimsPerBlock = length(params.stimBlock);

params.stimuliDir = exp.stimuliDir;
