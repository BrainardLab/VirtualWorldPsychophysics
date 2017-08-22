function stimBlock = LV4CreateStimBlock(stimInfo, stimBlockType)
% LV4CreateStimBlock - Creates trial stimulus info for 1 block.
%
% Syntax:
% stimBlock = LV4CreateStimBlock(stimInfo, stimBlockType)
%
% Description:
% A given block of the LightnessV4 experiment consists of all combinations
% of the stimulus parameters for each stimulus defined in 'stimInfo'.  This
% function takes the stimulus info and creates a matrix where each column
% defines the stimuls parameters for a given trial.
%
% Input:
% stimInfo (1xN struct) - The stimulus info struct array returned by
%     LV4ParseStimDefs.
% stimBlockType (LV4StimBlockType) - Enumeration defining the type of
%     stimlus block we're generating.
%
% Output:
% stimBlock (1xP struct) - Struct where each element represents the
%     stimulus info needed for 1 trial of 1 block of the experiment.  The
%     fields of the struct are as follows:
%     
%     stimID - This is the index of the stimulus as defined in the stimulus
%         definition CSV file.
%     order - The order in which the stimulus images are drawn on the
%         screen.
%     refIntensity - The intensity of the reference probe.
%     testIntensity - The intensity of the test probe.
%
% For the CrossStaircase type, the order and testIntensity are set to -1, and
% different l/r orderings of the same two stimuli are pruned from the returned
% block list.

narginchk(2, 2);

numStims = length(stimInfo);

switch stimBlockType
	case LV4StimBlockType.CrossAll
		% Loop over all the stimuli and create a single blocks worth of trial
		% stimulus specifications.
		blockData = [];
		for i = 1:numStims
			% Create all combinations of the order of stimuli displayed on the
			% screen.
			orderPerms = perms(1:numStims)';
			
			% All combinations of test and reference intensities.
			iCombinations = combvec(stimInfo(i).refIntensity, stimInfo(i).testIntensity);
			
			% Combine all our parameters and append to the stimBlock matrix.
			blockData = [blockData, combvec(i, orderPerms, iCombinations)];
		end
		
		% To make things more readable, we're going to reformat the stim block data
		% into a struct array where parameters are labeled.
		for i = 1:size(blockData, 2)
			o = 2 + numStims - 1;
			stimBlock(i).stimID = blockData(1,i); %#ok<*AGROW>
			stimBlock(i).order = blockData(2:o,i)';
			stimBlock(i).refIntensity = blockData(o+1,i);
			stimBlock(i).testIntensity = blockData(o+2,i);
		end
		
	case LV4StimBlockType.CrossSome
		% Loop over all the stimuli and create a single blocks worth of trial
		% stimulus specifications.
		blockData = [];
		for i = 1:numStims
			% Create all combinations of the order of stimuli displayed on the
			% screen.
			orderPerms = perms(1:numStims)';
		
			iCombinations = [];
			for j = 1:length(stimInfo(i).refIntensity)
				iCombinations = [iCombinations, combvec(stimInfo(i).refIntensity(j), stimInfo(i).testIntensity(:,j)')];
				%iCombinations = combvec(stimInfo(i).refIntensity, stimInfo(i).testIntensity);
			end
			
			% Combine all our parameters and append to the stimBlock matrix.
			blockData = [blockData, combvec(i, orderPerms, iCombinations)];
		end
		
		% To make things more readable, we're going to reformat the stim block data
		% into a struct array where parameters are labeled.
		for i = 1:size(blockData, 2)
			o = 2 + numStims - 1;
			stimBlock(i).stimID = blockData(1,i); %#ok<*AGROW>
			stimBlock(i).order = blockData(2:o,i)';
			stimBlock(i).refIntensity = blockData(o+1,i);
			stimBlock(i).testIntensity = blockData(o+2,i);
        end
        
    case LV4StimBlockType.CrossStaircase
		% Loop over all the stimuli and create a single blocks worth of trial
		% stimulus specifications.
		blockData = [];
		for i = 1:numStims
			% Create all combinations of the order of stimuli displayed on the
			% screen.
			orderPerms = -1*ones(size(perms(1:numStims)'));
		
			iCombinations = [];
			for j = 1:length(stimInfo(i).refIntensity)
				iCombinations = [iCombinations, combvec(stimInfo(i).refIntensity(j),-1)];
				%iCombinations = combvec(stimInfo(i).refIntensity, stimInfo(i).testIntensity);
			end
			
			% Combine all our parameters and append to the stimBlock matrix.
			blockData = [blockData, combvec(i, orderPerms, iCombinations)];
		end
		
		% To make things more readable, we're going to reformat the stim block data
		% into a struct array where parameters are labeled.
		for i = 1:size(blockData, 2)
			o = 2 + numStims - 1;
			stimBlock(i).stimID = blockData(1,i); %#ok<*AGROW>
			stimBlock(i).order = blockData(2:o,i)';
			stimBlock(i).refIntensity = blockData(o+1,i);
			stimBlock(i).testIntensity = blockData(o+2,i);
        end
		
        % Get rid of duplicates wrt to left-right order, a parameter that we don't
        % use in the staircase method.
        temp = [[stimBlock.stimID] ; [stimBlock.refIntensity] ];
        [temp1,ia] = unique(temp','rows');
        stimBlock = stimBlock(ia);
	otherwise
		error('Invalid stim block type, see LV4StimBlockTypes');
end
