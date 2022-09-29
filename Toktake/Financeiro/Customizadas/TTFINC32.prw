#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � TTFINC32 � Autor � Alexandre Venancio    � Data � 06/11/14 ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �  Controle de Materiais em poder de tecnicos                ���
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

User Function TTFINC32
 
Local aArea	:=	GetArea()
Private oList
Private aList := {}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho') 
Private cNumSer	:= space(15) 
Private cResp	:= space(6)
Private aCor 	:= {"1=Cinza","2=Laranja","3=Preto","4=Branco","5=Amarelo","6=Vermelho","7=Sem cor","8=A�o"}
Private aTipo   := {"1=Lacre","2=Bananinha","3=Glenview","4=POS","5=Caneta","6=Chave","7=Moedeiro","8=Ceduleiro"}	// AJUSTAR OPCOES
Private xCombo1	:= aCor[1]
Private xCombo2 := aTipo[1]
SetPrvt("oDlg1","oGrp1","oBrw1","oBtn1","oBtn2","oBtn3","oGrp2","oSay1","oSay2","oSay3","oSay4","oSay5")
SetPrvt("oCBox1","oCBox2","oGet2","oBtn4")
              
//prepare environment empresa "01" filial "01"

Aadd(aList,{.T.,'','','','','','','','','',''})

oDlg1      := MSDialog():New( 091,232,565,924,"Materiais em poder de t�cnicos",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,156,336,"Materiais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oList := TCBrowse():New(014,008,322,135,, {'','Num Serie','Tipo','Cor','Data Retirada','Data Utiliza��o','Data Devolu��o','Patrimonio'},{10,40,40,40,40,40,40,40},;
	                            oGrp1,,,,{|| },{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06],;
	                     aList[oList:nAt,07],;
	                     aList[oList:nAt,08]}}

