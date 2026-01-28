sumP :: Integer -> Integer -> Integer
sumP arg1 arg2 = sum [ x * x | x <- [low..high]]
  where
    low = min arg1 arg2
    high = max arg1 arg2

sumP'1 :: Integer -> Integer -> Integer
sumP'1 arg1 arg2 = sum [ x * x | x <- [low..high]]
  where
    low = min (arg1 + 1) (arg2 - 1)
    high = max (arg1 + 1) (arg2 - 1)
