#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"
Static lAlterou := .F.                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC02  บAutor  ณJackson E. de Deus  บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Tarefas.                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTPROC02()

Local oBrowse

If cEmpAnt <> "01"
	return
EndIF

dbSelectArea("SX2")
SX2->(dbSetOrder(1))
If !SX2->(dbSeek("SZ9"))
	ShowHelpDlg("SZ9", {"Tabela: SZ9" + CRLF + " Nใo encontrada no cadastro de tabelas (SX2)."},5,{"Nใo ้ possํvel continuar."},5)							
	Return
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SZ9")
oBrowse:SetDescription('Cadastro de Tarefas')
             
oBrowse:SetFilterDefault("Z9_SEQ=='001'")

oBrowse:Activate()

Return NIL 
                                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef   บAutor  ณJackson E. de Deus  บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ MenuDef. Define o menu do Browse.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณModelDef    บAutor  ณJackson E. de Deus  Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Define o modelo de dados.		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ModelDef()

Local oStruSZ9 := FWFormStruct( 1, 'SZ9' , {|cCampo| AllTrim(cCampo) $ "Z9_COD|Z9_DESC|Z9_TIPO|Z9_EMAILF" })
Local oStruSZ9D := FWFormStruct( 1, 'SZ9', {|cCampo| AllTrim(cCampo) $ "Z9_FILIAL|Z9_COD|Z9_SEQ|Z9_TAREFA|Z9_AREA|Z9_SLA|Z9_CORELAC|Z9_CONTROL" })
Local oModel	// Modelo de dados que serแ construํdo

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณViewDef   บAutor  ณJackson E. de Deus  บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Define o modelo de apresentacao.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ViewDef()

Local oModel := FWLoadModel( 'TTPROC02' )
Local oStruSZ9 := FWFormStruct( 2, 'SZ9' )
Local oStruSZ9D := FWFormStruct( 2, 'SZ9' )
Local oView
                                

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRemove campos da apresentacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPPROC01  บAutor  ณJackson E. de Deus  บ Data ณ  04/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pontos de entrada do programa.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC02  บAutor  ณMicrosiga           บ Data ณ  06/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	                       
	// valida se digitacao ้ do patrimonio
	If aParam[6] == "Z9_CONTROL"
		If AllTrim(M->Z9_CONTROL) == "1"
			For nI := 1 To Len(oObj:aCols)
				If nI == nLinha	// ignora a linha atual
					Loop
				EndIf
				If AllTrim(oObj:aCols[nI][nPosFlag]) == "1" .Or. AllTrim(oObj:aCols[nI][nPosFlag]) == "3" 		
					lRet := .F.
					Help( ,, 'Help',, 'Nใo permitido.' +CRLF +'Jแ existe sequ๊ncia para preenchimento do patrim๔nio.' +CRLF +'Sequ๊ncia: ' +oObj:aCols[nI][nPosSeq], 1, 0)
					Return lRet   
				EndIf	
			Next nI
			                
		// valida se digitacao ้ do pedido
		ElseIf AllTrim(M->Z9_CONTROL) == "2"
			For nI := 1 To Len(oObj:aCols)
				If nI == nLinha	// ignora a linha atual
					Loop
				EndIf
				If AllTrim(oObj:aCols[nI][nPosFlag]) == "1" .Or. AllTrim(oObj:aCols[nI][nPosFlag]) == "3" 		
					If nI > nLinha
						lRet := .F.
						Help( ,, 'Help',, 'Nใo permitido.' +CRLF +'A gera็ใo de pedido nใo pode ocorrer antes da sequ๊ncia de preenchimento do patrim๔nio.', 1, 0)
						Return lRet   
					EndIf
				ElseIf AllTrim(oObj:aCols[nI][nPosFlag]) == "2"
					lRet := .F.
					Help( ,, 'Help',, 'Nใo permitido.' +CRLF +'Jแ existe sequ๊ncia para gera็ใo do pedido.' +CRLF +'Sequ๊ncia: ' +oObj:aCols[nI][nPosSeq] , 1, 0)
					Return lRet
				EndIf			
			Next nI                	
	
		// valida se digitacao ้ do patrimonio/pedido
		ElseIf AllTrim(M->Z9_CONTROL) == "3"
			For nI := 1 To Len(oObj:aCols)
				If nI == nLinha	// ignora a linha atual
					Loop
				EndIf
				If AllTrim(oObj:aCols[nI][nPosFlag]) == "1" .Or. AllTrim(oObj:aCols[nI][nPosFlag]) == "3"
					lRet := .F.
					Help( ,, 'Help',, 'Nใo permitido.' +CRLF +'Jแ existe sequ๊ncia para preenchimento do patrim๔nio.' +CRLF +'Sequ๊ncia: ' +oObj:aCols[nI][nPosSeq], 1, 0)
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