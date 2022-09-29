#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC93  �Autor  �Jackson E. de Deus  � Data �  22/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Rotina utilizada para lancamento e consulta dos contadores���
���          �de Maquinas.							                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTPROC93()

Local oBrowse
Private cCadastro := "Contadores de Maquinas"

If cEmpAnt <> "01"
	return
EndIF

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SZN")
oBrowse:SetDescription(cCadastro)
oBrowse:AddLegend("AllTrim(ZN_VALIDA) == 'X'","BLACK"	,"Inv�lido")
oBrowse:AddLegend("AllTrim(ZN_VALIDA) == 'S'","PINK"	,"Aguardando valida��o")
oBrowse:AddLegend("AllTrim(ZN_VALIDA) == 'O'","GREEN"	,"Validado")


oBrowse:Activate()

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC13  �Autor  �Microsiga           � Data �  06/20/13   ���
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

ADD OPTION aRotina TITLE 'Pesquisar'ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Visualizar' Action 'STATICCALL(TTPROC93,Visual,Recno())' OPERATION 2 ACCESS 0
//ADD OPTION aRotina Title 'Incluir' Action 'STATICCALL(TTPROC93,Incluir,Recno())' OPERATION 3 ACCESS 0
//ADD OPTION aRotina Title 'Alterar' Action 'STATICCALL(TTPROC93,Alterar,Recno())' OPERATION 4 ACCESS 0
//ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.TTPROC13' OPERATION 5 ACCESS 0
//ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.TTPROC13' OPERATION 8 ACCESS 0
//ADD OPTION aRotina Title 'Copiar' Action 'VIEWDEF.TTPROC13' OPERATION 9 ACCESS 0
//ADD OPTION aRotina Title 'Importar' Action 'U_TTPROC14' OPERATION 10 ACCESS 0

Return aRotina


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC93  �Autor  �Microsiga           � Data �  07/21/15   ���
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
      
Axvisual("SZN",Recno(),2)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC93  �Autor  �Microsiga           � Data �  07/21/15   ���
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
   
Local aCpo := {}
Local aAlter := {} 
Local cUsrPerm := SuperGetMv("MV_XGCT001",.T.,"ADMIN")
Local nI
Private _aValues := {}

aCpo := {"NOUSER","ZN_NUMOS","ZN_DATA","ZN_TIPINCL","ZN_ROTA","ZN_PATRIMO","ZN_TIPMAQ","ZN_CLIENTE",;
		"ZN_LOJA","ZN_NUMANT","ZN_NUMATU","ZN_COTCASH","ZN_BOTTEST","ZN_PARCIAL","ZN_BOTAO01","ZN_BOTAO02",;
		"ZN_BOTAO03","ZN_BOTAO04","ZN_BOTAO05","ZN_BOTAO06","ZN_BOTAO07","ZN_BOTAO08","ZN_BOTAO09","ZN_BOTAO10",;
		"ZN_BOTAO11","ZN_BOTAO12","ZN_BOTAO13","ZN_BOTAO14","ZN_BOTAO15","ZN_BOTAO16","ZN_BOTAO17","ZN_BOTAO18",;
		"ZN_BOTAO19","ZN_BOTAO20","ZN_BOTAO21","ZN_BOTAO22","ZN_BOTAO23","ZN_BOTAO24","ZN_BOTAO25","ZN_BOTAO26",;		
		"ZN_BOTAO27","ZN_BOTAO28","ZN_BOTAO29","ZN_CONFERE","ZN_MABAST1",;
		"ZN_MABAST2","ZN_MABAST3","ZN_MABAST4","ZN_MABAST5","ZN_TROCO","ZN_BANANIN","ZN_GLENVIE","ZN_GLENVRE",;
		"ZN_LACRMOE","ZN_LACCMOE","ZN_LACRCED","ZN_LACCCED","ZN_LOGC01","ZN_LOGC02","ZN_LOGC03","ZN_LOGC04","ZN_LOGC05"}


aAlter := {"ZN_NUMATU","ZN_COTCASH","ZN_BOTTEST","ZN_PARCIAL","ZN_BOTAO01","ZN_BOTAO02","ZN_BOTAO03","ZN_BOTAO04",;
			"ZN_BOTAO05","ZN_BOTAO06","ZN_BOTAO07","ZN_BOTAO08","ZN_BOTAO09","ZN_BOTAO10","ZN_BOTAO11","ZN_BOTAO12",;
			"ZN_BOTAO13","ZN_BOTAO14","ZN_BOTAO15","ZN_BOTAO16","ZN_BOTAO17","ZN_BOTAO18","ZN_BOTAO19","ZN_BOTAO20",;
			"ZN_BOTAO21","ZN_BOTAO22","ZN_BOTAO23","ZN_BOTAO24","ZN_BOTAO25","ZN_BOTAO26","ZN_BOTAO27","ZN_BOTAO28",;
			"ZN_BOTAO29","ZN_CONFERE"}

If cUserName $ cUsrPerm
	AADD( aAlter, "ZN_MABAST1" )
	AADD( aAlter, "ZN_MABAST2" )
	AADD( aAlter, "ZN_MABAST3" )
	AADD( aAlter, "ZN_MABAST4" )
	AADD( aAlter, "ZN_MABAST5" )
	AADD( aAlter, "ZN_TROCO" )	
	AADD( aAlter, "ZN_BANANIN"  )
	AADD( aAlter, "ZN_GLENVIE"  )
	AADD( aAlter, "ZN_GLENVRE"  )
	AADD( aAlter, "ZN_LACRMOE"  )
	AADD( aAlter, "ZN_LACCMOE"  )
	AADD( aAlter, "ZN_LACRCED"  )
	AADD( aAlter, "ZN_LACCCED"  )
	AADD( aAlter, "ZN_LOGC01"  )
	AADD( aAlter, "ZN_LOGC02"  )
	AADD( aAlter, "ZN_LOGC03"  )
	AADD( aAlter, "ZN_LOGC04"  )
	AADD( aAlter, "ZN_LOGC05"  )
EndIf

For nI := 1 To Len(aAlter)
	AADD( _aValues, { aAlter[nI] , &(SZN->(aAlter[nI])) } )  	
Next nI

      
AxAltera("SZN",Recno(),4,aCpo,aAlter,,,,"STATICCALL( TTPROC93, Transa )")

Return

   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC93  �Autor  �Microsiga           � Data �  04/07/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Transa()

Local cOrigem := IIF( !IsInCallStack("U_TTPROC30"),"TTPROC93","TTPROC30" )
Local nI

If ValType(_aValues) <> Nil
	For nI := 1 To Len(_aValues)
		If &(SZN->(_aValues[nI][1])) <> _aValues[nI][2]
			U_TTGENC01( xFilial("SZN"),cOrigem,"ORDEM DE SERVICO","",SZN->ZN_NUMOS,,cUserName,dtos(date()),time(),,"Apontamento alterado - Campo: "+_aValues[nI][1],,,"SZN" )		    			
			
			// ajuste cash
			If _aValues[nI][1] == "ZN_COTCASH"
				dbSelectArea("SZI")
				dbSetOrder(3)
				If MSSeek( xFilial("SZI") +AvKey(SZN->ZN_NUMOS,"ZI_NUMOS") )
					If Val(SZI->ZI_CNTCAS) <> SZN->ZN_COTCASH
						If RecLock("SZI",.F.)
							SZI->ZI_CNTCAS := cvaltochar(SZN->ZN_COTCASH)
							SZI->(MsUnLock())
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next nI
EndIf

Return