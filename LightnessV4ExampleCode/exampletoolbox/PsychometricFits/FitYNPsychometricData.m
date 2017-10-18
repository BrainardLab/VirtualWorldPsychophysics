function [pFit,interpStimuli,pInterp,pse,loc25,loc75,paramsValues] = FitYNPsychometricData(theStimuli,nYesResponses,nTotalResponses)
%FitYNPsychometricData
%    pFit,interpStimuli,pInterp,pse,loc25,loc75,paramsValues] = FitYNPsychometricData(theStimuli,nYesResponses,nTotalResponses)
%
% Fit [0-1] psychometric data with cumulative normal.  Allows independent guess and lapse values in
% the range 0 to 5%.
%
% Fit with Palemedes Toolbox.  Some thinking is required to initialize the parameters sensibly.
% We know that the mean of the cumulative normal should be
% roughly within the range of the comparison stimuli, so we initialize this to the mean.  The standard deviation
% should be some moderate fraction of the range of the stimuli, so again this is used as the initializer.
%
% 6/29/12 dhb      Wrote from some earlier version.
% 2/22/14 dhb      Improved comments.
% 3/23/16 dhb      Made consistent with Palemedes 1.8.2.

%% Set some parameters for the curve fitting
paramsFree     = [1 1 0 0];
numPos = nYesResponses;
outOfNum = nTotalResponses;
PF = @PAL_CumulativeNormal;

%% Some optimization settings for the fit
options  = optimset('fminsearch');
options.TolFun = 1e-09;
options.MaxFunEvals = 1000;
options.MaxIter = 1000;
options.Display = 'off';

%% Search grid specification for Palemedes
gridLevels = 100;
searchGrid.alpha = logspace(log10(theStimuli(1)),log10(theStimuli(end)),gridLevels);
searchGrid.beta = 10.^linspace(-4,4,gridLevels);
searchGrid.gamma = 0.0;
searchGrid.lambda = 0.0;

%% Use Palamedes grid search method
[paramsValues,LL,flag] = PAL_PFML_Fit(theStimuli(:), numPos(:), outOfNum(:), ...
            searchGrid, paramsFree, PF, 'SearchOptions', options);

%% Get threshold and deal with catastrophic cases
pse = PF(paramsValues, 0.5, 'inverse');
loc25 = PF(paramsValues, 0.25, 'inverse');
loc75 = PF(paramsValues, 0.75, 'inverse');

if (pse < 0 | pse > 1 | ~isreal(pse) | isinf(pse))
    pse = NaN;
end

%% Provide fit psychometric function on passed stimulus levels
if (~isnan(pse))
    interpStimuli = linspace(min(theStimuli),max(theStimuli),100)';
    pInterp = PF(paramsValues,interpStimuli);
    pFit = PF(paramsValues,theStimuli);
else
    interpStimuli = NaN;
    pInterp = NaN;
    pFit = NaN;
end

%% This older worked with our modified Palemedes version 1.0.
%
% I suspect we are leaving this behind but am keeping the code commented
% out here for now (3/23/17).
%
% interpStimuli = linspace(min(theStimuli),max(theStimuli),100)';
% %interpStimuli = linspace(0,1,100)';
% nYes = nYesResponses;
% nTrials = nTotalResponses;
% PF = @PAL_CumulativeNormal;         % Alternatives: PAL_Gumbel, PAL_Weibull, PAL_CumulativeNormal, PAL_HyperbolicSecant
% PFI = @PAL_inverseCumulativeNormal;
% paramsFree = [1 1 1 1];             % 1: free parameter, 0: fixed parameter
% paramsValues0 = [mean(theStimuli) 1/((max(theStimuli,[],1)-min(theStimuli,[],1))/4) 0 0];
% options = optimset('fminsearch');   % Type help optimset
% options.TolFun = 1e-09;             % Increase required precision on LL
% options.Display = 'off';            % Suppress fminsearch messages
% lapseLimits = [0 0.05];                % Limit range for lambda
% guessLimits = [0 0.05];                % Limit range for guessing
% [paramsValues] = PAL_PFML_Fit(...
%     theStimuli,nYes,nTrials, ...
%     paramsValues0,paramsFree,PF,'searchOptions',options, ...
%     'guessLimits',guessLimits, ...
%     'lapseLimits',lapseLimits);
% pInterp = PF(paramsValues,interpStimuli);
% pFit = PF(paramsValues,theStimuli);
% pse = PFI(paramsValues,0.5);
% loc25 = PFI(paramsValues,0.25);
% loc75 = PFI(paramsValues,0.75);

end
