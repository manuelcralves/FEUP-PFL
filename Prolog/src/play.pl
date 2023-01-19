play :-
  clear,
  nex_logo,
  menu.

% checks whether its argument is an empty list.
empty_list([]).

% finds all the cells in a board (the first argument) that contain a particular value (the second argument) and returns them as a list of coordinates (the third argument).
find_cells(Board, Type, ListOfCells) :-
    findall((X,Y), (nth1(X, Board, Row), nth1(Y, Row, Type)), ListOfCells).

% permute_tuples(+Tuples, -Permutations)
% Given a list of Tuples, returns a list of Permutations, where each Permutation is a list of two tuples chosen from Tuples in a different order.
permute_tuples(Type, Tuples, Permutations) :-
    findall([Type |Permutation], (combination(Tuples, 2, Combination), permutations(Combination, Permutation)), TempPermutations),
    list_to_set(TempPermutations, Permutations).

% combination(+List, +Size, -Combination)
% Given a List and a Size, returns a Combination, which is a list of Size elements chosen from List.
combination(List, Size, Combination) :-
    length(Combination, Size),
    combination_(List, Combination).

combination_(_, []).
combination_([H|T], [H|Combination]) :-
    combination_(T, Combination).
combination_([_|T], Combination) :-
    combination_(T, Combination).

% permutations(+List, -Permutation)
% Given a List, returns a Permutation of the elements of List.
permutations([], []).
permutations(List, [H|Permutation]) :-
    select(H, List, Rest),
    permutations(Rest, Permutation).

% Define the predicate that will be used as the transformation in findall/3
append_lists(X, Y, Z) :- append(X, [Y], Z).

% Define the main predicate that will perform the operation
transform_lists(List1, List2, Result) :-
    % Use findall/3 to iterate over each element of List1 and generate the transformed lists
    findall(Intermediate, (member(X, List1), member(Y, List2), append_lists(X, Y, Intermediate)), Result).

% concatenates two lists. It takes two lists (the first and second arguments) and returns the concatenation of the two lists as the third argument.
concat([], List, List).
concat([Head|Tail], List, [Head|Rest]) :-
    concat(Tail, List, Rest).

%  is used to generate a list of valid moves that a player can make in the current game state.
valid_moves(GameState, Player, ListOfMoves) :-
  % ListOfMoves vai ser uma list com ValidMoves 
  % ValidMoves -  [moveType,[X,Y],[X2,Y2]]
  % ValidMoves -  [moveType,[X,Y],[X2,Y2],[X3,Y3]]

  get_board(GameState, Board),
  length(Board, Size),
 
  % MoveType 1 - Place a stone of their color AND a neutral stone on empty cells
  % Find empty cells that dont have the same coordinates
  find_cells(Board, 0, ListOfCells),
  permute_tuples(1, ListOfCells, ListOfMoves1),

  % ModeType 2 -  Replace two neutral stones with stones of their color, AND replace a different stone of their color on the board to neutral stone.
  % Find neutral stones AND find stones of the players color
  find_cells(Board, 3, ListOfCells2),
  permute_tuples(2, ListOfCells2, ListOfMoves2),
  find_cells(Board, Player, ListOfCells3),
  transform_lists(ListOfMoves2,ListOfCells3,ListOfMoves4),
  concat(ListOfMoves1,ListOfMoves4,ListOfMoves).

%  checks whether a given move is valid or not, by checking if it is a member of the list of valid moves.
validate_move(GameState, Player, Move) :-
  valid_moves(GameState,Player,ListOfMoves),
  member(Move,ListOfMoves),
  nl,
  write(' ---------- SUCCESSFUL MOVE!! -----------'),nl.

%  initialize a new game by creating the initial game state and then entering the main game loop
start_game(Size, Player1Type, Player2Type):-
  clear, 
  initial_state(Size, GameState),
  game_loop(GameState, Player1Type, Player2Type).

