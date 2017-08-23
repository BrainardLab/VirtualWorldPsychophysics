function [dataStruct] = LV4AnalyzeStaircaseDataFile(protocol, subject, iteration, dataSubDir)
% [dataStruct] = LV4AnalyzeStaircaseDataFile(protocol, subject, iteration, dataDir)
%
% LV4AnalyzeStaircaseDataFile - Analyzes a single LightnessV4 staircase data file.
%
% Syntax:
% LV4AnalyzeStaircaseDataFile(dataDir, subject, iteration)
%
% Input:
% protocol (string) - The protocol data directory.
% subject (string) - The name of the subject.
% iteration (scalar) - The iteration of the data file.  All data files are
%     appended with an integer value, use this number.
% dataSubDir - Path to top level data directory subdir
%
% The location of the stimuli is hardcoded, because we moved them after
% most of the data for the early conditions (to which this file applies)
% were collected.
%
% Example
%   LV4AnalyzeStaircaseDataFile('sc_pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_t1','test',1,'initialStaircaseData');

% Keep figures from accumulating
close all;

% Validate the number of inputs.
% narginchk(4,4);

% Dynamically add the program code to the path if it isn't already on it.
% We do this so we have access to the enumeration classes for this
% experiment.
codeDir = fullfile(fileparts(fileparts(which(mfilename))), 'code');
if isempty(strfind(path, codeDir))
    fprintf('- Adding %s dynamically to the path...', mfilename);
    addpath(RemoveSVNPaths(genpath(codeDir)), '-end');
    fprintf('Done\n');
end

% Figure out where the top level data directory is.
dataDir = fullfile(fileparts(fileparts(which(mfilename))), 'data', dataSubDir);

% Construct the data file name we want to analyze.
simpleFileName = sprintf('%s-%s-%d.mat', subject, protocol, iteration);
figFileName = sprintf('%s-%s-%d', subject, protocol, iteration);
figFileDir = fileparts(fullfile(dataDir,protocol,subject,figFileName));
fullFileName = fullfile(dataDir, protocol, subject, simpleFileName);

% Make sure the file exists.
assert(logical(exist(fullFileName, 'file')), 'LV4AnalyzeStaircaseDataFile:FileNotFound', ...
    'Cannot find file: %s', fullFileName);

% Load the data.
data = load(fullFileName);

% Regenerate the staircase objects found in data.params
UseClassesDev;
[M, N] = size(data.params.st);
for row = 1:M
    for col = 1:N
        % Generate dummy object
        newObject = Staircase('standard', 0, 'StepSizes', [0 0 0 0], 'NUp', 0, 'NDown', 0);
        
        % Reload it with values found in data.params.st{row,col}
        newObject = loadObject(newObject, data.params.st{row,col});
        data.params.st{row,col} = newObject;
    end
end

% Report some facts about the images


% Extract data
nStimTypes = size(data.params.st,1);
nInterleavedStaircases = size(data.params.st,2);
numTrialsPerStaircase = data.params.numTrialsPerStaircase;

% Get some statistics on the contextual images.  This loads in the blank image
% computes on it.
for i = 1:data.params.numStims
    fprintf('\n\tImage %d, %s\n',i,data.params.stimInfo(i).imageName);
    data.params.stimuliDir = '/Users1/Shared/Matlab/Experiments/LightnessV4/stimuli';
    fileName = fullfile(data.params.stimuliDir, dataSubDir, [data.params.stimInfo(i).imageName '.mat']);
    imageData = load(fileName);
    
    % Get image data
    meanImageValue = mean(mean(imageData.theImage));
    meanProbeLocationValue = mean(mean(imageData.theImage(imageData.probeIndex)));
    temp = imageData.theImage;
    temp(imageData.probeIndex) = NaN;
    meanNotProbeLocationValue = nanmean(nanmean(temp));
    fprintf('\tImage size = %d (h) by %d (v) pixels\n',size(imageData.theImage,2),size(imageData.theImage,1));
    fprintf('\tNumber of probe pixels = %d\n',length(imageData.probeIndex));
    fprintf('\tImage mean = %0.3f, probe location mean = %0.3f, not probe location mean = %0.3f\n',meanImageValue,meanProbeLocationValue,meanNotProbeLocationValue);
    fprintf('\tSpecified blank color = %0.3f\n',imageData.blankcolor);
end
    
