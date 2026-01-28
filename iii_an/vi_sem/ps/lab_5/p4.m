
% Programul P2_4
% Generarea secventelor de intrare
clf; n=0:40; D=10; a=3.0; b=-2;
x=a*cos(2*pi*0.1*n)+b*cos(2*pi*0.4*n);
xd=[zeros(1,D) x];
num=[2.2403 2.4908 2.2403]; den=[1 -0.4 0.75];
ic=[0 0]; % setarea conditiilor initiale 
%Calcularea semnalului de iesire y[n]
y=filter(num,den,x,ic);
% Calcularea semnalului de iesire yd[n]
yd=filter(num,den,xd,ic);
% Calcularea semnalului deabatere d[n]
d=y-yd(1+D:41+D);
%Afisarea graficelor semnalelor de iesire
subplot(3,1,1);
stem(n,y);
ylabel('Amplituda');
title('Semnalul de iesire y[n]'); grid;
subplot(3,1,2);
stem(n,yd(1:41));
ylabel('Amplituda');
title(['iesirea,la intirzierea semnalului la intrare x[n',num2str(D),']']); grid;
subplot(3,1,3);
stem(n,d);
xlabel('Timpul n'); ylabel('Amplituda');
title('semnalul de abatere'); grid;
