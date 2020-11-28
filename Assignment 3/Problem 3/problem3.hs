-- Included all important header files.
import Data.IORef
import System.Random
import System.IO.Unsafe
import Debug.Trace
import Data.List
import Data.Maybe

-- Function to calculate the number of kitchens given number of bedrooms
minKitchen :: Int -> Int
minKitchen bedroom = do
    let kitchen = bedroom `div` 3
    let left = bedroom `mod` 3
    if left > 0 then kitchen+1
        else kitchen

-- Data structure to hold the dimensions of garden and balcony in the solution approach.
data SceneII = SceneII {
                gardenII :: [Int],
                balconyII :: [Int],
                areaII :: Int
                } deriving (Show, Eq)

-- Function to habdle the creation of balcony for when required.
createSceneIIBalcony :: [Int] -> Int -> SceneII -> SceneII
createSceneIIBalcony sizeRoom count garden = do
    SceneII {
        gardenII = (gardenII garden),
        balconyII = sizeRoom,
        areaII = ((sizeRoom!!0)*(sizeRoom!!1)*count) + (areaII garden)
    }

-- Function to handle the validation of balcony size in the plot.
check_balcony sizeRoom area = do
    let balLen = ((sizeRoom!!0)!!0)
    let balWid = ((sizeRoom!!0)!!1)
    (balLen < 11 && balWid < 11 && area >= 0)

-- Function to handle the plotting of balcony in the given area plot.
buildBalcony :: [[Int]] -> [Int] -> Int -> Int -> SceneII -> [SceneII] 
buildBalcony (balSize : x) (balCount : y) area check garden = do
    let areaTotal = ((balSize!!0)*(balSize!!1)*balCount)
    let areaLeft = area - areaTotal               -- Left area i.e., the area left to divise new plots.
    if (check_balcony (balSize : x) areaLeft) then do
        let balcony = createSceneIIBalcony balSize balCount garden
        if check == 1 then do
            let scenarioIII = buildBalcony ([balSize!!0, balSize!!1 + 1] : x) (balCount : y) area 1 garden           -- Check for each of the scenarios given modes.
            scenarioIII ++ [balcony]
        else do
            let scenarioII = buildBalcony ([balSize!!0 + 1, balSize!!1] : x) (balCount : y) area 0 garden
            let scenarioIII = buildBalcony ([balSize!!0, balSize!!1 + 1] : x) (balCount : y) area 1 garden
            scenarioII ++ scenarioIII ++ [balcony]
    else []

-- Function to handle the creation of garden for when required.
createSceneIIGarden :: [Int] -> Int -> SceneII
createSceneIIGarden sizeRoom count = do
    SceneII {
        gardenII = sizeRoom,
        balconyII = [],
        areaII = (sizeRoom!!0)*(sizeRoom!!1)*count
    }

-- Function to validate the dimensions of the garden in a plot.
check_garden sizeRoom = do
    let garLen = ((sizeRoom!!0)!!0)
    let garWid = ((sizeRoom!!0)!!1)
    (garLen < 21 && garWid < 21)

-- Function tp handle the building of the garden on the plot.
buildGarden :: [[Int]] -> [Int] -> Int -> Int -> [SceneII]
buildGarden (gardSize : x) (gardCount : y) area check = do
    let areaTotal = ((gardSize!!0)*(gardSize!!1)*gardCount)
    let areaLeft = area - areaTotal            -- Left area i.e., the area left to divise new plots.
    if (check_garden (gardSize : x)) then do
        let garden = createSceneIIGarden gardSize gardCount
        let scenarioI = buildBalcony x y areaLeft 0 garden
        if check == 1 then do
            let scenarioIII = buildGarden ([gardSize!!0, gardSize!!1 + 1] : x) (gardCount : y) area 1              -- Check for each of the scenarios given modes.
            scenarioI ++ scenarioIII
        else do
            let scenarioII = buildGarden ([gardSize!!0 + 1, gardSize!!1] : x) (gardCount : y) area 0
            let scenarioIII = buildGarden ([gardSize!!0, gardSize!!1 + 1] : x) (gardCount : y) area 1
            scenarioI ++ scenarioII ++ scenarioIII
    else []

