/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁTMKDEF    ╨Autor  Ё Vendas CRM         ╨ Data Ё  06/13/00   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao ЁDEFINES DO MODULO DE CALL CENTER                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       ЁAP8                                                         ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁTMKA272 - TELEMARKETING                      													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// Valores dos combos tipo de ligacao
#DEFINE RECEPTIVO		1
#DEFINE ATIVO			2

// Valores dos combos status da ligacao
#DEFINE PLANEJADA		1
#DEFINE PENDENTE		2
#DEFINE ENCERRADA		3

// Valores dos combos status da ocorrencia/acao (SUD)
// No SX3 esta referido como Pendente/Encerrada causando
// conflito com o status da ligacao (SUC), logo definimos 
// ENCERRADA como FECHADA e PENDENTE como ABERTA
#DEFINE ABERTA			1
#DEFINE FECHADA		2

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁTMKA273 - TELEVENDAS                         													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// Valores para o rodape da rotina de Televendas
#DEFINE MERCADORIA		1	// Valor total do mercadoria
#DEFINE DESCONTO		2	// Valor total do desconto
#DEFINE ACRESCIMO		3	// Valor do acrescimo financeiro da condicao de pagamento
#DEFINE FRETE			4	// Valor total do frete
#DEFINE DESPESA		5	// Valor total da despesa
#DEFINE TOTAL			6	// Total do pedido
#DEFINE SUFRAMA		7	// Valor total da suframa
#DEFINE BASEDUP		8	// Base da duplicata (Valor lМquido da condiГЦo de pagamento)

// Valores dos combos tipo de marketing
#DEFINE RECEPTIVO		1
#DEFINE ATIVO			2
#DEFINE FAX			3
#DEFINE REPRESENTANTE	4

// Valores dos combos tipo operacao
#DEFINE FATURAMENTO	1
#DEFINE ORCAMENTO		2
#DEFINE ATENDIMENTO	3

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁAPENAS DOS CADASTROS                         													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

//TMKA070 - Cadastro de operadores - Rotinas de acesso
#DEFINE TELEMARKETING		1
#DEFINE TELEVENDAS			2
#DEFINE TELECOBRANCA		3
#DEFINE TODOS				4
#DEFINE TMKTLV				5

//здддддддддддддддддддддддддддддддддддддд©
//ЁARRAY COM DADOS DO EMAIL A SER ENVIADOЁ
//юдддддддддддддддддддддддддддддддддддддды
#DEFINE EMAIL	  	1	// Descricao do email do destinatario
#DEFINE ASSUNTO  	2	// Assunto do email
#DEFINE MENSAGEM 	3	// Corpo do email
#DEFINE ANEXO		4	// Anexo do email

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁLISTA DE CONTATO                             													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// Tipos de Telefone do Cadastro de Contatos - SU5

#DEFINE RESIDENCIAL 	1
#DEFINE CELULAR		2
#DEFINE FAX           	3
#DEFINE COMERCIAL1    	4
#DEFINE COMERCIAL2		5

// Rotinas do Menu

#DEFINE VISUAL			2
#DEFINE INCLUIR		3
#DEFINE INCLUIAUTO		4
#DEFINE ASSISTENTE		5
#DEFINE ALTERAR		6
#DEFINE EXCLUIR		7

// Valores do campo U4_TIPO ("Tipo de Lista")

#DEFINE MARKETING	1
#DEFINE COBRANCA	2
#DEFINE VENDAS 	3

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁTMKC010 - CONSULTA PERFIL DO CONTATO         													Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// Valores do campo de "Tipos de contato"
#DEFINE VOZ			1
#DEFINE FAX         	2
#DEFINE CROSSPOSTING	3
#DEFINE MALADIRETA		4
#DEFINE PENDENCIA		5
#DEFINE WEBSITE		6

//Status dos itens da lista.
#DEFINE NAOENVIADO		1
#DEFINE EMUSO			2
#DEFINE ENVIADO	 	3
#DEFINE TRANSFERIDO	4

// Tipo de Operador (U7_TIPO) - Cadastro de Operadores (SU7)

#DEFINE OPERADOR 		1
#DEFINE SUPERVISOR		2

// Situacao do OPERADOR (U7_VALIDO) - Cadastro de Operadores

#DEFINE VALIDO 		1

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁTMKA272 - CADASTRO DE SCRIPT - UZ_FORMATO														Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// Valores dos combos tipo de formato
#DEFINE DECISAO 	1		// Atendimento e o valor do SX3 - colocamos "decisao" para nao coincidir com o define anterior
#DEFINE PESQUISA	2

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁSIGXTEL - CADASTRO DE GRUPO DE ATENDIMENTO - HARDWARE											Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// Valores dos combos do tipo de Hardware
#DEFINE MODEM	1
#DEFINE CTI	2
#DEFINE MANUAL	3     

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁTMKA091 - Alternar entre Grupos de atendimento									                Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

// Rotinas monitoradas
#DEFINE AGENDAOPERADOR			1
#DEFINE SERVICEDESK				2
#DEFINE PREATENDIMENTO			3
#DEFINE CALLCENTER				4
#DEFINE TELEATENDIMENTO			5
#DEFINE ATENDIMENTORECEPTIVO	6

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁTMKC010 - Nomes dos Paineis de consulta									                Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

#DEFINE P_UNDEF				"INDEFINIDO" // Paineis indefinidos nЦo afetam regra de negocio
#DEFINE P_TMK_ENCERRADOS		"ENCERRADOS" // 4
#DEFINE P_TMK_ATIVOS			"ATIVOS" // 5
#DEFINE P_TMK_RECEPTIVOS		"RECEPTIVOS" //6
#DEFINE P_TMK_FOLLOW			"FOLLOW" //7 
#DEFINE P_TMK_PENDENCIAS		"PENDENCIAS" //8
#DEFINE P_TMK_CHAMADO		"CHAMADOS" //9
#DEFINE P_TMK_ATEND			"ATENDIMENTOS" //10

#DEFINE P_CAMP				"CAMPANHA"//11
#DEFINE P_CAMP_ANSCRIPT		"ANSCRIPT"//13

#DEFINE P_TLV_ORCAMENTO		"ORгAMENTOS"//16
#DEFINE P_TLV_FATURAMENTO	"FATURAMENTO" //17
#DEFINE P_TLV_CANCELADO		"CANCELADO" //18
#DEFINE P_TLV_SIGALOJA		"SIGALOJA" //19
#DEFINE P_TLV_BONUS			"BONUS" //20

#DEFINE P_TLC_NEGOCIA		"NEGOCIACAO" //26
#DEFINE P_TLC_OCORR			"OCORRENCIAS" //27
#DEFINE P_TLC_VENCIDA		"VENCIDAS"//28

#DEFINE P_ANF_VENCIDO		"VENCIDOS"//31
#DEFINE P_ANF_VENCER			"AVENCER"//32
#DEFINE P_ANF_ATRASO			"ATRASO"//33
#DEFINE P_ANF_CARTORIO		"CARTORIO"//34
#DEFINE P_ANF_PROTESTADO		"PROSTESTADO"//35

#DEFINE P_ANF_NCC				"NCCSABERTO" //37

#DEFINE P_CONT_RESULTADO		"LSTRESULTADO" //42 que devia ser 46

#DEFINE P_VAR					"VAREJO"
#DEFINE P_VAR_REGDES			"REGRADESC"
#DEFINE P_VAR_VPERDIDA		"VENDAPERDIDA"
#DEFINE P_VAR_CARTAO			"CARTAOFIDEL"





