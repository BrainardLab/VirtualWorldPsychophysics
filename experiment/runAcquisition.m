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
    case '0_1'
        directoryName = 'StimuliCondition2_covScaleFactor_0_1';
    case '0_5'
        directoryName = 'StimuliCondition2_covScaleFactor_0_5';
    case '1'
        directoryName = 'StimuliCondition2_covScaleFactor_1';
    case '5'
        directoryName = 'StimuliCondition2_covScaleFactor_5';
    case '10'
        directoryName = 'StimuliCondition2_covScaleFactor_10';
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
