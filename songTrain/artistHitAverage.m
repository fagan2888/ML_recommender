function [Yret, mu] = artistHitAverage (Y, Rtr, Rte, U, M, friends, mu, dim)
%finding the test indexes
count = sum(Rte, 2);
idx = find(count);

artistMean = mean(Y, 1);
Y(idx,:) = ones(length(idx),1) * artistMean;
Yret = Y;