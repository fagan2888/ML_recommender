function [X_trans] = transform(X)
X_trans = spfun(@log,X);
