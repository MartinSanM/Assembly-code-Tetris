fall:
        push BC
        push DE
        push IX
        push HL
        CALL clearT
        ld a, (Yposition) ; fall function clears piece and tries to place it one pixel down
        inc A
        ld (Yposition), a
        CALL checkPlace
        pop HL
        pop IX
        pop DE ; we do not pop AF or push AF since we need the a value to be returned since it is 0 if we cant place the piece
        pop BC
        RET