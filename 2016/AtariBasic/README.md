## Advent of code, 2016 - in Atari Basic

Atari Basic is perhaps the first language I learned as a very small kid in the mid-1980s. I
still have working hardware, which my not so tiny kids enjoy. In its time it was a very
fun machine to push to its limits, and for nostalgic and curious reasons, I wondered
whether its 1.79MHz processor (single-core, to be clear), and around 36k of RAM in Basic,
can be used to solve these AoC problems. And most of the time, it turns out it can, quite
slowly in many cases. 

In the folders below, I'll try and solve each puzzle, and the readme in each folder will 
incrementally describe the bits of syntax I've had to add for each one.

## Basic Loading and Running.

* I am cheating by using the excellent [Altirra](http://virtualdub.org/altirra.html) emulator, 
combined with an Atari Basic Revision C ROM which you must google for, download, and then 
in System,Configure System, Firmware, add and enable the Basic Firmware.

* Altirra lets you configure a folder as a virtual large floppy drive called "H:" - see the 
System, Configure System, Devices. That acts like one folder - sub-directories not supported
within the emulated Atari.

* The standard Atari knows nothing about folders, so is expecting `INPUT.TXT` to exist
in each folder. Run "copy_input.bat" to copy these from `/2016/inputs`.

* So, if you now boot the virtual Atari, you should get a ```READY``` prompt, at which you might
type...
  - ```LOAD "H:D01.BAS"``` to clear all current code/variables and load a basic file.
  - ```LIST``` or ```LIST 5``` or ```LIST 3,7``` to show all or part of the code.
  - ```SAVE "H:D01.BAS"``` should you want to resave the code.
  - ```LIST "H:D01.LST"``` writes the code nearly as a text file - just need to do a search and replace of ASCII code 155, with a newline.
  - ```ENTER "H:D01.LST"``` loads something that has been listed - and *merges* - so it doesn't clear current memory or variables, and only overwrites lines if the same line numbers are included in the LST file.
  - ```NEW``` clears the memory of code and variables.

* Note that files in Atari Basic are case-insensitive. Traditionally, they would be in upper-case,
and I'll stick with that convention.

* Alternatively, to all this loading or saving, Altirra let's you right click and *paste* copied text, as if it were typed. An
Atari ```.BAS``` file is tokenised, non-readable text, but I'll include a text version of the code
on each day for readable copy/paste purposes.

## TO-DO

* Days 5, 14 and 17 not done as they require MD5... write one in assembler maybe? And then see what else we need afterwards...
* Day 16, can't do part (b) in small memory yet.
* Add a pretty picture to all days that don't yet have anything.
* And review how ugly some of my READMEs are.
