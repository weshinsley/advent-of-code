; Advent of Code 2016, Day 11, Atari asm (6502)
; Just a little routine to search through
; an unsorted list of 3-byte or 4-byte groups
; for a particular entry. 

       org $0600                ; Fit in page 6 - 256 spare bytes...

           pla                  ; Arg count
           pla                  ;    Arg 0 msb
           pla                  ;    Arg 0 lsb
           tax                  ; x = arg[0] LSB - 3 or 4 for bytes per val.
           stx A1 + 1
           stx A2 + 1
           stx A3 + 1
           lda #64
           sta L1+2
           sta L2+2
           sta L3+2
           sta L4+2
           ldy #0
           sty L1+1
           iny
           sty L2+1
           iny
           sty L3+1
           iny
           sty L4+1
           pla                 ; Arg 1 msb
           sta END_MSB+1
           pla                 ; Arg 1 lsb
           sta END_LSB+1
           
           
L1         lda 16384
           cmp 203
           bne next
L2         lda 16385
           cmp 204
           bne next
L3         lda 16386
           cmp 205
           bne next
           cpx #3
           beq found
L4         lda 16387
           cmp 206
           beq found
next
           lda L1+1         ;   Get L1 address LSB
           clc
A1         adc #3           ;   (#3 overwritten by arg[0])
           sta L1+1
           bcc dig2
           inc L1+2

dig2       lda L2+1
           clc
A2         adc #3           ;   (#3 overwritten by arg[0])
           sta L2+1
           bcc dig3
           inc L2+2

dig3       lda L3+1
           clc
A3         adc #3           ;   (#3 overwritten by arg[0])
           sta L3+1
           bcc dig4
           inc L3+2

dig4       cpx #3
           beq skip_dig4
           lda L4+1
           clc
A4         adc #4           ;   (#3 overwritten by arg[0])
           sta L4+1
           bcc skip_dig4
           inc L4+2
           
skip_dig4  lda L1+2
END_MSB    cmp #64
           bne L1
           lda L1+1
END_LSB    cmp #0           
           bne L1
           lda #0
           sta 212
           jmp not_found

found      lda #1
           sta 212
not_found  lda #0
           sta 213
           rts
 
           
       


