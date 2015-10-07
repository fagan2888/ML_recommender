function[ret] = labelRow (X, labels, indexed)
if (indexed)
    ret = num2cell([X zeros(length(X),1)]);
    for i=1:length(X)
        ret{i,3} = labels(X(i,1));
    end;
else
    ret = 0
end;