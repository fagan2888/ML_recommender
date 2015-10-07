function [errorTe, errorTr, U, M] = CVweak(Y, params, Ytrain, R, Rsplit, K, Nf, lambda, step, minFun)
    errorTe = zeros(K, 1);
    errorTr = zeros(K, 1);
   
    %placeholder
    locWtT = 0;
    locWtX = 0;
    for i = 1:K
       % separate 2 sets
       Rte = Rsplit==i;
       Rtr = Rsplit~=i & Rsplit~=0;
       
       fprintf('fold %d: teSize=%d trSize=%d\n', i, full(sum(sum(Rte))), full(sum(sum(Rtr))));
       
       [Yret, U, M] = minFun(Y, Rtr, Nf, lambda, step);
       Yte = recomposeYMatrix( Yret, params, size(Ytrain,2));
       Rte = recomposeRMatrix( Rte, params, size(Ytrain,2));
       Rtr = recomposeRMatrix( Rtr, params, size(Ytrain,2));
       errorTe(i, :) = computeCVCost(Yte, Ytrain, Rte, locWtT, locWtX);
       errorTr(i, :) = computeCVCost(Yte, Ytrain, Rtr, locWtT, locWtX);
       fprintf('Te error: %f, Tr error: %f\n', errorTe(i, :),errorTr(i, :));

    end 
end