x = 1:1:100;
y = 2:2:200;

figure(1)
% a) 
stem(x,y), xlabel('x'), ylabel('y')

figure(2)
%b)
plot(x,y), xlabel('x'), ylabel('y')

figure(3)
%c)
stem(x,y)
hold on
plot(x,y, 'r'), xlabel('x'), ylabel('y')

figure(4)
%d)
subplot(2,1,1)
stem(x,y)
subplot(2,1,2)
plot(x,y)