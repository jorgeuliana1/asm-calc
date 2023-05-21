; vers�o de 10/05/2007
; corrigido erro de arredondamento na rotina line.
; circle e full_circle disponibilizados por Jefferson Moro em 10/2009
;
segment code

;Inicializa os registradores
;org 100h
..start:
        MOV     AX,data
    	MOV 	DS,AX
    	MOV 	AX,stack
    	MOV 	SS,AX
    	MOV 	SP,stacktop

;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
        MOV  	AH,0Fh
    	INT  	10h
    	MOV  	[modo_anterior],AL   

;Alterar modo de video para grafico 640x480 16 cores
    	MOV     AL,12h
   		MOV     AH,0
    	INT     10h
		
;desenhar retas
        JMP		MSN
       
		MOV		[cor],branco_intenso	;linha
		MOV		AX,20                   ;x1
		PUSH	AX
		MOV		AX,400                  ;y1
		PUSH	AX
		MOV		AX,25                  ;x2
		PUSH	AX
		MOV		AX,400                  ;y2
		PUSH	AX
		CALL	line
		
		
		
		MOV		[cor],marrom			;antenas
		MOV		AX,130
		PUSH	AX
		MOV		AX,270
		PUSH	AX
		MOV		AX,100
		PUSH	AX
		MOV		AX,300
		PUSH	AX
		CALL	line
		
		MOV		AX,130
		PUSH	AX
		MOV		AX,130
		PUSH	AX
		MOV		AX,100
		PUSH	AX
		MOV		AX,100
		PUSH	AX
		CALL	line
		
;desenha circulos 
		MOV		[cor],azul	;cabeça
		MOV		AX,200		;x
		PUSH	AX
		MOV		AX,200		;y
		PUSH	AX
		MOV		AX,100		;r
		PUSH	AX
		CALL	circle

		MOV		[cor],verde	;corpo
		MOV		AX,450
		PUSH	AX
		MOV		AX,200
		PUSH	AX
		MOV		AX,190
		PUSH	AX
		CALL	circle
		
		MOV		AX,100	;circulos das antenas
		PUSH	AX
		MOV		AX,100
		PUSH	AX
		MOV		AX,10
		PUSH	AX
		CALL	circle
		
		MOV		AX,100
		PUSH	AX
		MOV		AX,300
		PUSH	AX
		MOV		AX,10
		PUSH	AX
		CALL	circle
		
		MOV		[cor],vermelho	;circulos vermelhos
		MOV		AX,500
		PUSH	AX
		MOV		AX,300
		PUSH	AX
		MOV		AX,50
		PUSH	AX
		CALL	full_circle
		
		MOV		AX,500
		PUSH	AX
		MOV		AX,100
		PUSH	AX
		MOV		AX,50
		PUSH	AX
		CALL	full_circle
		
		MOV		AX,350
		PUSH	AX
		MOV		AX,200
		PUSH	AX
		MOV		AX,50
		PUSH	AX
		CALL	full_circle
		
;escrever uma mensagem
MSN: 
		MOV 	CX,14			;número de caracteres
    	MOV    	BX,0			;
    	MOV    	DH,10			;linha 0-29
    	MOV     DL,10			;coluna 0-79
		MOV		[cor],branco_intenso
l4:
		CALL	cursor
		MOV     DI,DS
    	MOV     AL,ES:[DI*10H+BX+mens]
		
		CALL	caracter
    	INC		BX				;proximo caracter
		INC		DL				;avanca a coluna
		;INC		[cor]			;mudar a cor para a seguinte
    	LOOP    l4

		MOV    	AH,08h
		INT     21h
	    MOV  	AH,0   			; set video mode
	    MOV  	AL,[modo_anterior]   	; modo anterior
	    INT  	10h
		MOV     AX,4c00h
		INT     21h
		
		
