function makeTrialStructForSubjectSelection(subjectName,numberOfStructs)

% This function makes trial structs for Case 1.
% These structs will be used for evaluating the thresholds before we
% perfrom the experiment for the other cases.
%
% subjectName = Subject Name Ex. 'Vijay'
% numberOfStructs = number of trial structs required, Ex 3
% 
% The trial structs will be saved in LightnessCasesForExperiment/StimuliFixedFlatTargetShapeFixedIlluminantFixedBkGnd
% 
% Vijay Singh wrote this. Dec 12 2018

for ii = 1:numberOfStructs
    
    nameOfTrialStruct = [subjectName,'_SelectionSessionId_',num2str(ii)];
    
    makeTrialStruct('directoryName','StimuliFixedFlatTargetShapeFixedIlluminantFixedBkGnd',...
    'LMSstructName', 'LMSStruct',...
    'outputFileName', nameOfTrialStruct,...
    'nBlocks', 30,...
    'stdYIndex', 6, ...
    'cmpYIndex', (1:11), ...
    'comparisionTargetSameSpectralShape',true);
end