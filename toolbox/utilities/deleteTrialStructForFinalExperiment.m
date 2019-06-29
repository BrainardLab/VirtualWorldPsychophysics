function deleteTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

% This function deletes trial structs.
%
% Vijay Singh wrote this. Jan 04 2019
% Vijay Singh updated this. Feb 21 2019


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
end

pathToTrialStruct = fullfile(getpref('VirtualWorldPsychophysics','stimulusInputBaseDir'),...
    directoryName,[nameOfTrialStruct '.mat']);
delete(pathToTrialStruct);


end