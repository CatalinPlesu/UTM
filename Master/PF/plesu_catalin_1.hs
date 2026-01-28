-- Lucrarea de laborator nr. 1
-- Tema de laborator: Evaluarea expresiilor. Funcții elementare
-- Student: Plesu Catalin
-- Profesor: Zgureanu Aureliu
--
-- Exercitii:
-- 1. Cum adaugati 4 la sfarsitul listei [1,2,3] ?
initList = [1..3]
newList = initList ++ [4]
-- 2. Gasiti cel putin 2 definitii echivalente pentru functia de librarie `last` (returneaza ultimul element al unei liste nevide), folosind functiile explicate in acest laborator.
shortLength list = length list - 1

last'1 list = head (reverse list)
last'2 list = list !! shortLength list
last'3 list = head (drop (shortLength list) list)
-- 3. Gasiti cel putin 2 definitii echivalente pentru functia de librarie `init` (sterge ultimul element dintr-o lista nevida), folosind functiile explicate in acest laborator.
init'1 list = take (shortLength list) list
init'2 list = reverse (drop 1 (reverse list))
init'3 list = reverse (tail (reverse list))
-- 4. Scrieti o functie `fib n` care returneaza al n-lea element din sirul lui fibonacci. Scrieti o functie `fibonacci n` care returneaza lista cu primele n elemente din sirul lui fibonacci (folosind, eventual, functia `fib`).
fib 0 = 0
fib 1 = 1
fib n = fib(n-1) + fib(n-2)

fibonacci 0 = []
fibonacci 1 = [0]
fibonacci n = fibonacci (n-1) ++ [fib (n-1)]
