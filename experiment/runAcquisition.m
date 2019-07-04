function acquisitionStatus = runAcquisition(subjectName, iterationNumber, condition, scaleFactor)

% This script runs the sessions over three conditions of lightness experiment.
% First generate random sequence for the conditions for the three sessions
% and save it in the excel file
% VirtualWorldPsychophysics/data/Experiment3/SubjectInformation/SequenceForExperiment.
% This random sequence is the order in which the conditions will be run for
% a given session.
%
%
%% Update this section for each acquisition
nameOfTrialStruct = [subjectName,'_Condition_',condition,'_Iteration_',num2str(iterationNumber)];

switch condition
    case '0_00'
        directoryName = 'Radius_0_00';
    case '0_10'
        directoryName = 'Radius_0_10';
    case '0_25'
        directoryName = 'Radius_0_25';
    case '0_40'
        directoryName = 'Radius_0_40';
    case '0_55'
        directoryName = 'Radius_0_55';
    case '0_55_FixedLocation'
        directoryName = 'Radius_0_55_FixedLocation';        
end

acquisitionStatus = runLightnessExperiment('directoryName', directoryName,...
    'nameOfTrialStruct', nameOfTrialStruct, ...
    'controlSignal', 'gamePad', ...
    'interval1Key', 'GP:UpperLeftTrigger', ...
    'interval2Key', 'GP:UpperRightTrigger', ...
    'feedback', 1, ...
    'subjectName', nameOfTrialStruct, ...
    'scaleFactor', scaleFactor);
end
