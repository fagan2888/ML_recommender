%%init
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
dim = 0;
minFun = @ALSWR;
minFun = @artistAverage;

step = 0.0001;


Ytr = Y;
Rtr = R;
[Ynorm, params.mu, params.sd] = normalize(Ytr, Rtr, dim);
[Yret, U, M] = minFun(Ynorm, Rtr, Nf, lambda, step);

Yte = recomposeYMatrix( Yret, R, params, size(Ytrain,2), dim);

Ytest_weak_pred = Yte .* Ytest_weak_pairs;
fprintf('weak prev done\n');
%% strong
step = 0.0001;

minFun = @ALSWR;
%minFun = @artistAverage;

%featuresFun = @doNothing;
featuresFun = @directFriendsAverage;
%featuresFun = @artistHitAverage;
lambda =  0.215%0.215;

Nf =    20;
dim = 1
a = size(Y,1);
b = size(Ytest_strong_pairs,1);
m = size(Y,2);
Ytr = [Y; zeros(b, m)];
Rtr = [R; zeros(b,m)];
Rte = [zeros(a,m); ones(b,m)];
Rtot = [R; ones(b,m)];
friends = Gtrain;
[Ynorm, params.mu, params.sd] = normalize(Ytr, Rtr, dim); 

%generating the base features
[Yret, U, M] = minFun(Ynorm, Rtr, Nf, lambda, step);

%infering the features of the test users based on their friends
[Yret, params.mu] = generateStrongY (Yret, Rtr, Rte, U, M, friends, params.mu, dim, featuresFun);

Yte = recomposeYMatrix( Yret, Rtot, params, size(Ytrain,2), dim);
Ytest_strong_pred = Yte(size(Y,1)+1:end,:) .* Ytest_strong_pairs;
fprintf('strong prev done\n');
%%
load songPred.mat;
%% weak test
A = Ytest_weak_pred(Ytest_weak_pred>0);
hist(log(A),500);
%% strong test
B = Ytest_strong_pred(Ytest_strong_pred>0);
hist(log(B),500);
%% save
save('songPred.mat', 'Ytest_weak_pred', 'Ytest_strong_pred');
%% test WILL CLEAR
testOutput