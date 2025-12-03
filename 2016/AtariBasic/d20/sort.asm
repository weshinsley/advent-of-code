; Advent of Code 2016, Day 20, Atari asm (6502)
; Basic code reads/converts the numbers into 4-byte
; hexadecimal representation. This code sorts them
; in increasing order of the first number in each row.

; Constants and placeholders
DIGIT_3 = 0
DIGIT_2 = 0
DIGIT_1 = 0
DIGIT_0 = 0
END_J_LSB = 0
END_J_MSB = 0
END_I_LSB = 0
END_I_MSB = 0

I_LSB = $CC
I_MSB = $CD
J_LSB = $CE
J_MSB = $CF
BEST_LSB = $D0
BEST_MSB = $D1
 
      org $6800                ; Start of code - compiler directive, not 6502.

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialisation       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
            
          pla                ; Arg count
          pla                ; msb of start address
          sta I_MSB
          pla                ; lsb of start address
          sta I_LSB
          pla                ; msb of Last entry
          sta END_I_M + 1    ; Store in end_i_loop
          sta END_J_M + 1    ; and end_j_loop
          pla                ; lsb of last entry
          sta END_I_L + 1    ; Store in end_i_loop
          clc
          adc #8
          sta END_J_L + 1    ; and + 8 for end j_loop - but w want
          bcc I_LOOP
          INC END_J_M + 1

    
    
I_LOOP                   ; We want: for i=address to last-address - 2
          ldy #0
          lda (I_LSB),y
          sta COMP_3 + 1  ; Set the four bytes to compare to
          iny
          lda (I_LSB),y
          sta COMP_2 + 1
          iny
          lda (I_LSB),y
          sta COMP_1 + 1
          iny
          lda (I_LSB),y
          sta COMP_0 + 1
          lda I_MSB         ; j = i + 8
          sta J_MSB
          sta BEST_MSB
          lda I_LSB
          sta BEST_LSB
          clc
          adc #8
          sta J_LSB
          bcc J_LOOP
          inc J_MSB
          
J_LOOP   
          ldy #0
          lda (J_LSB),y
COMP_3    cmp #DIGIT_3     ; After this, carry is set if DIGIT_3>=A
          bcc BETTER       ; otherwise, clear if DIGIT_3<A
          bne END_J_LOOP   ; And if not equal, it must be greater (worse)
          iny
          lda (J_LSB),y
COMP_2    cmp #DIGIT_2
          bcc BETTER       ; Repeat for other 3 digits.
          bne END_J_LOOP
          iny
          lda (J_LSB),y
COMP_1    cmp #DIGIT_1
          bcc BETTER
          bne END_J_LOOP
          iny
          lda (J_LSB),y
COMP_0    cmp #DIGIT_0
          bcc BETTER
          bne END_J_LOOP
          
BETTER
          ldy #0
          lda (J_LSB),y
          sta COMP_3 + 1
          iny
          lda (J_LSB),y           ; Replace the four digits 
          sta COMP_2 + 1          ; to compare, with this new
          iny                     ; favourite value
          lda (J_LSB),y
          sta COMP_1 + 1
          iny
          lda (J_LSB),y
          sta COMP_0 + 1
          lda J_LSB              ; And remember index where it 
          sta BEST_LSB           ; came from.
          lda J_MSB
          sta BEST_MSB
                 
