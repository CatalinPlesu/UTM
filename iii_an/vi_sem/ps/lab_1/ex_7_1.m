x=[-2 -1.5 0 0.5 2.5 3];
y=[6 9 11 10 7 5];

%a) difrente progresive
prog=diff(y)./diff(x);
vx=[-2 0 2.5];
for i=1:length(vx)
    k=find(x==vx(i));
    disp(['f''(' num2str(vx(i)) ') = ' num2str(prog(k))])
end

%b) diferente regresive
regr=diff(y)./diff(x);
vx=[-1.5 0 3];
for i=1:length(vx)
    k=find(x==vx(i));
    disp(['f''(' num2str(vx(i)) ') = ' num2str(regr(k-1))])
end

%c) diferente centrate

dx = diff(x);
dy = diff(y);
k = length(dx);
centr=(dy(1:k-1)+dy(2:k))./(dx(1:k-1)+dx(2:k));

vx=[-0.75 0.25 0.5 1];
for i=1:length(vx)
    k=find(x==vx(i));
    disp(['f''(' num2str(vx(i)) ') = ' num2str(centr(k))])
end

figure(1)
plot(prog)

figure(2)
plot(regr)

figure(3)
plot(centr)