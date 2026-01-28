for j=1:11
    x(j)= -1.1 + 0.1 * j;
    y(j)=( (j*(x(j))^2) / (x(j)-1) ) - 2/(j+1);
end
I=trapz(x,y)