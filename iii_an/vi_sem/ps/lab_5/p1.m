% Programul P2_1
% Simularea filtrului FIR de o lungime arbitrara
% generarea semnalului de intrare
clf; n=0:100;
s1=cos(2*pi*0.05*n); % semnal de o frecventa joasa
s2=cos(2*pi*0.47*n); % semnal de o frecventa inalta
x=s1+s2;
% Realiyarea filtrului FIR
M=input('Lungimea dorita a filtrului = ');
num=ones(1,M);
y=filter(num,1,x)/M;
% Afisarea semnalelor de intare si de isire
subplot(2,2,1);
plot(n,s1);
axis([0, 100, -2, 2]);
xlabel('Timpul n'); ylabel('Amplituda');
title('semnal #1');
subplot(2,2,2);
plot(n,s2);
axis([0, 100, -2, 2]);
xlabel('Timpul n'); ylabel('Amplituda');
title('semnal #2');
subplot(2,2,3);
plot(n,x);
axis([0, 100, -2, 2]);
xlabel('Timpul n'); ylabel('Amplituda');
title('Semnalul de intrare(suma semnal 1 si 2)');
subplot(2,2,4);
plot(n,y);
axis([0, 100, -2, 2]);
xlabel('Timpul n'); ylabel('Amplituda');
title('Semnalul de iesire');
axis;
