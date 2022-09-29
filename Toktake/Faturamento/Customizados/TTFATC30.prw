#include "colors.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "totvs.ch"  
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATC30�Autor  �Jackson E. de Deus    � Data �  22/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava a saida da nota fiscal								  ���
���          �Utilizado na Portaria										  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson	       �22/08/14�01.00 |Criacao                               ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 

User Function TTFATC30()

Local oDlg 
Local oPanel         
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Local nTamanho		:= 0.4
Local oLayer		:= FWLayer():new()
Local oChv
Local cChvNfe		:= Space(44)
Local lOk			:= .F. 
Local nRecno		:= 0 
Local cErro			:= ""
Local lVld			:= .T.
Private lViaMenu	:= .F.
Private oERRO

If cEmpAnt <> "01"
	Return
EndIf


If Empty(FunName())
	prepare environment empresa "01" filial "01"
Else
	lViaMenu := .T.	
EndIf

oDlg := MSDialog():New( 0,0,230, 600,"Saida de Nota Fiscal",,,.F.,,,,,,.T.,,,.T. )	

	oLayer:init(oDlg,.T.)
	
	oLayer:addLine("LN_ENCH",85,.F.)
	oLayer:addCollumn("COL_ENCH",100,.F.,"LN_ENCH")
	oLayer:addWindow("COL_ENCH","WIN_ENCH","",100,.F.,.T.,{||},"LN_ENCH")
	
	oPnlMaster := oLayer:GetWinPanel("COL_ENCH","WIN_ENCH","LN_ENCH")
	oPnlMaster:FreeChildren()
	
	oSay := TSay():New( 030,010,{ || "Informe o n�mero da chave: " },oPnlMaster,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,010)
	oChv := TGet():New( 028,095,{ |u| If(PCount()>0,cChvNfe:=u,cChvNfe) },oPnlMaster,150,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{ ||  },.F.,.F.,"","",,)
		
	oPanel := TPanel():New(0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,100,020)
	oPanel:Align := CONTROL_ALIGN_BOTTOM
	
	oERRO := TSay():New( 0,05,{ || "" },oPanel,,oFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,200,015)
       
	oSBtn2 := TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL', , , ,{ || oDlg:End() } , oPanel, "Sair" , ,) 
	oSBtn := TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{ || IIF( MsgYesNO("Confirma a sa�da da nota fiscal?"),lOk := .T., /**/) , IIF(lOk,lVld := Vld(cChvNfe,@nRecno),/**/ ) , IF(lVld, Gravar(nRecno,@cErro),/**/),IF(!Empty(cErro),MsgInfo(cErro),/**/)  } , oPanel, "Grava a sa�da" , ,) 

	oSBtn2:Align := CONTROL_ALIGN_RIGHT	 
	osBtn:Align := CONTROL_ALIGN_RIGHT
   		
oDlg:Activate(,,,.T.)

Return                                                                                                         


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Vld	    �Autor  �Jackson E. de Deus  � Data �  22/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao                                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Vld(cChvNfe,nRecno)
           
Local lRet := .T. 

If Len( AllTrim(cChvNfe) ) <> 44
	If lViaMenu
    	MsgAlert("A chave deve ter 44 caracteres!")
	Else 
		oERRO:setText("A chave deve ter 44 caracteres!")
	EndIf
	lRet := .F.
	Return lRet
EndIf        

For nI := 1 To Len(AllTrim(cChvNfe))
	If !IsDigit(SubStr(cChvNfe,nI,1))
		If lViaMenu
			MsgAlert("Digite apenas n�meros!")
		Else
			oERRO:setText("Digite apenas n�meros!")
		EndIf	
		lRet := .F.
		Return lRet
	EndIf
Next nI

