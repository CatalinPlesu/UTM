c=[1 13 -7 1 -1];
dc=polyder(c);
vx=[-2 -1.3 0.1 2.45];
format short g
der=polyval(dc,vx)
x=-2:0.1:3; df=polyval(dc,x);
plot(x,df)