function [L, LR] = computeCost(Theta, X, Y, R, lambda, locWtT, locWtX)
%the R should be given but in this case we can infer it
L = 0.5 * sum(sum((R .* ((Theta * X') - Y).^2)));
LR = 0.5 * sum(sum((R .* ((Theta * X') - Y).^2))) + lambda/2 * (sum(locWtT.*sum(Theta.^2,2),1) + sum(locWtX.*sum(X.^2,2),1));
