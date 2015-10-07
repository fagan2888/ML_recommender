function[ret, indexes] = filter (X, predicate)
ret = zeros(size(X));
index = 1;
for i=1:size(X,1)
    if (predicate(X(i,:)))
        indexes(index) = i;
        ret(index,:) = X(i,:);
        index = index + 1;
    end;
end;
ret = ret(1:(index-1),:);
ret = sparse(ret);