import Data.List
-- Lucrarea de laborator nr. 6
-- Student: Plesu Catalin
-- Profesor: Zgureanu Aureliu
--
-- Exercitii:
-- 1. Definiti o functie care calculeaza valoarea lui e^x utilizand seria Maclaurin:
-- Solutia va trebui sa neglijeze termenii mai mici de 10-6 ai seriei.
-- Ajutor: puteti folosi functiile zipWith si takeWhile.

expMaclaurin x = sum terms
  where
    terms = takeWhile (> 1e-6) [x^n / fromIntegral (factorial n) | n <- [0..]]

factorial 0 = 1
factorial n = n * factorial (n - 1)

-- 2. Definiti o functie digits :: Integer -> Integer astfel incat digits n sa returneze numarul de cifre al celui mai mic multiplu, m, al lui n, cu proprietatea ca m se scrie in baza zece folosind doar cifra 1. 
-- De exemplu:
-- > digits 9901
-- 12
-- > digits 3
-- 3
-- > digits 7
-- Conditia simplificata: primul multiplu al lui n foramt doar din cifra 1. Apoi calculati numarul de cifre al acestuia.

onesList = [read (replicate n '1') :: Integer | n <- [1..]]
digits n = head [x | x <- onesList, x > n]

-- 3. Considerati urmatorul algoritm pentru generarea unei secvente de numere. Se porneste de la un numar natural n oarecare. Daca n este par se imparte la 2, alfel se inmulteste cu 3 si se adauga 1. Repetati pana cand se ajunge la voarea 1. De exemplu pentru n=22 se obtine urmatoarea secventa: 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1. 
collatz 1 = [1]
collatz n
  | even n = n : collatz (n `div` 2)
  | odd n = n : collatz (n*3 + 1)
-- Definiti o functie solve :: Int -> Int -> (Int, Int, Int) care dandu-se doua numere i si j va returna o tripleta de forma (i, j, k) unde k este lungimea secventei maxime, generate conform algoritmului de mai sus, considerandu-se ca punct de start, pe rand, toate numere din intervalul [i..j]. 
-- De exemplu:
-- > solve 1 10
-- (1,10,20)
-- > solve 100 200
-- (100,200,125)
-- > solve 201 210
-- (201,210,89)
-- > solve 900 1000
-- (900,1000,174)
solve i j = (i, j, maximum [ length $ collatz x | x <- [i..j] ])
-- 4. Definiti o functie isJumper :: [Int] -> Bool care testeaza daca o lista de n > 0 numere indeplineste conditia ca valoarea absoluta a diferentei dintre elemente succesive ia toate valorile din intervalul [0..n-1]. O astfel de lista este [1,4,2,3] deoarece diferentele absolute sunt 3, 2 si respectiv 1. Se va sonsidera ca orice lista cu un singur element indeplibeste conditia.
-- > isJumper [1,4,2,3]
-- True
-- > isJumper [1,4,2,-1,6]
-- False
delta xs = sort [abs $ fst d - snd d | d<- zip xs $ tail xs]
isJumper xs = xsLn == dtLn
  where
    xsLn = length xs
    dtLn = (length $ filter (\x -> (fst x + 1) == snd x) jumper) + 2
    dt = delta xs
    jumper = zip dt $ tail dt 
-- 5. Definiti o functie care, dandu-se o lista de numere intregi si un numar intreg, returneaza un sir de caractere reprezentand o expresie matematica formata din numerele din lista si operatorii +, -, *, / ce se evalueaza la valoarea celui de-al doilea argument, in cazul in care e posibil, altfel returneaza sirul vid. Sunt permise doar operatii cu numere intregi (se utilizeaza impartirea doar daca rezultatul e intreg). 
-- Exemplu:
-- > solve [2,4,5,9,75] 658
-- "(2*(9+(4*(5+75))))"
-- > solve [9,1,4,8] 26
-- ""
-- > solve [9,1,4,8] (-17)
-- "(1-((9*8)/4))"

-- prea complicat
