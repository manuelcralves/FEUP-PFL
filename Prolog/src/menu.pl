option_dif(1, 'Easy').
option_dif(2, 'Normal').

clear :- write('\33\[2J').

nex_logo :-
    write('             ###     ##  ########  ##    ##    \n'),
    write('             ## #    ##  ##         ##  ##     \n'),
    write('             ##  #   ##  ##          ####      \n'),
    write('             ##   #  ##  #####        ##       \n'),
    write('             ##    # ##  ##          ####      \n'),
    write('             ##     ###  ##         ##  ##     \n'),
    write('             ##      ##  ########  ##    ##    \n').

game_over_logo :-
    write('  _____                         ____                  '), nl,
    write(' / ____|                       / __ \\                 '), nl,
    write('| |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __  '), nl,
    write('| | |_ |/ _` | ''_ ` _ \\ / _ \\ | |  | \\ \\ / / _ \\ ''__| '), nl,
    write('| |__| | (_| | | | | | |  __/ | |__| |\\ V /  __/ |    '), nl,
    write(' \\_____|\\__,_|_| |_| |_|\\___|  \\____/  \\_/ \\___|_|    '), nl.


% takes a header string as input and formats it to be displayed as a header in the menu
menu_header_format(Header):-
  format('~n~`*t ~p ~`*t~57|~n', [Header]).

% takes an option number and option details string as input and formats them to be displayed as an option in the menu
menu_option_format(Option, Details):-
  format('*~t~d~t~15|~t~a~t~40+~t*~57|~n',
        [Option, Details]).

% akes a string of text as input and formats it to be displayed as a regular line in the menu
menu_text_format(Text):-
  format('*~t~a~t*~57|~n', [Text]).

%  formats an empty line in the menu.
menu_empty_format :-
  format('*~t*~57|~n', []).

%  takes two label strings as input and formats them to be displayed as two columns in the menu.
menu_sec_header_format(Label1, Label2):-
  format('*~t~a~t~15+~t~a~t~40+~t*~57|~n',
          [Label1, Label2]).

% formats the bottom of the menu.
menu_bottom_format :-
  format('~`*t~57|~n', []).

% The banner/1, banner/2, and banner/3 predicates are used to display a banner at the top of the menu with a specific string and  additional information such as the board size and difficulty level
banner(String):-
  format('~n~`*t~57|~n', []),
  format('*~t~a~t*~57|~n', [String]),
  format('~`*t~57|~n', []).

banner(String, BoardSize):-
  format('~n~`*t~57|~n', []),
  format('*~t~a - ~dx~d Board~t*~57|~n', [String, BoardSize, BoardSize]),
  format('~`*t~57|~n', []).

banner(String, BoardSize, Difficulty):-
  format('~n~`*t~57|~n', []),
  format('*~t~a (~a) - ~dx~d Board~t*~57|~n', [String, Difficulty, BoardSize, BoardSize]),
  format('~`*t~57|~n', []).

% similar to the other banner predicates, but is specifically used to display a banner at the bottom of the menu
banner_bot(BoardSize, Difficulty):-
  format('~n~`*t~57|~n', []),
  format('*~tComputer (~a) vs Computer - ~dx~d Board~t*~57|~n', [Difficulty, BoardSize, BoardSize]),
  format('~`*t~57|~n', []).

% displays the main menu and prompts the user to select an option
menu :-
  menu_header_format('MAIN MENU'),
  menu_empty_format,
  menu_sec_header_format('Option', 'Details'),
  menu_empty_format,
  menu_option_format(1, 'Player vs Player'),
  menu_option_format(2, 'Player vs Computer'),
  menu_option_format(3, 'Computer vs Computer'),
  menu_option_format(4, 'Game Intructions'),
  menu_option_format(5, 'Information about project'),
  menu_empty_format,
  menu_option_format(0, 'BACK'),
  menu_empty_format,
  menu_bottom_format,

  read_number(0, 5, Number),
  menu_option(Number).

% displays a submenu for selecting the board size.
menu_board_size(Option):-
 menu_header_format('Choose a Board Size'),
  menu_empty_format,
  menu_sec_header_format('Option', 'Details'),
  menu_empty_format,
  menu_option_format(1, '6x6'),
  menu_option_format(2, '8x8'),
  menu_option_format(3, '12x12'),
  menu_empty_format,
  menu_option_format(0, 'BACK'),
  menu_empty_format,
  menu_bottom_format,
  read_number(0, 3, Option).

% handles the users selection from the main menu by calling the appropriate predicate based on the option chosen. 
menu_option(0):-
  clear,
  banner('Thank You For Playing').

menu_option(1):-
  clear, 
  menu_board_size(Option),
  pp_menu(Option).

menu_option(2):-
  clear, 
  menu_board_size(Option),
  pc_menu(Option).

