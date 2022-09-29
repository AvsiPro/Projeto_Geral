#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTAXCAD   �Autor  �Microsiga           � Data �  05/25/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ttaxcad()
   
Local aRotAdic 	:={} 
Local bPre 		:= {||} //MsgAlert('Chamada antes da fun��o')
Local bOK  		:= {||, .T.} //MsgAlert('Chamada ao clicar em OK')
Local bTTS  	:= {||} //MsgAlert('Chamada durante transacao')
Local bNoTTS  	:= {||}    //MsgAlert('Chamada ap�s transacao')
Local aButtons 	:= {}

//adiciona bot�es na tela de inclus�o, altera��o, visualiza��o e exclusao
//aadd(aButtons,{ "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Bot�o Teste" }  )

//adiciona chamada no aRotina
aadd(aRotAdic,{ "Saldo","u_saldoTT", 0 , 6 })

//AxCadastro("ZZL", "Clientes", "U_DelOk()", "U_COK()", aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )

AxCadastro("ZZL","Natureza x Banco", , , aRotAdic, , , , , , , , , )

Return(.T.)            
            

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTAXCAD   �Autor  �Microsiga           � Data �  05/25/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DelOk() 

Reclock("ZZL",.F.)
Dbdelete()
ZZL->(Msunlock())

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTAXCAD   �Autor  �Microsiga           � Data �  05/25/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COK() 
Local lRet := .T.
            
If Existcpo("ZZL",M->ZZL_NATURE)
	MsgAlert("Esta natureza j� esta cadastrada","TTAXCAD")
	lRet := .F.
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTAXCAD   �Autor  �Microsiga           � Data �  05/25/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Adic() 
	//MsgAlert("Rotina adicional") 
Return
   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTAXCAD   �Autor  �Microsiga           � Data �  05/25/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SaldoTT()
   
Local aArea		:=	GetArea()
Local cQuery        
Local oDlg1,oGrp1,oSay1,oSay2,oGet1,oGet2,oSBtn1      
Local nOpc		:=	0  
Local cBanco	:=	space(3) 
Local cAnomes	:=	space(7) 
Local cPd		:=	""
Local cUd		:=	"" 
Local cBancos	:=	""

While nOpc == 0

	oDlg1      := MSDialog():New( 091,232,261,556,"Saldo de Titulos enviados ao banco no m�s",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 004,004,060,152,"Informa��es do Banco/M�s",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oSay1      := TSay():New( 020,028,{||"Banco"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet1      := TGet():New( 020,068,{|u| If(Pcount()>0,cBanco:=u,cBanco)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA62","",,)

		oSay2      := TSay():New( 040,028,{||"M�s/Ano"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet2      := TGet():New( 040,068,{|u| If(Pcount()>0,cAnomes:=u,cAnomes)},oGrp1,060,008,'@R 99/9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSBtn1     := SButton():New( 064,064,1,{||oDlg1:end(nOpc:=1)},oDlg1,,"", )
	
	oDlg1:Activate(,,,.T.)

EndDo	 
  
cPd := substr(cAnomes,4,4)+substr(cAnomes,1,2)+"01" 
cUd := dtos(lastday(stod(cPd)))

cQuery := "SELECT E1_PORTADO,SUM(E1_SALDO) AS SALDO"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SEA")+" EA ON EA_NUMBOR=E1_NUMBOR AND EA_NUM=E1_NUM AND EA_PREFIXO=E1_PREFIXO"
cQuery += " 	AND EA_DATABOR BETWEEN '"+cPd+"' AND '"+cUd+"' AND EA.D_E_L_E_T_=''"	
cQuery += " WHERE "            
cQuery += " E1.D_E_L_E_T_=''"

If Alltrim(cBanco) == '*'
	cQuery += " AND E1_PORTADO IN(SELECT EE_CODIGO FROM "+RetSQLName("SEE")+" WHERE D_E_L_E_T_<>'*')
Else
	cQuery += " AND E1_PORTADO='"+cBanco+"' 
EndIf

cQuery += " AND E1_NUMBOR<>''"  
cQuery += " GROUP BY E1_PORTADO" 
                    
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTAXCAD.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

If Alltrim(cBanco) == '*'
	While !EOF()
		cBancos += "Saldo de titulos enviados em garantia para o banco "+TRB->E1_PORTADO+" em "+cAnomes+" de R$ "+Transform(TRB->SALDO,"@E 999,999,999.99")+CHR(13)+CHR(10)
		DbSkip()
	EndDo
Else
	cBancos	:= "Saldo de titulos enviados em garantia para o banco "+cBanco+" em "+cAnomes+" de R$ "+Transform(TRB->SALDO,"@E 999,999,999.99")
EndIf
	
MsgAlert(cBancos,"TTAXCAD")


RestArea(aArea)

Return