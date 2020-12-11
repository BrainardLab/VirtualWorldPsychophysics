%% Work through basic equivalent noise models
%
% Description:
%   Simulates data using a TSD based model, or loads in our actual data,
%   and fits with various models.
%
%   The fits are for the TSD model used to generate the simulated data and
%   a piecewise linear model.
%
%   Can also generate curves by simulating a simple (two pixel) linear
%   receptive field model, but this is not fit as it's slow and stochastic.
%   Parameters adjusted to match up with experimental data.  This is a
%   simplified version of the model Vijay developed to run on the actual
%   experimental images.  Note that the variability in the experimental
%   images is constrained by physical reflectance constraints (0-1), and
%   thus the realized variability is not exactly that specified by the
%   covariance matrix of the underlying Gaussian.
%
%   In simulate mode, every once and a while the piecewise linear function
%   fit function crashes for reasons I don't understand.  Running it again
%   is usually then fine, which is one reason it's hard to figure out.
%
% This requires the Palamedes toolbox.
%   You'll get that with tbUseProject('VirtualWorldPsychophysics') 
%   or just              tbUse('Palamedes_1.9.0')
%
% See also: t_tvnSimpleModel

%% History
%  12/10/20  dhb  Finished writing first version.

%% Initialize
clear; close all;

%% Set parameters for TSD model if it is simulated.


%% Threshold d-prime
%
% These are also value assumed in TSD fit if the corresponding fit booleans
% are false, so they are set outside the SIMULATE conditional.
%    simThresholdDPrime is the criterion d-prime value used to determine threshold
%    simSignalExponent is the exponent in the TSD model.
%       Positive values decrease the slope of the rising limb.  See
%       t_tvnSimpleModel for more expansion on the TSD model.
simThresholdDPrime = 1;
simSignalExponent = 1;

% In the TSD model fit, you can hold the thresholdDPrime and signalExponent
% fixed at the values above (set to false here), or search on them (set to
% true).
fitThresholdDPrime = false;
fitSignalExponent = true;

%% Simulate or set threshold data and smooth curve for plotting
SIMULATE = true;
if (SIMULATE)
    % Simulated parameters
    %   simSigma2_i is the variance of the internal noise
    %   simSigma2_e is the variance of the external noise at covScalar = 1.
    %   simDataNoiseSd is the standard deviation of iid Gaussian noise added to the simulated data.
    simSigma2_i = 1.5;
    simSigma2_e = 10;
    simDataNoiseSd = 0.05;
    
    % Data size
    nCovScalarsData = 10;
    nCovScalarsPlot = 100;
    covScalarsData = logspace(-3,log10(15),nCovScalarsData);
    covScalarsPlot = logspace(-3,log10(15),nCovScalarsPlot);
    
    % Simulate and add noise
    thresholdDeltaDataRaw = ComputeTSDModel(simThresholdDPrime,simSigma2_i,simSigma2_e,simSignalExponent,covScalarsData);
    thresholdDeltaData = thresholdDeltaDataRaw + normrnd(0,simDataNoiseSd,size(thresholdDeltaDataRaw));
    yPlotLimLow = 0;
    yPlotLimHigh = 2;
    
    % These parameters yield a reasonable fit (determined by hand) to the simulated data
    % with default script parameters.
    lrfThresholdDPrime = simThresholdDPrime;
    lrfSigma2_i = simSigma2_i;
    lrfSigma2_e = simSigma2_e;
else
    thresholdDeltaInput = [
        0.0001	0.0237
        0.01	0.0226
        0.03	0.0278
        0.1		0.029
        0.3		0.0338
        1		0.0374]';
    nCovScalarsPlot = 100;
    covScalarsData = thresholdDeltaInput(1,:);
    covScalarsPlot = logspace(log10(covScalarsData(1)),log10(covScalarsData(end)),nCovScalarsPlot);
    thresholdDeltaData = thresholdDeltaInput(2,:);
    nCovScalarsData = length(covScalarsData);
    yPlotLimLow = -3.5;
    yPlotLimHigh = -1.5;
    
    % Chosen by hand to approximate our data
    lrfThresholdDPrime = 1;
    lrfSigma2_i = (0.034)^2/2;
    lrfSigma2_e = (0.05)^2/2;
end

%% Fit the underlying TSD model
%
% If we're fitting thresholdDPrime, pass [] in key/value pair.  Otherwise pass fixed value
% to use.
if (fitThresholdDPrime)
    passThresholdDPrime = [];
else
    passThresholdDPrime = simThresholdDPrime;
end

