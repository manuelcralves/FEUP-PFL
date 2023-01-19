% ASCII code and respective decimal number
code_number(48, 0).
code_number(49, 1).
code_number(50, 2).
code_number(51, 3).
code_number(52, 4).
code_number(53, 5).
code_number(54, 6).
code_number(55, 7).
code_number(56, 8).
code_number(57, 9).

row(0, 'A').
row(1, 'B').
row(2, 'C').
row(3, 'D').
row(4, 'E').
row(5, 'F').
row(6, 'G').
row(7, 'H').
row(8, 'I').
row(9, 'J').
row(10, 'K').
row(11, 'L').

row_lower(0, 'a').
row_lower(1, 'b').
row_lower(2, 'c').
row_lower(3, 'd').
row_lower(4, 'e').
row_lower(5, 'f').
row_lower(6, 'g').
row_lower(7, 'h').
row_lower(8, 'i').
row_lower(9, 'j').
row_lower(10, 'k').
row_lower(11, 'l').

%  reads the row and column input from the player and passes it to read_column/2 and read_row/2 respectively to be read. Then, check_column/3 and check_row/3 are called to verify if the input is a valid row and column respectively. If the input is not valid, the player is prompted to enter the input again.
read_inputs(Size, X, Y):-
  read_column(Column, Size),
  check_column(Column, X, Size),
  format(': Row read :  ~d\n', X),
  read_row(Row, Size),
  check_row(Row, Y1, Size),
  row(Y2,Y1),
  Y is Y2 + 1,
  format(': Column read :     ~w\n', Y),
  skip_line.

read_column(Column, Size) :-
  format('| Row (1-~d) - ', Size),
  get_code(Column).

check_column(Testing, Number, Size) :-
  peek_char(Char),
  Char == '\n',
  code_number(Testing, Number),
  Number < Size, Number >= 0, skip_line.

check_column(_, CheckedColumn, Size) :-
  write('~ Invalid row\n| Select again\n'),
  skip_line,
  read_column(Column, Size),
  check_column(Column, CheckedColumn, Size).

read_row(Row, Size) :-
  Size1 is Size-1,
  row(Size1, Letter),
  format('| Column (A-~s) -    ', Letter),
  get_char(Row).

check_row(Rowread, RowreadUpper, Size) :-
  (row(RowNumb, Rowread) ; row_lower(RowNumb, Rowread)), RowNumb < Size, RowNumb >= 0, 
  row(RowNumb, RowreadUpper). % Gets Capital letter, ic case it reads lowercase letter

check_row(_, CheckedRow, Size) :-
  write('~ Invalid column\n| Select again\n'),
  skip_line,
  read_row(Row, Size),
  check_row(Row, CheckedRow, Size).
  
% used to read a number within a specified range (given by LowerBound and UpperBound) from the player. If the input is not a valid number within the range, the player is prompted to enter the input again.
read_number(LowerBound, UpperBound, Number):-
  format('| Choose an Option (~d-~d) - ', [LowerBound, UpperBound]),
  get_code(NumberASCII),
  peek_char(Char),
  Char == '\n',
  code_number(NumberASCII, Number),
  Number =< UpperBound, Number >= LowerBound, skip_line.

read_number(LowerBound, UpperBound, Number):-
  write('Not a valid number, try again\n'), skip_line,
  read_number(LowerBound, UpperBound, Number).

