DOTXYCopy:
        push BC
        push AF
	    push DE
        push HL
        CALL mult ; multiplies Y coord by 32
        ld HL, 0x5800 ;first pixel address
        add HL, DE ; adds DE which contains the y coords
        ld b, 0
        add HL, BC ; adds BC containing our x coords
        ld (HL), a ; paints the dot
        pop HL
	    pop DE
        pop AF
        pop BC ; returns values changed to the original
        RET


DOTXYC:
        push BC
        push AF
	    push DE
        push HL
        CALL mult ; multiplies Y coord by 32
        ld HL, 0x5800 ;first pixel address
        add HL, DE ; adds DE which contains the y coords
        ld b, 0
        add HL, BC ; adds BC containing our x coords
        CALL calculateColor
        ld (HL), a ; paints the dot
        pop HL
	    pop DE
        pop AF
        pop BC ; returns values changed to the original
        RET
calculateColor:
        push BC
        ld b, 3 ; simple loop adds a to itself 3 times essencially multiplying by 2 cubed or 8
colorloop:
        add a, a
        DJNZ colorloop
        pop BC
        RET

GetPixel:
        push BC
        push HL
	push DE
        CALL mult ; multiplies Y coord by 32
        ld HL, 0x5800 ;first pixel address
        add HL, DE ; adds DE which contains the y coords
        ld b, 0
        add HL, BC ; adds BC containing our x coords
        ld a, (HL) ; stores value in a
	pop DE
        pop HL
        pop BC ; returns values changed to the original
        RET
        
mult: 
        push BC
        push HL ; multiplies B by 32
        ld H, 0
        ld L, B ; we need to use a 2 byte register to avoid overwriting our value
        ld B, 5 ; adds B to itself 5 times doing b times 2 to the power of 5 or 32
mult32:
        add HL, HL
        DJNZ mult32 
        ld DE, HL ; stores value in DE register since we need to registers to store a number this big
        pop HL
        pop BC
        RET