#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC23  �Autor  �Jackson E. de Deus  � Data �  13/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Browse - Cadastro de POS									  ���
���          �										                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFINC23()

Local oBrowse
Private cCadastro := "Cadastro de POS"

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZZN')
oBrowse:SetDescription(cCadastro)
                                                                          
oBrowse:AddLegend("AllTrim(ZZN_LOCALZ) == '1'","BLUE"	,"Em cliente")
oBrowse:AddLegend("AllTrim(ZZN_LOCALZ) == '2'","GREEN"	,"Tesouraria")
oBrowse:AddLegend("AllTrim(ZZN_LOCALZ) == '3'","RED"	,"T�cnica")

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
ADD OPTION aRotina TITLE 'Visualizar'		ACTION	'STATICCALL(TTFINC23,Visual)'	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'			ACTION	'STATICCALL(TTFINC23,Incluir)'	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'			ACTION	'STATICCALL(TTFINC23,Alterar)'	OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Hist. vendas'		ACTION	'STATICCALL(TTFINC23,Vendas)'	OPERATION 6 ACCESS 0

Return aRotina


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Visual    �Autor  �Jackson E. de Deus  � Data �  13/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza                                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Visual(nRecno)
      
AxVisual("ZZN",Recno(),2)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Incluir   �Autor  �Jackson E. de Deus  � Data �  13/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Incluir                                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Incluir()

AxInclui("ZZN", 0, 3)

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Alterar  �Autor  �Microsiga           � Data �  10/13/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Alterar()

Local aCampos := { "ZZN_IDPDV", "ZZN_NRSERI","ZZN_PATRIM","ZZN_ICCID","ZZN_CLIENT","ZZN_LOJA","ZZN_LOCALZ" }

AxAltera("ZZN",Recno(),4,aCampos,,aCampos) 

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Vendas  �Autor  �Jackson E. de Deus    � Data �  03/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Vendas()

/*
aAdd(aPergs ,{1,"Rota/PA ?"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",6,.F.}) 	
If ParamBox(aPergs ,"Historico de vendas",@aRet)
	cRota := aRet[1]
	If Empty(cRota)
		MsgAlert("Informe uma Rota v�lida!")
		Return
	EndIf                                
EndIf
*/

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Assoc		�Autor  �Jackson E. de Deus  � Data �  13/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Associacao de POS x Patrimonio                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Assoc()
      
Local aArea	:=	GetArea()
Local cQuery

If !Empty(M->ZZN_PATRIM)
	cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName("ZZN")+" WHERE ZZN_PATRIM='"+M->ZZN_PATRIM+"' AND D_E_L_E_T_='' AND ZZN_IDPDV <> '"+M->ZZN_IDPDV+"' " 
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	dbSelectArea("TRB") 
	If TRB->QTD < 1
		dbSelectArea("SN1")
		dbSetOrder(2)
		If !dbSeek( xFilial("SN1") +AvKey(M->ZZN_PATRIM,"N1_CHAPA") )			
			M->ZZN_PATRIM	:= Space(TamSx3("ZZN_PATRIM")[1])
			M->ZZN_CLIENT	:= Space(TamSx3("ZZN_CLIENT")[1])
			M->ZZN_LOJA		:= Space(TamSx3("ZZN_LOJA")[1])
			MsgAlert("O Patrim�nio digitado n�o existe na tabela de Ativos!","TTFINC23")
		Else
			M->ZZN_CLIENT	:= SN1->N1_XCLIENT
			M->ZZN_LOJA		:= SN1->N1_XLOJA
			M->ZZN_LOCALZ	:= "1"
		EndIf
	Else
		M->ZZN_PATRIM	:= Space(TamSx3("ZZN_PATRIM")[1])
		M->ZZN_CLIENT	:= Space(TamSx3("ZZN_CLIENT")[1])
		M->ZZN_LOJA		:= Space(TamSx3("ZZN_LOJA")[1])
		MsgAlert("Esse patrim�nio j� esta vinculado a outro POS, favor verificar","TTFINC23")
	EndIf
Else
	If !Empty(ZZN->ZZN_PATRIM)
		If MsgYesNo("Deseja desvincular o patrim�nio do POS?")
			M->ZZN_CLIENT := Space(TamSx3("ZZN_CLIENT")[1])
			M->ZZN_LOJA := Space(TamSx3("ZZN_LOJA")[1])
			M->ZZN_LOCALZ := "2"	         
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return M->ZZN_CLIENT