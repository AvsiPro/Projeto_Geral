#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC17  บAutor  ณJackson E. de Deus  บ Data ณ  19/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca as respostas do formulario e grava na base de dados.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.	 ณnTpServ - Tipo do servico - Leitura de Maquina de Cafe.	  บฑฑ
ฑฑบ	 		 ณ							- Sangria.						  บฑฑ
ฑฑบ	 		 ณaDoc - Vetor simples com o numero da OS.					  บฑฑ
ฑฑบ	 		 ณaDados - Array com respostas do retorno.					  บฑฑ
ฑฑบ	 		 ณ@cMsgErro - Alimenta as mensagens de erro.				  บฑฑ 
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ19/11/13ณ01.00 |Criacao                               ณฑฑ
ฑฑณJackson	       ณ29/07/14ณ02.00 |Implementada a validacao do formularioณฑฑ
ฑฑณ									de Sangria							  ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno	 ณlRet - True ou False										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Integracao Equipe Remota                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC17(nTpServ,aDoc,aDados,cMsgErro,lReproc)

Local cFilAgente	:= ""
Local aMapa			:= {}
Local lRet			:= .F.
Local aCampos		:= {}
Local aCamposVld	:= {} 
Local cPos			:= ""
Local cNumChapa		:= ""
Local nAgente		:= 0
Local cNumOS		:= ""
Local cCliente		:= ""
Local cLoja			:= "" 
Local lExist		:= .F.
Local nI			:= 0
Local nJ			:= 0 
Local cRemete		:= "microsiga"
Local cTarget		:= "tesouraria@toktake.com.br"
Local cSubject		:= "POS"
Local cbody			:= ""
Local aAttach		:= {}
Local dData			:= stod("")
Local cFilAgente	:= "01" // ajustar
Local cNomeAgente	:= ""
Local nRecSN1		:= 0
Local cTpInclusao	:= ""
Local lIncons		:= .F.
Local cRota			:= ""
Local nPos			:= 0
Local nPosCM		:= 0
Local cCampoMB		:= ""
Local lValidar		:= .T.
Local nNumAnt		:= 0 
Local nNumAtu		:= 0 
Local cTpEvent		:= ""
Local nznCotCash	:= ''
Local nVlrTroco		:= 0
Local nFdoTroco		:= 0
Local nLimTroco		:= 0
Local aSZI			:= {}
Local lAuditoria	:= .F.
Local cTipoCmpo		:=	''
Local cTrocaPlaca	:= ""
Local lNovoFrm		:= .F.
Local cValidZN		:= ""
Local dDtNumAnt		:= stod("")
Default nTpServ		:= 0
Default aDoc		:= {}
Default aDados		:= {}  
Default cMsgErro	:= "" 
Default lReproc		:= .F.

If cEmpAnt <> "01"
	return lRet
EndIF

If nTpServ == 0
	MsgAlert("Parโmetro Tipo de Servico invแlido! ","TTPROC17")
	Return lRet
EndIf

If Len(aDados) == 0
	Return lRet
EndIf