// Verifica se ja houve a saida da nota
ChkSaida(cChvNfe,@nRecno)
If nRecno == 0
	If lViaMenu
		MsgAlert("N�o existe nota fiscal com essa chave de acesso!")
	Else
		oERRO:setText("N�o existe nota fiscal com essa chave de acesso!")                                       
	EndIf
	lRet := .F.
	Return lRet
Else
	If !Empty( TRB->F2_DTIMP ) .And. !Empty( TRB->F2_HRIMP )
		If lViaMenu
			MsgAlert("J� houve a sa�da dessa nota fiscal!" +" - " +"Data: " +dtoc(stod(TRB->F2_DTIMP)) +"  " +"Hora: " +TRB->F2_HRIMP)
		Else
			oERRO:setText("J� houve a sa�da dessa nota fiscal!" +" - " +"Data: " +dtoc(stod(TRB->F2_DTIMP)) +"  " +"Hora: " +TRB->F2_HRIMP)
		EndIf
		
		lRet := .F.
   		Return lRet
	Else
		lRet := .T.
	EndIf
	
	TRB->(dbCloseArea())
EndIf


If !lRet .And. !lViaMenu
	Sleep(2000)     
	oErro:setText("")
EndIf

Return lRet 



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ChkSaida  �Autor  �Jackson E. de Deus  � Data �  22/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica a nota                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ChkSaida(cChvNfe,nRecno)
           
Local cQuery := ""


cQuery := "SELECT F2_DTIMP, F2_HRIMP, F2_DOC, F2_SERIE, A1_NOME, SF2.R_E_C_N_O_ REC FROM " +RetSqlName("SF2") +" SF2 "
cQuery += " INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
cQuery += " A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA"
cQuery += " WHERE F2_CHVNFE = '"+cChvNfe+"' AND SF2.D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB" 
If !EOF()
	nRecno := TRB->REC
EndIf


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATC30  �Autor  �Microsiga           � Data �  11/23/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RegOut(cNota)

Local cQuery := ""
Local cSerie := "2"
Local nRecno := 0
Local cRetorno := ""
Local cErro := ""
Local cChave := ""
Local dDtImp := ""
Local cHrImp := ""


cQuery := "SELECT F2_DTIMP, F2_HRIMP, F2_CHVNFE, SF2.R_E_C_N_O_ REC FROM " +RetSqlName("SF2") +" SF2 "
cQuery += " WHERE F2_DOC = '"+cNota+"' AND F2_SERIE = '"+cSerie+"' AND SF2.D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB" 
If !EOF()
	nRecno := TRB->REC
	cChave := TRB->F2_CHVNFE
	dDtImp := TRB->F2_DTIMP
	cHrImp := TRB->F2_HRIMP
EndIf

TRB->(dbCloseArea())

If nRecno == 0
	cRetorno := "Nota fiscal n�o encontrada no sistema!"
Else
	If Empty(cChave)
		cRetorno := "Essa nota fiscal ainda n�o foi autorizada pela Sefaz!"
		Return cRetorno
	EndIf
	If !Empty(dDtImp) .And. !Empty(cHrImp)
		cRetorno := "J� houve a sa�da dessa nota fiscal!" +" - " +"Data: " +dtoc(stod(dDtImp)) +"  " +"Hora: " +cHrImp
		Return cRetorno
	EndIf
	
	
	Gravar(nRecno,@cErro) //"Ok! :D"
	If Empty(cErro)
		cRetorno := "Sa�da confirmada!"
	Else
		cRetorno := cErro
	EndIf
EndIf	
	
Return cRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Gravar    �Autor  �Jackson E. de Deus  � Data �  22/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava a saida                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Gravar(nRecno,cErro)
                        
Local cTime := Time()
Local cHora := SubStr(cTime, 1,5)
Local cMailResp := SuperGetMV("MV_XLOG001",.T.,"")
Local cRotaAtv := SuperGetMV("MV_XLOG011",.T.,"")
Local cTpRota := ""
Local cSql := ""
Local cRota := ""
Local cNota := ""
Local cSerie := ""
Local lCafe := .F.
Local cPaExec  := SuperGetMV("MV_XLOG009",.T.,"")
Local cArm := ""

