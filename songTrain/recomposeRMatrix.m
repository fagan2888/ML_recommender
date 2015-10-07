function [ret] = recomposeRMatrix(R, params, artists)
ret = zeros(size(R,1), artists);
ret(:,params.indexes) = R;

%recenter
for i = 1:size(R,1)
    idx = find(ret(i,:) ~= 0);
end

ret = sparse(ret);
