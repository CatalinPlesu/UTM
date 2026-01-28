figure(1)
fs=8000;
t = 0 : 1/fs : 1024/fs;
x = 0.5*sin(2*pi*50*t)+0.2*sin(2*pi*230*t+pi/3);
stem(t,x);
xlabel('t, s');, ylabel('A, V');

figure(2)
fs=90;
t = 0 : 1/fs : 2;
x = 3*cos(2*pi*3*t);
stem(t,x);
xlabel('t, s');, ylabel('A, V');
%A=3V,f=3Hz, fs=90 Hz, phi=0 

figure(3)
fs=3000;
t = 0 : 1/fs : 128/fs;
x = 10*sin(pi*200*t+pi/2)+20*sin(pi*100*t)-40*sin(pi*300*t-pi/4);
stem(t,x);
xlabel('t, s');, ylabel('A, V');

figure(4)
fs=4;
t = 0 : 1/fs : 2;
x = 3*sin(2*pi*5*t);
subplot(2,1,1);, stem(t,x);
xlabel('t, s');, ylabel('A, V');,title('fs=4 Hz');
fs=50;
t = 0 : 1/fs : 2;
x = 3*sin(2*pi*5*t);
subplot(2,1,2);, stem(t,x);
xlabel('t, s');, ylabel('A, V');,title('fs=50 Hz');

figure(5)
t=0:1/60:2;
x=sawtooth(12.566*t,0.5);
subplot(2,1,1), plot(t,x);
title('Semnalul');, xlabel('Timpul t');, ylabel('Amplitudinea');
subplot(2,1,2), stem(t,x);
title('Semnalul esantionat');, xlabel('Timpul t');, ylabel('Amplitudinea');

