function makeTrialStructForSubjectSelection(subjectName, TrialId)

% This function makes trial structs for Case 1.
% These structs will be used for evaluating the thresholds before we
% perfrom the experiment for the other cases.
%
% subjectName = Subject Name Ex. 'Vijay'
% TrialId = trial id, Ex 3
%
% The trial struct will be saved in LightnessCasesForExperiment/StimuliFixedFlatTargetShapeFixedIlluminantFixedBkGnd
%
% Vijay Singh wrote this. Dec 12 2018

nameOfTrialStruct = [subjectName,'_SelectionSessionId_',num2str(TrialId)];

makeTrialStruct('directoryName','StimuliFixedFlatTargetShapeFixedIlluminantFixedBkGnd',...
    'LMSstructName', 'LMSStruct',...
    'outputFileName', nameOfTrialStruct,...
    'nBlocks', 30,...
    'stdYIndex', 6, ...
    'cmpYIndex', (1:11), ...
    'comparisionTargetSameSpectralShape',true);
