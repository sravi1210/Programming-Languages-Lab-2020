% Style check to remove unnecessory warnings.
:- style_check(-singleton).

% Bus Information :- The format is bus(Number, Origin, Destination Place, Departure Time, Arrival Time, Distance, Cost).
bus(123,amingaon,jalukbari,14.5,15,10,10).
bus(13,jalukbari,paltanbazar,13,18,10,10).
bus(10,amingaon,paltanbazar,15,15.5,30,1).
bus(756,panbazar,chandmari,16,16.5,7,8).

% Function to calculate the travel time betweeen the buses.
find_TotalTime([X, Y|Z], 0, Count) :-
	(
		nb_getval(totalTime, TotalTime),
		TempTime is TotalTime + Y,
		UpdatedTime is TempTime - X,
		nb_setval(totalTime, UpdatedTime),
		UpdatedCount is Count - 1,
		find_TotalTime([Y|Z], 1, UpdatedCount)
	).

find_TotalTime(X, 0, 1) :-
	(
		write("")
	).

% Function to calculate the travel time betweeen the buses.
find_TotalTime([X, Y|Z], 1, Count) :-
	(
		nb_getval(totalTime, TotalTime),
		(
			(Y > X) ->
				TempTime is TotalTime + Y,
				UpdatedTime is TempTime - X,
				nb_setval(totalTime, UpdatedTime)
			;
			(Y < X) ->
				TempTime1 is TotalTime + Y,
				TempTime2 is TempTime1 + 24,
				UpdatedTime is TempTime2 - X,
				nb_setval(totalTime, UpdatedTime)
			;
				write("")
		),
		UpdatedCount is Count - 1,
		find_TotalTime([Y|Z], 0, UpdatedCount)
	).

find_TotalTime(X, 1, 1) :-
	(
		write("")
	).

% Depth First Search function for finding the path with the minimum travel time.
dfs_OptimalTime(X, Path, Bus, Y, TotalDistance, TotalCost, TotalTime, Count) :-
	(	
		% If the current node is not visited in path considered.
		not(member(X, Path)) ->
			% Add X to the current Path, and then recursively Depth First Search for all of its unvisited child nodes.
			append(Path, [X], UpdatedPath),
			(
				(X == Y) ->
					% If the destination is same as source node, then a path is reached thus store the results.
					nb_getval(optimalTime, OptimalTime),
					nb_setval(totalTime, 0),
					find_TotalTime(TotalTime, 0, Count),
					nb_getval(totalTime, OverallTime),
    				UpdatedOptimalTime is min(OptimalTime, OverallTime),
				    nb_setval(optimalTime, UpdatedOptimalTime),
				    (
				        % If current path has the minimum time value (till now), update minimum path list
				        (UpdatedOptimalTime =:= OverallTime) -> 
				        	nb_setval(optimalPath, UpdatedPath),
				        	nb_setval(optimalBus, Bus),
				        	nb_setval(optimalDistance, TotalDistance),
				        	nb_setval(optimalCost, TotalCost) 
				        ; 
				        write("")
				    )
				;
					write("")
			),
			forall(
				% Iterate through all possible paths and update thhe values in each one of them. 
				bus(ID, X, DP, ST, ET, Distance, Cost),
				(	
					UpdatedCost is TotalCost + Cost,
					UpdatedDistance is TotalDistance + Distance,
					append(TotalTime, [ST], TempTime),
					append(TempTime, [ET], UpdatedTime),
					UpdatedCount is Count + 2,
					append(Bus, [ID], UpdatedBus),
					dfs_OptimalTime(DP, UpdatedPath, UpdatedBus, Y, UpdatedDistance, UpdatedCost, UpdatedTime, UpdatedCount)
				)
			)
		;
			write("")
	).


