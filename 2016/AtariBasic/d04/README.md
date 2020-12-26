## Advent of code, 2016 - DAY 4 - Atari Basic

For Day 4, we need to learn about Atari Basic's String implementation...

### Overview:

* C(I) is my character frequency for each string, and the nasty looking expression for MX is just remembering the maximum
frequency so far.
* Lines 4-5 detect the square bracket, and build the room number.
* 6-7 find all letters with the max frequency, reset them, and look for the next biggest, until we've got all 5, matching to the
input string as we go.
* 20-27 Perform the part (b) transform, looking for 'nor' to occur in any string, which turns out to be sufficient.

### Strings...

* A string in Atari Basic is an array of characters.
* You cannot create an array of strings. You'd have to create one very big string, and an arary of numerical indexes.
* String variables must end in ```$```, and must be declared/dimensioned before use.
* ```DIM S$(10)``` uses 5 bytes of memory for a 5 byte string. Memory is *not* initialised.
* ```S$="HELLO"```
* ```LEN(S$)``` returns actual length - 5 characters.
* ```? S$(2,4)``` prints substring ```ELL```
* ```? S$(3)``` prints from 3 to the end - ```LLO```
* ```S$(8,8)="P"``` S$ becomes HELLO?!P - where ?! are garbage, because of non-initialisation. But LEN(S$)=8.
* ```S$(2) = S$(3)``` deletes a character, and reduces string length by 1.
* ```S$(3) = S$(2)``` copies character 2 to *every later* character in the string...
* ```S$="HELLO1234567"``` - S$ is truncated at the first 10 characters, without error.
* ```B$=A$``` does a string copy, for as many characters as possible (assuming B$ is dimmed to something)
* Really strangely. ```S$(1)="#":S$(10)="#":S$(2)=S$``` fills the string with hashes. Quite fast too, to the point that strings are 
often used in Atari Basic to store graphics, which can be cleared or scrolled upwards quite quickly.
* 

### ASCII codes:

* 97..122 are lower case a-z, and 48..57 are digits 0 to 9.
* 45 and 47 are ```[``` and ```]``` respectively. 

### GOSUB and RETURN

* This is a sub-routine. You can ```GOSUB``` to a line to call a subroutine, and when the next ```RETURN``` command is reached, 
flow control is back to the next command after the ```GOSUB``` - including if its on the same line as the GOSUB.
* Variables are all in global scope though - this is just flow control, nothing more.
* You can do ```ON conditions GOSUB ...``` just like you could with GOTO.

### POSITION

* ```POSITION X,Y``` positions the cursor at those co-ordinates. The next thing printed will go there.
