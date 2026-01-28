clear;
%Descompunerea unui semnal periodic s(t) in serie Fourier:
%T=perioada [sec], N=nr. de armonici
T = input('Setati perioada T [sec]: ');
N = input('Setati nr. de armonici: ');
tip = input('Alegeti tipul semnalului (sin[s], dreptunghiular[d], sau ferestrau[f]): ', 's');
W=2*pi/T; %pulsatia fundamentala
t=0:T/1022:T+T/1022;
if strcmp(tip,'s')
    s=sin(W*t); % semnal s(t) sinusoidal
else
    for j=1:1024
        if strcmp(tip,'d')
            if j<512 %semnal dreptunghiular
                s(j)=1;
            else
                s(j)=-1;
            end
        elseif strcmp(tip,'f')
            %semnal dinte de ferestrau
            s(j)=j/500-1;
        end
    end
end
%valoarea medie
val_medie=trapz(t,s)/T;
%valoarea efectiva
val_efectiva=sqrt(trapz(t,s.^2)/T);
timp=t-T/2;
for i=1:N
    %primii N coef. trigonometrici
    a(i)=2*trapz(t,s.*cos(i*W*t))/T;
    b(i)=2*trapz(t,s.*sin(i*W*t))/T;
    %coeficientii formei armonice
    A(i)=sqrt(a(i)^2+b(i)^2);
    %defazajele formei armonice
    F(i)=atan2(b(i),a(i));
    f(i)=i/T;
end
r=val_medie;
for j=1:N
    r=r+A(j)*cos(j*W*t-F(j));
end
subplot(223); plot(t,r);
title('semnalul reconstruit (verificare)');
xlabel('t [sec]');
axis([min(t) max(t) (min(r)-0.02*(max(r)-min(r))) (max(r)+0.02*(max(r)-min(r)))]);
grid;
subplot(221); plot(t,s);
title('semnalul s(t)'); xlabel('t [sec]'); grid;
axis([min(t) max(t) (min(r)-0.02*(max(r)-min(r))) (max(r)+0.02*(max(r)-min(r)))]);
subplot(222); stem(f,A);
title('Armonicile A(n)*cos[n*2*pi*f*t-Fi(n)]');
xlabel('f [Hz]'); grid;
subplot(224); stem(f,F/(pi));
title('defazajele Fi(f)'); xlabel('f [Hz]');
ylabel('x pi [rad]');
grid;
