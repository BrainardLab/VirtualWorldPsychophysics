function runEasyTrials(nEasyTrials, trialStruct, cal, scaleFactor, LMSStruct, params, controlSignal, win, gamePad, parser)

% This function runs nEasyTrials number of easy trials at the beginning of
% the experiment. These trials are not saved.

keepLooping = 1;
trialToRun = find(trialStruct.trialCmpIndex == max(trialStruct.trialCmpIndex),nEasyTrials);

rightSound = sin(2*pi*[1:1000]/10)/10;
wrongSound = rand(1,1000).*sin(2*pi*[1:1000]/10)/10;

for iterTrials = trialToRun
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
    end
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