## Advent of code, 2016 - DAY 20 - Atari Basic

The problem itself is not that difficult to solve conceptually; basically for (a)

1. Sort the lines of input data by the left-most number.
2. Starting with candidate = 0, and moving from the top to bottom of the sorted lines:
  - if the candidate is less than the first number, you've found the answer.
  - otherwise, if the candidate is less than the second number, candidate becomes second number + 1
  - otherwise, leave the candidate alone and continue with next line.

And for (b), the difference is that instead of "finding the answer", you accumulate the difference
between then first number, and the candidate each time.

## However....

The challenge for Atari Basic, is the size of the integer. On bigger computers, we'd be using an unsigned
32-bit integer, or if that's not available, a long integer type. Atari Basic's number is a strange 
format, and the particular issue that's going to get us is...

```
X = 4294967295

READY
? X
4294967290
```

Atari Basic rounds at ten decimal places for an integer (without warning us. But don't forget this late 1970s
early 1980s technology, and warnings were a luxury...!). I went for a mixture of Atari Basic for the file
handling, and a bit of decimal maths to sort out the above problem so that the input representation was as
32-bit (4-byte) unsigned integers. Then the sorting, and the solving of the puzzles I wrote some assembler.

## The Files...

Basic version files:

* [```CODE.BAS```](CODE.BAS) - the pure basic to load and get ready
* [```code.txt```](code.txt) - text readable version of the above.

Assembly version files:

* [```sort.asm```](sort.asm) - the 6502 code I wrote.
* [```sort.lst```](sort.lst) - the list output from the MADS compiler
* [```SORT.BIN```](SORT.BIN) - binary loadable file of the above.

## The BASIC stuff

* Lines 0: ```POKE 106,70:GRAPHICS 0``` - this pattern basically says that I want to use the memory starting at page 70
and the following graphics call fires an event that makes BASIC move everything out of the way. It turns out to be much
more memory than I need, but hey ho.
* Lines 1: best explained by this table...

| Big Number    | In Hex Bytes | In Decimal Bytes |
|---------------|--------------|------------------|
| 1,000,000,000 | 3B 9A CA 00  | 59 154 202 0     |
| 2,000,000,000 | 77 35 94 00  | 119 53 148 0     |
| 3,000,000,000 | B2 D0 5E 00  | 178 208 94 0     |
| 4,000,000,000 | EE 6B 28 00  | 238 107 40 0     |

So, as I read in the data, if it's more than ten digits (which Basic can't accurately store), I'm going to lop
off the first character of the string, convert the remaining nine digits to hex (which Basic wil be fine doing),
then depending on what the first digit was, add the bytes above to the converted hex.

* Line 2 parses a number from the file, delimited by dash (ASCII `45`), or newline (ASCII `10`).
* Line 3 gets a nine-digit or less value as a number into `V`; `I` stores the number of digits, and `T` is 1, 2, 3 or 4
if the original number was ten digits, and we've subtracted some billions from it to make it nine digit.
* Line 4 converts `V` into a 32-bit unsigned integer across 4 bytes, and pokes it into the RAM we reserved.
* Line 5 - if the number was 10 digits, this adds the billions in `T`, doing an add-with-carry, from right-most to
left-most byte. After this, we have successfully moved even the big ten-digit numbers into 4-byte 32-bit unsigned ints.
* Line 6 - move memory on 4 bytes, and keep reading. The loop is ended by an EOF error, which is caught.
* Line 7-8 reads in the ASM code. The first 6 bytes are header which we could use - but I ignore here as I was getting tired.
* Line 9 calls the ASM to sort, starting at memory reference 17920, and the start of the last line is M-8.
* Line 10 calls the ASM to solve part A and B.

## The Assembler bit.

* Fiddly, as always. See the listing for comments.
* Essentially, I do an insertion sort.
* I use indirect addressing - `LDA ($CC),Y` looks up address $CC and $CD, treating them as an LSB and MSB of
a memory address. It then adds the value of Y to that memory address index, and gets the value out of the resulting address.
