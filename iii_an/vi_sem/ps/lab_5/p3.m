% Programul P2_3
% Generarea secvenюelor de iesire
clf;
n=0:40;
a=2; b=-3;
x1=cos(2*pi*0.1*n);
x2=cos(2*pi*0.4*n);
x=a*x1+b*x2;
num=[2.2403 2.4908 2.2403];
den=[1 -0.4 0.75];
ic=[0 0]; % initializarea 
y1=filter(num,den,x1,ic); % Calcularea semnalului de iesire y1[n]
y2=filter(num,den,x2,ic); % Calcularea semnalului de iesire y2[n]
y=filter(num,den,x,ic); % Calcularea semnalului de iesire y[n]
yt=a*y1+b*y2;
d=y-yt; % calcularea abaterii d[n]
%Vizualizarea semnalelor de iesire si a semnalului de abatere
subplot(3,1,1);
stem(n,y);
ylabel('Amplituda ');
title('Semnalul de iesire, conform semnalului de intrare incarcat : a \cdot x_{1}[n] + b \cdot x_{2}[n]');
subplot(3,1,2);
stem(n,yt);
ylabel('Amplituda');
title('semnalul de iesire incarcat : a \cdot y_{1}[n] + b \cdot y_{2}[n]');
subplot(3,1,3);
stem(n,d);
xlabel('Timpul n'); ylabel('Amplituda');
title('semnalul diferential ');