% Depth First Search function for finding the path with the minimum cost.
dfs_OptimalCost(X, Path, Bus, Y, TotalDistance, TotalCost, TotalTime, Count) :-
	(	
		% If the current node is not visited in path considered.
		not(member(X, Path)) ->
			% Add X to the current Path, and then recursively Depth First Search for all of its unvisited child nodes.
			append(Path, [X], UpdatedPath),
			(
				(X == Y) ->
					% If the destination is same as source node, then a path is reached thus store the results.
					nb_getval(optimalCost, OptimalCost),
    				UpdatedOptimalCost is min(OptimalCost, TotalCost),
				    nb_setval(optimalCost, UpdatedOptimalCost),
				    (
				        % If current path has the minimum cost value (till now), update minimum path list
				        (UpdatedOptimalCost =:= TotalCost) -> 
				        	nb_setval(optimalPath, UpdatedPath),
				        	nb_setval(optimalDistance, TotalDistance),
				        	nb_setval(optimalBus, Bus),
				        	nb_setval(totalTime, 0),
				        	find_TotalTime(TotalTime, 0, Count),
				        	nb_getval(totalTime, TempTime),
				        	nb_setval(optimalTime, TempTime)

				        ; 
				        write("")
				    )
				;
					write("")
			),
			forall(
				% Iterate through all possible paths and update thhe values in each one of them.
				bus(ID, X, DP, ST, ET, Distance, Cost),
				(	
					UpdatedCost is TotalCost + Cost,
					UpdatedDistance is TotalDistance + Distance,
					append(TotalTime, [ST], TempTime),
					append(TempTime, [ET], UpdatedTime),
					append(Bus, [ID], UpdatedBus),
					UpdatedCount is Count + 2,
					dfs_OptimalCost(DP, UpdatedPath, UpdatedBus, Y, UpdatedDistance, UpdatedCost, UpdatedTime, UpdatedCount)
				)
			)
		;
			write("")
	).

% Depth First Search function for finding the path with the minimum distance.
dfs_OptimalDistance(X, Path, Bus, Y, TotalDistance, TotalCost, TotalTime, Count) :-
	(	
		% If the current node is not visited in path considered.
		not(member(X, Path)) ->
			% Add X to the current Path, and then recursively Depth First Search for all of its unvisited child nodes.
			append(Path, [X], UpdatedPath),
			(
				(X == Y) ->
					% If the destination is same as source node, then a path is reached thus store the results.
					nb_getval(optimalDistance, OptimalDistance),
    				UpdatedOptimalDistance is min(OptimalDistance, TotalDistance),
				    nb_setval(optimalDistance, UpdatedOptimalDistance),
				    (
				        % If current path has the minimum distance value (till now), update minimum path list
				        (UpdatedOptimalDistance =:= TotalDistance) -> 
				        	nb_setval(optimalPath, UpdatedPath),
				        	nb_setval(optimalBus, Bus),
				        	nb_setval(totalTime, 0),
				        	find_TotalTime(TotalTime, 0, Count),
				        	nb_getval(totalTime, TempTime),
				        	nb_setval(optimalCost, TotalCost),
				        	nb_setval(optimalTime, TempTime) 
				        ; 
				        write("")
				    )
				;
					write("")
			),
			% Iterate through all possible paths and update thhe values in each one of them.
			forall(
				bus(ID, X, DP, ST, ET, Distance, Cost),
				(	
					UpdatedDistance is TotalDistance + Distance,
					UpdatedCost is TotalCost + Cost,
					append(TotalTime, [ST], TempTime),
					append(TempTime, [ET], UpdatedTime),
					append(Bus, [ID], UpdatedBus),
					UpdatedCount is Count + 2,
					dfs_OptimalDistance(DP, UpdatedPath, UpdatedBus, Y, UpdatedDistance, UpdatedCost, UpdatedTime, UpdatedCount)
				)
			)
		;
			write("")
	).


% Function to print list of places and bus Id taken, for base case.
printData([Place], []) :-
	(
		write(Place),
		writeln("")
	).

% Function to print list of places and bus Id taken.
printData([Place | NextPlace], [Bus | NextBus]) :-
	(
		write(Place),write("("), write(Bus), write(") "),
		printData(NextPlace, NextBus)
	).

