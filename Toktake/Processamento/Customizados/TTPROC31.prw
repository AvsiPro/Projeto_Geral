#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC31  ºAutor  ³Jackson E. de Deus  º Data ³  08/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Mapa dos campos - Protheus x Equipe Remota                  º±±
±±º          ³Atualizar aqui o Mapa sempre que houver alteracoes		  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³08/10/14³01.01 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTPROC31(nTpServ)

Local aMapa := {}

Default nTpServ := 0

If cEmpAnt <> "01"
	return
EndIF

// Mapa de campos Leitura de maquina de cafe - SZN x KEEPLE
If nTpServ == 2
	aMapa := { {	"ZN_NUMOS"		,	"NUMEROOS"					},;
				{	"ZN_AGENTE"		,	"AGENTE"					},;
				{	"ZN_CLIENTE"	,	"CLIENTE"					},;
				{	"ZN_LOJA"		,	"LOJA"						},;
				{	"ZN_DATA"		,	"DATA"						},;
				{	"ZN_HORA"		,	"HORA"						},;	
				{	"ZN_PATRIMO"	,	"NUMERO_DO_ATIVO"			},;
				{	"ZN_NUMATU"		,	"TOTAL_DE_SELECOES"			},;
				{	"ZN_PARCIAL"	,	"PARCIAL"					},;
				{	"ZN_COTCASH"	,	"TOTAL_COFRE_/_VALOR_VISOR"	},;
				{	"ZN_BOTTEST"	,	"NUMERO_DE_TESTES"			},;
				{	"ZN_BOTAO01"	,	"P1"						},;
				{	"ZN_BOTAO02"	,	"P2"						},;
				{	"ZN_BOTAO03"	,	"P3"						},;
				{	"ZN_BOTAO04"	,	"P4"						},;
				{	"ZN_BOTAO05"	,	"P5"						},;
				{	"ZN_BOTAO06"	,	"P6"						},;
				{	"ZN_BOTAO07"	,	"P7"						},;
				{	"ZN_BOTAO08"	,	"P8"		  				},;
				{	"ZN_BOTAO09"	,	"P9"		 				},;
				{	"ZN_BOTAO10"	,	"P10"						},;
				{	"ZN_BOTAO11"	,	"P11"						},;
				{	"ZN_BOTAO12"	,	"P12"	   					},;
				{	"ZN_BOTAO13"	,	"P13"	   					},;
				{	"ZN_BOTAO14"	,	"P14"	   					},;
				{	"ZN_BOTAO15"	,	"P15"	   					},;
				{	"ZN_BOTAO16"	,	"P16"	   					},;
				{	"ZN_BOTAO17"	,	"P17"	   					},;
				{	"ZN_BOTAO18"	,	"P18"	   					},;
				{	"ZN_BOTAO19"	,	"P19"	   					},;
				{	"ZN_BOTAO20"	,	"P20"	   					},;
				{	"ZN_BOTAO21"	,	"P21"	   					},;
				{	"ZN_BOTAO22"	,	"P22"	   					},;
				{	"ZN_BOTAO23"	,	"P23"	   					},;
				{	"ZN_BOTAO24"	,	"P24"	   					},;
				{	"ZN_BOTAO25"	,	"P25"	   					},;
				{	"ZG_EOS"		,	"ENVIAR_COPIA_POR_E-MAIL"	} }				

