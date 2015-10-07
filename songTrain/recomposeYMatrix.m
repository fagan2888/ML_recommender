function [ret] = recomposeYMatrix(Y, R, params, artists, dim)
ret = zeros(size(Y,1), artists);

%recenter
if (dim == 0)
    ret = Y; %we didn't change anything
elseif (dim == 1)
    for i = 1:size(Y,1)
        idx = find(R(i,:) ~= 0);
        Y(i, idx) = Y(i, idx)*params.sd(i) + params.mu(i);
    end
else
    for i = 1:size(Y,2)
        idx = find(R(:,i) ~= 0);
        Y(idx, i) = Y(idx, i)*params.sd(i) + params.mu(i);
    end
end;

ret(:,params.indexes) = Y;
ret = sparse(exp(ret));
