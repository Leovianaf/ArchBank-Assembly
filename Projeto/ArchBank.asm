.data
    	MAX_CLIENTES: .word 50
    	cliente0: .space 50  # Espaco para armazenar informacoes do cliente0 (Cada cliente possui 50 bytes, sendo 12 para cpf, 9 para a conta e 29 para o nome)
    	cliente1: .space 50
    	cliente2: .space 50
    	cliente3: .space 50
    	cliente4: .space 50
    	cliente5: .space 50
    	cliente6: .space 50
    	cliente7: .space 50
    	cliente8: .space 50
    	cliente9: .space 50
    	cliente10: .space 50
    	cliente11: .space 50
    	cliente12: .space 50
    	cliente13: .space 50
    	cliente14: .space 50
    	cliente15: .space 50
    	cliente16: .space 50
    	cliente17: .space 50
    	cliente18: .space 50
    	cliente19: .space 50
    	cliente20: .space 50
    	cliente21: .space 50
    	cliente22: .space 50
    	cliente23: .space 50
    	cliente24: .space 50
    	cliente25: .space 50
    	cliente26: .space 50
    	cliente27: .space 50
    	cliente28: .space 50
    	cliente29: .space 50
    	cliente30: .space 50
    	cliente31: .space 50
    	cliente32: .space 50
    	cliente33: .space 50
    	cliente34: .space 50
    	cliente35: .space 50
    	cliente36: .space 50
    	cliente37: .space 50
    	cliente38: .space 50
    	cliente39: .space 50
    	cliente40: .space 50
    	cliente41: .space 50
    	cliente42: .space 50
    	cliente43: .space 50
    	cliente44: .space 50
    	cliente45: .space 50
    	cliente46: .space 50
    	cliente47: .space 50
    	cliente48: .space 50
    	cliente49: .space 50
    	
    	LIMITE_ATINGIDO_MSG: .asciiz "Limite de clientes atingido.\n"
   	CLIENTE_CADASTRADO_MSG: .asciiz "Cliente cadastrado com sucesso. Número da conta "
   	CLIENTE_CPF_MSG: .asciiz "Digite o CPF do cliente que deseja cadastrar: (11 digitos)\n"
   	CLIENTE_CONTA_MSG: .asciiz "Digite o numero da conta do cliente que deseja cadastrar: (6 digitos)\n"
   	CLIENTE_NOME_MSG: .asciiz "Digite o nome do cliente que deseja cadastrar: \n"
   	
   	cpf: .space 12		# Espaco na memoria para armazenar o cpf lido no input
	conta: .space 9 	# Espaco na memoria para armazenar o numero da conta lido no input
	nome: .space 29		# Espaco na memoria para armazenar o nome lido no input

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

.macro print_bl			# Macro para imprimir uma quebra de linha
    	addi $v0, $0, 11	# Codigo do syscall para imprimir um caractere
    	addi $a0, $0, '\n'	# Carrega \n em $a0 para uma quebra de linha
    	syscall
.end_macro