// Mapa de campos Sangria - SZN/SZF x KEEPLE
ElseIf nTpServ == 3
	aMapa := { {	"ZN_NUMOS"		,	"NUMEROOS"					},;
				{	"ZN_AGENTE"		,	"AGENTE"					},;
				{	"ZN_CLIENTE"	,	"CLIENTE"					},;
				{	"ZN_LOJA"		,	"LOJA"						},;
				{	"ZN_DATA"		,	"DATA"						},;
				{	"ZN_HORA"		,	"HORA"						},;	
				{	"ZN_PATRIMO"	,	"PATRIMONIO"	   			},;
				{	"ZN_GLENVRE"	,	"MOEDA_RETIRADO"			},;            //ZN_LACRCED
				{	"ZN_LACRMOE"	,	"CEDULA_RETIRADO"			},;
				{	"ZF_RETMOE1"	,	"QUANTIDADE R0,05"			},;
				{	"ZF_RETMOE2"	, 	"QUANTIDADE R0,10"			},;
				{	"ZF_RETMOE3"	,	"QUANTIDADE R0,25"			},;
				{	"ZF_RETMOE4"	,	"QUANTIDADE R0,50"			},;
				{	"ZF_RETMOE5"	,	"QUANTIDADE R1,00"			},;
				{	"ZN_TROCO"		,	"TROCO_MOEDA"				},;
				{	"ZN_BANANIN"	,	If(Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE","BANANINHA","NUMERO")				},;
				{	"ZN_GLENVIE"	,	"MOEDA_COLOCADO"			},;            //ZN_LACCCED
				{	"ZN_LACCMOE"	,	If(Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE","CEDULA_-_LACRE_COLOCADO","CEDULA_COLOCADO")			},;           //CEDULA_COLOCADO
				{	"ZZN_NRSERI"	,	"NUMERO_DE_SERIE_DO_POS"	},;
				{	"ZN_COTCASH"	,	"TOTAL CASH (R$)"			},;
				{	"ZN_NUMATU"		,	"TOTAL VENDAS QTD"			},;
				{	"ZN_LOGC01"		,	"CONTADOR 01"				},;
				{	"ZN_LOGC02"		,	"CONTADOR 02"				},;
				{	"ZN_LOGC03"		,	"CONTADOR 03"				},;
				{	"ZN_LOGC04"		,	"CONTADOR 04"				},;
				{	"ZN_LOGC05"		,	"CONTADOR 05"				},;
				{	"ZN_BOTTEST"	,	"NUMERO_TESTES"				},;
				{	"ZN_PARCIAL"	,	"PARCIAL"					},;
				{	"ZN_BOTAO01"	,	"P1"	   					},;
				{	"ZN_BOTAO02"	,	"P2"						},;
				{	"ZN_BOTAO03"	,	"P3"						},;
				{	"ZN_BOTAO04"	,	"P4"						},;
				{	"ZN_BOTAO05"	,	"P5"						},;
				{	"ZN_BOTAO06"	,	"P6"						},;
				{	"ZN_BOTAO07"	,	"P7"						},;
				{	"ZN_BOTAO08"	,	"P8"						},;
				{	"ZN_BOTAO09"	,	"P9"						},;
				{	"ZN_BOTAO10"	,	"P10"						},;
				{	"ZN_BOTAO11"	,	"P11"						},;
				{	"ZN_BOTAO12"	,	"P12"						},;
				{	"ZN_BOTAO13"	,	"P13"	   					},;
				{	"ZN_BOTAO14"	,	"P14"	   					},;
				{	"ZN_BOTAO15"	,	"P15"	   					},;
				{	"ZN_BOTAO16"	,	"P16"	   					},;
				{	"ZN_BOTAO17"	,	"P17"	   					},;
				{	"ZN_BOTAO18"	,	"P18"	   					},;
				{	"ZN_BOTAO19"	,	"P19"	   					},;
				{	"ZN_BOTAO20"	,	"P20"	   					},;
				{	"ZN_BOTAO21"	,	"P21"	   					},;
				{	"ZN_BOTAO22"	,	"P22"	   					},;
				{	"ZN_BOTAO23"	,	"P23"	   					},;
				{	"ZN_BOTAO24"	,	"P24"	   					},;
				{	"ZN_BOTAO25"	,	"P25"	   					},;
				{	"ZG_EOS"		,	"ENVIAR_COPIA_POR_E-MAIL"	}}

// Mapa de campos - Chamado Tecnico - AB9 x Keeple
ElseIf nTpServ == 7
	aMapa := { {	"AB9_XOSMOB"	,	"NUMEROOS"					},;
				{	"AB9_CODTEC"	,	"AGENTE"					},;
				{	"AB9_CODCLI"	,	"CLIENTE"					},;
				{	"AB9_LOJA"		,	"LOJA"						},;
				{	"AB9_DTFIM"		,	"DATAINI"					},;
				{	"AB9_HRFIM"		,	"HORAINI"					},;	
				{	"AB9_DTFIM"		,	"DATAFIM"					},;
				{	"AB9_HRFIM"		,	"HORAFIM"					},;	
				{	"AB9_MEMO2"		,	"DEFEITO_CONSTATADO"		},;
				{	"AB9_MEMO2"		,	"CAUSA_PROVAVEL"			},;	
				{	"AB9_MEMO2"		,	"SERVICO_EXECUTADO"			} }	  
				
				
ElseIf nTpServ == 8	
	aMapa := { {	"ZN_NUMOS"		,	"NUMEROOS"					},;
				{	"ZN_AGENTE"		,	"AGENTE"					},;
				{	"ZN_CLIENTE"	,	"CLIENTE"					},;
				{	"ZN_LOJA"		,	"LOJA"						},;
				{	"ZN_DATA"		,	"DATA"						},;
				{	"ZN_HORA"		,	"HORA"						},;	
				{	"ZN_PATRIMO"	,	"PATRIMONIO"				},;
				{	"ZN_NUMATU"		,	"TOTAL_DE_SELECOES"			},;
				{	"ZN_PARCIAL"	,	"PARCIAL"					},;
				{	"ZN_COTCASH"	,	"TOTAL_DE_CASH"				},;
				{	"ZN_BOTTEST"	,	"NUMERO_DE_TESTES"			},;
				{	"ZN_BOTAO01"	,	"CONTADOR_1_(P1)"			},;
				{	"ZN_BOTAO02"	,	"CONTADOR_2_(P2)"			},;
				{	"ZN_BOTAO03"	,	"CONTADOR_3_(P3)"			},;
				{	"ZN_BOTAO04"	,	"CONTADOR_4_(P4)"			},;
				{	"ZN_BOTAO05"	,	"CONTADOR_5_(P5)"			},;
				{	"ZN_BOTAO06"	,	"CONTADOR_6_(P6)"			},;
				{	"ZN_BOTAO07"	,	"CONTADOR_7_(P7)"			},;
				{	"ZN_BOTAO08"	,	"CONTADOR_8_(P8)"			},;
				{	"ZN_BOTAO09"	,	"CONTADOR_9_(P9)"			},;
				{	"ZN_BOTAO10"	,	"CONTADOR_10_(P10)"			},;
				{	"ZN_BOTAO11"	,	"CONTADOR_11_(P11)"			},;
				{	"ZN_BOTAO12"	,	"CONTADOR_12_(P12)"			},;
				{	"ZN_BOTAO13"	,	"CONTADOR_13_(P13)"			},;
				{	"ZN_BOTAO14"	,	"CONTADOR_14_(P14)"			},;
				{	"ZN_BOTAO15"	,	"CONTADOR_15_(P15)"			},;
				{	"ZN_BOTAO16"	,	"CONTADOR_16_(P16)"			},;
				{	"ZN_BOTAO17"	,	"CONTADOR_17_(P17)"			},;
				{	"ZN_BOTAO18"	,	"CONTADOR_18_(P18)"			},;
				{	"ZN_BOTAO19"	,	"CONTADOR_19_(P19)"			},;
				{	"ZN_BOTAO20"	,	"CONTADOR_20_(P20)"			},;
				{	"ZN_BOTAO21"	,	"CONTADOR_21_(P21)"			},;
				{	"ZN_BOTAO22"	,	"CONTADOR_22_(P22)"			},;
				{	"ZN_BOTAO23"	,	"CONTADOR_23_(P23)"			},;
				{	"ZN_BOTAO24"	,	"CONTADOR_24_(P24)"			},;
				{	"ZN_BOTAO25"	,	"CONTADOR_25_(P25)"			} }				
EndIf

Return aMapa