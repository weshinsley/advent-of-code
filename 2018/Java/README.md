## DIDE does advent of code, 2018

Each year, [Advent of code](https://adventofcode.com/) runs as a series of small programming challenges.  It's good fun, but it can be a lot of work to complete all the puzzles by yourself.

So the idea here is to complete the puzzles cooperatively!  Dip in and out, complete a puzzle that hasn't been done yet, or have a shot at one that has been done in a different language, with a different approach, or whatever.  Look through the alternative versions and learn something about different ways of solving problems.

Everyone who wants to can have push access to this repository - we won't be using pull requests *unless you want to suggest changes to someone else's solution*.  So a little structure is required to keep us from conflict hell.

Each day goes into a directory called **d** followd by a **two digit number** (`d01`, `d02`, ..., `d24`).  Within each directory all files that you create should be prefixed with your name or github name (whatever is most convenient and relatively unambiguous), e.g., `richfitz.R`, `richfitz-support.R`.  If you need a heap of support files for whatever reason, consider using a directory (e.g., `richfitz/`).

If you can't get a problem solved, just skip ahead until you find one you like, or use an existing solution to help get yours working.

## Resources

* Slack channel: `#advent-of-code` - anyone can join, no need to be invited (but ask Rich if you have trouble finding it)
* Leaderboard code: `309566-251fd075` - after entering this on the [private leaderboard page](https://adventofcode.com/2018/leaderboard/private) you can see our leaderboard [here](https://adventofcode.com/2018/leaderboard/private/view/309566) (if you find that sort of thing fun)
* There's also a general RSE one with code `236181-c749311a`
* and an Imperial RSE one with code `194474-115405e0`

## Wes

So, day 1 is up, and probably being among the most pathologically keen of our clan, I have likely got here first, and have taken a couple of liberties if that's ok:-

* Does anyone mind if we could prefix the folder name with a letter, such as the very respectable `d`? I am going to solve the problems in Java, and the folder name starting with a number makes it a bit tricky to build nicely. (I have brazenly assumed compliance and updated the text above)

* I have also created a folder called `tools` - which for me (and perhaps others) I'd like to use to contain any code that is likely to be shared between solutions for different days. This will make my Java solutions a bit more concise. I've got various little handling routines I've clobbered together from previous Advent years. I'll keep my files "Wes-" prefixed in there, and Java won't care at all if there are other people's files in there too.

* In the 2015 AoC, I noticed that different users were provided with different input files on some days. I've therefore downloaded mine as `d01/wes-input.txt` - which may well be the same as the input file you get, but might not be totally guaranteed.

* If you want to run any of my solutions, you'll need a JDK from (eg) java.sun.com, and add the bin folder to your system path, so that you can run `javac` and `java` from the commandline. Then, sitting in the root of the repository, `javac d01/wes.java` to compile and `java d01.wes` to run.
