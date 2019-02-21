function deleteTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

% This function deletes trial structs.
%
% Vijay Singh wrote this. Jan 04 2019
% Vijay Singh updated this. Feb 21 2019


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

pathToTrialStruct = fullfile(getpref('VirtualWorldPsychophysics','stimulusInputBaseDir'),...
    directoryName,[nameOfTrialStruct '.mat']);
delete(pathToTrialStruct);


end