/*
aMapa := { {	"ZN_NUMOS"		,	"ZN_NUMOS"			},;
			{	"ZN_TIPINCL"	,	"ZN_TIPINCL"		},;		
			{	"ZN_AGENTE"		,	"ZN_AGENTE"			},;
			{	"ZN_CLIENTE"	,	"ZN_CLIENTE"		},;
			{	"ZN_LOJA"		,	"ZN_LOJA"			},;
			{	"ZN_DATA"		,	"ZN_DATA"			},;
			{	"ZN_HORA"		,	"ZN_HORA"			},;	
			{	"ZN_PATRIMO"	,	"ZN_PATRIMO"	   	},;
			{	"ZN_NUMATU"		,	"ZN_NUMATU"			},;
			{	"ZN_PARCIAL"	,	"ZN_PARCIAL"		},;	
			{	"ZN_COTCASH"	,	"ZN_COTCASH"		},;	
			{	"ZN_BOTTEST"	,	"ZN_BOTTEST"		},;								
			{	"ZN_BOTAO01"	,	"ZN_BOTAO01"		},;
			{	"ZN_BOTAO02"	,	"ZN_BOTAO02"		},;
			{	"ZN_BOTAO03"	,	"ZN_BOTAO03"		},;
			{	"ZN_BOTAO04"	,	"ZN_BOTAO04"		},;
			{	"ZN_BOTAO05"	,	"ZN_BOTAO05"		},;
			{	"ZN_BOTAO06"	,	"ZN_BOTAO06"		},;
			{	"ZN_BOTAO07"	,	"ZN_BOTAO07"		},;
			{	"ZN_BOTAO08"	,	"ZN_BOTAO08"		},;
			{	"ZN_BOTAO09"	,	"ZN_BOTAO09"		},;
			{	"ZN_BOTAO10"	,	"ZN_BOTAO10"		},;
			{	"ZN_BOTAO11"	,	"ZN_BOTAO11"		},;
			{	"ZN_BOTAO12"	,	"ZN_BOTAO12"		},;
			{	"ZN_BOTAO13"	,	"ZN_BOTAO13"		},;
			{	"ZN_BOTAO14"	,	"ZN_BOTAO14"		},;
			{	"ZN_BOTAO15"	,	"ZN_BOTAO15"		},;
			{	"ZN_BOTAO16"	,	"ZN_BOTAO16"		},;
			{	"ZN_BOTAO17"	,	"ZN_BOTAO17"		},;
			{	"ZN_BOTAO18"	,	"ZN_BOTAO18"		},;
			{	"ZN_BOTAO19"	,	"ZN_BOTAO19"		},;
			{	"ZN_BOTAO20"	,	"ZN_BOTAO20"		},;
			{	"ZN_BOTAO21"	,	"ZN_BOTAO21"		},;
			{	"ZN_BOTAO22"	,	"ZN_BOTAO22"		},;
			{	"ZN_BOTAO23"	,	"ZN_BOTAO23"		},;
			{	"ZN_BOTAO24"	,	"ZN_BOTAO24"		},;
			{	"ZN_BOTAO25"	,	"ZN_BOTAO25"		},;			
			{	"ZN_GLENVIE"	,	"ZN_GLENVIE"		},;
			{	"ZN_GLENVRE"	,	"ZN_GLENVRE"		},;
			{	"ZN_LACRMOE"	,	"ZN_LACRMOE"		},;
			{	"ZN_LACCMOE"	,	"ZN_LACCMOE"		},;
			{	"ZN_LACRCED"	,	"ZN_LACRCED"		},;
			{	"ZN_LACCCED"	,	"ZN_LACCCED"		},;  
			{	"ZF_RETMOE1"	,	"ZF_RETMOE1"		},;
			{	"ZF_RETMOE2"	,   "ZF_RETMOE2"		},;
			{	"ZF_RETMOE3"	,	"ZF_RETMOE3"		},;
			{	"ZF_RETMOE4"	,	"ZF_RETMOE4"		},;
			{	"ZF_RETMOE5"	,	"ZF_RETMOE5"		},;				
			{	"ZN_TROCO"		,	"ZN_TROCO"			},;
			{	"ZN_BANANIN"	,	"ZN_BANANIN"		},;				
			{	"ZN_POS"		,	"ZN_POS"			},;				
			{	"ZN_LOGC01"		,	"ZN_LOGC01"			},;
			{	"ZN_LOGC02"		,	"ZN_LOGC02"			},;
			{	"ZN_LOGC03"		,	"ZN_LOGC03"			},;
			{	"ZN_LOGC04"		,	"ZN_LOGC04"			},;
			{	"ZN_LOGC05"		,	"ZN_LOGC05"			},;			
			{	"ZN_MABAST1"	,	"ZN_MABAST1"		},;
			{	"ZN_MABAST2"	, 	"ZN_MABAST2"		},;
			{	"ZN_MABAST3"	,	"ZN_MABAST3"		},;
			{	"ZN_MABAST4"	,	"ZN_MABAST4"		},;
			{	"ZN_MABAST5"	,	"ZN_MABAST5"		},;
			{	"ZN_TRPLACA"	,	"ZN_TRPLACA"		},;
			{	"ZN_VALIDA"		,	"ZN_VALIDA"			},;
			{	"ZG_EOS"		,	"ZG_EOS"			}}

*/


