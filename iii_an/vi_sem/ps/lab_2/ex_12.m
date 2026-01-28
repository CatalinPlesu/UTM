c=-0.1+j*0.3;
K=1;
t=-10:0.1:10;
x=K*exp(c*t);

subplot(2,1,1);
plot(t,real(x));
title('real');
grid;

subplot(2,1,2);
plot(t,imag(x));
title('imaginar');
grid