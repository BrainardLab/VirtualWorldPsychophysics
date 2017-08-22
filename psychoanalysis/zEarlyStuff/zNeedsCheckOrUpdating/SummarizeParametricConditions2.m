function SummarizeParametricConditions2(subjectToAnalyze)
% SummarizeParametricConditions2(subjectToAnalyze)
%
% Read in the summary analysis files for each subject
% and make some useful summary plots.
%
% Assumes that AnalyzeParametricConditions1 has been
% run for all subjects/conditions.
%
% THIS WILL NEED A LITTLE WORK TO HANDLE CONDITIONS 43-48, 
% WHICH VARY TEST LEVEL AND TIMECOURSE.
%
% THE PLOTTING ALSO NEEDS UPDATING TO REFLECT WHAT WAS VARIED
% IN THESE EXPERIMENTS.  CURRENTLY THE PLOTS MAKE SENSE FOR
% THE PARAMETRICCONDITIONS1 CONDITIONS.
%
% FINALLY, CHECK PRECISION TO WHICH SURROUND IS MATCHED.  IT
% VARIES IN REAL NUMBERS BUT I THINK HARDLY AT ALL IF ANY
% IN TERMS OF 8-BIT RGB VALUES.
%
% 7/30/13  dhb  Wrote it.

%% Close
close all;

%% Summary analysis parameters
summaryAnalysisParams.xLim = [0 0.2];
summaryAnalysisParams.xTick = [0 0.1 0.2];
summaryAnalysisParams.yLimSlope = [0 1.5];
summaryAnalysisParams.yTickSlope = [0 0.5 1 1.5];
summaryAnalysisParams.yLimIntercept = [-0.2 0.2];
summaryAnalysisParams.yTickIntercept = [-0.2 0 0.2];

summaryAnalysisParams.markerSize = 12;
summaryAnalysisParams.axisFontSize = 16;
summaryAnalysisParams.labelFontSize = 20;
summaryAnalysisParams.legendFontSize = 18;
summaryAnalysisParams.titleFontSize = 28;

%% Expected condition values
expectedRefType = 'pnt';
expectedRefRotation = 0;
expectedRefShadowSize = 4;
expectedRefBlk = 40;
expectedRefCen = 40;
expectedRefBg = 0.50;
expectedRefWhite = 0.95;
expectedRefBrightLight = 1.00;
expectedRefBlobSd = 0;
expectedRefnChecks = 5;
expectedTestRotation = 0;
expectedTestShadowSize = 4;
expectedTestBg = 0.50;
expectedTestWhite = 0.95;
expectedTestBlobSd = 0;
expectedTestnChecks = 5;

%% Figure out where the top level data directory is.
dataSubDir = 'parametricConditions2';
dataDir = fullfile(fileparts(fileparts(which(mfilename))), 'data', dataSubDir,'');
curDir = pwd;

%% Pick subject
subjectNames = {'aqr' 'baf' 'cnj'};

%% Figure out which subject to analyze
if (nargin < 1 || isempty(subjectToAnalyze))
    fprintf('Available subjects:\n');
    for s = 1:length(subjectNames)
        fprintf('\t%d - %s\n',s,subjectNames{s});
    end
    subjectToAnalyze = -1;
    while ((subjectToAnalyze ~= 0 & subjectToAnalyze < 1) | subjectToAnalyze > length(subjectNames))
        subjectToAnalyze = GetWithDefault('Enter subject number to analyze (0 for all subjects/conditions)',0);
    end
end
if (subjectToAnalyze == 0)
    subjectToAnalyze = 1:length(subjectNames);
end

