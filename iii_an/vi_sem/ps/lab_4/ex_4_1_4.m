fs=4;
t = 0 : 1/fs : 2;
x = 3*sin(2*pi*5*t);
subplot(2,1,1); stem(t,x);
 
fs=50;
t = 0 : 1/fs : 2;
x = 3*sin(2*pi*5*t);
subplot(2,1,2); stem(t,x);
