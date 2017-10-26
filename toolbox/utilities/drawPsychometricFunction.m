function drawPsychometricFunction(varargin)
%%drawPsychometricFunction : draw psychometric function for lightness experiment
%
% Usage:
%   drawPsychometricFunction();
%
% Description:
%   Draw psychometirc function for the response of subjects for lightness
%   experiment. The function needs the directory name of case being studied,
%   the subject name and the file number. It save the plot in the analysis
%   directory specified in the pref
%
% Input:
%   None
%
% Output:
%   None
%
% Optional key/value pairs:
%    'directoryName' : (string) Directory name of the case which will be studied (default 'ExampleDirectory')
%    'subjectName' : (string) Name of subject (default 'testSubject')
%    'fileNumber' : (scalar) (default 1)

%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('subjectName', 'testSubject', @ischar);
parser.addParameter('fileNumber', 1, @isscalar);
parser.parse(varargin{:});

directoryName = parser.Results.directoryName;
subjectName = parser.Results.subjectName;
fileNumber = parser.Results.fileNumber;

projectName = 'VirtualWorldPsychophysics';

%% Load the data struct
dataFolder = fullfile(getpref(projectName,'dataDir'), directoryName, subjectName);

dataFile = sprintf('%s/%s-%d.mat', dataFolder,subjectName, fileNumber);

fprintf('\nData will be loaded from:\n%s\n', dataFile);

tempData = load(dataFile); data = tempData.data; clear tempData;

%%
for ii = 1:length(data.trialStruct.cmpY)
    trialsWithThisCmpLvl = find( data.trialStruct.cmpY(ii) == data.trialStruct.cmpYInTrial);
    numberOfCorrectResponses = (data.response.actualResponse(trialsWithThisCmpLvl) == data.response.correctResponse(trialsWithThisCmpLvl));
    if (data.trialStruct.cmpY(ii) < data.trialStruct.stdY)
        fractionCorrect(ii) = 1 - mean(numberOfCorrectResponses);
    else
        fractionCorrect(ii) = mean(numberOfCorrectResponses);
    end
end

hFig = figure();
set(hFig,'units','pixels', 'Position', [1 1 600 500]);
hold on; box on;

plot(data.trialStruct.cmpY,fractionCorrect,'*');
xlabel('Comparison Lightness');
ylabel('Fraction Comparison Chosen');
title(sprintf('%s-%d', subjectName, fileNumber));
xlim([(min(data.trialStruct.cmpY) - min(diff(data.trialStruct.cmpY))/2) ...
    (max(data.trialStruct.cmpY)+ min(diff(data.trialStruct.cmpY))/2)]);
ylim([-0.05 1.05]);
xticks(data.trialStruct.cmpY);
hAxis = gca;
set(hAxis,'FontSize',15);
hAxis.XTickLabelRotation = 90;

%% Save the plot and the analysis data
analysisFolder = fullfile(getpref(projectName,'analysisDir'), directoryName, subjectName);
if ~exist(fullfile(analysisFolder,'plots'), 'dir')
    mkdir(fullfile(analysisFolder,'plots'));
end

figureFile = sprintf('%s/plots/%s-%d.pdf', analysisFolder,subjectName, fileNumber);

fprintf('\nPlot will be saved in folder:\n%s\n', figureFile);

save2pdf(figureFile, hFig, 600);




% save(dataFile,'data','-v7.3');
% 
% pathToTrialStruct = fullfile(getpref(projectName,'stimulusInputBaseDir'),...
%     directoryName,[nameOfTrialStruct '.mat']);
% temp = load(pathToTrialStruct); trialStruct = temp.trialStruct; clear temp;
