import Data.Char 
-- Lucrarea de laborator nr. 5
-- Tema de laborator: List comprehension
-- Student: Plesu Catalin
-- Profesor: Zgureanu Aureliu
--
-- Exercitii:
-- 1. Scrieti o functie pythagoreans care calculeaza toate tripletele (x,y,z) cu proprietatea x2+y2=z2, unde x, y, z sunt pana la o limta data. De exemplu:
-- > pythagoreans 10
-- [(3,4,5),(4,3,5),(6,8,10),(8,6,10)]

-- triplete care elimina triunghiurile congruente
triplete a1 a2 b1 b2 c1 c2 = [(a,b,c)| a<-[a1..a2],b<-[b1..b2],c<-[c1..c2], a<=b, b<=c]

-- triplete pentru care laturile x si y sunt mereu mai mici ca z, ca in exemplu
triplete' a1 a2 b1 b2 c1 c2 = [(a,b,c)| a<-[a1..a2],b<-[b1..b2],c<-[c1..c2], a <= c, b<=c]

trDrept xs = [(a,b,c) | (a,b,c) <- xs, a^2 + b^2 ==c^2||a^2 + c^2 ==b^2 ||c^2 + b^2 ==a^2]

pythagoreans n = trDrept $ triplete' 1 n 1 n 1 n


-- 2. Un numar natural se numeste perfect daca este egal cu suma divizorilor sai, excluzandu-se pe sine. Folosind list comprehension, definiti o functieperfects::Int->[Int] care o lista cu toate numere perfecte panal la o anumita limita. De exemplu:
-- > perfects 500
-- [6,28,496]

divisors n = [x | x <- [1..n], n `mod` x == 0]
perfect n = [x | x <- [2..n], (sum . init $ divisors x) == x]

-- ghci> perfect 50000
-- [6,28,496,8128^CInterrupted.

-- 3. Implementati cifrul lui Cezar. Se vor define 2 functii encode pentru criptare si decode pentru decriptare.
-- Ajutor: folositi functiile chr si ord

encode xs n = [chr $ ord x + n | x <- xs]
decode xs n = [chr $ ord x - n | x <- xs]
