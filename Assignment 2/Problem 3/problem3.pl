% Style check to remove unnecessory warnings.
:- style_check(-singleton).

% Starting doors information in the format start(gx).
start(g1).
start(g2).
start(g3).
start(g4).

% Path information between different doors in the jail.
edge(g1,g5,4). 
edge(g2,g5,6).
edge(g3,g5,8). 
edge(g4,g5,9). 
edge(g1,g6,10). 
edge(g2,g6,9). 
edge(g3,g6,3).  
edge(g4,g6,5). 
edge(g5,g7,3). 
edge(g5,g10,4). 
edge(g5,g11,6). 
edge(g5,g12,7). 
edge(g5,g6,7). 
edge(g5,g8,9). 
edge(g6,g8,2). 
edge(g6,g12,3). 
edge(g6,g11,5). 
edge(g6,g10,9). 
edge(g6,g7,10). 
edge(g7,g10,2). 
edge(g7,g11,5). 
edge(g7,g12,7). 
edge(g7,g8,10). 
edge(g8,g9,3). 
edge(g8,g12,3). 
edge(g8,g11,4). 
edge(g8,g10,8). 
edge(g10,g15,5). 
edge(g10,g11,2). 
edge(g10,g12,5). 
edge(g11,g15,4). 
edge(g11,g13,5). 
edge(g11,g12,4). 
edge(g12,g13,7). 
edge(g12,g14,8). 
edge(g15,g13,3). 
edge(g13,g14,4). 
edge(g14,g17,5). 
edge(g14,g18,4).
edge(g17,g18,8).

% Checks that last door on path is the exit door (g17).
consecutive_edges([g17]) :-
	(
		write("")
	).

% Checks if two consecutive gates of a given path are part of an edge
consecutive_edges([Door, NextDoor|Tail]) :-
    (
        (edge(Door, NextDoor, _) ; edge(NextDoor, Door, _)),
        % Check remaining path recursively
        consecutive_edges([NextDoor|Tail])
    ).

% Checks if given path is valid
valid([Door|Tail]) :-
    (
        % Checks that given path starts with one of g1, g, g3, g4 (start gates).
        start(Door),
        consecutive_edges([Door|Tail])
    ).

% Function to print list of gates taken in the path.
printData([Door]) :-
    (
        writeln(Door)
    ).

% Function to print list of gates taken in the path.
printData([Door | NextDoor]) :-
    (
        write(Door), write(" -> "),
        printData(NextDoor)
    ).

% Function to calculate minimum distance when path reaches end door g17.
dfs_OptimalDistance(g17, Path, TotalDistance) :- 
    (
        % Add door to current path
        append(Path, [g17], UpdatedPath), 
        % Update minimum path distance value in case it is minimum.
        nb_getval(optimalDistance, OptimalDistance),
        UpdatedOptimalDistance is min(OptimalDistance, TotalDistance),
        nb_setval(optimalDistance, UpdatedOptimalDistance),
        (
            % If current path has the minimum distance value (till now), update minimum path list
            UpdatedOptimalDistance =:= TotalDistance -> nb_setval(optimalPath, UpdatedPath) 
            ; 
            write("")
        )
    ).

% Function to recursively calculate minimum distance by doing Depth First Search.
dfs_OptimalDistance(Door, Path, TotalDistance) :-
    (
        not(member(Door, Path)) -> 
            % Add door to current path
            append(Path, [Door], UpdatedPath),
            % For all possible neighbours of the door, apply Depth First Search recursively
            forall(
                edge(Door, NextDoor, Distance), 
                (
                    % Update total distance at each step
                    UpdatedDistance is TotalDistance + Distance, 
                    dfs_OptimalDistance(NextDoor, UpdatedPath, UpdatedDistance)
                )
            )
        ;
            write("")
    ).

% If Depth First Search reaches exit door g17 during process of finding all paths.
dfs_Basic(g17, Path) :-
    ( 
        % Add last door to current path.
        append(Path, [g17], UpdatedPath), 
        % Convert path list to concatenated string
        atomic_list_concat(UpdatedPath, ' -> ', Atom), atom_string(Atom, String),
        % Write string to terminal and file output.txt
        format('~w~n', String),
        open('output.txt', append, Stream),
        write(Stream, String),
        nl(Stream),
        close(Stream)
    ).

% Basic Depth First Search to find all possible paths.
dfs_Basic(Door, Path) :-
    (
        % If door has not been visited yet.
        % Note that if door had been already visited, exploring it would create a cycle and infinite paths would be possible.
        not(member(Door, Path)) -> 
            % Add door to current path
            append(Path, [Door], UpdatedPath),
            % For all possible neighbours of the door, apply Depth First Search recursively
            forall(
                edge(Door, NextDoor, _); edge(NextDoor, Door, _), 
                (
                    dfs_Basic(NextDoor, UpdatedPath)
                )
            )
        ;
            write("")
    ).

% Prints all possible paths using which the prisoner can escape the jail.
paths() :-
    (
        forall(start(X), dfs_Basic(X, []))
    ).

% Prints the optimal path (least distance) using which the prisoner can escape the jail.
optimal() :-
    (
        % Initialize Global variables to store the optimal distance and path
        nb_setval(optimalDistance, 1000000),
        nb_setval(optimalPath, []),

        % Apply DFS from all start gates
        forall(start(Door), dfs_OptimalDistance(Door, [], 0)),

        % Get and output the optimal distance and path values.
        nb_getval(optimalDistance, OptimalDistance),
        format('Optimal Distance :- ~d~n', OptimalDistance),
        nb_getval(optimalPath, OptimalPath),
        atomic_list_concat(OptimalPath, ' -> ', Atom), atom_string(Atom, String),
        format('Optimal Path :- ~w~n', String)
    ).

