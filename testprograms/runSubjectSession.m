function runSubjectSession(subjectName)
%function runSubjectSession(subjectName)
% This function runs the session for a subject given the subject name. The
% subject name has to be provided as a string.
% The information will be stored in 
% /Users/vijaysingh/Dropbox (Aguirre-Brainard Lab)/CNST_materials/VirtualWorldPsychophysics/data/SubjectInformation


% Intialize the computer to and put VirtualWorldPsychophysics on MATLAB
% path.
% startup;
% tbUseProject('VirtualWorldPsychophysics', 'reset', 'full');

numberOfSubjectSelectionAcquisitions = 3;
numberOfExperimentIterations = 3;
numberOfConditions = 5;
ConditionNames = {'1', '2', '2a', '3', '3a'};

subjectInfoFileName = fullfile(getpref('VirtualWorldPsychophysics','dataDir'),'SubjectInformation',[subjectName,'.mat']);
if exist(subjectInfoFileName)
    load(subjectInfoFileName);
else
    subjectInfoStruct = struct();
    subjectInfoStruct.Name = subjectName;
    subjectInfoStruct.SelectionTrialFinished = zeros(1,numberOfSubjectSelectionAcquisitions);
    subjectInfoStruct.FinalExperimentAcquisition = zeros(1,numberOfExperimentIterations*numberOfConditions);
    subjectInfoStruct.FinalExperimentOrder = [ConditionNames(randperm(5)) ConditionNames(randperm(5)) ConditionNames(randperm(5))];
end

% if max(subjectInfoFileName.SelectionTrialFinished == 0)
%     makeTrialStructForSubjectSelection(subjectName,numberOfSubjectSelectionAcquisitions);
% end

%% Find out which session needs to be run
nextSubjectSelectionTrial = min(find(subjectInfoStruct.SelectionTrialFinished == 0));
nextAcquisition = min(find(subjectInfoStruct.FinalExperimentAcquisition == 0));

% If subject selection acquisition are left. First finish those acquisition.
if nextSubjectSelectionTrial < (numberOfSubjectSelectionAcquisitions+1)
    %Make the trial struct
    makeTrialStructForSubjectSelection(subjectName,nextSubjectSelectionTrial);
    % Run the acquisition   
    runSubjectSelectionSession(subjectName, nextSubjectSelectionTrial);
    % Update acquisition information
    subjectInfoStruct.SelectionTrialFinished(nextSubjectSelectionTrial) = 1;
    save(subjectInfoFileName, 'subjectInfoStruct');
else
    % Iteration number
    iterationNumber = ceil(nextAcquisition/numberOfConditions);
    % Condition
    nextConditioToBeRun = char(subjectInfoStruct.FinalExperimentOrder(nextAcquisition));
    % Make the required trial struct for this condition
    makeTrialStructForFinalExperiment(subjectName, iterationNumber, nextConditioToBeRun);
    % Run this trial struct
    runSession(subjectName, iterationNumber, nextConditioToBeRun);
    
    % update subject info and save
    subjectInfoStruct.FinalExperimentAcquisition(nextAcquisition) = 1;
    save(subjectInfoFileName, 'subjectInfoStruct');
end