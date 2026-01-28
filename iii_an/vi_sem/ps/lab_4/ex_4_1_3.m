fs=4000;
t = 0 : 1/fs : 200/fs;
x = 10*sin(pi*200*t+pi/2)+20*sin(pi*100*t)-40*sin(pi*300*t-pi/4);
stem(t,x);
