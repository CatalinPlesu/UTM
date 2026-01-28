% Programul P2_6
% Realizarea cascadelor
clf;
x=[1 zeros(1,40)]; % Generarea semnalului de intrare 
n=0:40;
% Coeficientii sistemului de gradul 4
den=[1 1.6 2.28 1.325 0.68];
num=[0.06 -0.19 0.27 -0.26 0.12];
% calcularea semnalului de ieasire a sistemului de gradul 4
y=filter(num,den,x);
% Coeficientii sistemelor de gradul 2
num1=[0.3 -0.2 0.4]; den1=[1 0.9 0.8];
num2=[0.2 -0.5 0.3]; den2=[1 0.7 0.85];
% Semnalul de iesire y1[n] a primei etape a cascadei
y1=filter(num1,den1,x);
% Semnalul de iesire y2[n] etapei a doua a cascadei
y2=filter(num2,den2,y1);
% abaterea dintre y[n] si y2[n]
d=y-y2;
% Graficele semnalelor de iesire si a abaterii
subplot(3,1,1);
stem(n,y);
ylabel('Amplituda');
title('afisarea realizarii de gradul 4'); grid;
subplot(3,1,2);
stem(n,y2);
ylabel('Amplituda');
title('Afisarea realizarii cascada'); grid;
subplot(3,1,3);
stem(n,d);
xlabel('Timpul n'); ylabel('Amplituda ');
title('semnalul abaterii'); grid;
