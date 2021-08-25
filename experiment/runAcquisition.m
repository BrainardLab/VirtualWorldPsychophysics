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
        directoryName = 'StimuliCondition2_covScaleFactor_0_00_NoReflection';
    case '0_01'
        directoryName = 'StimuliCondition2_covScaleFactor_0_01_NoReflection';
    case '0_03'
        directoryName = 'StimuliCondition2_covScaleFactor_0_03_NoReflection';
    case '0_10'
        directoryName = 'StimuliCondition2_covScaleFactor_0_10_NoReflection';
    case '0_30'
        directoryName = 'StimuliCondition2_covScaleFactor_0_30_NoReflection';
    case '1_00'
        directoryName = 'StimuliCondition2_covScaleFactor_1_00_NoReflection';
%     case '5'
%         directoryName = 'StimuliCondition2_covScaleFactor_5';
%     case '10'
%         directoryName = 'StimuliCondition2_covScaleFactor_10';
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