;***************************************************************************
;
;Funcao cursor
;
; dh = linha (0-29) e  dl=coluna  (0-79)
cursor:
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
		MOV     AH,2        ;INT 10h/AH = 2 - set cursor position.
		MOV     BH,0        ;BH = page number (0..7).
                            ;DL = column.		
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
;_____________________________________________________________________________
;
;Funcao caracter escrito na posicao do cursor
;
; AL= caracter a ser escrito
; cor definida na variavel cor
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
    	MOV     BL,[cor]    ;BL = attribute.
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
;_____________________________________________________________________________
;
;Funcao plot_xy
;
; push x; push y; call plot_xy;  (x<639, y<479)
; cor definida na variavel cor
plot_xy:
		PUSH    BP
		MOV		BP,SP
;Salvando o contexto, empilhando registradores		
		PUSHF
		PUSH 	AX
		PUSH 	BX
		PUSH	CX
		PUSH	DX
		PUSH	SI
		PUSH	DI
;Preparando para chamar a int 10h	    
	    MOV     AH,0Ch      ;INT 10h/AH = 0Ch - change color for a single pixel.
	    MOV     AL,[cor]    ;AL = pixel color    
	    MOV     BH,0
	    MOV     DX,479
		SUB		DX,[BP+4]   ;DX = row
	    MOV     CX,[BP+6]   ;CX = column - Load in AX
	    INT     10h
;Recupera-se o contexto		
		POP     DI
		POP		SI
		POP		DX
		POP		CX
		POP		BX
		POP		AX
		POPF
		POP		BP
		RET		4			;Add 4 cause row and column were updated before to enter in the function
;_____________________________________________________________________________
;
;Funaoo circle
;push xc; push yc; push r; call circle;  (xc+r<639,yc+r<479)e(xc-r>0,yc-r>0)
;cor definida na variavel cor
circle:
	    PUSH 	BP
	    MOV	 	BP,SP
;Salvando o contexto, empilhando registradores		
	    PUSHF
		PUSH 	AX
		PUSH 	BX
		PUSH	CX
		PUSH	DX
		PUSH	SI
		PUSH	DI
			
	    mov		ax,[bp+8]    ; resgata xc
	    mov		bx,[bp+6]    ; resgata yc
	    mov		cx,[bp+4]    ; resgata r
	
	    mov 	DX,BX	
	    add		DX,CX       ;ponto extremo superior
	    push    ax			
	    push	dx
	    call plot_xy
	
	    mov		dx,bx
	    sub		dx,cx       ;ponto extremo inferior
	    push    ax			
	    push	dx
	    call plot_xy
	
	    mov 	dx,ax	
	    add		dx,cx       ;ponto extremo direita
	    push    dx			
	    push	bx
	    call plot_xy
	
	    mov		dx,ax
	    sub		dx,cx       ;ponto extremo esquerda
	    push    dx			
	    push	bx
	    call plot_xy
		
	    mov		di,cx
	    sub		di,1	 ;di=r-1
	    mov		dx,0  	;dx ser� a vari�vel x. cx � a variavel y
	
;aqui em cima a l�gica foi invertida, 1-r => r-1
;e as compara��es passaram a ser jl => jg, assim garante 
;valores positivos para d

stay:				;loop
	mov		si,di
	cmp		si,0
	jg		inf       ;caso d for menor que 0, seleciona pixel superior (n�o  salta)
	mov		si,dx		;o jl � importante porque trata-se de conta com sinal
	sal		si,1		;multiplica por doi (shift arithmetic left)
	add		si,3
	add		di,si     ;nesse ponto d=d+2*dx+3
	inc		dx		;incrementa dx
	jmp		plotar
inf:	
	mov		si,dx
	sub		si,cx  		;faz x - y (dx-cx), e salva em di 
	sal		si,1
	add		si,5
	add		di,si		;nesse ponto d=d+2*(dx-cx)+5
	inc		dx		;incrementa x (dx)
	dec		cx		;decrementa y (cx)
	