% used to process player input, which is used to make moves in the game. It prompts the player to make a move and then processes the input to determine the players intended move. If the move is valid, it is applied to the game state and the game continues. If the move is invalid, the player is prompted to make a new move.
input_loop(GameState, Size, Player, Move) :-
  menu_type_move(TypeOption),
  menu_move(TypeOption, Move, Size),
  print(Move),
  validate_move(GameState, Player, Move), !.
input_loop(GameState, Size, Player, Move) :-
  write('\n~ Invalid Move\n| Select again\n'),
  input_loop(GameState, Size, Player, Move).

% updates the game state based on a given move. It takes a game state (the first argument), a move (the second argument), and returns the updated game state (the third argument).
move(GameState, Move, NewGameState) :-
    get_board(GameState, Board),
    get_player(GameState, Player),
    get_move_type(Move,Type),
    ( Type =:= 1 ->
    get_row_column(Move, Row2, Column2, Row1, Column1),
    nth1(Row1, Board, OldRow),
    replace(Column1, 3, OldRow, NewRow),
    replace(Row1, NewRow, Board, NewBoard),
    nth1(Row2, NewBoard, OldRow2),
    replace(Column2, Player, OldRow2, NewRow2),
    replace(Row2, NewRow2, NewBoard, NewBoard2),
    NextPlayer is (Player mod 2) + 1,
    NewGameState = [NextPlayer, NewBoard2];

    get_row_column(Move, Row2, Column2, Row1, Column1, Row3, Column3),
    nth1(Row1, Board, OldRow),
    replace(Column1, Player, OldRow, NewRow),
    replace(Row1, NewRow, Board, NewBoard),

    nth1(Row2, NewBoard, OldRow2),
    replace(Column2, Player, OldRow2, NewRow2),
    replace(Row2, NewRow2, NewBoard, NewBoard2),

    nth1(Row3, NewBoard2, OldRow3),
    replace(Column3, 3, OldRow3, NewRow3),
    replace(Row3, NewRow3, NewBoard2, NewBoard3),

    NextPlayer is (Player mod 2) + 1,
    NewGameState = [NextPlayer, NewBoard3]
    ).

% replaces an element at a given index in a list with a new value. It takes an index (the first argument), a value (the second argument), a list (the third argument), and returns a new list with the replacement made (the fourth argument).
replace(1, Value, [_|Tail], [Value|Tail]).
replace(Index, Value, [Head|Tail], [Head|NewTail]) :-
    Index > 1,
    Index1 is Index - 1,
    replace(Index1, Value, Tail, NewTail).

% checks if all elements in a list are equal to a given value. It takes a list (the first argument) and a value (the second argument) and succeeds if all elements in the list are equal to the value, fails otherwise.
is_line_full(Grid, Value) :-
    member(Line, Grid),
    maplist(=(Value), Line).

% checks if the game is over. It takes a game state (the first argument) and a player (the second argument) and succeeds if the game is over, fails otherwise. If the game is over, the player argument is set to the winner. If the game is not over, the player argument is set to 0. There are two clauses for this predicate: one checks if all elements in a row of the board are equal to 1 (indicating player 1 has won) and the other checks if all elements in a column of the board are equal to 2 (indicating player 2 has won).
game_over(GameState, 1) :-
  get_board(GameState,Board),
  is_line_full(Board,1).

game_over(GameState, 2) :-
  get_board(GameState,Board),
  transpose(Board,Transpose),
  is_line_full(Transpose,2).

game_over(_,0).

% represents the main loop of the game. It takes a game state (the first argument) and does not return any values. It calls several other predicates to display the game, get input from the player, update the game state, and check if the game is over. If the game is not over, it calls itself with the updated game state to continue the game. If the game is over, it calls the game_over_menu/1 predicate to display the game over menu.
game_loop(GameState,1, 2) :-
  % display game
  display_game(GameState),

  get_player(GameState,Player),
  display_header_current_player(Player),

  get_board(GameState,Board),
  length(Board, Size),
  input_loop(GameState, Size, Player, Move),
  move(GameState, Move, NewGameState),
  nl,nl,
  game_over(NewGameState, Winner),
  
  % call for game loop with newState
  ( Winner =:= 0 -> 
    game_loop(NewGameState,1,2) ; 
    W is (Player mod 2) + 1,
    game_over_menu(W) ).

