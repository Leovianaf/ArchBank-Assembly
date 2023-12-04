  .data
    string: .asciiz "Cadeira" #String que vai passar pela função.
    destino: .space 8 #Guarda um espaço de 8 bytes para a string na string destino. (esse número pode mudar dependendo do tamanho da string, pode-se usar um número maior para evitar ficar mudando o código)
  .text #inicio das instruções MIPS
    main: 
    # Chamar a função strcpy
      la $a0, string  # Carregar o endereço da string de origem em $a0
      la $a1, destino  # Carregar o endereço da string de destino em $a1
      jal strcpy  # Chamar a função strcpy

      li $v0, 10  #Carregar o ccódigo de saída do programa syscall

  strcpy:
 # (LEMBRANDO QUE AO ARMAZENAR UMA STRING, TAMBÉM PRECISAMOS ARMAZENAR O BYTE 0 QUE VEM AO FINAL)
     loop:
        lb $t0, 0($a0)  # Carregar o próximo byte de string
        sb   $t0, 0($a1)  # Armazenar tal byte em destino
        beq  $t0, $zero, end  # Se o byte for zero (o último da string), encerra a função

        addi $a0, $a0, 1 # Soma 1 no índice para avançar para o próximo byte na string de origem
        addi $a1, $a1, 1 # Soma 1 no índice para avançar para o próximo byte na string de destino
        j    loop # Volta para o loop

      end:
        jr  $ra  # Retornar
