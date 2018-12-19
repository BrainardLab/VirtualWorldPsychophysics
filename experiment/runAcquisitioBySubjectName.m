function runAcquisitioBySubjectName(subjectName)
%function runAcquisitioBySubjectName(subjectName)
%
% Example: runAcquisitioBySubjectName('CNSU_0000')
% This function runs the session for a subject given the subject name. The
% function automatically searches for the subject struct with the name 
% 'subjectName.mat' in the folder 
% /Users/vijaysingh/Dropbox (Aguirre-Brainard Lab)/CNST_materials/
% VirtualWorldPsychophysics/data/SubjectInformation.
% If no such file exists a struct is created with this name. If the file
% exists, it finds out which session needs to be run next and then runs it.
% The data is saved and the subject information struct is updated.
%
% Input:
%   subjectName : The subject pseudo-name. String. Example: 'CNSU_0000'
% 
% Output:
%   None
%
% Vijay Singh wrote this Dec 19 2018

% Some information about the experiment
numberOfSubjectSelectionAcquisitions = 3;
numberOfExperimentIterations = 3;
numberOfConditions = 5;
ConditionNames = {'1', '2', '2a', '3', '3a'};

% Check for the file with the information about this subject's acquisitons
subjectInfoFileName = fullfile(getpref('VirtualWorldPsychophysics','dataDir'),'SubjectInformation',[subjectName,'.mat']);
if exist(subjectInfoFileName,'file')
    load(subjectInfoFileName);
else
    % If the file does not exist make the corresponding struct
    subjectInfoStruct = struct();
    subjectInfoStruct.Name = subjectName;
    subjectInfoStruct.SelectionTrialFinished = zeros(1,numberOfSubjectSelectionAcquisitions);
    subjectInfoStruct.FinalExperimentAcquisition = zeros(1,numberOfExperimentIterations*numberOfConditions);
    subjectInfoStruct.FinalExperimentOrder = [ConditionNames(randperm(5)) ConditionNames(randperm(5)) ConditionNames(randperm(5))];
end

%% Find out which session needs to be run
nextSubjectSelectionTrial = find(subjectInfoStruct.SelectionTrialFinished == 0, 1);
nextAcquisition = find(subjectInfoStruct.FinalExperimentAcquisition == 0, 1);

% If subject selection acquisition are left. First finish those acquisition.
if nextSubjectSelectionTrial < (numberOfSubjectSelectionAcquisitions+1)
    %Make the trial struct
    makeTrialStructForSubjectSelection(subjectName,nextSubjectSelectionTrial);
    % Run the acquisition   
    acquisitionStatus = runSubjectSelectionAcquisition(subjectName, nextSubjectSelectionTrial);
        
    % If the acquisition was completed update the acquisition information
    % and save the updated struct
    if acquisitionStatus
        subjectInfoStruct.SelectionTrialFinished(nextSubjectSelectionTrial) = 1;
        save(subjectInfoFileName, 'subjectInfoStruct');
    end
else
    % Iteration number
    iterationNumber = ceil(nextAcquisition/numberOfConditions);
    % Condition
    nextConditioToBeRun = char(subjectInfoStruct.FinalExperimentOrder(nextAcquisition));
    % Make the required trial struct for this condition
    makeTrialStructForFinalExperiment(subjectName, iterationNumber, nextConditioToBeRun);
    % Run this trial struct
    acquisitionStatus = runAcquisition(subjectName, iterationNumber, nextConditioToBeRun);
    
    % If the acquisition was completed update the acquisition information
    % and save the updated struct
    if acquisitionStatus
        subjectInfoStruct.FinalExperimentAcquisition(nextAcquisition) = 1;
        save(subjectInfoFileName, 'subjectInfoStruct');
    end
end