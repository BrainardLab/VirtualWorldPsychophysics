% startup;
% tbUseProject('VirtualWorldPsychophysics');

% Run Sessions for the lightness experiment

% David's order: First run was Condition 1 chosen by Vijay.
% From then on, random permuations
% Session 1 : Condition 2 1 3
% Session 2 : Condition 3 2 1
% Session 3 : Condition 1 3 2
% 

session = 1;
condition = 2;
subjectName = 'David';
nameOfTrialStruct = [subjectName,'Session',num2str(session),'_StdY_0_40_dY_0_01'];

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
    'subjectName', nameOfTrialStruct);

