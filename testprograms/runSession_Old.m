% startup;
% tbUseProject('VirtualWorldPsychophysics');

% Run Sessions for the lightness experiment

% David's order: Chosen Randomly.
%
% Session 1 : Condition 2 1 3
%
% Session 2 : Condition 3 2 1
% Session 3 : Condition 1 3 2
% 

session = 3;
condition = 5;
subjectName = 'Vijay';
nameOfTrialStruct = [subjectName,'Session',num2str(session),'_StdY_0_40_dY_0_01'];

switch condition
    case 1
        directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantFixedBkGnd';
    case 2
        directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantBetweentrialBkGndVariation';
    case 3
        directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantWithintrialBkGndVariation';
    case 4
        directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantWithintrialBkGndVariationNoReflection';
    case 5
        directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantBetweentrialBkGndVariationNoReflection';
end

runLightnessExperiment('directoryName', directoryName,...
    'nameOfTrialStruct', nameOfTrialStruct, ...
    'controlSignal', 'gamePad', ...
    'interval1Key', 'GP:UpperLeftTrigger', ...
    'interval2Key', 'GP:UpperRightTrigger', ...
    'feedback', 1, ...
    'subjectName', nameOfTrialStruct);

