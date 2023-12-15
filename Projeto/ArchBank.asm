.data
    	MAX_CLIENTES: .word 50
    	cliente0: .space 64  # Espaco para armazenar informacoes do cliente0 (Cada cliente possui 64 bytes, sendo 11 para cpf, 8 para a conta, 6 para o saldo (em centavos), 6 para o limite (em centavos), 6 para a fatura/divida (em centavos) e 27 para o nome)
    	cliente1: .space 64
    	cliente2: .space 64
    	cliente3: .space 64
    	cliente4: .space 64
    	cliente5: .space 64
    	cliente6: .space 64
    	cliente7: .space 64
    	cliente8: .space 64
    	cliente9: .space 64
    	cliente10: .space 64
    	cliente11: .space 64
    	cliente12: .space 64
    	cliente13: .space 64
    	cliente14: .space 64
    	cliente15: .space 64
    	cliente16: .space 64
    	cliente17: .space 64
    	cliente18: .space 64
    	cliente19: .space 64
    	cliente20: .space 64
    	cliente21: .space 64
    	cliente22: .space 64
    	cliente23: .space 64
    	cliente24: .space 64
    	cliente25: .space 64
    	cliente26: .space 64
    	cliente27: .space 64
    	cliente28: .space 64
    	cliente29: .space 64
    	cliente30: .space 64
    	cliente31: .space 64
    	cliente32: .space 64
    	cliente33: .space 64
    	cliente34: .space 64
    	cliente35: .space 64
    	cliente36: .space 64
    	cliente37: .space 64
    	cliente38: .space 64
    	cliente39: .space 64
    	cliente40: .space 64
    	cliente41: .space 64
    	cliente42: .space 64
    	cliente43: .space 64
    	cliente44: .space 64
    	cliente45: .space 64
    	cliente46: .space 64
    	cliente47: .space 64
    	cliente48: .space 64
    	cliente49: .space 64
    	
    	LIMITE_ATINGIDO_MSG: .asciiz "Limite de clientes atingido.\n"
   	CLIENTE_CADASTRADO_MSG: .asciiz "\nCliente cadastrado com sucesso. N�mero da conta: "
   	COMANDO: .asciiz "Insira o comando para a opera��o desejada: \n"
   	
   	conta_cadastrar: .ascii "conta_cadastrar"
 	stringComando: .space 20 # vai armazenar o comando inserido na string do terminal
   	
   	input_string: .space 70
   	cpf: .space 11	 	# Espaco na memoria para armazenar o cpf lido no input
	conta: .space 6 	# Espaco na memoria para armazenar o numero da conta lido no input
	saldo: .asciiz "000000"		# Valor padrao para um saldo ao cadastrar o cliente
	limite: .asciiz "150000"	# Valor padrao para um limite ao cadastrar o cliente
	fatura: .asciiz "000000"	# Valor padrao para uma fatura ao cadastrar o cliente
	nome: .space 27		# Espaco na memoria para armazenar o nome lido no input

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

.macro guardar_ra_pilha
	addi $sp, $sp, -4
    	sw $ra, 0($sp)
.end_macro

.macro carregar_ra_pilha
	lw $ra, 0($sp)
	addi $sp, $sp, 4
.end_macro

