function[Yret, U, M] = artistAverage (Y, R, Nf, lambda, step)

[m, n] = size(Y);
mu = zeros(1, n);
Yret = ones(size(Y));
for i = 1:n
    idx = find(R(:,i) == 1);
    if (~isempty(idx))    
        mu(i) = mean(Y(idx, i));
    end;
    %Yret(i, :) = mu(i)*ones(1,size(Yret,2));
    if(mod(i,100) == 0)
        %fprintf('%f\n', i);
    end;
end

for i = 1:m
    Yret(i,:) = mu;
    if(mod(i,100) == 0)
        %fprintf('%f\n', i);
    end;
end;
    


%standard
U = 0;
M = 0;