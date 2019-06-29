function makeTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

% This function makes trial structs for all cases.
%
% subjectName = Subject Name Ex. 'Vijay'
% iterationNumber = iteration number for the condition. Ex. 2
% condition = condition name. Ex. '2a'
%
% Vijay Singh wrote this. Dec 12 2018
% Vijay Singh updated this. Feb 21 2019
% Vijay Singh updated this. May 1 2019
% Vijay Singh updated this. June 29 2019


nameOfTrialStruct = [subjectName,'_Condition_',condition,'_Iteration_',num2str(iterationNumber)];

switch condition

    case '0_00'
        
        makeTrialStruct('directoryName','Radius_0_00',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',false);

    case '0_10'
        
        makeTrialStruct('directoryName','Radius_0_10',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',false);

        case '0_25'
        
        makeTrialStruct('directoryName','Radius_0_25',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',false);

        case '0_40'
        
        makeTrialStruct('directoryName','Radius_0_40',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',false);

        case '0_55'
        
        makeTrialStruct('directoryName','Radius_0_55',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',false);
        
end
end