;-----------------------------------------------------------------------------
;    fun��o full_circle
;	 PUSH xc; PUSH yc; PUSH r; CALL full_circle;  (xc+r<639,yc+r<479)e(xc-r>0,yc-r>0)
; cor definida na variavel cor					  
global full_circle
extern line 

full_circle:
	PUSH 	bp
	MOV	 	bp,sp
	PUSHf                        ;coloca os flags na pilha
	PUSH 	ax
	PUSH 	bx
	PUSH	cx
	PUSH	dx
	PUSH	si
	PUSH	di

	MOV		ax,[bp+8]    ; resgata xc
	MOV		bx,[bp+6]    ; resgata yc
	MOV		cx,[bp+4]    ; resgata r
	
	MOV		si,bx
	SUB		si,cx
	PUSH    ax			;coloca xc na pilha			
	PUSH	si			;coloca yc-r na pilha
	MOV		si,bx
	ADD		si,cx
	PUSH	ax		;coloca xc na pilha
	PUSH	si		;coloca yc+r na pilha
	CALL line
	
		
	MOV		di,cx
	SUB		di,1	 ;di=r-1
	MOV		dx,0  	;dx ser� a vari�vel x. cx � a variavel y
	
;aqui em cima a l�gica foi invertida, 1-r => r-1
;e as compara��es passaram a ser jl => JG, assim garante 
;valores positivos para d

stay_full:				;loop
	MOV		si,di
	CMP		si,0
	JG		inf_full       ;caso d for menor que 0, seleciona pixel superior (n�o  SALta)
	MOV		si,dx		;o jl � importante porque trata-se de conta com sinal
	SAL		si,1		;multiplica por doi (shift arithmetic left)
	ADD		si,3
	ADD		di,si     ;nesse ponto d=d+2*dx+3
	INC		dx		;INCrementa dx
	JMP		plotar_full
inf_full:	
	MOV		si,dx
	SUB		si,cx  		;faz x - y (dx-cx), e SALva em di 
	SAL		si,1
	ADD		si,5
	ADD		di,si		;nesse ponto d=d+2*(dx-cx)+5
	INC		dx		;INCrementa x (dx)
	DEC		cx		;DECrementa y (cx)
	
plotar_full:	
	MOV		si,ax
	ADD		si,cx
	PUSH	si		;coloca a abcisa y+xc na pilha			
	MOV		si,bx
	SUB		si,dx
	PUSH    si		;coloca a ordenada yc-x na pilha
	MOV		si,ax
	ADD		si,cx
	PUSH	si		;coloca a abcisa y+xc na pilha	
	MOV		si,bx
	ADD		si,dx
	PUSH    si		;coloca a ordenada yc+x na pilha	
	CALL 	line
	
	MOV		si,ax
	ADD		si,dx
	PUSH	si		;coloca a abcisa xc+x na pilha			
	MOV		si,bx
	SUB		si,cx
	PUSH    si		;coloca a ordenada yc-y na pilha
	MOV		si,ax
	ADD		si,dx
	PUSH	si		;coloca a abcisa xc+x na pilha	
	MOV		si,bx
	ADD		si,cx
	PUSH    si		;coloca a ordenada yc+y na pilha	
	CALL	line
	
	MOV		si,ax
	SUB		si,dx
	PUSH	si		;coloca a abcisa xc-x na pilha			
	MOV		si,bx
	SUB		si,cx
	PUSH    si		;coloca a ordenada yc-y na pilha
	MOV		si,ax
	SUB		si,dx
	PUSH	si		;coloca a abcisa xc-x na pilha	
	MOV		si,bx
	ADD		si,cx
	PUSH    si		;coloca a ordenada yc+y na pilha	
	CALL	line
	
	MOV		si,ax
	SUB		si,cx
	PUSH	si		;coloca a abcisa xc-y na pilha			
	MOV		si,bx
	SUB		si,dx
	PUSH    si		;coloca a ordenada yc-x na pilha
	MOV		si,ax
	SUB		si,cx
	PUSH	si		;coloca a abcisa xc-y na pilha	
	MOV		si,bx
	ADD		si,dx
	PUSH    si		;coloca a ordenada yc+x na pilha	
	CALL	line
	
	CMP		cx,dx
	JB		fim_full_circle  ;se cx (y) est� abaixo de dx (x), termina     
	JMP		stay_full		;se cx (y) est� acima de dx (x), continua no loop
	
	
fim_full_circle:
	POP		di
	POP		si
	POP		dx
	POP		cx
	POP		bx
	POP		ax
	POPf
	POP		bp
	ret		6
