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
%    'thresholdU' : (scalar) Upper Threshold
%    'thresholdL' : (scalar) Lower Threshold
%% Get inputs and defaults.
parser = inputParser();
parser.addParameter('experimentType', 'Lightness', @ischar);
parser.addParameter('directoryName', 'ExampleCase', @ischar);
parser.addParameter('subjectName', 'testSubject', @ischar);
parser.addParameter('dateString', datestr(now,1), @ischar);
parser.addParameter('fileNumber', 1, @isscalar);
parser.addParameter('thresholdU', 0.75, @isscalar);
parser.addParameter('thresholdL', 0.25, @isscalar);
parser.parse(varargin{:});

experimentType = parser.Results.experimentType;
directoryName = parser.Results.directoryName;
subjectName = parser.Results.subjectName;
dateString = parser.Results.dateString;
fileNumber = parser.Results.fileNumber;
thresholdU = parser.Results.thresholdU;
thresholdL = parser.Results.thresholdL;

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
        totalCorrectResponse(ii) = length(numberOfCorrectResponses) - sum(numberOfCorrectResponses);
    else
        fractionCorrect(ii) = mean(numberOfCorrectResponses);
        totalCorrectResponse(ii) = sum(numberOfCorrectResponses);
    end
end

hFig = figure();
yLimits = [-0.05 1.05];
xLimits = [(min(data.trialStruct.cmpY) - min(diff(data.trialStruct.cmpY))/2) ...
    (max(data.trialStruct.cmpY)+ min(diff(data.trialStruct.cmpY))/2)];
set(hFig,'units','pixels', 'Position', [1 1 600 500]);
hold on; box on;

% plot a vertical line indicating the standard
lStdY = plot([data.trialStruct.stdY data.trialStruct.stdY], yLimits,':r','LineWidth', 1);

% Psychometric function form
PF = @PAL_CumulativeNormal;         % Alternatives: PAL_Gumbel, PAL_Weibull, PAL_CumulativeNormal, PAL_HyperbolicSecant

% paramsFree is a boolean vector that determins what parameters get
% searched over. 1: free parameter, 0: fixed parameter
paramsFree = [1 1 1 1];  

% Initial guess.  Setting the first parameter to the middle of the stimulus
% range and the second to 1 puts things into a reasonable ballpark here.
paramsValues0 = [mean(data.trialStruct.cmpY) 1/((max(data.trialStruct.cmpY)-min(data.trialStruct.cmpY))) 0 0];

lapseLimits = [0 0.05];

% Set up standard options for Palamedes search
options = PAL_minimize('options');

% Fit with Palemedes Toolbox.  The parameter constraints match the psignifit parameters above.  Some thinking is
% required to initialize the parameters sensibly.  We know that the mean of the cumulative normal should be 
% roughly within the range of the comparison stimuli, so we initialize this to the mean.  The standard deviation
% should be some moderate fraction of the range of the stimuli, so again this is used as the initializer.
xx = linspace(xLimits(1), xLimits(2),1000);

[paramsValues] = PAL_PFML_Fit(...
    data.trialStruct.cmpY',totalCorrectResponse',length(numberOfCorrectResponses)*ones(size(data.trialStruct.cmpY')), ...
    paramsValues0,paramsFree,PF, ...
    'lapseLimits',lapseLimits,'guessLimits',[],'searchOptions',options,'gammaEQlambda',true);
yy = PF(paramsValues,xx');
psePal = PF(paramsValues,0.5,'inverse');
threshPal = PF(paramsValues,0.7602,'inverse')-psePal;

text(min(data.trialStruct.cmpY),0.475,...
        ['PSE = ', num2str(psePal,3)],...
        'FontSize', 15); % Test to indicate the stimulusIntensities of 75% marker

text(min(data.trialStruct.cmpY),0.55,...
        ['Threshold = ', num2str(threshPal,3)],...
        'FontSize', 15); % Test to indicate the stimulusIntensities of 75% marker

% Plot Fit Line
lTh = plot(xx, yy, 'LineWidth', 1);

% Plot Raw Data % comparison
lData = plot(data.trialStruct.cmpY,fractionCorrect,'*');

% Indicate 75% threshold
thresholdIndex = find(yy > thresholdU, 1); % find threshold
if ~isempty(thresholdIndex)
    plot([xx(1)-1 xx(thresholdIndex)],[yy(thresholdIndex) yy(thresholdIndex)],'k'); % Horizontal line
    plot([xx(thresholdIndex) xx(thresholdIndex)],[yLimits(1) yy(thresholdIndex)],'k'); % Vertical line
    lThMk = plot(xx(thresholdIndex),yy(thresholdIndex),'.k','MarkerSize',20); % 75% co-ordiante marker
    
    text(min(data.trialStruct.cmpY),0.9,...
        ['(' num2str(xx(thresholdIndex),3) ',' num2str(round(thresholdU*100)) '%)'],...
        'FontSize', 15); % Test to indicate the stimulusIntensities of 75% marker
end
% Indicate 25% threshold
thresholdIndex = find(yy > thresholdL, 1); % find threshold
if ~isempty(thresholdIndex)
    plot([xx(1)-1 xx(thresholdIndex)],[yy(thresholdIndex) yy(thresholdIndex)],'k'); % Horizontal line
    plot([xx(thresholdIndex) xx(thresholdIndex)],[yLimits(1) yy(thresholdIndex)],'k'); % Vertical line
    lThMk = plot(xx(thresholdIndex),yy(thresholdIndex),'.k','MarkerSize',20); % 25% co-ordiante marker

    text(min(data.trialStruct.cmpY),0.4,...
        ['(' num2str(xx(thresholdIndex),3) ',' num2str(round(thresholdL*100)) '%)'],...
        'FontSize', 15); % Test to indicate the stimulusIntensities of 75% marker
end

legend([lData lTh lStdY],...
    {'Observation', 'Cum Gauss', 'Standard'},...
    'Location','Southeast');


xlabel('Comparison Lightness');
ylabel(['Fraction Comparison Chosen (N per level =',num2str(length(trialsWithThisCmpLvl)),')']);
title(sprintf('%s-%d', subjectName, fileNumber),'interpreter','none');
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