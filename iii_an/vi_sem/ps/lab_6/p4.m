clf;
den = input('Introduceti coeficientii de numitor:');
ki = poly2rc(den);
disp('Parametrii testului de stabilitate: ');
disp(ki);
if max(abs(ki)) < 1
    fprintf('Filtrul este stabil.\n');
else
    fprintf('Filtrul nu este stabil.\n');
end
zplane(roots(den));
