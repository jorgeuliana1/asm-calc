global display_gui
extern color, line, cursor, caracter

display_gui:
    ; Saving context
    PUSHF
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    PUSH    SI
    PUSH    DI
    PUSH    BP

    ; Drawing the horizontal line 1/4
    MOV     BX,15
    MOV     [color],BX ; Intense white
    MOV     AX,0 ; x1
    PUSH    AX
    MOV     AX,96 ; y1
    PUSH    AX
    MOV     AX,640 ; x2
    PUSH    AX
    MOV     AX,96 ; y2
    PUSH    AX
    CALL    line

    ; Drawing the horizontal line 2/4
    MOV     BX,15
    MOV     [color],BX ; Intense white
    MOV     AX,0 ; x1
    PUSH    AX
    MOV     AX,192 ; y1
    PUSH    AX
    MOV     AX,640 ; x2
    PUSH    AX
    MOV     AX,192 ; y2
    PUSH    AX
    CALL    line

    ; Drawing the horizontal line 3/4
    MOV     BX,15
    MOV     [color],BX ; Intense white
    MOV     AX,0 ; x1
    PUSH    AX
    MOV     AX,288 ; y1
    PUSH    AX
    MOV     AX,640 ; x2
    PUSH    AX
    MOV     AX,288 ; y2
    PUSH    AX
    CALL    line

    ; Drawing the horizontal line 4/4
    MOV     BX,15
    MOV     [color],BX ; Intense white
    MOV     AX,0 ; x1
    PUSH    AX
    MOV     AX,384 ; y1
    PUSH    AX
    MOV     AX,640 ; x2
    PUSH    AX
    MOV     AX,384 ; y2
    PUSH    AX
    CALL    line

    ; Drawing the vertical line 1/3
    MOV     BX,15
    MOV     [color],BX ; Intense white
    MOV     AX,160 ; x1
    PUSH    AX
    MOV     AX,0 ; y1
    PUSH    AX
    MOV     AX,160 ; x2
    PUSH    AX
    MOV     AX,384 ; y2
    PUSH    AX
    CALL    line

    ; Drawing the vertical line 2/3
    MOV     BX,15
    MOV     [color],BX ; Intense white
    MOV     AX,320 ; x1
    PUSH    AX
    MOV     AX,0 ; y1
    PUSH    AX
    MOV     AX,320 ; x2
    PUSH    AX
    MOV     AX,384 ; y2
    PUSH    AX
    CALL    line

    ; Drawing the vertical line 3/3
    MOV     BX,15
    MOV     [color],BX ; Intense white
    MOV     AX,480 ; x1
    PUSH    AX
    MOV     AX,0 ; y1
    PUSH    AX
    MOV     AX,480 ; x2
    PUSH    AX
    MOV     AX,384 ; y2
    PUSH    AX
    CALL    line

    JMP draw_chars
    after_drawing_chars:

    ; Retrieving context
    POP     BP
    POP     DI
    POP     SI
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    POPF
    RET

draw_chars:

    ; Drawing char 7
    MOV     DH,9    ; Cursor row
    MOV     DL,9    ; Cursor column
    CALL    cursor
    MOV     AL,37h ; Char '7'
    CALL    caracter

    ; Drawing char 8
    MOV     DH,9    ; Cursor row
    MOV     DL,29   ; Cursor column
    CALL    cursor
    MOV     AL,38h ; Char '8'
    CALL    caracter

    ; Drawing char 9
    MOV     DH,9    ; Cursor row
    MOV     DL,49   ; Cursor column
    CALL    cursor
    MOV     AL,39h ; Char '9'
    CALL    caracter

    ; Drawing char /
    MOV     DH,9    ; Cursor row
    MOV     DL,69   ; Cursor column
    CALL    cursor
    MOV     AL,2fh ; Char '/'
    CALL    caracter

    ; Drawing char 4
    MOV     DH,15   ; Cursor row
    MOV     DL,9    ; Cursor column
    CALL    cursor
    MOV     AL,34h ; Char '4'
    CALL    caracter

    ; Drawing char 5
    MOV     DH,15   ; Cursor row
    MOV     DL,29   ; Cursor column
    CALL    cursor
    MOV     AL,35h ; Char '5'
    CALL    caracter

    ; Drawing char 6
    MOV     DH,15   ; Cursor row
    MOV     DL,49   ; Cursor column
    CALL    cursor
    MOV     AL,36h ; Char '6'
    CALL    caracter

    ; Drawing char x
    MOV     DH,15   ; Cursor row
    MOV     DL,69   ; Cursor column
    CALL    cursor
    MOV     AL,78h ; Char 'x'
    CALL    caracter

    ; Drawing char 1
    MOV     DH,21   ; Cursor row
    MOV     DL,9    ; Cursor column
    CALL    cursor
    MOV     AL,31h ; Char '1'
    CALL    caracter

    ; Drawing char 2
    MOV     DH,21   ; Cursor row
    MOV     DL,29   ; Cursor column
    CALL    cursor
    MOV     AL,32h ; Char '2'
    CALL    caracter

    ; Drawing char 3
    MOV     DH,21   ; Cursor row
    MOV     DL,49   ; Cursor column
    CALL    cursor
    MOV     AL,33h ; Char '3'
    CALL    caracter

    ; Drawing char -
    MOV     DH,21   ; Cursor row
    MOV     DL,69   ; Cursor column
    CALL    cursor
    MOV     AL,2dh ; Char '-'
    CALL    caracter

    ; Drawing char 0
    MOV     DH,27   ; Cursor row
    MOV     DL,29   ; Cursor column
    CALL    cursor
    MOV     AL,30h ; Char '0'
    CALL    caracter

    ; Drawing char +
    MOV     DH,27   ; Cursor row
    MOV     DL,69   ; Cursor column
    CALL    cursor
    MOV     AL,2bh ; Char '+'
    CALL    caracter

    ; Moving to final cursor position
    MOV     DH,3    ; Cursor row
    MOV     DL,55   ; Cursor column
    CALL    cursor

    JMP after_drawing_chars