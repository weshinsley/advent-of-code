## Advent of code, 2016 - DAY 16 - Atari Basic

### Overview:

This puzzle has "I'm going to get with you a really big number" written all over it. Possibly, a solution will 
involve running it for lots of increasing sizes, plotting and extrapolating - which will be a big ask for Atari
Basic, although not as big an ask as getting 32Mb of RAM from somewhere.

### Towards analytical

Or, perhaps there is an analytical solution or method known to mathematicians who really like fractals... I am
not one of these... But I have noticed that the lengths required are 272 for part (a), and
35,651,584 - which are 17*(2^4), and 17*(2^17) respectively. My input string is 16 bits long - plus the one extra
zero in the middle of the expansion, but that doesn't quite work; size of initial input is 16, size of first
expansion is 16 + 1 + 16 = 33.

Let's try to expand it. `f` is the inverse, reverse function. Let's say f(a) = b. The function is symmetric, so
f(b) = a = f(f(a)).

* First expansion: `a` -> `a0b` - length 33
* Second expansion: `a0b` -> `a0b 0 a1b`  length 67
* Third expansion: `a0b0a1b` -> `a0b0a1b 0 a0b1a1b`  length 135
* Fourth expansion: `a0b0a1b0a0b1a1b` -> `a0b0a1b0a0b1a1b 0 a0b0a1b1a0b1a1b`  length 271

Now, for a start, storing `a` and `b` instead of the bits provides a geometrically expanding space saving. To store 
the n'th expansion using 0, 1, a and b as characters would take... `2(2^n)-1` bytes. That's still just over 128k - too
big, but better than before. We could represent the four possibilities into 2 bits though, requiring 32k, which we might
be able to work with - just about - in Atari Basic if our code is small, and we can calculate the checksum in almost
no memory. It's good, but I suspect not good enough. I think we'd want some kind of compression.

Calculating the checksum... is an iterative (or recursive) process in itself. The first time is the easiest, as we know at least
the middle of `a` and `b`, and only have to think about the start and ends, depending on the interplaced digit. But the second
version, where we keep checksumming the checksum... I'm not sure how to do that without using any memory.

### Really analytical?

So, I still wonder if there's some clever algorithm, that this puzzle is pushing at. Reading about [Dragon Curves](https://en.wikipedia.org/wiki/Dragon_curve) 
in Wikipedia. (The clue was in the title), take out all the ones and zeros from the fourth expansion, and compare it to the R and L on the expansion
of the Heighway Dragon Curve.

* `001001100011011`
* `RRLRRLLRRRLLRLL`

which might be a bit obvious, but it just shows we're dealing with an actual live dragon curve. And that means there are
straightforward functions for calculating the digits here - although they use bitwise arithmatic which Atari Basic doesn't
have any of. And also, having taken out the ones and zeros, the pattern of letters is always `ababab` and so on, which also
bodes well for there being something clever we can do...

.....

### Lines... (for part a so far)

* 0 - Read in `INPUT.TXT` - I've put this in a file for easy testing and sharing with everyone else who wants to solve
this puzzle in Atari Basic.
* 1 - Read it in. `L` is the length, `IN$` is the string.
* 2 - Sort out some arrays. I'm going to convert from `R$` to `S$` each time.
* 3 - Like this... `S$` becomes the flipped inverse of `R$`. There's always space to add a 0 on the end. There might not be space
to add any characters of `S$`, so check... then paste `S$` into the right place in `R$`. Atari Basic automatically ignores
out-of-bounds writes on a string, provided the first index is within bounds.
* 4 - Continue until we've done 272 or more characters.
* 5 - Do the checksum. Empty `S$`, skip through `R$` comparing, and rebuild `S$`. Copy `S$` to `R$`, check length and repeat...
* 6 - And repeat if length is even.
