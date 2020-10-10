:- style_check(-singleton).

% Bus Information :- The format is bus(Number, Origin, Destination Place, Departure Time, Arrival Time, Distance, Cost).

bus(123,amingaon,jalukbari,14.5,15,10,10).
bus(13,jalukbari,paltanbazar,16,18,10,10).
bus(756,panbazar,chandmari,16,16.5,7,8).


% Depth First Search function for finding the path with the minimum cost.

dfs_OptimalCost(X, Path, Y, TotalCost) :-
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
				        UpdatedOptimalCost =:= TotalCost -> nb_setval(optimalPath, UpdatedPath) 
				        ; 
				        write("")
				    )
				;
					write("")
			),
			forall(
				bus(_, X, DP, _, _, _, Cost),
				(	
					UpdatedCost is TotalCost + Cost,
					dfs_OptimalCost(DP, UpdatedPath, Y, UpdatedCost)
				)
			)
		;
			write("")
	).





% Depth First Search function for finding the path with the minimum distance.

dfs_OptimalDistance(X, Path, Y, TotalDistance) :-
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
				        UpdatedOptimalDistance =:= TotalDistance -> nb_setval(optimalPath, UpdatedPath) 
				        ; 
				        write("")
				    )
				;
					write("")
			),
			forall(
				bus(_, X, DP, _, _, Distance, _),
				(	
					UpdatedDistance is TotalDistance + Distance,
					dfs_OptimalDistance(DP, UpdatedPath, Y, UpdatedDistance)
				)
			)
		;
			write("")
	).






% Function route(X, Y) to find optimal route between X and Y in terms of cost, time and distance.

route(X, Y) :-
	(
		nb_setval(optimalDistance, 1000000),
    	nb_setval(optimalCost, 1000000),
    	nb_setval(optimalTime, 1000000),
    	nb_setval(optimalPath, []),

		% To check if atleast a path exists between X and Y by simple Depth First Search.

		dfs_OptimalDistance(X, [], Y, 0),

		nb_getval(optimalDistance, OptimalDistance),
		nb_getval(optimalPath, OptimalPath),

		not(OptimalDistance=1000000),
		atomic_list_concat(OptimalPath, ' -> ', Atom),
		atom_string(Atom, String),
		writeln("Optimal Distance Path :"),
	    writeln(String),
	    write("Minimum Distance To Travel : "), write(OptimalDistance), writeln(" km"),
	    writeln(""),
	    nb_setval(optimalPath, []),
	    dfs_OptimalCost(X, [], Y, 0),

	    nb_getval(optimalCost, OptimalCost),
	    nb_getval(optimalPath, OptimalPath),

	    not(OptimalCost=1000000),
	    atomic_list_concat(OptimalPath, ' -> ', Atom),
		atom_string(Atom, String),
		writeln("Optimal Cost Path :"),
	    writeln(String),
	    write("Minimum Cost To Travel : "), write("Rs "), writeln(OptimalCost),
	    writeln("")
	).
