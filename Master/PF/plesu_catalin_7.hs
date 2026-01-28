import System.IO
import Data.List
-- Lucrarea de laborator nr. 7
-- Tema de laborator: Intrările și ieșirile
-- Student: Plesu Catalin
-- Profesor: Zgureanu Aureliu
--
-- Exercitii:
-- 1. Scrieti o actiune IO() care concateneaza 2 fisiere a caror nume se citeste de la tastatura.
ex1 :: IO ()
ex1 = do
    putStrLn "Introduceti numele primului fisier"
    file1 <- getLine
    putStrLn "Introduceti numele celui de-al doilea fisier:"
    file2 <- getLine
    putStrLn "Introduceti numele fisierului nou"
    outputFile <- getLine

    contents1 <- readFile file1
    contents2 <- readFile file2

    writeFile outputFile (contents1 ++ contents2)
    putStrLn "Fisierele probabil au fost concatenate!"

-- 2. Definiti o actiune IO() readSort, care citeste numere intregi, de la tastatura, de pe linii succesive pana la intalnirea unei linii ce nu contine un intreg. Dupa citirea ultimei linii valide trebuie sa afiseze numerele sub forma unei secvente ordonate.

readListEx2 :: (Integral a, Read a) => [a] -> IO [a]
readListEx2 xs = do
    putStrLn "Introduceti un numar intreg sau enter pentru a finisa:"
    line <- getLine
    if null line
        then return xs
        else (do
            new_xs <- readListEx2 $ xs ++ (read line : [])
            return new_xs
        )

readSort :: IO ()
readSort = do
    list <- readListEx2 []
    putStrLn $ show $ sort list

-- 3. Construiti un joc de x si zero folosind biblioteca grafica Graphics.SOE (opțional)

checkWin board = 
    rowWin || colWin || diagWin
  where
    ((a1, a2, a3), (b1, b2, b3), (c1, c2, c3)) = board
    rowWin = (validLine [a1, a2, a3] && a1 == a2 && a2 == a3) || 
             (validLine [b1, b2, b3] && b1 == b2 && b2 == b3) || 
             (validLine [c1, c2, c3] && c1 == c2 && c2 == c3)
    colWin = (validLine [a1, b1, c1] && a1 == b1 && b1 == c1) || 
             (validLine [a2, b2, c2] && a2 == b2 && b2 == c2) || 
             (validLine [a3, b3, c3] && a3 == b3 && b3 == c3)
    diagWin = (validLine [a1, b2, c3] && a1 == b2 && b2 == c3) || 
              (validLine [a3, b2, c1] && a3 == b2 && b2 == c1)
    validLine :: [Char] -> Bool
    validLine line = not (elem ' ' line)

updateBoard board line symbol = case (row, col) of
    (1, 1) -> ((symbol, a2, a3), (b1, b2, b3), (c1, c2, c3))
    (1, 2) -> ((a1, symbol, a3), (b1, b2, b3), (c1, c2, c3))
    (1, 3) -> ((a1, a2, symbol), (b1, b2, b3), (c1, c2, c3))
    (2, 1) -> ((a1, a2, a3), (symbol, b2, b3), (c1, c2, c3))
    (2, 2) -> ((a1, a2, a3), (b1, symbol, b3), (c1, c2, c3))
    (2, 3) -> ((a1, a2, a3), (b1, b2, symbol), (c1, c2, c3))
    (3, 1) -> ((a1, a2, a3), (b1, b2, b3), (symbol, c2, c3))
    (3, 2) -> ((a1, a2, a3), (b1, b2, b3), (c1, symbol, c3))
    (3, 3) -> ((a1, a2, a3), (b1, b2, b3), (c1, c2, symbol))
    _ -> board  
  where
    ((a1, a2, a3), (b1, b2, b3), (c1, c2, c3)) = board
    row = read (words line !! 0) :: Int
    col = read (words line !! 1) :: Int 

printBoard board = do
    putStrLn (show a)
    putStrLn (show b)
    putStrLn (show c)
    where
        (a, b, c) = board

xo :: ((Char, Char, Char), (Char, Char, Char), (Char, Char, Char)) -> Char -> IO ()
xo board turn = do
    if checkWin board then (do
        printBoard board
        putStrLn "You have won"
        return ()
        )
        else (do
            printBoard board
            putStrLn ("Is " ++ [turn] ++ "'s turn:")
            line <- getLine
            xo (updateBoard board line turn) (if turn == 'X' then 'O' else 'X')
        )

xoGameStart = do
    putStrLn "Acesta este un joc x si 0"
    putStrLn "Introduceti coordonatele pentru elementul amplasat prin spatiu"
    putStrLn "Primul numar pentru rand si al doilea pentru coloana"
    xo ((' ', ' ', ' '), (' ', ' ', ' '), (' ', ' ', ' ')) 'X'
