% ComputeSomeStimulusParams
% 
% If we vary brightLight and blackRefl, what
% do we do to centerRefl to hold local contrast fixed.

%% Clear
clear; close all

%% Define reference parameters
brightLight0 = 1;
whiteRefl0 = 0.95;
blackRefl0 = 0.4;
centerRefl0 = 0.4;

darkLight0 = brightLight0*blackRefl0/whiteRefl0;
blankcolor0 = darkLight0*centerRefl0;

brightLights = [0.8 1.0];
blackRefls = [0.2 0.4 0.6];
for bl = 1:length(brightLights)
    for br = 1:length(blackRefls)
        darkLight(bl,br) = brightLights(bl)*blackRefls(br)/whiteRefl0;
        blankcolorWithCenterRefl0(bl,br) = darkLight(bl,br)*centerRefl0;
        centerReflHoldLocalContrastConstant(bl,br) = blankcolor0/darkLight(bl,br);
    end
end
