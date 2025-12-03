## Advent of code, 2016 - DAY 2 - Atari Basic

Not so much to add for Day 2.

### Overview:

* Another simple starter. G(i,j) stores my matrix for part 1, ignoring index 0 in each column or row.
* And H encodes the diamond shape onto a 5x5 grid, include index 0 and 6 as buffers. 1..9 
mean 1 to 9, 10..13 mean A to D, and 14,15,16 and 17 I use to detect when we've hit the edge.

### A gotcha

* ```IF``` statemets do not lazy evaluate. Hence, if you have an array of length 5, you cannot do:
  - ```IF (X<6) AND DATA(X)=0 THEN ...```
* You instead would have to do
  - ```IF (X<6) THEN IF DATA(X)=0```
* I instead allowed extra space on the array, because it made the code simpler.

### ASCII codes.

* CHR$(N) converts a numerical (ie, an ASCII code), to its character. 
* ASC("A") would do the opposite.
* CHR$(125) is a special code that clears the screen. I should probably have done ```GRAPHICS 0``` instead.
* On line 2, ASCII code 10 is the UNIX new line character on each line of the input.
* 82, 76, 68 and 85 are R, L, D, U, respectively.
* 65 is ASCII for A - hence, for my numbers 10,11,12 and 13, I do CHR$(55+X) to get A, B, C, D.

### ON... GOTO

* Remember I said on day 1, that ```IF (condition)``` skips to the next line if the condition is false?
* ```ON X GOTO 10,20,30``` goes to one of the lines (10,20,30), if the value of ```X``` is 1,2 or 3 respectively.
* But interestingly, if ```X``` is neither 1, 2 nor 3, then control continues on the same line after the ON statement.
* And since a boolean true evaluates as 1, we can do ```ON boolean GOTO line: ? "otherwise..."``` on the same line.

### END

* ```END``` ends a program. It does the same thing as if the code runs of out of lines to execute. 
Any open files get closed, and any leftover loops on the stack get cancelled.
