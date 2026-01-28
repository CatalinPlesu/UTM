F = 50;

figure(1)
t1 = 0:0.001:0.2;
s1 = 2*sin(2*pi*F*t1);
plot(t1,s1,'.-'), xlabel('Timp [s]'), grid, title('t1 = 0.001')

figure(2)
t2 = 0:0.01:0.2;
s2 = 2*sin(2*pi*F*t2);
plot(t2,s2,'.-'), xlabel('Timp [s]'), grid, title('t2 = 0.01')

figure(3)
t3 = 0:0.0002:0.2;
s3 = 2*sin(2*pi*F*t3);
plot(t3,s3,'.-'), xlabel('Timp [s]'), grid, title('t3 = 0.0002') 

figure(4)
F2 = 20;
c = 2*cos(2*pi*F2*t3);
plot(t3,s3,'b.-'), xlabel('Timp [s]'), grid, title('t3 = 0.0002')
hold on
plot(t3,c,'r.-'), xlabel('Timp [s]'), grid, title('t3 = 0.0002')