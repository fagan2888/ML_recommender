
seed = 8000;
rng(seed);


addpath(genpath('toolbox/'));
addpath(genpath('RandomforestToolbox/'));
addpath(genpath('persondetectionTrain'));

load train_feats;


% -- Generate feature vectors (so each one is a row of X)
fprintf('Generating feature vectors..\n');
D = numel(feats{1});  % feature dimensionality
Xtest = zeros([length(feats) D]);

for i=1:length(feats)
    Xtest(i,:) = feats{i}(:);  % convert to a vector of D dimensions
end



Tr.Xfold = Xtest;
Tr.yfold = labels;



% SVM

%SVMModelKfold = fitcsvm(Tr.Xfold,Tr.yfold,'KernelFunction','rbf','KernelScale',90,'Standardize', 'on',  'Verbose', 1, 'BoxConstraint', 10, 'Kfold', 5);
SVMModelKfold = fitcsvm(Tr.Xfold,Tr.yfold,'KernelFunction','rbf','KernelScale',90,'Standardize', 'on',  'Verbose', 1, 'BoxConstraint', 10);
%
save('SVMModelBasicKfolded', 'SVMModelKfold');

%
load('test_feats');
load('SVMModelBasicKfolded');


fprintf('Generating feature vectors..\n');
D = numel(feats{1});  % feature dimensionality
Xtest = zeros([length(feats) D]);

for i=1:length(imgs)
    Xtest(i,:) = feats{i}(:);  % convert to a vector of D dimensions
end

save('XtestKfolded', 'Xtest');

%% Predict 
load('XtestKfolded');

[svmPredTest,Ytest_score] = predict(SVMModelKfold,Xtest);

save('PredictionsKfold2', 'svmPredTest', 'Ytest_score');
Ytest_score2 = Ytest_score;
save('personPredKfold2', 'Ytest_score2');

%%
methodNames = {'SVM'}; % this is to show it in the legend

avgTest = evaluateMultipleMethods( svmPredTest > 0, [Ytest_score(:,2)], true, methodNames );
avgTest

%% Predicting on train to see if it is OK
fprintf('Generating feature vectors..\n');
load('train_feats');
D = numel(feats{1});  % feature dimensionality
Xtesttrain = zeros([length(imgs) D]);

for i=1:length(imgs)
    Xtesttrain(i,:) = feats{i}(:);  % convert to a vector of D dimensions
end
%%
[svmPredTestTrain,scoreTestTrain] = predict(SVMModelKfold,Xtesttrain);

save('PredictionsTrain', 'svmPredTestTrain', 'scoreTestTrain');

%%
differ = svmPredTestTrain - labels;
nbMissed = length(find(differ==-2)); 
nbRealPerson = length(find(labels==1));
TPR = (nbRealPerson-nbMissed)/nbRealPerson

nbFail = length(find(differ==2));
nbRealEmpty = length(find(labels==-1));
FPR = nbFail/nbRealEmpty


%% See prediction performance
fprintf('Plotting performance..\n');
randPred = rand(size(Te.y));

% and plot all together, and get the performance of each
methodNames = { 'Random', 'SVM'}; % this is to show it in the legend
avgTPRList = evaluateMultipleMethods( Te.y > 0, [randPred, scores(:,2)], true, methodNames );

savegraph(20, 15, 'graphs/ROC_all2');


avgTPRList




