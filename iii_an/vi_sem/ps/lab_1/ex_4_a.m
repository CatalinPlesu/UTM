z = zeros(1,21);
z(6) = 1;
n = 0:20;
m = -5:15;

% Reprezentarea grafică a lui z în funcție de n=0:20
subplot(2,1,1);
stem(n, z);

% Reprezentarea grafică a lui z în funcție de m=-5:15
subplot(2,1,2);
stem(m, z);