## Advent of code, 2016 - DAY 12 - Atari Basic

BunnyAssem! This one I found quite cute in Atari Basic - it uses the *return-key mode* to effectively
trans-pile the bunny assembler code into Atari Basic, add those lines to the current program and then
run them. The running takes some time, and it's much quicker to analyse what the code does, which is
quite simple. But writing the compiler is nice...

### STOP and CONT

* Two obvious commands, useful for debugging - and for other things as we'll see.
* ```STOP``` stops the program much like a breakpoint. All files are left open, all variables are unchanged.
* ```CONT``` continues a program that has been stopped from the *next line*. (So don't put anything after the STOP on the same line)

### RETURN KEY MODE
* Suppose you use ```POSITION``` and ```PRINT``` to write some text in the middle of the screen that look like Basic code.
* At the bottom of the screen, you POSITION and PRINT ```POKE 842,13:CONT```
* And in your code, you ```POSITION``` the cursor at the top of the screen, and in your code you execute ```POKE 842,12:STOP```
* All the while PEEK(842)=13, and while it has control, the Basic Editor pushes the return key, executing anything in its path.
* So, any lines of BASIC you printed on the screen will get added to the current program, just as if you'd typed them into the editor and pushed return yourself.
* And eventually, the ```POKE 842,13:CONT``` text gets executed, which turns off return-key mode, and continues the program.
* But now, you have more lines in the Basic program that you did before....
* And of course, you don't need the whole screen; you can do it as long as there's space for the STOP message, and the code you want to add.

### Overview:

* So, lines 12-13 cause anything printed in the middle of the screen to get added to the current program - having printed
the continue text on line 1. L is the line number being added, starting at 101. Line 100 is already there, setting A, B, C and D to zero.
* Line 4 and 5 translate the ```inc``` and ```dec``` assembunny into Atari Basic.
* Lines 7-8 translate the ```jnz``` and 9-11 the ```cpy```.
* Execution ends when either a ```jnz``` causes a line not found error, or I trigger one manually on 998.

