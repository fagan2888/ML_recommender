function [X_norm, mu, sigma] = normalize(X, R, dim)
%{
mu = mean(X);
X_norm = bsxfun(@minus, X, mu);

sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);
%}
[m, n] = size(X);
mid = sum(sum(X))/nnz(X);
X_norm = ones(size(X))*mid;
if (dim == 0)
    X_norm = X; %we don't do anything
    sigma = 1;
    mu = 0;
elseif (dim == 1)
    mu = ones(size(X,1),1)*mid; %if there is no mean we center on the mean of the dataset
    sigma = ones(m, 1);
    for i = 1:m
        idx = find(R(i,:) == 1);
        if (~isempty(idx))
            mu(i) = mean(X(i, idx));
        end;
        %sd = std(X(i, idx));
        %if (sd >0 && sd < 50)
        %    sigma(i) = sd;
        %end;
        X_norm(i, idx) = (X(i, idx) - mu(i))/sigma(i);
    end
else
    mu = ones(1, n)*mid;
    sigma = ones(1, n);
    for i = 1:n
        idx = find(R(:,i) == 1);
        if (~isempty(idx))
            mu(i) = mean(X(idx, i));
        end;
        %sd = std(X(i, idx));
        %if (sd >0 && sd < 50)
        %    sigma(i) = sd;
        %end;
        X_norm(idx, i) = (X(idx, i) - mu(i))/sigma(i);
    end
end;
%sigma = 1; %placeholder
X_norm=sparse(X_norm);