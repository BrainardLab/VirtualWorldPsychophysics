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
    case '_0_1_to_1_0'
        directoryName = 'StimuliIlluminantScale_0_1_to_1_0';
    case '_0_5_to_2_0'
        directoryName = 'StimuliIlluminantScale_0_5_to_2_0';
        
end

pathToTrialStruct = fullfile(getpref('VirtualWorldPsychophysics','stimulusInputBaseDir'),...
    directoryName,[nameOfTrialStruct '.mat']);
delete(pathToTrialStruct);


end