function [Rsplit] = generateStrongSplit(Y, R, K)

rng(9000);

indexes = crossvalind('Kfold', size(Y,1), K);
Rsplit = zeros(size(R));
for k=1:K
    idx = find(indexes==k); %users that will be in the test group for this i
    fun = @(x) k;
    Rsplit(idx,:) = spfun(fun, R(idx,:));
end;
Rsplit = sparse(Rsplit);