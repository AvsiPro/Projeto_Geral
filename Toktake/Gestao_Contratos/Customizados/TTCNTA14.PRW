#include "protheus.ch"
#include "topconn.ch"

/*
---------------------------------------------------------------------------------------
Programa: TTCNTA14
Autor: Jackson E. de Deus
Data: 02/12/2013
Descricao: Inclui patrimonio no contrato/planilha do cliente - tabela auxiliar SZQ
Parametros: nTipo,  cContrato, cPlanilha, cNumchapa, nValor, dData, cCliente, cLoja 
Retorno: True ou False
---------------------------------------------------------------------------------------
*/
User Function TTCNTA14(nTipo, cContrato, cPlanilha, cNumchapa, nValor, dData, cCliente, cLoja )
           
Local lRet			:= .F.
Local nCont			:= 0
Local nI 			:= 0
Local cMsgErro		:= ""
Local nRecSZQ		:= 0

Default nTipo		:= 0
Default cContrato	:= ""
Default cPlanilha	:= ""
Default cNumchapa	:= ""
Default nValor		:= 0
Default dData		:= ctod("")
Default cCliente	:= ""
Default cLoja		:= ""

If cEmpAnt <> "01"
	Return .F.
EndIf

If nTipo == 0
	Return .F.
EndIf
		
If Empty(cContrato) .Or. Empty(cPlanilha) .Or. Empty(cNumchapa) .Or. dtos(dData) == "" .Or. Empty(cCliente) .Or. Empty(cLoja)
	Return .F.
EndIf        
	
// inclusao
If nTipo == 1
	dbSelectArea("SZQ")
	dbSetOrder(1)	//contrato+planilha+patrimonio+cliente+loja
    
	// verifica se o patrimonio ja esta em outro contrato/planilha
	lExist := ChkPatrim(cNumchapa,@nRecSZQ)
	If ValType(lExist) == "L"
		If lExist .And. nRecSZQ > 0
			Return .F.
			
			dbSelectArea("SZQ")
			dbGoTo(nRecSZQ)
			If AllTrim(SZQ->ZQ_CLIENTE) <> cCliente .And. AllTrim(SZQ->ZQ_LOJA) <> cLoja .And. Empty(SZQ->ZQ_DATAREM)
				cMsgErro := "O patrimônio " +cNumchapa +" já está incluído em outro contrato/planilha." +CRLF 
				cMsgErro += "Contrato: " +SZQ->ZQ_CONTRA +CRLF 
				cMsgErro += "Planilha: " +SZQ->ZQ_PLAN +CRLF
				cMsgErro += "Para que seja possível incluir em outro contrato/planilha, é necessário que primeiro seja feita a remoção do contrato/planilha informados acima."
				Aviso("TTCNTA14",cMsgErro,{"Ok"},3)
				Return .F.
			EndIf
		EndIf
	EndIf
    
	// inclui na planilha
	dbSelectArea("SZQ")
	If RecLock("SZQ",.T.)
		SZQ->ZQ_FILIAL	:= xfilial("SZQ")
		SZQ->ZQ_CONTRA	:= cContrato
		SZQ->ZQ_PLAN	:= cPlanilha
		SZQ->ZQ_CLIENTE := cCliente
		SZQ->ZQ_LOJA	:= cLoja
		SZQ->ZQ_PATRIM	:= cNumchapa
		SZQ->ZQ_VALOR	:= nValor
		SZQ->ZQ_DATAINS	:= dData
		SZQ->( MsUnLock() )
		lRet := .T.		
	EndIf
	
// remocao
ElseIf nTipo == 2
	ChkRem(cContrato, cPlanilha, cNumchapa, cCliente, cLoja, cNumchapa,@nRecSZQ)
	If nRecSZQ > 0
		dbSelectArea("SZQ")
		dbGoTo(nRecSZQ)
		If RecLock("SZQ",.F.)
			SZQ->ZQ_DATAREM	:= dData
	   		SZQ->( MsUnLock() )
   			lRet := .T.
		EndIf
	EndIf	         
EndIf
	
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChkPatrim ºAutor  ³Jackson E. de Deus  º Data ³  08/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o patrimonio esta instalado em mais de um       º±±
±±º          ³contrato/planilha                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChkPatrim(cPatrim,nRecSZQ)

Local lRet := .F.
Local cQuery := ""
Local nTot := 0

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZQ") + " WHERE ZQ_PATRIM = '"+cPatrim+"' AND ZQ_DATAREM = '' AND D_E_L_E_T_ = '' "           

If Select("TRBP") > 0
	TRBP->( dbCloseArea() )
EndIf                     

TcQuery cQuery New Alias "TRBP"

dbSelectArea("TRBP")
nTot := TRBP->TOTAL

dbCloseArea()

If nTot > 0
	lRet := .T.
	cQuery := "SELECT R_E_C_N_O_ ZQREC FROM " +RetSqlName("SZQ") + " WHERE ZQ_PATRIM = '"+cPatrim+"' AND ZQ_DATAREM = '' AND D_E_L_E_T_ = '' "           

	If Select("TRBP") > 0
		TRBP->( dbCloseArea() )
	EndIf                     
	
	TcQuery cQuery New Alias "TRBP"
	
	dbSelectArea("TRBP")
	nRecSZQ := TRBP->ZQREC
	
	dbCloseArea()
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA14  ºAutor  ³Microsiga           º Data ³  09/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChkRem(cContrato, cPlanilha, cNumchapa, cCliente, cLoja, cNumchapa,nRecSZQ)
             
Local cQuery := ""

cQuery := "SELECT R_E_C_N_O_ ZQREC FROM " +RetSqlName("SZQ")
cQuery += " WHERE ZQ_CONTRA = '"+cContrato+"' AND ZQ_PLAN = '"+cPlanilha+"' AND ZQ_PATRIM = '"+cNumchapa+"' "
cQuery += " AND ZQ_CLIENTE = '"+cCliente+"' AND ZQ_LOJA = '"+cLoja+"' AND ZQ_DATAREM = '' AND D_E_L_E_T_ = '' "           

If Select("TRBP") > 0
	TRBP->( dbCloseArea() )
EndIf                     

TcQuery cQuery New Alias "TRBP"

dbSelectArea("TRBP")
nRecSZQ := TRBP->ZQREC
	
dbCloseArea()

Return