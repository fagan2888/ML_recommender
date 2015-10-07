seed = 8000;
rng(seed);

addpath(genpath('toolbox/'));
addpath(genpath('RandomforestToolbox/'));
addpath(genpath('persondetectionTrain'));

% Load features
load train_feats;


% Generation of feature vectors
fprintf('Generating feature vectors..\n');
D = numel(feats{1});  % feature dimensionality
X = zeros([length(feats) D]);

for i=1:length(feats)
    X(i,:) = feats{i}(:);  % convert to a vector of D dimensions
end


% K-fold : we do a 10-fold and store all results for further analysis and ROC curves
fprintf('Splitting into train/test..\n');

K = 10;
ind = crossvalind('Kfold', size(X,1), K);

RTResults = zeros(1,K);
SVMResults = zeros(1,K);


for k = 1:K


Tr.idxs = ind~=k;

Tr.X = X(Tr.idxs,:);
Tr.y = labels(Tr.idxs);

Te.idxs = ind==k;
Te.X = X(Te.idxs,:);
Te.y = labels(Te.idxs);

% Training Random Forest training and prediction

%B = TreeBagger(80, Tr.X, Tr.y, 'NPrint', 1, 'NVarToSample', 90);
B = TreeBagger(120, Tr.X, Tr.y, 'NPrint', 1);
[predRT,scoresRT] = predict(B,Te.X);


% Prediction and ROC performance
fprintf('Computing and plotting performance..\n');


methodNames = {'Random Tree'};
[avgRT, aucRT{k}, fprRT{k}, tprRT{k}] = evaluateMultipleMethods( Te.y > 0, [scoresRT(:,2)], false, methodNames );

%
%savegraph(20, 15, 'graphs/ROC_RT');


avgRT

%Store all average in RTResults
RTResults(1,k)  = avgRT(1)


disp(' Number K = ');
disp(k);

end
%%
save('RTResultsAll', 'RTResults','aucRT','fprRT', 'tprRT' );
