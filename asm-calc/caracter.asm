;
;Funcao caracter escrito na posicao do cursor
;
; AL= caracter a ser escrito
; color definida na variavel color
global caracter
extern color
caracter:

;Salvando o contexto, empilhando registradores
		PUSHF
		PUSH 	AX
		PUSH 	BX
		PUSH	CX
		PUSH	DX
		PUSH	SI
		PUSH	DI
		PUSH	BP
;Preparando para chamar a int 10h	        	
    	MOV     AH,9        ;INT 10h/AH = 09h - write character and attribute at cursor position.
    	MOV     BH,0        ;BH = page number. 
    	MOV     BL,[color]    ;BL = attribute.
    	MOV     CX,1        ;CX = number of times to write character.
   		INT     10h
;Recupera-se o contexto			
		POP		BP
		POP		DI
		POP		SI
		POP		DX
		POP		CX
		POP		BX
		POP		AX
		POPF
		RET