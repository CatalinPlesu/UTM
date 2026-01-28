f=4;
t=0:0.000001:2;
phase=0;
A=2;
arg=2*pi*f*t-phase;
x=A*cos(arg)+5;
plot(t,x);
grid;
