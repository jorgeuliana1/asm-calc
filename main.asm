extern print_integer, read_integer, _sum, _sub, _mul, _div, verify_for_op_symbol

segment code
..start:
    ; Initializing the routine
    MOV     ax,data 
	MOV     ds,ax
	MOV     ax,stack 
	MOV     ss,ax
	MOV     sp,stacktop

    ; Getting value1 from keyboard
    MOV     DI,value1
    CALL    read_integer

    ; Defining if value1 is negative and setting the 2-complement    
    MOV     BX,[DI]
    AND     BH,80h
    CMP     BH,80h
    JE      if_v1_is_negative

    if_v1_doesnt_need_treatment:

    ; Getting op_symbol from keyboard
    MOV     DI,op_symbol
    CALL    verify_for_op_symbol

    ; Getting value2 from keyboard
    MOV     DI,value2
    CALL    read_integer

    ; ; Defining if value2 is negative and setting the 2-complement
    MOV     BX,[DI]
    AND     BH,80h
    CMP     BH,80h
    JE      if_v2_is_negative

    if_v2_doesnt_need_treatment:
    
    ; Setting everything up for the operation
    MOV     AX,[value1]
    MOV     BX,[value2]
    MOV     DI,op_result

    ; Deciding the operation to be performed
    MOV     CX,[op_symbol]
    CMP     CX,'+'
    JE      call_sum
    CMP     CX,'-'
    JE      call_sub
    CMP     CX,'*'
    JE      call_mul
    CMP     CX,'/'
    JE      call_div
    JNE     quit_program

finish_routine:
    ; Printing the result
    MOV     DX,[op_result]
    MOV     CX,num_buffer
    CALL    print_2_complement

quit_program:
    ; Finishing the routine
    MOV     ah,4ch
	INT     21h

if_v1_is_negative:
    ; Converting to 2-complement
    MOV     DI,value1
    MOV     BX,[DI]
    AND     BH,0111b ; Removing most significant bit
    NEG     BX
    MOV     [DI],BX
    JMP     if_v1_doesnt_need_treatment

if_v2_is_negative:
    ; Converting to 2-complement
    MOV     DI,value2
    MOV     BX,[DI]
    AND     BH,0111b ; Removing most significant bit
    NEG     BX
    MOV     [DI],BX
    JMP     if_v2_doesnt_need_treatment

print_2_complement:
    MOV     AH,DH
    AND     AH,07h
    CMP     AH,DH
    JE      print_normally
    NEG     DX

    PUSH    DX
    ; Printing '-'
    MOV     DL,2Dh
    MOV     AH,02h
    INT     21h
    ; End of printing
    POP     DX
    print_normally:
    CALL print_integer
    RET

call_sum:
    CALL    _sum
    JMP     finish_routine

call_sub:
    CALL    _sub
    JMP     finish_routine

call_mul:
    CALL    _mul
    JMP     finish_routine

call_div:
    CALL    _div
    JMP     finish_routine

segment data
    CR             equ  0dh 
    LF             equ  0ah
    value1         dw   0
    value2         dw   0
    op_symbol      dw   0
    op_result      dw   0
    num_value      dw   0
    num_buffer:    resb 5
                   db CR,LF,'$'
                

segment stack stack 
	resb 512
    stacktop: