clear;
%parametrii trenului de impulsuri
T = input('Setati perioada T [sec]: ');
tau = input('Setati durata impulsului tau [sec]: ');
Amplit = input('Setati amplitudinea A [V]: ');
Ni = input('Setati nr. de armonici N: ');
% Pasul de selectare a numarului de armonici
n=Ni;
% numarul de armonici pentru aproximarea finala
Nf=3*n;
w0=2*pi/T;
f0=1/T;
B=Nf+1;
% calculul parametrilor modelului spectral
A=zeros(1,B);phi=zeros(1,B);
for i=1:B,
    alf=(i-1)*w0*tau/2;
 
    alf=alf/pi;
    A(1,i)=abs(Amplit*tau*sinc(alf)/T);
    phi(1,i)=-angle(sinc(alf));
end;
%se calculeaza vectorul ind, necesar in reprezentarea grafica a spectrului
for i=1:B,
    ind(i)=(i-1)*f0;
end;
%reprezentarea spectrului SFC (numai pentru frecvente pozitive)
subplot(221);
stem(ind,A(1,:));
title('spectrul SFC al trenului de impulsuri');
xlabel('f [Hz]');
grid;
subplot(222);
stem(ind,phi(1,:));
title('defazajele Fi(f)');
xlabel('f [Hz]'); ylabel('x pi [rad]');
grid;
%generarea trenului de impulsuri si reprezentarea lui grafica
x1=zeros(1,((T*1000/2)-(tau*1000/2)));
x2=Amplit*ones(1,(tau*1000));
x3=zeros(1,((T*1000/2)-(tau*1000/2)));
x=[x1 x2 x3];
dt=0.001;t=[-T/2+dt:dt:T/2];
subplot(223);
h=plot(t,x); %set(h,'LineWidth',T);
axis([-T/2 T/2 -1.5 1.2*Amplit]);grid;hold on;
%calculul semnalelor deduse pe baza spectrului determinat
%se utilizeaza Ni, 2*Ni si 3*Ni armonici in spectru;
%aceste semnale se reprezinta pe un grafic comun
%cu cel al trenului de impulsuri
for j=Ni:n:Nf,
    xy=A(1)*ones(1,(T*1000));
    
    for i=1:j,
        xy=xy+2*A(1,i+1)*cos(i*w0*t+phi(1,i+1));
    end;
end;
plot(t,xy,'k');grid;
title('semnalul initial si reconstruit');
xlabel('t [sec]');
axis([-T/2 T/2 -1.5 1.2*Amplit]);grid;
