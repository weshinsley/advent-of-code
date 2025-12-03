; A little VBI (vertical-blank interrupt) code,
; to put a couple of players on the screen at
; an (x,y) position, with given direction,
; so BASIC can get on with passing...

; Some constants
      DIRECTION  equ 203
      POS_X      equ 204
      POS_Y      equ 205
      OLD_Y      equ 206
      OLD_DIR    equ 207
      DIGIT_1    equ 1536
      DIGIT_2    equ 1537
      DIGIT_3    equ 1538
      SETVBV     equ $E45C
      SYSVBV     equ $E45F
      PM0_X      equ 53248
      PM1_X      equ 53249
      DUMMY_P    equ 32768
      DUMMY_A    equ 255
      PLOT_RESULT equ 212
      
      org $9800          ; Start of code - fit between PM 

      ; We need a custom display list, because the answer needs 205 vertical pixels; the normal
      ; GR.8 screen is only 192. But there are enough scan lines to stretch a bit.

display_list
      dta 112            ; 8 blank scan line at top. (Usually there would be 3)
      dta 79,0,112      ; 64+15 = LMS + mode 15, with screen memory at 28672
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15,15      ; total 102 mode 15 lines: 102 * 40 = 4080 - less than 54k. (+16 byte pad)
      dta 79,0,128                              ; Need another LMS because of 4k boundary
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15
      dta 15,15,15,15,15,15,15,15,15,15,15     ; 102 mode 15 lines again, but can't make this one contiguous.
      dta 79,0,144  ; One more LMS for a last few lines.
      dta 15,15,15  ; 4 more lines = 208 total.
      dta 65,$0,$98  ; Vwait and JMP to start of DList. 

; Total bytes in Display list: 218

; Now some lookups, for a given Y (0-207), what's the display list position?
y_loc_msb
      dta 112,112,112,112,112,112,112,113,113,113,113,113,113,114,114,114,114,114,114,114,115,115,115,115,115,115,116,116,116,116,116,116
      dta 117,117,117,117,117,117,117,118,118,118,118,118,118,119,119,119,119,119,119,119,120,120,120,120,120,120,121,121,121,121,121,121
      dta 122,122,122,122,122,122,122,123,123,123,123,123,123,124,124,124,124,124,124,124,125,125,125,125,125,125,126,126,126,126,126,126
      dta 127,127,127,127,127,127
      
      dta 128,128,128,128,128,128,128,129,129,129,129,129,129,130,130,130,130,130,130,130,131,131,131,131,131,131,132,132,132,132,132,132
      dta 133,133,133,133,133,133,133,134,134,134,134,134,134,135,135,135,135,135,135,135,136,136,136,136,136,136,137,137,137,137,137,137
      dta 138,138,138,138,138,138,138,139,139,139,139,139,139,140,140,140,140,140,140,140,141,141,141,141,141,141,142,142,142,142,142,142
      dta 143,143,143,143,143,143
      
      dta 144,144,144,144
       
y_loc_lsb
      dta 0,40,80,120,160,200,240,24,64,104,144,184,224,8,48,88,128,168,208,248,32,72,112,152,192,232,16,56,96,136,176,216
      dta 0,40,80,120,160,200,240,24,64,104,144,184,224,8,48,88,128,168,208,248,32,72,112,152,192,232,16,56,96,136,176,216
      dta 0,40,80,120,160,200,240,24,64,104,144,184,224,8,48,88,128,168,208,248,32,72,112,152,192,232,16,56,96,136,176,216
      dta 0,40,80,120,160,200
      
      dta 0,40,80,120,160,200,240,24,64,104,144,184,224,8,48,88,128,168,208,248,32,72,112,152,192,232,16,56,96,136,176,216
      dta 0,40,80,120,160,200,240,24,64,104,144,184,224,8,48,88,128,168,208,248,32,72,112,152,192,232,16,56,96,136,176,216
      dta 0,40,80,120,160,200,240,24,64,104,144,184,224,8,48,88,128,168,208,248,32,72,112,152,192,232,16,56,96,136,176,216
      dta 0,40,80,120,160,200
      dta 0,40,80,120
      
x_loc_byte
      dta 8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12
      dta 13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17
      dta 18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22
      dta 23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27
      dta 28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31,31,31,31,31,31,31,31,32,32,32,32,32,32,32,32
      dta 33,33,33,33,33,33,33,33
      
x_loc_bit
      dta 128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1 
      dta 128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1 
      dta 128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1    
      dta 128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1 
      dta 128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1,128,64,32,16,8,4,2,1
      dta 128,64,32,16,8,4,2,1 


