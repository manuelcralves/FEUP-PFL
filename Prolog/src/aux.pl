% take in the coordinates for a specific type of move and return a list with the move type and the coordinates in a specific format. 
coordinates_to_move_type1(X,Y,X2,Y2,[1,(X,Y),(X2,Y2)]).
coordinates_to_move_type2(X,Y,X2,Y2,X3,Y3,[2,(X,Y),(X2,Y2),(X3,Y3)]).

% take in a list with the move type and coordinates and extract the row and column values for the move
get_row_column([1,(X1,Y1),(X2,Y2)],X1, Y1, X2, Y2).
get_row_column([2,(X1,Y1),(X2,Y2),(X3,Y3)],X1, Y1, X2, Y2, X3,Y3).

% takes in a list with the move type and coordinates and extracts the move type.
get_move_type(L, First) :-
    L = [First|_].