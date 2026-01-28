-- Lucrarea de laborator nr. 2
-- Tema de laborator: Variabile, tipuri de date
-- Student: Plesu Catalin
-- Profesor: Zgureanu Aureliu
--
-- Exercitii:
-- 1. Care este tipul urmatoarelor date:
--    ['a', 'b', 'c']
a1s :: [Char] -- sau String
a1s = ['a', 'b', 'c']
--    ('a', 'b', 'c')
a2s :: (Char, Char, Char)
a2s = ('a', 'b', 'c')
--    [(False, 'O'), (True, '1')]
a3s :: [(Bool, Char)]
a3s = [(False, 'O'), (True, '1')]
--    ([False, True], ['0', '1'])
a4s :: ([Bool], String)
a4s = ([False, True], ['0', '1'])
--    [tail, init, reverse]
a5s :: [[a] -> [a]]
a5s = [tail, init, reverse]
-- 2. Functia
   -- map :: (a -> b) -> [a] -> [b]
-- aplica o alta functie pe toate elementele unei liste, rezultand o noua lista. Scrieti o definitie echivalenta e functiei de librarie length folosind functia map.
xTo1 x = 1
length'map xs = sum (map xTo1 xs)
-- Scrieti o functie mapAll asemanatoare cu map, dar care primeste o lista de functii ca prim argument.
map' function as = [ function a | a <- as]
-- nu este posibil ca tipul returnat de functia interioara a map sa returneze un tip diferit, fiind ca urmatoarea functie se va astepta tot sa opereze pe un tip a nu b.
mapAll :: [(a -> a)] -> [a] -> [a]
mapAll [] xs = xs
mapAll (f:fs) xs = mapAll fs (map f xs) 
-- mapAll (f:fs) xs = map f (mapAll fs xs)

double x = x*2
add25 x = x+25
divide3 x = x/3
roundTo2 x = fromIntegral (round (x * 100)) / 100
calculation = mapAll [double, add25, divide3, roundTo2] [1..25]

-- 3. Scrieti o functie Haskell care testeaza daca un numar intreg este palindrom.
palindrom :: (Integral a, Show a) => a -> Bool
palindrom i = isPalindrom (show i)
isPalindrom xs = 
   sum [if xs !! i == xs !! (length xs - 1 - i) then 1 else 0 | 
   (i, x) <- zip [0..] xs] == length xs
-- 4. Definiti o functie
block :: Int -> [a] -> [[a]]
-- astfel incat block n xs imparte xs in blocuri de n elemente. De exemplu:
   -- block 3 “hello clouds” = [“hel”, “lo ”, “clo”, “uds”]
block n xs = [xx| xx <- block' n xs, length xx /= 0]
block' n xs 
   | length xs < n = [xs] -- Base case
   | otherwise = take n xs : block n (drop n xs)
blocks = block 3 "hello clouds"


-- 5. Turnurile din Hanoi. Se dau trei tije si n discuri de diferite dimensiuni, stivuite pe tija STANGA în ordine descrescatoare a dimensiunilor lor, formând un <turn> ca în figura. Sa se scrie o functie Haskell care care calculeaza cate mutari sunt necesare pentru a muta cele n discuri de pe tija STANGA pe tija DREAPTA, astfel încât ele sa fie ordonate ca la început.
-- Din fericire asta poate fi calculat cu formula 2^n - 1
hanoi n = 2^n - 1

-- Metoda recursiva:
-- src - sursa
-- dest - destinatia
-- work - tija de lucru
recHanoi n src dest work
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = recHanoi (n-2) src work dest + -- muta n-1 elemente la mijloc
                recHanoi 1 src dest work + -- muta ultimul element la destinatie
                recHanoi 1 src dest work + -- muta ultimul element la destinatie
                recHanoi 1 src dest work + -- muta ultimul element la destinatie
                recHanoi (n-2) work dest src -- muta elementele din mijloc la destinatie

testHanoi = [ (x, hanoi x == recHanoi x "Stanga" "Dreapta" "Mijloc") | x <- [1..10]]

-- Daca mai adaugam o tija cum se modifica strategia? Cate mutari sunt necesare de aceasta data?
-- https://codepen.io/eliortabeka/pen/yOrrxG
-- src - sursa
-- dest - destinatia
-- work1 - tija de lucru 1
-- work2 - tija de lucru 2
recHanoi4 n src dest work1 work2
  | n == 1 = 1
  | n == 2 = 3
  | otherwise = recHanoi4 (n-2) src work2 work1 dest + 
                recHanoi4 2 src dest work1 work2 + 
                recHanoi4 (n-2) work2 dest src work1
