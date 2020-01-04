function makeTrialStructForSubjectSelection(subjectName, TrialId)

% This function makes trial structs for Case 1.
% These structs will be used for evaluating the thresholds before we
% perfrom the experiment for the other cases.
%
% subjectName = Subject Name Ex. 'Vijay'
% TrialId = trial id, Ex 3
%
% The trial struct will be saved in
% LightnessCasesForExperiment/Experiment5/Stimuli_IlluminantShapeVariation_covScaleFactor_0_00_NoReflection
%
% Vijay Singh wrote this. Dec 12 2018
% Vijay Singh modified. Feb 21 2019
% Vijay Singh modified. May 1 2019
% Vijay Singh modified. May 20 2019
% Vijay Singh modified. Jan 03 2020

nameOfTrialStruct = [subjectName,'_SelectionSessionId_',num2str(TrialId)];

makeTrialStruct('directoryName','Stimuli_IlluminantShapeVariation_covScaleFactor_0_00_NoReflection',...
    'LMSstructName', 'LMSStruct',...
    'outputFileName', nameOfTrialStruct,...
    'nBlocks', 30,...
    'stdYIndex', 6, ...
    'cmpYIndex', (1:11), ...
    'comparisionTargetSameSpectralShape',true);
