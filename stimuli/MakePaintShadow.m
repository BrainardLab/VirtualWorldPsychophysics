% MakePaintShadow
%
% Generate some dynamic stimuli.
%
% The basic 2D checkboard generation is written in a somewhat
% convoluted manner, because I started with the idea that I might not
% always do squares.  But, I'm keeping it this way
% for now because there may be someday that parallelgrams
% are in fact of interest, and this code provides
% a template.   Setting the paraTheta parameter to zero gives
% squares.
%
% 4/15/12 dhd  Started.
% 1/4/12  dhb  Update for psychophysics, better image naming.  Simplified.
% 3/2/13  dhb  Fix rounding for output dir naming.
% 4/9/13  dhb  Embedding, centering, flipping, etc.
% 6/7/13  dhb  Add jpg output with probe 50 in form for wiki.
% 6/23/13 dhb  Read stimulus parameters from configuration file.
% 10/22/13 dhb ROT90 option.

%% Clear
clear; close all;

%% Read configuration file
stimulusFile = 'StimulusDefinitions.txt';
stimulusParams = ReadStructsFromText(stimulusFile);

%% Decide which conditions to do
fprintf('There are %d conditions available\n',length(stimulusParams));
whichCondition = GetWithDefault('Which condition to generate (O for all)',length(stimulusParams));
if (whichCondition == 0)
    theConditions = 1:length(stimulusParams);
else
    theConditions = whichCondition;
end

