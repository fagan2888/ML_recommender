function M = updateM(Y, U, Nf, locWtM, lambda)
%Nf: number of features
%n_mi number of ratings for artist i
%locWtM: vector of n_mi
Nlm = size(Y,2); %number of artists
lamI = lambda * eye(Nf);
lM = zeros(Nf,Nlm);
lM = singles(lM);
%lM = single(lM); 
for m = 1:Nlm
    users = find(Y(:,m)); %non-empty rows aka users with measurements
    if (~isempty(users))
        Um = U(:, users); %removes empty cells
        vector = Um * full(Y(users, m));
        matrix = Um * Um' + locWtM(m) * lamI; 
        X = matrix \ vector;
        lM(:, m) = X;
    else
        'branch'
    end;
end
%M = gather(darray(lM));
M = lM;
size(M)