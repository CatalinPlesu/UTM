% optiune de reprezentare (rep=0) grafic unic, (rep>0) grafice separate 
tmax=2; % timpul maxim de reprezentare
fi=pi/2; % faza componentei secundare
f1=8; % frecventa componentei primare
f2=13; % frecventa componentei secundare
% pasul utilizat la reprezentarea grafica
pasmic=0.001;
fes=10; % frecventa de esantionare
rep=1;
tes=1/fes; % perioada esantioanelor 
a1=2.4;
a2=1.3;
t=0:pasmic:tmax;
% pregatirea graficului 1 (semnal original)
y=a1*cos(2*pi*f1*t)+a2*cos(2*pi*f2*t-fi); 
t1=0:tes:tmax;
n=round(tmax/tes)+1;
% pregatirea graficului 2 (esantionarea)
y1=a1*cos(2*pi*f1*t1)+a2*cos(2*pi*f2*t1-fi);
% pregatirea graficului 3 (reconstituire)
y2=y1(1)*sinc(t/tes);
for k=1:(n-1) 
y2=y2+y1(k+1)*sinc(t/tes-k);
end
if rep>0 
 subplot(4,1,1) 
 plot(t,y) % trasarea graficului 1 (semnal) 
 hold on 
 ylabel('Original') 
 title('ESANTIONAREA SEMNALELOR')
 plot([0 tmax],[0 0]) 
 for i=1:n
 subplot(4,1,2)
% trasarea graficului 2 (esantionarea)
 plot([t1(i) t1(i)],[0 y1(i)],'b:')
 hold on 
 ylabel('Esantionat') 
plot([0 tmax],[0 0])
end 
 subplot(4,1,3)
% trasarea graficului 3 (reconstituire)
 plot(t,y2,'k')
hold on 
plot([0 tmax],[0 0]) 
for i=1:n
plot([t1(i) t1(i)],[0 y1(i)],'b:') 
 end 
 ylabel('Reconstituire') 
 subplot(4,1,4) 
% trasarea graficului 4 (diferente)
 plot(t,y-y2,'r')
 hold on 
plot([0 tmax],[0 0]) 
 ylabel('Diferente') 
 xlabel('Timp(s)') 
else
 plot(t,y) % trasarea graficului 1 (semnal) 
hold on
plot([0 tmax],[0 0]) 
for i=1:n
% trasarea graficului 3 (reconstituire)
 plot([t1(i) t1(i)],[0 y1(i)],'b:') 
end 
 plot(t,y2,'k')
% trasarea graficului 4 (diferente)
 plot(t,y-y2,'r') 
plot([0 tmax],[0 0]) 
title('ESANTIONAREA SEMNALELOR') 
ylabel('Semnal(albastru)/Reconstituire(negru)/Diferente(rosu)')
 xlabel('Timp(s)') 
end

