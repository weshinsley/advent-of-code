## Atari Basic

In this document is an attempt to summarise everything about Atari Basic that's
needed to understand my solutions for all the Advent of Code 2016. Essentially, it's
a simple BASIC squashed into 8k or so - not especially fast, mostly because it does
floating point work everywhere. Other faster better alternatives exist, but let's
stay with the stock for this.

So, we have line-numbered BASIC code, with subroutines, but no functions, and a
single global scope, so if/when it comes to recursion, we'll have to basically
implement the stack and frames ourselves. 

Oh and free memory is typically 37902 bytes, reducing by 9 bytes if you write `A=0`.
Still think we can solve advent-of-code with this?

### Lines and Typing

* Code can be typed immediately into the editor, or put on line numbers.
* Line numbers are between 0 and 32767. There's no re-number command in 
  standard Atari Basic...
* Typing a line number followed by enter deletes a line.
* Multiple commands on the same line are separated with `:`
* Various special Atari characters are achieved by pressing `CTRL` key.
* Various other escape characters are achieved by pressing `ESC` before another combination of keys.
* But I won't be using the latter two; I'll keep things to standard characters.
* An 'inverse' key flips between normal and inverse text. That sometimes gets us
  some different colours, which might be nice - I'll see what happens when I get to that.
* Commands and variables are always upper-case.
* Variables are alphanumeric, starting with alpha.

### A bit more syntax

* Atari Basic parses with tokenising. Hence, spaces are optional at any point where you could 
  conceivably leave them out unambiguously. For example, if you have a variable X, you can type `GOTOX`. 
  But when listing code, Atari BASIC puts the spaces where they should be.
* Lines can be three editor lines long; 120 characters if the margin is set to zero. (See `POKE`)
* Commands can often be abbreviated to fit more into a line. They will be re-expanded on list.
* An exception is `?`, which is a short form of `PRINT`, and stays as `?` forever.
* Round brackets in expressions can be used as liberally (or not) as you like. I don't know what
  evaluation order Atari Basic uses...

### Types

For the purposes of writing this page, the symbols below indicate types. And where I 
talk about functions that take a numeric (N), I also mean they will parse with a 
function that returns (N). So `SIN(COS(ABS(X)))` is fine to work with.

| Keyword              | Symbol | Meaning
|----------------------|--------|---------------------------------------|
| Numeric              |   N    | All numbers 10-digit floating point   |
| String               |   S$   | Pre-allocated bunch of characters     |
| Boolean              |   N    | Just a numeric. 1 = TRUE, 0 = FALSE   |
| IOCB                 |   #I   | Input Output Channel #0 to #7         |
| 4                    |        | A number.                             |
| 3.1415926535         |        | A number that gets truncated to .265  |
| 123412341234         |        | The number 1.23412341E+11             |
| 3E-5                 |        | Another very valid number             |
| "S"                  |        | A string.                             |

### Maths Expresion

Using the types in the table above:

| Maths Expression   | Meaning           |
|--------------------|-------------------|
| `N+N`              | Addition          |
| `N-N`              | Subtraction       |
| `N*N`              | Multiplication    |
| `N/N`              | Division          |
| `N^N`              | Raise to power    |
| `N AND N`          | Bitwise AND       |
| `N OR N`           | Bitwise OR        |
| `NOT N`            | Bitwise NOT       |

### Logical Expressions

| Logical Expression   | Meaning                |
|----------------------|------------------------|
| `N>N`  or `S>S`      | Greater / Later        |
| `N>=N` or `S>=S`     | Greater or equal       |
| `N=N` or `S=S`       | Equal to               |
| `N<=N` or `S<=S`     | Less or equal          |
| `N<N` or `S<S`       | Less / Earlier         |
| `N<>N` or `S<>S`     | Not equal to           |

### Function List

| Keyword          | Meaning                                    |
|------------------|--------------------------------------------|
| `N=ABS(N2)`      | Absolute value                             |
| `N=ADR(S$)`      | Address of a string in memory (bit odd)    |
| `N=ASC(S$)`      | ASCII code of first character in S$        |
| `N=ATN(N2)`      | Arctan                                     |
| `N=CLOG(N2)`     | Base-10 log                                |
| `S$=CHR$(N2)`    | Character for ASCII code N2                |
| `N=EXP(N2)`      | Exponent (power of e)                      |
| `N=FRE(N2)`      | How much free memory. (N2 is ignored)      |
| `N=INT(N2)`      | Truncate to integer                        |
| `N=LEN(S$)`      | Length of string. (Not capacity)           |
| `N=LOG(N2)`      | Base-e log                                 |
| `N=PEEK(N2)`     | Lookup a byte in memory                    |
| `N=RND(N2)`      | Pseudo-random 0<=x<1 (N2 ignored)          |
| `N=SGN(N2)`      | -1, 0 or 1 for negative, zero or positive  |
| `N=SIN(N2)`      | Sine                                       |
| `S$=STR$(N2)`    | Format number as string                    |
| `N=USR(N2)`      | Run 6502ASM from address N2. Maybe crash.  |
| `N=USR(N2,N3,N4)`| Can have some args                         |
| `N=VAL(S$)`      | Attempt parsing a number from a string     |

### Command List

