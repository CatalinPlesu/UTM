t=0:0.1:256;
f=1/50;
phase=pi/3;
A=1;
arg=2*pi*f*t-phase;
x=A*cos(arg);
plot(t,x);
grid;
axis([0 256 -1.5 1.5]);