function [errorTe, errorTr] = CVstrong(Y, params, Ytrain, R, Rsplit, K, Nf, lambda, step, minFun, featuresFun)
    errorTe = zeros(K, 1);
    errorTr = zeros(K, 1);
   
    %placeholder
    locWtT = 0;
    locWtX = 0;
    for i = 1:K
       % separate 2 sets
       Rte = Rsplit==i;
       Rtr = Rsplit~=i .* R;
       
       fprintf('fold %d: teSize=%d trSize=%d\n', i, full(sum(sum(Rte))), full(sum(sum(Rtr))));
       
       [U,M] = minFun(Y, Rtr, Nf, lambda, step);
       Utest 
       Yte = recomposeYMatrix( U * M', params);
       Rte = recomposeRMatrix( Rte, params);
       Rtr = recomposeRMatrix( Rtr, params);
       errorTe(i, :) = computeCVCost(Yte, Ytrain, Rte, locWtT, locWtX);
       errorTr(i, :) = computeCVCost(Yte, Ytrain, Rtr, locWtT, locWtX);
       fprintf('Te error: %f, Tr error: %f\n', errorTe(i, :),errorTr(i, :));

    end 
end