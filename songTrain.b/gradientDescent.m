%function[ret] = ALSWR (Ytrain)
nonZero = Y~=0;
locWtM = full(sum(nonZero, 1))';
locWtU = full(sum(nonZero, 2));
Nf = 30;
lambda = 0.01;%0.01;
%init M
M = rand(Nf, size(Y, 2)); %14k
M = M';
U = rand(Nf, size(Y, 1)); %2k
U = U';
num_features = Nf;
num_users = size(Y,1);
num_movies = size(Y,2);
%M(1,:) = mean(Y,1);
%        M: X - num_movies  x num_features matrix of movie features
%        U: Theta - num_users  x num_features matrix of user features
initial_parameters = [U(:); M(:)];
options = optimset('GradObj', 'on', 'MaxIter', 200);
theta = fmincg (@(t)(cofiCostFunc(t, Y', R', size(Y,1), size(Y,2), ...
                                Nf, lambda)), ...
                initial_parameters, options);
            
M = reshape(theta(1:num_movies*num_features), num_movies, num_features);
U = reshape(theta(num_movies*num_features+1:end), ...
                num_users, num_features);
            
[L, LR] = computeCost(U, M, Y, lambda, locWtU, locWtM)
