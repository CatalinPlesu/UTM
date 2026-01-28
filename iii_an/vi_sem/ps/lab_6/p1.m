%Programul P4_1
% raspunsul de impuls al filtrului ideal
clf;
fc=0.25; %frecventa de taiere
n=[-6.5:1:6.5]; %semnalul ca array
y=2*fc*sinc(2*fc*n); %semnalul filtrat
k=n+6.5;
plot(y,k);
stem(k,y); title('N=13'); axis([0 13 -0.2 0.6]);
xlabel('Timpul n'); ylabel('Amplituda'); grid
