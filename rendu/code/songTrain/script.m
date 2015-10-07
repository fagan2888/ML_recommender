%% init
clear
load songTrain.mat;
X = Ytrain;
[i,j]=ind2sub(size(X'), 1:numel(X));
X = [j(:) i(:) reshape(X',[],1)];
B = sortrows(X,3);
C = flipud(full(B(end-1000:end,:)));

%% hit counts 
%by artist
artistHit = full(sum(Ytrain, 1))';
[sorted, index] = sortrows(artistHit);
artistHit = flipud([index sorted]);
artistHit = labelRow(artistHit,artistName, true);
%by user
userHit = full(sum(Ytrain, 2));
[sorted, index] = sortrows(userHit);
userHit = flipud([index sorted]);

%% specific user check
tmp = full(Ytrain(331,:));
test = labelCol(tmp, artistName, false);
user = flipud(sortrows(filterCell(test', @(x) x{1}~=0),1));

%% specific artist check
tmp = full(Ytrain(:,4140));
[i,j]=ind2sub(size(tmp'), 1:numel(tmp));
tmp = [j(:) i(:) reshape(tmp',[],1)];
artist = flipud(sortrows(tmp,3));

%% artists that have a lot of "outliers"
countSameArtist = zeros(length(C),2);
tmp = C(:,2);
index = 1;
for i = 1:length(tmp)
    if (isempty(find(countSameArtist(:,2) == C(i,2)))) 
        countSameArtist(index,:) = [sum(tmp==tmp(i)) tmp(i)];
        index = index+1;
    end
end

countSameArtist = countSameArtist(find(countSameArtist(:,1)~=0),:);
countSameArtist = flipud(sortrows(countSameArtist,1));

%% users that have a lot of "outliers"
countSameUser = zeros(length(C),2);
tmp = C(:,1);
index = 1;
for i = 1:length(tmp)
    if (isempty(find(countSameUser(:,2) == C(i,1)))) 
        countSameUser(index,:) = [sum(tmp==tmp(i)) tmp(i)];
        index = index+1;
    end
end

countSameUser = countSameUser(find(countSameUser(:,1)~=0),:);
countSameUser = flipud(sortrows(countSameUser,1));