menu_option(3):-
  clear, 
  menu_board_size(Option),
  cc_menu(Option).

menu_option(4):-
  clear,
  menu_header_format('INSTRUCTIONS'),
  menu_empty_format,
  format('*~t~s~t~30|~t~c~t~23+~t*~57|~n', ["Player 1", 49]),
  format('*~t~s~t~30|~t~c~t~23+~t*~57|~n', ["Player 2", 50]),
  menu_empty_format,

  menu_text_format('The objective of Nex is to create a connected chain'),
  menu_text_format(' of a players stones linking the opposite edges'),
  menu_text_format(' of the board marked by the players color.'),
  menu_empty_format,
  menu_empty_format,
  menu_text_format('-- GENERAL RULES --'),
  menu_empty_format,
  menu_text_format('The game begins with an empty board'),
  menu_text_format('Each player has an allocated color,'),
  menu_text_format('usually Red and Blue.'),
  menu_text_format('Players take turns making one of the following:'),
  menu_text_format('Place a stone of their color'),
  menu_text_format('AND'),
  menu_text_format(' a neutral stone on empty cells;'),
  menu_text_format('OR'),
  menu_text_format('Replace two neutral stones with stones of their color,'),
  menu_text_format('AND'),
  menu_text_format('replace a different stone of their color'),
  menu_text_format('on the board to neutral stone.'),
  menu_empty_format,
  menu_text_format('Since the first player has a distinct advantage,'),
  menu_text_format('the pie rule is generally used to make the game fair'),
  menu_text_format('This rule allows the second player to'),
  menu_text_format(' switch colors as his first move.'),
  menu_empty_format,
  menu_bottom_format,
  nl,
  sleep(5),
  clear,
  menu.

menu_option(5):-
  clear,
  menu_bottom_format,
  menu_empty_format,
  menu_text_format('Made By Manuel Alves and Pedro Moreira'),
  menu_text_format('for PFL'),
  menu_empty_format,
  menu_bottom_format,
  nl,
  sleep(5),
  clear,
  menu.

% pp_menu/1, pc_menu/1, and cc_menu/1 handle the specific functionality for each option.
pc_menu(0):-
  menu.

pc_menu(Option):-
  menu_header_format('Choose Difficulty'),
  nl, nl,
  menu_option_format(1, 'Random'),
  menu_option_format(2, 'Greedy'),
  nl,
  read_number(1, 2, Option),
  start_game(Option, 1, Option).

pp_menu(0):-
  menu.

pp_menu(Option):-
  start_game(Option, 1, 2).

cc_menu(0):-
  menu.

cc_menu(Option):-
  menu_header_format('Choose Skill for PC 1'),
  nl, nl,
  menu_option_format(1, 'Random'),
  menu_option_format(2, 'Greedy'),
  nl,
  read_number(1, 2, Option1),
  menu_header_format('Choose Skill for PC 2'),
  nl, nl,
  menu_option_format(1, 'Random'),
  menu_option_format(2, 'Greedy'),
  nl,
  read_number(1, 2, Option2),
  start_game(Option, Option1, Option2).

% displays a submenu for selecting the type of move to be made and prompts the user to select an option
menu_type_move(Option) :-
    write('Choose your move'),
    nl, nl,
    menu_option_format(1, 'Place a stone AND a neutral one on empty cells'),
    menu_option_format(2, 'Replace two neutral stones with your stones AND replace a different stone of yours on the board to neutral stone'),
    nl,
    read_number(1, 2, Option).

% handles the users selection from the move type menu by displaying a menu for the specific type of move chosen and prompting the user to input the coordinates for their move.
menu_move(1, MoveOption, Size) :-
    menu_header_format('Stone and Neutral'),
    nl,
    write('Place your stone'),
    nl, nl,
    read_inputs(Size,X,Y),nl,
    write('Place neutral on empty'),
    nl, nl,
    read_inputs(Size,X2,Y2),
    coordinates_to_move_type1(X,Y,X2,Y2,MoveOption).

menu_move(2, MoveOption, Size) :-
    menu_header_format('Replace 2 Neutral and Replace 1 color'),
    nl,
    write('Replace one neutral'),
    nl, nl,
    read_inputs(Size,X,Y),nl,
    write('Replace another neutral'),
    nl, nl,
    read_inputs(Size,X2,Y2),nl,
    write('Replace color with neutral'),
    nl, nl,
    read_inputs(Size,X3,Y3),nl,
    coordinates_to_move_type2(X,Y,X2,Y2,X3,Y3,MoveOption).

% displays a game over screen with a banner showing the player that won and a game over logo, then returns to the main menu and restarts the game
game_over_menu(Player) :-
  clear,
  banner(Player),
  game_over_logo,
  sleep(4),
  clear,
  menu,
  play.

    
