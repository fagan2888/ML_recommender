function [Rsplit] = generateStrongSplit(Y, K)

rng(9000);
R = Y~=0; %1 if there is measure, empty otherwise

indexes = crossvalind('Kfold', size(Y,1), K);
Rsplit = zeros(size(R));
for k=1:K
    idx = find(indexes==k); %users that will be in the test group for this i
    fun = @(x) k;
    Rsplit(idx,:) = spfun(fun, R(idx,:));
end;
Rsplit = sparse(Rsplit);