% Style check to remove unnecessory warnings.
:- style_check(-singleton).

% Bus Information :- The format is bus(Number, Origin, Destination Place, Departure Time, Arrival Time, Distance, Cost).

bus(123,amingaon,jalukbari,14.5,15,10,10).
bus(13,jalukbari,paltanbazar,16,18,10,10).
bus(10,amingaon,paltanbazar,15,15.5,30,100).
bus(756,panbazar,chandmari,16,16.5,7,8).

% Depth First Search function for finding the path with the minimum travel time.

dfs_OptimalTime(X, Path, Y, TotalDistance, TotalCost, TotalTime) :-
	(	
		% If the current node is not visited in path considered.
		not(member(X, Path)) ->
			% Add X to the current Path, and then recursively Depth First Search for all of its unvisited child nodes.
			append(Path, [X], UpdatedPath),
			(
				(X == Y) ->
					nb_getval(optimalTime, OptimalTime),
    				UpdatedOptimalTime is min(OptimalTime, TotalTime),
				    nb_setval(optimalTime, UpdatedOptimalTime),
				    (
				        % If current path has the minimum cost value (till now), update minimum path list
				        (UpdatedOptimalTime =:= TotalTime) -> 
				        	nb_setval(optimalPath, UpdatedPath),
				        	nb_setval(optimalDistance, TotalDistance),
				        	nb_setval(optimalCost, TotalCost) 
				        ; 
				        write("")
				    )
				;
					write("")
			),
			forall(
				bus(_, X, DP, ST, ET, Distance, Cost),
				(	
					UpdatedCost is TotalCost + Cost,
					UpdatedDistance is TotalDistance + Distance,
					Time is ET - ST,
					UpdatedTime is TotalTime + Time,
					dfs_OptimalTime(DP, UpdatedPath, Y, UpdatedDistance, UpdatedCost, UpdatedTime)
				)
			)
		;
			write("")
	).


% Depth First Search function for finding the path with the minimum cost.

dfs_OptimalCost(X, Path, Y, TotalDistance, TotalCost, TotalTime) :-
	(	
		% If the current node is not visited in path considered.
		not(member(X, Path)) ->
			% Add X to the current Path, and then recursively Depth First Search for all of its unvisited child nodes.
			append(Path, [X], UpdatedPath),
			(
				(X == Y) ->
					nb_getval(optimalCost, OptimalCost),
    				UpdatedOptimalCost is min(OptimalCost, TotalCost),
				    nb_setval(optimalCost, UpdatedOptimalCost),
				    (
				        % If current path has the minimum cost value (till now), update minimum path list
				        (UpdatedOptimalCost =:= TotalCost) -> 
				        	nb_setval(optimalPath, UpdatedPath),
				        	nb_setval(optimalDistance, TotalDistance),
				        	nb_setval(optimalTime, TotalTime) 
				        ; 
				        write("")
				    )
				;
					write("")
			),
			forall(
				bus(_, X, DP, ST, ET, Distance, Cost),
				(	
					UpdatedCost is TotalCost + Cost,
					UpdatedDistance is TotalDistance + Distance,
					Time is ET - ST,
					UpdatedTime is TotalTime + Time,
					dfs_OptimalCost(DP, UpdatedPath, Y, UpdatedDistance, UpdatedCost, UpdatedTime)
				)
			)
		;
			write("")
	).





% Depth First Search function for finding the path with the minimum distance.