plot_func
      pla     ; Always need first PLA
      pla     ; Pull off stack y-MSB first (which will be zero for Y)
      pla     ; Pull off stack y-LSB.
      tax     ; x = a
      lda y_loc_msb, x   ; a = y_loc_msb[x]
      sta read_pix_y + 2   ; Overwrite placeholder
      sta write_pix_y + 2
      lda y_loc_lsb, x   ; a = y_loc_lsb[x]
      sta read_pix_y + 1   ; Overwrite placeholder
      sta write_pix_y + 1
      pla     ; MSB of X always zero)
      pla     ; LSB of X
      tax
      lda x_loc_byte, x   ; a = x_loc_byte[x]
      sta read_byte_x + 1 ; Ovewrwrite placeholder
      sta write_byte_x + 1
      lda x_loc_bit, x   ; a = x_loc_bit[x]
      sta read_bit_x + 1 ; Overwrite placeholder
      sta write_bit_x + 1
      lda #0
      sta PLOT_RESULT + 1
      
      
read_byte_x      
      ldx #0             ; X offset placeholder
read_pix_y               ; The next two placeholders are overwritten
      lda DUMMY_P,X      ; Look in screen memry
      tax
read_bit_x               ; Save original for later
      and #DUMMY_A       ; Filter bit for the pixel we're about to plot.
      cmp #0             ; Is it zero?
      beq empty_pix      ; If so, it's empty... return 0
      lda #1             ; Otherwise it's one...
      sta PLOT_RESULT    ; Return the result
      rts                ; And we're done,.
empty_pix                ; If it wasn't already plotted,
      lda #0
      sta PLOT_RESULT    ; Set return (0 or 1)
      txa                ; Back to the original value 
write_bit_x
      ora #DUMMY_A       ; OR with the bit
write_byte_x
      ldx #0             ; Placeholder for x
write_pix_y
      sta DUMMY_P,X      ; Placeholder for y   
      rts                ; Done.

; Setup VBI
     
      pla
      pla
      pla
      tax
      stx wipe+2
      stx p1+2
      stx p3+2
      stx p5+2
      stx w1+2
      inx
      stx wipe+5
      stx p2+2
      stx p4+2
      stx w2+2
      stx p6+2
      
      lda #0
      ldx #0
w1
      sta DUMMY_P,X
w2
      sta DUMMY_P,X
      inx
      cpx #255
      bne w1
      sta DIRECTION
      sta POS_X
      sta POS_Y
      sta OLD_Y
      
      lda #112
      sta clear_mem + 2
      lda #0
      sta clear_mem + 1
      ldx #0
clear_mem
      sta DUMMY_P,X
      inx
      cpx #0
      bne clear_mem
      ldy clear_mem + 2
      iny
      cpy #145
      beq end_setup
      sty clear_mem + 2
      jmp clear_mem  
end_setup
      lda #6
      ldx #vbi/256
      ldy #vbi&255
      jsr SETVBV
skip_setup_vbi
      rts
      
vbi   sta restore + 1
      stx restore + 3
      sty restore + 5
      
      lda POS_X
      sta 53248
      sta 53249
      ldy OLD_Y
      cpy POS_Y
      beq plot
      
      lda #0
      ldx #3
wipe
      sta DUMMY_P,Y
      sta DUMMY_P,Y
      iny
      dex
      cpx #0
      bne wipe
      
      ldy POS_Y
      sty OLD_Y

plot
      ldx DIRECTION 
      lda pmdata,X
p1    sta DUMMY_P,Y
      inx
      lda pmdata,X
p2    sta DUMMY_P,Y
      inx
      iny 
      lda pmdata,X
p3    sta DUMMY_P,Y
      inx
      lda pmdata,X
p4    sta DUMMY_P,Y
      inx
      iny 
      lda pmdata,X
p5    sta DUMMY_P,Y
      inx
      lda pmdata,X
p6    sta DUMMY_P,Y

; Write the three digits in (1536,1537,1538) to top left.

      ldy #0           ; for x = 0 to 2 - each of the three digits in 1536,1537,1538
digit_loop
      lda 1536,Y       ; Get the number (0-9)
      clc              ; Add 16, as that's where '0 is in the chracter set
      adc #16
      asl           ; Multiply by 8, as character bitmaps are 8 bytes
      asl
      asl
      tax
      
      lda 57345,x     ; Copy middle 6 bytes (ignore top/bottom margin) 
      sta 28672,y
      lda 57346,x
      sta 28712,y
      lda 57347,x
      sta 28752,y
      lda 57348,x
      sta 28792,y
      lda 57349,x
      sta 28832,y
      lda 57350,x
      sta 28872,y
      iny
      cpy #3
      bne digit_loop
       
      
restore
      lda #0
      ldx #0
      ldy #0
      jmp SYSVBV
     
pmdata
      dta 2,0,5,2,0,5
      dta 2,4,1,2,2,4
      dta 0,5,5,2,2,0
      dta 2,1,4,2,2,1 