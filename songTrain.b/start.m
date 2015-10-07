clear
load songTrain.mat;
%tests
%remove the empty artist
[Y, indexes] = filter(Ytrain', @(x) ~isempty(find(x)));
%[Y, indexes] = filter(Ytrain', @(x) (length(find(x)) > 10));
Y = Y';
R = Y~=0;
Y = transform(Y);
Ytrain = transform(Ytrain);

mu = zeros(size(Y,1), 1);

[Y, mu, sigma] = normalize(Y,R);

K = 5;

RWeakSplit = generateWeakSplit(Y, R, K);
params = {};
params.indexes = indexes;
params.mu = mu;
params.sd = sigma;

step = 0.0002;

minFun = @ALSWR;
%minFun = @artistAverage;

load songTestPairs.mat;
Gtrain = [Gtrain;Gstrong(:,1:length(Gtrain))]; %adding the new user
RStrongSplit = generateStrongSplit(Y, K);
%% weak
lambda =  0.215%0.215;
Nf =    20;
[errorTe, errorTr, U, M] = CVweak(Y, params, Ytrain, R, RWeakSplit, K, Nf, lambda, step, minFun);
%%
name = strcat('results/', num2str(Nf),'-',num2str(lambda),'.mat')
save(name, 'errorTe', 'errorTr');

%% creating U and M based on the whole Y matrix
[U,M] = minFun(Y, R, Nf, lambda, step);
%% strong
featuresFun = minFun;
[errorTe, errorTr] = CVstrong(Y, params, Ytrain, R, RWeakSplit, K, Nf, lambda, step, minFun, featuresFun);

%% weak loop
lambda = 0.3:0.1:0.3;
Nf = 1:10:51;
errorTe = zeros(5, length(Nf));
errorTr = zeros(5, length(Nf));
for j=1:length(lambda)
    for i=1:length(Nf);
        [errorTe(:,i), errorTr(:,i), U, M] = CVweak(Y, params, Ytrain, R, RWeakSplit, K, Nf(i), lambda(j), step, minFun);
    end;
    %save
    names = strsplit(num2str(lambda(j)),'.' )
    var = strcat('errorTe', names{2});
    eval([var, '= errorTe;']);
    name = strcat('results/',num2str(lambda(j)),'.mat')
    save(name, var);
end;
%% save
var = strcat('errorTe', num2str(lambda(j)));
eval([var, '= errorTe;']);
name = strcat('results/',num2str(lambda(j)),'.mat')
name = 'results/20.mat';
save(name, var);
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