dfs_OptimalDistance(X, Path, Y, TotalDistance, TotalCost, TotalTime) :-
	(	
		% If the current node is not visited in path considered.
		not(member(X, Path)) ->
			% Add X to the current Path, and then recursively Depth First Search for all of its unvisited child nodes.
			append(Path, [X], UpdatedPath),
			(
				(X == Y) ->
					nb_getval(optimalDistance, OptimalDistance),
    				UpdatedOptimalDistance is min(OptimalDistance, TotalDistance),
				    nb_setval(optimalDistance, UpdatedOptimalDistance),
				    (
				        % If current path has the minimum distance value (till now), update minimum path list
				        (UpdatedOptimalDistance =:= TotalDistance) -> 
				        	nb_setval(optimalPath, UpdatedPath),
				        	nb_setval(optimalCost, TotalCost),
				        	nb_setval(optimalTime, TotalTime) 
				        ; 
				        write("")
				    )
				;
					write("")
			),
			forall(
				bus(_, X, DP, ST, ET, Distance, Cost),
				(	
					UpdatedDistance is TotalDistance + Distance,
					UpdatedCost is TotalCost + Cost,
					Time is ET - ST,
					UpdatedTime is TotalTime + Time,
					dfs_OptimalDistance(DP, UpdatedPath, Y, UpdatedDistance, UpdatedCost, UpdatedTime)
				)
			)
		;
			write("")
	).






% Function route(X, Y) to find optimal route between X and Y in terms of cost, time and distance.

route(X, Y) :-
	(
		writeln("---------------------------------------------------"),
		nb_setval(optimalDistance, 1000000),
    	nb_setval(optimalCost, 1000000),
    	nb_setval(optimalTime, 1000000),
    	nb_setval(optimalPath, []),

		% To check if atleast a path exists between X and Y by simple Depth First Search.

		dfs_OptimalDistance(X, [], Y, 0, 0, 0),

		nb_getval(optimalDistance, OptimalDistance1),
		nb_getval(optimalPath, OptimalPath1),
		nb_getval(optimalCost, OptimalCost1),
		nb_getval(optimalTime, OptimalTime1),

		not(OptimalDistance1=1000000),
		atomic_list_concat(OptimalPath1, ' -> ', Atom1),
		atom_string(Atom1, String1),
		writeln("Optimal Distance Path :"),
	    writeln(String1),
	    write("Minimum Distance To Travel : "), write(OptimalDistance1), writeln(" km"),
	    write("Cost : "),write("Rs "), writeln(OptimalCost1),
	    write("Travel Time : "), write(OptimalTime1), writeln(" hrs"),
	    writeln("---------------------------------------------------"),

	    nb_setval(optimalPath, []),
	    nb_setval(optimalTime, 1000000),
	    nb_setval(optimalCost, 1000000),
	    nb_setval(optimalDistance, 1000000),

	    dfs_OptimalCost(X, [], Y, 0, 0, 0),

	    nb_getval(optimalCost, OptimalCost2),
	    nb_getval(optimalPath, OptimalPath2),
	    nb_getval(optimalTime, OptimalTime2),
	    nb_getval(optimalDistance, OptimalDistance2),

	    not(OptimalCost2=1000000),
	    atomic_list_concat(OptimalPath2, ' -> ', Atom2),
		atom_string(Atom2, String2),
		writeln("Optimal Cost Path :"),
	    writeln(String2),
	    write("Minimum Cost To Travel : "), write("Rs "), writeln(OptimalCost2),
	    write("Distance Travelled : "), write(OptimalDistance2), writeln(" km"),
	    write("Travel Time : "), write(OptimalTime2),  writeln(" hrs"),
	    writeln("---------------------------------------------------"),

	    nb_setval(optimalPath, []),
	    nb_setval(optimalTime, 1000000),
	    nb_setval(optimalCost, 1000000),
	    nb_setval(optimalDistance, 1000000),

	    dfs_OptimalTime(X, [], Y, 0, 0, 0),

	    nb_getval(optimalCost, OptimalCost3),
	    nb_getval(optimalPath, OptimalPath3),
	    nb_getval(optimalTime, OptimalTime3),
	    nb_getval(optimalDistance, OptimalDistance3),

	    not(OptimalTime3=1000000),
	    atomic_list_concat(OptimalPath3, ' -> ', Atom3),
		atom_string(Atom3, String3),
		writeln("Optimal Travel Time Path :"),
	    writeln(String3),
	    write("Minimum Time To Travel : "), write(OptimalTime3), writeln(" hrs"),
	    write("Distance Travelled : "), write(OptimalDistance3), writeln(" km"),
	    write("Cost : "), write("Rs "), writeln(OptimalCost3),
	    writeln("---------------------------------------------------")

	).
