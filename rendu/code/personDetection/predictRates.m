load('SVMResultScores');
rng(seed);

%% K-fold
fprintf('Splitting into train/test..\n');

K = 10; %The K-fold
ind = crossvalind('Kfold', size(X,1), K);
Tr.idxs = ind~=1;

Tr.X = X(Tr.idxs,:);
Tr.y = labels(Tr.idxs);

Te.idxs = ind==1; %1 out of 10
Te.X = X(Te.idxs,:);
Te.y = labels(Te.idxs);

SVMModel = fitcsvm(Tr.X,Tr.y,'KernelFunction','rbf','KernelScale',100,'Standardize', 'on',  'Verbose', 1);
[svmPred,score] = predict(SVMModel,Te.X);

%%
diff = svmPred - Te.y;
%the -2 correspond to the time where we predict -1 and the true value is 1:
%-2 => we missed one
% the 2 happens when we predict 1 and the true value is -1: false positive

nbMissed = length(find(diff==-2)); 
nbRealPerson = length(find(Te.y==1));
TPR = (nbRealPerson-nbMissed)/nbRealPerson

nbFail = length(find(diff==2));
nbRealEmpty = length(find(Te.y==-1));
FPR = nbFail/nbRealEmpty