function params = LightnessV4StaircaseDriver(exp)
% LightnessV4StaircaseDriver - Driver for the LightnessV4 experiments.
%
% March 2013  dhb  Modified from method of constant stimuli version.

% Seed the random number generator using the computer clock.
ClockRandSeed;

% Initialize the experimental parameters.
params = initParams(exp);

% Initialize staircase objects
params.staircaseType = 'standard';
params.grain = 20;
params.stepSizes = [4/params.grain 4/params.grain 2/params.grain 1/params.grain];
params.nUps = 1:params.numInterleavedStaircases;
params.nDowns = params.nUps(end:-1:1);
for stim = 1:length(params.stimBlock)
    for k = 1:params.numInterleavedStaircases
        initialPoint = round(params.grain*unifrnd(0,1))/params.grain;
        params.st{stim,k} = Staircase(params.staircaseType,initialPoint, ...
            'StepSizes', params.stepSizes, 'NUp', params.nUps(k), 'NDown', params.nDowns(k), ...
            'MaxValue', 1, 'MinValue', 0);
    end
end

% Open up the display and load our images.
[win, params] = initDisplay(params);

% Fuss with times for simulated observer
if (params.simulateObserver)
    params.iti = 0.001;
    params.probeTime = 0.001;
    params.preprobeTime = 0;
end

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
totalTrials = params.numPracticeTrials + params.numInterleavedStaircases*params.stimsPerBlock*params.numTrialsPerStaircase;
trialsRun = 0;

% Run practice trials
if (params.numPracticeTrials > params.stimsPerBlock)
    error('Too many practice trials specified');
end
practiceBlock = params.stimBlock(Shuffle(1:params.stimsPerBlock));
for t = 1:params.numPracticeTrials
    % Set the locations for the stimulus images.
    order = Shuffle(1:length(practiceBlock(t).order));
    for i = 1:params.numStims
        objName = sprintf('im%d',order(i));
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
    
    % Set the probe locations and their intensity.  Use random value
    % for the test during the practice trials.
    testIntensity = round(params.grain*unifrnd(0,1))/params.grain;
    win.setObjectColor('refProbe', ones(1,3)*practiceBlock(t).refIntensity);
    win.setObjectColor('testProbe', ones(1,3)*testIntensity);
    
    % Wait for the right moment and pop in the probes
    mglWaitSecs(params.preprobeTime);
    win.draw;
    
    % Set the probe locations back to the background
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
        fprintf('Practice trial %d\n',trialsRun+1);
        fprintf('\tStim ID: %d\n', practiceBlock(t).stimID);
        fprintf('\tImage order:');
        for i = 1:length(order);
            fprintf(' %d', order(i));
        end
        fprintf('\n\tRef intensity: %g\n', practiceBlock(t).refIntensity);
        fprintf('\tTest intensity: %g\n', testIntensity);
    end
    
    % Wait for a keypress.
    if (params.simulateObserver == 0) 
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
    end
    
    % Blank the screen and wait the inter-trial interval.
    win.disableAllObjects('fp');
    win.draw;
    mglWaitSecs(params.iti);
    trialsRun = trialsRun + 1;
end

