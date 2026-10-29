; --------------------------------
; DRAW TETRO BOARD
; --------------------------------

drawBoard:
        push BC
        push AF
        push DE
        ld b, 0
        ld c, 10
        CALL Yline ; draws a board by drawing 2 lines at x coordinates 10 and 21
        ld c, 21
        CALL Yline
        ld b, 23
        ld c, 10 ; sets y coordinate to 23 and x to 10 to start the bottom line of the board
        ld d, 7 ; 7 is the gray color the board uses
Xlineloop:
        ld a, d ; loads gray color into a
        CALL DOTXYC ; draws the pixel
        inc C
        ld a, c ; increases the x coordinate to next value and checks if the line is finished
        sub 22
        jr nz, Xlineloop
        pop DE
        pop AF
        pop BC
        ret

Yline:
        push BC
        ld d, 7 ; Y line function draws a gray line from the most top point of the screen to the lowest
Ylineloop:
        ld a, d
        CALL DOTXYC
        inc b
        ld a, B
        sub 24
        jr nz, Ylineloop
        pop BC
        ret

drawBox:
        PUSH BC
        PUSH AF
        ld e, 7
        ld b, 7 ; draws a box by making 2 x lines and 2 y lines
        ld d, 23
drawBoxLoop:
        PUSH BC
        ld C, d
        ld b, 3
        ld a, e
        CALL DOTXYC
        ld b, 8
        ld a, e
        CALL DOTXYC
        inc d
        POP BC
        djnz drawBoxLoop
        ld b, 6
        ld d, 3
drawBoxLoop2:
        PUSH BC
        LD B, D
        ld c, 23
        ld a, e
        CALL DOTXYC
        ld c, 29
        ld a, e
        CALL DOTXYC
        INC d
        POP BC
        djnz drawBoxLoop2
        POP AF
        POP BC
        RET 