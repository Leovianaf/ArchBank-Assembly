# Parametros -> $a0 - int a ser convertido para string de data; $a1 - endereco para armazenar valor convertido ; $v0 - digito verificador
.globl converte_int_stringData

.text
    	converte_int_stringData:
    		li $t6, 0 	# Contador para saber quantos numeros foram convertidos
    			
    		# Variaveis necessarias
		li $t1, 10 		# Valor 10 para ser dividido
		la $t2, 0($a1)		# Pega o endereco de valorConvertido para colocar o numero convertido
		addi $t2, $t2, 1	# Soma em $t2 a posicao do ultimo byte do endereco que vai salvar o valor a ser convertido				
		
		loop_divisao:
			beq $t6, 2, fim_conversao # Se terminou a conversao do numero para todos os bytes, vai para fim da conversao
        		div $a0, $t1    # Divide o n�mero por 10
        		mflo $a0        # Move o quociente para $a0
        		mfhi $t3        # Move o resto para $t4

        		add $t3, $t3, 48 # Converte o resto para caractere
        		sb $t3, 0($t2)	 # Armazena o d�gito no menos significativo do valorConvertido

        		addi $t2, $t2, -1 # Volta para o pr�ximo byte no buffer
        		addi $t6, $t6, 1  # Incrementa o contador

        		bnez $a0, loop_divisao  # Repete o loop se o quociente n�o for zero
		
		fim_conversao:
			# Valor convertido foi salvo em "dataConvertida"
			jr $ra		# Jump para onde foi chamada
