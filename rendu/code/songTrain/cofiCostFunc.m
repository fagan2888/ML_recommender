function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: M: X - num_movies  x num_features matrix of movie features
%        U: Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%





%{
for i=1:size(X,1)
    for j=1:size(Theta,1)
        J = J + R(i,j) * 0.5 * (Theta(j,:) * X(i,:)'-Y(i,j))^2;
    end;
end;
%}
nonZero = Y~=0;
locWtX = full(sum(nonZero, 2));
locWtT = full(sum(nonZero, 1))';

%J = 0.5 * sum(sum((R .* ((Theta * X')' - Y).^2))) + lambda/2 * (sum(sum(Theta.^2)) + sum(sum(X.^2)));
J =  0.5 * sum(sum((R .* ((Theta * X')' - Y).^2))) + lambda/2 * (sum(locWtT.*sum(Theta.^2,2),1) + sum(locWtX.*sum(X.^2,2),1));


parfor i=1:size(X,1)
    %X_grad = R .* (Theta * X')'
    tmp = find(R(i,:) == 1);
    thetatmp = Theta(tmp,:);
    Ytmp = Y(i,tmp);
    X_grad(i,:) = (X(i,:) * thetatmp' - Ytmp) * thetatmp + lambda*locWtX(i)*X(i,:);
end;

parfor i=1:size(Theta,1)
    tmp = find(R(:,i) == 1);
    Ytmp = Y(tmp,i);
    Xtmp = X(tmp,:);
    Theta_grad(i,:) = (Xtmp * Theta(i,:)' - Ytmp)' * Xtmp + lambda*locWtT(i)*Theta(i,:);
end;


% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
