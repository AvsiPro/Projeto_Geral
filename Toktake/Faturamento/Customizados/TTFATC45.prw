#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATC45  �Autor  �Jackson E. de Deus  � Data �  15/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Browse - Mercadoria com Rota								  ���
���          �										                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFATC45()

Local oBrowse
Private cCadastro := "Mercadoria com Rota"

If cEmpAnt <> "01"
	Return
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('SZ7')
oBrowse:SetDescription(cCadastro)
                                                                          
oBrowse:AddLegend("AllTrim(Z7_STATUS) == '1' .And. Z7_QATU == 0"		,"GREEN"	,"Em andamento - sem saldo")
oBrowse:AddLegend("AllTrim(Z7_STATUS) == '1' .And. Z7_QATU > 0"			,"BLUE"		,"Em andamento - com saldo")
oBrowse:AddLegend("AllTrim(Z7_STATUS) == '2'"							,"PINK"		,"Prestando contas")
oBrowse:AddLegend("AllTrim(Z7_STATUS) == '3' .And. !Empty(Z7_RETORNO)"	,"RED"		,"Encerrado")

oBrowse:Activate()

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Jackson E. de Deus  � Data �  13/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Criacao do menu padrao                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE 'Pesquisar'		ACTION	'PesqBrw'						OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar'		ACTION	'STATICCALL(TTFATC45,Visual)'	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Distribuicao'		ACTION	'STATICCALL(TTFATC45,Mov)'		OPERATION 6 ACCESS 0
//ADD OPTION aRotina TITLE 'Inventariar'		ACTION	'STATICCALL(TTFATC45,Invent)'	OPERATION 7 ACCESS 0
//ADD OPTION aRotina TITLE 'Desconto'			ACTION	'STATICCALL(TTFATC45,DescRT)'	OPERATION 7 ACCESS 0

Return aRotina


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO11    �Autor  �Microsiga           � Data �  10/15/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Visual()

Local aCampos := {"NOUSER","Z7_ARMMOV","Z7_DOC","Z7_SERIE","Z7_CLIENTE","Z7_LOJA","Z7_EMISSAO","Z7_SAIDA",;
					"Z7_RETORNO","Z7_ITEM","Z7_COD","Z7_QUANT","Z7_QATU","Z7_ARMORI"}

AxVisual("SZ7",Recno(),2,aCampos)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATC45  �Autor  �Microsiga           � Data �  10/15/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Mov()

Local aAbast := {}
Local cRota := ""
Local dDtIni := dDatabase
Local dDtFim := dDatabase
Local aPergs := {}
Local aRet := {}
Local aItens := {}

aAdd(aPergs ,{1,"Rota"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Data inicial"				,dDtIni,"99/99/99","","","",0,.F.})
aAdd(aPergs ,{1,"Data final"				,dDtFim,"99/99/99","","","",0,.F.})

If ParamBox(aPergs ,"Parametros",@aRet) 
	cRota := aRet[1]
	dDtIni := aRet[2]
	dDtFim := aRet[3] 
	
	MsAguarde({ || aAbast := STATICCALL(TTPROC57,fQTAbast,cRota,dDtIni,dDtFim) },"Aguarde, verificando abastecimentos...")	
	For nI := 1 To Len(aAbast)
		If SubStr(aAbast[nI][4],1,1) == "P"
			AADD(aItens,aAbast[nI])
		EndIf
	Next nI
	STATICCALL(TTPROC57,Detalhe,aItens)
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATC45  �Autor  �Microsiga           � Data �  11/26/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Invent()





Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATC45  �Autor  �Microsiga           � Data �  10/26/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DescRT()
 
Local cRota := ""
Local dData := dDatabase
Local aPergs := {}
Local aRet := {} 
Local axItens := {}
Local aItens := {}
Local cSql := "" 
Local cOSMobile := ""
Private _cMot := ""

aAdd(aPergs ,{1,"Rota"					,Space( TamSx3("ZZ1_COD")[1] ),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Data de fechamento"	,dData,"99/99/99","","","",0,.F.})

If !ParamBox(aPergs ,"Parametros",@aRet)
	Return
EndIf     

cRota := aRet[1] 
dData := aRet[2]

cSql := "SELECT Z7_OSCNFRT FROM " +RetSqlName("SZ7")
cSql += " WHERE Z7_ARMMOV = '"+cRota+"' AND Z7_RETORNO = '"+DTOS(dData)+"' "	
cSql += " AND Z7_DOCRET <> ''  AND Z7_SERIRET <> '' AND Z7_STATUS = '3' AND D_E_L_E_T_ = '' "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf
                        
TcQuery cSql New Alias "TRBZ"

dbSelectArea("TRBZ")
If !EOF()
	cOSMobile := TRBZ->Z7_OSCNFRT
EndIf
                                 
If Empty(cOSMobile)
	MsgInfo("N�o h� dados!")
	Return
EndIf


DescX(aDocIt)

dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(cOSMobile,"ZG_NUMOS") )
	// produtos contados na OS de conferencia cega
	axItens := U_TTPROC71(cOSMobile)
	
	// relatorio
	If !Empty(axItens)
		_cMot := STATICCALL( TTPROC57, TecRota, cRota)
		For nI := 1 To Len(axItens)
			If axItens[nI][2] > 0
				AADD( aItens, axItens[nI] )
			EndIf
		Next nI
		MsAguarde({ || STATICCALL( TTFAT14C, RelDscto, SZG->ZG_DOC,SZG->ZG_SERIE,dDatabase,aItens ) },"Gerando relat�rio..")	
	EndIf
EndIf

Return