oGrp2      := TGroup():New( 160,004,224,236,"Adicionar",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 172,008,{||"Respons�vel"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oGet1      := TGet():New( 172,072,{|u|If(Pcount()>0,cResp:=u,cResp)},oGrp2,040,008,'',{||If(!empty(cResp),busca(cResp),)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"AA1","",,)
	oSay5      := TSay():New( 172,116,{||"Nome"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
	
	oSay2      := TSay():New( 184,008,{||"Cor"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oCBox1     := TComboBox():New( 184,072,{|u|If(Pcount()>0,xCombo1:=u,xCombo1)},aCor,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay4      := TSay():New( 196,008,{||"Tipo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oCBox2     := TComboBox():New( 196,072,{|u|If(Pcount()>0,xCombo2:=u,xCombo2)},aTipo,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay3      := TSay():New( 208,008,{||"Numero S�rie"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oGet2      := TGet():New( 208,072,{|u|If(Pcount()>0,cNumSer:=u,cNumSer)},oGrp2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
oBtn1      := TButton():New( 164,244,"Incluir",oDlg1,{|| incluir()},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 164,296,"Excluir",oDlg1,{|| excluir()},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 184,244,"Retornar",oDlg1,{|| retorno()},037,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 184,296,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )


oDlg1:Activate(,,,.T.)
      
RestArea(aArea)

Return  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC32  �Autor  �Microsiga           � Data �  11/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Busca material em aberto com o tecnico                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Busca(cResp)

Local aArea	:=	GetArea()
Local cQuery

If !existcpo("AA1",cResp)
	Return
EndIf

aList := {}
cQuery := "SELECT * FROM "+RetSQLName("ZZO")
cQuery += " WHERE ZZO_RESPON='"+cResp+"' AND ZZO_DATRET='' AND D_E_L_E_T_=''"

oSay5:settext("")
oSay5:settext(Posicione("AA1",1,xFilial("AA1")+cResp,"AA1_NOMTEC"))

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("TTFINC32.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

While !EOF()  
//'','Num Serie','Tipo','Cor','Data Retirada','Data Utiliza��o','Data Devolu��o','Patrimonio'
  	Aadd(aList,{.F.,TRB->ZZO_LACRE,aTipo[Ascan(aTipo,{|x| substr(x,1,1) == TRB->ZZO_TIPO})],;
  				aCor[Ascan(aCor,{|x| substr(x,1,1) == If(Empty(TRB->ZZO_CORLAC),'7',TRB->ZZO_CORLAC)})],;
  				dtoc(stod(TRB->ZZO_DATSAI)),;
  				dtoc(stod(TRB->ZZO_DATUTI)),dtoc(stod(TRB->ZZO_DATRET)),TRB->ZZO_PATRIM,TRB->R_E_C_N_O_})
	Dbskip()
EndDo

If len(aList) > 0

Else
	Aadd(aList,{.F.,'','','','','','','','','','',''})
EndIf

	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06],;
	                     aList[oList:nAt,07],;
	                     aList[oList:nAt,08]}}
	oList:refresh()
	oDlg1:refresh()
	
RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC32  �Autor  �Microsiga           � Data �  11/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Incluir material para o tecnico.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function incluir()
 
Local nRec := 0 

If !existcpo("AA1",cResp)
	Return
EndIf

If empty(cNumSer) .or. empty(cResp) .or. empty(xCombo1) .or. empty(xCombo2)
	MsgAlert("Todas as informa��es devem ser preenchidas","incluir - TTFINC32")
	Return
Else
    //Primeiro verifica se o pos existe na base antes de amarra-lo ao tecnico
    If substr(xCombo2,1,1) == "4"
    	DbSelectArea("ZZN")
    	DbSetOrder(2)
    	If !DbSeek(xFilial("ZZN")+cNumSer)
    		MsgAlert("N�o existe este PDV cadastrado na tabela de POS�s","incluir - TTFINC32")
    		Return
    	EndIf
    EndIf
    
  	DbSelectArea("ZZO")
  	Reclock("ZZO",.T.)
  	ZZO->ZZO_LACRE 	:= 	cNumSer
  	ZZO->ZZO_TIPO 	:=	Substr(xCombo2,1,1)
  	ZZO->ZZO_CORLAC	:=	if(substr(xCombo1,1,1)<>'7',substr(xCombo1,1,1),'')
  	ZZO->ZZO_DATSAI	:=	ddatabase
  	ZZO->ZZO_RESPON	:= 	cResp
  	nRec := Recno()
  	ZZO->(Msunlock()) 
  	
  	//atrelar o pos ao atendente da tecnica
  	If Substr(xCombo2,1,1) == "4"
		DbSelectArea("ZZN")
		DbSetOrder(2)
    	DbSeek(xFilial("ZZN")+cNumSer)
    	Reclock("ZZN",.F.)
    	ZZN->ZZN_LOCALZ := "3"
  	EndIf
  	
	Aadd(aList,{.T.,cNumSer,aTipo[Ascan(aTipo,{|x| substr(x,1,1) == substr(xCombo2,1,1)})],;
				aCor[Ascan(aCor,{|x| substr(x,1,1) == substr(xCombo1,1,1)})],;
				ddatabase,ctod(' / / '),ctod(' / / '),'',nRec})
	 
	cNumSer := space(15)
	//xCombo1 := aCor[1]
	//xCombo2 := aTipo[1]
	
	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06],;
	                     aList[oList:nAt,07],;
	                     aList[oList:nAt,08]}}
	oList:refresh()
	oDlg1:refresh()
EndIf

Return       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC32  �Autor  �Microsiga           � Data �  11/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Excluir registros na ZZO                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function excluir()
                          
Local dData1 := ctod(' / / ')
Local dData2 := ctod(' / / ')

If !Empty(aList[oList:nAt,09])
	If Valtype(aList[oList:nAt,06]) == "C"
		dData1 := ctod(aList[oList:nAt,06])
	Else
		dData1 := aList[oList:nAt,06]
	EndIf                         
	
	If Valtype(aList[oList:nAt,07]) == "C"
		dData2 := ctod(aList[oList:nAt,07])
	Else
		dData2 := aList[oList:nAt,07]
	EndIf
	
	If !Empty(dData1) .or. !Empty(dData2) .Or. !Empty(aList[oList:nAt,08])
		MsgAlert("S� � permitido excluir um material que n�o tenha sido utilizado em campo","excluir - TTFINC32")
		Return
	EndIf
		
	DbSelectArea("ZZO")
	DbGoto(aList[oList:nAt,09])  
	Reclock("ZZO",.F.)
	Dbdelete()
	ZZO->(Msunlock()) 
	
	If substr(aList[oList:nAt,03],1,1) == "4"
		DbSelectArea("ZZN")
		DbSetOrder(2)
    	DbSeek(xFilial("ZZN")+aList[oList:nAt,02])
    	Reclock("ZZN",.F.)
    	ZZN->ZZN_LOCALZ := "2"
  	EndIf

	ADEL(aList,oList:nAt)
	ASIZE(aList,Len(aList)-1) 
  	
	If len(aList) < 1
		Aadd(aList,{.F.,'','','','','','','','','','',''})
	EndIf
	
	
	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06],;
	                     aList[oList:nAt,07],;
	                     aList[oList:nAt,08]}}
	oList:refresh()
	oDlg1:refresh()
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC32  �Autor  �Microsiga           � Data �  11/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Retornar material                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function retorno()

//'','Num Serie','Tipo','Cor','Data Retirada','Data Utiliza��o','Data Devolu��o','Patrimonio'

If !Empty(aList[oList:nAt,09])
	If Valtype(aList[oList:nAt,06]) == "C"
		dData1 := ctod(aList[oList:nAt,06])
	Else
		dData1 := aList[oList:nAt,06]
	EndIf                         
	
	If Valtype(aList[oList:nAt,07]) == "C"
		dData2 := ctod(aList[oList:nAt,07])
	Else
		dData2 := aList[oList:nAt,07]
	EndIf
	
	If !Empty(dData1) .or. !Empty(dData2) .Or. !Empty(aList[oList:nAt,08])
		MsgAlert("S� � permitido retornar um material que n�o tenha sido utilizado em campo","excluir - TTFINC32")
		Return
	EndIf
	DbSelectArea("ZZO")
	DbGoto(aList[oList:nAt,09])  
	Reclock("ZZO",.F.)
	ZZO->ZZO_DATRET	:=	Ddatabase
	ZZO->(Msunlock()) 
    
	aList[oList:nAt,07] := ddatabase
	
	If substr(aList[oList:nAt,03],1,1) == "4"
		DbSelectArea("ZZN")
		DbSetOrder(2)
    	DbSeek(xFilial("ZZN")+aList[oList:nAt,02])
    	Reclock("ZZN",.F.)
    	ZZN->ZZN_LOCALZ := "2"
  	EndIf
  	
	oList:refresh()
	oDlg1:refresh()

EndIf

Return