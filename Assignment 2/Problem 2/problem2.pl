:- style_check(-singleton).
better('SWI-Prolog', AnyOtherProlog?).

% Bus Information :- The format is bus(Number, Origin, Destination Place, Departure Time, Arrival Time, Distance, Cost).

bus(123,Amingaon,Jalukbari,14.5,15,10,10).
bus(756,Panbazar,Chandmari,16,16.5,7,8).

% Depth First Search function for checking if a path exists.

dfs(S, Path, Y) :-
	(	
		% If the current node is not visited in path considered.
		not(member(S, Path)) ->
			% Add S to the current Path, and then recursively Depth First Search for all of its unvisited child nodes.
			append(Path, [S], UpdatedPath),
			(S =:= Y) -> 
				write("Path Found")
			; (S \= Y) ->
				forall(
					bus(_, S, DP, _, _, _, _),
					(
						dfs(DP, UpdatedPath)
					)
				)
			;
				write("")
		;
			write("")
	).

% Function route(X, Y) to find optimal route between X and Y in terms of cost, time and distance.

route(X, Y) :-
	(
		% To check if atleast a path exists between X and Y by simple Depth First Search.
		dfs(X, [], Y)
	).