plotar:	
	mov		si,dx
	add		si,ax
	push    si			;coloca a abcisa x+xc na pilha
	mov		si,cx
	add		si,bx
	push    si			;coloca a ordenada y+yc na pilha
	call plot_xy		;toma conta do segundo octante
	mov		si,ax
	add		si,dx
	push    si			;coloca a abcisa xc+x na pilha
	mov		si,bx
	sub		si,cx
	push    si			;coloca a ordenada yc-y na pilha
	call plot_xy		;toma conta do s�timo octante
	mov		si,ax
	add		si,cx
	push    si			;coloca a abcisa xc+y na pilha
	mov		si,bx
	add		si,dx
	push    si			;coloca a ordenada yc+x na pilha
	call plot_xy		;toma conta do segundo octante
	mov		si,ax
	add		si,cx
	push    si			;coloca a abcisa xc+y na pilha
	mov		si,bx
	sub		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call plot_xy		;toma conta do oitavo octante
	mov		si,ax
	sub		si,dx
	push    si			;coloca a abcisa xc-x na pilha
	mov		si,bx
	add		si,cx
	push    si			;coloca a ordenada yc+y na pilha
	call plot_xy		;toma conta do terceiro octante
	mov		si,ax
	sub		si,dx
	push    si			;coloca a abcisa xc-x na pilha
	mov		si,bx
	sub		si,cx
	push    si			;coloca a ordenada yc-y na pilha
	call plot_xy		;toma conta do sexto octante
	mov		si,ax
	sub		si,cx
	push    si			;coloca a abcisa xc-y na pilha
	mov		si,bx
	sub		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call plot_xy		;toma conta do quinto octante
	mov		si,ax
	sub		si,cx
	push    si			;coloca a abcisa xc-y na pilha
	mov		si,bx
	add		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call plot_xy		;toma conta do quarto octante
	
	cmp		cx,dx
	jb		fim_circle  ;se cx (y) est� abaixo de dx (x), termina     
	jmp		stay		;se cx (y) est� acima de dx (x), continua no loop
	
	
fim_circle:
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	pop		bp
	ret		6
;-----------------------------------------------------------------------------
;    fun��o full_circle
;	 push xc; push yc; push r; call full_circle;  (xc+r<639,yc+r<479)e(xc-r>0,yc-r>0)
; cor definida na variavel cor					  
full_circle:
	push 	bp
	mov	 	bp,sp
	pushf                        ;coloca os flags na pilha
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di

	mov		ax,[bp+8]    ; resgata xc
	mov		bx,[bp+6]    ; resgata yc
	mov		cx,[bp+4]    ; resgata r
	
	mov		si,bx
	sub		si,cx
	push    ax			;coloca xc na pilha			
	push	si			;coloca yc-r na pilha
	mov		si,bx
	add		si,cx
	push	ax		;coloca xc na pilha
	push	si		;coloca yc+r na pilha
	call line
	
		
	mov		di,cx
	sub		di,1	 ;di=r-1
	mov		dx,0  	;dx ser� a vari�vel x. cx � a variavel y
	
;aqui em cima a l�gica foi invertida, 1-r => r-1
;e as compara��es passaram a ser jl => jg, assim garante 
;valores positivos para d

stay_full:				;loop
	mov		si,di
	cmp		si,0
	jg		inf_full       ;caso d for menor que 0, seleciona pixel superior (n�o  salta)
	mov		si,dx		;o jl � importante porque trata-se de conta com sinal
	sal		si,1		;multiplica por doi (shift arithmetic left)
	add		si,3
	add		di,si     ;nesse ponto d=d+2*dx+3
	inc		dx		;incrementa dx
	jmp		plotar_full
inf_full:	
	mov		si,dx
	sub		si,cx  		;faz x - y (dx-cx), e salva em di 
	sal		si,1
	add		si,5
	add		di,si		;nesse ponto d=d+2*(dx-cx)+5
	inc		dx		;incrementa x (dx)
	dec		cx		;decrementa y (cx)
	
