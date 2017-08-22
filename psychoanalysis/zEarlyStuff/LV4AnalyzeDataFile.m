function [dataStruct,results] = LV4AnalyzeDataFile(protocol, subject, iteration, dataSubDir)
% [dataStruct,results] = LV4AnalyzeDataFile(protocol, subject, iteration, dataSubDir)
%
% LV4AnalyzeDataFile - Analyzes a single LightnessV4 data file.
%
% Syntax:
% LV4AnalyzeDataFile(dataDir, subject, iteration)
%
% Input:
% protocol (string) - The protocol data directory.
% subject (string) - The name of the subject.
% iteration (scalar) - The iteration of the data file.  All data files are
%     appended with an integer value, use this number.
% 
% Example
%   LV4AnalyzeDataFile('pnt_rot0_shad4_blk30_cen30_vs_pnt_rot0_shad4_blk30_cen30_time1','dhb',1,'initialLightnessData); 
%
% 6/23/13  dhb  Add dataSubDir argument.

% Keep figures from accumulating
close all;

% Validate the number of inputs.
narginchk(4,4);

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
dataDir = fullfile(fileparts(fileparts(which(mfilename))), 'data', dataSubDir, '');

% Construct the data file name we want to analyze.
simpleFileName = sprintf('%s-%s-%d.mat', subject, protocol, iteration);
figFileName = sprintf('%s-%s-%d', subject, protocol, iteration);
figFileDir = fileparts(fullfile(dataDir,protocol,subject,figFileName));
fullFileName = fullfile(dataDir, protocol, subject, simpleFileName);

% Make sure the file exists.
assert(logical(exist(fullFileName, 'file')), 'LV4AnalyzeDataFile:FileNotFound', ...
	'Cannot find file: %s', fullFileName);

% Load the data.
data = load(fullFileName);

% List of different stimulus IDs used in the experiment.
stimIDs = 1:data.params.numStims;

% Pre-allocate our results matrix.
numTests = size(data.params.stimInfo(1).testIntensity, 1);
numRefs = length(data.params.stimInfo(1).refIntensity);
results = zeros(data.params.numStims, numRefs, numTests);

% Loop over each stimulus ID and aggregate the response data.  The results
% data will be stored in a 3D matrix defined as follows:
% Dim 1 - The stimulus ID.  This will be 1 or 2.
% Dim 2 - The index into the stimInfo(Dim1).refIntensity array.
% Dim 3 - The row index of stimInfo(Dim1).testIntensity(:,Dim2).
% The contents of the array will be the mean correct response for all of
% these parameters.
for sid = stimIDs
	% Find all response struct entries for the given stimulus ID.
	rStruct = data.params.responseStruct([data.params.responseStruct.stimID] == sid);
	
	for d2 = 1:numRefs
		for d3 = 1:numTests
			% We'll look for all trials using these values.
			refIntensity = data.params.stimInfo(sid).refIntensity(d2);
			testIntensity = data.params.stimInfo(sid).testIntensity(d3,d2);
			
			% Pull out the matches.
			l = ([rStruct.refIntensity] == refIntensity) & ...
				([rStruct.testIntensity] == testIntensity);
			sStruct = rStruct(l);
			
			% Loop over all the matches and see if the subject chose the
			% test probe.
			numTestSelected = 0;
 			for c = 1:length(sStruct)
				% Find where in the order the test intensity is.
				refLocation = find(sStruct(c).order == sid);
				switch refLocation
					case 1
						testLocation = LV4KeyMap.Right;
						
					case 2
						testLocation = LV4KeyMap.Left;
				end
				
				% If the test location was chosen increment our counter.
				if testLocation == sStruct(c).key
					numTestSelected = numTestSelected + 1;
				end
				
% 				% Determine which intensity was on the left and right side
% 				% based on where the reference intensity was located.
% 				if refLocation == 1
% 					leftIntensity = sStruct(c).refIntensity;
% 					rightIntensity = sStruct(c).testIntensity;
% 				else
% 					rightIntensity = sStruct(c).refIntensity;
% 					leftIntensity = sStruct(c).testIntensity;
% 				end
% 				
% 				% Figure out if the subject made the right choice.  In the
% 				% event the 2 intensities are the same, we'll flip a coin
% 				% to see if they're correct.  The right choice means the
% 				% subject chose the ligher probe.
% 				if rightIntensity == leftIntensity
% 					numCorrect = numCorrect + CoinFlip(1, 0.5);
% 				else
% 					switch sStruct(c).key
% 						case LV4KeyMap.Right
% 							if rightIntensity > leftIntensity
% 								numCorrect = numCorrect + 1;
% 							end
% 							
% 						case LV4KeyMap.Left
% 							if leftIntensity > rightIntensity
% 								numCorrect = numCorrect + 1;
% 							end
% 					end
% 				end
 			end
			
			% Store the mean higher response.
			results(sid, d2, d3) = numTestSelected / length(sStruct);
		end
	end
end

% The following plots use the 'results' matrix, indexing values out using
% the following guide (as noted above also)
% Dim 1 - The stimulus ID.  This will be 1 or 2.
% Dim 2 - The index into the stimInfo(Dim1).refIntensity array.
% Dim 3 - The row index of stimInfo(Dim1).testIntensity(:,Dim2).

% Make a plot of the probability of picking the test stimuli for stimulus
% 1's 1st reference intensity.
theFig = figure; clf;
set(theFig,'Position',[1000 650 820 680]);
nStims = size(results,1);
nRefs = size(results,2);
figIndex = 1;
for stimID = 1:size(results,1)
    for refIndex = 1:size(results,2)
        refIntensity = data.params.stimInfo(stimID).refIntensity(refIndex);
        testIntensities = data.params.stimInfo(stimID).testIntensity(:, refIndex)';
        probs = squeeze(results(stimID, refIndex, :));
        subplot(nStims,nRefs,figIndex); hold on
        plot(testIntensities, probs, 'ro','MarkerSize',8,'MarkerFaceColor','r');
        [~,interpStimuli,pInterp,pse,loc25,loc75] = FitPsychometricData(testIntensities',probs*length(sStruct),ones(size(probs))*length(sStruct));
        plot(interpStimuli,pInterp, 'r');
        plot([refIntensity refIntensity],[0 0.1],'r','LineWidth',2);
        plot([loc25 loc75],[0.05 0.05],'g','LineWidth',3);
        plot([pse pse],[0 0.1],'g','LineWidth',3);
        xlabel('Test Intensity','FontSize',12);
        ylabel('Probability Test Brighter','FontSize',12);
        title(sprintf('Ref in image %d, intensity: %0.2f', stimID, refIntensity));
        axis([0 1 0 1]);
        
        % Return key data, with image1 defined as reference context
        if (stimID == 1)
             dataStruct(figIndex).whichFixed = 1;
             dataStruct(figIndex).refIntensity = refIntensity; 
             dataStruct(figIndex).testIntensity = pse;       
        elseif (stimID == 2)
            dataStruct(figIndex).whichFixed = 2;
             dataStruct(figIndex).refIntensity = pse;
             dataStruct(figIndex).testIntensity = refIntensity;
        else
            error('This code assumes only two contextual images.');
        end
       
        % Bump counter
        figIndex = figIndex + 1; 
    end
end

% Add title 
[~,h] = suplabel(LiteralUnderscore([protocol ', ' subject]),'t');
set(h,'FontSize',14);

% Save the plot and close the figure
curDir = pwd;
cd(figFileDir);
savefig(figFileName,theFig,'pdf');
cd(curDir);
close(theFig);
