

%% Initialize
clear; close all;

%% Set parameters
sigma2_i = 1.5;
sigma2_e = 10;

%% Threshold d-prime
%
% These are also value assumed in TSD fit if the corresponding fit booleans
% are false
simThresholdDPrime = 1;
simSignalExponent = 2;
fitThresholdDPrime = false;
fitSignalExponent = true;

%% Noisiness of the data
dataNoiseSd = 0.05;

%% Simulate or set threshold data and smooth curve for plotting
SIMULATE = false;
if (SIMULATE)
    nCovScalarsData = 10;
    nCovScalarsPlot = 100;
    covScalarsData = logspace(-3,log10(15),nCovScalarsData);
    covScalarsPlot = logspace(-3,log10(15),nCovScalarsPlot);
    thresholdDeltaDataRaw = ComputeTSDModel(simThresholdDPrime,sigma2_i,sigma2_e,simSignalExponent,covScalarsData);
    thresholdDeltaData = thresholdDeltaDataRaw + normrnd(0,dataNoiseSd,size(thresholdDeltaDataRaw));
    yPlotLimLow = 0;
    yPlotLimHigh = 2;
    
        
    lrfSigma2_i = (1.8)^2;
    lrfSigma2_e = (3)^2;
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
    
    lrfSigma2_i = (0.034)^2;
    lrfSigma2_e = (0.05)^2;
end

%% Fit the underlying TSD model
if (fitThresholdDPrime)
    passThresholdDPrime = [];
else
    passThresholdDPrime = simThresholdDPrime;
end
if (fitSignalExponent)
    passSignalExponent = [];
else
    passSignalExponent = simSignalExponent;
end
[tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent] = FitTSDModel(covScalarsData,thresholdDeltaData,...
    'thresholdDPrime',passThresholdDPrime,'signalExponent',passSignalExponent);
tsdThreshDeltaPlot = ComputeTSDModel(tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent,covScalarsPlot);
fprintf('TSD fit: thresholdDPrime = %0.1f, sigma2_i = %0.4g, sigma2_e = %0.4g, signalExponent = %0.3f\n', ...
    tsdThresholdDPrime,tsdSigma2_i,tsdSigma2_e,tsdSignalExponent);

%% Fit piecewise linear function
[plThresh0,plLogEquivScalar,plSlope] = FitPiecewiseLinear(covScalarsData,thresholdDeltaData);
plThreshDeltaPlot = ComputePiecewiseLinear(plThresh0,plLogEquivScalar,plSlope,covScalarsPlot);
fprintf('Piecewise fit: thresh0 = %0.2f (log T^2 = %0.2f), logEquivScalar = %0.2f, slope = %0.2f\n\n',plThresh0,log10(plThresh0^2),plLogEquivScalar,plSlope);

%% Compute linear RF model
lrfThreshDeltaData = ComputeLinearRFModel(lrfSigma2_i,lrfSigma2_e,covScalarsData);

% Interpret piecewise linear parameters
%
% thresh0 = sqrt(sigma2_n)*simThresholdDPrime;
plSigma2_i = (plThresh0/simThresholdDPrime)^2;
plSigma2_e = plSigma2_i/10^(plLogEquivScalar);

% Print out
if (SIMULATE)
    fprintf('Simulated:     internal noise SD = %0.3f, external noise SD = %0.3f (at cov scalar 1)\n',sqrt(sigma2_i),sqrt(sigma2_e));
end
fprintf('TSD fit:       internal noise SD = %0.4g, external noise SD = %0.4g (at cov scalar 1)\n',sqrt(tsdSigma2_i),sqrt(tsdSigma2_e));
fprintf('Piecewise fit: internal noise SD = %0.4g, external noise SD = %0.4g (at cov scalar 1)\n',sqrt(plSigma2_i),sqrt(plSigma2_e));

%% Plot log threshold^2 versus log covScalar
figure; clf; hold on;
plot(log10(covScalarsData),log10(thresholdDeltaData.^2),'ro','MarkerFaceColor','r','MarkerSize',10);
plot(log10(covScalarsPlot),log10(tsdThreshDeltaPlot.^2),'r','LineWidth',1,'MarkerSize',10);
plot(log10(covScalarsPlot),log10(plThreshDeltaPlot.^2),'b','LineWidth',1,'MarkerSize',10);
plot(log10(covScalarsData),log10(lrfThreshDeltaData.^2),'ko','MarkerFaceColor','k','MarkerSize',8);
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
f = 10*sqrt(mean(diff2));

end

%% Compute thresholds under simple underlying TSD model
%
% Just need to invert the forward relation
%       thresholdDPrime = (thresholdLRF - standardLRF)/sqrt(sigman2_n + covScalar*sigma2_e);
% Adding back standard to get delta just cancels it out so we don't need it here.
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

% temp = ComputeTSDModel(thresholdDPrime,sigma2_i,sigma2_e,signalExponent,covScalars);
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
% Just need to invert the forward relation
%       thresholdDPrime = (thresholdLRF - standardLRF)/sqrt(sigman2_n + covScalar*sigma2_e);
% Adding back standard to get delta just cancels it out so we don't need it here.
function thresholdDelta = ComputeLinearRFModel(sigma2_i,sigma2_e,covScalars)

% Figure 
lrfPsychoFig = figure; clf;

% Threshold criterion
thresholdCrit = 0.7602;

factor = 3*sqrt(sigma2_i/0.03);

% Background
backgroundLRF = factor*1;

% Linear RF
linearRF = [1 -1];

% Standard/comparison LRF values
standardLRF = factor*0;
comparisonLRFs = factor*[-0.05 -0.04 -0.03 -0.02 -0.01 0 0.01 0.02 0.03 0.04 0.05];

N = 5000;
standardRFValues = zeros(1,N);
comparisonRFValues = zeros(1,N);
for ss = 1:length(covScalars)
    propComparisonChosen = zeros(1,length(comparisonLRFs));
    for cc = 1:length(comparisonLRFs)
        comparisonChosen = zeros(1,N);
        for nn = 1:N
            standardRFValues(nn) = linearRF*[backgroundLRF + standardLRF,backgroundLRF + normrnd(0,sqrt(covScalars(ss)*sigma2_e))]';
            comparisonRFValues(nn) = linearRF*[backgroundLRF + comparisonLRFs(cc),backgroundLRF + normrnd(0,sqrt(covScalars(ss)*sigma2_e))]';
            decisionNoise = normrnd(0,sqrt(sigma2_i));
            if (comparisonRFValues(nn) > standardRFValues(nn)+decisionNoise)
                comparisonChosen(nn) = 1;
            end
        end
        propComparisonChosen(cc) = mean(comparisonChosen);
    end
    
    % Fit psychometric function
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
    
    figure(lrfPsychoFig); clf; hold on
    plot(comparisonLRFs,propComparisonChosen,'ro','MarkerFaceColor','r','MarkerSize',12);
    plot(xx,yy,'r','LineWidth',1);
    ylim([0 1]);
    % pause;
end

close(lrfPsychoFig);
end