% If we're fitting signalExponent, pass [] in key/value pair. Otherwise
% pass fixed value to use.
if (fitSignalExponent)
    passSignalExponent = [];
else
    passSignalExponent = simSignalExponent;
end

% Fit and report
[tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent] = FitTSDModel(covScalarsData,thresholdDeltaData,...
    'thresholdDPrime',passThresholdDPrime,'signalExponent',passSignalExponent);
fprintf('\nTSD fit to data: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent);

% Generate smooth curve for plotting
tsdThreshDeltaPlot = ComputeTSDModel(tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent,covScalarsPlot);

%% Fit piecewise linear function
[plThresh0,plLogEquivScalar,plSlope] = FitPiecewiseLinear(covScalarsData,thresholdDeltaData);
plThreshDeltaPlot = ComputePiecewiseLinear(plThresh0,plLogEquivScalar,plSlope,covScalarsPlot);
fprintf('Piecewise fit to data: thresh0 = %0.2f (log T^2 = %0.2f), logEquivScalar = %0.2f, slope = %0.2f\n\n',plThresh0,log10(plThresh0^2),plLogEquivScalar,plSlope);

%% Compute linear RF model
%
% Run out predictions with hand chosen parameters
lrfThreshDeltaData = ComputeLinearRFModel(lrfThresholdDPrime,lrfSigma2_i,lrfSigma2_e,covScalarsData);

% Fit this with the TSD model, which should describe it exactly with
% exponent of 1, up to simulation noise
[lrfTSDFitThresholdDPrime,lrfTSDFitSigma2_i,lrfTSDFitSigma2_e,lrfTSDFitSignalExponent] = FitTSDModel(covScalarsData,lrfThreshDeltaData,...
    'thresholdDPrime',lrfThresholdDPrime,'signalExponent',1);
fprintf('\nLRF model parameters:       thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g\n', ...
    lrfThresholdDPrime,lrfSigma2_i,lrfSigma2_e);
fprintf('TSD fit to linear RF model: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    lrfTSDFitThresholdDPrime,lrfTSDFitSigma2_i,lrfTSDFitSigma2_e,lrfTSDFitSignalExponent);

% Compute curve for plotting
lrfTSDFitThreshDeltaPlot = ComputeTSDModel(lrfTSDFitThresholdDPrime,lrfTSDFitSigma2_i,lrfTSDFitSigma2_e,lrfTSDFitSignalExponent,covScalarsPlot);

% Interpret piecewise linear parameters
%
% thresh0 = sqrt(sigma2_n)*simThresholdDPrime;
plSigma2_i = (plThresh0/simThresholdDPrime)^2;
plSigma2_e = plSigma2_i/10^(plLogEquivScalar);

% Print out
if (SIMULATE)
    fprintf('Simulated:     internal noise SD = %0.3f, external noise SD = %0.3f (at cov scalar 1)\n',sqrt(simSigma2_i),sqrt(simSigma2_e));
end
fprintf('\nTSD fit:       internal noise SD = %0.4g, external noise SD = %0.4g (at cov scalar 1)\n',sqrt(tsdSigma2_i),sqrt(tsdSigma2_e));
fprintf('Piecewise fit: internal noise SD = %0.4g, external noise SD = %0.4g (at cov scalar 1)\n',sqrt(plSigma2_i),sqrt(plSigma2_e));

%% Plot log threshold^2 versus log covScalar
figure; clf; hold on;
plot(log10(covScalarsData),log10(thresholdDeltaData.^2),'ro','MarkerFaceColor','r','MarkerSize',10);
plot(log10(covScalarsPlot),log10(tsdThreshDeltaPlot.^2),'r','LineWidth',1);
plot(log10(covScalarsPlot),log10(plThreshDeltaPlot.^2),'b','LineWidth',1);
plot(log10(covScalarsData),log10(lrfThreshDeltaData.^2),'ko','MarkerFaceColor','k','MarkerSize',8);
plot(log10(covScalarsPlot),log10(lrfTSDFitThreshDeltaPlot.^2),'k','LineWidth',1);

xlabel('Log10 Covariance Scalar');
ylabel('Log10 Threshold^2');
%ylim([yPlotLimLow yPlotLimHigh]);

%% ComputePiecewiseLinear
%
% Compute thresholds from parameters of piecewise linear fit in log10
% threshold^2 versus log10 covariance scalar piecewise linear fit.
function thresholdDeltaLRFs = ComputePiecewiseLinear(thresh0,logEquivScalar,slope,covScalars)
delta = log10(thresh0^2);
temp = covScalars - logEquivScalar;
temp1 = log10(temp);
temp1(temp <= 0) = -100;
thresholdDeltaLRFs = sqrt(10.^max(delta,delta + slope*(log10(covScalars)-logEquivScalar)));
end

%% FitPiecewiseLinear
function [thresh0,logEquivScalar,slope] = FitPiecewiseLinear(covScalars,thresholdDeltaData)

% Reasonable bounds
minThresh0 = min(thresholdDeltaData);
maxThresh0 = max(thresholdDeltaData);
minLogScalar = log10(min(covScalars));
maxLogScalar = log10(max(covScalars));
minSlope = 0.1;
maxSlope = 10;

% Bounds
vlb = [minThresh0 minLogScalar minSlope];
vub = [maxThresh0 maxLogScalar maxSlope];

% Set up starting point grid
nThresh0s = 5;
nLogScalars = 5;
nSlopes = 5;
tryThresh0s = linspace(minThresh0,maxThresh0,nThresh0s);
tryLogScalars = linspace(minLogScalar,maxLogScalar,nLogScalars);
trySlopes = linspace(minSlope,maxSlope,nSlopes);

% Grid search around fmincon starting point
options = optimset(optimset('fmincon'),'Diagnostics','off','Display','off','LargeScale','off','Algorithm','active-set');
bestF = Inf;
bestX = [];
for tt = 1:nThresh0s
    for ll = 1:nLogScalars
        for ss = 1:nSlopes
            % Set x0 and search
            x0 = [tryThresh0s(tt) tryLogScalars(ll) trySlopes(ss)];
            x = fmincon(@(x)FitPiecewiseLinearFun(x,covScalars,thresholdDeltaData),x0,[],[],[],[],vlb,vub,[],options);
            f = FitPiecewiseLinearFun(x,covScalars,thresholdDeltaData);
            if (f < bestF)
                bestF = f;
                bestX = x;
            end
        end
    end
end

% Extract parameters from best fit
thresh0 = bestX(1);
logEquivScalar = bestX(2);
slope = bestX(3);
end

%% Error function for piecewise linear fitting
function f = FitPiecewiseLinearFun(x,covScalars,thresholdDelta)

thresh0 = x(1);
logEquivScalar = x(2);
slope = x(3);
predictedDelta = ComputePiecewiseLinear(thresh0,logEquivScalar,slope,covScalars);
diff2 = (thresholdDelta - predictedDelta).^2;
f = sqrt(mean(diff2));

end

%% Compute thresholds under simple underlying TSD model
%
% For the signalExponent == 1 case, just need to invert the forward relation
%       thresholdDPrime = (thresholdLRF - standardLRF)/sqrt(sigman2_n + covScalar*sigma2_e);
%
% This corresponds to adding noise to both comparison and standard
% representationsm as per standard definition of d-prime under equal
% variance distributions.
%
% Since the threshold we want is the difference from the standard, we can
% just treat the standardLRF as 0 without loss of generality.
%
% The raising to the signalExponent is provides an ad-hoc parameter that allows us
% more flexibility in fiting the data, but its underlying interpretation
% isn't clear.  Note that when the signalExponent isn't 1, it's hard to
% interpret the sigma's of the fit.  Or at least, we have not thought that
% through yet.
function thresholdDelta = ComputeTSDModel(thresholdDPrime,sigma2_i,sigma2_e,signalExponent,covScalars)

for jj = 1:length(covScalars)
    thresholdDelta(jj) = (sqrt(sigma2_i + covScalars(jj)*sigma2_e)*thresholdDPrime).^(1/signalExponent);
end

end

%% FitTSDModel
function [thresholdDPrime,sigma2_i,sigma2_e,signalExponent] = FitTSDModel(covScalars,thresholdDelta,varargin)

p = inputParser;
p.addParameter('thresholdDPrime',1,@(x) (isempty(x) | isnumeric(x)));
p.addParameter('signalExponent',1,@(x) (isempty(x) | isnumeric(x)));
p.parse(varargin{:});

% Set thresholdDPrime initial value and bounds depending on parameters
% Empty means search over it, otherwise lock at passed
% value.
if (~isempty(p.Results.thresholdDPrime))
    thresholdDPrime0 = p.Results.thresholdDPrime;
    thresholdDPrimeL = p.Results.thresholdDPrime;
    thresholdDPrimeH = p.Results.thresholdDPrime;
else
    thresholdDPrime0 = 1;
    thresholdDPrimeL = 1e-10;
    thresholdDPrimeH = 1e10;
end

% Set signalExponent initial value and bounds depending on parameters
% Empty means search over it, otherwise lock at passed
% value.
if (~isempty(p.Results.signalExponent))
    signalExponent0 = p.Results.signalExponent;
    signalExponentL = p.Results.signalExponent;
    signalExponentH = p.Results.signalExponent;
    nExps = 1;
else
    signalExponent0 = 1;
    signalExponentL = 1e-2;
    signalExponentH = 1e2;
    nExps = 20;
end

% Bounds
vlb = [thresholdDPrimeL 1e-20 1e-20 signalExponentL];
vub = [thresholdDPrimeH  100 100 signalExponentH];

% Grid over starting parameters
trySignalExponents = linspace(signalExponentL,signalExponentH,nExps);

% Search
bestF = Inf;
bestX = [];
for ee = 1:nExps
    thresholdDPrime0 = thresholdDPrime0;
    signalExponent0 = trySignalExponents(ee);
    sigma2_i0 = ((min(thresholdDelta).^signalExponent0)/thresholdDPrime0).^2;
    sigma2_e0 = sigma2_i0;
    
    x0 = [thresholdDPrime0 sigma2_i0 sigma2_e0 signalExponent0];
    options = optimset(optimset('fmincon'),'Diagnostics','off','Display','off','LargeScale','off','Algorithm','active-set');
    x = fmincon(@(x)FitTSDModelFun(x,covScalars,thresholdDelta),x0,[],[],[],[],vlb,vub,[],options);
    f = FitTSDModelFun(x,covScalars,thresholdDelta);
    if (f < bestF)
        bestF = f;
        bestX = x;
    end
end

% Extract parameters
thresholdDPrime = bestX(1);
sigma2_i = bestX(2);
sigma2_e = bestX(3);
signalExponent = bestX(4);
end

%% Error function for TSD model fitting
function f = FitTSDModelFun(x,covScalars,thresholdDelta)

thresholdDPrime = x(1);
sigma2_i = x(2);
sigma2_e = x(3);
signalExponent = x(4);
predictedDelta = ComputeTSDModel(thresholdDPrime,sigma2_i,sigma2_e,signalExponent,covScalars);
diff2 = (thresholdDelta - predictedDelta).^2;
f = sqrt(mean(diff2));

end

%% Compute thresholds under linear RF model
%
% This is a two-pixel version, with one pixel for center and one for
% surround.  They have weights 1 and -1, which are hard coded here. We add
% external noise to the surround, and vary the center of the comparisons
% relative to the standard.
%
% Internal noise is added to the center and external noise to the surround,
% for both standard and comparison.  This factors the parameters a bit
% differently from the way Vijay did in his code, but allows easy match up
% to the analytic TSD model.
%
% It's useful to plot the psychometric functions, because you want to make
% sure that the range of comparison variation is in a regime that affects
% performance reasonably.  This varies with sigma2_i and sigma2_e, and
% based on experience the routine attemps to put the comparison variation
% in the right range.
function thresholdDelta = ComputeLinearRFModel(thresholdDPrime,sigma2_i,sigma2_e,covScalars,varargin)

p = inputParser;
p.addParameter('plotPsycho',true,@(x) (islogical(x)));
p.parse(varargin{:});

% Figure 
if (p.Results.plotPsycho)
    lrfPsychoFig = figure; clf;
end

% Threshold criterion
thresholdCrit = dPrimeToTAFCFractionCorrect(thresholdDPrime);   % d-prime of 1 -> 0.7602

% This factor scales the stimuli so as put psychometric function in range.
% Determined by hand
factor = 10*sqrt(sigma2_i/0.03);

% Linear RF
linearRF = [1 -1];

% Standard/comparison LRF values
standardLRF = factor*0;
comparisonLRFs = factor*[-0.05 -0.04 -0.03 -0.02 -0.01 0 0.01 0.02 0.03 0.04 0.05];

N = 5000;
for ss = 1:length(covScalars)
    propComparisonChosen = zeros(1,length(comparisonLRFs));
    
    % Add surrond noise to both standard and comparison as in experiment
    for cc = 1:length(comparisonLRFs)
        standardRFValues = standardLRF - normrnd(0,sqrt(covScalars(ss)*sigma2_e + sigma2_i),1,N);
        comparisonRFValues = comparisonLRFs(cc) - normrnd(0,sqrt(covScalars(ss)*sigma2_e + sigma2_i),1,N);
        propComparisonChosen(cc) = mean(comparisonRFValues > standardRFValues);
    end
    
    % Fit psychometric function using Palamedes.  Fairly standard code.
    PF = @PAL_CumulativeNormal;         % Alternatives: PAL_Gumbel, PAL_Weibull, PAL_CumulativeNormal, PAL_HyperbolicSecant
    
    % paramsFree is a boolean vector that determins what parameters get
    % searched over. 1: free parameter, 0: fixed parameter
    paramsFree = [1 1 1 1];
    
    % Initial guess.  Setting the first parameter to the middle of the stimulus
    % range and the second to 1 puts things into a reasonable ballpark here.
    paramsValues0 = [0 1 0 0];
    lapseLimits = [0 0.05];
    
    % Set up standard options for Palamedes search
    options = PAL_minimize('options');
    
    % Fit with Palemedes Toolbox.  The parameter constraints match the psignifit parameters above.  Some thinking is
    % required to initialize the parameters sensibly.  We know that the mean of the cumulative normal should be
    % roughly within the range of the comparison stimuli, so we initialize this to the mean.  The standard deviation
    % should be some moderate fraction of the range of the stimuli, so again this is used as the initializer.
    [paramsValues] = PAL_PFML_Fit(...
        comparisonLRFs,propComparisonChosen,ones(size(propComparisonChosen)), ...
        paramsValues0,paramsFree,PF, ...
        'lapseLimits',lapseLimits,'guessLimits',[],'searchOptions',options,'gammaEQlambda',true);
    
    xx = linspace(comparisonLRFs(1),comparisonLRFs(end),1000);
    yy = PF(paramsValues,xx');
    psePal = PF(paramsValues,0.5,'inverse');
    thresholdDelta(ss) = PF(paramsValues,thresholdCrit,'inverse')-psePal;
    
    if (p.Results.plotPsycho)
        figure(lrfPsychoFig); hold on
        %plot(comparisonLRFs,propComparisonChosen,'ro','MarkerFaceColor','r','MarkerSize',12);
        plot(xx,yy,'r','LineWidth',1);
        ylim([0 1]);
    end
end

end


%% The three functions below are TSD utility routines pasted in from ISETBio
function fractionCorrect = dPrimeToTAFCFractionCorrect(dPrime)
% fractionCorrect = dPrimeToTAFCPercentFraction(dPrime)
%
% Get area under ROC curve for an equal-variance normal distribution
% d-prime and from there compute fraction correct.
%
% This was originally written as numerical integration of ROC curve.  Now
% has analytic calculation inserted, and a check that the two are close.
% At some point, might want to change over to the analytic version.
%
% See also: computeROCArea, analyticPHitPpFA, computeDPrimCritNorm

% History:
%    05/26/2020  dhb  Added analytic calculation

%% Examples:
%{
    dPrimeToTAFCFractionCorrect(0.25)
    dPrimeToTAFCFractionCorrect(0.5)
    dPrimeToTAFCFractionCorrect(0.1)
    dPrimeToTAFCFractionCorrect(2)
    dPrimeToTAFCFractionCorrect(3)
%}

nCriteria = 1000;
lowCriterion = -8;
highCriterion = 8;

fractionCorrect = computeROCArea(dPrime,0,1,linspace(lowCriterion,highCriterion,nCriteria));
fractionCorrect1 = normcdf(dPrime/sqrt(2));
if (max(abs(fractionCorrect-fractionCorrect1)) > 1e-3)
    error('Numerical and analytic calculations do not match');
end
    
end

%% Also from isetbio, and here for convenience
function rocArea = computeROCArea(signalMean,noiseMean,commonSd,criteria)
% rocArea = computeROCArea(signalMean,noiseMean,commonSd,criteria)
%
% Compute area under ROC curve given signal mean, noise mean, the common
% standard deviation, and a set of criteria.  Uses the equal-variance
% normal assumption.

% Compute ROC curve
for i = 1:length(criteria)
    [pHitAnalytic(i),pFaAnalytic(i)] = analyticpHitpFa(signalMean,noiseMean,commonSd,criteria(i));
end

% Integrate numerically to get area.  The negative
% sign is because the way the computation goes, the hit rates
% decrease with increasing criteria.
rocArea = -trapz([1 pFaAnalytic 0],[1 pHitAnalytic 0]);

end

function [pHit,pFa] = analyticpHitpFa(signalMean,noiseMean,commonSd,rightCrit)
% [pHit,pFa] = analyticpHitpFa(signalMean,noiseMean,commonSd,rightCrit)
% 
% This just finds the area under the signal and noise
% distributions to the right of the criterion to obtain
% hit and false alarm rates.  Uses the equal-variance normal assumption.

pHit = 1-normcdf(rightCrit,signalMean,commonSd);
pFa = 1-normcdf(rightCrit,noiseMean,commonSd);

end
