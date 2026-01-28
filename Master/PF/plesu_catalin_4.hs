import Data.List
import Data.Function (on)
-- Lucrarea de laborator nr. 4 
-- Tema de laborator: Moduri de definire a functiilor
-- Student: Plesu Catalin
-- Profesor: Zgureanu Aureliu
--
-- Exercitii:
-- 1. Se considera o functie safeTail::[a]->[a] ce se comporta similar cu functia de librarie tail, cu exceptia ca in cazul listei vide safeTail va returna aceeasi lista vida, pe cand tail genereaza
-- eroare. Definiti safeTail folosind:
   -- • o expresie conditionala
safeTail'1 xs = if length xs == 0 then [] else tail xs
   -- • “guarded ecuations”
safeTail'2 xs
   | length xs == 0 = []
   | otherwise = tail xs
   -- • “pattern matching”
safeTail'3 [] = []
safeTail'3 xs = tail xs
-- 2. Scrieti o functie subList care verifica daca o lista e inclusa in alta.
subList as bs = any (\a -> a) [as == take (length as) (drop i bs) | (i, b) <- zip [0..] bs, length bs - i >= length as]
-- 3. Definiti o functie pentru calculul produsului a 2 polinoame. Un polinom se va reprezenta prin lista coeficientilor.
p1s ❌ p2s = multiply p1s p2s

multiply xs [] = []
multiply [] xs = []
multiply xs ys = simplifyMultiplication $ bruteMultiply (coefAndPow xs) (coefAndPow ys)

coefAndPow xs = reverse $ zip (reverse xs) [0..]
bruteMultiply as bs = [ (fst a * fst b, snd a * snd b) | a <- as, b <- bs ]
uniquePowers xs = (reverse . sort . nub) [ snd x | x <- xs ]

simplifyMultiplication xs = [ (coefSum xs power, power) | power <- uniquePowers xs]
coefSum xs pow = sum [ fst $ xs !! i | i <- findIndices (\(_,x) -> x == pow) xs]

-- 4. Scrieti o functie pascal :: Int -> [Int] , unde pascal n returneaza randul n din triunghiul lui Pascal.

pascalRow 1 = [1]
pascalRow 2 = [1,1]
pascalRow n = 1 : [ a + b | (a, b) <- zip previous $ drop 1 previous] ++ [1]
   where
      previous = pascalRow $ n - 1 
