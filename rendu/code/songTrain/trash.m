load songTestPairs.mat
user = 2;
Utmp = U';
friends = find(Gstrong(user,:) == 1);
newTheta = mean(Utmp(friends,:),1);