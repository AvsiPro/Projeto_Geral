#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �         � Autor �                       � Data �           ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �  Consulta tabela de log generica para venda perdida        ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function JGENX010(cOpc,cDoc,cTab2)

Local aArea	:=	GetArea()
Local aList	:=	busca(cOpc,cDoc,cTab2)

Default cTab2 := ''

SetPrvt("oDlg1","oBtn1")

If len(aList) > 0
	//ZL_TIPOMOV,ZL_DOCTO,ZL_USUARIO,ZL_DATA,ZL_HORA,ZL_OBS
	oDlg1      := MSDialog():New( 092,232,542,1234,"Log de altera��es",,,.F.,,,,,,.T.,,,.T. )
	//oBrw1      := MsNewGetDados():New(000,004,200,492,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1 )
	oList 	   := TCBrowse():New(010,010,485,185,, {'Tipo Mov','Docto','Usu�rio','Data','Hora','Altera��o'},{40,40,40,40,40,140},;
	                        oDlg1,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],;
						aList[oList:nAt,02],;
	 					aList[oList:nAt,03],;
	 					aList[oList:nAt,04],;
						aList[oList:nAt,05],;
	 					aList[oList:nAt,06]}}
	
	oBtn1      := TButton():New( 203,208,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
Else
	MsgAlert("N�o h� logs registrados para o item selecionado")
EndIf

RestArea(aArea)

Return

Static Function busca(cOpc,cDoc,cTab2)

Local cQuery 
Local aRet	:=	{}

cQuery	:=	"SELECT ZL_TIPOMOV,ZL_DOCTO,ZL_USUARIO,ZL_DATA,ZL_HORA,ZL_OBS FROM "+RetSQLName("SZL")
cQuery 	+=	" WHERE ZL_FILIAL='"+xFilial(cOpc)+"'"

If Empty(cTab2)
	cQuery  += 	" AND ZL_TABELA='"+cOpc+"'"
Else 
	cQuery  += 	" AND ZL_TABELA IN('"+cOpc+"','"+cTab2+"')"
EndIF 

cQuery	+=	" AND D_E_L_E_T_=' '"

cQuery  += 	" AND ZL_DOCTO='"+cvaltochar(cDoc)+"' ORDER BY R_E_C_N_O_"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("AMCFSR01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)  

While !EOF()
	Aadd(aRet,{TRB->ZL_TIPOMOV,TRB->ZL_DOCTO,TRB->ZL_USUARIO,STOD(TRB->ZL_DATA),TRB->ZL_HORA,TRB->ZL_OBS})
	Dbskip()
EndDo
Return(aRet)
