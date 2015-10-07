function [L] = computeCVCost(Yte, Y, R, locWtT, locWtX)
%might change it
L = sqrt(0.5/nnz(R) * sum(sum((R .* (Yte - Y).^2))));
