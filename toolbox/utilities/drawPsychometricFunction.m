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
parser.addParameter('experimentType', 'Lightness', @ischar);
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('subjectName', 'testSubject', @ischar);
parser.addParameter('dateString', datestr(now,1), @ischar);
parser.addParameter('fileNumber', 1, @isscalar);
parser.addParameter('threshold', 0.75, @isscalar);
parser.parse(varargin{:});

experimentType = parser.Results.experimentType;
directoryName = parser.Results.directoryName;
subjectName = parser.Results.subjectName;
dateString = parser.Results.dateString;
fileNumber = parser.Results.fileNumber;
threshold = parser.Results.threshold;

projectName = 'VirtualWorldPsychophysics';

%% Load the data struct
dataFolder = fullfile(getpref(projectName,'dataDir'), experimentType, directoryName, subjectName, dateString);

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
yLimits = [-0.05 1.05];
xLimits = [(min(data.trialStruct.cmpY) - min(diff(data.trialStruct.cmpY))/2) ...
    (max(data.trialStruct.cmpY)+ min(diff(data.trialStruct.cmpY))/2)];
set(hFig,'units','pixels', 'Position', [1 1 600 500]);
hold on; box on;
% plot % comparison
lData = plot(data.trialStruct.cmpY,fractionCorrect,'*');

% plot a vertical line indicating the standard
lStdY = plot([data.trialStruct.stdY data.trialStruct.stdY], yLimits,':r');

% Find the parameters for a cumulative Gaussian fit
% Initial Guesses
a = 10;
mu = data.trialStruct.stdY;
sig = 1;
guess0 = [a mu sig];
% Call fmins
ff = @(guess) fitcumgauss(guess,data.trialStruct.cmpY, fractionCorrect);
pars = fmincon(ff, guess0, [], []);
xx = linspace(xLimits(1), xLimits(2),1000);
yy = pars(1)/(pars(3)*sqrt(2*pi)) * exp( -( (xx-pars(2)).^2 ./ (2.*pars(3)).^2 ) );
yy = cumsum(yy) ./ sum(yy);

lTh = plot(xx, yy);
% Indicate threshold
thresholdIndex = find(yy > threshold, 1); % find threshold
plot([xx(1)-1 xx(thresholdIndex)],[yy(thresholdIndex) yy(thresholdIndex)],'k'); % Horizontal line
plot([xx(thresholdIndex) xx(thresholdIndex)],[yLimits(1) yy(thresholdIndex)],'k'); % Vertical line
lThMk = plot(xx(thresholdIndex),yy(thresholdIndex),'.k','MarkerSize',20); % 75% co-ordiante marker

legend([lData lTh lThMk lStdY],...
    {'Observed', 'Cum Gau Fit', [num2str(threshold*100),'% Threshold'], 'Std. Y'},...
    'Location','Southeast');

text(min(data.trialStruct.cmpY),0.9,...
    ['(' num2str(xx(thresholdIndex),3) ',' num2str(round(threshold*100)) '%)'],...
    'FontSize', 20); % Test to indicate the stimulusIntensities of 75% marker

xlabel('Comparison Lightness');
ylabel(['Fraction Comparison Chosen (N per level =',num2str(length(trialsWithThisCmpLvl)),')']);
title(sprintf('%s-%d', subjectName, fileNumber));
xlim(xLimits);
ylim(yLimits);
xticks(data.trialStruct.cmpY);
hAxis = gca;

set(hAxis,'FontSize',15);
hAxis.XTickLabelRotation = 90;

%% Save the plot and the analysis data
analysisFolder = fullfile(getpref(projectName,'analysisDir'), experimentType, directoryName, subjectName, dateString);
if ~exist(fullfile(analysisFolder,'plots'), 'dir')
    mkdir(fullfile(analysisFolder,'plots'));
end

figureFile = sprintf('%s/plots/%s-%d.pdf', analysisFolder,subjectName, fileNumber);

fprintf('\nPlot will be saved in folder:\n%s\n', figureFile);

save2pdf(figureFile, hFig, 600);
close;
end

function SSE = fitcumgauss(guess, x, y)
a = guess(1);
mu = guess(2);
sigma = guess(3);

Est = a/(sigma*sqrt(2*pi)) * exp( -( (x-mu).^2 ./ (2.*sigma).^2 ) );
Est = cumsum(Est) ./ sum(Est);
SSE = sum( (y - Est).^2 );

end