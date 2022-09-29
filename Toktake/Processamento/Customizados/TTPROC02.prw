#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"
Static lAlterou := .F.                             
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC02  �Autor  �Jackson E. de Deus  � Data �  05/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Tarefas.                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TTPROC02()

Local oBrowse

If cEmpAnt <> "01"
	return
EndIF

dbSelectArea("SX2")
SX2->(dbSetOrder(1))
If !SX2->(dbSeek("SZ9"))
	ShowHelpDlg("SZ9", {"Tabela: SZ9" + CRLF + " N�o encontrada no cadastro de tabelas (SX2)."},5,{"N�o � poss�vel continuar."},5)							
	Return
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SZ9")
oBrowse:SetDescription('Cadastro de Tarefas')
             
oBrowse:SetFilterDefault("Z9_SEQ=='001'")

oBrowse:Activate()

Return NIL 
                                 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Jackson E. de Deus  � Data �  05/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � MenuDef. Define o menu do Browse.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()

Local aRotina	:= {}

ADD OPTION aRotina TITLE 'Pesquisar'	ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.TTPROC02'	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'		ACTION 'VIEWDEF.TTPROC02'	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'		ACTION 'VIEWDEF.TTPROC02'	OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'		ACTION 'VIEWDEF.TTPROC02'	OPERATION 5 ACCESS 0

//Return FWMVCMenu( "TTPROC02" )
Return(aRotina)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef    �Autor  �Jackson E. de Deus  Data �  05/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define o modelo de dados.		                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ModelDef()

Local oStruSZ9 := FWFormStruct( 1, 'SZ9' , {|cCampo| AllTrim(cCampo) $ "Z9_COD|Z9_DESC|Z9_TIPO|Z9_EMAILF" })
Local oStruSZ9D := FWFormStruct( 1, 'SZ9', {|cCampo| AllTrim(cCampo) $ "Z9_FILIAL|Z9_COD|Z9_SEQ|Z9_TAREFA|Z9_AREA|Z9_SLA|Z9_CORELAC|Z9_CONTROL" })
Local oModel	// Modelo de dados que ser� constru�do

oModel := MPFormModel():New( 'MPPROC02', , /*{ |oModel| ModelPos(oModel) }*/ ) // Quando User Function nao pode ter o mesmo nome do fonte

oModel:AddFields( 'SZ9MASTER',/*Owner*/ , oStruSZ9 )
oModel:AddGrid( 'SZ9DETAIL', 'SZ9MASTER', oStruSZ9D, /*{ |oModelGrid, nLine, cAction, cField| MGridPre(oModelGrid, nLine, cAction, cField) }*/, /*{ |oModelGrid| MGridPos(oModelGrid) }*/ )

oModel:SetRelation( 'SZ9DETAIL', { { 'Z9_FILIAL', 'xFilial( "SZ9" )' }, { 'Z9_COD','Z9_COD' } }, SZ9->( IndexKey( 1 ) ) )
                
oModel:SetPrimaryKey({})

oModel:SetDescription( 'Cadastro de Tarefas' )

// Permite que Grid tenha ou nao pelo menos uma linha digitada
oModel:GetModel('SZ9DETAIL'):SetOptional(.F.)


Return oModel


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef   �Autor  �Jackson E. de Deus  � Data �  05/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define o modelo de apresentacao.                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()

Local oModel := FWLoadModel( 'TTPROC02' )
Local oStruSZ9 := FWFormStruct( 2, 'SZ9' )
Local oStruSZ9D := FWFormStruct( 2, 'SZ9' )
Local oView
                                

/*
//�����������������������������Ŀ
//�Remove campos da apresentacao�
//�������������������������������
*/

oStruSZ9:RemoveField('Z9_SEQ')
oStruSZ9:RemoveField('Z9_TAREFA')
oStruSZ9:RemoveField('Z9_AREA')
oStruSZ9:RemoveField('Z9_SLA')
oStruSZ9:RemoveField('Z9_CORELAC')
oStruSZ9:RemoveField('Z9_CONTROL')
oStruSZ9:RemoveField('Z9_TPSERV')

oStruSZ9D:RemoveField('Z9_COD')
oStruSZ9D:RemoveField('Z9_DESC')
oStruSZ9D:RemoveField('Z9_TPSERV')
oStruSZ9D:RemoveField('Z9_TIPO')     
oStruSZ9D:RemoveField('Z9_EMAILF')


oView := FWFormView():New()
oView:SetModel( oModel )

oView:AddField( 'VIEW_SZ9M', oStruSZ9, 'SZ9MASTER' )   
oView:AddGrid( 'VIEW_SZ9D', oStruSZ9D, 'SZ9DETAIL' ) 
            
oView:AddIncrementField( 'VIEW_SZ9D', 'Z9_SEQ' )

oView:CreateHorizontalBox( 'SUPERIOR', 20 ) 
oView:CreateHorizontalBox( 'INFERIOR', 80 )