plotar_full:	
	mov		si,ax
	add		si,cx
	push	si		;coloca a abcisa y+xc na pilha			
	mov		si,bx
	sub		si,dx
	push    si		;coloca a ordenada yc-x na pilha
	mov		si,ax
	add		si,cx
	push	si		;coloca a abcisa y+xc na pilha	
	mov		si,bx
	add		si,dx
	push    si		;coloca a ordenada yc+x na pilha	
	call 	line
	
	mov		si,ax
	add		si,dx
	push	si		;coloca a abcisa xc+x na pilha			
	mov		si,bx
	sub		si,cx
	push    si		;coloca a ordenada yc-y na pilha
	mov		si,ax
	add		si,dx
	push	si		;coloca a abcisa xc+x na pilha	
	mov		si,bx
	add		si,cx
	push    si		;coloca a ordenada yc+y na pilha	
	call	line
	
	mov		si,ax
	sub		si,dx
	push	si		;coloca a abcisa xc-x na pilha			
	mov		si,bx
	sub		si,cx
	push    si		;coloca a ordenada yc-y na pilha
	mov		si,ax
	sub		si,dx
	push	si		;coloca a abcisa xc-x na pilha	
	mov		si,bx
	add		si,cx
	push    si		;coloca a ordenada yc+y na pilha	
	call	line
	
	mov		si,ax
	sub		si,cx
	push	si		;coloca a abcisa xc-y na pilha			
	mov		si,bx
	sub		si,dx
	push    si		;coloca a ordenada yc-x na pilha
	mov		si,ax
	sub		si,cx
	push	si		;coloca a abcisa xc-y na pilha	
	mov		si,bx
	add		si,dx
	push    si		;coloca a ordenada yc+x na pilha	
	call	line
	
	cmp		cx,dx
	jb		fim_full_circle  ;se cx (y) est� abaixo de dx (x), termina     
	jmp		stay_full		;se cx (y) est� acima de dx (x), continua no loop
	
	
fim_full_circle:
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	pop		bp
	ret		6
;-----------------------------------------------------------------------------
;
;Funcao line
;
; push x1; push y1; push x2; push y2; call line;  (x<639, y<479)
line:
		PUSH 	BP
	    MOV	 	BP,SP
;Salvando o contexto, empilhando registradores		
	    PUSHF
		PUSH 	AX
		PUSH 	BX
		PUSH	CX
		PUSH	DX
		PUSH	SI
		PUSH	DI
;Resgata os valores das coordenadas	previamente definidas antes de chamar a funcao line
		MOV		ax,[bp+10]  ;x1
		MOV		bx,[bp+8]   ;y1 
		MOV		cx,[bp+6]   ;x2 
		MOV		dx,[bp+4]   ;y2
		
		CMP		AX,CX       ;Compare x1 with x2 
		JE		lineV       ;Jump to Vertical Line
		
		JB		line1       ;Jump if x1 < x2 
		
		XCHG	AX,CX       ;else, exchange x1 with x2,
		XCHG	BX,DX       ;and exchange y1 with y2,
		JMP		line1

;---------------- Vertical line ------------------------------
lineV:		                ;Deltax=0
		CMP		BX,DX       ;Compare y1 with y2                   |
		JB		lineVD      ;Jump if y1 < y2, down vertical line \|/ 
		XCHG	BX,DX       ;else, exchange y1 with y2, up vertical line /|\        
lineVD:	                    ;                                             |
		PUSH	AX          ;column
		PUSH	BX          ;row
		CALL 	plot_xy
		
		CMP		BX,DX       ;Compare y1 with y2
		JNE		IncLineV    ;if not equal, jump to increase pixel
		JMP		End_line    ;else jump fim_line
IncLineV:	
        INC		BX
		JMP		lineVD

;---------------- Horizotnal line ----------------------------
;Deltax <,=,>0
line1:
;Compare modulus Deltax & Deltay due to CX > AX -> x2 > x1
		PUSH	CX          ;Save x2 in stack
		SUB		CX,AX       ;CX = CX-AX -> x2 = x2-x1 -> Deltax
		MOV		[deltax],CX ;Save deltax
		POP		CX          ;CX = x2
		
		PUSH	DX          ;Save y2 in stack		
		SUB		DX,BX       ;DX = DX-BX -> y2 = y2-y1 -> Deltay \
		JA		line32      ;Jump if DX > BX -> y2 > y1          \|
		NEG		DX          ;else, invert DX                                   --

