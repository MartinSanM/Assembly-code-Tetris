; -----------------------------------------------------------------------------
; TETROMINO DATA DEFINITIONS & CONSTANTS
; -----------------------------------------------------------------------------

offsetBY:       EQU 1
offsetBX:       EQU 2
ptrOffsetRL:    EQU 3
ptrOffsetRR:    EQU 5
offsetData:     EQU 7

TETRISBLOCKS:
        DW blockO, blockL, blockZ, blockS, blockI_H, blockJ, blockT

; O-Block (Yellow - 6)
blockO:
        DB 6, 2, 2
        DW blockO, blockO
        DB 1, 1
        DB 1, 1

; I-Block (Bright Cyan - 13)
blockI_H:
        DB 13, 1, 4
        DW blockI_V, blockI_V
        DB 1, 1, 1, 1

blockI_V:
        DB 13, 4, 1
        DW blockI_H, blockI_H
        DB 1
        DB 1
        DB 1
        DB 1

; Z-Block (Bright Red - 10)
blockZ:
        DB 10, 2, 3
        DW blockZ_V, blockZ_V
        DB 1, 1, 0
        DB 0, 1, 1

blockZ_V:
        DB 10, 3, 2
        DW blockZ, blockZ
        DB 0, 1
        DB 1, 1
        DB 1, 0

; S-Block (Green - 4)
blockS:
        DB 4, 2, 3
        DW blockS_V, blockS_V
        DB 0, 1, 1
        DB 1, 1, 0

blockS_V:
        DB 4, 3, 2
        DW blockS, blockS
        DB 1, 0
        DB 1, 1
        DB 0, 1

; L-Block (Red - 2)
blockL:
        DB 2, 2, 3
        DW blockL_270, blockL_90
        DB 0, 0, 1
        DB 1, 1, 1

blockL_90:
        DB 2, 3, 2
        DW blockL, blockL_180
        DB 1, 0
        DB 1, 0
        DB 1, 1

blockL_180:
        DB 2, 2, 3
        DW blockL_90, blockL_270
        DB 1, 1, 1
        DB 1, 0, 0

blockL_270:
        DB 2, 3, 2
        DW blockL_180, blockL
        DB 1, 1
        DB 0, 1
        DB 0, 1

; J-Block (Bright Blue - 9)
blockJ:
        DB 9, 2, 3
        DW blockJ_270, blockJ_90
        DB 1, 0, 0
        DB 1, 1, 1

blockJ_90:
        DB 9, 3, 2
        DW blockJ, blockJ_180
        DB 1, 1
        DB 1, 0
        DB 1, 0

blockJ_180:
        DB 9, 2, 3
        DW blockJ_90, blockJ_270
        DB 1, 1, 1
        DB 0, 0, 1

blockJ_270:
        DB 9, 3, 2
        DW blockJ_180, blockJ
        DB 0, 1
        DB 0, 1
        DB 1, 1

; T-Block (Magenta - 3)
blockT:
        DB 3, 2, 3
        DW blockT_270, blockT_90
        DB 0, 1, 0
        DB 1, 1, 1

blockT_90:
        DB 3, 3, 2
        DW blockT, blockT_180
        DB 1, 0
        DB 1, 1
        DB 1, 0

blockT_180:
        DB 3, 2, 3
        DW blockT_90, blockT_270
        DB 1, 1, 1
        DB 0, 1, 0

blockT_270:
        DB 3, 3, 2
        DW blockT_180, blockT
        DB 0, 1
        DB 1, 1
        DB 0, 1
