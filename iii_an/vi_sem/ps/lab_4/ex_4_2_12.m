n = 1:0.01:40;
x=17./n;
figure(1)
x1 = round(x);
subplot(2,1,1), plot(n,x,n,x1);
xlabel('n'); ylabel('x[n]'); title('Semnalul cuantizat (metoda round)');
z=x-x1;
subplot(2,1,2), plot(n,z);
xlabel('n'); ylabel('x[n]-xq[n]'); title('Zgomot (metoda round)');
figure(2)
x1 = floor(x);
subplot(2,1,1), plot(n,x,n,x1);
xlabel('n'); ylabel('x[n]'); title('Semnalul cuantizat (metoda floor)');
z=x-x1;
subplot(2,1,2), plot(n,z);
xlabel('n'); ylabel('x[n]-xq[n]'); title('Zgomot (metoda floor)');
 
y=-17./n;
figure(3)
y1 = round(y);
subplot(2,1,1), plot(n,y,n,y1);
xlabel('n'); ylabel('x[n]'); title('Semnalul cuantizat (metoda round)');
z=y-y1;
subplot(2,1,2), plot(n,z);
xlabel('n'); ylabel('x[n]-xq[n]'); title('Zgomot (metoda round)');
figure(4)
y1 = floor(y);
subplot(2,1,1), plot(n,y,n,y1);
xlabel('n'); ylabel('x[n]'); title('Semnalul cuantizat (metoda floor)');
z=y-y1;
subplot(2,1,2), plot(n,z);
xlabel('n'); ylabel('x[n]-xq[n]'); title('Zgomot (metoda floor)');