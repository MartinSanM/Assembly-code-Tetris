; --------------------------------
; UNDO LAST MOVE ON COLLISION
; --------------------------------
reverse:
        push AF
        ld a, (lastmove)
        cp 1
        jr z, undoW
        cp 2
        jr z, undoA
        cp 3
        jr z, undoS
        cp 4
        jr z, undoD
        cp 5
        jr z, undo5
        jr endUndo
undoW:
        ld HL, (IX + (ptrOffsetRR))
        ld IX, HL
        jr endUndo
undoA:
        ld a, (Xposition)
        inc A
        ld (Xposition), A
        jr endUndo
undoS:
        ld a, (Yposition)
        dec A
        ld (Yposition), A
        jr endUndo
undoD:
        ld a, (Xposition)
        dec A
        ld (Xposition), A
        jr endUndo
undo5:
        ld a, (Yposition)
        dec A
        ld (Yposition), A
endUndo:
        pop AF
        ret
