:- style_check(-singleton).

% Bus Information :- The format is bus(Number, Origin, Destination Place, Departure Time, Arrival Time, Distance, Cost).

bus(123,amingaon,jalukbari,14.5,15,10,10).
bus(13,jalukbari,paltanbazar,16,18,10,10).
bus(756,panbazar,chandmari,16,16.5,7,8).

% Depth First Search function for checking if a path exists.

dfs(X, Path, Y) :-
	(	
		% If the current node is not visited in path considered.
		not(member(X, Path)) ->
			% Add X to the current Path, and then recursively Depth First Search for all of its unvisited child nodes.
			append(Path, [X], UpdatedPath),
			(
				(X == Y) ->
					write("Ravi\n"),
					atomic_list_concat(UpdatedPath, ' -> ', Atom),
					atom_string(Atom, String),
				    format('~w~n', String),
				    open('output.txt', append, Stream),
				    write(Stream, String),
				    nl(Stream),
				    close(Stream)
				;
					write("")
			),
			forall(
				bus(_, X, DP, _, _, _, _),
				(	
					dfs(DP, UpdatedPath, Y)
				)
			)
		;
			write("")
	).

% Function route(X, Y) to find optimal route between X and Y in terms of cost, time and distance.

route(X, Y) :-
	(
		% To check if atleast a path exists between X and Y by simple Depth First Search.
		dfs(X, [], Y)

	).
