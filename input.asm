global read_integer, verify_for_op_symbol

read_integer:
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
    JE      read_integer_return
    CMP     AL,'*'
    JE      read_integer_return
    CMP     AL,'/'
    JE      read_integer_return

    ; ASCII to INT conversion
    SUB     al,30h
    MOV     cl,al
    
    MOV     ax,[di]
    MOV     bx,10
    MUL     bx
    MOV     [di],ax

    ADD     [di],cl
    JMP     read_integer

read_integer_return:
    RET

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