function [ret] = recomposeYMatrix(Y, params, artists)
ret = zeros(size(Y,1), artists);

%recenter
for i = 1:size(Y,1)
    idx = find(Y(i,:) ~= 0);
    Y(i, idx) = Y(i, idx)*params.sd(i) + params.mu(i);
end

ret(:,params.indexes) = Y;
ret = sparse(ret);
