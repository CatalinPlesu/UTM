t = [0:0.001:1];
y1 = 5*exp(-6*t);
y2 = exp(5*t);

figure(1)
plot(t, y1);
grid

figure(2)
plot(t, y2);
grid