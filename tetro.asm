putT:
        PUSH DE
        ld e, (IX)
        CALL drawTetro
        POP DE
        RET
    
clearT:
        PUSH DE
        ld e, 0
        CALL drawTetro ; draws a tetro with color black essencially  deleting it
        POP DE
        RET

checkPlace:
        push BC
        push DE
        push IX ; push everything
        push IY
        push HL
        ld a, (Xposition)
        ld c, A
        ld a, (Yposition)
        ld b, A
        ld HL, xcoord ; tracks start of X coordinate
        ld (HL), c ; load initial x coordinate in variable

        ld IY, IX ; IY used to navigate the block data

        ld HL, counterX
        ld a, (IX + (offsetBX)) ; sets X counter
        ld (HL), a

        ld HL, counterY
        ld a, (IX + (offsetBY)) ; sets Y counter
        ld (HL), a

blockLoopCol:
        ;Check the block data
        ld a, (IY + (offsetData))
        cp 1 ; gets the data from the tetromino and checks with 1 to see if it has to draw or not

        jr nz, blackCol: ; if not it will skip assigning the color

        CALL GetPixel
        or A
        jr nz, collision
blackCol:
        INC IY ; iy address points to next position of tetromino data
        inc c ; next c coordinate

        ; Check if end of X line
        ld HL, counterX 
        dec (HL) ; decreases X counter until 0
        jr nz, blockLoopCol ; End of X loop

endOfXloopCol:

        ld HL, counterX ; RESET X counter
        ld a, (IX + (offsetBX))
        ld (HL), a

        ld a, (xcoord) ; reset x coordinates
        ld c, a
        inc B ; Next y coordinate

        ld HL, counterY ; decrease Y counter
        dec (HL)
        jr nz, blockLoopCol ; ends loop if the Y counter hits 0

        ld a, 0
collision:
        pop HL
        pop IY
        pop IX ; pops everything back
        pop DE
        pop BC
        RET


drawTetro:
        push BC
        push DE
        push IX ; push everything
        push IY
        push HL
        ld a, (Xposition)
        ld c, A
        ld a, (Yposition)
        ld b, A
        ld HL, xcoord ; tracks start of X coordinate
        ld (HL), c ; load initial x coordinate in variable

        ld IY, IX ; IY used to navigate the block data

        ld HL, counterX
        ld a, (IX + (offsetBX)) ; sets X counter
        ld (HL), a

        ld HL, counterY
        ld a, (IX + (offsetBY)) ; sets Y counter
        ld (HL), a

blockLoop:
        ;Check the block data
        ld a, (IY + (offsetData))
        cp 1 ; gets the data from the tetromino and checks with 1 to see if it has to draw or not

        jr nz, black: ; if not it will skip assigning the color

        ld a, e ; gets color and draws the dot
        CALL DOTXYC
black:
        INC IY ; iy address points to next position of tetromino data
        inc c ; next c coordinate

        ; Check if end of X line
        ld HL, counterX 
        dec (HL) ; decreases X counter until 0
        jr nz, blockLoop ; End of X loop

endOfXloop:

        ld HL, counterX ; RESET X counter
        ld a, (IX + (offsetBX))
        ld (HL), a

        ld a, (xcoord) ; reset x coordinates
        ld c, a
        inc B ; Next y coordinate

        ld HL, counterY ; decrease Y counter
        dec (HL)
        jr nz, blockLoop ; ends loop if the Y counter hits 0

        pop HL
        pop IY
        pop IX ; pops everything back
        pop DE
        pop BC
        RET