#include "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"
                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC27  บAutor  ณJackson E. de Deus  บ Data ณ  19/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados recebidos na tabela SZI.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.	 ณaCampos - Array com os campos da tabela e seus valores.	  บฑฑ
ฑฑบ			 ณ		Posicao [x][1] - Nome do campo no dicionario SZN	  บฑฑ
ฑฑบ			 ณ		Posicao [x][2] - Valor do campo						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno	 ณlRet - True ou False										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Integracao Equipe Remota                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC27(aCampos,lAuditoria)
           
Local cCliente := ""
Local cLoja := ""
Local dData := CtoD("")
Local cNumChapa := "" 
Local cNumOS := ""
Local nFdoTroco := 0
Local cContCash := ""
Local nLimTroco := 0 
Local nVlrTroco := 0
Local nVlrSan := 0
Local cTpEvent := ""
Local nI
Local lRet := .F.

Default aCampos := {}

If cEmpAnt <> "01"
	return
EndIF

// Somente para Sangria / Correcao Sangria
If Len(aCampos) == 0
	Return
EndIf

// Pega dados do array para tratamento caso necessario
For nI := 1 To Len(aCampos)
	If AllTrim(aCampos[nI][1]) == "ZI_TIPO"
		cTpEvent := aCampos[nI][2]
	// Patrimonio		
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_PATRIMO"
		cNumChapa := aCampos[nI][2]
	// Contador Cash
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_CNTCAS"
		cContCash := strtran(aCampos[nI][2],".")
		cContCash := strtran(cContCash,",")
	// Cliente	
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_CLIENTE"
		cCliente := aCampos[nI][2]
	// Loja
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_LOJA"
		cLoja := aCampos[nI][2]
	// Data
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_DATA"
		dData := aCampos[nI][2]
	// Troco abastecido
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_VLRTRO"
		nVlrTroco := aCampos[nI][2]
	// Fundo de troco
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_FDOTRO"
		nFdoTroco := aCampos[nI][2]
	// Valor sangrado
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_VLRSAN"
		nVlrSan := aCampos[nI][2]
	// Limite de troco		
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_LIMTRO"
		nLimTroco := aCampos[nI][2]
	// os mobile
	ElseIf AllTrim(aCampos[nI][1]) == "ZI_NUMOS"
		cNumOS := aCampos[nI][2]	
	EndIf
Next nI

lExiste := ChkReg(cTpEvent,cNumChapa,dData,cCliente,cLoja)
If lExiste    
	Conout( "TTPROC27 - REG JA EXISTE | " +cNumChapa +dtoc(dData) )
	Return .T.
EndIf
               
dbSelectArea("SZI")
If RecLock("SZI",.T.)

	SZI->ZI_PATRIMO := cNumChapa
	SZI->ZI_DATA := dData
	SZI->ZI_TIPO := If(lAuditoria,'8',cTpEvent)
	SZI->ZI_LIMTRO := nLimTroco
	SZI->ZI_VLRTRO := nVlrTroco          
	SZI->ZI_VLRSAN := nVlrSan
	SZI->ZI_CNTCAS := cContCash
	SZI->ZI_FDOTRO := If(lAuditoria,nVlrTroco,nFdoTroco)
	SZI->ZI_CLIENTE := cCliente
	SZI->ZI_LOJA := cLoja
	SZI->ZI_NUMOS := cNumOS
	
	SZI->(MsUnLock())
	lRet := .T.
EndIf
	
Return lRet
   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetRecAnt  บAutor  ณJackson E. de Deus บ Data ณ  01/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o evento anterior do patrimonio                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetRecAnt(cNumChapa,dData)		

Local nRecno := 0
Local cQuery := ""

cQuery := "SELECT TOP 1 R_E_C_N_O_ ZIREC FROM " +RetSqlName("SZI") +" ZI "
cQuery += " WHERE ZI_DATA < '"+dtos(dData)+"' AND ZI_PATRIMO = '"+cNumChapa+"' AND D_E_L_E_T_ = '' ORDER BY ZI_DATA DESC, R_E_C_N_O_ DESC "

If Select("TRBD") > 0
	TRBD->( dbCloseArea() )
EndIf

TcQuery cQuery New Alias "TRBD"

If !EOF()
	nRecno := TRBD->ZIREC
EndIf

TRBD->( dbCloseArea() )

Return nRecno       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkReg  บAutor  ณJackson E. de Deus    บ Data ณ  11/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se ja existe o lancamento na tabela                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkReg(cTpEvent,cNumChapa,dData,cCliente,cLoja)

Local lRet := .F.
Local cQuery := ""
Local nTot := 0                 

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZI") 
cQuery += " WHERE D_E_L_E_T_ = '' AND ZI_PATRIMO = '"+cNumChapa+"' "
cQuery += " AND ZI_DATA = '"+DTOS(dData)+"' AND ZI_CLIENTE = '"+cCliente+"' AND ZI_LOJA = '"+cLoja+"' "  

If cTpEvent == "0"
	cQuery += " AND ZI_TIPO = '0' "	// REG INICIAL DO PATRIMONIO NO CLIENTE
ElseIf cTpEvent == "9"
	cQuery += " AND ZI_TIPO = '9' "	// REG FINAL DO PATRIMONIO NO CLIENTE
EndIf

If Select("TZI") > 0
	TZI->(dbCloseArea())
EndIf
     
TcQuery cQuery New Alias "TZI"

dbSelectArea("TZI")
If !EOF()
	nTot := TZI->TOTAL
EndIf

If nTot > 0
	lRet := .T.
EndIf       

Return lRet