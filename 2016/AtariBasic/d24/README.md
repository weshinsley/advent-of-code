## Advent of code, 2016 - DAY 24 - Atari Basic

### Overview:

A language with recursive functions and variable scope would make this problem easier to solve. So, again we have to do
some management of the recursive stack. The algorithm I used is to do a breadth first search from each of the points of
interest, and find the shortest distance to each of the other points of interest, forming an origin-destination matrix.
Then, we need to permute all the possible orders of visiting, and choose the smallest.

Nothing particularly new comes up in the code... here's what it does.

* 0-21 - this calculates the origin-destination matrix graphically. To skip this, `GOTO 23` - I've added the results in
the data statements on lines 25-26.
* 0-4 - parse the map file. I transpose X and Y, because the best resolution graphics screen I have in colour is
159x192, whereas my input map is 184x40.
* 4 - I store the co-ordinates of the places of interest in T$, in pairs of X and Y co-ordinates.
* 5 - Set up a direction matrix - arrays DX and DY are the changes in X and Y for directions N, E, S, W in order.
* 6-7 - DIST is our origin-destination matrix of shortest distances between points of interest. S1$ and S2$ are the LSB 
and the MSB of the shortest distance from the start point of a breadth-first search, to each reachable point in the maze.
The distances will go about 255, so we need two bytes to store them.
* 7-10 the N-loop tracks which place of interest is our start point for the breadth-first search. For each iteration,
we reset `S1$` and `S2$`, and the appearance of the map. (255,255) in (S1$,S2$) indicates a wall, and all blank spaces are
initialised to a very large distance...
* 10 - X and Y retrieve from T$ the co-ordinates of the place of interest we are starting from.
* 11 - Initialise the breadth-first search; (X,Y) is the first point to explore, and the best distance (`S1$` and `S2$`) for
that point is set to zero. S$ is the queue of locations that need exploring, and SP stores the end of the queue.
* 12-14 Recursion ends when the queue is empty. Otherwise: pull the location from the head of the queue, remove it, update SP.
`S$=S$(3)` is convenient to remove the queue head - unless `S$` is length exactly 2 characters, in which case we have to set it
to empty manually.
* 15-16 - For each direction, N, E, S, W, if the square in that direction is empty, and we haven't already reached that square
in a shorter distance before, then set the distance in S1$ and S2$ to the distance found in the current square plus one, and 
add that square to the queue. `LOCATE X,Y,Z` examines the maze graphically; if `Z=0` then it's a space, if `Z=1` then it's a wall, and
if Z=2 then it's a place of interest. `IF Z=3` then we've already visited that square, and it acts like a space.
* 17-18 - If the square was a place of interest, look up which one it is, and update the best distance if necessary.
* 19-21 - Update the graphics, and continue dealing with the queue, and afterwards, the next iteration of N.
* 23-26 - In case we're bored with watching the graphics of the breadth-first search, we can jump in here and read the summary
data on lines 25,26, which are the results of `DIST` that we're interested in.
* 27-34 - This is Hill's algorithm, to permute the numbers 1234567 into every possible order in the array `P`.
* 30 - Lookup the distance from 0 to the point of interest indicated by P(0), then from place P(0) to P(1), etc. For part 2, also
include the distance from P(7) back to point of interest zero.
* 31 - See if it's the best.

