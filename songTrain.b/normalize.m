function [X_norm, mu, sigma] = normalize(X, R)
%{
mu = mean(X);
X_norm = bsxfun(@minus, X, mu);

sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);
%}
[m, n] = size(X);
mu = zeros(m, 1);
sigma = ones(m, 1);
X_norm = zeros(size(X));
for i = 1:m
    idx = find(R(i,:) == 1);
    mu(i) = mean(X(i, idx));
    %sd = std(X(i, idx));
    %if (sd >0 && sd < 50)
    %    sigma(i) = sd;
    %end;
    X_norm(i, idx) = (X(i, idx) - mu(i))/sigma(i);
end
%sigma = 1; %placeholder
X_norm=sparse(X_norm);