% Function route(X, Y) to find optimal route between X and Y in terms of cost, time and distance.
route(X, Y) :-
	(
		% All Global variables used in the code.
		writeln("---------------------------------------------------"),
		nb_setval(optimalDistance, 1000000),
    	nb_setval(optimalCost, 1000000),
    	nb_setval(optimalTime, 1000000),
    	nb_setval(optimalPath, []),
    	nb_setval(optimalBus, []),
    	nb_setval(totalTime, 0),

		% To calculate minimum distance between X and Y by simple Depth First Search.
		dfs_OptimalDistance(X, [], [], Y, 0, 0, [], 0), 

		nb_getval(optimalDistance, OptimalDistance1),
		nb_getval(optimalPath, OptimalPath1),
		nb_getval(optimalBus, OptimalBus1),
		nb_getval(optimalCost, OptimalCost1),
		nb_getval(optimalTime, OptimalTime1),
		(
			(OptimalDistance1 =:= 1000000) ->
				writeln("No Paths Exists")
			;
				write("")
		),
		not(OptimalDistance1=1000000),
		writeln("Optimal Distance Path :"),
	    printData(OptimalPath1, OptimalBus1),
	    write("Minimum Distance To Travel : "), write(OptimalDistance1), writeln(" km"),
	    write("Cost : "),write("Rs "), writeln(OptimalCost1),
	    write("Travel Time (Including delay between Buses) : "), write(OptimalTime1), writeln(" hrs"),
	    writeln("---------------------------------------------------"),

	    nb_setval(optimalPath, []),
	    nb_setval(optimalBus, []),
	    nb_setval(optimalTime, 1000000),
	    nb_setval(optimalCost, 1000000),
	    nb_setval(optimalDistance, 1000000),

	    % To calculate minimum cost between X and Y by simple Depth First Search.
	    dfs_OptimalCost(X, [], [], Y, 0, 0, [], 0),

	    nb_getval(optimalCost, OptimalCost2),
	    nb_getval(optimalPath, OptimalPath2),
	    nb_getval(optimalBus, OptimalBus2),
	    nb_getval(optimalTime, OptimalTime2),
	    nb_getval(optimalDistance, OptimalDistance2),

	    not(OptimalCost2=1000000),
		writeln("Optimal Cost Path :"),
	    printData(OptimalPath2, OptimalBus2),
	    write("Minimum Cost To Travel : "), write("Rs "), writeln(OptimalCost2),
	    write("Distance Travelled : "), write(OptimalDistance2), writeln(" km"),
	    write("Travel Time (Including delay between Buses) : "), write(OptimalTime2),  writeln(" hrs"),
	    writeln("---------------------------------------------------"),

	    nb_setval(optimalPath, []),
	    nb_setval(optimalBus, []),
	    nb_setval(optimalTime, 1000000),
	    nb_setval(optimalCost, 1000000),
	    nb_setval(optimalDistance, 1000000),

	    % To calculate minimum travel time between X and Y by simple Depth First Search.
	    dfs_OptimalTime(X, [], [], Y, 0, 0, [], 0),

	    nb_getval(optimalCost, OptimalCost3),
	    nb_getval(optimalPath, OptimalPath3),
	    nb_getval(optimalBus, OptimalBus3),
	    nb_getval(optimalTime, OptimalTime3),
	    nb_getval(optimalDistance, OptimalDistance3),

	    not(OptimalTime3=1000000),
		writeln("Optimal Travel Time Path :"),
	    printData(OptimalPath3, OptimalBus3),
	    write("Minimum Time To Travel (Including delay between Buses) : "), write(OptimalTime3), writeln(" hrs"),
	    write("Distance Travelled : "), write(OptimalDistance3), writeln(" km"),
	    write("Cost : "), write("Rs "), writeln(OptimalCost3),
	    writeln("---------------------------------------------------")
	).
