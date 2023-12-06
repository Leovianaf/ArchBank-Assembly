.data
    	MAX_CLIENTES: .word 50
    	clientes: .space 1600  # Espaco para armazenar informacoes dos clientes (Cada cliente possui 32 bytes, e precisamos de 50 clientes, entao 32*50 = 1600)
    	
    	LIMITE_ATINGIDO_MSG: .asciiz "Limite de clientes atingido.\n"
   	CLIENTE_CADASTRADO_MSG: .asciiz "Cliente cadastrado com sucesso. Número da conta "

.macro print_int(%inteiro)	# Macro para imprimir um inteiro, passado como parametro
	addi $v0, $0, 1		# Codigo do syscall para imprimir um inteiro
    	add $a0, $0, %inteiro	# Coloque o valor a ser impresso em $a0 
    	syscall
.end_macro

.macro print_str(%string)	# Macro para imprimir uma string, passada como parametro
	addi $v0, $0, 4		# Codigo do syscall para imprimir uma string
    	la $a0, %string		# Carrega o endereco da striing em $a0
    	syscall
.end_macro

.macro print_bl			# Macro para imprimir uma string, passada como parametro
    	addi $v0, $0, 11	# Codigo do syscall para imprimir um caractere
    	addi $a0, $0, '\n'	# Carrega \n em $a0 para uma quebra de linha
    	syscall
.end_macro

.text
    	.globl main

	main:
    		# Inicializacao de variaveis
    		li $t0, 0          # $t0 = numClientes
    		la $t1, clientes   # $t1 = endereco do array clientes

    		# Exemplo de uso:
    		la $a0, "12345678901"
    		la $a1, "987654"
    		la $a2, "Joao Silva"
    		jal cadastrarCliente

    		la $a0, "98765432109"
    		la $a1, "123456"
    		la $a2, "Maria Souza"
    		jal cadastrarCliente

    		j exit	# Fim do programa  

	cadastrarCliente:
    		# Argumentos: $a0 = cpf, $a1 = conta, $a2 = nome
    		# Variáveis locais: $t0 = numClientes, $t1 = endereco do array clientes
    		# Cada cliente tem 32 bytes e é estruturado da seguinte maneira: 0-12 bytes = CPF / 13-21 bytes = numConta / 22-31 bytes = nome

    		# Verificar se o limite de clientes foi atingido
    		lw $t2, MAX_CLIENTES
    		bge $t0, $t2, limiteAtingido

    		# Copiar informacoes para a estrutura do cliente
    		sw $a0, 0($t1)      # clientes[numClientes].cpf = cpf / 0-12 devido ao cpf ter 11 digitos + o null
    		sw $a1, 12($t1)     # clientes[numClientes].conta = conta / 13-21 devido a conta ter 8 digitos + o null
    		sw $a2, 22($t1)     # clientes[numClientes].nome = nome / 22-31 devido o tamanho maximo para um nome ter 9 bytes + o null

    		# Calcular digito verificador
    		lw $t3, 12($t1)     # $t3 = endereco de clientes[numClientes].conta
    		jal calcularDigitoVerificador
    		sb $v0, 19($t1)     # clientes[numClientes].conta[6] = dígito verificador
    		sb $zero, 20($t1)   # clientes[numClientes].conta[7] = '\0'

    		# Mensagem de sucesso  
   		print_str(CLIENTE_CADASTRADO_MSG) # $a0 = string para cliente cadastrado, definida no .data
    
    		print_str(12($t1))	# $a0 = endereco de clientes[numClientes].conta

		print_str(19($t1))	# $a0 = digito verificador
	
		print_bl()	# Macro para imprimir uma quebra de linha

    		# Incrementar numClientes
    		addi $t0, $t0, 1
    		sw $t0, 0($t1)      # numClientes = numClientes + 1

    		j fimFuncao

	limiteAtingido:
		print_str(LIMITE_ATINGIDO_MSG)	# $a0 = string para limite atingido, definida no .data	

	fimFuncao:
    		jr $ra              # Retornar da funcao

	calcularDigitoVerificador:
    		# Argumento: $t3 = endereco de conta
    		# Retorno: $v0 = digito verificador

    		# Pesos utilizados no calculo do digito verificador
    		li $t0, 2
    		li $t1, 3
    		li $t2, 4
    		li $t4, 5
    		li $t5, 6
    		li $t6, 7

    		# Variavel para armazenar a soma ponderada dos dígitos
    		li $t7, 0

    		# Loop para percorrer os primeiros 6 digitos da conta
    		li $t8, 0
    		
    		calcularLoop:
        		# Converte o caractere numerico para o valor inteiro correspondente
        		lb $t9, 0($t3)
        		sub $t9, $t9, 48

        		# Realiza a multiplicacao do digito pelo peso correspondente
        		mult $t9, $t0
        		mflo $t9
        		add $t7, $t7, $t9

        		# Proximo digito e peso
        		addi $t3, $t3, 1
        		addi $t0, $t0, 1

        		# Condicao de parada
       			bne $t8, 5, calcularLoop
        		nop

    		# Calcula o resto da divisao da soma pelo numero 11
    		li $t0, 11
    		rem $t7, $t7, $t0

    		# Retorna 'X' se o resto for 10, caso contrario, retorna o proprio resto convertido para caractere
    		li $t0, 10
    		beq $t7, $t0, resto10
    		addi $t7, $t7, 48
    		j fimFuncaoCalculo

	resto10:
    		li $t7, 88

	fimFuncaoCalculo:
    		move $v0, $t7
    		jr $ra              # Retornar da funcao

	strcpy:
 		# Argumentos $a0 = source, $a1 = destination, retorno em $v0
 		
 		move $t1, $a0	# Temporario para iterar entre os indices da string source sem perder o endereco original
		move $t2, $a1	# Temporario para iterar entre os indices da string destination sem perder o endereco original
		
     		loop:
        		lb $t0, 0($t1)  # Carregar o proximo byte de string
        		sb $t0, 0($t2)  # Armazenar tal byte em destino
        		beq $t0, $zero, end  # Se o byte for zero (o ultimo da string), encerra a funcao

        		addi $t1, $t1, 1 # Soma 1 no indice para avancar para o proximo byte na string de origem
        		addi $t2, $t2, 1 # Soma 1 no indice para avancar para o proximo byte na string de destino
        		j    loop 	# Volta para o loop

      		end:
        		jr  $ra  # Retornar

	exit:
       		li $v0, 10        # Codigo do syscall para encerrar o programa
        	syscall
        