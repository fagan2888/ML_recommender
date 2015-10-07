function [L, Ldata] = computeCVCost(Yte, Y, R, locWtT, locWtX)
%might change it
Yte = log(Yte);
Y = spfun(@log, Y);
%L = sqrt(0.5/nnz(R) * sum(sum((R .* (Yte - Y).^2))));
L =  1/nnz(R)*sum(sum(abs(R .* (Yte - Y))));

Ldata = abs(R .* (Yte - Y));

%{
i = 2
idx = find(R(i,:))
Yte(i,idx) - Y(i, idx)




%}