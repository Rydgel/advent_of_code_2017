{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Concurrent.Async
import Data.Bits
import Formatting
import Formatting.Clock
import System.Clock

infixr 8 ><
(><) :: (a -> b) -> (c -> d) -> (a, c) -> (b, d)
(f >< g) (x, y) = (f x, g y)
{-# INLINE (><) #-}

input :: (Int, Int)
input = (703, 516)

generatorA :: Int -> Int
generatorA x = x * 16807 `rem` 2147483647
{-# INLINE generatorA #-}

generatorB :: Int -> Int
generatorB x = x * 48271 `rem` 2147483647
{-# INLINE generatorB #-}

toInt16 :: Int -> Int
toInt16 = (.&. 0xFFFF)
{-# INLINE toInt16 #-}

count :: (a -> Bool) -> [a] -> Int
count f = length . filter f
{-# INLINE count #-}

judgeFinalCount :: Int -> [Int] -> [Int] -> Int
judgeFinalCount n iterA iterB = count (uncurry (==)) $ take n (zip iterA iterB)
{-# INLINE judgeFinalCount #-}

solution1 :: (Int, Int) -> Int
solution1 (i1, i2) = judgeFinalCount 40000000 iterA iterB
  where
    iterA = toInt16 <$> iterate generatorA i1
    iterB = toInt16 <$> iterate generatorB i2

solution2 :: (Int, Int) -> Int
solution2 (i1, i2) = judgeFinalCount 5000000 iterA iterB
  where
    iterA = filter ((== 0) . (`rem` 4)) $ toInt16 <$> iterate generatorA i1
    iterB = filter ((== 0) . (`rem` 8)) $ toInt16 <$> iterate generatorB i2

main :: IO ()
main = do
  start <- getTime Monotonic
  jobs <- mapM async
    [ print $ solution1 input
    , print $ solution2 (generatorA >< generatorB $ input)
    ]
  mapM_ wait jobs
  end <- getTime Monotonic
  fprint ("it took " % timeSpecs % "\n") start end