-- Data structure to hold the dimension of the bedroom, hall, kitchen, bathroom, and the total area they take in the plot.
data SceneI = SceneI{
                        hallI :: [Int],
                        bedroomI :: [Int],
                        kitchenI :: [Int],
                        bathroomI :: [Int],
                        areaI :: Int
                    }deriving (Show, Eq)

-- Function to handle the creation of the bathroom as when required
createSceneIBathroom :: [Int] -> Int -> SceneI -> SceneI
createSceneIBathroom sizeRoom count kitchen = do
    SceneI {
        hallI = (hallI kitchen),
        bedroomI = (bedroomI kitchen),
        kitchenI = (kitchenI kitchen),
        bathroomI = sizeRoom,
        areaI = ((sizeRoom!!0)*(sizeRoom!!1)*count) + (areaI kitchen)        -- Update the new area with intial area taken.
    }

-- Function to handle the validation of the dimension of the bathroom in the plot.
check_bathroom sizeRoom area kitchen = do
    let bathLen = ((sizeRoom!!0)!!0)
    let bathWid = ((sizeRoom!!0)!!1)
    let kitLen = (kitchen!!0)
    let kitWid = (kitchen!!1)
    (bathLen < 9 && bathWid < 10 && bathLen <= kitLen && bathWid <= kitWid)

-- Recursive function to handle the building of the bathroom on the plot area left. 
buildBathroom :: [[Int]] -> [Int] -> Int -> Int -> SceneI -> [SceneI]
buildBathroom (bathSize : x) (bathCount : y) area check kitchen = do
    let areaTotal = ((bathSize!!0)*(bathSize!!1)*bathCount)
    let areaLeft = area - areaTotal       -- Left area i.e., the area left to divise new plots.
    if (check_bathroom (bathSize : x) areaLeft (kitchenI kitchen)) then do
        let bathroom = createSceneIBathroom bathSize bathCount kitchen
        if check == 1 then do
            let scenarioIII = buildBathroom ([bathSize!!0, bathSize!!1 + 1] : x) (bathCount : y) area 1 kitchen          -- Check for each of the scenarios given modes.
            scenarioIII ++ [bathroom]
        else do
            let scenarioII = buildBathroom ([bathSize!!0 + 1, bathSize!!1] : x) (bathCount : y) area 0 kitchen
            let scenarioIII = buildBathroom ([bathSize!!0, bathSize!!1 + 1] : x) (bathCount : y) area 1 kitchen
            scenarioII ++ scenarioIII ++ [bathroom]
    else []

-- Fucntion to handle the creation of the kitchen which in turn creates the bathroom on the plot.
createSceneIKitchen :: [Int] -> Int -> SceneI -> SceneI
createSceneIKitchen sizeRoom count hall = do
    SceneI{
        hallI = (hallI hall),
        bedroomI = (bedroomI hall),
        kitchenI = sizeRoom,
        bathroomI = [],
        areaI = ((sizeRoom!!0)*(sizeRoom!!1)*count) + (areaI hall)
    }

-- Function to handle the validation of the dimensions of the kitchen given the area plot as well.
check_kitchen sizeRoom area bed hall = do
    let kitLen = ((sizeRoom!!0)!!0)
    let kitWid = ((sizeRoom!!0)!!1)
    let hallLen = (hall!!0)
    let hallWid = (hall!!1)
    let bedLen = (bed!!0)
    let bedWid = (bed!!1)
    (kitLen < 16 && kitWid < 14 && kitLen < bedLen && kitLen < hallLen && kitWid < bedWid && kitWid < hallWid && area>=0)

