        DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
        org $8000               ; Program is located from memory address $8000 = 32768
begin:          di              ; Disable Interrupts
                ld sp,0         ; Set stack pointer to top of ram (RAMTOP)


;-------------------------------------------------------------------------------------------------
; Student Code
main:

        CALL hrBKG ; makes the pieces have high resolution textures
        CALL drawBoard
        CALL drawBox ; draws the main board and the box to the right where the next piece is displayed
        CALL setcoords

        CALL Random ; picks random number from 0-7
        add a ; multiply number by 2 since each tetro pointer is a word (16-bit)
        ld d, 0 
        ld E, a ; store value in DE
        ld HL, TETRISBLOCKS
        add HL, DE ; adds value to initial tetrisblocks pointer this is where the next tetro is stored
        ld IY, HL
        ld HL, (IY) ; saves the value in a memory location "nextpiece"
        ld (nextpiece), HL

pieceloop:
        CALL setcoords ; set game coordinates to the top middle of the board
        ld IX, (nextpiece) ; stores next piece address in IX register
        CALL checkPlace ; checks if the initial possition is empty
        or A
        jp nz, gameover ; if the top middle position is full and the tetro block cant be drawn the game is over and the player has lost
        CALL putT ; if not the tetro is drawn
nextpiecedraw:
        CALL drawnext ; sets coords to draw next piece
        CALL clearT ;clears next piece slot
        CALL chooseNext ; picks the next piece to at random
        CALL setcoords ; sets the coordinates back to the startin playing position
lineloop:
        ld HL, 2000
        ld (downcounter), HL ; a decresing counter is used to make the piece fall
loop1:
        CALL putT ; the piece is drawn to start
        ld a, (downcounter)
        dec a ; counter is decreased and saved
        ld (downcounter), a 
        jr z, nextline ; if the counter has reached 0 the program will make the piece fall to the next line bellow
        CALL readKeys
        CALL keyaction ; if not the program will check for key presses and performs action if needed changing the tetros coordinates or rotating it
        CALL checkPlace ; the program then checks if the new tetro can be placed
        or A
        jr z, loop1
        CALL reverse ; if the tetro cant be placed it makes the last move backwards since this will result in the previous position
        jr loop1
nextline:
        CALL fall ; makes piece fall and checks for collision
        or a
        jr z, lineloop ; if there is no collision the program loops back to where the counter is set
        ld a, (Yposition)
        dec a ; if there is a collision the tetro is placed in its previous position
        ld (Yposition), a
        CALL putT
        ld b, (IX + offsetBY) ; size of Y piece
        inc b
        ld d, 0 ; sets a to the most bottom line the game needs to check
checknext:
        ld a, (Yposition)
        add b
        sub 2 ; check if the line has to be cleared
        CALL checkLine ; returns 1 if needs to clear the line
        or A
        jr z, keepline ; skips next part if line is not complete (does not have to clear line)
        ld a, (Yposition)
        add B
        sub 2
        PUSH BC ; if the line has to be cleared it sets the coordinates to clear the line and paints it a bright blue and white
        ld b, a 
        CALL clearLine
        inc d
        POP BC
keepline:
        djnz checknext ; loops back untill every line on the board is checked
        PUSH AF
        ld a, D ; checks if any line has to be cleared
        or A
        jr z, noLine
        POP AF

        CALL pause ; pauses the game to let the player see the completed lines

fallingLines:
        ld b, (IX + offsetBY) ; size of Y piece
        inc b
        ld d, 0
fallingLinesLoop:
        ld a, (Yposition) ; block of code is same as one above to check which lines it has to remove
        add b
        sub 2
        CALL checkLine ; returns 1 if needs to clear the line
        or A
        jr z, keepline2 ; skips next part if line is not complete
        ld a, (Yposition)
        add B
        sub 2
        PUSH BC
        ld b, a
fallAll:
        CALL copyline ; removes the line by copying every line above to the one bellow it and increases b since each line is one pixel lower than previously
        djnz fallAll
        POP BC
        inc b
keepline2:
        djnz fallingLinesLoop
noLine:
        jp pieceloop ; jump back to playing next tetromino

gameover:
        ld a, 2
        out ($fe), a ; if the player loses the border is set to red and the program finishes
        jr endofcode

;---------------------------------------------------------------------------------------------------
endofcode:      jr endofcode    ; Infinite loop

 INCLUDE "highResBackground.asm"


nextpiece: DW 0
 INCLUDE "keyboard.asm" ; keyboard inputs
 INCLUDE "board.asm" ; draws the tetro board
 INCLUDE "nextpiece.asm" ; chooses next piece to place
 INCLUDE "singlepixel.asm" ; handles pixels (drawing removing and getting the color)
 INCLUDE "tetro.asm" ; handles tetros, drawing checking and clearing
 INCLUDE "lineremove.asm" ; handles the removal of a line when complete
Xposition: DB 0
Yposition: DB 0

xcoord: DB 0
counterY: DB 0
counterX: DB 0
 INCLUDE "fall.asm" ; handles the tetro falling
downcounter: DW 0
 INCLUDE "undo.asm" ; undo function for when we cant do a move
lastmove: DB 0

 INCLUDE "tetromino_blocks.asm"