% Run real trials
for t = 1:params.numTrialsPerStaircase
    for k = 1:params.numInterleavedStaircases
        % Randomize the block of trial stimuli.
        stimulusOrder = Shuffle(1:params.stimsPerBlock);
        
        % Do the trials for this block
        for s = 1:length(stimulusOrder)
            stim = stimulusOrder(s);
            
            % Set the locations for the stimuli images.  
            % If order == [1 2] then image 1 is on left.
            % If order == [2 1] then image 2 is on right.
            order = Shuffle(1:length(params.stimBlock(stim).order));
            if (length(order) ~= 2)
                error('The code assumes only two spatial locations');
            end
            for i = 1:params.numStims
                objName = sprintf('im%d', order(i));
                win.setObjectProperty(objName, 'Center', params.imageLocations(i,:));
            end
            
            % Select the reference and test probe targets.
            % If refTarget == 1, then reference is image 1
            % If refTarget == 2, then reference is image 2.
            refTarget = params.stimBlock(stim).stimID;
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
            testIntensity = getCurrentValue(params.st{stim,k});
            win.setObjectColor('refProbe', ones(1,3)*params.stimBlock(stim).refIntensity);
            win.setObjectColor('testProbe', ones(1,3)*testIntensity);
            
            % Wait for the right moment and pop in the probes
            mglWaitSecs(params.preprobeTime);
            win.draw;
            
            % Set the probe locations back to the background
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
                fprintf('Total trial %d of %d (staircase trial %d, staircase %d, stimulus %d)\n',trialsRun+1,totalTrials,t,k,s);
                fprintf('\tStim ID: %d\n', params.stimBlock(stim).stimID);
                fprintf('\tImage order:');
                for i = 1:length(order);
                    fprintf(' %d',order(i));
                end
                fprintf('\n\tRef intensity: %g\n', params.stimBlock(stim).refIntensity);
                fprintf('\tTest intensity: %g\n',testIntensity);
            end
            
            % Wait for a keypress.  We code the response as 0 if the reference is judged
            % lighter, and as 1 if the test is judged lighter.
            if (params.simulateObserver == 0)
                while true
                    keyPress = GetChar;
                    switch keyPress
                        case 'q'
                            error('abort');
                            
                        case LV4KeyMap.Left.Key
                            % Left key hit
                            %
                            % Image 1 is on left.  It is the reference.  It is picked.
                            %   -> reference judged lighter
                            if (order(1) == 1 && refTarget == 1)
                                response = 0;
                                
                            % Image 1 is on left.  It is the test.  It is picked.
                            %   -> test is judged lighter.
                            elseif (order(1) == 1 && refTarget == 2)
                                response = 1;
                            
                            % Image 1 is on right.  It is the reference.  It is not picked.
                            %   -> test is judged lighter.
                            elseif (order(1) == 2 && refTarget == 1)
                                response = 1;
                            
                            % Image 1 is on right.  It is the test.  It is not picked.
                            %   -> reference is judged lighter.
                            elseif (order(1) == 2 && refTarget == 2)
                                response = 0;
                            else
                                error('Should not get here');
                            end
                            responseStruct(stim,k,t).order = order;
                            responseStruct(stim,k,t).key = LV4KeyMap.Left.Key;
                            responseStruct(stim,k,t).response = response;
                            params.st{stim,k} = updateForTrial(params.st{stim,k},testIntensity,response);
                            break;
                            
                        case LV4KeyMap.Right.Key
                            % Right key hit.
                            %
                            % Image 1 is on left.  It is the reference.  It is not picked.
                            %   -> test is judged lighter.
                            if (order(1) == 1 && refTarget == 1)
                                response = 1;
                                
                            % Image 1 is on left.  It is the test.  It is not picked.
                            %   -> reference is judged lighter.
                            elseif (order(1) == 1 && refTarget == 2)
                                response = 0;
                            
                            % Image 1 is on right.  It is the reference.  It is picked.
                            %   -> reference is judged lighter.       
                            elseif (order(1) == 2 && refTarget == 1)
                                response = 0;
                            
                            % Image 1 is on right.  It is the test.  It is picked.
                            %   -> test is judged lighter.
                            elseif (order(1) == 2 && refTarget == 2)
                                response = 1;
                            else
                                error('Should not get here');
                            end
                            responseStruct(stim,k,t).order = order;
                            responseStruct(stim,k,t).key = LV4KeyMap.Right.Key;
                            responseStruct(stim,k,t).response = response;
                            params.st{stim,k} = updateForTrial(params.st{stim,k},testIntensity,response);
                            break;

                        otherwise
                    end
                end
            else
                if (testIntensity + normrnd(0,params.simulateSd) > params.stimBlock(stim).refIntensity)
                    % Simulate.  Test picked.
                    response = 1;
                    
                    % Image 1 is on left.  It is the reference.  It is not picked.
                    if (order(1) == 1 && refTarget == 1)
                        responseStruct(stim,k,t).key = LV4KeyMap.Right.Key;
                        
                        % Image 1 is on left.  It is the test.  It is picked.
                    elseif (order(1) == 1 && refTarget == 2)
                        responseStruct(stim,k,t).key = LV4KeyMap.Left.Key;
                        
                        % Image 1 is on right.  It is the reference.  It is not picked.
                    elseif (order(1) == 2 && refTarget == 1)
                        responseStruct(stim,k,t).key = LV4KeyMap.Left.Key;
                        
                        % Image 1 is on right.  It is the test.  It is picked.
                    elseif (order(1) == 2 && refTarget == 2)
                        responseStruct(stim,k,t).key = LV4KeyMap.Right.Key;
                    else
                        error('Should not get here');
                    end
                else
                    % Simulate.  Test not picked.
                    response = 0;
                    
                    % Image 1 is on left.  It is the reference.  It is picked.
                    if (order(1) == 1 && refTarget == 1)
                        responseStruct(stim,k,t).key = LV4KeyMap.Left.Key;
                        
                        % Image 1 is on left.  It is the test.  It is not picked.
                    elseif (order(1) == 1 && refTarget == 2)
                        responseStruct(stim,k,t).key = LV4KeyMap.Right.Key;
                        
                        % Image 1 is on right.  It is the reference.  It is picked.
                    elseif (order(1) == 2 && refTarget == 1)
                        responseStruct(stim,k,t).key = LV4KeyMap.Right.Key;
                        
                        % Image 1 is on right.  It is the test.  It is not picked.
                    elseif (order(1) == 2 && refTarget == 2)
                        responseStruct(stim,k,t).key = LV4KeyMap.Left.Key;
                    else
                        error('Should not get here');
                    end
                end
                responseStruct(stim,k,t).order = order;
                responseStruct(stim,k,t).response = response;
                params.st{stim,k} = updateForTrial(params.st{stim,k},testIntensity,response);
            end
            
            % Blank the screen and wait the inter-trial interval.
            win.disableAllObjects('fp');
            win.draw;
            mglWaitSecs(params.iti);
            
            % Store the trial info.
            fNames = fieldnames(params.stimBlock(stim));
            for i = 1:length(fNames)
                responseStruct(stim,k,t).(fNames{i}) = params.stimBlock(stim).(fNames{i});
            end
            responseStruct(stim,k,t).order = order;
            
            % Break?
            trialsRun = trialsRun + 1;
            if (params.simulateObserver == 0)
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
    if (params.numStims ~= 2)
        error('Code assumes only two underlying images');
    end
    for i = 1:params.numStims
        fprintf('Image %d, %s\n',i,params.stimInfo(i).imageName);
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