-- Function to handle the generation of the kitchen which in turn will recursively generate bathroom on the plot.
buildKitchen :: [[Int]] -> [Int] -> Int -> Int -> SceneI -> [SceneI]
buildKitchen (kitchenSize : x) (kitchenCount : y) area check hall = do
    let areaTotal = ((kitchenSize!!0)*(kitchenSize!!1)*kitchenCount)
    let areaLeft = area - areaTotal         -- Left area i.e., the area left to divise new plots.
    if (check_kitchen (kitchenSize : x) areaLeft (bedroomI hall) (hallI hall)) then do
        let kitchen = createSceneIKitchen kitchenSize kitchenCount hall
        let scenarioI = buildBathroom x y areaLeft 0 kitchen
        if check == 1 then do
            let scenarioIII = buildKitchen ([kitchenSize!!0, kitchenSize!!1 + 1] : x) (kitchenCount : y) area 1 hall           -- Check for each of the scenarios given modes.
            scenarioI ++ scenarioIII
        else do
            let scenarioII = buildKitchen ([kitchenSize!!0 + 1, kitchenSize!!1] : x) (kitchenCount : y) area 0 hall
            let scenarioIII = buildKitchen ([kitchenSize!!0, kitchenSize!!1 + 1] : x) (kitchenCount : y) area 1 hall
            scenarioI ++ scenarioII ++ scenarioIII
    else []

-- Function to handle the creation of hall for when required.
createSceneIHall :: [Int] -> Int -> SceneI -> SceneI
createSceneIHall sizeRoom count bed = do
    SceneI {
        hallI = sizeRoom,
        bedroomI = (bedroomI bed),
        kitchenI = [],
        bathroomI = [],
        areaI = ((sizeRoom!!0)*(sizeRoom!!1)*count) + (areaI bed)
    }

-- Function to handle the validations of the dimension of the hall given the plot area.
check_hall sizeRoom area = do
    let hallLen = ((sizeRoom!!0)!!0)
    let hallWid = ((sizeRoom!!0)!!1)
    (hallLen < 21 && hallWid < 16 && area >= 0)

-- Function to handle the genration of the hall which in turn recursively creates the kitchen on the plot.
buildHall :: [[Int]] -> [Int] -> Int -> Int -> SceneI -> [SceneI]
buildHall (hallSize : x) (hallCount : y) area check bed = do
    let areaTotal = ((hallSize!!0)*(hallSize!!1)*hallCount)
    let areaLeft = area - areaTotal            -- Left area i.e., the area left to divise new plots.
    if (check_hall (hallSize : x) areaLeft) then do
        let hall = createSceneIHall hallSize hallCount bed
        let scenarioI = buildKitchen x y areaLeft 0 hall
        if check == 1 then do
            let scenarioIII = buildHall ([hallSize!!0, hallSize!!1 + 1] : x) (hallCount : y) area 1 bed         -- Check for each of the scenarios given modes.
            scenarioI ++ scenarioIII
        else do
            let scenarioII = buildHall ([hallSize!!0 + 1, hallSize!!1] : x) (hallCount : y) area 0 bed
            let scenarioIII = buildHall ([hallSize!!0, hallSize!!1 + 1]: x) (hallCount : y) area 1 bed
            scenarioI ++ scenarioII ++ scenarioIII
    else []

-- Fucntion to handle the creation of bedroom as when required.
createSceneIBedroom :: [Int] -> Int -> SceneI
createSceneIBedroom sizeRoom count = do
    SceneI {
        hallI = [],
        bedroomI = sizeRoom,
        kitchenI = [],
        bathroomI = [],
        areaI = (sizeRoom!!0)*(sizeRoom!!1)*count
    }

-- Function to handle the validation of the dimension of the bedroom and area on the plot.
check_bedroom sizeRoom = do
    let bedLen = ((sizeRoom!!0)!!0)
    let bedWid = ((sizeRoom!!0)!!1)
    ((bedLen < 16) && (bedWid < 16))