game_loop(GameState,1, 4) :-
  % display game
  display_game(GameState),

  get_player(GameState,Player),
  display_header_current_player(Player),

  get_board(GameState,Board),
  length(Board, Size),
  ( Player =:= 1 ->
  input_loop(GameState, Size, Player, Move),
  move(GameState, Move, NewGameState);

  choose_moves(GameState,2,1,Move)
  ),
  nl,nl,
  game_over(NewGameState, Winner);
  % call for game loop with newState
  ( Winner =:= 0 -> 
    game_loop(NewGameState,1, 4) ; 
    W is (Player mod 2) + 1,
    game_over_menu(W) ).

game_loop(GameState,1, 5) :-
  % display game
  display_game(GameState),

  get_player(GameState,Player),
  display_header_current_player(Player),

  get_board(GameState,Board),
  length(Board, Size),
  ( Player =:= 1 ->
  input_loop(GameState, Size, Player, Move),
  move(GameState, Move, NewGameState);

  choose_moves(GameState,2,2,Move)
  ),
  nl,nl,
  game_over(NewGameState, Winner);
  % call for game loop with newState
  ( Winner =:= 0 -> 
    game_loop(NewGameState,1, 5) ; 
    W is (Player mod 2) + 1,
    game_over_menu(W) ).

game_loop(GameState,4, 4) :-
  % display game
  display_game(GameState),

  get_player(GameState,Player),
  display_header_current_player(Player),

  get_board(GameState,Board),
  length(Board, Size),
  ( Player =:= 4 ->
  choose_moves(GameState,1,1,Move);

  choose_moves(GameState,2,1,Move)
  ),
  nl,nl,
  game_over(NewGameState, Winner);
  % call for game loop with newState
  ( Winner =:= 0 -> 
    game_loop(NewGameState,4,4) ; 
    W is (Player mod 2) + 1,
    game_over_menu(W) ).

game_loop(GameState,4, 5) :-
  % display game
  display_game(GameState),

  get_player(GameState,Player),
  display_header_current_player(Player),

  get_board(GameState,Board),
  length(Board, Size),
  ( Player =:= 4 ->
  choose_moves(GameState,1,1,Move);

  choose_moves(GameState,2,2,Move)
  ),
  nl,nl,
  game_over(NewGameState, Winner);
  % call for game loop with newState
  ( Winner =:= 0 -> 
    game_loop(NewGameState,4, 5) ; 
    W is (Player mod 2) + 1,
    game_over_menu(W) ).

game_loop(GameState,5, 4) :-
  % display game
  display_game(GameState),

  get_player(GameState,Player),
  display_header_current_player(Player),

  get_board(GameState,Board),
  length(Board, Size),
  ( Player =:= 4 ->
  choose_moves(GameState,1,2,Move);

  choose_moves(GameState,2,1,Move)
  ),
  nl,nl,
  game_over(NewGameState, Winner);
  % call for game loop with newState
  ( Winner =:= 0 -> 
    game_loop(NewGameState,5, 4) ; 
    W is (Player mod 2) + 1,
    game_over_menu(W) ).

game_loop(GameState,5, 5) :-
  % display game
  display_game(GameState),

  get_player(GameState,Player),
  display_header_current_player(Player),

  get_board(GameState,Board),
  length(Board, Size),
  ( Player =:= 4 ->
  choose_moves(GameState,1,2,Move);

  choose_moves(GameState,2,2,Move)
  ),
  nl,nl,
  game_over(NewGameState, Winner);
  % call for game loop with newState
  ( Winner =:= 0 -> 
    game_loop(NewGameState,5, 5) ; 
    W is (Player mod 2) + 1,
    game_over_menu(W) ).

