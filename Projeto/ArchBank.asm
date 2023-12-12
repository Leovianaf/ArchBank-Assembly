.data
    	MAX_CLIENTES: .word 50
    	cliente0: .space 50  # Espaco para armazenar informacoes do cliente0 (Cada cliente possui 50 bytes, sendo 11 para cpf, 8 para a conta e 33 para o nome)
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
    	ESTOU_AQUI: .asciiz "Estou aqui"
   	CLIENTE_CADASTRADO_MSG: .asciiz "\nCliente cadastrado com sucesso. Número da conta: "
   	CLIENTE_CPF_MSG: .asciiz "Digite o CPF do cliente que deseja cadastrar: (11 digitos)\n"
   	CLIENTE_CONTA_MSG: .asciiz "Digite o numero da conta do cliente que deseja cadastrar: (6 digitos)\n"
   	CLIENTE_NOME_MSG: .asciiz "Digite o nome do cliente que deseja cadastrar: (até 33 digitos)\n"
   	COMANDO: .asciiz "Insira o comando para a operação desejada: \n"
   	
   	conta_cadastrar: .ascii "conta_cadastrar"
 	stringComando: .space 20 # vai armazenar o comando inserido na string do terminal
   	
   	input_string: .space 50
   	cpf: .space 11	 	# Espaco na memoria para armazenar o cpf lido no input
	conta: .space 6 	# Espaco na memoria para armazenar o numero da conta lido no input
	nome: .space 33		# Espaco na memoria para armazenar o nome lido no input

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
    		
    		j exit
    	
    	# Teste: cliente_cadastrar-<13967492419>-<12345678>-<Marceline>
    	
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
    		addi $a1, $a1, 17 # Endereço do começo do cpf contido na string
    		la $a0, cpf # Destination de memcpy
    		jal memcpy # Chama memcpy
    	
    		li $a2, 8 # Num de bytes do numero da conta a serem copiados
    		la $a1, input_string # Source de memcpy
    		addi $a1, $a1, 31 # Endereço do começo do numero da conta contido na string (contando com ">-<")
    		la $a0, conta # Destination de memcpy
    		jal memcpy # Chama memcpy
    	
    		la $a1, input_string # Source de strcpy
    		addi $a1, $a1, 42 # Endereço do começo do nome contido na string (contando com ">-<")
    		la $a0, nome # Destination de strcpy
    		jal strcpy # Chama strcpy
    	
    		j cadastrarCliente # Chama funcao cadastrarCliente

	cadastrarCliente:
    		# Argumentos: $a0 = cpf, $a1 = conta, $a2 = nome
    		# Variaveis locais: $s0 = numClientes, $s1 = endereco do bloco de clientes
    		# Cada cliente tem 50 bytes e é estruturado da seguinte maneira: 0-10 bytes = CPF / 11-19 bytes = numConta / 20-49 bytes = nome

    		# Verificar se o limite de clientes foi atingido
   		lw $t2, MAX_CLIENTES
    		bge $s0, $t2, limiteAtingido
	
    		# Calcular o offset para o cliente atual
    		mul $t3, $s0, 50  # Cada cliente tem 50 bytes
    		add $t4, $s1, $t3 # Endereco do cliente atual

    		# Copiar informações para a estrutura do cliente
    		la $a0, 0($t4)	# Carrega em $a0 a posicao inicial do cpf do cliente	(cliente[numClientes].cpf[0])
    		la $a1, cpf	# Carrega em #a1 o cpf digitado pelo usuario, que estava na memoria
    		la $a2, 11	# Carrega em $a2 a quantidade de bytes a serem copiadas de "cpf"
    		jal memcpy	# Chama a funcao memcpy
    		
    		la $a0, 11($t4)	# Carrega em $a0 a posicao inicial do numero da conta do cliente 	(cliente[numClientes].conta[0])
    		la $a1, conta	# Carrega em #a1 o numero da conta digitado pelo usuario, que estava na memoria
    		la $a2, 6	# Carrega em $a2 a quantidade de bytes a serem copiadas de "conta"
    		jal memcpy	# Chama a funcao memcpy
    		
    		li $t9, '-'         # Carrega em $t9 o caractere '-'
   		sb $t9, 17($t4)     # clientes[numClientes].conta[7] = '-'
   		
    		la $a0, conta       # Passa o endereco da conta salva na memoria para a funcao calcularDigitoVerificador		
    		jal calcularDigitoVerificador
    		sb $v0, 18($t4)     # clientes[numClientes].conta[8] = digito verificador calculado
    		
    		la $a0, 19($t4)	# Carrega em $a0 a posicao inicial do nome do cliente 	(cliente[numClientes].nome[0])
    		la $a1, nome	# Carrega em #a1 o nome digitado pelo usuario, que estava na memoria
    		jal strcpy	# Chama a funcao memcpy

    		# Mensagem de sucesso  
    		print_str(CLIENTE_CADASTRADO_MSG)  # $a0 = string para cliente cadastrado, definida no .data   		

    		# Incrementar numClientes
    		addi $s0, $s0, 1	# numClientes = numClientes + 1

    		j fimFuncao

	limiteAtingido:
    		print_str(LIMITE_ATINGIDO_MSG)  # $a0 = string para limite atingido, definida no .data  

	fimFuncao:
		carregar_ra_pilha()	# Carrega o $ra salvo na pilha, para voltar ao main
    		jr $ra              # Retornar da funcao

	calcularDigitoVerificador:
    		# Argumento: $a0 = endereco de conta
    		# Retorno: $v0 = digito verificador
    		li $t0, 2	# Pesos utilizados no calculo do digito verificador

    		li $t7, 0	# Variavel para armazenar a soma ponderada dos dígitos

    		li $t8, 0	# Loop para percorrer os primeiros 6 digitos da conta
    		
    		la $t5, 11($a0)	# Guarda em $t5 o endereco do inicio do numero da conta do cliente
    		
    		calcularLoop:
        		lb $t9, 0($t5)		# Carrega em $t9 o caractere do numero da conta atual
        		addi $t9, $t9, -48  	# Converte o caractere para sua versao numerica
       		
        		mult $t9, $t0		# Realiza a multiplicacao do digito pelo peso correspondente
        		mflo $t9		# O que ele guarda aqui?
        		add $t7, $t7, $t9	# Adiciona a $t7 o valor multiplicado pelo peso, para obter a soma ponderada

        		# Proximo digito e peso
        		addi $t5, $t5, 1	# Avanca 1 byte no endereco da conta
        		addi $t0, $t0, 1	# Acrescenta 1 ao peso
        		addi $t8, $t8, 1	# Acrescenta 1 ao contador de bytes ja lidos

        		# Condicao de parada
       		 	bne $t8, 5, calcularLoop	# Enquanto a quantidade de bytes calculada for < 5, continua caculando
        		nop

    		# Calcula o resto da divisao da soma pelo numero 11
    		li $t0, 11       # Carrega 11 em $t0 para fazer a divisao
    		rem $t7, $t7, $t0 # Divide $t7 por $t0 e guarda o resto da divisao em $t7

    		# Retorna 'X' se o resto for 10, caso contrario, retorna o proprio resto convertido para caractere
    		li $t0, 10		# Carrega 10 em $t0 para comparar
   	 	beq $t7, $t0, resto10	# Se o resto for 10, jump para resto10
    		addi $t7, $t7, 48	# Converte o numero para sua versao em caractere
    		
    		j fimFuncaoCalculo

	resto10:
    		li $t7, 88       # 88 = numero do caractere 'X'

	fimFuncaoCalculo:
    		move $v0, $t7	# Guarda em $v0 o retorno da funcao (digito verificador)
    		jr $ra          # Jump para a funcao cadastrarCliente   		
        		
	exit:
       		li $v0, 10        # Codigo do syscall para encerrar o programa
        	syscall
        
