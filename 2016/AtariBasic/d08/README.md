## Advent of code, 2016 - DAY 7 - Atari Basic

For Day 7, we needed some actual graphics!

### Overview:

* A bit of string parsing to get the numbers - lots of subtracting by 48 to get number values from ASCII ```0```.
* Then the actual rotations I decided to do with an actual graphics screen. Pixels are bit-packed into memory with
small computers, so this is quite memory efficient too...!

### POKE

* ```POKE``` puts an 8-bit number into a memory address. And like all computers of this kind, certain 
memory addresses are hardwired into doing certaint things. 
* In this code, ```POKE 82,0``` changes the left-margin of any text screen. By default this is 2, and for
some reason I decided I wanted no left margin here.
* I haven't needed it here, but ```PEEK``` is used to lookup the value in a memory address.

### Some Graphics

* ```GRAPHICS 4``` gets into a graphics mode that has a 4-line text window at the bottom, and
a staggering 80x40 matrix of pixels above it, where (0,0) is the top-left. In 2 colours. Black and red-ish by default.

* ```LOCATE X,Y,Z``` makes ```Z`` become the value of the pixel at the co-ordinate (X,Y). It works on
text screens too, returning the ASCII value for the character at that co-ordinate.

* ```COLOR X``` sets which color is used for the next plot or drawing. For this graphics mode, ```0``` and ```1``` are
the interesting values to use. There are tricksy ways of getting lots of different colours on a screen, but ```COLOR``` is not the
way...

* ```PLOT X,Y``` plots a pixel at the given co-ordinate. Not needed here, but ```DRAWTO X,Y``` draws a line from the pixel most recently visited
by a ```PLOT```, or another ```DRAWTO```, to another co-ordinate.

