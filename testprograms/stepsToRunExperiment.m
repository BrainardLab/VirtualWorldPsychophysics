%% Steps to run experiment
% These are the steps to run the experiment

%% Computer setting
% 1. Switch on the monitor
% 2. Set path preferences 
startup;
tbUseProject('VirtualWorldPsychophysics', 'reset', 'full');

%% Make subject selection trial struct
subjectName = 'Vijay';

makeTrialStructForSubjectSelection(subjectName,3);

%% Run subject selection session
% This has to be run three times once for each trial

TrialId = 1;
runSubjectSelectionSession(subjectName, TrialId)

% If you don't see a screen with some text in red on the monitor, quit.
% To quit: press 'q' and 'y' on the keyboard and try again.

%% Make final trial for the session
% Update the subject name as needed
% Generate and store random sequence using randperm(3) in the file 
% ConditionNames = {'1', '2', '2a', '3', '3a'}
% ConditionNames(randperm(5))
% VirtualWorldPsychophysics/data/SubjectInformation/SequenceForExperiment

iterationNumber = 2;
condition = '3a';    % Condition number according to the random sequence for this session
makeTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

%% Run Session
% 
% Run the three conditions for this session according to the random sequence

runSession(subjectName, iterationNumber, condition);