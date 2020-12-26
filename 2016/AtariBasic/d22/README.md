## Advent of code, 2016 - DAY 22 - Atari Basic

Some will love/hate this puzzle... 

## Overview

The first part is a n*n comparison between nodes, to see if the data on one node would
fit into another. This is easy enough, although in Atari Basic, quite slow. I could have
accelerated it by sorting the list into decreasing order of free space, perhaps in 
assembler, and then written the comparison in assembler too. But it quickly became
apparent that that's not what this puzzle is about. Part 2 then seems immediately
quite unlikely to solve as a programmatic general solution, and is perhaps better
expressed as... a game!

## The Code

* 0 - a bit of setup, and if we want, we can skip part (a)...
* 1-13 parse the input data. The numbers are sometimes (rarely) more than 255, so we need two bytes. `UM$` and `UL$` are the
MSB and LSB of the space in use, `SM$` and `SL$` are the MSB and LSB of the size, and to speed up things, `AM$` and `AL$` are the
MSB and LSB of the available space. Remember strings are indexed from number 1, so if we want to represent a grid as a string,
the index is `1+X+(Y * X_SIZE)`, where `X_SIZE` is the number of columns.
* M, XS and YS I have naughtily hard-coded as the sizes for my input...
* 2 - Skip the first line of the input, which we can ignore.
* 3 - Skip the second line of the input, which we can ignore as well.
* 4 - My input is in nice order - y counts from 0..ymax, and then x increases... So for each line:
* 5 - Ignore characters until a space...
* 6 - Then ignore characters until a non-space...
* 7 - And parse the size, until you get a 'T' (ASCII 84), whereas numbers 0-9 are ASCII 48..57.
* 8 - Parse away the spaces
* 9 - Parse the usage, until we get a 'T'
* 10 - Parse til the end of the line. (ASCII 10)
* 11 - Store the size as MSB, LSB, in `SM$` and `SL$`. (And get the colour ready to plot something...)
* 12 - Store the usage as MSB, LSB in `UM$` and `UL$`. Also calculate the available space. And plot something... And keep an eye out 
for any rare occurences where the usage is zero...
* 13 - Store the availability as MSB, LSB in `AM$` and `AL$`, and loop.
* 14-19 calculates part (a), which can be skipped if we want. If we want to do it, then lets write the viable pairs to a file
because it's interesting to see what the viable pairs are...
* 15 - Loop through every node `A`. If `A` is empty, skip `A`. Loop through every node `B`. If `A=B` skip `B`.
* 16 - See if the pair are viable. If so, write to file, and increase counter.
* 17-18 - Close loops. (Separate lines needed because of the skipping options.
* 19-26 - Get the human to solve the problem for part (b).
* 19 - Clear keyboard buffer and "Press a key to continue".
* 20 - Set the node whose data we want to COLOR 2 on the map. `POKE 752,1` makes the cursor invisible. And we can open an I/O
channel to the keyboard exactly as if it's a file, and `GET` ASCII code characters from it. (Whereas `PEEK(764)` returns more 
tricky scan codes, but has the advantage of not blocking while waiting for a key).
* 21 - Print a helpful bit of text in the text window at the bottom. Most of this graphics mode is for plotting at an
amazing resolution of 79*39.
* 22 - Get a key. ASCII 65, 68, 83 and 87 are A, D, S, W respectively. (X2,Y2) is the proposed new square, with checking for
going out of bounds.
* 23 - For any other key, don't do anything. If the square we are wanting to move into is of a certain colour... then forbid it.
* 24 - Otherwise, swap (X2,Y2)'s pixel with our own, and move there. Count how many moves. If a certain square has made it to (0,0),
then the game is done.
* 25 - Clear buffer, and keep going.
* 26 - The End.
*