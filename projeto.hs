--Pedro Ribeiro, pg60421
--Pedro Silva, pg60422


import Data.Complex
type Bit = Bool

--swap
--delete
--copy
--falsum
--xor
--not

swap :: (Bit, Bit) -> (Bit, Bit)
swap (a, b) = (b, a)

delete :: Bit -> ()
delete _ = ()

copy1 :: Bit -> (Bit, Bit)
copy1 b = (b, b)

falsum :: () -> Bit
falsum () = False

xor :: (Bit, Bit) -> Bit
xor (True, False) = True
xor (False, True) = True
xor (True, True) = False
xor (False, False) = False

not2 :: Bit -> Bit
not2 True = False
not2 False = True

testBialgebra :: (Bit, Bit) -> Bool
testBialgebra (a, b) = leftSide == rightSide
  where

    leftSide = copy1 (xor (a, b))
    

    (a1, a2) = copy1 a
    (b1, b2) = copy1 b

    (b1', a2') = swap (a2, b1)
    

    resultado1 = xor (a1, b1')
    resultado2 = xor (a2', b2)
    
    rightSide = (resultado1, resultado2)

testswapxor :: (Bit, Bit) -> Bit
testswapxor (a,b)= xor (a,b) == xor (swap (a,b))

testcopyxor :: Bit -> Bit
testcopyxor b = xor (copy1 b) == falsum (delete b)


type Matrix = [[Complex Double]]

bits :: [Bit]
bits = [False, True]

pairs :: [(Bit,Bit)]
pairs = [(a,b) | a <- bits, b <- bits]



stateFalse :: Matrix
stateFalse = [[1.0 :+ 0.0],
              [0.0 :+ 0.0]]


stateTrue :: Matrix
stateTrue = [[0.0 :+ 0.0],
             [1.0 :+ 0.0]]


toMatrix :: (Eq b) => [a] -> [b] -> (a -> b) -> Matrix
toMatrix inputs outputs f = [ [ if f x == y then 1 else 0 | x <- inputs ] | y <- outputs]


notM :: Matrix
notM = toMatrix bits bits not2

copyM :: Matrix
copyM = toMatrix bits pairs copy1

--[[1.0 :+ 0.0,0.0 :+ 0.0],
--[0.0 :+ 0.0,0.0 :+ 0.0],
--[0.0 :+ 0.0,0.0 :+ 0.0],
--[0.0 :+ 0.0,1.0 :+ 0.0]]

swapM :: Matrix
swapM = toMatrix pairs pairs swap

--[[1.0 :+ 0.0,0.0 :+ 0.0,0.0 :+ 0.0,0.0 :+ 0.0],
--[0.0 :+ 0.0,0.0 :+ 0.0,1.0 :+ 0.0,0.0 :+ 0.0],
--[0.0 :+ 0.0,1.0 :+ 0.0,0.0 :+ 0.0,0.0 :+ 0.0],
--[0.0 :+ 0.0,0.0 :+ 0.0,0.0 :+ 0.0,1.0 :+ 0.0]]

xorM :: Matrix
xorM = toMatrix pairs bits xor

--[[1.0 :+ 0.0,0.0 :+ 0.0,0.0 :+ 0.0,1.0 :+ 0.0],
--[0.0 :+ 0.0,1.0 :+ 0.0,1.0 :+ 0.0,0.0 :+ 0.0]]

falsumM :: Matrix
falsumM = toMatrix [()] bits falsum

deleteM :: Matrix
deleteM = toMatrix bits [()] delete

matMul :: Matrix -> Matrix -> Matrix
matMul a b = [ [ sum [ a!!i!!k * b!!k!!j | k <- [0..length b - 1] ] | j <- [0..length (head b) - 1] ] | i <- [0..length a - 1] ]




testswapxorMatrix :: Bool
testswapxorMatrix =  xorM == matMul xorM swapM

testcopyxorMatrix :: Bool
testcopyxorMatrix = matMul xorM copyM == matMul falsumM deleteM

tensor :: Matrix -> Matrix -> Matrix
tensor a b = concatMap (\rowA -> map (\rowB -> concatMap (\x -> map (x *) rowB ) rowA ) b ) a

identity :: Int -> Matrix
identity n =[ [ if i == j then 1 else 0 | j <- [0..n-1] ] | i <- [0..n-1] ]

testBialgebraMatrix :: Bool
testBialgebraMatrix = matMul (tensor xorM xorM) (matMul (tensor (tensor (identity 2) swapM) (identity 2)) (tensor copyM copyM)) == matMul copyM xorM

