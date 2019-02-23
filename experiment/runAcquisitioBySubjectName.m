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
% Vijay Singh updated this Feb 21 2019

% Some information about the experiment
numberOfSubjectSelectionAcquisitions = 3;
numberOfExperimentIterations = 3;
numberOfConditions = 5;
ConditionNames = {'0_1', '0_5', '1', '5', '10'};

scaleFactor = 4.9; % This scale factor is determined using the function
                   % findScaleFactor(cal, LMSStruct). For all images that
                   % are displayed in one experiment the scale factor
                   % should be the same. In our case there are 5
                   % conditions. The scale factor for condition 5 is the
                   % lowest (4.5460) and for condition 1 is the highest 
                   % (9.6869). We have chosen the scale factor a little 
                   % lower than Condition 5.

% Check for the file with the information about this subject's acquisitons
subjectInfoFileName = fullfile(getpref('VirtualWorldPsychophysics','dataDir'),'SubjectInformation',[subjectName,'.mat']);
if exist(subjectInfoFileName,'file')
    load(subjectInfoFileName);
else
    % If the file does not exist make the corresponding struct
    subjectInfoStruct = struct();
    subjectInfoStruct.Name = subjectName;
    subjectInfoStruct.DemoFinished = 0;
    subjectInfoStruct.SelectionTrialFinished = zeros(1,numberOfSubjectSelectionAcquisitions);
    subjectInfoStruct.SelectionTrialDate = cell(1,numberOfSubjectSelectionAcquisitions);
    subjectInfoStruct.FinalExperimentAcquisition = zeros(1,numberOfExperimentIterations*numberOfConditions);
    subjectInfoStruct.FinalExperimentOrder = [ConditionNames(randperm(5)) ConditionNames(randperm(5)) ConditionNames(randperm(5))];
    subjectInfoStruct.FinalExperimentDate = cell(1,numberOfExperimentIterations*numberOfConditions);
end

%% If the demosession has not been run yet, run the demo session
if ~subjectInfoStruct.DemoFinished
    
    % Run  demo 
    runLightnessExperiment('directoryName', 'StimuliCondition2_covScaleFactor_1',...
        'nameOfTrialStruct', 'demoTrialStruct', ...
        'controlSignal', 'gamePad', ...
        'interval1Key', 'GP:UpperLeftTrigger', ...
        'interval2Key', 'GP:UpperRightTrigger', ...
        'feedback', 1, ...
        'subjectName', 'demoTrialStruct', ...
        'isDemo', 1, ...
        'scaleFactor', scaleFactor);
    
    subjectInfoStruct.DemoFinished = 1;
    save(subjectInfoFileName, 'subjectInfoStruct');
    
else
    
    %% Find out which session needs to be run
    nextSubjectSelectionTrial = find(subjectInfoStruct.SelectionTrialFinished == 0, 1);
    nextAcquisition = find(subjectInfoStruct.FinalExperimentAcquisition == 0, 1);
    
    % If subject selection acquisition are left. First finish those acquisition.
    if nextSubjectSelectionTrial < (numberOfSubjectSelectionAcquisitions+1)
        %Make the trial struct
        makeTrialStructForSubjectSelection(subjectName,nextSubjectSelectionTrial);
        % Run the acquisition
        acquisitionStatus = runSubjectSelectionAcquisition(subjectName, nextSubjectSelectionTrial, scaleFactor);
        
        % If the acquisition was completed update the acquisition information
        % and save the updated struct
        if acquisitionStatus
            subjectInfoStruct.SelectionTrialFinished(nextSubjectSelectionTrial) = 1;
            subjectInfoStruct.SelectionTrialDate{nextSubjectSelectionTrial} = date;
            save(subjectInfoFileName, 'subjectInfoStruct');
        end
        deleteTrialStructForSubjectSelection(subjectName, nextSubjectSelectionTrial)
    else
        % Iteration number
        iterationNumber = ceil(nextAcquisition/numberOfConditions);
        % Condition
        nextConditioToBeRun = char(subjectInfoStruct.FinalExperimentOrder(nextAcquisition));
        % Make the required trial struct for this condition
        makeTrialStructForFinalExperiment(subjectName, iterationNumber, nextConditioToBeRun);
        % Run this trial struct
        acquisitionStatus = runAcquisition(subjectName, iterationNumber, nextConditioToBeRun, scaleFactor);
        
        % If the acquisition was completed update the acquisition information
        % and save the updated struct
        if acquisitionStatus
            subjectInfoStruct.FinalExperimentAcquisition(nextAcquisition) = 1;
            subjectInfoStruct.FinalExperimentDate{nextAcquisition} = date;
            save(subjectInfoFileName, 'subjectInfoStruct');
        end
        deleteTrialStructForFinalExperiment(subjectName,iterationNumber, nextConditioToBeRun)
    end
    % Send email to Vijay when experiment finishes.
    SendEmail('vsin@sas.upenn.edu', 'experimentFinished', 'experimentFinished');
end
end