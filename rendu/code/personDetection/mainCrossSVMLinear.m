%% Linear SVM
rng(seed);


addpath(genpath('toolbox/'));
addpath(genpath('persondetectionTrain'));
%% Load features
load train_feats;



%% Generation of feature vectors
fprintf('Generating feature vectors..\n');
D = numel(feats{1});  % feature dimensionality
X = zeros([length(feats) D]);

for i=1:length(feats)
    X(i,:) = feats{i}(:);  % convert to a vector of D dimensions
end


%% K-fold
fprintf('Splitting into train/test..\n');

K = 10;
ind = crossvalind('Kfold', size(X,1), K);

neuralResults = zeros(1,K);
SVMResultsLin = zeros(1,K);

SVMResultScores = zeros(length(SVMResultsLin), K);


for k = 1:K


Tr.idxs = ind~=k;

Tr.X = X(Tr.idxs,:);
Tr.y = labels(Tr.idxs);

Te.idxs = ind==k;
Te.X = X(Te.idxs,:);
Te.y = labels(Te.idxs);


%% SVM
fprintf('Training..\n');
SVMModel = fitcsvm(Tr.X,Tr.y,'KernelFunction','linear', 'Standardize', 'on', 'Verbose', 1, 'BoxConstraint', 100);

%%
fprintf('Prediction..\n');
[svmPred,score] = predict(SVMModel,Te.X);


%% See prediction performance
fprintf('Plotting performance..\n');


methodNames = { 'SVM'};
[avgSVMLin, aucSVMLin{k}, fprSVMLin{k}, tprSVMLin{k}] = evaluateMultipleMethods( Te.y > 0, [score(:,2)], true, methodNames );

%savegraph(20, 15, 'graphs/ROC_all2');


avgSVMLin


SVMResultsLin(k)     = avgSVMLin(1);


disp(' Number K = ');
disp(k);

end
%%
save('SVMResultsLinAll', 'SVMResultsLin','aucSVMLin','fprSVMLin', 'tprSVMLin' );


