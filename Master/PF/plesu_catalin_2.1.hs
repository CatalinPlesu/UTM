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
