# Parametros -> $a0 - string a ser zerada
.globl zerarString

zerarString:
    		# Argumentos: $a0 = endereco da string
    		li $t0, 0   # Valor do caractere nulo '\0'

    		loop_zerar:
        		sb $t0, 0($a0)   # Insere o caractere nulo na posi��o atual da string
        		addi $a0, $a0, 1  # Avan�a para o pr�ximo caractere na string
        		lb $t1, 0($a0)    # Carrega o pr�ximo caractere

        		# Verifica se chegou ao final da string
        		beq $t1, $t0, fim_zerar
        		j loop_zerar

    		fim_zerar:
        		jr $ra  # Retorna