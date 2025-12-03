## Advent of code, 2016 - DAY 21 - Atari Basic

### Overview:

Fairly straight forward, although part (b) encourgaed a rewrite, since reading text files backwards is not
convenient. Nothing particularly new in Basic. Not sure if I've described `GOSUB` before - which is a subroutine call, and `RETURN` returns control to the next command after the more recent `GOSUB` was called, which can be
on the same line. They can be nested - not sure how many the stack will hold - and `ON X GOSUB 10,20,30` calls one of the three subroutines depending on whether X is 1, 2 or 3.
although I can't remember whetherjust lots of string handling.

* Line 0: Some startup
* Line 1: Read an instruction line from the file. For each line, I encode each 'instruction' into 3 characters in `SC$`.
* Lines 2-5: `RESTORE` forces reading the data to line 5 from the start. If the first `L` characters matches `S$`, then the function numnber is `X`, and the two parameters taken from indexes `A` and `B` in the instruction.
* Lines 6: Loop and dispatch by function number.
* Line 10: Swap by position
* Line 11-12: Swap by letter
* Line 13-14: Rotate left
* Line 15-16: Rotate right
* Line 17-18: Rotate by given letter
* Line 19-24: Move
* Line 25: Reverse.

For Part B, we want to run the script backwards. For the swaps and the reverse, the functions are totally symmetrical. For the rotate left/right, we just want to call the opposite direction. The other two functions we need
to rewrite; the move needs its parameters swapped, and the rotate by character index is a bit trickier. I decided to trial and error; rotate the original, call the function on it, and see if the result was the one we wanted. 
Otherwise, rotate and try again.

* Line 26 is the new dispatcher - not the swapping of 13 and 15, and the new functions 30 and 28.
* Line 229 is the new move function - it swaps the parameters, then jumps back into the old move on line 20.
* Line 30-35 is the new rotate by given letter function, where `T$` is our target, `U$` is a rotation of `T$`, we perform the process on `U$` creating `V$`, and if `V$` matches the target, than `U$` was what we msut have
started with.
