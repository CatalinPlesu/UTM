%Generarea semnalului impuls unitar dreptunghiular
Ts=0.01; T=1; A=0.85; w=0.5;
N=T/Ts;t=-T/2:Ts:T/2;
y=A*rectpuls(t,w);
subplot(311); plot(t,y); grid;
title('Impuls unitar dreptunghiular');
xlabel('Timpul,sec.');
%Aplicarea procedurii fft
x=fft(y)/N; df=1/T; Fm=1/Ts;
a=abs(x);f=0:df:Fm;
subplot(312); plot(f,a);grid;
title('Functia de densitate spectrala(procedura fft)');
xlabel('Frecventa,Hz');
ylabel('Modulul')
%Aplicarea procedurii fftshift
xp=fftshift(x);
a=abs(xp);f1=-Fm/2:df:Fm/2;
subplot(313);plot(f1,a),grid;
title('Functia de densitate spectrala(procedura fftshift)');
xlabel('Frecventa,Hz');
ylabel('Modulul')
