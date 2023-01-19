import Data.List
import Text.Read
import Data.List.Split
import System.IO
import Test.QuickCheck

type Poly = [Mono]
type VarExpo = (Char,Int)
type Coef = Int
type Mono = (Coef, [VarExpo])

----------------------  MAIN  ----------------------
{-
Simple interface to test the functionalities of our program (sum,mult,deriv)
Every input should be followed by an enter
Every polynomial should be written as a string (Ex: 2x^3yz^6)
-}
main = do
    putStrLn "Which operation do you whish to perform? (sum, mult, deriv)"
    op <- getLine
    if op == "sum"
    then do
        putStrLn "Please input the two polynomials you want to sum."
        poly2str <- getLine
        poly3str <- getLine
        putStrLn (removeInitStr (polyToString (sumPoly (strToPoly poly2str) (strToPoly poly3str))))
    else if op == "mult"
    then do
        putStrLn "Please input the two polynomials you want to multiply."
        poly2str <- getLine
        poly3str <- getLine
        putStrLn (removeInitStr (polyToString (multPoly (strToPoly poly2str) (strToPoly poly3str))))
    else if op == "deriv"
    then do
        putStrLn "Please input the a polynomial and the variable you want to derive in relation to."
        poly2str <- getLine
        var2 <- getChar
        putStrLn (removeInitStr (derivaPolyToString (strToPoly poly2str) var2))
    else putStrLn "The operation you inputed is not valid :("


----------------------------------------------------

-------------------- GETTERS -----------------------

getCoef :: Mono -> Coef
getCoef (coef,_) = coef

getCoefList :: Poly -> [Int]
getCoefList p1 = [(getCoef x) | x<-p1]

getVarExpoList :: Mono -> [VarExpo]
getVarExpoList (_,varexpo) = varexpo

getVarListFromMono :: Mono -> [Char]
getVarListFromMono (_,varexpo) = [fst(x) | x<-varexpo]

getExpoListFromMono :: Mono -> [Int]
getExpoListFromMono (_,varexpo) = [snd(x) | x<-varexpo]

getExpoListFromVarExpo :: [VarExpo] -> [Int]
getExpoListFromVarExpo xs = [snd(x) | x<-xs]

getPairFromVar :: [VarExpo] -> Char -> VarExpo
getPairFromVar [] _  = (' ', 0)
getPairFromVar (x:xs) var
    |fst(x) == var = x
    |otherwise = getPairFromVar xs var

getPair :: Mono -> Char -> VarExpo
getPair mono var = getPairFromVar (getVarExpoList (normMono mono)) var

{-
Auxiliar function to getPair function
-}
doesPairExist :: Mono -> Char -> Bool
doesPairExist mono var
    |(getPairFromVar (getVarExpoList mono) var) == (' ',0) = False
    |otherwise = True

--------------------------------------------------------------------

-------------------------- INPUT PARSING ----------------------------

rmvSpace :: String -> String
rmvSpace str =  [x | x <- str, x/=' ']

rmvOperators :: String -> String
rmvOperators str =  [x | x <- str, x/='*' && x/='+']

mySplit :: String -> Char -> [String]
mySplit [] delim = [""]
mySplit (c:cs) delim
    | c == delim = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = mySplit cs delim

splitVar :: String -> [String]
splitVar [] = [""]
splitVar (c:cs)
    | ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') = "" : splitVar cs
    | otherwise = (c : head (splitVar cs)) : tail (splitVar cs)

stringSplit :: String -> [String]
stringSplit [] = [""]
stringSplit (c:cs)
    | c == '+' = "" : rest
    | otherwise = (c : head rest) : tail rest
    where
        rest = stringSplit cs

{-
Adds a '+' before every '-' to facilitate every parsing
-}
addPlus :: String -> String
addPlus "" = ""
addPlus (x:xs)
    | x == '-' =  "+" ++ [x] ++ addPlus xs
    | otherwise = [x] ++ addPlus xs

{-
similar to Prelude head, but knows how to deal with empty lists
-}
myHead :: [String] -> Int
myHead [] = 1
myHead (x:_) = read x ::Int