-- Function to handle the generation of the bedroomm which in turn generates the hall on the plot.
buildBedroom :: [[Int]] -> [Int] -> Int -> Int -> [SceneI]
buildBedroom (bedSize : x) (bedCount : y) area check = do
    let areaTotal = ((bedSize!!0)*(bedSize!!1)*bedCount)
    let areaLeft = area - areaTotal           -- Left area i.e., the area left to divise new plots.
    if (check_bedroom (bedSize : x)) then do
        let bed = createSceneIBedroom bedSize bedCount
        let scenarioI = buildHall x y areaLeft 0 bed
        if check == 1 then do

            let scenarioIII = buildBedroom ([bedSize!!0, bedSize!!1 + 1]:x) (bedCount:y) area 1        -- Check for each of the scenarios given modes.
            scenarioI ++ scenarioIII
        else do
            let scenarioII = buildBedroom ([bedSize!!0 + 1, bedSize!!1]:x) (bedCount:y) area 0
            let scenarioIII = buildBedroom ([bedSize!!0, bedSize!!1 + 1]:x) (bedCount:y) area 1
            scenarioI ++ scenarioII ++ scenarioIII
    else []


-- Basic function to handle the comparison operator for the sortBy operation. sorted in ascending order.
sortSceneI option1 option2
    | (areaI option1) <= (areaI option2) = LT
    | otherwise = GT

-- Basic function to handle the comparison operator for the sortBy operation. sorted in descending order.
sortSceneII option1 option2
    | (areaII option1) >= (areaII option2) = LT
    | otherwise = GT

-- Data structure to hold the final plan of the plot or the final design.
data PlotPlan  = PlotPlan {
        bedroomF :: [Int],
        hallF :: [Int],
        kitchenF :: [Int],
        bathroomF :: [Int],
        gardenF :: [Int],
        balconyF :: [Int],
        areaF :: Int,
        unUsedArea :: Int
    }

-- Fucntion to handle the genration of the PlotPlan struct when required.
createPlotPlan :: SceneI -> SceneII -> Int -> PlotPlan
createPlotPlan scene1 scene2 area = do
    PlotPlan {
        bedroomF = (bedroomI scene1),
        hallF = (hallI scene1),
        kitchenF = (kitchenI scene1),
        bathroomF = (bathroomI scene1),
        gardenF = (gardenII scene2),
        balconyF = (balconyII scene2),
        areaF = (areaI scene1) + (areaII scene2),
        unUsedArea = area - ((areaI scene1) + (areaII scene2))
    }

-- Function to merge two structs SceneI and SceneII to find the struct with minimum unUsed area left.
findOptimal :: [SceneI] -> [SceneII] -> Int -> PlotPlan -> PlotPlan
findOptimal _ [] _ base = base
findOptimal [] _ _ base = base
findOptimal (scene1 : x) (scene2 : y) area base = do
    let scene = createPlotPlan scene1 scene2 area
    if (unUsedArea scene < unUsedArea base) && (unUsedArea scene >= 0) then do         -- Condition in which the unUsed area of current is less than base.
        if (areaI scene1) + (areaII scene2) < area then
            findOptimal x (scene2 : y) area scene
        else 
            findOptimal (scene1 : x) y area scene
    else do                                                   -- Otherwise case.
        if (areaI scene1) + (areaII scene2) < area then
            findOptimal x (scene2 : y) area scene
        else 
            findOptimal (scene1 : x) y area scene

