function U = update(Y, R, M, Nf, locWtU, lambda)
%Nf: number of features
%n_mi number of ratings for artist i
%locWtM: vector of n_mi
Nlu = size(Y,1); %number of users
lamI = lambda * eye(Nf);
lU = zeros(Nf,Nlu); 
%lM = single(lM); 
for u = 1:Nlu
    artists = find(R(u,:)); %only takes the relevant cells
    if (~isempty(artists))
        Mu = M(:, artists); %removes empty cells
        vector = Mu * full(Y(u, artists))';
        matrix = Mu * Mu' + locWtU(u) * lamI; 
        X = matrix \ vector;
        lU(:, u) = X;
    end;
end
%M = gather(darray(lM));
U = lU;