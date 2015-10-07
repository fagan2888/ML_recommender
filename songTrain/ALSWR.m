function[Yret, U, M] = ALSWR (Y, R, Nf, lambda, step)
locWtM = full(sum(R, 1))';
locWtU = full(sum(R, 2));
%init M
M = rand(Nf, size(Y, 2));
M(1,:) = mean(Y,1);
n = 200;
L = zeros(2*n,1);
LR = zeros(2*n,1);

i = 1;
for index=1:n
    U = update(Y, R, M, Nf, locWtU, lambda);
    [L(i), LR(i)] = computeCost(U', M', Y, R, lambda, locWtU, locWtM);
    %'U:'
    %LR(i)

    M = update(Y', R', U, Nf, locWtM, lambda);
    [L(i+1), LR(i+1)] = computeCost(U', M', Y, R, lambda, locWtU, locWtM);
    %'M:'
    %LR(i+1)
    
    %testing
    if(i>2 && ((LR(i-1) - LR(i+1))/LR(i-1) < step)  ) %0.0001
        LR(i+1)
        i
        break;
    end;
    if (i>2)
        fprintf('%i, %f, %f, %f%% maxU: %f, maxM: %f\n',index, LR(i), LR(i+1), (LR(i-1) - LR(i+1))/LR(i-1)*100, max(max(U)), max(max(M)));
    end;
    i = i+2;
end;
%returns in the standard format
U = U';
M = M';
Yret = U * M';




