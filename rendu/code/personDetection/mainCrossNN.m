% Trains a neural network model, with a 10-fold validation.
% Stores the results in cells to be reused by generateROC


rng(seed);

addpath(genpath('toolbox/'));
addpath(genpath('persondetectionTrain'));
addpath(genpath('DeepLearnToolbox-master/'));
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


for k = 1:K


Tr.idxs = ind~=k;

Tr.X = X(Tr.idxs,:);
Tr.y = labels(Tr.idxs);

Te.idxs = ind==k;
Te.X = X(Te.idxs,:);
Te.y = labels(Te.idxs);

%% Training of the network
fprintf('Training simple neural network..\n');


% Setup of the network with two hidden layers of respectively 200 and 20
% neurons. 2 classes at the end
nn = nnsetup([size(Tr.X,2) 200 20 2]);
opts.numepochs =  15;   %  Number of sweeps through data
opts.batchsize = 100;  %  Nb of samples

% set to 1 if plot wanted
opts.plot               = 0; 

nn.learningRate = 2;
nn.activation_function = 'sigm'; %using a sigmoid activation function


% this neural network implementation requires number of samples to be a
% multiple of batchsize, so we remove some for this to be true.
numSampToUse = opts.batchsize * floor( size(Tr.X) / opts.batchsize);
Tr.XNeural = Tr.X(1:numSampToUse,:);
Tr.yNeural = Tr.y(1:numSampToUse);

% normalize data
[Tr.normX, mu, sigma] = zscore(Tr.XNeural); % train, get mu and std

% prepare labels for NN
LL = [1*(Tr.yNeural>0)  1*(Tr.yNeural<0)];  % first column, p(y=1)
                                   % second column, p(y=-1)

[nn, L] = nntrain(nn, Tr.normX, LL, opts);


Te.normX = normalize(Te.X, mu, sigma);  % normalize test data

% to get the scores we need to do nnff (feed-forward)
%  see for example nnpredict().
nn.testing = 1;
nn = nnff(nn, Te.normX, zeros(size(Te.normX,1), nn.size(end)));
nn.testing = 0;

% predict on the test set
nnPred = nn.a{end};
nnPred
% we want a single score, subtract the output sigmoids
nnPred = nnPred(:,1) - nnPred(:,2);

nnPredAll{k} = nnPred;


%% Prediction and ROC performance
fprintf('Computing and plotting performance..\n');

% plot and get performance
methodNames = {'Neural Network'}; 
[avgNeural, aucNN{k}, fprNN{k}, tprNN{k}] = evaluateMultipleMethods( Te.y > 0, [nnPred], false, methodNames );


savegraph(20, 15, 'graphs/ROC_NN');

%Performance for FPR between 0.001 and 0.01 for this k
avgNeural

%neural Results contains all the average for every k. 
neuralResults(1,k)  = avgNeural(1);


disp(' Number K = ');
disp(k);

end
%%
save('neuralResultsAll', 'neuralResults','aucNN','fprNN', 'tprNN' );
