function [errorTe, errorTr, Yprev, U, M] = CVweak(Y, params, Ytrain, R, Rsplit, K, Nf, lambda, step, dim, minFun)
    errorTe = zeros(K, 1);
    errorTr = zeros(K, 1);
    Yprev = zeros(size(Ytrain));
    %placeholder
    locWtT = 0;
    locWtX = 0;
    for i = 1:K
       % separate 2 sets
       Rte = Rsplit==i;
       Rtr = Rsplit~=i & Rsplit~=0;
       
       fprintf('fold %d: teSize=%d trSize=%d\n', i, nnz(Rte), nnz(Rtr));
       Ytr = Y.*Rtr;
       [Ynorm, params.mu, params.sd] = normalize(Ytr, Rtr, dim);
       [Yret, U, M] = minFun(Ynorm, Rtr, Nf, lambda, step);

       Yte = recomposeYMatrix( Yret, Rsplit, params, size(Ytrain,2), dim);
       Rte = recomposeRMatrix( Rte, params, size(Ytrain,2));
       Rtr = recomposeRMatrix( Rtr, params, size(Ytrain,2));
       errorTe(i, :) = computeCVCost(Yte, Ytrain, Rte, locWtT, locWtX);
       errorTr(i, :) = computeCVCost(Yte, Ytrain, Rtr, locWtT, locWtX);
       
       %used for the plot of the prev vs real
       Yprev = Yprev + Yte.*Rte;
       
       fprintf('Te error: %f, Tr error: %f\n', errorTe(i, :),errorTr(i, :));

    end 
end

