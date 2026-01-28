clear;
clc;
Ts=0.01;T=10; t=0:Ts:T;
y=3.5*cos(2*pi*t)+sin(4*pi*t)+2.5*cos(4*pi*t);

figure(1)
subplot(3,1,1); plot(t,y); grid
df=1/T; Fm=1/Ts; len=length(t);
f=-Fm/2:df:Fm/2;
x=fft(y)/len;
xs=fftshift(x);
A=abs(xs);
s1=len/2-50; s2=len/2+50;
subplot(3,1,2); stem(f(s1:s2), A(s1:s2)); grid
xlabel('frecventa(Hz)'); ylabel('Modulul')
P=angle(xs);
subplot(3,1,3); stem(f(s1:s2), P(s1:s2)); grid
xlabel('frecventa(Hz)'); ylabel('Faza')

figure(2)
subplot(311); plot(t,y); grid
df=1/T; Fm=1/Ts; len=length(t);
f=-Fm/2:df:Fm/2;
x=fft(y)/len;
xs=fftshift(x);
Re=real(xs); Im=imag(xs);
s1=len/2-50; s2=len/2+50;
subplot(312)
plot(f(s1:s2),Re(s1:s2));grid
ylabel('Partea reala')
subplot(313)
plot(f(s1:s2),Im(s1:s2));grid
ylabel('Partea imaginara')