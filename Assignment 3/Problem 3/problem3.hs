-- Include important header files.
import Data.List
import Data.IORef
import Data.Maybe
import System.Random
import System.IO.Unsafe

minKitchen :: Integer -> Integer
minKitchen bedroom = do
    let kitchen = bedroom `div` 3
    let left = bedroom `mod` 3
    if left > 0 then kitchen+1
        else kitchen

design :: Integer -> Integer -> Integer -> IO ()
design area bedroom hall = do
    let bathroom = bedroom + 1
    let kitchen = minKitchen bedroom
    let garden = 1
    let balcony = 1
    print ("Bedroom: " ++ (show bedroom) ++ " Hall: " ++ (show hall) ++ " Bathroom: " ++ (show bathroom) ++ " Kitchen: " ++ (show kitchen) ++ " Garden: " ++ (show garden) ++ " Balcony: " ++ (show balcony))

    let minTotalArea = (bedroom * 100) + (hall * 150) + (bathroom * 20) + (kitchen * 35) + (garden * 100) + (balcony * 25)
    print("Minimum Area Needed For Basic Arrangement: " ++ (show minTotalArea))

    if area < minTotalArea then print ("Sorry! Area Is Too Small To Design")
        else print ("Most Effective Design Is Below: ")

main = do
    design 100 5 5
