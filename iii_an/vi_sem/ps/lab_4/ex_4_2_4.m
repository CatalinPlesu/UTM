fs=8000;
t = 0 : 1/fs : 1024/fs;
x = 0.5*sin(2*pi*50*t)+0.2*sin(2*pi*230*t+pi/3);
figure(1)
N=256; %8 biti
x1 = floor((N-1)*x)/(N-1);
subplot(2,1,1), plot(t,x,t,x1);
xlabel('t(s)'); ylabel('A(V)'); title('Semnalul cuantizat pe 8 biti (metoda floor)');
N=65536; %16 biti
x1 = floor((N-1)*x)/(N-1);
subplot(2,1,2), plot(t,x,t,x1);
xlabel('t(s)'); ylabel('A(V)'); title('Semnalul cuantizat pe 16 biti (metoda floor)');
