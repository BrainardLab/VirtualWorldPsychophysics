function deleteTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

% This function deletes trial structs.
%
% Vijay Singh wrote this. Jan 04 2019
% Vijay Singh updated this. Feb 21 2019


nameOfTrialStruct = [subjectName,'_Condition_',condition,'_Iteration_',num2str(iterationNumber)];

switch condition
    case '0_00'
        directoryName = 'Radius_0_00';
    case '0_03'
        directoryName = 'Radius_0_03';
    case '0_10'
        directoryName = 'Radius_0_10';
    case '0_30'
        directoryName = 'Radius_0_30';
    case '0_55'
        directoryName = 'Radius_0_55';
    case '0_55_FixedLocation'
        directoryName = 'Radius_0_55_FixedLocation';     
    case '0_55_TargetAtCenter'
        directoryName = 'Radius_0_55_TargetAtCenter';                
end

pathToTrialStruct = fullfile(getpref('VirtualWorldPsychophysics','stimulusInputBaseDir'),...
    directoryName,[nameOfTrialStruct '.mat']);
delete(pathToTrialStruct);


end