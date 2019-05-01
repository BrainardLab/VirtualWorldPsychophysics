function makeTrialStructForSubjectSelection(subjectName, TrialId)

% This function makes trial structs for Case 1.
% These structs will be used for evaluating the thresholds before we
% perfrom the experiment for the other cases.
%
% subjectName = Subject Name Ex. 'Vijay'
% TrialId = trial id, Ex 3
%
% The trial struct will be saved in LightnessCasesForExperiment/Experiment3/StimuliCondition2_covScaleFactor_1
%
% Vijay Singh wrote this. Dec 12 2018
% Vijay Singh modified. Feb 21 2019
% Vijay Singh modified. May 1 2019

nameOfTrialStruct = [subjectName,'_SelectionSessionId_',num2str(TrialId)];

makeTrialStruct('directoryName','StimuliCondition2_covScaleFactor_0_0',...
    'LMSstructName', 'LMSStruct',...
    'outputFileName', nameOfTrialStruct,...
    'nBlocks', 30,...
    'stdYIndex', 6, ...
    'cmpYIndex', (1:11), ...
    'comparisionTargetSameSpectralShape',false);
