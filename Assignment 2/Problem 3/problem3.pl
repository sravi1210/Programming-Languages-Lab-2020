% Style check to remove unnecessory warnings.
:- style_check(-singleton).

% Starting gates information in the format start(gx).
start(g1).
start(g2).
start(g3).
start(g4).

% Path information between different gates in the jail.
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

% Function to calculate minimum distance when path reaches end gate g17.
dfs_OptimalDistance(g17, Path, TotalDistance) :- 
    (
        % Add gate to current path
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

% Function to recursively calculate minimum distance by doinf Depth First Search.
dfs_OptimalDistance(Gate, Path, TotalDistance) :-
    (
        not(member(Gate, Path)) -> 
            % Add gate to current path
            append(Path, [Gate], UpdatedPath),
            % For all possible neighbours of the gate, apply Depth First Search recursively
            forall(
                edge(Gate, NextGate, Distance), 
                (
                    % Update total distance at each step
                    UpdatedDistance is TotalDistance + Distance, 
                    dfs_OptimalDistance(NextGate, UpdatedPath, UpdatedDistance)
                )
            )
        ;
            write("")
    ).

% If Depth First Search reaches exit gate g17 during process of finding all paths.
dfs_Basic(g17, Path, _) :- 
    % Add last gate to current path.
    append(Path, [g17], UpdatedPath), 
    % Convert path list to concatenated string
    % atomic_list_concat(UpdatedPath, ' -> ', Atom), atom_string(Atom, String),
    % Write string to terminal and file output.txt
    % format('~w~n', String),
    % open('output.txt', append, Stream),
    % write(Stream, String),
    % nl(Stream),
    % close(Stream)
    printData(UpdatedPath).

% Basic Depth First Search to find all possible paths.
dfs_Basic(Gate, Path, TotalDistance) :-
    (
        % If gate has not been visited yet.
        % Note that if gate had been already visited, exploring it would create a cycle and infinite paths would be possible.
        not(member(Gate, Path)) -> 
            % Add gate to current path
            append(Path, [Gate], UpdatedPath),
            % For all possible neighbours of the gate, apply Depth First Search recursively
            forall(
                edge(Gate, NextGate, Distance); edge(NextGate, Gate, Distance), 
                (
                    % Update total distance at each step
                    UpdatedDistance is TotalDistance + Distance, 
                    dfs_Basic(NextGate, UpdatedPath, UpdatedDistance)
                )
            )
        ;
            write("")
    ).

% Prints all possible paths using which the prisoner can escape the jail.
paths() :-
    (
        forall(start(X), dfs_Basic(X, [], 0))
    ).

% Prints the optimal path (least distance) using which the prisoner can escape the jail.
optimal() :-
    (
        % Initialize Global variables to store the optimal distance and path
        nb_setval(optimalDistance, 1000000),
        nb_setval(optimalPath, []),

        % Apply DFS from all start gates
        forall(start(Gate), dfs_OptimalDistance(Gate, [], 0)),

        % Get and output the optimal distance and path values.
        nb_getval(optimalDistance, OptimalDistance),
        format('Optimal Distance :- ~d~n', OptimalDistance),
        nb_getval(optimalPath, OptimalPath),
        atomic_list_concat(OptimalPath, ' -> ', Atom), atom_string(Atom, String),
        format('Optimal Path :- ~w~n', String)
    ).


% Checks that last gate on path is the exit gate (g17).
consecutive_edges([g17]).


% Checks if two consecutive gates of a given path are part of an edge
consecutive_edges([Gate, NextGate|Tail]) :-
    (
        (edge(Gate, NextGate, _) ; edge(NextGate, Gate, _)),
        % Check remaining path recursively
        consecutive_edges([NextGate|Tail])
    ).

% Checks if given path is valid
valid([Gate|Tail]) :-
    (
        % Checks that given path starts with one of g1, g, g3, g4 (start gates).
        start(Gate),
        consecutive_edges([Gate|Tail])
    ).

% Function to print list of places and bus Id taken, for base case.
printData([Gate]) :-
    (
        writeln(Gate)
    ).

% Function to print list of places and bus Id taken.
printData([Gate | NextGate]) :-
    (
        write(Gate), write(" -> "),
        printData(NextGate)
    ).
