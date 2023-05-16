global read_integer, verify_for_op_symbol

read_integer:
    MOV     DX,0000h
    PUSH    DX
read_integer1:
    ; Reading the char
    MOV     ah,1h
    INT     21h

    ; Verifying for ending of reading
    CMP     AL,'='
    JE      read_integer_return

    ; Verifying for operation symbol
    CMP     AL,'+'
    JE      read_integer_return
    CMP     AL,'-'
    JE      if_minus_signal
    CMP     AL,'*'
    JE      read_integer_return
    CMP     AL,'/'
    JE      read_integer_return
    CMP     AL,'0'
    JE      if_is_zero
    keep_going:

    ; ASCII to INT conversion
    SUB     al,30h
    MOV     cl,al

    PUSH    AX
    MOV     ax,[di]
    MOV     bx,10
    MUL     bx
    MOV     [di],ax
    POP     AX

    ADD     [di],cl
    JMP     read_integer1
read_integer_return:
    POP     DX
    ADD     [DI],DX
    CMP     DH,00h
    JE      skip_pop
    
    POP     CX
    skip_pop:
    RET

if_negative_num:
    MOV     DX,8000h
    PUSH    DX
    JMP     read_integer1

if_minus_signal:
    MOV     DX,[DI]
    CMP     DX,0
    JE      if_negative_num
    JNE     read_integer_return

if_is_zero:
    MOV     DX,[DI]
    CMP     DX,0
    JNE     keep_going
    ADD     DX,8000h
    MOV     [DI],DX
    JMP     read_integer1


verify_for_op_symbol:
    ; AL must contain the operator to be evaluated
    ; DI must contain the address to destination variable
    CMP     AL,'+'
    JE      if_operation_symbol
    CMP     AL,'-'
    JE      if_operation_symbol
    CMP     AL,'*'
    JE      if_operation_symbol
    CMP     AL,'/'
    JE      if_operation_symbol
end_verification:
    RET

if_operation_symbol:
    MOV     AH,00h
    MOV     [DI],AL
    JMP     end_verification