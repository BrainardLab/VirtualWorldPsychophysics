function deleteTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

% This function deletes trial structs.
%
% Vijay Singh wrote this. Jan 04 2019
% Vijay Singh updated this. Feb 21 2019


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
%         
%     case '10'
%         directoryName = 'StimuliCondition2_covScaleFactor_10';
        
end

pathToTrialStruct = fullfile(getpref('VirtualWorldPsychophysics','stimulusInputBaseDir'),...
    directoryName,[nameOfTrialStruct '.mat']);
delete(pathToTrialStruct);


end