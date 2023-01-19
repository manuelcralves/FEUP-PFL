# Turma 6 - Nex_2


## Creators
- [Pedro José Ferreira Moreira](up201905429@fe.up.pt) - up201905429
- [Manuel Carlos Ramos Alves](up201906910@fe.up.pt) - up201906910

## Instalation and Execution
### Windows & Linux
- Execut `spwin.exe`
- `File` -> `Consult...` -> Select File `nex.pl`
- SicStus: `play.`


## Game Logic

### Internal Representation 

The GameState function is a list of lists that contains in the first element the current Player and on the second the board.

The board is represented as a list of lists. PLayer 1 is represented by 1s and Player 2 by 2s. An empty cell is represented by 0 and a neutral cell by 0.

There are two types of moves:
1.Place a stone of their color AND a neutral stone on empty cells;
2.Replace two neutral stones with stones of their color, AND replace a different stone of their color on the board to neutral stone.

Therefore the representation of move 1 is a list of tuples where the first element is 1 (to represent the move type) and the next two tuples are the cell coordinates of the cells we want to change. For move two the exact same happens but now the first element is 2 and there are 3 subsequent tuples.

There are 3 types of player: Human player 1 and 2 are 1 and 2, computer random is 4 and computer greedy is 5. This comes in handy when starting a game because depending on the type of player the start_game predicate is different.

### Game State visualization

Using the functions display game we display a simple board with separators.
Columns are numbered and Rows are represented y letters.
There are also multiple interactive menus as it can be seen on the menu module explanation bellow. All of them vary with input.

The initial state is nothing more than a simple predicate where the option choosen on the menu is exchanged by a GameState of choice as it can be seen on display module.

### Executing plays

After checking for valid moves we receive a list of valid moves, if the move the player wants to do is there the move(+GameState, +Move, -NewGameState) is done by replacing the contents of the desired cells with the desired values using the auxiliar funciton replace.

A NewGameState is outputed and can be use to feed a new StartGame/3.

### Valid Moves

First we check the type of move, then we iterate over the matrix in search of empty positions. After we find them we permutate them and this is all we need to do for move 1.

In move two we find neutral pieces on the board, permutate them and them concatenate all the pieces with the players number.

We then concatenate both lists and now we have all possible of of both possible types.

### Game Over

We check if there are any walls connected by the respective players number. If there is that player has just won the game.

Using tranpose function we can basically use the same functions for both players.

### Board Evaluation

We use the value/2 predicate to evaluate the board in the end of the game. It calculates the number of empty cells, neutral cells, player 1 cells and player 2 cells on the board. It takes a game state (first argument), and returns a list with all the values (second argument).

### Computer Move

For the computer move, we use the choose_move/4 predicate. It checks if the level is 1 (random/easy) or 2 (greedy/hard). Based on that, if the move is random it only chooses a random (but valid) move. If not, it calls the predicate best_move/3, which returns the best move possible acording to a algorithm that is calculated in the score predicate/4. That predicate checks, in case of player 1, how many cells does the column with more cells (from player 1) has. In case of player2, it does the same but for rows.

## Input

The read_inputs/3 predicate reads a column and a row from the user and checks if they are valid. The read_column/2 predicate reads a column from the user and the check_column/3 predicate checks if the column is within the valid range (specified by the second argument). Similarly, the read_row/2 predicate reads a row from the user and the check_row/3 predicate checks if the row is within the valid range (specified by the second argument).

The read_number/3 predicate reads a number from the user and checks if it is within the specified range (specified by the first and second arguments). The code_number/2 predicate maps an ASCII code to its respective decimal number, and the row/2 and row_lower/2 predicates map a row number to its respective letter (either capital or lowercase).


## Menu

Defines some predicates to print a user interface for a game. It defines predicates to clear the screen, print a logo and various banners with different formatting, and display a main menu with different options.

The clear/0 predicate writes ASCII escape codes to clear the screen. The nex_logo/0 predicate prints a logo. The game_over_logo/0 predicate prints a game over logo.

The menu_header_format/1, menu_option_format/2, menu_text_format/1, menu_empty_format/0, menu_sec_header_format/2, and menu_bottom_format/0 predicates are formatting predicates used to print various parts of the main menu. The banner/1, banner/2, and banner/3 predicates are formatting predicates used to print banners with different types of content. The banner_bot/2 predicate is similar to the banner/3 predicate, but is used to print a banner for a computer vs computer game.

The menu/0 predicate prints the main menu. The difficulty_menu/0 predicate prints a menu to choose the difficulty level for the game. The board_size_menu/0 predicate prints a menu to choose the size of the board for the game. The game_instructions/0 predicate prints the instructions for the game.

## Play

The code is for a game where players take turns making moves on a board. The valid_moves/3 predicate is used to generate a list of valid moves that a player can make in the current game state. The validate_move/3 predicate checks whether a given move is valid or not, by checking if it is a member of the list of valid moves.

The start_game/3 predicate is used to initialize a new game by creating the initial game state and then entering the main game loop. The game_loop/1 predicate is responsible for the main game loop, where players take turns making moves until the game is over.

The input_loop/4 predicate is used to process player input, which is used to make moves in the game. It prompts the player to make a move and then processes the input to determine the player's intended move. If the move is valid, it is applied to the game state and the game continues. If the move is invalid, the player is prompted to make a new move.

The get_board/2 predicate gets the current board from the game state. The initial_state/2 predicate creates the initial game state. The play/0 predicate calls several other predicates to start the game. The clear/0 predicate clears the screen and the nex_logo/0 predicate displays the "nex" logo. The menu/0 predicate displays the main menu.

## Conclusions

Writing Nex in Prolog was a challenging but rewarding experience. One of the biggest difficulties I faced was with bugs in the input handling. These bugs greatly delayed my project, as I spent a lot of time trying to track down and fix them.

Another challenge was implementing the logic for choosing moves. I had to think carefully about how to represent the game state and generate valid moves, and it took some time to get everything working correctly.

Perhaps the biggest challenge, however, was adjusting to the mindset of logic programming. Coming from a background in imperative programming, it took some time to get used to thinking about problems in terms of logical rules and facts, rather than control flow and variables.

Despite these difficulties, I am pleased with the progress I made on the project. I was able to implement the core gameplay mechanics and get the game up and running. In the future, I would like to improve the greedy algorithm that the computer player uses, as well as solve the remaining bugs in the input handling. However, I didn't have the time to fully address these issues in this project.

Overall, writing Nex in Prolog has been a challenging but valuable experience. It has helped me to understand the power and limitations of logic programming, and has given me a greater appreciation for the complexity of building a functional game.

# Bibliography 
- [SicStus 4.6.0](https://sicstus.sics.se/sicstus/docs/latest4/html/sicstus.html/)
- [Wikipedia](https://en.wikipedia.org/wiki)
- [GeeksForGeeks](https://www.geeksforgeeks.org/)