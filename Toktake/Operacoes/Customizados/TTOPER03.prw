#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTOPER03  ºAutor  ³Jackson E. de Deus  º Data ³  17/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui o patrimonio do plano de trabalho                    º±±
±±º          ³Utilizado na remocao de maquina via OMM                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTOPER03(cCliente, cLoja, cNumChapa)

Local aArea := GetArea()
Local lRet := .F.          
Local cQuery := ""              
Local cData := FirstDay(dDatabase)
Local cAuxData := ""
Local nRecnoZE := 0

Default cCliente := ""
Default cLoja := ""
Default cNumChapa := ""
    
// Verifica parametros
If Empty(cCliente) .Or. Empty(cLoja) .Or. Empty(cNumChapa)
	Return
EndIf

If cEmpAnt == "01"
	// Monta query
	cQuery := "SELECT SUBSTRING(ZE_MENSAL,1,6) MENSAL, R_E_C_N_O_ ZEREC FROM " +RetSqlName("SZE")
	cQuery += " WHERE ZE_CLIENTE = '"+cCliente+"' AND ZE_LOJA = '"+cLoja+"' "
	cQuery += " AND ZE_CHAPA = '"+cNumChapa+"' "                                                         
	cQuery += " AND D_E_L_E_T_ = '' "
	
	If Select("TRBZE") > 0
		TRBZE->( dbCloseArea() )
	EndIf                       
	
	TcQuery cQuery New Alias "TRBZE"
	
	dbSelectArea("TRBZE")
	While !EOF()
		nRecnoZE := TRBZE->ZEREC
		cAuxData := TRBZE->MENSAL +"01"
		cAuxData := StoD(cAuxData)
		cAuxData := LastDay(cAuxData)
		
		// mensal = ou > que data atual
		If cAuxData >= cData
			dbSelectArea("SZE")
			dbGoTo(nRecnoZE)
			RecLock("SZE",.F.)
			dbDelete()
			SZE->( MsUnLock() )
			lRet := .T.
		EndIf
		
		dbSelectArea("TRBZE")
		TRBZE->( dbSkip() )
	End
	
	TRBZE->( dbCloseArea() )
EndIf
            
RestArea(aArea)

Return lRet