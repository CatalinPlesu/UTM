% Programul P2_7
clf;
h=[3 2 1 -2 1 0 -4 0 3]; % raspuns de impuls
x=[1 -2 3 -4 3 2 1]; % secventa de intrare 
y=conv(h,x);
n=0:14;
subplot(2,1,1);
stem(n,y);
xlabel('Timpul n'); ylabel('Amplituda');
title('Semnalul de iesire,obtinut in urma convolutiei'); grid;
x1=[x zeros(1,8)];
y1=filter(h,1,x1);
subplot(2,1,2); 
stem(n,y1); 
xlabel('Timpul n'); ylabel('Amplituda');
title('Semnalul de iesire obtinut in urma filtrarii'); grid;