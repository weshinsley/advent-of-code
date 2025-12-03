; Advent of Code 2016, Day 18, Atari asm (6502)

      TEN_COUNTER equ 203      ; Do iterations in batches of 10.
      TOTAL equ 207            ; LSB of the total. 206,205,204 are the increasing 3 bytes.
      TRAP_CH       equ '^'    ; ASCII #96
      SAFE_CH       equ '.'    ; ASCII #46

      ITER_LOOP_MSB equ 1      ; These are really placeholders of the right size
      ITER_LOOP_LSB equ 1      ; to make sure the compiler uses the right opcode
      STR_LEN       equ 100    ; (single-byte for zero-page <256, or
      STR_LEN_M1    equ 99     ; LSB MSB for addresses above 255)
      STR_IN        equ 1536   ; But actual values will come from the initialisation
      STR_IN_P1     equ 1537
      STR_IN_P2     equ 1538
      STR_OUT       equ 1638
      STR_OUT_P1    equ 1639
      ZERO_FLAG     equ 1

      org $6000                ; Start of code - compiler directive, not 6502.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialisation - Sort out params ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      pla                     ; Get arg count
      pla                     ; MSB of input string
      sta first_loop + 2
      sta init_str + 2        ; Overwrite MSB in all the places we read data.
      sta digit1 + 2
      sta digit2 + 2
      sta copy_to + 2
      pla                     ; LSB of input string
      tax                     ; Use X, (because we can INX and DEX)
      stx init_str + 1        ; Put LSB-1 as initial "first digit"
      stx copy_to + 1
      stx first_loop + 1
      inx
      stx digit1 + 1          ; LSB is initial "second digit"
      inx
      stx digit2 + 1          ; LSB+1 is initial "third digit"
      pla                     ; Skip MSB
      pla                     ; size (including padding)
      sta copy_back + 1
      tax
      dex
      stx non_safe + 2        ; For very-first case, counting safe.
      dex
      stx end_inner_loop + 1  ; Put length-2 as the end condition for inner loop.
      pla                     ; MSB of buffer
      sta assign_status + 2   ; Overwrite in the place where we write
      sta copy_from + 2
      pla                     ; LSB of buffer
      sta copy_from + 1
      tax
      inx
      stx assign_status + 1   ; Overwrite [x+1] first.
      pla                     ; MSB of steps/10
      sta step_loop_msb + 1
      pla                     ; LSB of steps/10
      sta step_loop_lsb + 1

      lda #0                  ; Initialise 207,206,205,204 = 0
      sta TOTAL               ; These will be the 32-bit counter.
      sta TOTAL - 1
      sta TOTAL - 2
      sta TOTAL - 3

      lda #1
      sta very_first + 1      ; And set the "very first time" flag for first row.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Outer iteration loop                                                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

step_loop_lsb    ldx #ITER_LOOP_LSB
                 dex                     ; iters_LSB--
                 stx step_loop_lsb + 1
                 cpx #255                ;   if (iters_LSB!=255)    ie - no wrap
                 bne cont_main_loop      ;     do the next part
step_loop_msb    ldx #ITER_LOOP_MSB      ;   else
                 dex                     ;     iters_MSB--
                 stx step_loop_msb + 1
                 cpx #255                ;     if (iters_MSB!=255)   no wrap
                 bne cont_main_loop      ;     do the next part
                 rts                     ;     else exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Batch of 10 iterations loop                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



cont_main_loop   lda #10                 ; ten_counter = 10 (Hence, 400000 = 10 * 40000 so can use 16-bit)
                 sta TEN_COUNTER         ; Store in 204 - spare bytes in page zero.

ten_loop         ldx TEN_COUNTER
                 dex                     ; ten_counter --
                 stx TEN_COUNTER
                 cpx #255                ; if (ten_counter == 255)  - ie, wrap
                 beq step_loop_lsb       ;   go to outer_loop

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Very first time - score initial row                                                  ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


very_first       lda #ZERO_FLAG          ; Very first case - this only happens once
                 cmp #1                  ; if zero_flag != 1
                 bne non_zero            ;   carry on with the normal stuff.
                 lda #0
                 sta very_first + 1      ; else zero_flag = 0 - and this never happens again,
                 ldx #1                  ; X = 1
first_loop       lda STR_IN, X           ; do {
                 cmp #SAFE_CH            ;   TOTAL += (str[X] == SAFE)
                 bne non_safe
                 inc TOTAL
non_safe         inx                     ;   X++
                 cpx #STR_LEN_M1
                 bne first_loop          ; } while (X != len-1)
                 jmp ten_loop            ; this counts as first interation. Go to ten loop.

non_zero                                 ; For all other not-very-first cases:
                 ldx #0                  ; X = 0 (Examine [0,1,2] and calculate new value for [1]

                                         ; Calculate row score. First few lines are only needed for X=0

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Calculate new string from old                                                        ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Start-up for first two characters                                                ;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                 ldy #0                  ; Y = 0
init_str         lda STR_IN              ; A = str[0]
                 cmp #TRAP_CH
                 bne digit1              ; if A == safe
                 iny                     ;   y+=4
                 iny                     ;   then y = y + 4   (quicker than TAY, CLC, ADC #4, TYA)
                 iny
                 iny
digit1           lda STR_IN_P1           ; A = str[1]
                 cmp #TRAP_CH            ;
                 bne digit2              ; if A == safe
                 iny                     ;   y+=2
                 iny                     ;

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Third character - and all subsequent characters                                  ;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

digit2           lda STR_IN_P2, X        ; A = str[2+x] - we'll jump back to this point for later digits
                 cmp #TRAP_CH            ;
                 bne digit3              ; if A == safe
                 iny                     ;   y++

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Decide what new character at X+1 should be                                       ;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

digit3           cpy #6                  ; "Trap values" are ^^. .^^ ^.. ..^ = 6, 3, 4, 1
                 beq set_trap
                 cpy #4
                 beq set_trap            ; if A %in% (6,4,3,1) then IT'S A TRAP!!
                 cpy #3
                 beq set_trap
                 cpy #1
                 beq set_trap
                 lda #SAFE_CH            ; Else, it's SAFE. A = SAFE_CHAR
                 inc TOTAL
                 bne assign_status       ; TOTAL++  (where total is "32-bit")
                 inc TOTAL - 1           ; check wraps for the LSB, LSB-1 and LSB-2
                 bne assign_status
                 inc TOTAL - 2
                 bne assign_status
                 inc TOTAL - 3
                 jmp assign_status       ; skip over the "IT'S A TRAP BIT"

set_trap         lda #TRAP_CH            ; (If it is a TRAP, A = TRAP_CHAR)

assign_status    sta STR_OUT_P1,X        ; new_str[X+1] = A
                 inx                     ; X++
end_inner_loop   cpx #STR_LEN_M1         ; if X == len-1
                 beq done_string         ;   We've done the loop
                 tya                     ; else
                 and #3                  ; y = (y & binary 00000011) shl 1
                 asl                     ; (ie, chop off left-most bit, and shift left)
                 tay                     ;
                 jmp digit2              ; Now consider the next single digit.


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Copy new string to "old"                                                             ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



done_string
                 ldx #0                ; For X = 1 to STR_LEN-1 inclusive
copy_loop        inx
copy_back        cpx #STR_LEN
                 bne copy_from         ; (it's too far away to beq ten_loop)
                 jmp ten_loop
copy_from        lda STR_OUT,X         ;   str[X] = new_Str[X]
copy_to          sta STR_IN,X
                 jmp copy_loop         ; Next X
                                       ; and then goto ten_loop
                                       