function makeTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

% This function makes trial structs for all cases.
%
% subjectName = Subject Name Ex. 'Vijay'
% iterationNumber = iteration number for the condition. Ex. 2
% condition = condition name. Ex. '2a'
%
% Vijay Singh wrote this. Dec 12 2018
% Vijay Singh updated this. Feb 21 2019
% Vijay Singh updated this. May 01 2019
% Vijay Singh updated this. Jan 03 2020


nameOfTrialStruct = [subjectName,'_Condition_',condition,'_Iteration_',num2str(iterationNumber)];

switch condition

    case '_0_0_to_0_0'
        
        makeTrialStruct('directoryName','StimuliIlluminantScale_0_0_to_0_0',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',true);

    case '_0_95_to_1_05'
        
        makeTrialStruct('directoryName','StimuliIlluminantScale_0_95_to_1_05',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',true);

    case '_0_9_to_1_1'
        
        makeTrialStruct('directoryName','StimuliIlluminantScale_0_9_to_1_1',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',true);
        
	case '_0_85_to_1_15'
        makeTrialStruct('directoryName','StimuliIlluminantScale_0_85_to_1_15',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',true);
        
    case '_0_8_to_1_2'
        
        makeTrialStruct('directoryName','StimuliIlluminantScale_0_8_to_1_2',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',true);

    case '_0_75_to_1_25'
        
        makeTrialStruct('directoryName','StimuliIlluminantScale_0_75_to_1_25',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',true);

    case '_0_7_to_1_3'
        
        makeTrialStruct('directoryName','StimuliIlluminantScale_0_7_to_1_3',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',true);

    case '_0_5_to_2_0'
        makeTrialStruct('directoryName','StimuliIlluminantScale_0_5_to_2_0',...
            'LMSstructName', 'LMSStruct',...
            'outputFileName', nameOfTrialStruct,...
            'nBlocks', 30,...
            'stdYIndex', 6, ...
            'cmpYIndex', (1:11), ...
            'comparisionTargetSameSpectralShape',true);    
        
end
end