| Keyword       | Meaning                                  |
|---------------|------------------------------------------|
| `BYE`         | Exit Basic - self-test and reboot!       |
| `CLOAD`       | Load tokenised program from tape         |
| `CLR`         | Set vars to zero. (But don't free them)  |
| `COM S$(N)`   | Same as `DIM`. I've never understood why |
| `CSAVE`       | Save tokenised program to tape           |
| `DEG`         | Future trig funcs returned in degrees    |
| `DIM S$(N)`   | Get memory for S$ to index with 1..N     |
| `DIM N(N2)`   | Get memory for N to index with 0..N2     |
| `DIM N(N2,N3)`| Matrix. (0..N2, 0..N3)                   |
| `DOS`         | Exit Basic - enter DOS (losing work...)  |
| `END`         | End BASIC program                        |
| `LIST`        | List current program                     |
| `LIST N`      | List a single line                       |
| `LIST N,N2`   | List a range of lines                    |
| `NEW`         | Clear BASIC program and variables        |
| `RAD`         | Future trig funcs returned in radians    |
| `REM ...`     | A comment                                |

### Program Flow

| Keyword                 | Meaning                                                    |
|-------------------------|------------------------------------------------------------|
| `CONT`                  | Continue program on line after `STOP`                      |
| `FOR N=N1 TO N2`        | Inclusive loop incrementing by one each time. See `NEXT`   |
| `FOR N=N1 TO N2 STEP N3`| A loop setting the delta value for N                       |
| `GOTO N` (or `GO TO N`) | Go to line number. (Rest of line ignored)                  |
| `GOSUB N`               | Go to line number as a subroutine (see `RETURN`)           |
| `IF N THEN` ...         | Do some work if N evals to 1 or more.                      |
|                         | If the N evals to 0, go straight to next line              |
| `IF N1 THEN N2`         | Special form - if N1 evals to 1 or more GOTO N2            |
|                         | And anything else on line is ignored. See also `ON`        |
| `NEXT N`                | End a loop. (Multiple branched `NEXT` for same `FOR` is ok |
| `ON N GOTO N1,N2`       | If N is 1, goto N1. If N is 2, goto N2, etc.               |
|                         | If no match, continue with rest of line.                   |
| `ON N GOSUB N1,N2`      | Like `ON N GOTO` but you can `RETURN` from it              |
| `POP`                   | Cancel one `GOSUB` or `FOR` loop from stack                |
| `RETURN`                | Continue from command after the last GOSUB.                |
| `RUN`                   | Run currently loaded BASIC program                         |
| `STOP`                  | Stop (pause) BASIC program - see `CONT`                    |

### Strings

A string is an array of characters. No built-in suppot for an array of strings.
Brackets perform sub-stringing.

| Keyword                 | Meaning                                                    |
|-------------------------|------------------------------------------------------------|
| S$=S2$(N1,N2)           | Get substring from chars N1..N2 inclusive. (N1>=1)         |
| S$=S2$(N1)              | Get substring from N1 to `LEN(S$)`                         |
| S$(N1,N2)=S2$           | Copy S2$ to s$ chars in range, fill spare with spaces      |
| S$(3)=S$(4)             | Delete a character in S$                                   |
| S$(4)=S$(3)             | Copy S$(3) to the rest of the string. Probably not wanted. |

And this freaky bit of code:

`DIM S$(100):S$(1,1)="X":S$(100,100)="X":S$(2)=S$`

fills an array with a certain character - as fast as assembler. Who knows why.

### Graphics

| Keyword                 | Meaning                                                    |
|-------------------------|------------------------------------------------------------|
| `COLOR N`               | Set which col register to draw with                        |
| `DRAWTO N1,N2`          | Draw from end of last point (plot/drawto), to (X,Y)        |
| `GRAPHICS N`            | Get into a certain graphics mode. There are plenty.        |
| `PLOT N1,N2`            | Plot a pixel at (X,Y)                                      |
| `POSITION(N1,N2)`       | Position (notional) cursor at (X,Y)                        |
| `PRINT S$`              | Print a string at cursor co-ordinates                      |
| `PRINT S$; (or ? S$;)`  | The semi-colon suppresses a new-line                       |
| `PRINT #I;S$`           | Usually `? #6` - to print in the top part of a split mode  |
| `SETCOLOR N1,N2,N3`     | Set colour reg N1 to hue N2, brightness N3.                |

Treat these loosely; you can `PLOT` and `DRAWTO` in a text mode too, inwhich case 
`COLOR` sets the character being drawn with. Quite odd. Some graphics modes are text
only, some are graphics only, some are graphics with a window. For all that are split,
or graphics-only, you must `PRINT #6` to use the top part.

### Loading and Saving

| Keyword              | Meaning                                                  |
|----------------------|----------------------------------------------------------|
| `ENTER "H:CODE.BAS"` | Load a program in text form.                             |
| `LIST "H:CODE.BAS"`  | Save a program in text form.                             |
| `LOAD "H:CODE.BAS"`  | Load a program in Atari-Basic tokenised form             |
| `SAVE "H:CODE.BAS"`  | Save a program in Atari-Basic tokenised form             |
| `RUN "H:CODE.BAS"    | `LOAD` and immediately `RUN` something that was `SAVE`d. |

Here, `H:` refers to the home drive mapped by the Altirra emulator. On
real hardware, `C:` would refer to tape, `D:` to disk, `D2:` to a specific
disk drive if you have more of them or `P:` to a
printer. Other devices can be created and added
