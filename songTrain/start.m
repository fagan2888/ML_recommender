clear
load songTrain.mat;
%tests
%remove the empty artist
[Y, indexes] = filter(Ytrain', @(x) ~isempty(find(x)));
%[Y, indexes] = filter(Ytrain', @(x) (length(find(x)) > 10));
Y = Y';
R = Y~=0;
Y = transform(Y);
%Ytrain = transform(Ytrain);

mu = zeros(size(Y,1), 1);

dim = 1;

%[Y, mu, sigma] = normalize(Y,R, dim);

K = 5;

RWeakSplit = generateWeakSplit(Y, R, K);
params = {};
params.indexes = indexes;
%params.mu = mu;
%params.sd = sigma;

load songTestPairs.mat;
Gtrain = [Gtrain;Gstrong(:,1:length(Gtrain))]; %adding the new user
RStrongSplit = generateStrongSplit(Y, R, K);
%% weak
lambda =  0.185%0.185;
Nf =    20;
step = 0.0001;
[errorTe, errorTr, Yprev, U, M] = CVweak(Y, params, Ytrain, R, RWeakSplit, K, Nf, lambda, step, dim, minFun);
%%
name = strcat('results/', num2str(Nf),'-',num2str(lambda),'.mat')
save(name, 'errorTe', 'errorTr');
%% weak loop
lambda = [20];
Nf = 10:5:50;
errorTe = zeros(5, length(Nf));
errorTr = zeros(5, length(Nf));
for j=1:length(lambda)
    for i=1:length(Nf);
        [errorTe(:,i), errorTr(:,i), U, M] = CVweak(Y, params, Ytrain, R, RWeakSplit, K, Nf(i), lambda(j), step, dim, minFun);
    end;
    %save
    names = strsplit(num2str(lambda(j)),'.' )
    var = strcat('errorTe', names{2});
    eval([var, '= errorTe;']);
    name = strcat('results/',num2str(lambda(j)),'.mat')
    save(name, var);
end;
%% save
%{
var = strcat('errorTe', num2str(lambda(j)));
eval([var, '= errorTe;']);
name = strcat('results/',num2str(lambda(j)),'.mat')
name = 'results/20.mat';
save(name, var);
%}
%% strong
step = 0.001;

minFun = @ALSWR;
%minFun = @artistAverage;

%featuresFun = @doNothing;
featuresFun = @directFriendsAverage;
%featuresFun = @artistHitAverage;
lambda =  0.215%0.215;
Nf =    20;
dim = 1

[errorTe, errorTr, Yprev] = CVstrong(Y, params, Ytrain, R, RStrongSplit, K, Nf, lambda, step, dim, Gtrain, minFun, featuresFun);
%% save
var = strcat('artistHitAverage',num2str(dim));
%var = strcat('doNothing',num2str(dim));

eval([var, '= errorTe;']);
name = strcat('strong/',var,'.mat')
save(name, var);
%% creating U and M based on the whole Y matrix
[U,M] = minFun(Y, R, Nf, lambda, step);

%%

%save ('results/Ldata.mat', 'Ldata', 'Yte', 'Y');
% average by artist
Rtmp = RWeakSplit ~= 0;
Rtmp = RStrongSplit ~= 0;
Rtmp = recomposeRMatrix( Rtmp, params, size(Ytrain,2));
%{
clear muYA
clear muYTeA
count = sum(Rtmp, 1);
idx = find(count);
muYA(:,idx) =  sum(Ytrain(:,idx).*Rtmp(:,idx),1) ./ count(:,idx);
muYTeA(:,idx) = sum(Yprev(:,idx),1)./ count(:,idx);
plot(muYA, muYTeA, '.');

% average by user
clear muYA
clear muYTeA
count = sum(Rtmp, 2);
idx = find(count);
muYA(idx,:) =  sum(Ytrain(idx,:).*Rtmp(idx,:),2) ./ count(idx,:);
muYTeA(idx,:) = sum(Yprev(idx,:),2)./ count(idx,:);
plot(muYA, muYTeA, '.');
%}


Yteclean = Yprev.*Rtmp;
Yteline = Yteclean(Yteclean~=0);
Yline = Ytrain(Yteclean~=0);
plot(log(Yline), log(Yteline), '.');
h = refline(1,0);
set(h, 'color', 'r');
corrcoef(log(Yline),  log(Yteline))