aMapa := { {	"ZN_NUMOS"		,	"ZN_NUMOS"			},;
			{	"ZN_TIPINCL"	,	"ZN_TIPINCL"		},;		
			{	"ZN_AGENTE"		,	"ZN_AGENTE"			},;
			{	"ZN_CLIENTE"	,	"ZN_CLIENTE"		},;
			{	"ZN_LOJA"		,	"ZN_LOJA"			},;
			{	"ZN_DATA"		,	"ZN_DATA"			},;
			{	"ZN_HORA"		,	"ZN_HORA"			},;	
			{	"ZN_PATRIMO"	,	"ZN_PATRIMO"	   	},;
			{	"ZN_NUMATU"		,	"ZN_NUMATU"			},;
			{	"ZN_PARCIAL"	,	"ZN_PARCIAL"		},;	
			{	"ZN_COTCASH"	,	"ZN_COTCASH"		},;	
			{	"ZN_BOTTEST"	,	"ZN_BOTTEST"		},;								
			{	"ZN_GLENVIE"	,	"ZN_GLENVIE"		},;
			{	"ZN_GLENVRE"	,	"ZN_GLENVRE"		},;
			{	"ZN_LACRMOE"	,	"ZN_LACRMOE"		},;
			{	"ZN_LACCMOE"	,	"ZN_LACCMOE"		},;
			{	"ZN_LACRCED"	,	"ZN_LACRCED"		},;
			{	"ZN_LACCCED"	,	"ZN_LACCCED"		},;  
			{	"ZF_RETMOE1"	,	"ZF_RETMOE1"		},;
			{	"ZF_RETMOE2"	,   "ZF_RETMOE2"		},;
			{	"ZF_RETMOE3"	,	"ZF_RETMOE3"		},;
			{	"ZF_RETMOE4"	,	"ZF_RETMOE4"		},;
			{	"ZF_RETMOE5"	,	"ZF_RETMOE5"		},;				
			{	"ZN_TROCO"		,	"ZN_TROCO"			},;
			{	"ZN_BANANIN"	,	"ZN_BANANIN"		},;				
			{	"ZN_POS"		,	"ZN_POS"			},;				
			{	"ZN_LOGC01"		,	"ZN_LOGC01"			},;
			{	"ZN_LOGC02"		,	"ZN_LOGC02"			},;
			{	"ZN_LOGC03"		,	"ZN_LOGC03"			},;
			{	"ZN_LOGC04"		,	"ZN_LOGC04"			},;
			{	"ZN_LOGC05"		,	"ZN_LOGC05"			},;			
			{	"ZN_MABAST1"	,	"ZN_MABAST1"		},;
			{	"ZN_MABAST2"	, 	"ZN_MABAST2"		},;
			{	"ZN_MABAST3"	,	"ZN_MABAST3"		},;
			{	"ZN_MABAST4"	,	"ZN_MABAST4"		},;
			{	"ZN_MABAST5"	,	"ZN_MABAST5"		},;
			{	"ZN_TRPLACA"	,	"ZN_TRPLACA"		},;
			{	"ZN_VALIDA"		,	"ZN_VALIDA"			},;
			{	"ZG_EOS"		,	"ZG_EOS"			}}


For nI := 1 To 60
	AADD( aMapa, { "ZN_BOTAO" +PadL( cvaltochar(nI),2,"0"  ) ,"ZN_BOTAO" +PadL( cvaltochar(nI),2,"0"  ) } ) 
