## Advent of code, 2016 - DAY 15 - Atari Basic

## Overview

I did this the very slow (in Atari Basic) brute-force way, with only one small speed improvement. I'm sure 
I could speed it up a lot with some simple assembler, and I'm also sure there's a much better
mathematical way of solving it. But today, I have done neither of those, and just let the simple
code run overnight.

### Code:

Nothing very exciting.

* Lines 1-4 initialise. DS are my disk dizes, and DC is my current position.
* Line 5 sets the target I'm looking for. I want the first disk to be one move left of zero; the second to be two moves left of
zero, and so on. I check for negative numbers and correct, but this may not work for all inputs - particularly 
for very small discs.
* Lines 6-8 do a small number of steps, until disk 1 is one more left of its slot - hence, this is the first time the capsule
will make it through the hole at T+1. After that, we can safely jump forward by DS(1) seconds (the period
of the first disc), before there's any hope of a solution. This divides the number of tests by 7 in my
input, and I'm sure expanding that idea further would make it all much faster...
* Line 9-12 continue jumping through time in steps of DS(1) until all the slots line up with the 
* Line 13: first time through, X=6 and I check for the 6 discs (part a). After a solution, I check for the 7
discs (part b). And then after that solution stop.
