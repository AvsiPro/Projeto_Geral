#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF240BUT  �Autor  �Alexandre Venancio  � Data �  05/31/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para incluir botoes no browse da classificacao de ativos���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AF240BUT()

Local aAF240BUT := {}	

aAdd( aAF240BUT, { "Classificar por NF", "U_TTATFC05() ", 0, 3 } )

Return aAF240BUT


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �TTATFC04  � Autor �Alexandre Venancio     � Data �31/05/12  ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Classificacao de bens por nota fiscal.                     ���
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

User Function TTATFC05()

Local oGrp1,oSay1,oSay2,oSay3,oSay4,oGet1,oGet2,oGet3,oGet4,oBtn1,oGrp2
Local oBtn2,oBtn3
Local nOpc			:=	0
Private cNota		:=	space(9)
Private cSerie    	:=	space(3)
Private cFornec		:=	space(6)
Private cLoja		:=	space(4) 
Private aList		:=	{}
Private oList	    
Private oDlg1   

Aadd(aList,{"","","","",space(13),space(25),space(25),"","",""})

oDlg1      := MSDialog():New( 091,232,545,852,"Classificar Ativo por NF",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,040,300,"Dados da NF",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 020,009,{||"Nota"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oGet1      := TGet():New( 020,025,{|u| If(Pcount()>0,cNota:=u,cNota)},oGrp1,052,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1","",,)
	
	oSay2      := TSay():New( 020,081,{||"S�rie"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oGet2      := TGet():New( 020,096,{|u| If(Pcount()>0,cSerie:=u,cSerie)},oGrp1,028,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay3      := TSay():New( 020,128,{||"Cod. Fornec."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet3      := TGet():New( 020,161,{|u| If(Pcount()>0,cFornec:=u,cFornec)},oGrp1,040,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","",,)
	
	oSay4      := TSay():New( 020,205,{||"Loja"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oGet4      := TGet():New( 020,218,{|u| If(Pcount()>0,cLoja:=u,cLoja)},oGrp1,032,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oBtn1      := TButton():New( 018,256,"Pesquisar",oGrp1,{|| PreAcols()},037,012,,,,.T.,,"",,,,.F. )
	
oGrp2      := TGroup():New( 044,004,188,300,"Dados dos Ativos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList := TCBrowse():New(056,008,290,125,, {'Produto','Descricao','Qtd','Grupo','Range Chapa','Range Nr Serie','Breve Hist.'},{30,40,20,30,30,30,35},;
	                            oGrp2,,,,{|| },{|| editcol()},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06],;
	                     aList[oList:nAt,07]}}


oBtn2      := TButton():New( 198,080,"Salvar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 198,172,"Sair",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpc == 1
	Gravar()
EndIf

Return                     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF240BUT  �Autor  �Microsiga           � Data �  05/31/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Buscando as informacoes sobre a nota fiscal a ser classifi-���
���          �cada.                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Preacols()

Local aArea	:=	GetArea()
Local cQuery 

aList := {}

cQuery := "SELECT N1_PRODUTO,B1_DESC,SUM(N1_QUANTD) As QTD"
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=N1_PRODUTO AND B1.D_E_L_E_T_=''"
cQuery += "  WHERE N1.D_E_L_E_T_=''"
cQuery += "  AND N1_STATUS='0'"
cQuery += "  AND N1_FORNEC='"+cFornec+"' AND N1_LOJA='"+cLoja+"' AND N1_NFISCAL='"+cNota+"' AND N1_NSERIE='"+cSerie+"'"
cQuery += " GROUP BY N1_PRODUTO,B1_DESC"            

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC05.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")  

While !EOF()
    Aadd(aList,{TRB->N1_PRODUTO,TRB->B1_DESC,cvaltochar(TRB->QTD),"",space(13),space(30),space(25),""})
	DbSkip()
EndDo

If len(aList) == 0
	Aadd(aList,{"","","","",space(13),space(30),space(30),"","",""})
	MsgAlert("Nota Fiscal n�o encontrada","TTATFC05 - AF240BUT")
EndIf     

	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06],;
	                     aList[oList:nAt,07]}}
	oList:refresh()
	oDlg1:refresh()

Return                                

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF240BUT  �Autor  �Microsiga           � Data �  05/31/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Colunas editaveis no Grid.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function editcol()

Local aArea	 :=	GetArea()
Local aRange := {}                  
Local lRange := .F.

If empty(aList[oList:nAt,01])
	RestArea(aArea)
	Return
EndIf

lGrupo := ConPad1(,,,"SNG",,,.F.) 
                       
If lGrupo                       
	aList[oList:nAt,04] := SNG->NG_GRUPO
	oList:refresh()
	oDlg1:refresh()
	
	While !lRange   
	    aList[oList:nAt,5] := space(6)
		lEditCell(aList,oList,'@!',5) 
		If empty(aList[oList:nAt,05]) .Or. val(aList[oList:nAt,05]) < 1
			MsgAlert("Digite um valor valido")                          
		Else
			aList[oList:nAt,05] := Strzero(val(aList[oList:nAt,05]),6)+"-"+Strzero(val(aList[oList:nAt,05])+val(aList[oList:nAt,03]),6)
			lRange := .T.
		EndIf
	Enddo
	lEditCell(aList,oList,'@!',6)  
	lEditCell(aList,oList,'@!',7)  
Else                              
	aList[oList:nAt,04] := space(4)
	lEditCell(aList,oList,'@!',4)
	lEditCell(aList,oList,'@!',5)  
	lEditCell(aList,oList,'@!',6)    
	lEditCell(aList,oList,'@!',7)  
EndIf

oList:refresh()
oDlg1:refresh()

RestArea(aArea)

Return                                       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF240BUT  �Autor  �Microsiga           � Data �  06/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Gravar()

Local aArea	 := GetArea()
Local cQuery  
Local aAtivo := {}  
Local cChapa          
Local cSer

For nX := 1 to len(aList)

	cQuery := "SELECT N1_FILIAL,N1_PRODUTO,N1_CBASE,N1_ITEM,R_E_C_N_O_ AS REC,N1_DESCRIC,N1_XTENSOR,N1_XANOFAB"
	cQuery += " FROM "+RetSQLName("SN1")+" N1"
	cQuery += "  WHERE N1.D_E_L_E_T_=''"
	cQuery += "  AND N1_STATUS='0'"
	cQuery += "  AND N1_FORNEC='"+cFornec+"' AND N1_LOJA='"+cLoja+"' AND N1_NFISCAL='"+cNota+"' AND N1_NSERIE='"+cSerie+"'"
	cQuery += "  AND N1_PRODUTO='"+aList[nX,01]+"'"

	If Select("TRB2") > 0
		dbSelectArea("TRB2")
		dbCloseArea()
	EndIf
	cChapa := val(aList[nX,05])
	cSer   := aList[nX,06]
	MemoWrite("TTATFC05.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB2',.F.,.T.)   
	
	DbSelectArea("TRB2")  
	aAtivo := {}
	While !EOF()
	    //Aadd(aAtivo,{TRB2->N1_FILIAL,TRB2->N1_PRODUTO,TRB2->N1_CBASE,TRB2->N1_ITEM,TRB2->REC})
	    Aadd(aAtivo,{TRB2->N1_CBASE+"/"+TRB2->N1_PRODUTO,TRB2->N1_DESCRIC,cSer,TRB2->N1_XTENSOR,TRB2->N1_XANOFAB,Strzero(cChapa,6),""})    
        DbSelectArea("SN1")
        DbSetOrder(1)
        If DbSeek(xFilial("SN1")+TRB2->N1_CBASE+TRB2->N1_ITEM)
        	Reclock("SN1",.F.)
        	SN1->N1_CHAPA 		:=	Strzero(cChapa,6)
			SN1->N1_GRUPO 		:=  aList[nX,04]
			SN1->N1_STATUS 		:=	"1"
			SN1->N1_DTCLASS 	:= 	DDATABASE
			SN1->N1_PRZDEPR 	:= 	Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_PRZDEPR")
			SN1->N1_DETPATR 	:= 	Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_DETPATR")
			SN1->N1_UTIPATR 	:= 	Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_UTIPATR")
			SN1->N1_XNSERFA		:=	cSer
			SN1->(Msunlock())
		EndIf       
		
		DbSelectArea("SN3")
		DbSetOrder(1)
		If DbSeek(xFilial("SN3")+TRB2->N1_CBASE+TRB2->N1_ITEM)
			Reclock("SN3",.F.)
			SN3->N3_CCONTAB 	:= Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_CCONTAB")
			SN3->N3_CDEPREC 	:= Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_CDEPREC")
			SN3->N3_CCUSTO 		:= Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_CCUSTO")
			SN3->N3_CCDEPR 		:= Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_CCDEPR")
			SN3->N3_TXDEPR1 	:= Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_TXDEPR1")
			SN3->N3_TXDEPR2 	:= Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_TXDEPR2")
			SN3->N3_CCDESP 		:= Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_CCDESP")
			SN3->N3_CCCDEP 		:= Posicione("SNG",1,xFilial("SNG")+aList[nX,04],"NG_CCCDEP")
			SN3->N3_TIPREAV 	:= "N"
			SN3->N3_HISTOR 		:= aList[nX,07] 
			SN3->(Msunlock())
		EndIf
	    cChapa++
		cSer := __Soma1(cSer) 
		DbSelectArea("TRB2")
		DbSkip()
	EndDo
	
Next nX
   
//U_TTATFC03(aAtivo)
	
RestArea(aArea)

Return