Next nI


 
For nI := 1 To Len(aMapa)
	For nJ := 1 To Len(aDados)
		If aMapa[nI][2] == aDados[nJ][1]	   
			// esses campos nao devem ser gravados
			If !aMapa[nI][1] $ "ZN_POS"
				AADD( aCampos, { aMapa[nI][1] , aDados[nJ][2] } )
			EndIf
			
			If aMapa[nI][1] == "ZN_POS"
				cPOS := aDados[nJ][2]
			ElseIf aMapa[nI][1] == "ZN_PATRIMO"
				cNumChapa := aDados[nJ][2]
				
				// obtem o numerador anterior
				nNumAnt := U_TTPROG02(cNumChapa,@dDtNumAnt)
			  	If Valtype(nNumAnt) == "C" 
			  		nNumAnt := Val(nNumAnt)
			  	EndIf       
			  	
			ElseIf aMapa[nI][1] == "ZN_AGENTE"
				nAgente := aDados[nJ][2]
				
				// ADICIONA O NOME DO AGENTE AO ARRAY DE CAMPOS/VALORES
				dbSelectArea("AA1")
				dbSetOrder(7) // filial + codigo pager
				If dbSeek( xFilial("AA1") +AvKey( nAgente,"AA1_PAGER") ) 
					cFilAgente := AA1_XFILAT
					cNomeAgente := AA1->AA1_NOMTEC
					AADD( aCampos, { "ZN_NOMAGEN", cNomeAgente } )
				EndIf
				
			ElseIf aMapa[nI][1] == "ZN_NUMOS"
				cNumOS := aDados[nJ][2]
			
				dbSelectArea("SZG")
				dbSetOrder(1) // filial +NUMERO OS
				If dbSeek( xFilial("SZG") +AvKey( cNumOS,"ZG_NUMOS") )
					// verifica se e uma OS de auditoria para que o fundo de troco seja considerado a partir desta os
					If "AUDITORIA" $ SZG->ZG_DESCFRM 
						lAuditoria := .T.
					EndIF
					// ADICIONA A ROTA AO ARRAY DE CAMPOS/VALORES
					AADD( aCampos, { "ZN_ROTA", SZG->ZG_ROTA } )
					cRota := SZG->ZG_ROTA
					// prepara o tipo de inclusao da tabela de contadores [nao considerar conferencia cega - tipo de formulario 1]
					If "FECHAMENTO" $ SZG->ZG_DESCFRM
						cTpInclusao := "FECHAMENTO"
					Else
						If SZG->ZG_TPFORM == 2
							cTpInclusao := "LEITURA CF"
						ElseIf SZG->ZG_TPFORM == 6
							cTpInclusao := "LEITURA CF"							
						ElseIf SZG->ZG_TPFORM == 3
							cTpInclusao := "SANGRIA"
						ElseIf SZG->ZG_TPFORM == 8
							cTpInclusao := "ABASTEC"
						ElseIf SZG->ZG_TPFORM == 11
							cTpInclusao := "SANGRIA"
						ElseIf SZG->ZG_TPFORM == 15
							cTpInclusao := "LEITURA CF"
						EndIf					
					EndIf
				EndIf
				   
			ElseIf aMapa[nI][1] == "ZN_CLIENTE"
				cCliente := aDados[nJ][2]    
			ElseIf aMapa[nI][1] == "ZN_LOJA"
				cLoja := aDados[nJ][2]
			ElseIf aMapa[nI][1] == "ZN_DATA"
				dData := aDados[nJ][2]
			ElseIf aMapa[nI][1] == "ZN_HORA"
				cHora := aDados[nJ][2] 
			ElseIf aMapa[nI][1] == "ZN_COTCASH"
				nznCotCash := cvaltochar(aDados[nJ][2])
			ElseIf aMapa[nI][1] == "ZN_TROCO"
				nVlrTroco := aDados[nJ][2]   
			ElseIf aMapa[nI][1] == "ZN_NUMATU"
				nNumAtu := aDados[nJ][2]
			
			ElseIf aMapa[nI][1] == "ZN_NUMANT"
				nNumAnt := aDados[nJ][2]   
					   
			ElseIf aMapa[nI][1] == "ZN_TRPLACA"
				cTrocaPlaca := aDados[nJ][2]
			ElseIf aMapa[nI][1] == "ZN_VALIDA"
				cValidZN := "S"
			ElseIf aMapa[nI][1] == "ZN_TIPINCL"
				cTpInclusao := aDados[nJ][2]
			EndIf

			Exit
		EndIf
	Next nJ
Next nI

