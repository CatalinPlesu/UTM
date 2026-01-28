t=0:1/60:2;
x=sawtooth(4*pi*t,0.5);
subplot(2,1,1), plot(t,x);
subplot(2,1,2), stem(t,x);
