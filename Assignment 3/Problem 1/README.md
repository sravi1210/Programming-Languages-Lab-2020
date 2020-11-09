# To Compile The Program Use:
	$ ghc -o a.out problem1.hs

# To Run The Program Use:
	?- ./a.out

## OR

# Use Interface Haskell.
	$ ghci
	Prelude> :load "problem1.hs"
	*Main> function_name parameters  

# To Access Different Function Formats In Haskell
	*Main> setUnion 'A' 'B'
	*Main> setIntersect 'A' 'B'
	*Main> setDifference 'A' 'B'
	*Main> isEmpty 'A'
	*Main> setAdd 'A' 'B'
	*Main> main