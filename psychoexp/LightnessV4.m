function LightnessV4
% LightnessV4 - Top level function to run the Lightnessv4 experiment.

%% Get the name of the m-file we're running, grab version info,
% and add code directory dynamically to path.
exp.mFileName = mfilename;
[exp.versionInfo,exp.codeDir] = GetAllVersionInfo(exp.mFileName);
AddToMatlabPathDynamically(exp.codeDir);

%% Determine the paths to our data, stimuli, and analysis folders.  The will
% be the same level as the code folder.
exp.dataDir = fullfile(fileparts(exp.codeDir), 'data');

%% Standard read of configuration information
[exp.configFileDir,exp.configFileName,exp.protocolDataDir,exp.protocolList,exp.protocolIndex,exp.conditionName,exp.stimuliDir] = GetExperimentConfigInfo(exp.codeDir,exp.mFileName,exp.dataDir);

%exp.stimuliDir = fullfile(fileparts(exp.codeDir), 'stimuli');
%exp.analysisDir = fullfile(fileparts(exp.codeDir), 'analysis');

%% Set up data directory for this subject
[exp.subject,exp.subjectDataDir,exp.saveFileName] = GetSubjectDataDir(exp.protocolDataDir,exp.protocolList,exp.protocolIndex);

% Store the date/time when the experiment starts.
exp.experimentTimeNow = now;
exp.experimentTimeDateString = datestr(exp.experimentTimeNow);
exp.experimentTimeSecs = mglGetSecs;

% Now we can execute the driver associated with this protocol.
driverCommand = sprintf('params = %s(exp);', exp.protocolList(exp.protocolIndex).driver);
eval(driverCommand);

% Record the time the experiment ends.
exp.experimentEndSecs = mglGetSecs;
exp.experimentDurationSecs = exp.experimentEndSecs - exp.experimentTimeSecs;
exp.experimentDurationMins = exp.experimentDurationSecs / 60;

% Save the experimental data 'params' along with the experimental setup
% data 'exp'.
save(exp.saveFileName, 'params', 'exp');
fprintf('- Data saved to %s\n', exp.saveFileName);