.text
    	.globl main

	main:
    		# Inicializacao de variaveis
    		li $t0, 0          # $t0 = numClientes
    		la $t1, cliente0   # $t1 = endereco do cliente0

    		# Exemplo de uso:
    		li $v0, 4		# Codigo do syscall para imprimir uma string
		la $a0, CLIENTE_CPF_MSG	# $a0 = string para pedir cpf do cliente, definida no .data
		syscall
	
    		li $v0, 8	# Codigo do syscall para ler uma string como input
    		la $a0, cpf	# Salva o valor lido no espaco cpf reservado na memoria
    		li $a1, 12	# Tamanho de bytes maximo a ser lido
    		syscall
    		
    		print_bl()	# Quebra uma linha
    		
    		li $v0, 4		# Codigo do syscall para imprimir uma string
		la $a0, CLIENTE_CONTA_MSG	# $a0 = string para pedir cpf do cliente, definida no .data
		syscall
	
    		li $v0, 8	# Codigo do syscall para ler uma string como input
    		la $a0, conta	# Salva o valor lido no espaco cpf reservado na memoria
    		li $a1, 7	# Tamanho de bytes maximo a ser lido
    		syscall
    		
    		print_bl()	# Quebra uma linha
    		
    		li $v0, 4		# Codigo do syscall para imprimir uma string
		la $a0, CLIENTE_NOME_MSG	# $a0 = string para pedir cpf do cliente, definida no .data
		syscall
	
    		li $v0, 8	# Codigo do syscall para ler uma string como input
    		la $a0, nome	# Salva o valor lido no espaco cpf reservado na memoria
    		li $a1, 29	# Tamanho de bytes maximo a ser lido
    		syscall
    		
    		jal cadastrarCliente

    		j exit	# Fim do programa  

	cadastrarCliente:
    		# Argumentos: $a0 = cpf, $a1 = conta, $a2 = nome
    		# Variaveis locais: $t0 = numClientes, $t1 = endereco do bloco de clientes
    		# Cada cliente tem 50 bytes e é estruturado da seguinte maneira: 0-11 bytes = CPF / 12-20 bytes = numConta / 21-49 bytes = nome

    		# Verificar se o limite de clientes foi atingido
   		lw $t2, MAX_CLIENTES
    		bge $t0, $t2, limiteAtingido

    		# Calcular o offset para o cliente atual
    		mul $t3, $t0, 50  # Cada cliente tem 50 bytes
    		add $t4, $t1, $t3 # Endereco do cliente atual

    		# Copiar informações para a estrutura do cliente
    		sw $a0, 0($t4)      # clientes[numClientes].cpf = cpf / 0-11 devido ao cpf ter 12 digitos (incluindo '\0')
    		sw $a1, 12($t4)     # clientes[numClientes].conta = conta / 12-17 os numeros da conta digitados
    		li $t9, '-'         # Carrega em $t9 o caractere '-'
   		sb $t9, 18($t4)     # clientes[numClientes].conta[7] = '-'
    		la $a0, conta       # Passa o endereco da conta para a funcao calcularDigitoVerificador
    		jal calcularDigitoVerificador
    		sb $v0, 19($t4)     # clientes[numClientes].conta[8] = digito verificador calculado (sobrando o byte 20 para o '\0')
    		sw $a2, 21($t4)     # clientes[numClientes].nome = nome / 21-49 devido ao tamanho maximo para um nome ter 29 bytes (incluindo '\0')

    		# Mensagem de sucesso  
    		print_str(CLIENTE_CADASTRADO_MSG)  # $a0 = string para cliente cadastrado, definida no .data

    		# print_str(12($t4))  # $a0 = endereco de clientes[numClientes].conta

    		# Incrementar numClientes
    		addi $t0, $t0, 1	# numClientes = numClientes + 1

    		j fimFuncao

	limiteAtingido:
    		print_str(LIMITE_ATINGIDO_MSG)  # $a0 = string para limite atingido, definida no .data  

	fimFuncao:
    		jr $ra              # Retornar da funcao

	calcularDigitoVerificador:
    		# Argumento: $a0 = endereco de conta
    		# Retorno: $v0 = digito verificador

    		# Pesos utilizados no calculo do digito verificador
    		li $t0, 2

    		# Variavel para armazenar a soma ponderada dos dígitos
    		li $t7, 0

    		# Loop para percorrer os primeiros 6 digitos da conta
    		li $t8, 0
    		
    		calcularLoop:
        		# Converte o caractere numerico para o valor inteiro correspondente
        		lb $t9, 0($a0)
        		sub $t9, $t9, 48

        		# Realiza a multiplicacao do digito pelo peso correspondente
        		mult $t9, $t0
        		mflo $t9
        		add $t7, $t7, $t9

        		# Proximo digito e peso
        		addi $a0, $a0, 1
        		addi $t0, $t0, 1
        		addi $t8, $t8, 1

        		# Condicao de parada
       		 	bne $t8, 5, calcularLoop
        		nop

    		# Calcula o resto da divisao da soma pelo numero 11
    		li $t0, 11       # Carrega 11 em $t0 para fazer a divisao
    		rem $t7, $t7, $t0 # Divide $t7 por $t0 e guarda o resto da divisao em $t7

    		# Retorna 'X' se o resto for 10, caso contrario, retorna o proprio resto convertido para caractere
    		li $t0, 10
   	 	beq $t7, $t0, resto10
    		addi $t7, $t7, 48
    		
    		j fimFuncaoCalculo

	resto10:
    		li $t7, 88       # 88 = numero do caractere 'X'

	fimFuncaoCalculo:
    		move $v0, $t7
    		jr $ra           # Retornar da funcao

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
        
