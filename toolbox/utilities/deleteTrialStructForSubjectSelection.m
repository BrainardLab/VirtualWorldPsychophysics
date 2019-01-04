function deleteTrialStructForSubjectSelection(subjectName, TrialId)

% This function deletes the trial structs for Case 1.
%
% subjectName = Subject Name Ex. 'Vijay'
% TrialId = trial id, Ex 3
%
% Vijay Singh wrote this. Jan 04 2019

nameOfTrialStruct = [subjectName,'_SelectionSessionId_',num2str(TrialId)];

pathToTrialStruct = fullfile(getpref('VirtualWorldPsychophysics','stimulusInputBaseDir'),...
                            'StimuliFixedFlatTargetShapeFixedIlluminantFixedBkGnd',[nameOfTrialStruct '.mat']);
delete(pathToTrialStruct);