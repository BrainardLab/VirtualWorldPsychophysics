function VirtualWorldPsychophysicsLocalHook
% VirtualWorldPsychophysicsLocalHook
%
% Configure things for working on the VirtualWorldPsychophysics project.
%
% For use with the ToolboxToolbox.  If you copy this into your
% ToolboxToolbox localToolboxHooks directory (by defalut,
% ~/localToolboxHooks) and delete "LocalHooksTemplate" from the filename,
% this will get run when you execute tbUseProject('VirtualWorldPsychophysics') to set up for
% this project.  You then edit your local copy to match your configuration.
%
% You will need to edit the project location and i/o directory locations
% to match what is true on your computer.

%% Say hello
theProject = 'VirtualWorldPsychophysics';
fprintf('Running %s local hook\n',theProject);

%% Remove old preferences
if (ispref(theProject))
    rmpref(theProject);
end

%% Put project toolbox onto path
%
% Specify project name and location
projectName = theProject;
projectBaseDir = tbLocateProject(theProject);

%% Figure out where baseDir for other kinds of data files is.
sysInfo = GetComputerInfo();
switch (sysInfo.localHostName)
    case 'eagleray'
        % DHB's desktop
        baseDir = fullfile(filesep,'Volumes','Users1','Dropbox (Aguirre-Brainard Lab)');
 
    case 'stingray'
        % Vijay's desktop
        baseDir = fullfile(filesep,'Volumes','OWSHD','Dropbox (Aguirre-Brainard Lab)');
    otherwise
        % Some unspecified machine, try user specific customization
        switch(sysInfo.userShortName)
            % Could put user specific things in, but at the moment generic
            % is good enough.
            otherwise
                baseDir = fullfile('/Users',sysInfo.userShortName,'Dropbox (Aguirre-Brainard Lab)');
        end
end

%% Set preferences for project output
%
% This will need to be locally configured.
outputBaseDir = fullfile(baseDir,'CNST_materials',theProject);
multispectralInputBaseDir = fullfile(baseDir,'IBIO_analysis','VirtualWorldColorConstancy');
stimulusInputBaseDir = fullfile(baseDir,'CNST_materials',theProject,'LightnessCasesForExperiment');
stimulusDefInputBaseDir = fullfile(projectBaseDir,'stimuli');

% This is where the data will be stored
dataDir = fullfile(baseDir,'CNST_materials',theProject,'data');

% This is where the initial psychometric functions will be stored
analysisDir = fullfile(baseDir,'CNST_materials',theProject,'Analysis');

% Set the preferences
setpref(theProject,'outputBaseDir',outputBaseDir);
setpref(theProject,'multispectralInputBaseDir',multispectralInputBaseDir);
setpref(theProject,'stimulusInputBaseDir',stimulusInputBaseDir);
setpref(theProject,'stimulusDefInputBaseDir',stimulusDefInputBaseDir);
setpref(theProject,'dataDir',dataDir);
setpref(theProject,'analysisDir',analysisDir);

% Calibration data lives in a project specific directory, which we define
% here.  Also set the BrainardLabToolbox 'CalDataFolder' preference, so
% that calibration data will get written to the correct place if the
% calibration is run after the tbUseProject (which it should be).
setpref(theProject,'calibrationDir',fullfile(baseDir,'CNST_materials',theProject,'CalibrationData'));
setpref('BrainardLabToolbox','CalDataFolder',getpref(theProject,'calibrationDir'));

% We sometimes need some images for testing.  We don't want these in the code repository (too big, 
% separate code and data), so we define their home here.
setpref(theProject,'testImageDir',fullfile(baseDir,'CNST_materials',theProject,'TestImages'));