;y = -mx+b 
line32:		
		MOV		[deltay],DX ;Save deltay
		POP		DX          ;DX = y2

		PUSH	AX          ;Save x2 in stack
		MOV		AX,[deltax] ;Compare DeltaX with DeltaY
		CMP		AX,[deltay]
		POP		AX          ;AX = x2
		JB		line5       ;Jump if DeltaX < DeltaY

	; cx > ax e deltax>deltay
		push		cx
		sub		cx,ax
		mov		[deltax],cx
		pop		cx
		push		dx
		sub		dx,bx
		mov		[deltay],dx
		pop		dx

		mov		si,ax
line4:
		push		ax
		push		dx
		push		si
		sub		si,ax	;(x-x1)
		mov		ax,[deltay]
		imul		si
		mov		si,[deltax]		;arredondar
		shr		si,1
; se numerador (DX)>0 soma se <0 subtrai
		cmp		dx,0
		jl		ar1
		add		ax,si
		adc		dx,0
		jmp		arc1
ar1:		sub		ax,si
		sbb		dx,0
arc1:
		idiv    [deltax]
		add		ax,bx
		pop		si
		push		si
		push		ax
		call		plot_xy
		pop		dx
		pop		ax
		cmp		si,cx
		je		End_line
		inc		si
		jmp		line4
                                ;                         --
line5:	cmp		bx,dx           ;Compare y1 with y2       /|
		jb 		line7           ;Jump if y1 < y2 -> line /
		xchg		ax,cx       ;else 
		xchg		bx,dx
line7:                          
		push		cx
		sub		cx,ax
		mov		[deltax],cx
		pop		cx
		push		dx
		sub		dx,bx
		mov		[deltay],dx
		pop		dx



		mov		si,bx
line6:
		push		dx
		push		si
		push		ax
		sub		si,bx	;(y-y1)
		mov		ax,[deltax]
		imul		si          ;Signed multiply
		mov		si,[deltay]		;arredondar
		shr		si,1            ;Shift operand1 Right
		
; se numerador (DX)>0 soma se <0 subtrai
		cmp		dx,0
		jl		ar2
		add		ax,si
		adc		dx,0
		jmp		arc2
ar2:		sub		ax,si
		sbb		dx,0
arc2:
		idiv    [deltay]
		mov		di,ax
		pop		ax
		add		di,ax
		pop		si
		push		di
		push		si
		call		plot_xy
		pop		dx
		cmp		si,dx
		je		End_line
		inc		si
		jmp		line6

End_line:
		POP		DI
		POP		SI
		POP		DX
		POP		CX
		POP		BX
		POP		AX
		POPF
		POP		BP
		RET		8


;*******************************************************************
segment data

cor		db		branco_intenso

;	I R G B COR
;	0 0 0 0 preto
;	0 0 0 1 azul
;	0 0 1 0 verde
;	0 0 1 1 cyan
;	0 1 0 0 vermelho
;	0 1 0 1 magenta
;	0 1 1 0 marrom
;	0 1 1 1 branco
;	1 0 0 0 cinza
;	1 0 0 1 azul claro
;	1 0 1 0 verde claro
;	1 0 1 1 cyan claro
;	1 1 0 0 rosa
;	1 1 0 1 magenta claro
;	1 1 1 0 amarelo
;	1 1 1 1 branco intenso

preto		    equ		0
azul		    equ		1
verde		    equ		2
cyan		    equ		3
vermelho	    equ		4
magenta		    equ		5
marrom		    equ		6
branco		    equ		7
cinza		    equ		8
azul_claro	    equ		9
verde_claro	    equ		10
cyan_claro	    equ		11
rosa		    equ		12
magenta_claro	equ		13
amarelo		    equ		14
branco_intenso	equ		15

modo_anterior	db		0
linha   	    dw  	0
coluna  	    dw  	0
deltax		    dw		0
deltay		    dw		0	
mens    	    db  	'Função Gráfica Sistemas Embarcados I $' 


;*************************************************************************
segment stack stack
    		    dw 		512
stacktop:
