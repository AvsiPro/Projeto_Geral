#include "tbiconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTESTMOV    Autor  ³Jackson E. de Deus º Data ³  04/06/17   º±±
±±º									Xcode Mobile						  º±±	
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Estorno dos movimentos                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTESTMOV( cArmazem,dDiaIni,dDiaFim,cHrInicio )
                  

Local dDia	:= NIL
Local nExec := 0
Local lEnd := .F.

Default cArmazem := ""
Default dDiaIni := dDatabase
Default dDiaFim := dDatabase
Default cHrInicio := "00:00:00"

If cEmpAnt == "01"
	
	If Empty(cArmazem)
		MsgAlert("Informar o armazem")
		Return
	EndIf
	
	If MsgYesNo("Confirma o estorno dos movimentos?")
		Processa( { |lEnd| fPRoc(cArmazem,dDiaIni,dDiaFim,cHrInicio ),"Estorno"} )
	EndIf
EndIF

Return
 
//prepare environment empresa "01" filial "01"

Static Function fProc(cArmazem,dDiaIni,dDiaFim,cHrInicio )

Local cQuery1 := ""
Local cQuery2 := ""
Local cQuery3 := ""
Local cQuery4 := "" 
Local cQuery5 := "" 

If !Empty( cArmazem ) 

	If SubStr( cArmazem,1,1 ) == "P"
		//cArmazem := "A" +SubStr( cArmazem,2 ) 
		cArmA := "A" +SubStr( cArmazem,2 ) 
	EndIf

	ProcRegua(5)
	
	
	IncProc("Movimentos SZ0")
	
	// estorna SZ0
	cQuery1 := "UPDATE " +RetSqlName("SZ0") +" SET D_E_L_E_T_ = '*' " 
	cQuery1 += " WHERE Z0_NUMOS IN ( "
	cQuery1 += 						" SELECT ZG_NUMOS FROM " +RetSqlName("SZG") 
	cQuery1 += 						" WHERE "
	
	If Substr(cArmazem,1,1) == "R"
		cQuery1 += " ZG_ROTA = '"+cArmazem+"' "
	Else 
		cQuery1 += " ZG_PA = '"+cArmazem+"' "
	EndIf
	
	cQuery1 += 	" AND ZG_FORM IN ('04','08') "

	//cQuery1 += " AND ZG_DATAFIM BETWEEN '"+dtos(dDiaIni)+"' AND '"+DTOS(dDiaFim)+"' "
	cQuery1 += 						" AND ( "
	cQuery1 += 						" ( ZG_DATAFIM = '"+dtos(dDiaIni)+"' AND ZG_HORAFIM > '"+cHrInicio+"' ) "
	cQuery1 += 						" OR "
	cQuery1 += 						" ( ZG_DATAFIM BETWEEN '"+dtos(dDiaIni+1)+"' AND '"+dtos(dDiaFim)+"' ) "
	cQuery1 += 						" ) "
	
	cQuery1 += " ) "
	
	nExec := TCSQLExec(cQuery1)
	If nExec < 0
		MsgStop( "ERRO " +CRLF + TCSQLError() )
	EndIf
	
	
	IncProc("Movimentos SZ5")
		
	// estorna SZ5
	cQuery2 := "UPDATE " +REtSqlName("SZ5") +" SET D_E_L_E_T_ = '*' " 
	cQuery2 += " WHERE Z5_NUMOS IN ( "
	cQuery2 += 						" SELECT ZG_NUMOS FROM " +RetSqlName("SZG") 
	cQuery2 +=						" WHERE "
	
	If Substr(cArmazem,1,1) == "R"
		cQuery2 += " ZG_ROTA = '"+cArmazem+"' "
	Else 
		cQuery2 += " ZG_PA = '"+cArmazem+"' "
	EndIf
	
	cQuery2 += 	" AND ZG_FORM IN ('04','08') "
	
	//cQuery2 += " AND ZG_DATAFIM BETWEEN '"+DTOS(dDiaIni)+"' AND '"+DTOS(dDiaFim)+"' "
	cQuery2 += 							" AND ( "
	cQuery2 += 									" ( ZG_DATAFIM = '"+dtos(dDiaIni)+"' AND ZG_HORAFIM > '"+cHrInicio+"' ) "
	cQuery2 += 									" OR "
	cQuery2 += 									" ( ZG_DATAFIM BETWEEN '"+dtos(dDiaIni+1)+"' AND '"+dtos(dDiaFim)+"' ) "
	cQuery2 += 							" ) "  
	
	cQuery2 += 	" ) "  
	  
	nExec := TCSQLExec(cQuery2)
	If nExec < 0
		MsgStop( "ERRO " +CRLF + TCSQLError() )
	EndIf
	
	IncProc("Movimentos SZ7")
	
	// acerta sz7 
	cQuery3 := "UPDATE " +RetSqlName("SZ7") +" SET Z7_QATU = Z7_QUANT WHERE Z7_ARMMOV = '"+cArmazem+"' "
	cQuery3 += " AND Z7_SAIDA BETWEEN '"+DTOS(dDiaIni)+"' AND '"+dtos(dDiaFim)+"' AND D_E_L_E_T_ = '' "
	
	nExec := TCSQLExec(cQuery3)
	If nExec < 0
		MsgStop( "ERRO " +CRLF + TCSQLError() )
	EndIf
	
	
	IncProc("Saldos SZ6")
		
	// acerta SZ6
	cQuery4 := "UPDATE " +RetSqlName("SZ6") 
	cQuery4 += " SET Z6_QATU = ( SELECT ISNULL(SUM(Z5_QUANT),0) FROM " +RetSqlName("SZ5") +" SZ5 "
	cQuery4 += 					" WHERE Z5_LOCAL = Z6_LOCAL AND Z5_COD = Z6_COD AND SZ5.D_E_L_E_T_ = '' "  
	cQuery4 +=					" AND Z5_TM = '100' AND Z5_OBS LIKE '%ENTRADA DE MERCADORIA%' " 
	
	cQuery4 += 					" AND ( ( Z5_EMISSAO = '"+dtos(dDiaIni)+"' AND Z5_HORA > '"+cHrInicio+"' ) "
	cQuery4 += 					" OR " 
	cQuery4 += 					"( Z5_EMISSAO BETWEEN '"+DTOS(dDiaIni+1)+"' AND '"+DTOS(dDiaFim)+"' ) ) ) " 

	cQuery4 += " WHERE "                   
	
	If SubStr( cArmazem,1,1 ) == "R"
		cQuery4 +=  "Z6_LOCAL = '"+cArmazem+"' 
	Else
		cQuery4 +=  "Z6_LOCAL = '"+cArmA+"' 
	EndIf
	 
	cQuery4 += " AND D_E_L_E_T_ = '' "

		
	nExec := TCSQLExec(cQuery4)
	If nExec < 0
		MsgStop( "ERRO " +CRLF + TCSQLError() )
	EndIf
	
	IncProc("Estorno OS")
	
	// reprocessamento OS 
	cQuery5 := " UPDATE " +REtSqlName("SZG") +" SET ZG_PROC = '' WHERE ZG_ROTA = '"+cArmazem+"' AND ZG_DATAFIM BETWEEN '"+DTOS(dDiaIni)+"' AND '"+DTOS(dDiaFim)+"' AND ZG_FORM IN ('04','08') " 
	
	nExec := TCSQLExec(cQuery5)
	If nExec < 0
		MsgStop( "ERRO " +CRLF + TCSQLError() )
	EndIf
	                   
EndIf
 
//reset environment      

Return