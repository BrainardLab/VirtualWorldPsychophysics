% startup;
% tbUseProject('VirtualWorldPsychophysics');

% Get the data and the psychometric functions based on total RGB values at
% the center of the images.

% David's order: Chosen Randomly.
%
% Session 1 : Condition 2 1 3
% Session 2 : Condition 3 2 1
% Session 3 : Condition 1 3 2
% 

session = 1;
condition = 1;
subjectName = 'David';
nameOfTrialStruct = [subjectName,'Session',num2str(session),'_StdY_0_40_dY_0_01'];
nameOfDataStruct = [subjectName,'Session',num2str(session),'_StdY_0_40_dY_0_01_Theoretical'];

switch condition
    case 1
        directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantFixedBkGnd';
    case 2
        directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantBetweentrialBkGndVariation';
    case 3
        directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantWithintrialBkGndVariation';
end

runLightnessExperiment('directoryName', directoryName,...
    'nameOfTrialStruct', nameOfTrialStruct, ...
    'controlSignal', 'gamePad', ...
    'interval1Key', 'GP:UpperLeftTrigger', ...
    'interval2Key', 'GP:UpperRightTrigger', ...
    'feedback', 1, ...
    'subjectName', nameOfDataStruct, ...
    'theoreticalPsychophysicsMode', 1);

