import Data.List

-- 1. Suma elementelor divizibile la 3 si 5

sumMond3_5 = sum [ x | x <- [1..499], mod x 3 == 0, mod x 5 == 0]


-- 2. Returneaza o lista de elemente adiacente dintr-o lista

list = [1..10]
addiacentElements [x]  = []
addiacentElements (x:xs) = (x, head xs) : addiacentElements(xs)

-- 3. Palindrom

palindrom :: (Integral a, Show a) => a -> Bool
palindrom i = isPalindrom (show i)
isPalindrom xs = 
   sum [if xs !! i == xs !! (length xs - 1 - i) then 1 else 0 | 
   (i, x) <- zip [0..] xs] == length xs

-- 4. Triunghiuri cu laturi impare < 5

triplete x = [(a,b,c)| a<-[1,3..x],b<-[1,3..x],c<-[1,3..x]]

triunghiuri xs = [(a,b,c)| (a,b,c) <- xs, a+b>c,a+c>b,c+b>a]

trPermutations (x, y, z) =
  [(x, y, z), (x, z, y), (y, x, z), (y, z, x), (z, x, y), (z, y, x)]

excludeList :: Eq a => [a] -> [a] -> [a]
excludeList xs excludes = filter (`notElem` excludes) xs

rmCongruentDuplicates [] = []
rmCongruentDuplicates [x] = [x]
rmCongruentDuplicates (x:xs) = x : rmCongruentDuplicates (excludeList xs (trPermutations x))

result4 = rmCongruentDuplicates (triunghiuri (triplete 25))

-- 5. Patrate cu regiuni
-- R: A B C D E
-- G: B C D E G H I
-- Y: C D G H F
-- B: D E H I J


checkSums :: [Int] -> Bool
checkSums [a,b,c,d,e,f,g,h,i,j] =
    let redSum = a + b + c + d + e
        greenSum = b + c + d + e + g + h + i
        yellowSum = c + d + g + h + f
        blueSum = d + e + h + i + j
    in redSum == greenSum && greenSum == yellowSum && yellowSum == blueSum

-- Function to find all valid assignments for A to J
findValidAssignments :: [[Int]]
findValidAssignments = filter checkSums (permutations [1..10])
