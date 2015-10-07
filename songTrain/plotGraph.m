%% plot
load results/20.mat;

ax = axes();

%{
plot(dimension, mseTrLR, 'Color', [0 0 1]);
hold on;
plot(dimension, mseTeLR, 'Color', [0.2 1 1]);

plot(dimension, los01Tr, 'Color', [1 0 0]);
plot(dimension, los01Tr, 'Color', [1 0.5 0]);

plot(dimension, logLossTr, 'Color', [0 1 0]);
plot(dimension, logLossTe, 'Color', [0.5 1 0]);



errorbar(dimension, mean(mseTrLR), mean(mseTrLRsd), 'Color', [0 0 1]);
hold on;
errorbar(dimension, mean(mseTeLR), mean(mseTeLRsd), 'Color', [0.2 1 1]);

errorbar(dimension, mean(los01Tr), mean(los01Trsd), 'Color', [1 0 0]);
errorbar(dimension, mean(los01Te), mean(los01Tesd), 'Color', [1 0.5 0]);

errorbar(dimension, mean(logLossTr), mean(logLossTrsd), 'Color', [0 1 0]);
errorbar(dimension, mean(logLossTe), mean(logLossTesd), 'Color', [0.5 1 0]);
%}
%set(ax, 'XScale', 'log');
%set(ax, 'YScale', 'log');
plot(Nf, mean(errorTe,1));
hold on;
legend('\lambda = 20', 'location', 'NorthEast');
hx = xlabel('sample size');
hy = ylabel('');
ylim([0.59 0.65]);
%xlim([0.9e-2 1.1e3]);

%% 
% the following code makes the plot look nice and increase font size etc.
set(gca,'fontsize',15,'fontname','Helvetica','box','off','tickdir','out','ticklength',[.02 .02],'xcolor',0.5*[1 1 1],'ycolor',0.5*[1 1 1]);
set([hx; hy],'fontsize',18,'fontname','avantgarde','color',[.3 .3 .3]);
grid on;

hold off;
w = 25; h = 20;
set(gcf, 'PaperPosition', [0 0 w h]); %Position plot at left hand corner with width w and height h.
set(gcf, 'PaperSize', [w h]); %Set the paper to have width w and height h.
 saveas(gcf, 'bla', 'pdf') %Save figure