oView:SetOwnerView( 'VIEW_SZ9M', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_SZ9D', 'INFERIOR' )
                 
Return oView


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MPPROC01  �Autor  �Jackson E. de Deus  � Data �  04/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Pontos de entrada do programa.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MPPROC02()

Local aParam		:= PARAMIXB
Local xRet			:= .T.
Local oObj			:= ""
Local cIDPonto		:= ""
Local cIdModel		:= ""
Local lIsGrid		:= .F.
Local nLinha		:= 0
Local nQtdLinhas	:= 0
Local cMsg			:= ""

If aParam <> NIl
	oObj		:= aParam[1]
	cIdPonto	:= aParam[2]
	cIDModel	:= aParam[3]
	lIsGrid		:= ( Len(aParam)>3 )
    /*
	If lIsGrid
		nQtdLinhas := oObj:GetQtdLine()
		nLinha := oObj:nLine
	EndIf
	*/
                               
    // Antes da alteracao da linha do formulario FWFORMGRID
	If cIdPonto == "FORMLINEPRE"
		xRet := ValCampo(aParam)
	ElseIf cIdPonto == "FORMLINEPOS"
		//xRet := VldAlt(aParam)
	ElseIf cIdPonto == "FORMCOMMITTTSPOS"
		//xRet := FormPos()	
	EndIf	
EndIf

Return xRet




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC02  �Autor  �Microsiga           � Data �  06/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValCampo(aParam)

Local lRet		:= .T.           
Local nOperation
Local oObj
Local cIdPonto
Local cIDModel
Local lIsGrid
Local nLinha
Local nQtdLinhas
Local nI
Local nPosSeq	:= Ascan(aHeader,{|x|AllTrim(x[2])=="Z9_SEQ"})
Local nPosFlag	:= Ascan(aHeader,{|x|AllTrim(x[2])=="Z9_CONTROL"})

If aParam <> Nil
	oObj		:= aParam[1]
	cIdPonto	:= aParam[2]
	cIDModel	:= aParam[3]
	lIsGrid		:= ( Len(aParam)>3 )
	nOperation  := oObj:GetOperation()
	
	If lIsGrid
		nQtdLinhas := oObj:GetQtdLine()
		nLinha := oObj:nLine
	EndIf
	                       
	// valida se digitacao � do patrimonio
	If aParam[6] == "Z9_CONTROL"
		If AllTrim(M->Z9_CONTROL) == "1"
			For nI := 1 To Len(oObj:aCols)
				If nI == nLinha	// ignora a linha atual
					Loop
				EndIf
				If AllTrim(oObj:aCols[nI][nPosFlag]) == "1" .Or. AllTrim(oObj:aCols[nI][nPosFlag]) == "3" 		
					lRet := .F.
					Help( ,, 'Help',, 'N�o permitido.' +CRLF +'J� existe sequ�ncia para preenchimento do patrim�nio.' +CRLF +'Sequ�ncia: ' +oObj:aCols[nI][nPosSeq], 1, 0)
					Return lRet   
				EndIf	
			Next nI
			                
		// valida se digitacao � do pedido
		ElseIf AllTrim(M->Z9_CONTROL) == "2"
			For nI := 1 To Len(oObj:aCols)
				If nI == nLinha	// ignora a linha atual
					Loop
				EndIf
				If AllTrim(oObj:aCols[nI][nPosFlag]) == "1" .Or. AllTrim(oObj:aCols[nI][nPosFlag]) == "3" 		
					If nI > nLinha
						lRet := .F.
						Help( ,, 'Help',, 'N�o permitido.' +CRLF +'A gera��o de pedido n�o pode ocorrer antes da sequ�ncia de preenchimento do patrim�nio.', 1, 0)
						Return lRet   
					EndIf
				ElseIf AllTrim(oObj:aCols[nI][nPosFlag]) == "2"
					lRet := .F.
					Help( ,, 'Help',, 'N�o permitido.' +CRLF +'J� existe sequ�ncia para gera��o do pedido.' +CRLF +'Sequ�ncia: ' +oObj:aCols[nI][nPosSeq] , 1, 0)
					Return lRet
				EndIf			
			Next nI                	
	
		// valida se digitacao � do patrimonio/pedido
		ElseIf AllTrim(M->Z9_CONTROL) == "3"
			For nI := 1 To Len(oObj:aCols)
				If nI == nLinha	// ignora a linha atual
					Loop
				EndIf
				If AllTrim(oObj:aCols[nI][nPosFlag]) == "1" .Or. AllTrim(oObj:aCols[nI][nPosFlag]) == "3"
					lRet := .F.
					Help( ,, 'Help',, 'N�o permitido.' +CRLF +'J� existe sequ�ncia para preenchimento do patrim�nio.' +CRLF +'Sequ�ncia: ' +oObj:aCols[nI][nPosSeq], 1, 0)
					Return lRet
				EndIf
			Next nI                	
		EndIf
	EndIf
EndIf

Return lRet



Static Function VldAlt(aParam)

Local lRet		:= .T.           
Local nOperation
Local oObj
Local cIdPonto
Local cIDModel
Local lIsGrid
Local nLinha
Local nQtdLinhas
Local nI
Local nPosSeq	:= Ascan(aHeader,{|x|AllTrim(x[2])=="Z9_SEQ"})
Local nPosFlag	:= Ascan(aHeader,{|x|AllTrim(x[2])=="Z9_CONTROL"})

If aParam <> Nil
	oObj		:= aParam[1]
	cIdPonto	:= aParam[2]
	cIDModel	:= aParam[3]
	lIsGrid		:= ( Len(aParam)>3 )
	nOperation  := oObj:GetOperation()
	
	If lIsGrid
		nQtdLinhas := oObj:GetQtdLine()
		nLinha := oObj:nLine
	EndIf
	
	For nI := 1 To oObj:Length()
		oObj:GoLine( nI )
		If oObj:IsDeleted()
			nCtDel++
		ElseIf oObj:IsInserted()
			nCtInc++
		ElseIf oObj:IsUpdated()
			nCtAlt++
		EndIf
	Next      

	If nCtDel > 0 .Or. nCtInc > 0 .Or. 	nCtalt > 0
		lAlterou := .T.
	EndIf	
EndIf



Return .T.