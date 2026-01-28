t=-10:0.02:10;
r = 0.8;
B = 1;
x1 = B*r.^t;

arg=2*pi/12*t;
x2=2*sin(arg);

x3=x1.*x2;

plot(t,x3);
grid;