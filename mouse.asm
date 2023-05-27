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
    JMP     test_for_1 ; If the key is pressed, search for location

finish_mouse_call:
    ; Printing input
    PUSH    AX
    MOV     DL,AL
    MOV     AH,02h
    INT     21h
    POP     AX

    ; Recovering context
    POP     DX
    POP     CX
    POP     BX
    POPF

    RET

; The following set of labels define the region to be clicked
; and the corresponding input
test_for_1:
    CMP     CX,160
    JG      test_for_2
    CMP     DX,384
    JG      test_for_2
    CMP     DX,288
    JG      is_1 ; if CX < 160 && 240 < DX < 320
    JMP     test_for_2

is_1:
    MOV     AL,'1'
    JMP     finish_mouse_call

test_for_2:
    CMP     CX,320
    JG      test_for_3
    CMP     CX,160
    JL      test_for_3
    CMP     DX,384
    JG      test_for_3
    CMP     DX,288
    JG      is_2 ; if CX < 160 && 240 < DX < 320
    JMP     test_for_3

is_2:
    MOV     AL,'2'
    JMP     finish_mouse_call

test_for_3:
    CMP     CX,480
    JG      test_for_4
    CMP     CX,320
    JL      test_for_4
    CMP     DX,384
    JG      test_for_4
    CMP     DX,288
    JG      is_3 ; if CX < 160 && 240 < DX < 320
    JMP     test_for_4

is_3:
    MOV     AL,'3'
    JMP     finish_mouse_call

test_for_4:
    CMP     CX,160
    JG      test_for_5
    CMP     DX,288
    JG      test_for_5
    CMP     DX,192
    JG      is_4 ; if CX < 384 && 96 < DX < 192
    JMP     test_for_5

is_4:
    MOV     AL,'4'
    JMP     finish_mouse_call

test_for_5:
    CMP     CX,320
    JG      test_for_6
    CMP     CX,160
    JL      test_for_6
    CMP     DX,288
    JG      test_for_6
    CMP     DX,192
    JG      is_5 ; if CX < 160 && 240 < DX < 320
    JMP     test_for_6

is_5:
    MOV     AL,'5'
    JMP     finish_mouse_call

test_for_6:
    CMP     CX,480
    JG      test_for_7
    CMP     CX,320
    JL      test_for_7
    CMP     DX,288
    JG      test_for_7
    CMP     DX,192
    JG      is_6 ; if CX < 160 && 240 < DX < 320
    JMP     test_for_7

is_6:
    MOV     AL,'6'
    JMP     finish_mouse_call

test_for_7:
    CMP     CX,160
    JG      test_for_8
    CMP     DX,192
    JG      test_for_8
    CMP     DX,96
    JG      is_7 ; if CX < 384 && 96 < DX < 192
    JMP     test_for_8

is_7:
    MOV     AL,'7'
    JMP     finish_mouse_call

test_for_8:
    CMP     CX,320
    JG      test_for_9
    CMP     CX,160
    JL      test_for_9
    CMP     DX,192
    JG      test_for_9
    CMP     DX,96
    JG      is_8 ; if CX < 160 && 240 < DX < 320
    JMP     test_for_9

is_8:
    MOV     AL,'8'
    JMP     finish_mouse_call

test_for_9:
    CMP     CX,480
    JG      test_for_0
    CMP     CX,320
    JL      test_for_0
    CMP     DX,192
    JG      test_for_0
    CMP     DX,96
    JG      is_9 ; if CX < 160 && 240 < DX < 320
    JMP     test_for_0

is_9:
    MOV     AL,'9'
    JMP     finish_mouse_call

test_for_0:
    CMP     CX,320
    JG      test_for_plus
    CMP     CX,160
    JL      test_for_plus
    CMP     DX,480
    JG      test_for_plus
    CMP     DX,384
    JG      is_0 ; if CX < 160 && 240 < DX < 320
    JMP     test_for_plus

is_0:
    MOV     AL,'0'
    JMP     finish_mouse_call

test_for_plus:
    CMP     CX,640
    JG      test_for_minus
    CMP     CX,480
    JL      test_for_minus
    CMP     DX,480
    JG      test_for_minus
    CMP     DX,384
    JG      is_plus ; if CX < 160 && 240 < DX < 320
    JMP     test_for_minus

is_plus:
    MOV     AL,'+'
    JMP     finish_mouse_call

test_for_minus:
    CMP     CX,640
    JG      test_for_times
    CMP     CX,480
    JL      test_for_times
    CMP     DX,384
    JG      test_for_times
    CMP     DX,288
    JG      is_minus ; if CX < 160 && 240 < DX < 320
    JMP     test_for_times

is_minus:
    MOV     AL,'-'
    JMP     finish_mouse_call

test_for_times:
    CMP     CX,640
    JG      test_for_div
    CMP     CX,480
    JL      test_for_div
    CMP     DX,288
    JG      test_for_div
    CMP     DX,192
    JG      is_times ; if CX < 160 && 240 < DX < 320
    JMP     test_for_div

is_times:
    MOV     AL,'*'
    JMP     finish_mouse_call

test_for_div:
    CMP     CX,640
    JG      is_equal
    CMP     CX,480
    JL      is_equal
    CMP     DX,192
    JG      is_equal
    CMP     DX,96
    JG      is_div ; if CX < 160 && 240 < DX < 320
    JMP     is_equal

is_div:
    MOV     AL,'/'
    JMP     finish_mouse_call

is_equal:
    MOV     AL,'='
    JMP     finish_mouse_call