% Programul P2_5
% calcularea impulsului de raspuns y
clf;
N=40;
num=[2.2403 2.4908 2.2403];
den=[1 -0.4 0.75];
y=impz(num,den,N);
% Reprezentarea grafica a impulsului de raspuns 
stem(y);
xlabel('Timpul n'); ylabel('Amplituda');
title('Impulsul de raspuns'); grid;