{-
Retrives the Coeficient of a Monomial
-}
strCoef :: String -> Int
strCoef "" = 0
strCoef str
    |(head str == '-' && (x <'0' || x>'9')) = foldr (*) (-1) ([read (rmvOperators x) :: Int | x <- split (keepDelimsL $ oneOf "abcdefghijklmnopqrstuvwxyzxyz*") str, (readMaybe (rmvOperators x) :: Maybe Int) /= Nothing])
    |otherwise = foldr (*) 1 ([read (rmvOperators x) :: Int | x <- split (keepDelimsL $ oneOf "abcdefghijklmnopqrstuvwxyzxyz*") str, (readMaybe (rmvOperators x) :: Maybe Int) /= Nothing])
    where x = head (drop 1 str)

{-
Retreives the VarExpo list of a Monomial
-}
strVarExpo :: String -> [VarExpo]
strVarExpo str = [ (head x, myHead (drop 1 (mySplit (rmvOperators x) '^'))) | x <- tail(list), (readMaybe (rmvOperators x) :: Maybe Int) == Nothing]
    where list = split (keepDelimsL $ oneOf "abcdefghijklmnopqrstuvwxyzxyz*") str

{-
Parses string into Monomial
-}
strToMono :: String -> Mono
strToMono str = (strCoef str, strVarExpo str )

{-
Parses string into Polynomial
-}
strToPoly :: String -> Poly
strToPoly str = normPoly [strToMono x |x <- stringSplit (addPlus (rmvSpace str))]

{-
Removes "+ " if the first polynomial is positive
(Ex: if "+ 2x" changes to "2x", but if "- 2x" stays the same)
-}
removeInitStr :: String -> String
removeInitStr str
    |((head str == '0') || (head str == '-')) = str
    |otherwise = drop 2 str

isMonoNull :: Mono -> Bool
isMonoNull mono
    |(getCoef mono) == 0 = True
    |otherwise = False

removeNulls :: Poly -> Poly
removeNulls poly = [orderMono (removeVar x) | x<-poly, isMonoNull x == False]

{-
Removes variables whose exponent is 0
-}
removeVar :: Mono -> Mono
removeVar m1 = (getCoef m1, [x | x<-(getVarExpoList m1), snd(x)/=0])

{-
Returns true if Monomials have the same variables and exponents
Ex: 5x and 8x returns true, but 5x and 5y returns false
-}
canSumMono :: Mono -> Mono -> Bool
canSumMono m1 m2
    |getVarExpoList (orderMono m1) == getVarExpoList (orderMono m2) = True
    |otherwise = False

sumMono :: Mono -> Mono -> Mono
sumMono m1 m2
    |canSumMono m1 m2 = (getCoef m1 + getCoef m2,getVarExpoList m1)
    |otherwise = error "can't sum"


orderMono :: Mono -> Mono
orderMono m1 = (getCoef m1, sort (getVarExpoList m1))

{-
Returns the number of variables of a Monomial
-}
howManyVariables :: Mono -> Int
howManyVariables m1 = length (getVarExpoList (normMono m1))

{-
Auxiliar function to function SortByNumberOfVar
-}
moreVariables :: Mono -> Mono -> Ordering
moreVariables m1 m2
    |(howManyVariables m1) > (howManyVariables m2) = LT
    |otherwise = GT

{-
Orders Polynomial by number of vars (descending order)
-}
sortByNumberOfVar :: Poly -> Poly
sortByNumberOfVar p1 = sortBy moreVariables (removeNulls p1)

{-
Auxiliar function to sortAlfabetical
-}
alfabetical :: Mono -> Mono -> Ordering
alfabetical m1 m2
    |(getVarListFromMono m1) < (getVarListFromMono m2) = LT
    |otherwise = GT

{-
Orders Polynomial by alfabetical order
-}
sortAlfabetical :: Poly -> Poly
sortAlfabetical p1 = sortBy alfabetical p1

{-
Auxiliar function to sortExpo
-}
expo :: Mono -> Mono -> Ordering
expo m1 m2
    |(getExpoListFromMono m1) > (getExpoListFromMono m2) = LT
    |otherwise = GT

{-
Orders Polynomial by greatest exponent
-}
sortExpo :: Poly -> Poly
sortExpo p1 = sortBy expo p1

{-
Groups Polynomial by number of Vars, in order to use sortAlfabetical after
-}
groupByNumOfVar :: Poly -> [Poly]
groupByNumOfVar p1 = groupBy (\m1 m2 ->((howManyVariables m1) == (howManyVariables m2))) (sortByNumberOfVar p1)

{-
Sorts Polynomial and Concatenates
-}
sortAlfabeticalSameNumOfVar :: [Poly] -> Poly
sortAlfabeticalSameNumOfVar [] = []
sortAlfabeticalSameNumOfVar (x:xs) = concat ((sortAlfabetical x):[(sortAlfabeticalSameNumOfVar xs)])

