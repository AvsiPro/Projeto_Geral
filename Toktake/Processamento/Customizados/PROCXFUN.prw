#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC03  บAutor  ณJackson E. de Deus  บ Data ณ  29/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca o proximo numero para a tabela/campo informados.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC03(cAlias,cCampo)
           
Local lVld		:= .F.
Local aArea		:= GetArea()
Local cNum		:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK001",.T.,"000001"),"")

If cEmpAnt <> "01"
	return
EndIF

dbSelectArea(cAlias)
dbSetOrder(1)
dbGoTop()
                
//cNum := (cAlias)->&cCampo
While !lVld
	If dbSeek(xFilial(cAlias) +AvKey(cNum,cCampo))
		cNum := SOMA1(cNum)
	Else
		lVld := .T.	
	EndIf
End
dbCloseArea()
RestArea(aArea)

Return cNum



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC04  บAutor  ณJackson E. de Deus  บ Data ณ  06/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida caracteres digitados no campo.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cadastro de Tarefas                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC04(cString)

Local lRet := .T.
Default cString := ""
     
If cEmpAnt <> "01"
	return lRet
EndIF
If Empty(cString)
     Return lRet
EndIf

If '-' $ cString
	Help( ,, 'TTPROC04',, "Caractere '-' nใo permitido.", 1, 0)
	//ShowHelpDlg("XPROC02",{"Caractere '-' nใo permitido."},5,{"Corrija o conte๚do do campo."},5)
	lRet := .F.
	Return lRet
EndIf                                                             

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC18  บAutor  ณJackson E. de Deus  บ Data ณ  21/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se ja existe a OS gravada na base de dados.		  บฑฑ
ฑฑบ          ณTabela SZN.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Integracao Keeple                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC18(cFilAgente, cNumOS, cNumChapa, dData, cHora)

Local lRet := .F.
Local cQuery := ""

Default cFilial := Nil
Default cNumOS := Nil
Default cNumChapa := Nil
Default dData := Nil
Default cHora := Nil 

If cEmpAnt <> "01"
	return lRet
EndIF

If cFilAgente == NIl .Or. cNumOS == Nil .Or. cNumChapa == Nil .Or. dData == Nil .Or. cHora == Nil
	Aviso("TTPROC18","Nใo ้ possํvel validar a exist๊ncia da Ordem de Servi็o." +CRLF +"Verifique os parโmrtros enviados.",{"Ok"})
	Return .T.
EndIf

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZN")
cQuery += " WHERE ZN_NUMOS = '"+cNumOS+"' AND D_E_L_E_T_ = '' "
If Select("TRBZN") > 0
	TRBZN->(dbCloseArea())
EndIf                    

TcQuery cQuery New alias "TRBZN"

dbSelectArea("TRBZN")
If TRBZN->TOTAL > 0
	lRet := .T.
EndIf

TRBZN->( dbCloseArea() )

/*
cQuery := "SELECT * FROM " +RetSqlName("SZN")
cQuery += " WHERE ZN_FILIAL = '"+cFilAgente+"' AND ZN_PATRIMO = '"+cNumChapa+"' AND ZN_DATA = '"+DtoS(dData)+"' AND ZN_TIPINCL = 'MOBILE' AND D_E_L_E_T_ = '' "
If Select("TRBZN") > 0
	TRBZN->(dbCloseArea())
EndIf                    

TcQuery cQuery New alias "TRBZN"

dbSelectArea("TRBZN")
While TRBZN->ZN_FILIAL == "01" .And. AllTrim(TRBZN->ZN_PATRIMO) == AllTrim(cNumChapa) .And. TRBZN->ZN_DATA == DTOS(dData) .And. TRBZN->(!EOF())
	If TRBZN->ZN_NUMOS == cNumOS .And. TRBZN->ZN_HORA == cHora
 		Aviso("TTPROC17","A Ordem de Servi็o jแ estแ gravada no sistema.",{"Ok"})
   		lRet := .T.
   EndIf
   dbSkip()
End
*/
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC23  บAutor  ณJackson E. de Deus  บ Data ณ  02/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se as notas fiscais devem ser classificadas.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC23(aDadosWS)
      
Local cQuery := ""
Local cNumOS := ""
Local nI
Local aRet := {}       

Default aDadosWS := {}

If cEmpAnt <> "01"
	return
EndIF

If Len(aDadosWS) == 0
	Return
EndIf

For nI := 1 To Len(aDadosWS)
	cNumOS += "'" +aDadosWS[nI][1][2] +"'"
	If nI <> Len(aDadosWS)
		cNumOS += ","
	EndIf
Next nI

If AllTrim(cNumOS) == ""
	Return
EndIf

cQuery := "SELECT F1_FILIAL, F1_STATUS, F1_XWSOSR NUMOS, R_E_C_N_O_ F1REC FROM " +RetSqlName("SF1") + " WHERE F1_XWSOSR IN ("+cNumOS+") AND D_E_L_E_T_ = '' "

If Select("TRBA") > 0
	TRBA->( dbCloseArea() ) 
EndIf                     

TcQuery cQuery New Alias "TRBA"

dbSelectArea("TRBA")
While TRBA->( !EOF() )
	If TRBA->F1_FILIAL == "01"
		cMsg := "NF MATRIZ"		
	ElseIf TRBA->F1_FILIAL <> "01" .And. AllTrim(TRBA->F1_STATUS) == ""
	 	cMsg := "CLASSIFICAR"					
	EndIf
	
	AADD(aRet, { TRBA->NUMOS,;
				If(cMsg == "CLASSIFICAR",.T.,.F.),;
				cMsg })
	TRBA->( dbSkip() )						
End

Return aRet