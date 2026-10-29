chooseNext:
        PUSH IX
        CALL Random
        add a
        ld d, 0
        ld E, a ; picks random next piece
        ld HL, TETRISBLOCKS
        add HL, DE
        ld IY, HL
        ld HL, (IY) ; chooses the next piece the game will play
        ld IX, HL
        CALL putT
        ld (nextpiece), IX
        POP IX
        ret
drawnext:
        push BC
        ld B, 5
        ld C, 25
        ld HL, Xposition ; sets coordinates to draw the next piece
        ld (HL), C
        ld HL, Yposition
        ld (HL), B
        pop BC
        ret

setcoords:
        push BC
        ld B, 0
        ld C, 14 ; sets coordinates to draw the current piece in the startin position
        ld HL, Xposition
        ld (HL), C
        ld HL, Yposition
        ld (HL), B
        pop BC
        ret

Random: ; Javier Chocano
        ld a, r ; r is the “Refresh Register” for DRAM
        and 7 ; Keep only the three less significant bits
        cp 7 ; Make sure the result is not 7 (we want 0..6)
        jr z, Random ; Read r again if we got a 7
        ret ; Return from function