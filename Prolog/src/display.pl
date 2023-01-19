% initial state of the game, given the size of the board. It returns a list with the current player and a board, represented as a list of lists. 
 initial_state(1, [1, [
  [0, 0, 0 , 0, 0, 0],
  [0, 0, 0 , 0, 0, 0],
  [0, 0, 0 , 0, 0, 0],
  [0, 0, 0 , 0, 0, 0],
  [0, 0, 0 , 0, 0, 0],
  [0, 0, 0 , 0, 0, 0]
]]).

initial_state(2, [1, [
    [0, 0, 0 , 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0]
]]).

initial_state(3, [1, [
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0, 0]
]]).

 initial_state(4, [1, [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
]]).

% displays the current state of the game. It gets the board from the game state, and calls display_board/1 to print it.
display_game(GameState) :- 
    get_board(GameState, Board),
    display_board(Board).

% gets the board from the game state. It returns the second element of the list, which represents the board.
get_board([Player, Board], Board).

%  gets the current player from the game state. It returns the first element of the list, which represents the current player.
get_player([Player, Board], Player).


% print_separator/1 and print_separator/2 are predicates that print a horizontal separator for the board. print_separator/1 calls print_separator/2 with an initial value of 0 for the index. print_separator/2 prints a '+' character and then calls itself with an incremented index until it reaches the size of the board.
print_separator(Size) :-
    print_separator(Size, 0).

print_separator(Size, Size) :-
    write('+'), nl.
print_separator(Size, Index) :-
    write('+ - '),
    Index1 is Index + 1,
    print_separator(Size, Index1).

% prints a list of elements separated by '|'. It prints a '|' character and then calls itself with the tail of the list.
print_list([]) :- write('|').
print_list([H|T]) :-
    format('| ~w ',H),
    print_list(T).

% displays the board. It first calls print_separator/1 to print the top separator of the board. Then it calls display_board_aux/2 to print the rows of the board.
display_board(Board) :-
    length(Board,Size),
    print_separator(Size),
    display_board_aux(Board,Size).

% prints the rows of the board. It prints each row by calling print_list/1, followed by a newline character. It then calls print_separator/1 to print a separator between rows. It repeats this process until all rows have been printed.
display_board_aux([],_).
display_board_aux([H|T],Size) :-
    print_list(H),nl,
    print_separator(Size),
    display_board_aux(T,Size).

% displays a message with the current player's turn. It prints the player number in the message.
display_header_current_player(Player) :-
  nl, format('********** Player ~w Turn **********', [Player]),nl.




