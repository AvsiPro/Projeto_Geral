

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MBM007    �Autor  �Jackson E. de Deus  � Data �  21/06/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna as OS canceladas                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MBM007(Atendente)

           
Local cJson := ""
Local oItem := Nil
Local aJson := {}
Local oObj := Nil
Local cStatus := ""
Local aDados := {} 
Local cQuery := ""

If cEmpAnt <> "01"
	Return
EndIf

cQuery := "SELECT ZG_NUMOS FROM " +RetSqlName("SZG") +" WITH (NOLOCK) "
cQuery += " WHERE "
cQuery += "( "
cQuery += "	( ZG_CODTEC = '"+Atendente+"' AND ZG_STATUS IN ('CTEC','COPE','CCLI') AND ZG_DTCANC >= '"+DTOS(Date()-2)+"' ) "
cQuery += "	OR "
cQuery += "	( ZG_OBS LIKE '%TRANSFERIDA - AGENTE ANT.: "+Atendente+"%' AND ZG_DATAINI >= '"+DTOS(Date()-2)+"' ) "
cQuery += ")"
cQuery += " AND D_E_L_E_T_ = '' "

MPSysOpenQuery( cQuery , "TRBZ" )  

dbSelectArea("TRBZ")

While !EOF()	
	oItem := JsonObject():New()
	oItem:PutVal("os", Val(TRBZ->ZG_NUMOS) )			
	AADD(aJson,oItem)
		
	TRBZ->(dbSkip())
End	

oObj := JsonObject():New()
If !Empty(aJson)
	oObj:PutVal("status","ok")
	oObj:PutVal("result","")
	oObj:PutVal("lista",aJson)
	cJson := oObj:ToJson()
Else
	oObj:PutVal("status","ok")
	oObj:PutVal("result","")
	oObj:PutVal("lista","[]")
	cJson := oObj:ToJson()	
EndIf


Return cJson