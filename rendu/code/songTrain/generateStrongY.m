function[Yret, mu] = generateStrongY (Y, Rtr, Rte, U, M, friends, mu, dim, featuresFun)
%averaging the features of their friends
[Yret, mu] = featuresFun(Y, Rtr, Rte, U, M, friends, mu, dim);