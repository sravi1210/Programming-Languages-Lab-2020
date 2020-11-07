-- Include important header files.
import Data.List
import Data.IORef
import Data.Maybe
import System.Random
import System.IO.Unsafe

-- Team acronyms for all the 12 registered teams given in the problem statement.
teamNames = ["BS", "CM", "CH", "CV", "CS", "DS", "EE", "HU", "MA", "ME", "PH", "ST"]

-- Take any index between 0 and len(list)-1 | Make that index the first value in the list | Create a new list with (first 'index' elements ++ list by dropping first index+1 elements) | Run shuffle again on this newly created array.
shuffle teams = if length teams < 2 then return teams else do
        index <- System.Random.randomRIO (0, length(teams)-1)
        temp <- shuffle (take index teams ++ drop (index+1) teams)
        return (teams!!index : temp)

-- Create a global variable to store shuffle team list for all other operations.
shuffleTeam = unsafePerformIO (shuffle teamNames)

-- Data structure to hold values of the schedule or one fixture.
data Schedule = Schedule {
                         teamNo1 :: String,
                         teamNo2 :: String,
                         matchTime :: String,
                         matchDay :: String
                        } deriving (Show, Eq)

-- Function to create schedule information for the shuffled team list array
createSchedule teams 4 = []  -- In case when all fixtures are created and no teams left.
createSchedule teams day = do      
    let nextDay = day + 1         -- Create fixture for the 4 teams today and recurse for the next day.
    Schedule {
        teamNo1 = teams !! 0, 
        teamNo2 = teams !! 1,
        matchTime="9:30 AM",
        matchDay=(show day) ++ "-12-2020"
    } : Schedule {
        teamNo1 = teams !! 2, 
        teamNo2 = teams !! 3,
        matchTime="7:30 PM",
        matchDay=(show day) ++ "-12-2020"
    } : createSchedule (drop 4 teams) nextDay   -- Recurse to create fixture for the next day.


-- Function to print fixture details for all scheduled matches.
printFixtures :: [Schedule] -> IO ()
printFixtures [] = putStrLn ""       -- Incase of no matches left.
printFixtures matchFixture = do         -- Recurse and print all other matches scheduled.
    let fixture = matchFixture !! 0
    let tN1 = teamNo1 fixture
    let tN2 = teamNo2 fixture 
    let mD = matchDay fixture
    let mT = matchTime fixture
    print(tN1 ++ " vs " ++ tN2 ++ " " ++ mD ++ " " ++ mT)
    printFixtures (drop 1 matchFixture)

-- Fucntion to print single schedule ot match detail.
printFixture :: Schedule -> IO ()
printFixture fixture = do
    let tN1 = teamNo1 fixture
    let tN2 = teamNo2 fixture 
    let mD = matchDay fixture
    let mT = matchTime fixture
    print(tN1 ++ " vs " ++ tN2 ++ " " ++ mD ++ " " ++ mT) 

-- Function to display all schedules or schedule of some speciific teams.
fixture :: String -> IO ()
fixture option = do
    let matchFixtures = createSchedule shuffleTeam 1
    if option == "all"
        then printFixtures matchFixtures
        else if option `elem` teamNames
            then do
                let index = fromMaybe (0) $ (findIndex (==option) shuffleTeam)
                let dIndex = (index `div` 2)
                let ftr = matchFixtures!!dIndex
                printFixture ftr
            else putStrLn "Sorry! No Such Team Exists"

-- Function to return Index of the corresponding match which is going to happen next.
returnIndex day time = do
    let index = (2 * day) - 2
    if time >= 0 && time <= 9.30 then index
        else if time > 9.30 && time <= 19.30 then index+1
            else index+2

-- Function to handle querying next match details.
nextMatch day time = do
    let matchFixtures = createSchedule shuffleTeam 1
    if day >=1 && day <=3 && time >= 0 && time <= 24
        then do
            let index = returnIndex day time
            if index < 6 
                then do
                    let ftr = matchFixtures!!index
                    printFixture ftr
                else putStrLn "No Matches Left! Round Over"
        else putStrLn "Enter Day Between (1-3) And Time Between (0-24)"

-- Main function for testing purposes.
main = do
    fixture "all"
    fixture "HU"
    fixture "ST"
    fixture "ANY"
    nextMatch 2 20


