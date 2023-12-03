# | Projeto ArchBank-Assembly |

## Informações:
* Beatriz Pereira da Silva - beatrizbusinessx@gmail.com
* Leonardo da Silva Viana Filho - leonardoviana.nave@gmail.com
* Paloma Raissa Alves dos Santos - palomaraissa10@gmail.com
* Ricardo José Zaidan Serra - ricardozaidan3@gmail.com

## Descrição geral do projeto:
Projeto realizado por grupo de 4 alunos na cadeira de Arquitetura e Organização de Computadores na UFRPE, consiste em um sitema bancário feito na linguagem Assembly MIPS.
O objetivo deste projeto é implementar um sistema de cadastro de clientes e transações para uma agência bancária.

### Objetivo do programa:
* Este sistema de cadastro será operado através de um terminal (prompt/shell) que funciona como um interpretador de comandos de texto, ou seja, o sistema ficará constantemente checando entradas de texto (string) e interpretando o que for recebido a partir de uma lista de comandos que o sistema será capaz de executar.

## Requisitos do Projeto:
* O sistema deve ter a capacidade de gerenciar até 50 clientes ao mesmo tempo.
  * Cada cliente deve ter as seguintes informações: nome, CPF e número de conta.
  * O sistema deve ser capaz de gerar o dígito verificador da conta do cliente no momento do cadastro. 
* O sistema deve permitir o pagamento de contas em débito ou crédito.
  * Se o pagamento for em débito, o valor pago deve ser deduzido do saldo. Se o pagamento for em crédito, o crédito da conta deve ser reduzido do limite de crédito. O limite de crédito padrão para cada novo cliente deve ser de R$ 1500,00.
* O sistema deve permitir alterar o limite de crédito de cada cliente individualmente. 
* O sistema deve ser capaz de registrar transações de débito e crédito para cada cliente.
  * Cada cliente pode ter um máximo de 50 transações de débito e crédito, cada. Transações que não foram bem-sucedidas não devem ser registradas. Caso o  número de transações exceda o limite, deve-se sobrescrever a mais antiga, mas os saldos atuais não devem ser alterados. 
