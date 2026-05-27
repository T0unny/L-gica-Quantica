import Data.Set (Set)
import qualified Data.Set as Set
import Data.List (replicate)

--swap
--delete
--copy
--alsum
--xor
--not



-- quantidade de bits necessária para representar o máximo
bitSize :: Int -> Int
bitSize maxN
  | maxN <= 0  = 1
  | otherwise   = length (toBinaryRaw maxN)

-- binário sem zeros à esquerda
toBinaryRaw :: Int -> [Int]
toBinaryRaw 0 = [0]
toBinaryRaw n = reverse (go n)
  where
    go 0 = []
    go x = (x `mod` 2) : go (x `div` 2)

-- binário com tamanho fixo, preenchido com zeros à esquerda
toBinaryFixed :: Int -> Int -> [Int]
toBinaryFixed maxN n =
  let size = bitSize maxN
      bits = toBinaryRaw n
  in replicate (size - length bits) 0 ++ bits


createSet :: Int -> Set [Int]
createSet n = Set.fromList (map (toBinaryFixed n) [0..n])


swap :: Int -> Int -> [Int] -> [Int]
swap i j xs
  | i < length xs && j < length xs = 
      let temp = xs !! i
          xs' = take i xs ++ [xs !! j] ++ drop (i + 1) xs
      in take j xs' ++ [temp] ++ drop (j + 1) xs'
  | otherwise = xs


delete :: Int -> [Int] -> [Int]
delete i xs
  | i < length xs = take i xs ++ drop (i + 1) xs
  | otherwise = xs


copy :: Int -> [Int] -> [Int]
copy n x = take n x ++ replicate 2 (x !! n) ++ drop (n + 1) x  

falsum :: Int -> [Int] -> [Int]
falsum n x = take n x ++ [0] ++ drop n x

xor :: Bool -> Bool -> Bool
xor True False = True
xor False True = True
xor _ _ = False

not :: Bool -> Bool
not True = False
not False = True



