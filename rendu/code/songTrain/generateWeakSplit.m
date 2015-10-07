function [Rsplit] = generateWeakSplit(Y, R, K)

rng(90000);
[~, N] = size(Y);
Rsplit = zeros(size(Y));
for artist=1:N
    nonzero = find(R(:,artist)~=0); %indexes of users that have a hit for that artist
    if (length(nonzero)>=K)
        idx = crossvalind('Kfold', length(nonzero), K);
        Rsplit(R(:,artist),artist) = idx;
    end;
end;
Rsplit = sparse(Rsplit);