%  calculates the number of empty cells, neutral cells, player 1 cells, and player 2 cells on the board. It takes a game state (the first argument) and returns a list with these values (the second argument).
% value(+Gamestate, -Value)
value(Gamestate, Value):- 
    get_board(Gamestate, Board),
    count_element_in_matrix(Board, 0, EmptyCount),
    count_element_in_matrix(Board, 3, NeutralCount),
    count_element_in_matrix(Board, 1, Player1Count),
    count_element_in_matrix(Board, 2, Player2Count),
    Value = [EmptyCount, NeutralCount, Player1Count, Player2Count].

% count_element_in_matrix(+Matrix, +Element, -Count)
% Count the ammount of times Element appears in a matrix Matrix
count_element_in_matrix([], _, 0).
count_element_in_matrix([CurrRow|NextRow], Element, Count) :-
    count_element_in_row(CurrRow, Element, RowCount),
    count_element_in_matrix(NextRow, Element, RemainingCount),
    Count is RowCount + RemainingCount.

% count_element_in_row(+Row, +Element, -Count)
% Count the ammount of times Element appears in a row Row
count_element_in_row([], _, 0).
count_element_in_row([Elem|Elems], Element, Count) :-
    (   Elem = Element
    ->  NewCount is 1
    ;   NewCount is 0
    ),
    count_element_in_row(Elems, Element, RemainingCount),
    Count is NewCount + RemainingCount.

% Choose a move for the given player in the given game state.
% If the level is 1, choose a random move.
% If the level is 2, choose the best move according to the greedy algorithm.
choose_move(GameState, Player, Level, Move) :-
    (Level = 1 -> valid_moves(GameState, Player, ListOfMoves),
                  random_member(Move, ListOfMoves)
     ; best_move(GameState, Player, Move)).

% Choose a move for the given player in the given game state.
% If the level is 1, choose a random move.
% If the level is 2, choose the best move according to the greedy algorithm.
choose_move(GameState, Player, Level, Move) :-
    (Level = 1 -> valid_moves(GameState, Player, ListOfMoves),
                  random_member(Move, ListOfMoves)
     ; best_move(GameState, Player, Move)).

% Calculate the score for the given player in the given game state.
% The score is the number of connected cells in the top-bottom or left-right path,
% depending on the value of Direction.
score(GameState, Player, Direction, Score) :-
    % Calculate the number of connected cells in the specified direction path.
    get_board(GameState, Board),
    (Direction = top_bottom
     -> findall(X, (nth1(X, Board, Row), nth1(Y, Row, Cell), (X = 1 ; nth1(Y, nth1(X-1, Board, PrevRow), PrevCell), PrevCell == Cell), Cell == Player), TopBottom),
        length(TopBottom, Score)
     ; Direction = left_right
       -> findall(Y, (member(Row, Board), nth1(Y, Row, Cell), (Y = 1 ; nth1(Y-1, Row, PrevCell), PrevCell == Cell), Cell == Player), LeftRight),
          length(LeftRight, Score)).

% Calculate the best move for the given player in the given game state.
best_move(GameState, Player, BestMove) :-
    % Get the direction in which the player can connect the cells.
    (Player = 1 -> Direction = top_bottom ; Direction = left_right),
    
    % Get the list of valid moves for the player.
    valid_moves(GameState, Player, Moves),
    
    % Initialize the best score and best move to -infinity.
    BestScore = -10000,
    BestMove = none,
    
    % Iterate over the valid moves and calculate the score for each one.
    % If the score is higher than the current best score, update the best score and best move.
    findall([Score, Move], (
        member(Move, Moves),
        move(GameState, Move, NewGameState),
        score(NewGameState, Player, Direction, Score),
        write(Score)
    ), ScoresAndMoves),
    member([BestScore, BestMove], ScoresAndMoves).
    % Select the move with the highest score.