% DataBase Information :- For new data term copy paste here and run the code.
parent(jatin,avantika).
parent(jolly,jatin).
parent(jolly,kattappa).
parent(manisha,avantika).
parent(manisha,shivkami).
parent(bahubali,shivkami).
male(kattappa).
male(jolly).
male(bahubali).
female(shivkami).
female(avantika).

% Uncle :- Is defined as the brother of one's father or mother.
% uncle(X, Y) :- means X is the uncle of Y.

uncle(X, Y) :- 
	(
		male(X),
		parent(P, X),
		parent(Z, Y),
		parent(P, Z)
	).

% Function to find the common parent between X and Y, if it is P or not.

oneParentCommon(P, X, Y) :-
	(
		parent(P, X),
		parent(P, Y)
	).

% Function to find the other parent between X and Y, ie O.

otherParent(P, O, X) :-
	(
		parent(O, X),
		not(P=O)
	).

% Half Sister :- Is defined as the sister with whom only one parent is common.
% halfsister(X, Y) :- means X is the halfsister of Y.

halfsister(X, Y) :-
	(
		female(X),
		oneParentCommon(P, X, Y),
		otherParent(P, OX, X),
		otherParent(P, OY, Y),
		not(OX=OY)
	).

