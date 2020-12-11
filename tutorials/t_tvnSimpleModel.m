% t_tvnSimpleModel
%
% Simple model for thresholds versus noise
%
% See also: t_equivNoiseEtc

% History:
%   11/13/19  dhb Wrote it.

%% Clear
clear; close all;

%% Parameters
sigmasExternal = linspace(0.01,100,1000);
criterionDPrime = 1;

%% Initialize figure
figure; hold on

sigmaInternal = 1; externalIntrusionFactor = 0.5; signalExponent = 1;
thresholds = ComputeTvNThresholds(sigmasExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent);
plot(log10(sigmasExternal.^2),log10(thresholds.^2),'r','LineWidth',4);

sigmaInternal = 2; externalIntrusionFactor = 0.5; signalExponent = 1;
thresholds = ComputeTvNThresholds(sigmasExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent);
plot(log10(sigmasExternal.^2),log10(thresholds.^2),'r:','LineWidth',4);

sigmaInternal = 1; externalIntrusionFactor = 1; signalExponent = 1;
thresholds = ComputeTvNThresholds(sigmasExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent);
plot(log10(sigmasExternal.^2),log10(thresholds.^2),'b','LineWidth',2);

sigmaInternal = 2; externalIntrusionFactor = 10; signalExponent = 1;
thresholds = ComputeTvNThresholds(sigmasExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent);
plot(log10(sigmasExternal.^2),log10(thresholds.^2),'b:','LineWidth',2);

sigmaInternal = 1; externalIntrusionFactor = 0.5; signalExponent = 2;
thresholds = ComputeTvNThresholds(sigmasExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent);
plot(log10(sigmasExternal.^2),log10(thresholds.^2),'g','LineWidth',4);

sigmaInternal = 2; externalIntrusionFactor = 0.5; signalExponent = 2;
thresholds = ComputeTvNThresholds(sigmasExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent);
plot(log10(sigmasExternal.^2),log10(thresholds.^2),'g:','LineWidth',4);

xlim([-3 3]); ylim([-1 5]); axis('square');
xlabel('Log10 Noise Sigma^2');
ylabel('log10 Threshold^2');

function thresholds = ComputeTvNThresholds(sigmasExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent)
    for ii = 1:length(sigmasExternal)
        thresholds(ii) = ComputeTvNThreshold(sigmasExternal(ii),criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent);
    end
end

% Compute thresholds for a generalized version of the standard TvN model.
%
% Syntax:
%     threshold = ComputeTvNThreshold(sigmaExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent)
%
% Description:
%     Compute threshold under simple model where performance is limited by
%     an early static non-linearity between stimulus and perceptual axis,
%     with the non-linearity taken as a power function, as well as noise on
%     the perceptual axis.  The noise is the sum of internal noise and the
%     effect of external noise.
%
%     When the exponent is 1, this reduces to (I think) the standard model
%     used for TvN functions.  The standard model has an asymptotic slope
%     of 1 when threshold squared is plotted against noise variance.  Our
%     data have slopes smaller than 1, and adding the exponent as a
%     parameter allows a description of the data.  The process
%     interpretaiton of this model, however, is not immediately obvious.
%
% Inputs:
%     sigmaExternal -             Variance of experimentally added external noise.
%     criterionDPrime -           Value of d-prime that corresponds to threshold.
%     sigmaInternal -             Variance of internal noise on perceptual axis.
%     externalIntrusionFactor -   External noise times this is the addive
%                                 variance of the external noise on the perceptual axis.
%     signalExponent -            Effect of stimulus strength on perceptual
%                                 axis is x raised to this exponent.  Set to 1 for the standard TvN
%                                 model.
%     
% Outputs:
%     threshold -                 Threshold signal strength.
%
% Optional key/value pairs:
%    None.

% History:
%   07/17/19  dhb  Added header comment.

function threshold = ComputeTvNThreshold(sigmaExternal,criterionDPrime,sigmaInternal,externalIntrusionFactor,signalExponent)
    sigma = sqrt(sigmaInternal^2 + sigmaExternal^2*externalIntrusionFactor);
    exponentiatedThreshold = criterionDPrime*sigma;
    threshold = exponentiatedThreshold^(1/signalExponent);
end
