% Programul P4_2
% Rspunsul propriu al filtrului de frecvenюг joasг.
clf;
M=2;
num=ones(1,M)/M;
w=0:pi/255:pi;
h=freqz(num,1,w); %Frequency response of digital filter
g=20*log10(abs(h));
plot(w/pi,g); grid
axis([0 1 -50 0.5]);
xlabel('\omega /\pi'); ylabel('Adaugare');
title(['M = ',num2str(M)]);
