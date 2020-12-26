## Advent of code, 2016 - DAY 19 - Atari Basic

### Overview:

This turns out, fortunately, to be analytically solvable, because otherwise, 
I couldn't think of any way to get a list of 3 million elves into 64k. One 
mathematical precision gotcha arises quite quickly as well, which is...

```
READY
? 2^21
2097153
```

whereas

```
READY
P=1:FOR I=1 TO 21:P=P*2:NEXT I:? P
2097152
```

Anyway, part 1 is the classical [Josephus Problem](https://en.wikipedia.org/wiki/Josephus_problem) and 
Wikipedia provides the very simple algorithm. Also the [Numberphile](https://www.youtube.com/watch?v=uCsD3ZGzMgE)
video of it is really good (with brutally understated animation...)

And part b: by testing, every time the number of elves is a exact power of 3, that 3-powered elf is
the winner... and I'm sure there are patterns besides that, but at that point, in February 2019, I cheated
and googled for the rest of the answer. Perhaps I'll return and figure it out for myself better some day.
