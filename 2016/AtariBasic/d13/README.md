## Advent of code, 2016 - DAY 13 - Atari Basic

So, this puzzle is basically a depth-first search, followed by a breadth first search;
a shortest-distance followed by a limited-distance exploration. The challenge for Atari
Basic is the lack of functions and variable scope, which means recursive algorithms like
this have to be done manually, and are therefore much more clumsy and inelegant than the
underlying solution.

## Anyway...

* I decided I would draw these graphically for fun...
* And for the recursive stack, I used a string as an array of chars (bytes), since all the numbers
we want to represent will be less than 255.
* For the breadth-first, I decided 255 would represent a wall, 254 would represent a space not yet
explored, and any other number would represent the best distance from (1,1) to that square so far,
so don't re-explore if we've already been able to get to that square quicker than the current path.

## The Lines... (a)

* 0-1 : I stored the input in a text file (Unix line-endings) anyway, instead of coding it.
* 2-5 : Plot the maze walls in colour 1, and the spaces are left as colour zero. 0..XM and 0..YM are the 
limits of the maze, inclusive, and it turns out (50,50) is sufficient for both problems.
* 7-15: The explore step of the recursion. `S$` is my stack, onto which I store the steps so far as 
characters, N, E, S and W. I use `LOCATE` to examine the map visually, to see if there are walls or not.
* 8-9: The `POKE 77,0` stops attract mode happening, where the Atari colour-cycles everything to protect CRT
screens. It's a bit annoying these days. But also here, if I've reached the target, then the distance to
get there is the new 'best' distance, MD, so any path reaching that value in the future can give up; we've
already got a better distance.
* 15-19: This is the backtrack part of the algorithm, to peel the previous steps off the stack, and jump
back into lines 11-13 to explore the next direction in order.

## The Lines... (b)

* 20-23: Because I need to store a number for each point, I needed a new array for this. `S2$` represents
the screen, and I rescan the graphics to populate it with 255 for all the walls, and 254 for all the spaces.
(1,1) - which is `(YM + 1) + 2` in `S2$` is set to distance zero, and we load (1,1) onto `S$`, which
is now a queue, and will at the beginning contain the first and only square to explore.
* 24-27: Here, we peel the first (X,Y) from the front of the queue. `LEN` returns how many contiguous
characters appear at the start of a string (whereas `DIM` sets the memory capacity of the string). `S$(3)` is
a convenient way of deleting the first two characters - but we need a special case when `S$` only contains
two characters, as it does at the beginning.
* 27: `Z` here is the number of steps it took to get to this square, so if it is 50, don't explore any further.
* 28-35: Otherwise, we add the squares North, South, West and East from (X,Y) - but only if
(1) they are in the range 0..XM, 0..YM, and (2) they're not a wall, and (3) they're either unexplored (254), or
they have been explored but we've got there in fewer steps this time `Q` is the magic number, and if it is 254,
then we increment `C` which stores every previously unexplored square that we now enter.