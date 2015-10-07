function[ret] = filterCell (X, predicate)
ret = num2cell(zeros(size(X)));
index = 1;
for i=1:size(X,1)
    if (predicate(X(i,:)))
        ret(index,:) = X(i,:);
        index = index + 1;
    end;
end;
ret = ret(1:(index-1),:);