%% Do the conditions, getting parameters
% for each from the parameter structure that was read in.
for c = theConditions
    
    % Parameters
    
    % Output directory
    outputRoot = stimulusParams(c).outputRoot;
    
    % This set we are not planning to vary across initial experiments
    checkSquareSize = stimulusParams(c).checkSquareSize;
    probeDiam = stimulusParams(c).probeDiam;
    
    % Rotation in depth of image
    rotationDeg = stimulusParams(c).rotationDeg;
    
    % Check reflecance
    whiteRefl = stimulusParams(c).whiteRefl;
    blackRefl = stimulusParams(c).blackRefl;
    centerRefl = stimulusParams(c).centerRefl;
    backgroundRefl = stimulusParams(c).backgroundRefl;
    
    % Shadow steepness
    shadowSteepness = stimulusParams(c).shadowSteepness;
    
    % These probably won't change anytime soon
    brightLight = stimulusParams(c).brightLight;
    paraTheta = stimulusParams(c).paraTheta;
    imageRows = stimulusParams(c).imageRows;
    imageCols = imageRows;
    nChecks = stimulusParams(c).nChecks;
    
    % Blob standard deviation
    blobSd = stimulusParams(c).blobSd;
    
    % Embed image in a bigger image?  Only has
    % an effect if rotation is 0.  Rotated images
    % are always embedded, and we specify the embedding
    % size in the switch statement below.
    EMBED = stimulusParams(c).EMBED;
    embedRows = stimulusParams(c).embedRows;
    embedCols = embedRows;
    
    % ROT90
    ROT90 = stimulusParams(c).ROT90;
    
    % Center probe?
    CENTERPROBE = stimulusParams(c).CENTERPROBE;
    
    % Depth rotation.  To keep extracted image
    % from being too huge, we extract it from
    % what's returned by the rotation routine.
    % Figureing out the bound is beyond me today,
    % but it's easy to look in photoshop and get
    % the coordinates.
    switch (rotationDeg)
        case 0
            extractRowIndex = 1:imageRows;
            extractColIndex = 1:imageCols;
        case 70
            extractRowIndex = 424:735;
            extractColIndex = 254:1650;
        otherwise
            error('Need to provide extract row/col info for this rotation');
    end
    
    %% Set up directory name for images from this run
    if (EMBED | rotationDeg == 0)
        dirName = sprintf('Eimgs_rot%d_shad%d_blk%d_cen%d',rotationDeg,shadowSteepness,round(100*blackRefl),round(100*centerRefl));
    else
        dirName = sprintf('Images_rot%d_shad%d_blk%d_cen%d',rotationDeg,shadowSteepness,round(100*blackRefl),round(100*centerRefl));
    end
    if (CENTERPROBE & (EMBED | rotationDeg ~= 0))
        dirName = ['C' dirName];
    end
    if (ROT90)
        dirName = ['R' dirName];
    end
    outputDir = fullfile(outputRoot,dirName,'');
    if (~exist(outputDir,'dir'))
        mkdir(outputDir);
    end
    
    %% Illumination.  Dark light is chosen
    % to equate key squares.  The steepness
    % parameter controls the size of the
    % illumination blur across the diagonal
    % edge.
    darkLight = brightLight*blackRefl/whiteRefl;
    fprintf('\nBright light = %0.2f, dark light = %0.2f\n',brightLight,darkLight);
    blankcolor = darkLight*centerRefl;
    
    % Probe info.  The first entry must be zero.
    if (blobSd == 0)
        BLOB = 0;
    else
        BLOB = 1;
    end
    probeColors = [0 0.5 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1];
    
    %% Some computed geometric parameters.
    colSize = checkSquareSize;
    colParaDelta = round(checkSquareSize*sin((pi/180)*paraTheta));
    rowSize = round(checkSquareSize*cos((pi/180)*paraTheta));
    steadyCols = nChecks*colSize;
    steadyRows = nChecks*rowSize;
    rowOffset = round((imageRows-steadyRows)/2);
    colOffset = round((imageCols-steadyCols)/2);
    
    %% Make shadow illumination image
    fprintf('Making shadow illumination image\n');
    theShadowIllumImage = brightLight*ones(imageRows,imageCols);
    critRow = rowSize;
    critCol = colSize;
    for theRow = 1:imageRows
        effectiveRow = theRow-rowOffset;
        for theCol = 1:imageCols
            effectiveCol = theCol-colOffset;
            
            % This first conditional makes sure we are within the checkerboard itself
            if (theRow >= rowOffset && theCol >= colOffset && theRow <= imageRows-rowOffset && theCol <= imageCols - colOffset)
                
                % This checks if we are in the central part, which is always the darker illuminant
                if (effectiveRow < critRow + effectiveCol && effectiveRow >= -critRow + effectiveCol)
                    theShadowIllumImage(theRow,theCol) = darkLight;
                    
                    % Lower diagonal below center.  Allocate bright/dark according to distance along diagonal.
                elseif (effectiveRow < 2*critRow + effectiveCol && effectiveRow >= critRow + effectiveCol)
                    
                    distance = (2*critRow-effectiveRow + effectiveCol)/rowSize;
                    effDistance = betacdf(distance,shadowSteepness,shadowSteepness);
                    theShadowIllumImage(theRow,theCol) =  (1-effDistance)*brightLight + effDistance*darkLight;
                    
                    % Upper diagonal above center.  Same idea as lower.
                elseif (effectiveRow < -critRow + effectiveCol && effectiveRow >= -2*critRow + effectiveCol)
                    distance = 1 - (-effectiveRow + effectiveCol-colSize)/colSize;
                    effDistance = betacdf(distance,shadowSteepness,shadowSteepness);
                    theShadowIllumImage(theRow,theCol) =  (1-effDistance)*brightLight + effDistance*darkLight;
                end
                
            end
        end
    end
    
    %% Fill in the reflectance and paint illumination images.
    %
    % The paint illumination image for each square is the mean of the
    % shadow illumination image for the same square.
    fprintf('Making reflectance and paint illumination images\n');
    theReflImage = backgroundRefl*ones(imageRows,imageCols);
    thePaintIllumImage = brightLight*ones(imageRows,imageCols);
    rowStart = rowOffset;
    colStart = colOffset;
    [x,y] = meshgrid(1:imageCols,1:imageRows);
    X = [x(:)  y(:)];
    middleCheck = ceil(nChecks/2);
    for theRow = 1:nChecks
        if (rem(theRow,2) == 0)
            checkPolarity = 1;
        else
            checkPolarity = 0;
        end
        colStart = colOffset + (theRow-1)*colParaDelta;
        for theCol = 1:nChecks;
            if (theRow == middleCheck && theCol == middleCheck)
                checkRefl = centerRefl;
                if (checkPolarity == 0)
                    checkPolarity = 1;
                else
                    checkPolarity = 0;
                end
            elseif (checkPolarity == 0)
                checkRefl = whiteRefl;
                checkPolarity = 1;
            else
                checkRefl = blackRefl;
                checkPolarity = 0;
            end
            colTopLeft = colStart; colTopRight = colTopLeft+colSize;
            colBottomLeft = colTopLeft+colParaDelta; colBottomRight = colBottomLeft+colSize;
            TRI = DelaunayTri([[colTopLeft rowStart]',[colTopRight rowStart]',[colBottomLeft,rowStart+rowSize]',[colBottomRight,rowStart+rowSize]']');
            index = ~isnan(pointLocation(TRI,X));
            theReflImage(index) = checkRefl;
            thePaintIllumImage(index) = mean(theShadowIllumImage(index));
            colStart = colStart + colSize;
        end
        rowStart = rowStart + rowSize;
    end
    
    %% Image is illumination times reflectance
    thePaintImage = thePaintIllumImage .* theReflImage;
    theShadowImage = theShadowIllumImage .* theReflImage;
    
    %% Compute means of the two images
    paintImageMean = mean(thePaintImage(:));
    shadowImageMean = mean(theShadowImage(:));
    fprintf('Paint image mean = %0.3f, shadow image mean = %0.3f\n',paintImageMean,shadowImageMean);
    
    %% Add the probe circles
    thePaintImages = cell(length(probeColors)+1,1);
    imPaintData = cell(length(probeColors)+1,1);
    theShadowImages = cell(length(probeColors)+1,1);
    imShadowData = cell(length(probeColors)+1,1);
    
    for k = 1:length(probeColors)+1
        % Get image data w/o probe
        thePaintImages{k} = thePaintImage;
        theShadowImages{k} = theShadowImage;
        
        % Add the probe circles to the center of the paint and shadow images
        % Don't add to the last one, which will be the blank image
        if (k <= length(probeColors))
            probeColor = probeColors(k);
            probeRowCenter = rowOffset + nChecks/2*rowSize;
            probeColCenter = colOffset + nChecks/2*colSize;
            probeDelta = X - ones(size(X,1),1)*[probeColCenter probeRowCenter];
            for i = 1:size(X,1)
                if (norm(probeDelta(i,:)) < probeDiam/2)
                    if (~BLOB)
                        thePaintImages{k}(i) = probeColor;
                        theShadowImages{k}(i) = probeColor;
                    else
                        bgColor = thePaintImages{k}(i);
                        thePaintImages{k}(i) = bgColor + (probeColor-bgColor)*exp(-0.5*(probeDelta(i,:))*inv(diag([blobSd.^2 blobSd.^2]))*(probeDelta(i,:)'));
                        
                        bgColor = theShadowImages{k}(i);
                        theShadowImages{k}(i) = bgColor + (probeColor-bgColor)*exp(-0.5*(probeDelta(i,:))*inv(diag([blobSd.^2 blobSd.^2]))*(probeDelta(i,:)'));
                    end
                end
            end
        end
        
        % Use OpenGL/MGL magic to rotate/translate the checkerboard
        if (rotationDeg ~= 0)
            
            rotationAxis = [-1 0 0];                    % x, y, z
            sceneDims = [48 30];			            % Dimensions of the rendered scene.  These are generic widescreen dimensions.
            screenDist = 40;                            % Distance from the image.
            objectDims = [25 25];                       % Size of the image plane.
            tempPaintData = RenderRotatedImage(thePaintImages{k}(end:-1:1,:), rotationDeg, rotationAxis, screenDist, sceneDims, objectDims, brightLight*backgroundRefl);
            tempShadowData = RenderRotatedImage(theShadowImages{k}(end:-1:1,:), rotationDeg, rotationAxis, screenDist, sceneDims, objectDims, brightLight*backgroundRefl);
            tempPaintData = tempPaintData(extractRowIndex,extractColIndex);
            tempShadowData = tempShadowData(extractRowIndex,extractColIndex);
            
            % Embed the extracted data in an image of the appropriate size.
            startRow = round((embedRows-length(extractRowIndex))/2);
            startCol = round((embedCols-length(extractColIndex))/2);
            imPaintData{k} = brightLight*backgroundRefl*ones(embedRows,embedCols);
            imPaintData{k}(startRow:(startRow+length(extractRowIndex)-1),startCol:(startCol+length(extractColIndex)-1)) = tempPaintData;
            imShadowData{k} = brightLight*backgroundRefl*ones(embedRows,embedCols);
            imShadowData{k}(startRow:(startRow+length(extractRowIndex)-1),startCol:(startCol+length(extractColIndex)-1)) = tempShadowData;
        else
            if (EMBED)
                tempPaintData = thePaintImages{k};
                tempShadowData = theShadowImages{k};
                startRow = round((embedRows-imageRows)/2);
                startCol = round((embedCols-imageCols)/2);
                imPaintData{k} = brightLight*backgroundRefl*ones(embedRows,embedCols);
                imPaintData{k}(startRow:(startRow+imageRows-1),startCol:(startCol+imageCols-1)) = tempPaintData;
                imShadowData{k} = brightLight*backgroundRefl*ones(embedRows,embedCols);
                imShadowData{k}(startRow:(startRow+imageRows-1),startCol:(startCol+imageCols-1)) = tempShadowData;
            else
                imPaintData{k} = thePaintImages{k};
                imShadowData{k} = theShadowImages{k};
            end
        end
        
        %% Flip images up/down, to deal with some sort of Matlab/OpenGL difference in coordinate systems.
        % Doing this here ensures that the probe stuff comes out right.
        imPaintData{k} = imPaintData{k}(end:-1:1,:);
        imShadowData{k} = imShadowData{k}(end:-1:1,:);
        
        %% Find the indices of image locations that correspond to the probe.  This will be
        % useful for the experimental program when it wants to write the probe into the blank
        % image.
        if (k == 1)
            if (any(thePaintImage == 0))
                error('Rotation indexing code won''t work if any non-probe pixels are zero.  Rethink logic.');
            end
            if (probeColors(k) ~= 0)
                error('First probe color must be 0 for probe location index finding code to work');
            end
            rawProbeIndex = find(imPaintData{k} == 0);
            [rowIndices,colIndices] = ind2sub(size(imPaintData{k}),rawProbeIndex);
            rawProbeRowCenter = round(mean(rowIndices));
            rawProbeColCenter = round(mean(colIndices));
        end
        
        %% Center the probe in the image
        if (CENTERPROBE & (EMBED | rotationDeg ~= 0))
            tempPaintData = imPaintData{k};
            tempShadowData = imShadowData{k};
            rowShift = (round(embedRows/2)-rawProbeRowCenter);
            colShift = (round(embedCols/2)-rawProbeColCenter);
            imPaintData{k} = shift(tempPaintData,[rowShift,colShift]);
            imShadowData{k} = shift(tempShadowData,[rowShift,colShift]);
            if (k == 1)
                probeIndex = find(imPaintData{k} == 0);
                [rowIndices,colIndices] = ind2sub(size(imPaintData{k}),probeIndex);
                foundProbeRowCenter = round(mean(rowIndices));
                foundProbeColCenter = round(mean(colIndices));
            end
        else
            probeIndex = rawProbeIndex;
            foundProbeRowCenter = rawProbeRowCenter;
            foundProbeColCenter = rawProbeColCenter;
        end
        
        %% Save ungamma corrected stimulus images and sqrt images at each contrast.
        % Flip them up/down at write so that they come out correctly for looking
        % at in the TIFF files.  Thus the TIFF and mat files are flipped with
        % respect to each other.
        cd(outputDir);
        if (k <= length(probeColors))
            nameBase = sprintf('_Probe%d_Diam%d_Blob%d_Chk%d',round(100*probeColors(k)),probeDiam,blobSd,checkSquareSize);
        else
            nameBase = sprintf('_NoProbe_Diam%d_Blob%d_Chk%d',probeDiam,blobSd,checkSquareSize);
        end
        if (ROT90)
            imPaintData{k} = rot90(imPaintData{k});
            imShadowData{k} = rot90(imShadowData{k});
        end
        imwrite(imPaintData{k}(end:-1:1,:),sprintf('Paint%s.tiff',nameBase),'tiff');
        imwrite(imShadowData{k}(end:-1:1,:),sprintf('Shadow%s.tiff',nameBase),'tiff');
        imwrite(sqrt(imPaintData{k}(end:-1:1,:)),sprintf('PaintSqrt%s.tiff',nameBase),'tiff');
        imwrite(sqrt(imShadowData{k}(end:-1:1,:)),sprintf('ShadowSqrt%s.tiff',nameBase),'tiff');
        if (k <= length(probeColors) && round(100*probeColors(k)) == 50)
            imwrite(sqrt(imPaintData{k}(end:-1:1,:)),sprintf('aPaintSqrt_%s_%s.jpg',dirName,nameBase),'jpg');
            imwrite(sqrt(imShadowData{k}(end:-1:1,:)),sprintf('aShadowSqrt_%s_%s.jpg',dirName,nameBase),'jpg');
        end
        
        %% Save as mat files too.  For these find the index of the pixels that
        theImage = imPaintData{k};
        save(sprintf('Paint%s',nameBase),'probeIndex','foundProbeRowCenter','foundProbeColCenter','blankcolor','theImage');
        theImage = imShadowData{k};
        save(sprintf('Shadow%s',nameBase),'probeIndex','foundProbeRowCenter','foundProbeColCenter','blankcolor','theImage');
        cd('..');
        
        %% Report.  Shadow and paint are the same on these.
        fprintf('Final image size is %d by %d\n',size(theImage,1),size(theImage,2));
        fprintf('Found probe center = %d, %d (row,col)\n',foundProbeRowCenter,foundProbeColCenter);
        
        
    end
end

