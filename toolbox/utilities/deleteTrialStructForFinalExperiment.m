function deleteTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

% This function deletes trial structs.
%
% Vijay Singh wrote this. Jan 04 2019
% Vijay Singh updated this. Feb 21 2019
% Vijay Singh updated this. Jan 03 2020


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

pathToTrialStruct = fullfile(getpref('VirtualWorldPsychophysics','stimulusInputBaseDir'),...
    directoryName,[nameOfTrialStruct '.mat']);
delete(pathToTrialStruct);


end