If nRecno == 0
	cErro := "Registro de nota inv�lido!"
	Return
EndIf
                             
dbSelectArea("SF2")
dbGoTo(nRecno)
cRota := SF2->F2_XCODPA
cNota := SF2->F2_DOC
cSerie := SF2->F2_SERIE

If ! FindFunction( "U_TTFAT18C" ) .OR.  !FindFunction( "U_TTFAT27C" )
	MsgAlert( "Aten��o, compilar os programas U_TTFAT18C e U_TTFAT27C" )
	Return
EndIf

If !Empty(cRota)
	/*
	If SubStr( cRota,1,1 ) == "P"
		cArm := "A" +SubStr(cRota,2)
	Else
		cArm := cRota	
	EndIf
	*/
    /*
	dbSelectArea("ZZ1")
	dbSetOrder(1)
	If MsSeek( xFilial("ZZ1") +AvKey(cArm,"ZZ1_COD") )
		cTpRota := AllTrim(ZZ1->ZZ1_TIPO)	// 1 - cafe | 2 - snacks | 3 - PA
	EndIf
	*/
	
	// Se Rota cafe - valida prestacao de contas
	//If SubStr(cRota,1,1) == "R"
		/*
		If cTpRota $ cRotaAtv
			cSql := "SELECT COUNT(*) TOTAL FROM " +RetSqlname("SZ7")
			cSql += " WHERE Z7_ARMMOV = '"+cRota+"' AND Z7_STATUS IN ('2') AND Z7_DOC <> '"+cNota+"' "
			cSql += " AND Z7_SERIE = '"+cSerie+"' AND Z7_SAIDA <= '"+DTOS(Date())+"' AND D_E_L_E_T_ = '' "
			
			IIF( Select("TRBZ") > 0,TRBZ->(dbCloseArea()),)
			
			TcQuery cSql New Alias "TRBZ"
			dbSelectArea("TRBZ")
			If TRBZ->TOTAL > 0
				TRBZ->(dbCloseArea())
				cErro := "Essa Rota/PA ainda est� em fase de presta��o de contas, n�o � poss�vel continuar. Entre em contato com o departamento de Opera��es."
				Return		
			EndIf
		EndIf
		*/
		
		If IsClosing(cRota)
			cErro := "Essa Rota/PA ainda est� em fase de presta��o de contas, n�o � poss�vel continuar. Entre em contato com o departamento de Opera��es."
			Return
		EndIf
		
	//EndIf
EndIf



// atualiza o armazem rota e controle de mercadoria da rota ( movel )
If SubStr(cRota,1,1) == "R"
	U_TTFAT18C( SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA )
	If !ChkEntr( SF2->F2_DOC,SF2->F2_SERIE,"SZ5" )
		MsgAlert( "Aten��o, as mercadorias n�o entraram corretamente no armaz�m - SZ5. Tente novamente." )
		Return
	EndIf
	
	U_TTFAT27C( SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,3 ) 
	If !ChkEntr( SF2->F2_DOC,SF2->F2_SERIE,"SZ7" )
		MsgAlert( "Aten��o, as mercadorias n�o entraram corretamente no armaz�m - SZ7. Tente novamente." )
		Return
	EndIf	
	
// somente para PA excecao - ja entra mercadoria na saida da nf
ElseIf SubStr(cRota,1,1) == "P" .And. cRota $ cPaExec
	U_TTFAT18C( SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA )
	If !ChkEntr( SF2->F2_DOC,SF2->F2_SERIE,"SZ5" )
		MsgAlert( "Aten��o, as mercadorias n�o entraram corretamente no armaz�m - SZ5. Tente novamente." )
		Return
	EndIf

	U_TTFAT27C( SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,3 )
	If !ChkEntr( SF2->F2_DOC,SF2->F2_SERIE,"SZ7" )
		MsgAlert( "Aten��o, as mercadorias n�o entraram corretamente no armaz�m - SZ7. Tente novamente." )
		Return
	EndIf
	 	
