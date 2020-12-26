## Advent of code, 2016 - DAY 23 - Atari Basic

### Overview:

Bearing in mind this code self-modifies, my solution for Day 12 involving return-key mode isn't the right one,
cute as it is. We need to know what the instruction is, and while I suppose I could list it to the screen (in
return-key mode), work out what it is, and transform it... and then handle the copy number, number somehow in
a way that preserves that it's a copy for the next time it might toggle... It's just starting to feel a bit
gruesome, so for this one, I'll write a proper interpreter, which will be quite fun anyway.

Storing the commands is interesting - we need to distinguish between registers and numbers somehow, and it looks
like TGL can do no end of nonsense. So I'm going to expand the command set a little like this:-

No. |  Opcode. |  Arg 1  | Arg 2  | Compile as                  | Toggle into
----|----------|---------|--------|-----------------------------|-------------
  0 |   CPY    |   num   |   num  |   skip                      |    8
  1 |   CPY    |   num   |   reg  |   [reg] = num               |    9
  2 |   CPY    |   reg   |   num  |   skip                      |    10
  3 |   CPY    |   reg   |   reg  |   [reg] = [reg]             |    11
  4 |   DEC    |   num   |        |   skip                      |    6
  5 |   DEC    |   reg   |        |   [reg]--                   |    7
  6 |   INC    |   num   |        |   skip                      |    4
  7 |   INC    |   reg   |        |   [reg]++                   |    5
  8 |   JNZ    |   num   |   num  |   if num<>0 goto pc+num     |    0
  9 |   JNZ    |   num   |   reg  |   if num<>0 goto pc+[reg]   |    1
  10|   JNZ    |   reg   |   num  |   if [reg]<>0 goto pc+num   |    2
  11|   JNZ    |   reg   |   reg  |   if [reg]<>0 goto pc+[reg] |    3
  12|   TGL    |   num   |        |   Toggle pc+num             |    6
  13|   TGL    |   reg   |        |   Toggle pc+[reg]           |    7

Note that TGL can get toggled into an INC, but no op-code can become a TGL, so there is hope 
perhaps that the TGL behaviour might dissolve. Or perhaps it might not.

### The Code

* C is for Code, and is my program, C(x,1) is the op-code, C(x,2) is the first argument, and
C(x,3) is the second if it exists. These are numerical, as the code is not very big, so I'm 
brazenly letting it have 90 or so numbers, at a massive code of 11 bytes each. Registers will
be stored as numbers 1,2,3,4 for easy indexing; the op-code is sufficient to know whether
1,2,3,4 refers to a register, or an absolute number.
* 0: Set up some arrays...
* 1: Read the op-code - always 3 letters and a space.
* 2: Read first argument; new-line means there's no second argument. Or...
* 3: Read second argument.
* 4-8: Match the opcode, and convert to the number in the first column above.
* 9-10: Process second argument. (Hence, single-argument opcodes in lines 4-8 skip this). `VAL` is useful
for converting the string into the number, if it's not a,b,c or d.
* 11-12: Same for the first argument.
* 13: L is our line number; keep going, until a EOF error is caught.
* 14: Initialise registers; N is now number of lines, and L is current line number.
* 15: Load in the toggles - last column in the table above.
* 16: Check we're inside the code, otherwise the program has ended.
* 17: Neat - jump to lines 20..33, depending on op-code.
* 20-33: Do the work for opcodes 0-13, update the line number, and do the next line.
* 34-35: I needed one extra line here for testing that the line number to toggle (Z) is in range.

### Part 2

So, the description makes me think this will take phenomenally long on the Atari, and we'll need to
reverse engineer. The toggles might be annoying for reading the code, so let's try and break the number 
a bit first. For 7 eggs, my answer was 11130...
* which is 2 * 3 * 5 * 7 * 53. So maybe we're looking for something to do with lowest divisors, but the 
53 is awkward to guess. It's the 16th prime number... as it turns out, this is a red herring though....
* So let's look at the code. Register a starts at 7. The others get initialised within the code.
```
| Line | Code     | Meaning...                  | Or simply... |
|------|----------|-----------------------------|--------------|
|   1  | cpy a b  |  b=a                        |              |
|   2  | dec b    |  b--                        |              |
|   3  | cpy a d  |  do {  d=a                  |   d=a        |
|   4  | cpy 0 a  |        a=0                  |              |
|   5  | cpy b c  |        do { c=b             | -            |
|   6  | inc a    |             do { a++        | -            |
|   7  | dec c    |                  c--        | - a=bd       |
|   8  | jnz c -2 |                } while c!=0 | -            |
|   9  | dec d    |             d--             | -            |
|   10 | jnz d -5 |           } while d!=0      | -            |
|   11 | dec b    |        b--                  |   b--        |
|   12 | cpy b c  |        c=b                  |              |
|   13 | cpy c d  |        d=c                  | -            |
|   14 | dec d    |        do { d--             | - c=2b       |
|   15 | inc c    |             c++             | -            |
|   16 | jnz d -2 |           } while d!=0      | -            |
|   17 | tgl c    |        tgl(c)               |              |
|   18 | cpy -16 c|        c=-16                |              |
|   19 | jnz 1 c  |     } while (true)          |              |
```

* There are a 7 more lines, but we can't get to them until line 19 gets changed, or some other line changes
such that we jump over line 19. In either case, it will be some action of the toggle on 17. So we'll talk about 
lines 20-26 when we've got a better idea of what toggles have taken place.
* For the toggle to occur, we need c to be at most 9 (as my last line is 26), and at least -16,
which would toggle the first line.
* So... 6..8 is actually a=a+c. Wrapping 5..10 around that does it 'd' times - so a=a+dc. Because d
starts at a, and c starts at b, and b=a--... On the first iteration, this calculates a(a-1) - or 7*6.
* Next iteration of 5..10, b is decreased, d takes the value that a had, and then a accumulates db again... which
is n(n-1)(n-2). So, it's looking rather factorial.
* So through this process b is reducing by one each time on line 11. Lines 14-16 make c=2b. So, for the starting case
of a=7, when we reach line 17 for the toggle for the first time, b will be 5 (having been dec-ed on lines 2
and 11). Next time, 4, then 3, then 2, then 1. And c will be double that each time. Hence, toggle will be called with
10 (which is ignore), 8 (toggling line 25), 6 (toggling line 23), 4 (toggling line 21), and 2 (toggling line 19),
at which point the final jump is toggled into a copy, and we can continue. By this time, a will be
n! (5040 for case 7). The next file lines then look like this, pre and post toggle.

```
| Line | Original | Toggled   | Meaning                 |
|------|----------|-----------|-------------------------|
|  19  | jnz 1 c  |  cpy 1 c  |    c=1                  |
|  20  | cpy 70 c |           |    c=70                 |
|  21  | jnz 87 d |  cpy 87 d |    do { d=87            |
|  22  | inc a    |           |         do { a++        |
|  23  | inc d    |  dec d    |              d--        |
|  24  | jnz d -2 |           |            } while d!=0 |
|  25  | inc c    |  dec c    |         c--             |
|  26  | jnz c -5 |           |       } while c!=0      |
```

* So. Very simply. For my input, we add 87 to a 70 times. For a given a, the answer is a! + 6090. 
Although it's fairly likely the 87 and 70 change for different people...!

* So see code2.txt for a more concise version of the code...