-- Function to calculate the design of the given plot using the "meet-in-the-middle" approach. 
design :: Int -> Int -> Int -> IO ()
design area bedroom hall = do
    let bathroom = bedroom + 1         -- Number of bathromm is one greater than the number of bedrooms
    let kitchen = minKitchen bedroom

    let garden = 1         -- Number of gardens and balcony is 1. 
    let balcony = 1

    let minTotalArea = (bedroom * 100) + (hall * 150) + (bathroom * 20) + (kitchen * 35) + (garden * 100) + (balcony * 25)
    putStrLn ("Minimum Area Needed For Basic Arrangement: " ++ (show minTotalArea))
    putStrLn("")

    if (area < minTotalArea) then do
        putStrLn ("Sorry! Area Is Too Small To Design.")
    else do
        putStrLn ("Most Effective Design Possible Is Below: ")

    if (area >= minTotalArea) then do
        -- Dimensions of the different rooms to be designed.
        let sizeKitchen = [7, 5]
        let sizeBedroom = [10, 10]
        let sizeHall = [15, 10]
        let sizeBalcony = [5, 5]
        let sizeGarden = [10, 10]
        let sizeBathroom = [4, 5] 

        let sizeRoomI = [sizeBedroom, sizeHall, sizeKitchen, sizeBathroom]   -- List of dimensions of different rooms required for planning the design.
        let sizeRoomII = [sizeGarden, sizeBalcony]

        let countRoomI = [bedroom, hall, kitchen, bathroom] -- Count of rooms are fixed before and their list to select for increase.
        let countRoomII = [garden, balcony]

        let scenarioI = buildBedroom sizeRoomI countRoomI area 0

        let scenarioII = buildGarden sizeRoomII countRoomII area 0

        let sortedScenarioI = sortBy sortSceneI scenarioI
        let sortedScenarioII = sortBy sortSceneII scenarioII

        let base = PlotPlan {
                                bedroomF = [],
                                hallF = [],
                                kitchenF = [],
                                bathroomF = [],
                                gardenF = [],
                                balconyF = [],
                                areaF = 0,
                                unUsedArea = area   
                            }

        let optimalDesign = findOptimal sortedScenarioI sortedScenarioII area base
        let countMachine = [bedroom, hall, kitchen, bathroom, balcony, balcony]
        print (displayAnswer optimalDesign countMachine [])
    else do
        putStrLn ("")

-- Function to handle the single string format to display the data structure.
displayAnswer :: PlotPlan -> [Int] -> ShowS
displayAnswer result roomCount = do
    let bedLen = ((bedroomF result)!!0)             -- Let all the parameters and finally create a show string to be displayed.
    let bedWid = ((bedroomF result)!!1)
    let hallLen = ((hallF result)!!0)
    let hallWid = ((hallF result)!!1)
    let kitLen = ((kitchenF result)!!0)
    let kitWid = ((kitchenF result)!!1)
    let bathLen = ((bathroomF result)!!0)
    let bathWid = ((bathroomF result)!!1)
    let garLen = ((gardenF result)!!0)
    let garWid = ((gardenF result)!!1)
    let balLen = ((balconyF result)!!0)
    let balWid = ((balconyF result)!!1)
    let unusedSpace = (unUsedArea result)
    showString "Bedroom: (" . shows (roomCount!!0) . showString ") ". shows (bedLen) . showString "X" .  shows (bedWid) . showString "," . showString "Hall: (" . shows (roomCount!!1) . showString ") ". shows (hallLen) . showString "X" .  shows (hallWid) . showString "," . showString "Kitchen: (" . shows (roomCount!!2) . showString ") ". shows (kitLen) . showString "X" .  shows (kitWid) . showString "," . showString "Bathroom: (" . shows (roomCount!!3) . showString ") ". shows (bathLen) . showString "X" .  shows (bathWid) . showString "," . showString "Balcony: (" . shows (roomCount!!4) . showString ") ". shows (balLen) . showString "X" .  shows (balWid) . showString "," . showString "Garden: (" . shows (roomCount!!5) . showString ") ". shows (garLen) . showString "X" .  shows (garWid) . showString "," . showString "Unused Space:" . shows (unusedSpace)