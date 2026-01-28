n1 = -15:25;
n2 = 0:50;
x1 = sin((pi/17)*n1);
x2 = cos((pi/sqrt(23))*n2);

plot(n1, x1);
hold
plot(n2, x2);
title('x1 si x2')

uiwait(gcf); 

subplot(2,1,1);
plot(n1, x1);
title('x1')
subplot(2,1,2);
plot(n2, x2);
title('x2')

uiwait(gcf);

stem(n1, x1);
hold
stem(n2, x2);
title('x1 si x2')


uiwait(gcf);

subplot(2,1,1);
stem(n1, x1);
title('x1')
subplot(2,1,2);
stem(n2, x2);
title('x2')