EndIf

dbSelectArea("SF2")
dbGoTo(nRecno)
RecLock("SF2",.F.)
SF2->F2_DTIMP := dDatabase
SF2->F2_HRIMP := cHora
//SF2->F2_XUSRIMP := __cUserID
//SF2->F2_XNAMIMP := cUserName
MsUnLock()


If !FwIsInCallStack("RegOut") 
	If lViaMenu
		MsgInfo("Sa�da confirmada!")
	Else
		oERRO:setText("Sa�da confirmada!")
		oERRO:Refresh()
		Sleep(4000)     
		oERRO:setText("")
	EndIf
EndIf	

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATC30  �Autor  �Microsiga           � Data �  06/27/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ChkEntr( cNumNF,cSerie,cTabela )

Local cQuery := ""
Local lOk := .T.

If cTabela == "SZ5"
	cQuery := "SELECT D2_ITEM, D2_COD, Z5_COD PROD FROM " +RetSqlName("SD2") +" SD2 WITH (NOLOCK) "
	cQuery += " LEFT JOIN " +RetSqlName("SZ5") +" SZ5 WITH (NOLOCK) ON " 
	cQuery += " D2_FILIAL = Z5_FILIAL "
	cQuery += " AND Z5_NF = D2_DOC "
	cQuery += " AND Z5_NFITEM = D2_ITEM "
	cQuery += " WHERE " 
	cQuery += " D2_FILIAL = '"+xFilial("SD2")+"' "
	cQuery += " AND D2_DOC = '"+cNumNF+"' " 
	cQuery += " AND D2_SERIE = '"+cSerie+"' "
	cQuery += " AND SD2.D_E_L_E_T_ = '' AND SZ5.D_E_L_E_T_ = '' "
ElseIf cTabela == "SZ7"
	cQuery := "SELECT D2_ITEM, D2_COD, Z7_COD PROD FROM " +RetSqlName("SD2") +" SD2 WITH (NOLOCK) "
	cQuery += " LEFT JOIN " +RetSqlName("SZ7") +" SZ7 WITH (NOLOCK) ON " 
	cQuery += " D2_FILIAL = Z7_FILIAL "
	cQuery += " AND Z7_DOC = D2_DOC "
	cQuery += " AND Z7_ITEM = D2_ITEM "
	cQuery += " WHERE " 
	cQuery += " D2_FILIAL = '"+xFilial("SD2")+"' "
	cQuery += " AND D2_DOC = '"+cNumNF+"' " 
	cQuery += " AND D2_SERIE = '"+cSerie+"' "
	cQuery += " AND SD2.D_E_L_E_T_ = '' AND SZ7.D_E_L_E_T_ = '' "
EndIf	

MpSysOpenQuery( cQuery,"TRB" )

dbSelectArea("TRB")

While !EOF()
	
	If Empty( TRB->PROD )
		lOk := .F.
		Exit
	EndIf

	dbSkip()
End

Return lOk


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATC30  �Autor  �Microsiga           � Data �  06/14/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function IsClosing( cArmazem )

Local cSql := ""
Local lInFech := .F.

cSql := "SELECT COUNT(*) TOTAL FROM " +RetSqlname("SZ7")
cSql += " WHERE Z7_ARMMOV = '"+cArmazem+"' AND Z7_STATUS IN ('2') "
cSql += "  AND Z7_SAIDA <= '"+DTOS(Date())+"' AND D_E_L_E_T_ = '' "

MpSysOpenQuery( cSql,"TRBX" )

dbSelectArea("TRBX")

If TRBX->TOTAL > 0
	lInFech := .T.	
EndIf

Return lInFech