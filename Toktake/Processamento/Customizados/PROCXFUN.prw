#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC03  �Autor  �Jackson E. de Deus  � Data �  29/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca o proximo numero para a tabela/campo informados.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC04  �Autor  �Jackson E. de Deus  � Data �  06/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida caracteres digitados no campo.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de Tarefas                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	Help( ,, 'TTPROC04',, "Caractere '-' n�o permitido.", 1, 0)
	//ShowHelpDlg("XPROC02",{"Caractere '-' n�o permitido."},5,{"Corrija o conte�do do campo."},5)
	lRet := .F.
	Return lRet
EndIf                                                             

Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC18  �Autor  �Jackson E. de Deus  � Data �  21/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se ja existe a OS gravada na base de dados.		  ���
���          �Tabela SZN.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Integracao Keeple                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	Aviso("TTPROC18","N�o � poss�vel validar a exist�ncia da Ordem de Servi�o." +CRLF +"Verifique os par�mrtros enviados.",{"Ok"})
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
 		Aviso("TTPROC17","A Ordem de Servi�o j� est� gravada no sistema.",{"Ok"})
   		lRet := .T.
   EndIf
   dbSkip()
End
*/
Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC23  �Autor  �Jackson E. de Deus  � Data �  02/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se as notas fiscais devem ser classificadas.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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