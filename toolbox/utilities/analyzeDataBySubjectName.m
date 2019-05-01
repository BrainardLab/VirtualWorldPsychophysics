function analyzeDataBySubjectName(subjectName)
%function analyzeDataBySubjectName(subjectName)
%
% Example: analyzeDataBySubjectName('CNSU_0001')
% This function analyzes the data collected for a subject.
% The subject information is recovered from 'subjectName.mat' in the folder
% /Users/vijaysingh/Dropbox (Aguirre-Brainard Lab)/CNST_materials/
% VirtualWorldPsychophysics/data/SubjectInformation.
%
% Input:
%   subjectName : The subject pseudo-name. String. Example: 'CNSU_0000'
%
% Output:
%   None
%
% The figures are saved in Analysis/Lightness/subjectName
%
% Vijay Singh wrote this Jan 03 2019
% Vijay Singh modified May 01 2019

%% Load the struct with subject information
subjectInfoFileName = fullfile(getpref('VirtualWorldPsychophysics','dataDir'),'SubjectInformation',[subjectName,'.mat']);
subjectInfoStruct = load(subjectInfoFileName);
subjectInfoStruct = subjectInfoStruct.subjectInfoStruct;

criteria = 0.025; % The threshold criteria for subject selection.

%% Subject selection analysis
% For do the analysis to find out if the subject can be used for the rest
% of the experiment
%
if (subjectInfoStruct.SelectionTrialFinished(3))
    
% Find thresholds
iterCond = 1;
for iterTrial = 1:3
    thresholds = drawPsychometricFunction('ExperimentType', 'Lightness',...
        'directoryName', 'StimuliCondition2_covScaleFactor_0_0', ...
        'subjectName', [subjectName,'_SelectionSessionId_',num2str(iterTrial)], ...
        'date', char(subjectInfoStruct.SelectionTrialDate(iterTrial)), ...
        'fileNumber', 1,...
        'thresholdU', 0.75, ...
        'thresholdL', 0.25);
%     U(iterTrial) = thresholds.U;
%     L(iterTrial) = thresholds.L;
%     PSE(iterTrial) = thresholds.PSE;
    threshold(iterTrial) = thresholds.threshold;
%     fractionCorrect(iterTrial,:) = thresholds.fractionCorrect;
%     stimPerLevel(iterTrial,:) = thresholds.stimPerLevel;
%     cmpY(iterTrial,:) = thresholds.cmpY;
end

% Display if the crietria is met or not.
display(['The thresholds for the first conditions are  ', ...
    num2str(threshold(1),'%0.3f'),',  ', num2str(threshold(2),'%0.3f'),' and  ', num2str(threshold(3),'%0.3f')]);
if(mean(threshold(2:3) < criteria))
    display('The mean threshold for last two trials is LOWER than the criteria.');
else
    display('The mean threshold for last two trials is HIGHER than the criteria.');
end

else
    display('All subject selection trials have not been finished.')
end

%% Final Analysis

if (subjectInfoStruct.FinalExperimentAcquisition(15))

condition_0_0.directoryName = 'StimuliCondition2_covScaleFactor_0_0';
condition_0_01.directoryName = 'StimuliCondition2_covScaleFactor_0_01';
condition_0_05.directoryName = 'StimuliCondition2_covScaleFactor_0_05';
condition_0_1.directoryName = 'StimuliCondition2_covScaleFactor_0_1';
condition_0_5.directoryName = 'StimuliCondition2_covScaleFactor_0_5';
condition_1.directoryName = 'StimuliCondition2_covScaleFactor_1';
% condition5.directoryName = 'StimuliCondition2_covScaleFactor_5';
% condition10.directoryName = 'StimuliCondition2_covScaleFactor_10';

nConditions = 6;
threshold = zeros(nConditions,3);

for iterTrial = 1:3
    for iterCond = 1:nConditions
        whichCondition = subjectInfoStruct.FinalExperimentOrder((iterTrial-1)*5 + iterCond);
        condition = eval(['condition_', char(whichCondition)]);
        thresholds = drawPsychometricFunction('ExperimentType', 'Lightness',...
            'directoryName', condition.directoryName, ...
            'subjectName', [subjectName,'_Condition_',char(whichCondition),'_Iteration_',num2str(iterTrial)], ...
            'date', char(subjectInfoStruct.FinalExperimentDate((iterTrial-1)*5 + iterCond)), ...
            'fileNumber', 1,...
            'thresholdU', 0.75, ...
            'thresholdL', 0.25);
%         U(iterTrial) = thresholds.U;
%         L(iterTrial) = thresholds.L;
%         PSE(iterTrial) = thresholds.PSE;
        switch char(whichCondition)
            case '0_0'
                threshold(1, iterTrial) = thresholds.threshold;
            case '0_01'
                threshold(2, iterTrial) = thresholds.threshold;
            case '0_05'
                threshold(3, iterTrial) = thresholds.threshold;
            case '0_1'
                threshold(4, iterTrial) = thresholds.threshold;
            case '0_5'
                threshold(5, iterTrial) = thresholds.threshold;
            case '1'
                threshold(6, iterTrial) = thresholds.threshold;
        end
        
%         fractionCorrect(iterTrial,:) = thresholds.fractionCorrect;
%         stimPerLevel(iterTrial,:) = thresholds.stimPerLevel;
%         cmpY(iterTrial,:) = thresholds.cmpY;
    end
end

%% Plot thresholds for the five conditions and save the plot
meanthreshold = mean(threshold');
SEMthreshold = std(threshold')/sqrt(size(threshold,2));
errorbar([1 2 3 4 5], meanthreshold, SEMthreshold);
hold on;box on;
axis square;
xlim([0.5 5.5]);
ylim([-0.005 0.08]);
xlabel('Covariance Scale Factor');
ylabel('');
xticks([1:5])
xticklabels({'0.0', '0.01', '0.05', '0.1', '0.5', '1'});
l = legend({'Threshold (Mean +/- SEM)'}, 'location', 'best', 'fontsize',15);
l.Position = [    0.2301    0.7920    0.3893    0.1012];
title([subjectName,' Thresholds'],'interpreter','latex');
set(gca,'FontSize',20);

pathToFolder = fullfile(getpref('VirtualWorldPsychophysics','analysisDir'),'Lightness','SubjectThresholdsSummary',subjectName);
if ~(exist(pathToFolder))
    mkdir(pathToFolder)
end

save2pdf(fullfile(pathToFolder,[subjectName,'.pdf']),gcf,600);
close all;

else
    display(['All 18 acquisitions have not been finished. Remaining acquisitions = ',num2str(18 - length(find(subjectInfoStruct.FinalExperimentAcquisition)))]);
end

end

