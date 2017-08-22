function figParams = SetFigParams(figParams,type)
% figParams = SetFigParams(figParams,type)
%
% Set fields of figParams structure.
%
% If other fields already exist in the passed structure, they
% are preserved.  If empty is passed, a structure is created,
% filled, and returned.
%
% Known types
%   'popdecode'
%   'psychophysics'
%
% 5/11/14  dhb  Factored out.

figParams.basicSize = 700;
figParams.position = [100 100 figParams.basicSize round(420/560*figParams.basicSize)];
figParams.sqPosition = [100 100 round(7/7*figParams.basicSize) round(7/7*figParams.basicSize)];
figParams.fontName = 'Helvetica';
figParams.markerSize = 22;
figParams.axisLineWidth = 2;
figParams.lineWidth = 4;
figParams.axisFontSize = 22;
figParams.labelFontSize = 24;
figParams.legendFontSize = 18;
figParams.titleFontSize = 10;
figParams.figType = {'pdf'};
figParams.theColors = ['r' 'b' 'g' 'k' 'c' 'y'];

figParams.intensityLimLow = -0.05;
figParams.intensityLimHigh = 1.05;
figParams.intensityTicks = [0.0 0.25 0.5 0.75 1.0];
figParams.intensityTickLabels = {'0.00' '0.25' '0.50' '0.75' '1.00'};
figParams.intensityYTickLabels = {'0.00 ' '0.25 ' '0.50 ' '0.75 ' '1.00 '};

figParams.fractionLimLow = -0.05;
figParams.fractionLimHigh = 1.05;
figParams.fractionTicks = [0.0 0.25 0.50 0.75 1.0];
figParams.fractionTickLabels = {'0.00 ' '0.25 ' '0.50 ' '0.75 ' '1.00 '};

switch (type)
    case 'popdecode'

        figParams.rfXFontSize = 24;
        
        figParams.interceptLimLow = -0.30;
        figParams.interceptLimHigh = 0.30;
        figParams.gainLimLow = 0;
        figParams.gainLimHigh = 3;
        figParams.interceptTicks = [-0.30 -0.20 -0.10 0.0 0.10 0.20 0.30];
        figParams.interceptTickLabels = {'-0.30' '-0.20' '-0.10' '0.0' '0.10' '0.20' '0.30'};
        figParams.rfPlotLimLow = -300;
        figParams.rfPlotLimHigh = 300;
        
        figParams.spikeLimLow = -1;
        figParams.spikeLimHigh = 81;
        figParams.spikeTicks = [0 20 40 60 80 100 120 140 160 180 200];
        figParams.spikeTickLabels = {'0  ' '20  ' '40  ' '60  ' '80  ' '100 ' '120 ' '140 ' '160 ' '180 ' '200 '};
    case 'psychophysics'

    otherwise
        error('Don''t know about passed figure type');
end