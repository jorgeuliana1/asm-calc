global print_integer

print_integer:
    ; Read the value stored in DX as a decimal and prints it, CX must point to a buffer
    ; Arguments:
    ;   CX: Point to a buffer
    ;   DX: Integer to be printed
    PUSHF
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
            
    MOV     DI,CX
    CALL    bin2ascii

    MOV     DX,CX
    MOV     AH,9h
    INT     21h
    
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    POPF
    RET

bin2ascii:
    CMP     DX,10
    JB      unity
    CMP     DX,100 
    JB      tens
    CMP     DX,1000
    JB      hundreds
    CMP     DX,10000
    JB      thousands
    JMP     tens_thousands
         
unity:     
    ADD     DX,0x0030
    MOV     byte [DI],DL
    RET
tens:
    MOV     AX,DX
    MOV     BL,10
    div     BL
    ADD     AH,0x30
    ADD     AL,0x30
    MOV     byte [DI],AL
    MOV     byte [DI+1],AH
    RET
hundreds:    
    MOV     AX,DX
    MOV     BL,100
    DIV     BL
    ADD     AL,0x30
    MOV     byte [DI],AL
    MOV     AL,AH
    AND     AX,0x00FF
    MOV     BL,10
    DIV     BL
    ADD     AH,0x30
    ADD     AL,0x30
    MOV     byte [DI+1],AL    
    MOV     byte [DI+2],AH
    RET
thousands:    
    MOV     AX,DX
    MOV     DX,0
    MOV     BX,1000
    DIV     BX
    ADD     AL,0x30
    MOV     byte [DI],AL
    MOV     AX,DX
    MOV     BL,100
    DIV     BL
    ADD     AL,0x30
    MOV     byte [DI+1],AL    
    MOV     AL,AH
    AND     AX,0x00FF
    MOV     BL,10
    DIV     BL
    ADD     AH,0x30
    ADD     AL,0x30
    MOV     byte [DI+2],AL    
    MOV     byte [DI+3],AH
    RET
tens_thousands:
    MOV     AX,DX
    MOV     DX,0
    MOV     BX,10000
    DIV     BX
    ADD     AL,0x30
    MOV     byte [DI],AL
    MOV     AX,DX    
    MOV     DX,0
    MOV     BX,1000
    DIV     BX
    ADD     AL,0x30
    MOV     byte [DI+1],AL
    MOV     AX,DX
    MOV     BL,100
    DIV     BL
    ADD     AL,0x30
    MOV     byte [DI+2],AL    
    MOV     AL,AH
    AND     AX,0x00FF
    MOV     BL,10
    DIV     BL
    ADD     AH,0x30
    ADD     AL,0x30
    MOV     byte [DI+3],AL    
    MOV     byte [DI+4],AH
    RET    