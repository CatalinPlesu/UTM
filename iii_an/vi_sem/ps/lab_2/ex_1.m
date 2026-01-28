figure(1);

subplot(4,1,1);
n=-15 : 15 ;
y=zeros(size(n));
pos=round(size(n,2)/2, 0);
y(pos)=0.8;
stem(n,y);
xlabel('n'); ylabel('y(n)')

subplot(4,1,2);
n=1 : 20 ;
y=zeros(size(n));
pos=5-min(n)+1;
y(pos)=0.9;
stem(n,y);
xlabel('n'); ylabel('y(n)')

subplot(4,1,3);
n=300 : 350 ;
y=zeros(size(n));
pos=333-min(n)+1;
y(pos)=1.5;
stem(n,y);
xlabel('n'); ylabel('y(n)')

subplot(4,1,4);
n=-10 : 0;
y=zeros(size(n));
pos=abs(min(n))-7+1;
y(pos)=4.9;
stem(n,y);
xlabel('n'); ylabel('y(n)');

figure(2);

A=4;
subplot(3,1,1);
step=100;
t=-10:1/step:10;
U=[zeros(1,10*step),ones(1,10*step+1) * 4];
plot(t,U);
xlabel('t,s');ylabel('Amplitudine');
axis([-10 10 -0.5 4.5]);

subplot(3,1,2);
step=100;
t=-5:1/step:20;
U=[zeros(1,(5+7)*step),ones(1,(20-7)*step+1) * 1.4];
plot(t,U);
xlabel('t,s');ylabel('Amplitudine');
axis([-5 20 -0.1 1.5]);

subplot(3,1,3);
step=100;
t=-15:1/step:10;
U=[zeros(1,(15-5)*step),ones(1,(10+5)*step+1) * 2.3];
plot(t,U);
xlabel('t,s');ylabel('Amplitudine');
axis([-15 10 -0.2 2.5]);