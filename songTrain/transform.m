function [X_trans] = transform(X)
%removing outliers
hits = sum(X,1);
[u,m] = size(X);
for i=1:u
    idx = find(X(i,:));
    for j=1:length(idx)
        %removes all the data for artists having more than 85% of theirs
        %hits from the same user
        if (X(i,idx(j))/hits(idx(j)) > 0.85 && hits(idx(j)) > 5000)
            X(i,idx(j)) = 0;
        end;
    end;
end;

%log
X_trans = spfun(@log,X);
