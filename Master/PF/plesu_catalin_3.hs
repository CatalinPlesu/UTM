import Data.Bits
-- Lucrarea de laborator nr. 3
-- Tema de laborator: Clasele de baza din Haskell
-- Student: Plesu Catalin
-- Profesor: Zgureanu Aureliu
-- 
-- Exercitii:
-- 1. Scrieti o functie powers cu proprietatea ca powers n = [n^1, n^2, n^3,...]
powers n = go 1 n
  where
    go acc n = n^acc : go (acc+1) n

-- 2. Definiti o functie longest care returneaza cele mai lungi cuvinte dintr-o propozitie(String).
-- Exemplu:
-- > longest “examples of functional algorithms”
-- [“functional”, “algorithms”]
-- Ajutor: puteti folosi functia de biblioteca words.
longest propozitie = recLongest (words propozitie)

recLongest [] = error "This is empty"
recLongest [c] = [c]
recLongest (c:cs) = c 📏 (recLongest cs)

longestWord a bs
  | ord == LT = bs
  | ord == EQ = a : bs
  | ord == GT = [a]
  where ord = compare (length a) (length (head bs))

a 📏 bs = a `longestWord` bs

-- 3. Scrieti o functie care calculeaza intersectia a doua multimi(liste).
-- Ajutor: puteti folosi functia de librarie elem
intersection as bs = filter (`elem` as) bs

-- 4. Scrieti o functie care transforma o lista de valori Bool intr-un numar intreg, considerand lista
-- ca fiind reprezentarea lui in baza 2. De exemplu: [True, True, False] se va evalua la 6.
intreg bs = sum [ 2 ^ (fst b) | b <- zip [0..] (reverse bs), snd b]
sase = intreg [True, True, False]

-- Scrieti apoi functia inversa.
binary 0 = [False]
binary 1 = [True]
binary i = binary (div i 2) ++ [(if mod i 2 == 1 then True else False)]

-- 5. Scrieti o functie care calculeaza cel mai mare divizor comun a doua numere.
a ⏫ b = gcd a b

-- 6. Implementati unul din algoritmii de sortare cunoscuti. Datele se vor reprezenta sub forma de lista.
mergeSort xs ord 
  | length xs == 1 = xs
  | length xs == 2 = merge (take 1 xs) (drop 1 xs) ord
  | otherwise = merge (mergeSort as ord) (mergeSort bs ord) ord
  where 
    as = take (length xs `div` 2) xs
    bs = drop (length xs `div` 2) xs

merge [] xs ord = xs
merge xs [] ord= xs
merge (x:xs) (y:ys) ord
  | (compare x y) == ord = x:merge xs (y:ys) ord
  | otherwise = y:merge (x:xs) ys ord

-- 7. Scrieti o functie ce evalueaza expresii sub forma poloneza postfixata. Expresia de calculat va fi transmisa functiei sub forma unui sir de caractere. 
-- Exemplu: “1 2 3 + *” se va evalua la 7, adica 1+2*3 “ 1 3 + 2 *” se va evalua la 8, adik (1+3)*2

-- prea complicat
