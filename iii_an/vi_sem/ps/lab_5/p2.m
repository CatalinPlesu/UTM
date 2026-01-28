% Programul P2_2
% generarea semnalului sinusoidal de intrare 
clf;
n=0:200;
x=cos(2*pi*0.05*n);
% Calcularea semnalului de iesire 
x1 = [x 0 0]; % x1[n] = x[n+1]
x2 = [0 x 0]; % x2[n] = x[n]
x3 = [0 0 x]; % x3[n] = x[n-1]
y=x2.*x2 + x1.*x3;
y=y(2:202);
% Vizualizarea semnalului de intre si a celui de iesire
subplot(2,1,1);
plot(n,x);
xlabel('Timpul n'); ylabel('Amplituda');
title('semnalul de intrare ');
subplot(2,1,2);
plot(n,y);
xlabel('Timpul n'); ylabel('Amplituda');
title('Semnalul de iesire');
