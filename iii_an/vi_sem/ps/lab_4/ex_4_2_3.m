z = 0.2*randn(1,15);
plot(z);
title('Semnalul original');
figure(2)
q=0.25;
zq = round(z/q)*q;
subplot(2,2,1), plot(zq);
title('Semnalul cuantizat (q=+-1/4)');
q=0.5;
zq = round(z/q)*q;
subplot(2,2,2), plot(zq);
title('Semnalul cuantizat (q=+-2/4)');
q=0.75;
zq = round(z/q)*q;
subplot(2,2,3), plot(zq);
title('Semnalul cuantizat (q=+-3/4)');
zq = round(z);
subplot(2,2,4), plot(zq);
title('Semnalul cuantizat (q=+-1)');