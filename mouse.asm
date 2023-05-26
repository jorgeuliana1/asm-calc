global mouse_input

mouse_input:
    ; After this execution is finished the clicked char will be returned on AL
    ; Saving context
    PUSHF
    PUSH    BX
    PUSH    CX
    PUSH    DX

mouse_status:
    ; Getting mouse status
    MOV     AX,03h
    INT     33h

    ; The registers status now:
    ; BX: button status
    ; CX: Y coordinate
    ; DX: X coordinate 

    ; Testing for left button down
    TEST    BL,1
    JNZ     left_down
    JMP     mouse_status

left_down:
    ; Getting new mouse status
    MOV     AX,03h
    INT     33h

    ; Testing for left button up
    TEST    BL,1
    JNZ     left_down

finish_mouse_call:
    ; Recovering context
    POP     DX
    POP     CX
    POP     BX
    POPF

    RET

; The following set of labels define the region to be clicked
; and the corresponding input
test_for_1:
test_for_2:
test_for_3:
test_for_4:
test_for_5:
test_for_6:
test_for_7:
test_for_8:
test_for_9:
test_for_0:
test_for_plus:
test_for_minus:
test_for_times:
test_for_div:

; The folloring set of labels define the return of the call
is_1:
    MOV     AL,'1'
    JMP     finish_mouse_call
is_2:
    MOV     AL,'2'
    JMP     finish_mouse_call
is_3:
    MOV     AL,'3'
    JMP     finish_mouse_call
is_4:
    MOV     AL,'4'
    JMP     finish_mouse_call
is_5:
    MOV     AL,'5'
    JMP     finish_mouse_call
is_6:
    MOV     AL,'6'
    JMP     finish_mouse_call
is_7:
    MOV     AL,'7'
    JMP     finish_mouse_call
is_8:
    MOV     AL,'8'
    JMP     finish_mouse_call
is_9:
    MOV     AL,'9'
    JMP     finish_mouse_call
is_0:
    MOV     AL,'0'
    JMP     finish_mouse_call
is_plus:
    MOV     AL,'+'
    JMP     finish_mouse_call
is_minus:
    MOV     AL,'-'
    JMP     finish_mouse_call
is_times:
    MOV     AL,'*'
    JMP     finish_mouse_call
is_div:
    MOV     AL,'/'
    JMP     finish_mouse_call