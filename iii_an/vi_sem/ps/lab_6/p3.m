% Programul P4_3
% Punctele zero FIR filtrelor in faza liniara
clf;
b=[1 -8.5 30.5 -63];
num1=[b 81 fliplr(b)];
num2=[b 81 81 fliplr(b)];
num3=[b 0 -fliplr(b)];
num4=[b 81 -81 -fliplr(b)];
n1=0:length(num1)-1;
n2=0:length(num2)-1;
subplot(2,2,1); stem(n1,num1);
xlabel('Timpul n'); ylabel('Amplituda'); grid
title('Tipul 1 FIR filtrului');
subplot(2,2,2); stem(n2,num2);
xlabel('Timpul n'); ylabel('Amplituda'); grid
title('Tip 2 FIR filtrului');
subplot(2,2,3); stem(n1,num3);
xlabel('Timpul n'); ylabel('Amplituda'); grid
title(' Tip 3 FIR filtrului ');
subplot(2,2,4); stem(n2,num4);
xlabel('Timpul n'); ylabel('Amplituda'); grid
title('Tip 2 FIR filtrului');
%pause
figure(2)
subplot(2,2,1); zplane(num1,1);
title(' Tip 1 FIR filtrului ');
subplot(2,2,2); zplane(num2,1);
title(' Tip 2 FIR filtrului ');
subplot(2,2,3); zplane(num3,1);
title('Tip 3 FIR filtrului');
subplot(2,2,4); zplane(num4,1);
title('Tip 4 FIR filtrului');
disp('Zeroul FIR filtrului de Tip 1');
disp(roots(num1));
disp(' Zeroul FIR filtrului de Tip 2');
disp(roots(num2));
disp(' Zeroul FIR filtrului de Tip 3');
disp(roots(num3));
disp(' Zeroul FIR filtrului de Tip 4');
disp(roots(num4));