%% Analyze all the subjects specified
for s = subjectToAnalyze
    % Get subject name
    subjectName = subjectNames{s};
    fprintf('Analyzing data for subject %s\n',subjectName);
    
    % Load the summary data struct array
    clear summaryDataStruct
    summaryDataDir = fullfile(dataDir,'Summary',subjectNames{s},'');
    summaryDataFile = fullfile(summaryDataDir,'SummaryData');
    temp = load(summaryDataFile);
    summaryDataStruct = temp.summaryDataStruct; clear temp;
    
    % Unpack the stuff we care about here
    for c = 1:length(summaryDataStruct)
        % Get data for this subject
        theSlopes(s,c) = summaryDataStruct{c}.theFit(1);
        theIntercepts(s,c) = summaryDataStruct{c}.theFit(2);
        
        % Check for some stuff we expect to be true of all the conditions here
        if (~strcmp(summaryDataStruct{c}.ref.type,'pnt'))
            error('We expect the reference image type to be paint');
        end
        if (summaryDataStruct{c}.ref.rot ~= expectedRefRotation)
            error('Unexpected reference rotation angle');
        end
        if (summaryDataStruct{c}.ref.shadowSize ~= expectedRefShadowSize)
            error('Unexpected reference shadow size');
        end
        if (summaryDataStruct{c}.ref.blk ~= expectedRefBlk)
            error('Unexpected reference black value');
        end
        if (summaryDataStruct{c}.ref.cen ~= expectedRefCen)
            error('Unexpected reference center value');
        end
        if (summaryDataStruct{c}.ref.whiteRefl ~= expectedRefWhite)
            error('Unexpected reference center value');
        end
        if (summaryDataStruct{c}.ref.backgroundRefl ~= expectedRefBg)
            error('Unexpected reference center value');
        end
        if (summaryDataStruct{c}.ref.brightLight ~= expectedRefBrightLight)
            error('Unexpected reference center value');
        end
        if (summaryDataStruct{c}.ref.blobSd ~= expectedRefBlobSd)
            error('Unexpected reference center value');
        end
        if (summaryDataStruct{c}.ref.nChecks ~= expectedRefnChecks)
            error('Unexpected reference center value');
        end
        
        if (summaryDataStruct{c}.test.rot ~= expectedTestRotation)
            error('Unexpected test rotation angle');
        end
        if (summaryDataStruct{c}.test.shadowSize ~= expectedTestShadowSize)
            error('Unexpected test shadow size');
        end
        if (summaryDataStruct{c}.test.whiteRefl ~= expectedTestWhite)
            error('Unexpected reference center value');
        end
        if (summaryDataStruct{c}.test.backgroundRefl ~= expectedTestBg)
            error('Unexpected reference center value');
        end
        if (summaryDataStruct{c}.test.blobSd ~= expectedTestBlobSd)
            error('Unexpected reference center value');
        end
        if (summaryDataStruct{c}.test.nChecks ~= expectedTestnChecks)
            error('Unexpected reference center value');
        end
        
        % Get each condition.  Load for first subject analyzed, check
        % consistency for additional subjects
        if (s == 1)
            theRefImageType{c} = summaryDataStruct{c}.ref.type;
            theTestImageType{c} = summaryDataStruct{c}.test.type;
            theRefImageMeanImageValue(c) = summaryDataStruct{c}.meanImageValue(1);
            theTestImageMeanImageValue(c) = summaryDataStruct{c}.meanImageValue(2);
            theRefImageProbeContextValue(c) = summaryDataStruct{c}.meanProbeLocationValue(1);
            theTestImageProbeContextValue(c) = summaryDataStruct{c}.meanProbeLocationValue(2);
            theRefImageBlkValue(c) = summaryDataStruct{c}.ref.blk;
            theTestImageBlkValue(c) = summaryDataStruct{c}.test.blk;
            theRefImageCenValue(c) = summaryDataStruct{c}.ref.cen;
            theTestImageCenValue(c) = summaryDataStruct{c}.test.cen;
            theTestBrightLightValue(c) = summaryDataStruct{c}.test.brightLight;
        else
            if (theRefImageType{c} ~= summaryDataStruct{c}.ref.type)
                error('Inconsistency in conditions across subjects');
            end
            if (theTestImageType{c} ~= summaryDataStruct{c}.test.type)
                error('Inconsistency in conditions across subjects');
            end
            if (theRefImageMeanImageValue(c) ~= summaryDataStruct{c}.meanImageValue(1))
                error('Inconsistency in conditions across subjects');
            end
            if (theTestImageMeanImageValue(c) ~= summaryDataStruct{c}.meanImageValue(2))
                error('Inconsistency in conditions across subjects');
            end
            if (theRefImageProbeContextValue(c) ~= summaryDataStruct{c}.meanProbeLocationValue(1))
                error('Inconsistency in conditions across subjects');
            end
            
            if (theTestImageProbeContextValue(c) ~= summaryDataStruct{c}.meanProbeLocationValue(2))
                error('Inconsistency in conditions across subjects');
            end
            if (theRefImageBlkValue(c) ~= summaryDataStruct{c}.ref.blk)
                error('Inconsistency in conditions across subjects');
            end
            if (theTestImageBlkValue(c) ~= summaryDataStruct{c}.test.blk)
                error('Inconsistency in conditions across subjects');
            end
            if (theRefImageCenValue(c) ~= summaryDataStruct{c}.ref.cen)
                error('Inconsistency in conditions across subjects');
            end
            if (theTestImageCenValue(c) ~= summaryDataStruct{c}.test.cen)
                error('Inconsistency in conditions across subjects');
            end 
            if (theTestImageBrightLightValue(c) ~= summaryDataStruct{c}.test.brightLight)
                error('Inconsistency in conditions across subjects');
            end   
        end
    end
     
    % Plot slope/intercept versus local contrast for conditions
    theFig1 = figure; clf; hold on
    set(theFig1,'Position',[1000 950 1600 800]);
    set(gca,'FontSize',summaryAnalysisParams.axisFontSize);
    
    indexPntCntl  = find(theTestImageBlkValue == 30 & strcmp(theTestImageType,'pnt'));
    indexShdCntl  = find(theTestImageBlkValue == 30 & strcmp(theTestImageType,'shd'));
    indexPnt = find(theTestImageBlkValue == 20 & strcmp(theTestImageType,'pnt'));
    indexShd = find(theTestImageBlkValue == 20 & strcmp(theTestImageType,'shd'));
    
    subplot(1,2,1); hold on
    plot(theTestImageProbeContextValue(indexPnt),theSlopes(s,indexPnt),'ro','MarkerFaceColor','r','MarkerSize',summaryAnalysisParams.markerSize);
    plot(theTestImageProbeContextValue(indexShd),theSlopes(s,indexShd),'bo','MarkerFaceColor','b','MarkerSize',summaryAnalysisParams.markerSize);
    plot(theTestImageProbeContextValue(indexPntCntl),theSlopes(s,indexPntCntl),'rs','MarkerFaceColor','r','MarkerSize',summaryAnalysisParams.markerSize+4);
    plot(theTestImageProbeContextValue(indexShdCntl),theSlopes(s,indexShdCntl),'bs','MarkerFaceColor','b','MarkerSize',summaryAnalysisParams.markerSize+4);
    plot(summaryAnalysisParams.xLim,[1 1],'k:');
    xlim(summaryAnalysisParams.xLim);
    set(gca,'XTick',summaryAnalysisParams.xTick);
    ylim(summaryAnalysisParams.yLimSlope);
    set(gca,'YTick',summaryAnalysisParams.yTickSlope);
    
    xlabel('Local Surround Intensity (0-1 units)','FontSize',summaryAnalysisParams.labelFontSize);
    ylabel('Effect Slope','FontSize',summaryAnalysisParams.labelFontSize);
    title(sprintf('Slopes, Subject %s',subjectName),'FontSize',summaryAnalysisParams.titleFontSize);
    lg = legend('Paint','Shadow','location','northwest');
    set(lg,'FontSize',summaryAnalysisParams.legendFontSize);
    
    subplot(1,2,2); hold on
    plot(theTestImageProbeContextValue(indexPnt),theIntercepts(s,indexPnt),'ro','MarkerFaceColor','r','MarkerSize',summaryAnalysisParams.markerSize);
    plot(theTestImageProbeContextValue(indexShd),theIntercepts(s,indexShd),'bo','MarkerFaceColor','b','MarkerSize',summaryAnalysisParams.markerSize);
    plot(theTestImageProbeContextValue(indexPntCntl),theIntercepts(s,indexPntCntl),'rs','MarkerFaceColor','r','MarkerSize',summaryAnalysisParams.markerSize+4);
    plot(theTestImageProbeContextValue(indexShdCntl),theIntercepts(s,indexShdCntl),'bs','MarkerFaceColor','b','MarkerSize',summaryAnalysisParams.markerSize+4);
    plot(summaryAnalysisParams.xLim,[0 0],'k:');
    xlim(summaryAnalysisParams.xLim);
    set(gca,'XTick',summaryAnalysisParams.xTick);
    ylim(summaryAnalysisParams.yLimIntercept);
    set(gca,'YTick',summaryAnalysisParams.yTickIntercept);
    xlabel('Local Surround Intensity (0-1 units)','FontSize',summaryAnalysisParams.labelFontSize);
    ylabel('Effect Intercept','FontSize',summaryAnalysisParams.labelFontSize);
    title(sprintf('Intercepts, Subject %s',subjectName),'FontSize',summaryAnalysisParams.titleFontSize);
    lg = legend('Paint','Shadow','location','northwest');
    set(lg,'FontSize',summaryAnalysisParams.legendFontSize);
    
    % Save plot
    curDir = pwd;
    cd(summaryDataDir);
    savefig('SummarySlopeIntercept',theFig1,'pdf');
    savefig('SummarySlopeIntercept',theFig1,'png');
    cd(curDir);
    close(theFig1);
