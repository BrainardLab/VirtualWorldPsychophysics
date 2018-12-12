function runSession(subjectName, session, condition)

% This script runs the sessions over three conditions of lightness experiment.
% First generate random sequence for the conditions for the three sessions
% and save it in the excel file
% VirtualWorldPsychophysics/data/SubjectInformation/SequenceForExperiment.
% This random sequence is the order in which the conditions will be ru for
% a given session.
%
%
%% Update this section for each acquisition
nameOfTrialStruct = [subjectName,'_Session_',num2str(session)];

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
end