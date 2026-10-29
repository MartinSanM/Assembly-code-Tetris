keyaction:
        push AF
        ld a, (pressKey) ; checks which key has been pressed to know what action to perform
        cp 1
        jr z, waction
        cp 2
        jr z, aaction
        cp 3
        jr z, saction
        cp 4
        jr z, daction ; before each action the tetro is cleared since it will not clear the right coordinates if we do it after
        jr noaction
waction:
        CALL clearT ; if the W key is pressed the tetro pointer is set to the same piece rotated to the left
        ld HL, (IX + (ptrOffsetRL))
        ld IX, HL
        jr noaction
aaction:
        CALL clearT
        ld a, (Xposition) ; if the A key has been pressed the X coordinate of the tetro decreases to move left
        dec A
        ld (Xposition), A
        jr noaction
saction:
        CALL clearT
        ld a, (Yposition) ; the S key sends the tetro block straight down by increasing the Y coordinate value and trying to draw the tetro on each iteration untill the tetro cant be drawn
        inc A
        ld (Yposition), A
        CALL checkPlace
        or A
        jr z, saction
        jr noaction
daction:
        CALL clearT
        ld a, (Xposition); the D key is the same as the A however it increases the X coordinate to move right
        inc A
        ld (Xposition), A     
noaction:
        ld a, (pressKey) ; if no key has been pressed and no action needs to be done the program does not do anything
        ld (lastmove), a
        ld a, 0
        ld (pressKey), a ; at the end of every action the program saves the last move in the memory address labeled "lastmove"
        pop AF
        ret

pressKey: db 0

readKeys: ;This is a switch case depending on which key has been pressed.
        call fourkey ;Calls to check the routine so that we can compare the D register with a and act accordingly.
        ld a, 0
        cp d ;If the D register contains 0, then it will keep waiting until you press one key.
        jr z, leave
        inc a
        cp d ;If the D register contains 1, it will now jump to the Wleave and wait until you stop pressing the key.
        jr z, Wleave
        inc a
        cp d ;If the D register contains 2, it will now jump to the Aleave and wait until you stop pressing the key.
        jr z, Aleave
        inc a
        cp d ;If the D register contains 3, it will now jump to the Sleave and wait until you stop pressing the key.
        jr z, Sleave
        inc a
        cp d ;If the D register contains 4, it will now jump to the Dleave and wait until you stop pressing the key.
        jr z, Dleave
        jr readKeys

Wleave: ;Once the user stops pressing the key, it will finally print the desired pixel with its colour.
        ld a, 1
        ld (pressKey), a
        call wkey
        jr z, Wleave
        ret
Aleave: ;Once the user stops pressing the key, it will finally print the desired pixel with its colour.
        ld a, 2
        ld (pressKey), a
        call akey
        jr z, Aleave
        ret
Sleave: ;Once the user stops pressing the key, it will finally print the desired pixel with its colour.
        ld a, 3
        ld (pressKey), a
        call skey
        jr z, Sleave
        ret
Dleave: ;Once the user stops pressing the key, it will finally print the desired pixel with its colour.
        ld a, 4
        ld (pressKey), a
        call dkey
        jr z, Dleave
        ret
leave:
        ret

;-------------------------------------------------------------------------------------------------
fourkey:
        call wkey ;If the key W has been pressed, it stores the value 1 in the D register.
        ld d, 1
        jr z, return ;If it has indeed been pressed, it directly jumps to the end of the routine.
        call akey ;If the key A has been pressed, it stores the value 2 in the D register.
        ld d, 2
        jr z, return ;If it has indeed been pressed, it directly jumps to the end of the routine.
        call skey ;If the key S has been pressed, it stores the value 3 in the D register.
        ld d, 3
        jr z, return ;If it has indeed been pressed, it directly jumps to the end of the routine.
        call dkey ;If the key D has been pressed, it stores the value 4 in the D register.
        ld d, 4
        jr z, return ;If it has indeed been pressed, it directly jumps to the end of the routine.
        ld d, 0 ;If none of these keys have been pressed, then it will store the 0 in the D register.

return:
        ret
wkey:
        ld bc, $FBFE ;Detects the W key.
        in a, (c)
        bit 1, a
        ret
akey:
        ld bc, $FDFE ;Detects the A key.
        in a, (c)
        bit 0, a
        ret
skey:
        ld bc, $FDFE ;Detects the S key.
        in a, (c)
        bit 1, a
        ret
dkey:
        ld bc, $FDFE ;Detects the D key.
        in a, (c)
        bit 2, a
        ret