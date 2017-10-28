% Test script for runLightnessExperiment function
% 
% The options are defined below:
% 'directoryName' : Name of directory where the LMS struct and the trialStruct is stored
% 'nameOfTrialStruct' : Name of trial struct that will be used in the experiment
% 'controlSignal' : The input method for response 'keyboard' or 'gamePad'
% 'interval1Key' : For keyboard -> 1, For gamePad either GP:1 or GP:X
% 'interval2Key' : For keyboard -> 2, For gamePad either GP:2 or GP:A
% 'subjectName' : Name of the subject

runLightnessExperiment('directoryName', 'FixedTargetShapeFixedIlluminantFixedBkGnd',...
        'nameOfTrialStruct', 'exampleTrial', ...
        'controlSignal', 'keyboard', ...
        'interval1Key', '1', ...
        'interval2Key', '2', ...        
        'subjectName', 'testSubject');
    
% mglClose;  ListenChar(0);