CONOUT("#TTPROC17 -> OS: "+cNumOS +" - PATRIMONIO: "+cNumChapa +" - NUM ANT: " +cvaltochar(nNumAnt) +" - NUM ATU: " +cvaltochar(nNumAtu) )	


If Empty(cFilAgente)
	cFilAgente := "01"
EndIf

// se for placa nova - considerar numerador anterior o numerador atual da placa	10/06/2015
If AllTrim(cTrocaPlaca) == "2"
	nNumAnt := nNumAtu
EndIf

// PATRIMONIO
dbSelectArea("SN1")
dbSetOrder(2)
If MSSeek( xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA") )
	cCliente := SN1->N1_XCLIENT
	cLoja := SN1->N1_XLOJA
EndIf


dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	dData := SZG->ZG_DATAFIM
EndIf


// inclui outros campos
AADD( aCampos, { "ZN_FILIAL"	, cFilAnt } )       
AADD( aCampos, { "ZN_TIPINCL"	, If(lAuditoria,'AUDITORIA',cTpInclusao) } )
AADD( aCampos, { "ZN_NUMANT"	, nNumAnt	} )
AADD( aCampos, { "ZN_TRPLACA"	, cTrocaPlaca } )
AADD( aCampos, { "ZN_VALIDA"	, cValidZN } )
AADD( aCampos, { "ZN_DESCCLI"	, Posicione("SA1",1,xFilial("SA1") +AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA"),"A1_NOME" ) } )

// POS
AADD( aCampos, { "ZN_POS", cPOS } )
AADD( aCampos, { "ZN_DTANT", dDtNumAnt } )


dbSelectArea("SZN")
dbSetOrder(4)	// os + tipo
If MsSeek( xFilial("SZN") +AvKey(cNumOS,"ZN_NUMOS") +AvKey( cTpInclusao,"ZN_TIPINCL" ) ) 
	cMsgErro += "Os dados da Ordem de Servico ja estao gravados no sistema." +CRLF
	Aviso("TTPROC17","Os dados da Ordem de Servico ja estao gravados no sistema.",{"Ok"})
	Return lRet
EndIf   

// Checka o POS se confere com o Patrimonio
If nTpServ == 3 .And. !Empty(cPos)
	dbSelectArea("ZZN")
	dbSetOrder(1)
	If dbSeek(xFilial("ZZN")+AvKey(cPOS,"ZZN_IDPDV"))
		If AllTrim(ZZN->ZZN_PATRIM) <> AllTrim(cNumChapa)

			U_TTGENC01( xFilial("SZG"),"TTPROC17","ORDEM DE SERVICO","",,"","WS",dtos(date()),time(),,"O POS " +cPOS +" NAO CONFERE COM O PATRIMONIO INFORMADO: " +AllTrim(cNumChapa),,,"ZZN" )	

			cBody := "<html>"
			cBody += "<title>POS</title>"
			cBody += "<body>"
			cBody += "<p><strong>O POS " +cPOS +" nใo confere com o Patrim๔nio informado: " +AllTrim(cNumChapa) +"</strong></p><br>"
			cBody += "<p><strong>Sangria da OS: "+cNumOS +"</strong></p><br>"
			cBody += "<p><strong>Patrim๔nio: " +AllTrim(cNumChapa) +"</strong></p>"
			cBody += "<p><strong>Cliente: "+cCliente +"</strong></p><br>" 
			cBody += "<p><strong>Loja: "+cLoja +"</strong></p><br>"
			cBody += "<p><strong>Email automแtico enviado via Protheus.</strong></p>"
			cBody += "<p><strong>Favor nใo responder.</strong></p>"							
			cBody += "</body>"
			cBody += "</html>"
			
		EndIf
	Else

		U_TTGENC01( xFilial("SZG"),"TTPROC17","ORDEM DE SERVICO","",,"","WS",dtos(date()),time(),,"O POS " +cPOS +" NAO FOI ENCONTRADO NA BASE DE DADOS - PATRIMONIO "+Alltrim(cNumChapa),,,"ZZN" )	

		cBody := "<html>"
		cBody += "<title>POS</title>"
		cBody += "<body>"
		cBody += "<p><strong>O POS " +cvaltochar(cPOS) +" nใo foi encontrado na base de dados.</strong></p>"
		cBody += "<p><strong>Sangria da OS: "+cNumOS +"</strong></p>"
		cBody += "<p><strong>Patrim๔nio: " +AllTrim(cNumChapa) +"</strong></p>"
		cBody += "<p><strong>Cliente: "+cCliente +"</strong></p>" 
		cBody += "<p><strong>Loja: "+cLoja +"</strong></p>"
		cBody += "<p><strong>Email automแtico enviado via Protheus.</strong></p>"
		cBody += "<p><strong>Favor nใo responder.</strong></p>"										
		cBody += "</body>"
		cBody += "</html>"

	EndIf    
	
	If AllTrim(cBody) <> ""
		If FindFunction("U_TTMAILN")
			U_TTMAILN(cRemete,cTarget,cSubject,cBody,aAttach,.F.)
		EndIf
	EndIf

EndIf

// Carrega conteudo padrao dos campos em caso de campos vazios
For nI := 1 To Len(aCampos)
	cTipoCmpo := ChkTpCmpo(aCampos[nI][1])
	
	If ValType(aCampos[nI][2]) <> cTipoCmpo
		If cTipoCmpo == "C"
			If !Empty(aCampos[nI][2])
				aCampos[nI][2] := CValToChar(aCampos[nI][2])
			Else 
				aCampos[nI][2] := ""
			EndIf
		ElseIf cTipoCmpo == "N"
			If !Empty(aCampos[nI][2])
				aCampos[nI][2] := Val(aCampos[nI][2])
			Else
				aCampos[nI][2] := 0
			EndIf
		EndIf
	EndIf
Next nI
	

If FindFunction("U_TTPROC16")
	lRet := U_TTPROC16(aCampos,@cMsgErro,lAuditoria)
	If Valtype(lRet) == "L"
		If lRet
			CONOUT("#TTPROC17 -> Dados recebidos e gravados com sucesso - OS: "+cNumOS)
		Else 
			CONOUT("#TTPROC17 -> Houve erro ao gravar os dados do formulario - OS: " +cNumOS)
		EndIf
	EndIf                      
Else
	cMsgErro += "Funcao TTPROC16 nao compilada." +CRLF
	CONOUT("#TTPROC17 -> Fun็ใo U_TTPROC16 nใo compilada no reposit๓rio. Os dados nใo serใo gravados.")
	Return lRet
EndIf

// Tratamento para geracao do evento na SZI
If nTpServ == 3
	cTpEvent := "1"         
ElseIf nTpServ == 2
	cTpEvent := "7"
EndIf

If nTpServ == 3
	nFdoTroco := STATICCALL( TTAUDT02, SaldoFD, cNumChapa, dData,0 )
	If ValType(nFdoTroco) == "N"
		nFdoTroco := If(lAuditoria,nVlrTroco,nFdoTroco + nVlrTroco)
	EndIf
	
	AADD( aSZI, { "ZI_TIPO"		, cTpEvent } )
	AADD( aSZI, { "ZI_PATRIMO"	, cNumChapa } )  
	AADD( aSZI, { "ZI_CLIENTE"	, cCliente } )
	AADD( aSZI, { "ZI_LOJA"		, cLoja } )
	AADD( aSZI, { "ZI_DATA"		, dData } )
	AADD( aSZI, { "ZI_CNTCAS"	, nznCotCash } ) 
	AADD( aSZI, { "ZI_VLRTRO"	, nVlrTroco } )
	AADD( aSZI, { "ZI_FDOTRO"	, nFdoTroco } )
	AADD( aSZI, { "ZI_LIMTRO"	, nLimTroco } )
	AADD( aSZI, { "ZI_NUMOS"	, cNumOS } )

	// salva evento na SZI
	lRet := U_TTPROC27( aSZI,lAuditoria )
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkTpCmpo  บAutor  ณJackson E. de Deus บ Data ณ  07/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica tamanho do campo                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkTpCmpo(cCampo)

Local aX3 := TamSX3(cCampo)
Local cTipo := 	""

If Len(aX3) > 0
	cTipo := aX3[3]
EndIf

Return cTipo