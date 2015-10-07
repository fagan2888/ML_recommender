function [Yret, mu] = directFriendsAverage (Y, Rtr, Rte, U, M, friends, mu, dim)
%finding the test indexes
count = sum(Rte, 2);
idx = find(count);

%averaging over the features of the friends
for user=1:length(idx)
    %U
    friendsIdx = find(friends(idx(user),:));
    features = U(friendsIdx,:);
    if (nnz(features))
        U(idx(user),:) = sum(features, 1)/(nnz(features)/size(features,2));
        if (dim == 1)
            %mu(idx(user)) = mean(mu(friendsIdx));
        else
            
        end;
    end;
    %mean
end

Yret = U * M';