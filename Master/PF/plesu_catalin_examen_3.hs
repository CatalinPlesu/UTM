-- listToInt :: [Int] -> listToInt

mult10Add a b = a*10+b
(🔴) = mult10Add
listToInt xs = foldl (🔴) 0 xs

-- listToInt [x] = x
-- listToInt (x:xs) = x * 10 ^ (length xs) + listToInt xs