end


%% Dump out a nice condition table in DokuWiki format
if (length(subjectToAnalyze) > 1)
    outfile = fullfile(dataDir,'Summary','ConditionSummaryTable.txt');
    fid = fopen(outfile,'wt');
    fprintf(fid,'=====Condition Summary=====\n\n');
    fprintf(fid,'This table created by SummarizeParametricConditions2.m. ');
    fprintf(fid,'Just copy and paste the summary conditions table it creates here to update.\n\n');
    fprintf(fid,'Fixed across these conditions\n');
    fprintf(fid,'  * Reference type is %s\n',expectedRefType);
    fprintf(fid,'  * Reference rotation is %d\n',expectedRefRotation);
    fprintf(fid,'  * Reference shadow size is %d\n',expectedRefShadowSize);
    fprintf(fid,'  * Reference black value is %d\n',expectedRefBlk);
    fprintf(fid,'  * Reference center value is %d\n',expectedRefCen); 
    fprintf(fid,'  * Reference white value is %d\n',round(100*expectedRefWhite));
    fprintf(fid,'  * Reference bg value is %d\n',round(100*expectedRefBg));
    fprintf(fid,'  * Reference blob sd value is %d\n',expectedRefBlobSd);
    fprintf(fid,'  * Reference bright illum value is %d\n',expectedRefBrightLight);
    fprintf(fid,'  * Reference nChecks value is %d\n',expectedRefnChecks);  
    fprintf(fid,'  * Test rotation is %d\n',expectedTestRotation);
    fprintf(fid,'  * Test shadow size is %d\n',expectedTestShadowSize);
    fprintf(fid,'  * Test white value is %d\n',round(100*expectedTestWhite));
    fprintf(fid,'  * Test bg value is %d\n',round(100*expectedTestBg));
    fprintf(fid,'  * Test blob sd value is %d\n',expectedTestBlobSd);
    fprintf(fid,'  * Test nChecks value is %d\n',expectedTestnChecks);
    
    fprintf(fid,'\n');
    fprintf(fid,'<WRAP leftalign>\n');
    fprintf(fid,'^ Condition Num ^ Test Type ^ Ref Mean ^ Test Mean ^ Ref Probe ^ Test Probe ^ Test Blk ^ Test Cen ^ Test Bright Light ^\n');
    for c = 1:length(summaryDataStruct)
        fprintf(fid,'| %d',summaryDataStruct{c}.condNumber);
        fprintf(fid,' | %s',theTestImageType{c});
        fprintf(fid,' | %0.4f',theRefImageMeanImageValue(c));
        fprintf(fid,' | %0.4f',theTestImageMeanImageValue(c));
        fprintf(fid,' | %0.4f',theRefImageProbeContextValue(c));
        fprintf(fid,' | %0.4f',theTestImageProbeContextValue(c));
        fprintf(fid,' | %0.4f',theTestImageBlkValue(c));
        fprintf(fid,' | %0.4f',theTestImageCenValue(c));
        fprintf(fid,' | %0.4f',theTestBrightLightValue(c));
        fprintf(fid,' |\n');
    end
    fprintf(fid,'</WRAP>\n');
    fclose(fid);
