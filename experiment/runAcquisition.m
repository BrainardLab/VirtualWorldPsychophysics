function acquisitionStatus = runAcquisition(subjectName, iterationNumber, condition, scaleFactor)

% This script runs the sessions over three conditions of lightness experiment.
% First generate random sequence for the conditions for the three sessions
% and save it in the excel file
% VirtualWorldPsychophysics/data/Experiment5/SubjectInformation/SequenceForExperiment.
% This random sequence is the order in which the conditions will be run for
% a given session.
%
%
%% Update this section for each acquisition
nameOfTrialStruct = [subjectName,'_Condition_',condition,'_Iteration_',num2str(iterationNumber)];

switch condition
    case '_0_0_to_0_0'
        directoryName = 'StimuliIlluminantScale_0_0_to_0_0';
    case '_0_95_to_1_05'
        directoryName = 'StimuliIlluminantScale_0_95_to_1_05';
    case '_0_9_to_1_1'
        directoryName = 'StimuliIlluminantScale_0_9_to_1_1';
    case '_0_85_to_1_15'
        directoryName = 'StimuliIlluminantScale_0_85_to_1_15';
    case '_0_8_to_1_2'
        directoryName = 'StimuliIlluminantScale_0_8_to_1_2';
    case '_0_75_to_1_25'
        directoryName = 'StimuliIlluminantScale_0_75_to_1_25';
    case '_0_7_to_1_3'
        directoryName = 'StimuliIlluminantScale_0_7_to_1_3';
    case '_0_5_to_2_0'
        directoryName = 'StimuliIlluminantScale_0_5_to_2_0';
    
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