{-
Groups Polynomial by same variables, as it is already
sorted by number of variables, in order to order by exponents after
-}
groupBySameVars :: Poly -> [Poly]
groupBySameVars p1 = groupBy (\m1 m2 ->((getVarListFromMono m1) == (getVarListFromMono m2))) (sortAlfabeticalSameNumOfVar (groupByNumOfVar p1))

{-
Sorts Polynomial by bigger exponent
Starts checking the first variable, if it has same exponent then
checks for the variable after
-}
sortExposSameVars :: [Poly] -> Poly
sortExposSameVars [] = []
sortExposSameVars (x:xs) = concat ((sortExpo x):[(sortExposSameVars xs)])

{-
Groups by same variables and exponents, because it is already sorted
by number of variables and exponents of those variables,
in order then sum monomials who have the same variables and exponents
-}
groupBySameVarExpo :: Poly -> [Poly]
groupBySameVarExpo p1 = groupBy (\m1 m2 ->((getVarExpoList m1) == (getVarExpoList m2))) (sortExposSameVars (groupBySameVars p1))

{-
If Polynomial has the same variables and exponents, sums them and turns
into a single element
Ex: If you have x 2x and 5x, it turns 8x. If you have 2xy and 5y, doesnt
do nothing
-}
sumSameVarExpos :: [Poly] -> Poly
sumSameVarExpos [] = []
sumSameVarExpos (x:xs)
    |(length x == 1) = concat (x:[(sumSameVarExpos xs)])
    |otherwise = concat([((sum (getCoefList x)), getVarExpoList (head x))]:[(sumSameVarExpos xs)])

{-
Major function that calls all functions above in chain to a list
of normalized Monomials in order to normalize the Polynomial
-}
normPoly :: Poly -> Poly
normPoly p1 = sumSameVarExpos (groupBySameVarExpo [normMono x | x<-p1])

sumPoly :: Poly -> Poly -> Poly
sumPoly p1 p2 = normPoly ([normMono x | x<-p1]++[normMono y | y<-p2])

{-
Sorts list of variables and exponents by those who have the same var
Ex: if you have (x,2) and (x,6) it turns (x,8)
-}
sortBySameVar :: [VarExpo] -> [VarExpo]
sortBySameVar varexpo = sortBy sortVarExpo varexpo

{-
Auxiliar function to sortBySameVar
-}
sortVarExpo :: VarExpo -> VarExpo -> Ordering
sortVarExpo ve1 ve2
    |(fst(ve1) > fst(ve2)) = GT
    |otherwise = LT

{-
Groups by those who have the same variable, in order to sum everything
from the same group
-}
groupByVar :: [VarExpo] -> [[VarExpo]]
groupByVar ve = groupBy (\x y -> (fst(x)==fst(y))) (sortBySameVar ve)

{-
If length is 1 doesnt do nothing
If >1 then sums the exponents from the same groups of variables
-}
sumSameVar :: [[VarExpo]] -> [VarExpo]
sumSameVar [] = []
sumSameVar (x:xs)
    |(length x == 1) = concat(x:[(sumSameVar xs)])
    |otherwise = concat([(fst (head x),(sum (getExpoListFromVarExpo x)))]:[(sumSameVar xs)])

{-
Normalizes the Monomial in order to use it after in function normPoly
-}
normMono :: Mono -> Mono
normMono m1 = removeVarsZero (getCoef m1, sumSameVar (groupByVar (getVarExpoList m1)))

{-
Auxiliar function to normMono
-}
removeVarsZero :: Mono -> Mono
removeVarsZero m1 = (getCoef m1, [x | x<-(getVarExpoList m1), ((isVarZero x == False) && (isVarInvalid x == False))])

{-
Auxiliar function to removeVarsZero
-}
isVarInvalid :: VarExpo -> Bool
isVarInvalid varexpo
    |((fst varexpo > 'z') || (fst varexpo < 'a'))   = True
    |otherwise = False

{-
Auxiliar function to removeVarsZero
-}
isVarZero :: VarExpo -> Bool
isVarZero varexpo
    |snd varexpo == 0 = True
    |otherwise = False

{-
Multiplies monomials
-}
multMono :: Mono -> Mono -> Mono
multMono m1 m2 = normMono ((getCoef m1 * getCoef m2), (getVarExpoList m1 ++ getVarExpoList m2))