END_J_LOOP
          lda 20            ; Do some pretty colours while we wait.
          adc 54283         ; (which also lets us know we haven't hung)
          sta 53274
          lda J_LSB            ; j=j+8
          clc
          adc #8
          sta J_LSB
          bcc END_J_L
          inc J_MSB

END_J_L   cmp #END_J_LSB
          bne J_LOOP
          lda J_MSB         
END_J_M   cmp #END_J_MSB     ; if j<>$6798, then goto J_LOOP
          bne J_LOOP         ; (where $6798 is first "out-of-bounds")

END_I_LOOP
          lda BEST_LSB       ;  J loop is done. 
          cmp I_LSB          ;  Was the best the first entry anyway?
          bne SWAP           ;  No. 
          lda BEST_MSB
          cmp I_MSB
          beq CONTINUE       ; Or actually,yes.
SWAP
          ldy #0
SWAP_LOOP lda (I_LSB),Y      ; Swap 8 bytes, between the memory at i,
          tax                ; and the memory at best.
          lda (BEST_LSB),Y
          sta (I_LSB),Y
          txa
          sta (BEST_LSB),Y
          iny
          cpy #8
          bne SWAP_LOOP
           
CONTINUE
          clc
          lda I_LSB           ; i+=8
          adc #8
          sta I_LSB
          bcc END_I_L
          inc I_MSB   

END_I_L   cmp #END_I_LSB
          beq RETURN1         ; if i<>$6790 then goto I_LOOP
          jmp I_LOOP
RETURN1   lda I_MSB           ; (where $6790 is the last bit of data)
END_I_M   cmp #END_I_MSB      ; (hence only one left - must be sorted)
          beq RETURN2
          jmp I_LOOP
RETURN2   rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Now to solve part a.

PART_NO = $CB
RESULT_3 = $CE
RESULT_2 = $CF
RESULT_1 = $D0
RESULT_0 = $D1

          pla                ; Arg count
          pla                ; msb of start address
          sta I_MSB
          pla                ; lsb of start address
          sta I_LSB
          clc                ; Going to assume this loop 
          lda #0             ; always terminates... 
          sta FREE_3A + 1    ; Set for first comparison.
          sta FREE_2A + 1
          sta FREE_1A + 1
          sta FREE_0A + 1
          sta FREE_3B + 1    ; Set for first comparison.
          sta FREE_2B + 1
          sta FREE_1B + 1
          sta FREE_0B + 1
          sta RESULT_3
          sta RESULT_2
          sta RESULT_1
          sta RESULT_0
          pla                ; Argument set to 1 for part (b)
          pla
          sta PART_NO           
PA_I_CHECK

          ldy #0
          lda (I_LSB),y      ; if FREE < the first number of the pair
FREE_3A   cmp #DIGIT_3       ; we have an answer
          beq NEXT_3A
          bcc PA_NEXT_I
          bcs PA_ANSWER
NEXT_3A   iny
          lda (I_LSB),y
FREE_2A   cmp #DIGIT_2
          beq NEXT_2A
          bcc PA_NEXT_I          
          bcs PA_ANSWER
NEXT_2A   iny
          lda (I_LSB),y
FREE_1A   cmp #DIGIT_1
          beq NEXT_1A
          bcc PA_NEXT_I          
          bcs PA_ANSWER
NEXT_1A   iny
          lda (I_LSB),y
FREE_0A   cmp #DIGIT_0
          beq PA_NEXT_I
          bcc PA_NEXT_I

PA_ANSWER
          lda PART_NO          ;; For part 1, store the answer, and exit...
          beq PART_ONE
          jmp PB_ANSWER
PART_ONE          
          lda FREE_3A+1       ; We've found the answer.
          sta RESULT_3        ; Copy from the code about into
          lda FREE_2A+1       ; CE,CF,D0,D1 and return.
          sta RESULT_2
          lda FREE_1A+1
          sta RESULT_1
          lda FREE_0A+1       ; See lower for part 2 handling of an answer.
          sta RESULT_0
          rts

PA_NEXT_I                   ; Otherwise, (we didn't find an answer)what's the next free val?
          ldy #4
          lda (I_LSB),Y    ; If the num in 4-7 is bigger than FREE
                           ; then.... 
FREE_3B   cmp #DIGIT_3
          beq NEXT_3
          bcs FREE_IS_SMALLER
          bcc FREE_IS_BIGGER
NEXT_3    iny
          lda (I_LSB),Y
FREE_2B   cmp #DIGIT_2
          beq NEXT_2
          bcs FREE_IS_SMALLER
          bcc FREE_IS_BIGGER
NEXT_2    iny
          lda (I_LSB),Y
FREE_1B   cmp #DIGIT_1
          beq NEXT_1
          bcs FREE_IS_SMALLER
          bcc FREE_IS_BIGGER
NEXT_1    iny
          lda (I_LSB),Y
FREE_0B   cmp #DIGIT_0
          beq FREE_IS_SMALLER
          bcc FREE_IS_BIGGER

FREE_IS_SMALLER 
          ldy #7
          lda (I_LSB),Y         
          sta FREE_0A+1             ; If we reach here, our best so far was smaller 
          dey                       ; so set best to the right-hand number...
          lda (I_LSB),Y
          sta FREE_1A+1
          dey
          lda (I_LSB),Y
          sta FREE_2A+1
          dey
          lda (I_LSB),Y
          sta FREE_3A+1
          clc
          inc FREE_0A + 1             ; And increase it by 1
          bne NO_CARRY_FREE
          inc FREE_1A + 1
          bne NO_CARRY_FREE
          inc FREE_2A + 1
          bne NO_CARRY_FREE
          inc FREE_3A + 1
          bne NO_CARRY_FREE       ; Else free wrapped from FFFFFFFF to 0
          rts
NO_CARRY_FREE          
          lda FREE_0A + 1
          sta FREE_0B + 1
          lda FREE_1A + 1
          sta FREE_1B + 1
          lda FREE_2A + 1
          sta FREE_2B + 1
          lda FREE_3A + 1
          sta FREE_3B + 1

FREE_IS_BIGGER                   ; (If free was already bigger, leave FREE alone.)          
          lda I_LSB
          clc
          adc #8
          sta I_LSB              ; i = i + 8
          bcc PA_NO_CARRY_I
          inc I_MSB
PA_NO_CARRY_I

          jmp PA_I_CHECK
          
PB_ANSWER                     ; PART B...
          ldy #3
          lda (I_LSB),y
          sec                 ; Calculate NEXT_BLOCKED_VAL - CURRENT_FREE_VAL
          sbc FREE_0A+1
          sta 1539
          dey
         
          lda (I_LSB),y
          sbc FREE_1A+1
          sta 1538
          dey
          
          lda (I_LSB),y
          sbc FREE_2A+1
          sta 1537
          dey
          
          lda (I_LSB),y
          sbc FREE_3A+1
          sta 1536
          
          clc               ; And add the result to the counter
          lda RESULT_0
          adc 1539
          sta RESULT_0
          lda RESULT_1
          adc 1538
          sta RESULT_1
          lda RESULT_2
          adc 1537
          sta RESULT_2
          lda RESULT_3
          adc 1536
          sta RESULT_3

          jmp FREE_IS_SMALLER   ; Not the end - so next free possibility is
                                ; right-hand-number plus one.