% Figure.  Trials where comparison was judged lighter are plotted as
% solid symbols, and where it was judged darker as open symbols.
% Different staircases are plotted in different colors.
colors = ['r' 'g' 'b' 'k' 'y' 'c'];
psychoFig = figure;
set(psychoFig,'Position',[697 236 1700 1050]);
nPlotRows = 2;
nPlotCols = nStimTypes/nPlotRows;
for s = 1:nStimTypes
    valuesStair{s} = [];
    responsesStair{s} = [];
    stairFig = figure; clf;
    stimID(s) = data.params.stimBlock(s).stimID;
    refIntensity(s) = data.params.stimBlock(s).refIntensity;
    for k = 1:nInterleavedStaircases
        pseStair(s,k) = getThresholdEstimate(data.params.st{s,k});
        [valuesSingleStair{s,k},responsesSingleStair{s,k}] = getTrials(data.params.st{s,k});
        
        % Note that the pse's extracted from the staircase are pretty close to
        % their simulated value (which here is zero and indicated by a horizontal
        % black line in the plot).
        subplot(nInterleavedStaircases,1,k); hold on
        xvalues = 1:numTrialsPerStaircase;
        plot(xvalues,zeros(size(xvalues)),'k','LineWidth',2);
        index = find(responsesSingleStair{s,k} == 0);
        plot(xvalues,valuesSingleStair{s,k},[colors(k) '-']);
        plot(xvalues,valuesSingleStair{s,k},[colors(k) 'o'],'MarkerFaceColor',colors(k),'MarkerSize',6);
        if (~isempty(index))
            plot(xvalues(index),valuesSingleStair{s,k}(index),[colors(k) 'o'],'MarkerFaceColor','w','MarkerSize',6);
        end
        plot(xvalues,pseStair(s,k)*ones(1,numTrialsPerStaircase),colors(k));
        
        xlabel('Trial Number','FontSize',16);
        ylabel('Level','FontSize',16);
        ylim([0 1]);
        title(sprintf('Staircase plot %d, %d, stimID = %d, refIntensity = %0.2f',s,k,stimID(s),refIntensity(s)),'FontSize',16);
        valuesStair{s} = [valuesStair{s} valuesSingleStair{s,k}];
        responsesStair{s} = [responsesStair{s} responsesSingleStair{s,k}];
    end
    
    % Fit psychometric function
    [~,interpStimuli{s},pInterp{s},pse(s),loc25(s),loc75(s)] = FitPsychometricData(valuesStair{s}',responsesStair{s}',ones(size(responsesStair{s}')));

    % Aggregated trials
    [meanValues{s},nAbove{s},nTrials{s}] = GetAggregatedStairTrials(valuesStair{s},responsesStair{s},5);
    figure(psychoFig);
    subplot(nPlotRows,nPlotCols,s); hold on
    plot(meanValues{s},nAbove{s}./nTrials{s},'ro','MarkerSize',8,'MarkerFaceColor','r');
    plot(interpStimuli{s},pInterp{s}, 'r');
    plot([refIntensity(s) refIntensity(s)],[0 0.1],'r','LineWidth',2);
    plot([loc25(s) loc75(s)],[0.05 0.05],'g','LineWidth',3);
    plot([pse(s) pse(s)],[0 0.1],'g','LineWidth',3);
    xlabel('Test Intensity');
    ylabel('Fraction Judged Lighter');
    title(sprintf('stimID = %d, refIntensity = %0.2f',stimID(s),refIntensity(s)),'FontSize',14);
    xlim([0 1]);
    ylim([0 1]);
    
    % Return key data, with image1 defined as reference context
    if (stimID(s) == 1)
        dataStruct(s).whichFixed = 1;
        dataStruct(s).refIntensity = refIntensity(s);
        dataStruct(s).testIntensity = pse(s);
    elseif (stimID(s) == 2)
        dataStruct(s).whichFixed = 2;
        dataStruct(s).refIntensity = pse(s);
        dataStruct(s).testIntensity = refIntensity(s);
    else
        error('This code assumes only two contextual images.');
    end
end

% Add title
[~,h] = suplabel(LiteralUnderscore([protocol ', ' subject ', ' num2str(iteration)]),'t');
set(h,'FontSize',14);

% Save the plot and close the figure
curDir = pwd;
cd(figFileDir);
savefig(figFileName,psychoFig,'pdf');
savefig(figFileName,psychoFig,'png');
cd(curDir);
close(psychoFig);

% Close all figs.  Comment out to look at
% staircase plots.
close all;

end



