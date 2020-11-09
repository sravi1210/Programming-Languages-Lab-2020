-- Include important header files.
import Data.List
import Data.Bool

-- Two sets 'A' and 'B' to be used in the program.
setA = [1, 2, 2, 2, 2, 3, 4, 5, 6, 7, 8, 9]
setB = [5, 2, 6, 7, 8, 9, 10, 11]


-- Function to remove duplicates from a given set.
removeDuplicates :: (Eq a) => [a] -> [a]
removeDuplicates [] = []
removeDuplicates [x] = [x]
removeDuplicates (x:xs) = x : [ k  | k <- removeDuplicates (xs), k /=x ]



-- Function to find the union of two sets.
findUnion :: [Integer] -> [Integer] -> [Integer]
findUnion [] _ = []  -- If first set becomes empty.

findUnion (b:sb) sa = do -- If first set is not empty.
    if (b `elem` sa)
        then findUnion sb sa
    else 
        b : findUnion sb sa

-- Function to handle duplicate values in the union of two sets.
findUnion' :: [Integer] -> [Integer] -> [Integer]
findUnion' sb sa = do
    let temp = findUnion sb sa
    let set_union = sa ++ temp
    removeDuplicates set_union

-- Function to handle union of set and user input.
setUnion :: Char -> Char -> IO ()
setUnion x y | (x /= 'A' && x /= 'B') || (y /= 'B' && y /= 'A') = putStrLn "ONLY A OR B ARE SUPPORTED"
             | x == y && x == 'A' = print (removeDuplicates setA)
             | x == y && x == 'B' = print (removeDuplicates setB)
             | x /= y = print (findUnion' setB setA)




-- Function to find the intersection of two sets.
findIntersect :: [Integer] -> [Integer] -> [Integer]
findIntersect [] _ =  []  -- If first set becomes empty.

findIntersect (a:sa) sb = do -- If first set is not empty.
    if (a `elem` sb)
        then a : findIntersect sa sb
    else 
        findIntersect sa sb

-- Function to handle the duplicate values in the intersection of two sets.
findIntersect' :: [Integer] -> [Integer] -> [Integer]
findIntersect' sa sb = do
    let set_intersect = findIntersect sa sb
    removeDuplicates set_intersect

-- Function to handle intersection of set and user input.
setIntersect :: Char -> Char -> IO ()
setIntersect x y | (x /= 'A' && x /= 'B') || (y /= 'B' && y /= 'A') = putStrLn "ONLY A OR B ARE SUPPORTED"
                 | x == y && x == 'A' = print (removeDuplicates setA)
                 | x == y && x == 'B' = print (removeDuplicates setB)
                 | x /= y = print (findIntersect' setA setB)




-- Function to find the difference of two sets.
findDifference :: [Integer] -> [Integer] -> [Integer]
findDifference [] _ =  []   -- If first set becomes empty.

findDifference (a:sa) sb = do  -- If first set is not empty.
    if (a `elem` sb)
        then findDifference sa sb
    else
        a : findDifference sa sb

-- Function to handle the duplicate values in the difference of two sets.
findDifference' :: [Integer] -> [Integer] -> [Integer]
findDifference' sa sb = do
    let set_difference = findDifference sa sb
    removeDuplicates set_difference

-- Function to handle difference of set and user input.
setDifference :: Char -> Char -> IO ()
setDifference x y | (x /= 'A' && x /= 'B') || (y /= 'B' && y /= 'A') = putStrLn "ONLY A OR B ARE SUPPORTED"
                  | x == 'A' && y == 'A' = print (findDifference' setA setA)
                  | x == 'B' && y == 'B' = print (findDifference' setB setB) 
                  | x /= y && x == 'A' && y == 'B' = print (findDifference' setA setB)
                  | x /= y && x == 'B' && y == 'A' = print (findDifference' setB setA)



-- Function to handle addition of two sets.
findAdd :: [Integer] -> [Integer] -> [Integer]
findAdd [] _ = []   -- If first set is empty.
findAdd _ [] = []   -- If second set is empty.

findAdd (a:sa) (b:sb) = do
    let temp1 = findAdd sa (b:sb)
    let add1 = (a+b : temp1)
    let temp2 = findAdd (a:sa) sb
    add1 ++ temp2

-- Function to handle remove duplicates in the addition of the two sets.
findAdd' sa sb = do
    let set_add = findAdd sa sb
    removeDuplicates set_add

-- Function to handle addition of sets and user input.
setAdd :: Char -> Char -> IO ()
setAdd x y | (x /= 'A' && x /= 'B') || (y /= 'B' && y /= 'A') = putStrLn "ONLY A OR B ARE SUPPORTED"
           | x == 'A' && y == 'A' = print (findAdd' setA setA)
           | x == 'B' && y == 'B' = print (findAdd' setB setB)
           | x /= y = print (findAdd' setA setB)




-- Function to handle if the set is empty.
isEmpty :: Char -> IO ()
isEmpty x | (x /= 'A' && x /= 'B') = putStrLn "ONLY A OR B ARE SUPPORTED"
          | x == 'A' && length setA == 0 = putStrLn "Set A Is Empty"
          | x == 'A' && length setA /= 0 = putStrLn "Set A Is Not Empty"
          | x == 'B' && length setB == 0 = putStrLn "Set B Is Empty"
          | x == 'B' && length setB /= 0 = putStrLn "Set B Is Not Empty"



-- Function to print all condition of operation between sets A and B.
main = do
    putStrLn "Set A Is "
    print (removeDuplicates setA)
    putStrLn "\n"
    putStrLn "Set B Is "
    print (removeDuplicates setB)
    putStrLn "\n"

    putStrLn "Check If Set A Is Empty"
    isEmpty 'A'
    putStrLn "\n"

    putStrLn "Check If Set B Is Empty"
    isEmpty 'B'
    putStrLn "\n"

    putStrLn "Union of A and B"
    setUnion 'A' 'B'
    putStrLn "\n"

    putStrLn "Union of A and A"
    setUnion 'A' 'A'
    putStrLn "\n"

    putStrLn "Union of B and B"
    setUnion 'B' 'B'
    putStrLn "\n"

    putStrLn "Intersection of A and B"
    setIntersect 'A' 'B'
    putStrLn "\n"

    putStrLn "Intersection of A and A"
    setIntersect 'A' 'A'
    putStrLn "\n"

    putStrLn "Intersection of B and B"
    setIntersect 'B' 'B'
    putStrLn "\n"

    putStrLn "Set-Difference of A and B"
    setDifference 'A' 'B'
    putStrLn "\n"

    putStrLn "Set-Difference of B and A"
    setDifference 'B' 'A'
    putStrLn "\n"

    putStrLn "Set-Difference of A and A"
    setDifference 'A' 'A'
    putStrLn "\n"
    
    putStrLn "Set-Difference of B and B"
    setDifference 'B' 'B'
    putStrLn "\n"

    putStrLn "Addition of A and B"
    setAdd 'A' 'B'