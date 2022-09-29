#include "topconn.ch"
#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATR49  �Autor  �Jackson E. de Deus  � Data �  25/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Pedidos prioritarios para liberacao                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFATR49()

Local cPerg := "TTFATR49"
Local lEnd := .F.
Local nOpca := 0
Private cDir := ""

If cEmpAnt <> "01"
	Return
EndIf

AjustaSX1(cPerg)

//��������������������������������������������������������������Ŀ
//� Tela de configuracao do Relatorio			         	     �
//����������������������������������������������������������������
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Pedidos priorit�rios") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir a rela��o de prioridade dos pedidos") SIZE 268, 8 OF oDlg PIXEL
	@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1  
	cDir := cGetFile(, OemToAnsi("Selecione o diret�rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	If !Empty(cDir)                                          
		CursorWait()
		Processa( { |lEnd| Gerar(@lEnd) },"Gerando relatorio, aguarde..")
		CursorArrow()
	Else
		Aviso(cPerg,"Escolha um diret�rio v�lido.",{"Ok"})
	EndIf
EndIf

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Gerar		�Autor  �Jackson E. de Deus  � Data �  25/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera o relatorio em planilha de excel.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Gerar(lEnd)

Local cQuery := ""
Local oExcel := FWMSEXCEL():New()
Local cArqXls := "pedidos_prioritarios.xml"
Local cSheet1 := "Pedidos"
Local nCont := 0

//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Data de entrega: ", dtoc(mv_par01) } )


oExcel:AddworkSheet(cSheet1) 
oExcel:AddTable (cSheet1,"Relatorio")
oExcel:AddColumn(cSheet1,"Relatorio","Pedido",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","PA",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Cliente",1,1)


cQuery := "SELECT C5_NUM, C5_XCODPA, C5_XDCODPA FROM " +RetSqlName("SC5") + " SC5 "
cQuery += " INNER JOIN " +RetSqlName("ZZ1") + " ON "
cQuery += " ZZ1_FILIAL = C5_FILIAL AND ZZ1_COD = C5_XCODPA"
cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery += " AND C5_XDTENTR = '"+DTOS(MV_PAR01)+"' "
cQuery += " AND C5_XFINAL = '4' "
cQuery += " AND C5_XCODPA <> '' "
cQuery += " AND SC5.D_E_L_E_T_ = '' "
cQuery += " ORDER BY ZZ1_PRIORI"


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	nCont++
	dbSkip()
End

If nCont == 0
	Aviso("TTFATR49","N�o h� dados",{"Ok"})
	Return
EndIf

ProcRegua(nCont)


// SHEET 1 -> SD3 
TRB->(dbGoTop())
While !EOF()
	IncProc(cSheet1 +" -> " +"Pedido: "+AllTrim(TRB->C5_NUM) )
	oExcel:AddRow(cSheet1,"Relatorio",{TRB->C5_NUM,; 
										TRB->C5_XCODPA,;
										TRB->C5_XDCODPA })
	
	TRB->( dbSkip() )
End
TRB->(dbCloseArea())
	
ProcRegua(nCont)


oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFATR50","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFATR50", 'MsExcel n�o instalado. ' +CRLF +'O arquivo est� localizado em: '+cDir, {"Ok"} )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1  �Autor  �Jackson E. de Deus � Data �  25/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajusta a pergunta do relatorio                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1(cPerg)


PutSx1(cPerg,"01","Data entrega ?","Data entrega ?","Data entrega ?","mv_cha","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","")

      
Return