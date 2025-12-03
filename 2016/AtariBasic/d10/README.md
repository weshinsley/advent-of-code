## Advent of code, 2016 - DAY 10 - Atari Basic

Mostly file parsing... nothing new on the Atari front.

### Overview:

* I've allowed for 250 different robots. Each has two values ```B1(n)``` and ```B2(n)``` - not necessarily in
order, and two destinations ```D1(n)``` and ```D2(n)``` - which will be in low-high order.
* ASCII 98 is ```b``` - hence, lines 10-20 deal with lines that start ```bot```, and lines
4-9 deal with lines that start ```value```.
* 4-9 - the value part is fairly straightforward. All values are positive, hence ```-1``` is my not-yet
identifier. Line 4 parses the value, line 6 parses the bot number, with constant bytes skipped between the two. 7-8 put
the value into the first of B1 and B2 that's currently ```-1```.
* 11 gets the bot number, remembering the largest we encounter for later.
* 13 decides whether the low is given to bot, or output; the bot number, (or add 1000 if it's an output) goes in D1.
* 19-20 do the same for the high value.
* 21-31 then cycles through the bots, doing some work each time a bit has two values 
(ie, neither ```B1(n)``` nor ```B2(n)``` is ```-1```. L becomes the lowest of the two, and H the highest.
* 23-25 and 26-28 despatch the values to B1 or B2 (whichever is -1), for the bots indicated by D1 and D2 of the donor.
* 61 and 17 are prime - hence, checking their product is enough on line 29, to see which bots handle those two.
* And if D1 or D2 were above 1000, that would be referring to outputs, dealt with on 35-41.