end

%% Dump out a nice data table in DokuWiki format
if (length(subjectToAnalyze) > 1)
    outfile = fullfile(dataDir,'Summary','DataSummaryTable.txt');
    fid = fopen(outfile,'wt');
    fprintf(fid,'=====Data Summary=====\n\n');
    fprintf(fid,'This table created by SummarizeParametricConditions2.m. ');
    fprintf(fid,'Just copy and paste the summary data table it creates here to update.\n\n');
    
    fprintf(fid,'\n');
    fprintf(fid,'<WRAP leftalign>\n');
    fprintf(fid,'^ Condition Num ^ Mean Slope ^ Mean Intercept');
    for s = subjectToAnalyze
        subjectName = subjectNames{s};
        fprintf(fid,' ^ %s Slope ^ %s Intercept',subjectName,subjectName);
    end
    fprintf(fid,' ^\n');
     
    for c = 1:length(summaryDataStruct)
        meanSlope = mean(theSlopes(:,c));
        semSlope = std(theSlopes(:,c))/sqrt(length(theSlopes(:,c)));
        meanIntercept = mean(theIntercepts(:,c));
        semIntercept = std(theIntercepts(:,c))/sqrt(length(theIntercepts(:,c)));
            

        fprintf(fid,'| %d',summaryDataStruct{c}.condNumber);
        fprintf(fid,' | %0.2f +/- %0.2f',meanSlope,semSlope);
        fprintf(fid,' | %0.2f +/- %0.2f',meanIntercept,semIntercept);
        for s = subjectToAnalyze
            fprintf(fid,' | %0.2f | %0.2f',theSlopes(s,c),theIntercepts(s,c));
        end
        fprintf(fid,' |\n');
    end
    fprintf(fid,'</WRAP>\n');
    fclose(fid);
end

%% Close
close all


