import System.IO
import Text.ParserCombinators.Parsec (label)

main = do
    contents <- readFile "input.txt"
    let reports = map (map read . words) $ lines contents
    let levelDiffs = map deriveList reports
    let day2a = length $ filter isSameSign $ filter isSafe levelDiffs
    print day2a 


deriveList :: [Int] -> [Int]
deriveList [] = []
deriveList [x] = []
deriveList (x:xs) = (x - head xs) : deriveList xs

isSafe:: [Int] -> Bool
isSafe = all (\x -> abs x <= 3 && x /= 0)

isSameSign :: [Int] -> Bool
isSameSign xs = all (>= 0) xs || all (< 0) xs