.text
    	.globl main
	.globl verificar_limite
	.globl alterar_limite
	.globl realizar_pagamento

	main:
    		# Inicializacao de variaveis
    		li $s0, 0          # $s0 = numClientes
    		la $s1, cliente0   # $s1 = endereco do cliente0

    		li $v0, 4
    		la $a0, COMANDO
    		syscall
    		
    		li $v0, 8
    		la $a0, input_string
    		li $a1, 50
    		syscall
    		
    		jal decodificaInput
    		jal verificar_limite
		jal alterar_limite
		jal realizar_pagamento

    		j exit
    	
    	# Teste: conta_cadastrar-13967492419-100010-Marceline
    	
    	decodificaInput: # Funcao para decodificar o input inserido pelo cliente
    		move $t0, $a0 # Move o endereço de input_string para $t0
    		li $t1, '-' # Carrega o hifen em $t1
    		la $t2, stringComando # Carrega o endereço da string a ser preenchida com o comando para ser comparado
    	
    		copiaComando:
    		lb $t3, 0($t0)  # Carrega byte por byte do comando em $t3
        	beq $t3, $t1, comparaComando  # Se encontrar o hifen, pula para a funcao comparaComando
        	sb $t0, 0($t2) # Copia o byte em $t0 para o endereço em $t2
        	addi $t2, $t2, 1 #Incrementa o endereco de stringComando para copiar o próximo byte
        	addi $t0, $t0, 1  # Incrementa o endereco do comando em $t0 para verificar o byte seguinte
        	j copiaComando
        	
        	comparaComando:
    		la $a0, stringComando
    		la $a1, conta_cadastrar
    		guardar_ra_pilha() # Salva o $ra atual na pilha
    		jal strcmp
    		beq $v0, $zero, decodificaCadastrarCliente
    	
    	decodificaCadastrarCliente: # Funcao para decodificar os atributos do cliente
    		li $a2, 11 # Num de bytes do cpf a serem copiados
    		la $a1, input_string # Source de memcpy
    		addi $a1, $a1, 16 # Endereço do começo do cpf contido na string
    		la $a0, cpf # Destination de memcpy
    		jal memcpy # Chama memcpy
    	
    		li $a2, 6 # Num de bytes do numero da conta a serem copiados
    		la $a1, input_string # Source de memcpy
    		addi $a1, $a1, 28 # Endereço do começo do numero da conta contido na string
    		la $a0, conta # Destination de memcpy
    		jal memcpy # Chama memcpy
    	
    		la $a1, input_string # Source de strcpy
    		addi $a1, $a1, 35 # Endereço do começo do nome contido na string
    		la $a0, nome # Destination de strcpy
    		jal strcpy # Chama strcpy
    	
    		j cadastrarCliente # Chama funcao cadastrarCliente

	cadastrarCliente:
    		# Argumentos: $a0 = cpf, $a1 = conta, $a2 = nome
    		# Variaveis locais: $s0 = numClientes, $s1 = endereco do bloco de clientes
    		# Cada cliente tem 64 bytes e é estruturado da seguinte maneira: 0-10 bytes = CPF / 11-18 bytes = numConta / 19-24 bytes = saldo / 25-30 bytes = limite / 31-36 bytes = fatura / 37-63 bytes = nome

    		# Verificar se o limite de clientes foi atingido
   		lw $t2, MAX_CLIENTES
    		bge $s0, $t2, limiteAtingido
	
    		# Calcular o offset para o cliente atual
    		mul $t3, $s0, 64  # Cada cliente tem 64 bytes
    		add $t4, $s1, $t3 # Endereco do cliente atual

    		# Copiar informacoes para a estrutura do cliente
    		la $a0, 0($t4)	# Carrega em $a0 a posicao inicial do cpf do cliente	(cliente[numClientes].cpf[0])
    		la $a1, cpf	# Carrega em #a1 o cpf digitado pelo usuario, que estava na memoria
    		la $a2, 11	# Carrega em $a2 a quantidade de bytes a serem copiadas de "cpf"
    		jal memcpy	# Chama a funcao memcpy
    		
    		la $a0, 11($t4)	# Carrega em $a0 a posicao inicial do numero da conta do cliente (cliente[numClientes].conta[0])
    		la $a1, conta	# Carrega em #a1 o numero da conta digitado pelo usuario, que estava na memoria
    		la $a2, 6	# Carrega em $a2 a quantidade de bytes a serem copiadas de "conta"
    		jal memcpy	# Chama a funcao memcpy
    		
    		li $t9, '-'         # Carrega em $t9 o caractere '-'
   		sb $t9, 17($t4)     # clientes[numClientes].conta[7] = '-'
   		
    		la $a0, conta       # Passa o endereco da conta salva na memoria para a funcao calcularDigitoVerificador		
    		jal calcularDigitoVerificador
    		sb $v0, 18($t4)     # clientes[numClientes].conta[8] = digito verificador calculado
    		
    		la $a0, 19($t4)	# Carrega em $a0 a posicao inicial do saldo do cliente 	(cliente[numClientes].saldo[0])
    		la $a1, saldo	# Carrega em #a1 o saldo inicial para um cliente definido na memoria
    		la $a2, 6	# Carrega em $a2 a quantidade de bytes a serem copiadas de "saldo_inicial"
    		jal memcpy	# Chama a funcao memcpy
    		
    		la $a0, 25($t4)	# Carrega em $a0 a posicao inicial do limite do cliente (cliente[numClientes].limite[0])
    		la $a1, limite	# Carrega em #a1 o limite inicial para um cliente definido na memoria
    		la $a2, 6	# Carrega em $a2 a quantidade de bytes a serem copiadas de "limite_inicial"
    		jal memcpy	# Chama a funcao memcpy
    		
    		la $a0, 31($t4)	# Carrega em $a0 a posicao inicial da fatura do cliente (cliente[numClientes].fatura[0])
    		la $a1, fatura	# Carrega em #a1 o limite inicial para um cliente definido na memoria
    		la $a2, 6	# Carrega em $a2 a quantidade de bytes a serem copiadas de "limite_inicial"
    		jal memcpy	# Chama a funcao memcpy
    		
    		la $a0, 37($t4)	# Carrega em $a0 a posicao inicial do nome do cliente 	(cliente[numClientes].nome[0])
    		la $a1, nome	# Carrega em #a1 o nome digitado pelo usuario, que estava na memoria
    		jal strcpy	# Chama a funcao memcpy

    		# Mensagem de sucesso  
    		print_str(CLIENTE_CADASTRADO_MSG)  # $a0 = string para cliente cadastrado, definida no .data
    		
    		la $a0, 11($t4)		# Carrega em $a0 a posicao inicial do numero da conta do cliente (cliente[numClientes].conta[0])
		jal print_numConta      # Chama a funcao para imprimir o numero da conta com o digito verificador	

    		# Incrementar numClientes
    		addi $s0, $s0, 1	# numClientes = numClientes + 1

    		j fimFuncao

	verificar_limite:
		lw $t2, MAX_CLIENTES
   		bltz $t0, cliente_invalido
   		bge $t0, $t2, cliente_invalido

    		sll $t3, $t0, 6
   		la $t4, cliente0
    		add $t4, $t4, $t3

   		lw $t5, 44($t4)  # Offset 44 corresponde à posição do limite dentro do cliente

   		# Exibe o limite do cliente
    		li $v0, 4
    		la $a0, msg_limite
    		syscall

    		li $v0, 1
    		move $a0, $t5
    		syscall

    		jr $ra
	alterar_limite:
		li $v0, 4
    		la $a0, msg_novo_limite
    		syscall

    		li $v0, 5
    		syscall
    		move $t1, $v0  # $t1 contém o novo limite

    		lw $t2, MAX_CLIENTES
    		bltz $t0, cliente_invalido
    		bge $t0, $t2, cliente_invalido

    		sll $t3, $t0, 6
    		la $t4, cliente0
    		add $t4, $t4, $t3

    		sw $t1, 44($t4)  # Atualiza o limite

    		jr $ra

	realizar_pagamento:
		li $v0, 4
    		la $a0, PAGAMENTO_MSG
    		syscall

    		li $v0, 5
    		syscall
    		move $t2, $v0  # $t2 contém o valor do pagamento

    		li $v0, 4
    		la $a0, ESCOLHER_PAGAMENTO_MSG
    		syscall

    		li $v0, 5
    		syscall
    		move $t3, $v0  # $t3 contém a opção: 0 para débito, diferente de 0 para crédito

    		lw $t4, MAX_CLIENTES
    		bltz $t0, cliente_invalido
    		bge $t0, $t4, cliente_invalido

    		sll $t5, $t0, 6
    		la $t6, cliente0
    		add $t6, $t6, $t5

	    	lw $t7, 38($t6)  # ALTERAR PQ NAO SEI QUAL corresponde à posição do saldo dentro do cliente
    		lw $t8, 25($t6) 
    		# Verifica se é débito
    		beqz $t3, debito   # Se $t3 (opção) é zero, pula para a seção de débito
    		# Se for crédito, subtrai do limite
    		sub $t8, $t8, $t2   # $t8 (limite) -= $t2 (valor do pagamento)
    		b fim_pagamento

	debito:
   		# Se for débito, subtrai do saldo
    		sub $t7, $t7, $t2   # $t7 (saldo) -= $t2 (valor do pagamento)

	fim_pagamento:
    		sw $t7, 38($t6)  # Atualiza o saldo no cliente

    		jr $ra

	cliente_invalido:
		li $v0, 4
    		la $a0, CLIENTE_INVALIDO_MSG
    		syscall

    		jr $ra

	limiteAtingido:
    		print_str(LIMITE_ATINGIDO_MSG)  # $a0 = string para limite atingido, definida no .data  

	fimFuncao:
		carregar_ra_pilha()	# Carrega o $ra salvo na pilha, para voltar ao main
    		jr $ra              # Retornar da funcao	   		
        		
	# Parametros -> $a0 - endereco de conta na memoria;
	print_numConta :
    		li $v0, 11	# Codigo do syscall para imprimir um caractere
    		li $t1, 8       # Número de bytes a serem impressos
    		la $t5, 0($a0)	# Guarda em $t5 o endereco do inicio do numero da conta do cliente, clientes[numCliente].conta[0]

		printLoop:
    			lb $t2, 0($t5)	# Carrega o byte da posição atual
    			move $a0, $t2   # Move o byte para $a0 (argumento do syscall)
    			syscall

    			addi $t5, $t5, 1	# Avança para o próximo byte

    			addi $t1, $t1, -1	# Decrementa o contador de bytes
    			bnez $t1, printLoop     # Se ainda não foram impressos todos os bytes, continua o loop

    		jr $ra		# Jump para a funcao cadastrarCliente		
        
	exit:
       		li $v0, 10        # Codigo do syscall para encerrar o programa
        	syscall
        
