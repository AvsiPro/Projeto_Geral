#INCLUDE 'PROTHEUS.CH'
#Include 'TopConn.ch'
#include 'tbiconn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSD2520  �Autor  �RODRIGO BARRETO   � Data �  31/10/2022   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na exclusao da NFs de saida para estornar  ���
���          �o movimento interno de distribuicao                         ���
�������������������������������������������������������������������������͹��
���Uso       � CONNECT                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MSD2520()

	Local cTMEst      	:=  GetMv("MV_XTESD3",,"501")
	//Local cTM			:=	GetMv("MV_XTMSD3",,"001")
	Local aArea			:=	GetArea()
	Local _aCab1 		:= 	{}
	Local _aItem 		:= 	{}
	Local _atotitem		:=	{}
	//Local n             :=  0

	Private aEst 		:=	{} //estrutura produto
	Private aAuxest 	:=	{}
	Private lMsHelpAuto := 	.T. // se .t. direciona as mensagens de help
	Private lMsErroAuto := 	.F. //necessario a criacao

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO )) .AND. !Empty(SC5->C5_XCODPA) .AND. SC5->C5_XTPPED == "A"

		_aCab1 := {{"D3_DOC" ,SD2->D2_DOC, NIL},;
					{"D3_TM" ,cTMEst , NIL},;
					{"D3_CC" ,"        ", NIL},;
					{"D3_EMISSAO" ,ddatabase, NIL}}

		_aItem:={{"D3_COD" ,SD2->D2_COD ,NIL},;
				{"D3_UM" ,SD2->D2_UM ,NIL},;
				{"D3_QUANT" , SD2->D2_QUANT ,NIL},;
				{"D3_LOCAL" ,SC5->C5_XCODPA ,NIL},;
				{"D3_LOTECTL" ,"",NIL},;
				{"D3_LOCALIZ" , "",NIL}}

		aadd(_atotitem,_aitem)
		

	ElseIf SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO )) .AND. SC5->C5_XTPPED == "F"
		cUpd := "UPDATE Z08010 SET Z08_NOTA=' ',Z08_SERIE=' '"
		cUpd += " WHERE Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_CONTRT='"+SC5->C5_XCONTRT+"'"
		cUpd += " AND Z08_PEDIDO='"+SC5->C5_NUM+"' AND Z08_NOTA='"+SD2->D2_DOC+"'"
		cUpd += " AND Z08_SERIE='"+SD2->D2_SERIE+"' AND D_E_L_E_T_=' '"
		TcSqlExec(cUpd)

	ElseIf SC5->C5_XTPPED == "I"
		atucontr(SC6->C6_CONTRT,SC6->C6_ITCONTR)
	else
		RestArea(aArea)
		return(nil)
	EndIf

	SC5->(DBCloseArea())

	
	If len(_aCab1) > 0 .AND. len(_atotitem) > 0 
		MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
		
		If lMsErroAuto
			Mostraerro()
			DisarmTransaction()
			break

		EndIf
	EndIf 
	

	RestArea(aArea)
Return

/*/{Protheus.doc} atucontr
	(long_description)
	@type  Static Function
	@author user
	@since 05/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function atucontr(cContrt,cItCont)

Local aArea  :=	GetArea()
Local cQuery :=	""
Local cMaq   :=	""
Local lOK    :=	.T.
Local nRecno := 0

DbSelectArea("AAM")
DbSetOrder(1)
Dbseek(xFilial("AAM")+cContrt)

DbSelectArea("AAN")
DbSetOrder(1)
If Dbseek(xFilial("AAN")+cContrt+cItCont)
	RecLock("AAN", .F.)
	cMaq := AAN->AAN_XCBASE
	DBDelete()
	AAN->(MsUnlock())
EndIf 

DbSelectArea("AA3")
DbSetOrder(1)
if DBSEEK(xFilial("AA3") + AAM->AAM_CODCLI + AAM->AAM_LOJA + AAN->AAN_CODPRO + Posicione("SN1", 2, xFilial("SN1") + AvKey(AAN->AAN_XCBASE, "N1_CBASE"), "N1_XNUMSER") + xFilial("AA3"))
	RecLock("AA3", .F.)
		DBDelete()
	AA3->(MsUnlock())
endif

DbSelectArea("AA4")
DbSetOrder(2)
if DBSEEK(xFilial("AA4") + AAM->AAM_CODCLI + AAM->AAM_LOJA + AAN->AAN_CODPRO + AAN->AAN_XCBASE)
	RecLock("AA4", .F.)
		DBDelete()
	AA4->(MsUnlock())
endif

DbSelectArea("SN1")
DbSetOrder(2)
if DBSEEK(xFilial("SN1")+AvKey(cMaq, "N1_CBASE"))
	RecLock("SN1", .F.)
		SN1->N1_XCLIENT := ""
		SN1->N1_XLOJA   := ""	
	MsUnlock()
endif

cQuery := " SELECT AAN_CONTRT FROM " + RetSQLName("AAN") + " WHERE AAN_CONTRT = '" + cContrt + "' "
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " AND AAN_FILIAL = '" + xFilial("AAN") + "' "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("MSD2520.SQL",cQuery)
cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
DbSelectArea("TRB")   

while !EOF()
	lOK := .F.
	DBSKIP()
end

if lOK
	cQuery := " SELECT R_E_C_N_O_ AS ALIASREC, AAN_CODPRO FROM " + RetSQLName("AAN") + " WHERE AAN_CONTRT = '" + cContrt + "'"

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	
	MemoWrite("MSD2520.SQL",cQuery)
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	DbSelectArea("TRB")   

	while !EOF()
		if AllTrim(TRB->AAN_CODPRO) == "CONTRATO"
			nRecno := TRB->ALIASREC
		endif
		DBSKIP()
	end

	DbSelectArea("AAN")
	DBGOTO( nRecno )
	RecLock("AAN", .F.)
	DBRecall()
	AAN->(MsUnlock())

endif

RestArea(aArea)

Return
