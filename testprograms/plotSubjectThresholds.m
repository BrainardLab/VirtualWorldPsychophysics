%% Plot Subject thresholds for experiment 3

%%
% clear;
% distance = [0.0 0.1 0.25 0.4 0.55 0.55];
% % VijaySelection = [0.0	0.0	0.0];
% VijayThresholds = [0.0150	0.0147  0.0196  NaN;
%                    0.0210	0.0189  0.0238  NaN;	
%                    0.0223	0.0326  0.0302  NaN;	
%                    0.0306   0.0390	0.0359  0.0280;	
%                    0.0466   0.0590  0.0371  0.0362;
%                    0.0249   0.0267  0.0218  NaN;
%                    0.0164   0.0232  0.0164  NaN]';
% figure;
% hold on; box on;
% errorbar(distance(1:5) , nanmean(VijayThresholds(:,1:5)), nanstd(VijayThresholds(:,1:5)), '.', 'MarkerSize', 25);
% errorbar(distance(6) , nanmean(VijayThresholds(:,6)), nanstd(VijayThresholds(:,6)), 'r.', 'MarkerSize', 25);
% errorbar(distance(6) , nanmean(VijayThresholds(:,7)), nanstd(VijayThresholds(:,7)), 'k.', 'MarkerSize', 25);
% dataForFit = [repmat(distance(1:5)',4,1) reshape(VijayThresholds(:,1:5)',[],1)];
% dataForFit([16 17 18],:) = []; 
% [curve, goodness] = fit( dataForFit(:,1), dataForFit(:,2), 'poly1' );
% plot([0.0:0.01:1], curve([0.0:0.01:1]),'k');
% set(gca, 'Fontsize',20);
% xlabel('distance','interpreter', 'latex');
% ylabel('threshold','interpreter', 'latex');
% xticks([0.0 0.1 0.25 0.4 0.55]);
% xticklabels({'0.00', '0.1', '0.25', '0.40', '0.55'});
% xlim([-0.05 0.6]);
% legend({'Std at center, Cmp at distace', 'Std & Cmp at same location', 'Std & Cmp at center with background changed'}, 'location', 'northwest');
% % ylim([-4. -2.5]);


clear;
distance = [eps 0.03 0.1 0.3 0.55 0.55 0.55];

%% Subject 2
ThresholdSubject2 = [0.0188	0.0189  0.0143;
                   0.0208	0.0233  0.0165;	
                   0.0175	0.0194  0.0189;	
                   0.0282   0.0276	0.0238;	
                   0.0367   0.0357  0.0314;
                   0.0359   0.0287  0.0343;
                   0.0192   0.0237  0.0181]';
s2 = subplot(2,2,1);
hold on; box on;
plotFigure(s2, distance, ThresholdSubject2, 'Subject 2');



%% Subject 5
ThresholdSubject5 = [0.0367	  0.0255    0.0249;
                     0.0361	  0.0350    0.0347;	
                     0.0455	  0.0314    0.0391;	
                     0.0697   0.0603	0.0600;	
                     0.1030   0.1030    0.0692;
                     0.0804   0.0527    0.0594;
                     0.0504   0.0405    0.0343]';
s5 = subplot(2,2,2);
hold on; box on;
plotFigure(s5, distance, ThresholdSubject5, 'Subject 5');



%% Subject 8
ThresholdSubject8 = [0.0171	  0.0175  0.0174;
                     0.0195	  0.0245  0.0246;	
                     0.0298   0.0252  0.0217;	
                     0.0352   0.0334  0.0380;
                     0.0572   0.0594  0.0367;
                     0.0571   0.0914  0.0993;
                     0.0386   0.0282  0.0233]';
s8 = subplot(2,2,3);
hold on; box on;
plotFigure(s8, distance, ThresholdSubject8, 'Subject 8');

%% Subject 19
ThresholdSubject19 = [0.0336	0.0266  0.0236;
                   0.0416	0.0324  0.0452;	
                   0.0369	0.0363  0.0369;	
                   0.0567   0.0676	0.0533;	
                   0.0728   0.0876  0.0843;
                   0.0616   0.0513  0.0558;
                   0.0458   0.0437  0.0337]';
s19 = subplot(2,2,4);
hold on; box on;
plotFigure(s19, distance, ThresholdSubject19, 'Subject 19');


function [fitCurve,gof2] = fitDoubleLinear(logXScale, logSquaredThreshold)
    fo = fitoptions('Method','NonlinearLeastSquares',...
        'Lower',[min(logSquaredThreshold(:)),0,min(logXScale)],...
        'Upper',[max(logSquaredThreshold(:)),10,max(logXScale)],...
        'StartPoint',[mean(logSquaredThreshold(:,1)) 1 mean(logXScale)]);
    ft = fittype('max(a,a+b*(x-c))','options',fo);
    [fitCurve,gof2] = fit(repmat(logXScale,3,1),reshape(logSquaredThreshold',[],1),ft);
end


function plotFigure(s1, distance, ThresholdsSubject, Title)

    logXScale = log10(distance);
    logXScaleForPlotting = [-3 logXScale(2:end)];
    logSquaredThresholdVijay = log10(ThresholdsSubject.^2);
    [fitCurveVijay, gof2Vijay] = fitDoubleLinear(logXScale(1:5)', logSquaredThresholdVijay(:,1:5));
%     errorbar(s1,logXScaleForPlotting(1), mean(log10(VijaySelection.^2)), std(log10(VijaySelection.^2))/sqrt(3),'b*', 'linewidth', 2, 'MarkerSize', 15);
    l2 = errorbar(s1,logXScaleForPlotting(1:5), mean(logSquaredThresholdVijay(:,1:5),1),std(logSquaredThresholdVijay(:,1:5))/sqrt(3), 'b.', 'linewidth', 2, 'MarkerSize', 35);
    l3 = errorbar(s1,logXScaleForPlotting(6), mean(logSquaredThresholdVijay(:,6),1),std(logSquaredThresholdVijay(:,6))/sqrt(3), 'r.', 'linewidth', 2, 'MarkerSize', 35);
    l4 = errorbar(s1,logXScaleForPlotting(7), mean(logSquaredThresholdVijay(:,7),1),std(logSquaredThresholdVijay(:,7))/sqrt(3), 'k.', 'linewidth', 2, 'MarkerSize', 35);
    xxx = linspace(min(logXScaleForPlotting), max(logXScale), 100);
    yyy = fitCurveVijay(xxx);
    lFit = plot(s1,xxx, yyy, 'b', 'linewidth', 2);
    set(gca, 'Fontsize',20);
    xlabel('distance','interpreter', 'latex');
    ylabel('$\log_{10}(T^2)$','interpreter', 'latex');
    xticks(logXScaleForPlotting(1:5));
    xticklabels({'0.00', '0.03', '0.10', '0.30','0.55'});
    xtickangle(90);
    xlim([-3.5 0.1]);
    ylim([-4. -1.9]);
    title(Title);    
    lFitLabel = ['\{$T_0$, $\alpha$, distance\} = \{',num2str(sqrt(10^fitCurveVijay.a),2), ', ', ...
        num2str(fitCurveVijay.b,2), ', ', num2str(10^fitCurveVijay.c,2),'\}'];
    leg = legend([lFit, l2, l3, l4],{lFitLabel, 'Mean $\pm$ SEM','STD/CMP Periphry', 'STD/CMP Center'}, 'location', 'best','interpreter','latex');
%     leg.Title.String = ;
end
