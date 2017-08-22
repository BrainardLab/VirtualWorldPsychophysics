function stimInfo = LV4ParseStimDef(fileName, stimBlockType)
% LV4ParseStimDef - Parses a stimulus definition file.
%
% Syntax:
% stimInfo = LV4ParseStimDef(fileName)
%
% Description:
% A stimulus definition file defines the image name, reference intensities,
% and test intensities for all stimuli in an experiment.  The file is
% formatted as a CSV.  This function reads that CSV file in and creates a
% struct array where each element contains the information for 1 stimulus.
%
% Input:
% fileName (string) - The CSV file name.
% stimBlockType (LV4StimBlockType) - This determines how we parse the
%     stimuli definition file.  See LV4StimBlockTypes.m for more info.
%
% Output:
% stimInfo (1xN struct) - The stimuli definitions.

error(nargchk(2, 2, nargin));

% Read the CSV file.
csvObj = CSVFile(fileName);

% Get a list of the headers in the file.
columnHeaders = csvObj.getColumnHeaders;

% Determine the number of stimuli by finding all the columns that begin
% with "image".
numStimuli = 0;
s = strfind(columnHeaders, 'image');
for i = 1:length(s)
    if ~isempty(s{i})
        numStimuli = numStimuli + 1;
    end
end

% Extract the data for each stimulus.
for i = 1:numStimuli
    % Grab the image name.
    stimInfo(i).imageDir = removeEmpties(csvObj.getColumnData(sprintf('dir%d', i))); %#ok<*AGROW>
    stimInfo(i).imageBase = removeEmpties(csvObj.getColumnData(sprintf('image%d', i))); %#ok<*AGROW>
    stimInfo(i).imageName = fullfile(stimInfo(i).imageDir{1},stimInfo(i).imageBase{1}); %#ok<*AGROW>
    
    switch stimBlockType
        case LV4StimBlockType.CrossAll
            % Pull out the reference and test intensities.
            stimInfo(i).refIntensity = removeEmpties(csvObj.getColumnData(sprintf('refIntensity%d', i)));
            stimInfo(i).testIntensity = removeEmpties(csvObj.getColumnData(sprintf('testIntensity%d', i)));
            
            % Convert the data from strings into the proper format.
            stimInfo(i).refIntensity = str2double(stimInfo(i).refIntensity)';
            stimInfo(i).testIntensity = str2double(stimInfo(i).testIntensity)';
            
        case LV4StimBlockType.CrossSome
            % Get the reference intensities.
            stimInfo(i).refIntensity = removeEmpties(csvObj.getColumnData(sprintf('refIntensity%d', i)));
            stimInfo(i).refIntensity = str2double(stimInfo(i).refIntensity)';
            
            % For each reference intensities we need to pull out the list
            % of test intensities.
            stimInfo(i).testIntensity = [];
            for j = 1:length(stimInfo(i).refIntensity)
                % Pull out the test intensities specific to this reference
                % intensity.
                testIntensities = removeEmpties(csvObj.getColumnData(sprintf('testIntensity%d%d', i, j)));
                testIntensities = str2double(testIntensities);
                stimInfo(i).testIntensity = [stimInfo(i).testIntensity, testIntensities];
            end
            
        case LV4StimBlockType.CrossStaircase
            % Get the reference intensities.
            stimInfo(i).refIntensity = removeEmpties(csvObj.getColumnData(sprintf('refIntensity%d', i)));
            stimInfo(i).refIntensity = str2double(stimInfo(i).refIntensity)';
         
        otherwise
            error('Invalid stimlus block type.');
    end
end


% This function just strips out empty entries that can be stuck on the end
% of column data pulled out of CSV files using the CSVFile class.
function columnData = removeEmpties(columnData)
% Find the empty column data entries.
l = ~strcmp(columnData, '');

% Trim the empty entries out.
columnData = columnData(l);
