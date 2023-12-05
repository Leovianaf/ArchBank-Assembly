.data
	dest: .space 80
	source: .space 80
	dest_prompt: .asciiz "Insira a primeira string: "
	source_prompt: .asciiz "Insira a string a ser concatenada: "
	
.text
	li $v0, 4	#imprimir string
	la $a0, dest_prompt	#endereço da string
	syscall
	
    	li $v0, 8	#ler string
    	la $a0, dest	#carrega em $a0 endereço de dest
    	li $a1, 80	#tamanho de bytes maximo a ser lido
    	syscall
    
	li $v0, 4	#imprimir string
	la $a0, source_prompt	#endereço da string
	syscall
	
	li $v0, 8	#ler string
	la $a0, source	#guarda string lida em source
	li $a1, 80	#tamanho da string a ser lida
	syscall
	
	#chama função com endereços de $a0 e $a1
	la $a0, dest
    	la $a1, source
    	jal concatenacao
	
	#imprimir string concatenada em dest
	li $v0, 4
	la $a0, dest
	
	#encerrar programa
	li $v0, 10
	syscall
	
	concatenacao:
		li $t2, 0		#$t2 vai guardar o tamanho de dest
		move $t0, $a0		#guarda endereço de dest em $t0 para ser usado sem alterar $a0
		tamanho:
		lb $t1, 0($t0)		#pra carregar byte por byte de dest em $t1
		beq $t1, $zero, concat	#ao achar 0 em dest, pula pra função concat
		addi $t2, $t2, 1	#incrementa o tamanho de dest
		addi $t0, $t0, 1	#incrementa o endereço de dest em $t0 para verificar o byte seguinte
		j tamanho
		
		move $t1, $a1		#$t1 vai guardar o endereço de source
		
		concat:
		lb $t2, 0($t1)		#carrega um caractere de source no registrador $t2
		sb $t2, 0($t0)		#armazena um caractere de source no fim da string dest
		addi $t1, $t1, 1	#incrementa o endereço de source pra copiar caractere seguinte
		addi $t0, $t0, 1	#incrementa o endereço de dest pra indicar próx. pos. pra onde o caractere copiado de source deve ir
		beq $t1, $zero, nullch	#se achar caractere nulo em source pula pra função nullch
		j concat
		
		nullch:
		sb $zero, 0($t0)	#adiciona o caractere nulo no final da string concatenada
		move $v0, $a0		#move o endereço de dest para o retorno em $v0
		
	jr $ra			#volta pra próxima instrução depois da chamada da função
		