{-
Applies multMono to every possible case in order to multiply
Polynomials
-}
multPoly :: Poly -> Poly -> Poly
multPoly p1 p2 = normPoly [multMono x1 x2 | x1<-p1, x2<-p2]

{-
derivated Monomial in order to a chosen variable,
using derivation rules
-}
derivaMono :: Mono -> Char -> Mono
derivaMono m1 var
    |getPair m1 var == (' ',0) = (0,[])
    |otherwise = normMono((getCoef m1)*(snd (getPair m1 var)), (decrementExpo (getVarExpoList m1) var))

{-
Auxiliar function do derivaMono, in order to decrement its exponent
after derivation
-}
decrementExpo :: [VarExpo] -> Char -> [VarExpo]
decrementExpo [] _ = []
decrementExpo (x:xs) var
    |fst (x) == var = (var, snd (x) -1):xs
    |otherwise = x:(decrementExpo xs var)

{-
Applies function derivaMono to every monomials inside Polynomial
-}
derivaPoly :: Poly -> Char -> Poly
derivaPoly p1 var = normPoly [derivaMono m1 var | m1<-p1]

{-
Turns monomial to a string
-}
monoToString :: Mono -> String
monoToString m1
    |(abs (getCoef m1) == 1 || getCoef m1 == 0) && (getVarExpoList m1 /= []) = ((signal m1) ++ " " ++ varexpoToString (getVarExpoList m1))
    |otherwise = ((signal m1) ++ " " ++ show (abs (getCoef m1))) ++ varexpoToString (getVarExpoList m1)

{-
Auxiliar function to monoToString that returns the '+' or '-'
depending of the coeficient
-}
signal :: Mono -> String
signal m1
    |getCoef m1 >= 0 = "+"
    |otherwise = "-"

{-
Converts the list of variables and exponents to a string
-}
varexpoToString :: [VarExpo] -> String
varexpoToString [] = []
varexpoToString (x:xs)
    |snd x == 1 = ([(fst (x))] ++ (varexpoToString xs))
    |otherwise = ([(fst (x))] ++ "^" ++ (show(snd (x)))) ++ (varexpoToString xs)

{-
Convert the polynomial to a string
-}
polyToString :: Poly -> String
polyToString p1
    |normPoly p1 == [] = "0"
    |p2 == [] = (monoToString p)
    |otherwise = (monoToString p) ++ " " ++ (polyToString p2)
    where (p:p2) = (normPoly p1)


{-
The 3 following functions apply the sum, mult and deriv, converting
the Poly to String after
-}

sumPolyToString :: Poly -> Poly -> String
sumPolyToString p1 p2 = polyToString (normPoly (sumPoly p1 p2))

multPolyToString :: Poly -> Poly -> String
multPolyToString p1 p2 = polyToString (normPoly (multPoly p1 p2))

derivaPolyToString :: Poly -> Char -> String
derivaPolyToString p1 var = polyToString (normPoly (derivaPoly p1 var))

---- TEST -----

{-
Functions to test all the properties from the operations
-}

monoTest0 :: Mono
monoTest0 = (0,[])

monoTest1 :: Mono
monoTest1 = (1,[])

monoTest2 :: Mono
monoTest2 = (5,[])

prop_associativity_sum :: Poly -> Poly -> Bool
prop_associativity_sum p1 p2 = sumPoly p1 p2 == sumPoly p2 p1

prop_null_element_sum :: Poly -> Bool
prop_null_element_sum p1 = sumPoly p1 [monoTest0] == normPoly p1

prop_associativity_mult :: Poly -> Poly -> Bool
prop_associativity_mult p1 p2 = multPoly p1 p2 == multPoly p2 p1

prop_null_element_mult :: Poly -> Bool
prop_null_element_mult p1 = multPoly p1 [monoTest1]  == normPoly p1

prop_coef_deriv :: Poly -> Bool
prop_coef_deriv p1 = normPoly (derivaPoly (multPoly [monoTest2] p1 ) 'x') == normPoly (multPoly [monoTest2] (derivaPoly p1 'x'))

prop_null_element_deriv :: Poly -> Bool
prop_null_element_deriv p1 = derivaPolyToString (p1 ++ [monoTest2]) 'x' ==  derivaPolyToString p1 'x'

prop_sum_deriv :: Poly -> Poly -> Bool
prop_sum_deriv p1 p2 = normPoly (derivaPoly (sumPoly p1 p2) 'x') == normPoly (sumPoly (derivaPoly p1 'x') (derivaPoly p2 'x'))
