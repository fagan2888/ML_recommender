%%
Sigma = X' * X / size(X, 1);
[U,S,V] = svd(Sigma);

disp('DONE');

%%
K = 2000;
Xtmp = X;
Z = zeros(size(X,1), K);
for i=1:size(X,1)   
    disp(i);
    Z(i,:) = Xtmp(i,:) * U(:,1:K);
end;