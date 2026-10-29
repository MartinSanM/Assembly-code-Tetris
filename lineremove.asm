; FUNCTION TO COPY 1 POSITION DOWN
copyline:
        push AF
        push BC
        ld e, b
        ld d, b ; copy line loops through every pixel on two lines copying the one above to the one bellow
        dec d
        ld c, 11 ; stores the Y coordinate in e and d and increases the d to make it one line above
nextcopy:
        ld b, D
        CALL GetPixel ; by loading the d or e values into b acordingly we can easily cover both lines copying each pixel with every iteration
        ld b, e
        CALL DOTXYCopy
        inc C
        ld a, C
        cp 21 ; the program will stop when the x coordinate reaches the board
        jr nz, nextcopy
        pop BC
        pop AF
        ret

; FUNCTION TO CHECK IF LINE HAS TO BE ERASED
checkLine:
        push BC
        ld b, a
        ld c, 11
nextpixel:
        CALL GetPixel ; checks every pixel in the line untill one of them is black or it covers the entire line
        or A
        jr z, retCheckLine ; if a black pixel is found the function exits since  the line does not have to be cleared returning a as 0
        inc C
        ld a, C
        cp 21
        jr nz, nextpixel
        ld a, 1 ; if the whole line is checked and no black pixel is found the line has to be cleared and the a is returned as 1
retCheckLine:
        pop BC
        ret

; FUNCTION TO CLEAR LINE
clearLine:
        push AF
        push BC
        ld b, a
        ld c, 11 ; function covers line pixel by pixel from left to right
nextpixelCl:
        CALL GetPixel ; it reads the pixel and turns almost every bit to 1
        add a
        or %10111101
        CALL DOTXYCopy ; by doing this we paint the line a bright blue and white that is shown to the user before the line is removed
        inc C
        ld a, C
        cp 21
        jr nz, nextpixelCl
        pop BC
        pop AF
        ret

pause:
        PUSH BC
        PUSH DE
        PUSH HL ; pause function puts the program in an infinite loops to pause for a second
        ld HL, 0
        ld DE, 0
        ld BC, 40000
        ldir
        pop HL
        pop DE
        pop BC
        RET
