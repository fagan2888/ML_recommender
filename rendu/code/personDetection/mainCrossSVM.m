seed=8000;
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


%% K-fold : we do a 10-fold and store all results for further analysis and ROC curves
fprintf('Splitting into train/test..\n');

K = 10;
ind = crossvalind('Kfold', size(X,1), K);

neuralResults = zeros(1,K);
SVMResults = zeros(1,K);

SVMResultScores = zeros(length(SVMResults), K);


for k = 1:K


Tr.idxs = ind~=k;

Tr.X = X(Tr.idxs,:);
Tr.y = labels(Tr.idxs);

Te.idxs = ind==k; 
Te.X = X(Te.idxs,:);
Te.y = labels(Te.idxs);


%% SVM

%SVMModel = fitcsvm(Tr.X,Tr.y,'KernelFunction','linear', 'Standardize', 'on', 'Verbose', 1);
%SVMModel = fitcsvm(Tr.X,Tr.y,'KernelFunction','rbf','KernelScale',100,'Standardize', 'on',  'Verbose', 1);
%SVMModel = fitcsvm(Tr.X,Tr.y,'KernelFunction','rbf','KernelScale',90,'Standardize', 'on',  'Verbose', 1, 'BoxConstraint',10);
SVMModel = fitcsvm(Tr.X,Tr.y,'KernelFunction','rbf','KernelScale',81,'Standardize', 'on',  'Verbose', 1, 'BoxConstraint',10);
%SVMModel = fitcsvm(Tr.X,Tr.y,'KernelFunction','rbf','KernelScale',8,'Standardize', 'on',  'Verbose', 1, 'BoxConstraint',1);

%%
[svmPred,score] = predict(SVMModel,Te.X);


%% See prediction performance
fprintf('Plotting performance..\n');

methodNames = {'SVM'}; % this is to show it in the legend
[avgSVM, aucSVM{k}, fprSVM{k}, tprSVM{k}] = evaluateMultipleMethods( Te.y > 0, [score(:,2)], true, methodNames );

%savegraph(20, 15, 'graphs/ROC_SVM2');


avgSVM


SVMResults(k)     = avgSVM(1);


disp(' Number K = ');
disp(k);

end
%%
save('SVMResultsAll', 'SVMResults','aucSVM','fprSVM', 'tprSVM' );


