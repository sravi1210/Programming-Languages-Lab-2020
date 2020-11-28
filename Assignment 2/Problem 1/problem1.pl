% DataBase Information :- For new data term copy paste here and run the code.
parent(ram,bha).
parent(ram,bir).
parent(ram,sat).
parent(bha,nar).
parent(bha,par).
parent(sat,st).
parent(pre,st).
parent(sat,ju).
parent(sat,ch).
parent(rsh,ju).
parent(pre,ch).
parent(bir,bhu).
parent(bir,jy).
parent(sum,jy).
parent(sum,bhu).
parent(rsh,nar).
parent(rsh,par).
parent(x,pre).
parent(hz,sum).
male(ram).
male(bha).
male(bir).
male(sat).
male(nar).
male(par).
male(x).
male(bhu).
male(st).
female(ju).
female(ch).
female(jy).
female(sum).
female(pre).
female(rsh).
female(shti).

% Uncle :- Is defined as the brother of one's father or mother.
% uncle(X, Y) :- means X is the uncle of Y.

uncle(X, Y) :- 
	(
		male(X),
		parent(P, X),
		parent(Z, Y),
		not(Z=X),
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

