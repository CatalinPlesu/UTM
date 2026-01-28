-- Ultimate Exam Practice
-- Exercises:

-- 1. How do you insert 10 at the second position in the list [5,15,20]?
origList = [5,15,20]
updatedList = head origList : 10 : drop 1 origList

-- 2. Define at least two equivalent versions of the library function `head` 
-- (returns the first element of a non-empty list) using only functions covered so far.

head'1 list = list !! 0
extract_single [x] = x
head'2 list = extract_single $ take 1 list

-- 3. Define at least two equivalent versions of the function `tail`
-- (removes the first element of a non-empty list) using only functions covered so far.

tail'1 list = drop 1 list
tail'2 (x:xs) = xs

-- 4. Write a function `sumEven n` that returns the sum of the first `n` even numbers.

sumEven n = sum [ x | x <- [0..n*2], even x]

-- 5. Implement a function `factorial n` that computes n! recursively.

factorial 1 = 1
factorial n = n * factorial (n - 1)

-- 6. Implement a function `isPrime n` that checks whether a given integer `n` is prime.

isPrime 1 = True
isPrime 2 = True
isPrime 3 = True
isPrime n = not $ any (\x -> mod n x == 0) [2..(n-1)]

-- 7. Write a function `removeDuplicates list` that removes all duplicate elements from a list.

isUnique x unqs
  | not $ elem x unqs = unqs ++ [x]
  | otherwise = unqs
 
constructUniqueList [x] unqs = isUnique x unqs
constructUniqueList (x:xs) unqs = constructUniqueList xs (isUnique x unqs)
removeDuplicates list = constructUniqueList list []

-- 8. Implement `mergeSorted list1 list2`, which merges two sorted lists into one sorted list.

-- mergeSorted list1 list2 = -- Your answer here

-- 9. Write a function `collatz n` that computes the Collatz sequence starting from `n` until it reaches 1.

-- collatz n = -- Your answer here

-- 10. Implement `reverseWords sentence`, which takes a string and reverses the words while keeping their order.

-- reverseWords sentence = -- Your answer here

-- 11. Implement `rotateLeft n list`, which rotates a list `n` positions to the left.

-- rotateLeft n list = -- Your answer here

-- 12. Implement a function `subsequences list` that returns all possible subsequences of a list.

-- subsequences list = -- Your answer here

-- 13. Implement `groupByN n list`, which groups elements of a list into sublists of length `n`.

-- groupByN n list = -- Your answer here

-- 14. Implement `hanoiSteps n`, which returns the number of moves required to solve the Towers of Hanoi problem for `n` disks.

-- hanoiSteps n = -- Your answer here

-- 15. Implement `binarySearch list target`, which searches for `target` in a sorted list using binary search.

-- binarySearch list target = -- Your answer here

-- 16. Implement `quickSort list`, which sorts a list using the QuickSort algorithm.

-- quickSort list = -- Your answer here

-- 17. Implement `palindromeCheck str`, which checks if a given string is a palindrome.

-- palindromeCheck str = -- Your answer here

-- 18. Implement `countOccurrences x list`, which counts the number of times `x` appears in `list`.

-- countOccurrences x list = -- Your answer here

-- 19. Implement `fibonacci n`, which returns the `n`-th Fibonacci number.

-- fibonacci n = -- Your answer here

-- 20. Implement `dotProduct v1 v2`, which computes the dot product of two vectors.

-- dotProduct v1 v2 = -- Your answer here
