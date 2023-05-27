global color, keychar, keyflag
extern print_integer, read_integer, _sum, _sub, _mul, _div, verify_for_op_symbol, display_gui, mouse_input

segment code
..start:
    ; Initializing the routine
    MOV     ax,data 
	MOV     ds,ax
	MOV     ax,stack 
	MOV     ss,ax
	MOV     sp,stacktop

    ; Back up the current graphical mode
    MOV  	AH,0Fh
    INT  	10h
    MOV  	[last_graphical_mode],AL

    ; 640x480 16 colors mode
    MOV     AL,12h
    MOV     AH,0
    INT     10h

    ; Defining the keyboard interruption
    CALL replace_int9

    ; Initializing the mouse
    MOV     AX,00h
    INT     33h

    ; Show the mouse cursor
    MOV     AX,01h
    INT     33h

    ; Displaying the Graphical User Interface
    CALL    display_gui

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

    ; Defining if value2 is negative and setting the 2-complement
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
    JNE     finish_graphical_mode

finish_routine:
    ; Printing the result
    MOV     DX,[op_result]
    MOV     CX,num_buffer
    CALL    print_2_complement

    ; Wait for click to confirm closing
    CALL    mouse_input

finish_graphical_mode:
    ; Finishing the graphical mode
    MOV     AH,0
    MOV     AL,[last_graphical_mode]
    INT     10h

quit_program:
    CALL retrieve_dos_int9

    ; Finishing the routine
    MOV     AX,4c00h
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

replace_int9:
    CLI
    XOR     AX,AX
    MOV     ES,AX
    MOV     AX,[ES:int9*4]
    MOV     [offset_dos],AX
    MOV     AX,[ES:int9*4+2]
    MOV     [cs_dos],AX
    MOV     WORD[ES:int9*4+2],CS
    MOV     AX,seg key_int
    rol     AX,4
    MOV     DX,CS
    rol     DX,4
    SUB     AX,DX
    ADD     AX,key_int
    MOV     WORD[ES:int9*4],AX
    STI
    RET

retrieve_dos_int9:
	CLI
	XOR     AX,AX
	MOV     ES,AX
	MOV     AX,[offset_dos]
	MOV     [ES:int9*4],AX 
	MOV     AX,[cs_dos]
	MOV     [ES:int9*4+2],AX
	STI
    RET

key_int:
    ; Saving context
	PUSH    AX
    PUSH    BX
    PUSH    DS

	MOV     AX,seg cs_dos
	MOV     DS,AX

    ; Defining that the keyflag is being read
    MOV     byte[keyflag],1

    ; Getting key make/break code
	IN      AL,kb_data
    CMP     AL,0E0h ; Ignoring 0E0h
    JNE     key_is_captured
	IN      AL,kb_data ; If 0E0h was captured, capture the next input from buffer

key_is_captured:
    ; Updating the value of p_i
	INC     word [p_i]
	AND     word [p_i],7
	MOV     BX,[p_i]

    ; Saving the captured key value
	MOV     [BX+key],AL
	IN      AL,kb_ctl
	OR      AL,80h
	OUT     kb_ctl,AL
	AND     AL,7fh
	OUT     kb_ctl,AL

    ; Defining flag

    defining_keychar:
    check_0_keypress:
    CMP     byte[BX+key],0Bh
    JNE     check_1_keypress
    MOV     byte[keychar],'0'
    JMP     finish_key_checking

    check_1_keypress:
    CMP     byte[BX+key],02h
    JNE     check_2_keypress
    MOV     byte[keychar],'1'
    JMP     finish_key_checking

    check_2_keypress:
    CMP     byte[BX+key],03h
    JNE     check_3_keypress
    MOV     byte[keychar],'2'
    JMP     finish_key_checking

    check_3_keypress:
    CMP     byte[BX+key],04h
    JNE     check_4_keypress
    MOV     byte[keychar],'3'
    JMP     finish_key_checking

    check_4_keypress:
    CMP     byte[BX+key],05h
    JNE     check_5_keypress
    MOV     byte[keychar],'4'
    JMP     finish_key_checking

    check_5_keypress:
    CMP     byte[BX+key],06h
    JNE     check_6_keypress
    MOV     byte[keychar],'5'
    JMP     finish_key_checking

    check_6_keypress:
    CMP     byte[BX+key],07h
    JNE     check_7_keypress
    MOV     byte[keychar],'6'
    JMP     finish_key_checking

    check_7_keypress:
    CMP     byte[BX+key],08h
    JNE     check_8_keypress
    MOV     byte[keychar],'7'
    JMP     finish_key_checking

    check_8_keypress:
    CMP     byte[BX+key],09h
    JNE     check_9_keypress
    MOV     byte[keychar],'8'
    JMP     finish_key_checking

    check_9_keypress:
    CMP     byte[BX+key],0Ah
    JNE     check_plus_keypress
    MOV     byte[keychar],'9'
    JMP     finish_key_checking

    check_plus_keypress:
    CMP     byte[BX+key],0Dh
    JNE     check_minus_keypress
    MOV     byte[keychar],'+'
    JMP     finish_key_checking

    check_minus_keypress:
    CMP     byte[BX+key],0Ch
    JNE     check_times_keypress
    MOV     byte[keychar],'-'
    JMP     finish_key_checking

    check_times_keypress:
    CMP     byte[BX+key],2Dh
    JNE     check_div_keypress
    MOV     byte[keychar],'*'
    JMP     finish_key_checking

    check_div_keypress:
    CMP     byte[BX+key],35h
    JNE     else_keypress
    MOV     byte[keychar],'/'
    JMP     finish_key_checking

    else_keypress:
    MOV     byte[keyflag],0

    finish_key_checking:
    ; Informing End-of-Interruption to the system
	MOV 	AL,eoi
	OUT     pictrl,AL
	
    ; Retrieving context
    POP     DS
    POP     BX
    POP     AX
    
    IRET

segment data
    CR                      equ  0dh 
    LF                      equ  0ah
    value1                  dw   0
    value2                  dw   0
    op_symbol               dw   0
    op_result               dw   0
    last_graphical_mode     db   0
    color                   db   15 ; Intense white
    cs_dos                  dw   1
    offset_dos              dw   1
    key                     resb 8 ; Key array
    keychar                 db   0
    p_i                     dw   0 ; Key pointer index
    p_t                     dw   0
    kb_data                 equ  60h
    kb_ctl                  equ  61h
    pictrl                  equ  20h
    eoi                     equ  20h
    int9                    equ  9h
    keyflag                 db   0
    num_buffer:             resb 5
                            db CR,LF,'$'
                

segment stack stack 
	resb 512
    stacktop: