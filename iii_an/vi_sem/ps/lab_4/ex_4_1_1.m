fs=8000;
t = 0 : 1/fs : 1024/fs;
s1 = 0.5*sin(2*pi*50*t);
s2 = 0.2*sin(2*pi*230*t+pi/3);
stem(t,s1 + s2);