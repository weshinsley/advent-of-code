## Advent of code, 2016 - DAY 18 - Atari Basic

There are other analytical-type solutions to this problem, but I decided to (1) do a version in a graphics
mode, and then, given part b being bigger, but not inconceivably huge, (2) do a version of the main 
processing in 6502 assembler.

Basic version files:

* [```CODE_BAS.BAS```](CODE_BAS.BAS) - the pure basic program, with graphics.
* [```code_bas.txt```](code_bas.txt) - text readable version of the above.

Assembly version files:

* [```code_asm.asm```](code_asm.asm) - the 6502 code I wrote.
* [```code_asm.lst```](code_asm.lst) - the list output from the MADS compiler
* [```CODE_ASM.BIN```](CODE_ASM.BIN) - binary loadable file of the above.
* [```CODE_ASM.BAS```](CODE_ASM.BAS) - basic to load the BIN, and run part (a) and (b)
* [```code_asm.txt```](code_asm.txt) - text readable version of ```CODE_ASM.BAS```

## The BASIC (Graphic) version

* Lines 0-7 solve part (a), drawing a pretty picture as it goes.
* ```GRAPHICS 7``` is a 160x180 resolution 4-colour mode, with a text window.
* ```POKE 764,255``` clears the keyboard buffer. Well, when I say buffer, I mean the one
character that will appear or get used at the next opportunity...
* To get single keypresses, I can either read ```PEEK(764)``` for funny non-ASCII scan codes, or
```OPEN #1,4,0,"K:":GET #1,A``` uses similar syntax for file reading, but using a keyboard device ```K:```
instead of a disk. The ```GET``` pauses and waits for a keypress, and ```A``` is assigned an ASCII value.
* The rest is simple strings and loops. I pre-pended and appended a ```.``` character to calculate the
boundary values, hence my loops for scoring, and copying the new string to the old tend to run from 
1 to length-1 inclusive.

## The ASSEMBLER version

Well. 6502 assembler code is reasonably simple and pleasant among the languages of that sort I've used. 
It has three 8-bit registers called ```A``` (accumulator), ```X```, and ```Y```, and a program control 
register containing a few flags that might get set or unset, as side-effects of operations performed. 
It has smaller faster operations when working with memory addresses below 256 (zero-page), which can be 
fitted into a byte. It has a stack that the accumulator can push or pop. It has subroutines that can
be called and returned-from, using the stack to send arguments (but not return results). It has adds 
and subtracts (in which you have to watch the carry-flag), branches and jumps, and the usual bitwise
operators (which BASIC doesn't have). 

When you get down to it, it's not much more complicated than Assembunny...

### Developing it.

* I wrote the algorithm effectively on paper. With a pencil. I used a rubber several times.
* I then typed it up in [Eclipse](https://www.eclipse.org]), using the [https://www.wudsn.com/](WUSDN) plug-in, 
and the [MADS](http://mads.atari8.info/) assembler. And [Altirra](http://virtualdub.org/altirra.html) to run and
debug.
* Compilation produces an ```.XEX``` file, which typically is an Atari executable file, but I'll be
parsing that file (easily) into Atari Basic rather than executing it entirely. I can't remember how to do the
file-handling in assembler just now...

### Memory usage...

* A big fat (not really) splodge of free memory sits between about $4000 and $A000 in an unexpanded Atari XL. The 
basic program itself starts to nibble at the low end, and my code will be tiny... so I arbitrarily chose $6000 to
compile my code. See the ```org``` command in the assembler sources - which is a pre-compiler command.
* Also very useful are a bunch of spare bytes ```$CB-$CF``` (203-207), which are not used by BASIC, and are relatively
fast since they are in page zero. The 6502 has some smaller fast instructions for memory addresses that are represented
by a single byte. I use these for counters that get altered often.

### Code Overview.

* See somewhere like [here](https://www.atarimax.com/jindroush.atari.org/aopc.html) for a full 6502 reference. The
  only difference I spotted was that ```ASL A``` in the documentation, must be written as just ```ASL``` for MADS; it
  does an arithmetic shift left of the ```A``` register.
* And see * [```code_asm.asm```](code_asm.asm) - for line-by-line pseudocode of how it works, which will explain a modest
  chunk of what the 6502 can do.

### BASIC -> ASSEMBLER CODE

* The code is called from BASIC with ```Z=USR(M,INPUT,LENGTH,OUTPUT,COUNT)``` where:
  * All the arguments to USR are treated as 16-bit integers.
  * M is the start address of some assembler code. For us: $6000 = 24576.
  * INPUT is the address of the first byte of the input string - having already prefixed and affixed a spare ```.```
  * LENGTH is the number of characters in the input string, including the two extra safe spaces.
  * OUTPUT is the address of free memory the same length as INPUT, for calculating the next step.
  * COUNT is the number of steps to make, divided by 10 - so that for part (b), we can send 40000, which is 16-bit, whereas 400,000 is too big.
  * The last 4 are pushed onto the stack in reverse order, LSB followed by MSB for each 16-bit integer. After that, the number 
    of bytes of arguments (8 here) is pushed.
  * The assembler code must pop all 9 bytes from the stack before returning to Basic, or it will crash. 
  * And the stack is a LIFO queue, so have to remember the 16-bit numbers come off the stack MSB first, while in all
    other 2-byte memory addresses in the 6502 code, they are written LSB first.
