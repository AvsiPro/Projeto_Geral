#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"


/*/{Protheus.doc}	SepAuto
Ordem de separação automática (solução paliativa)

@author				Paulo Lima
@since				22/04/2022
@return				Nil
/*/
User Function SEPAUTO()
	
	Local oBrowse
	
	Private cTitulo := "Ordem de Separação paliativa" 
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetDescription( cTitulo )
	oBrowse:SetAlias( 'CB7' )
	oBrowse:SetLocate()

    oBrowse:AddLegend("CB7->CB7_DIVERG == '1'"                                                                        , "BR_VERMELHO" , "Divergencia" ) // legenda 1
    oBrowse:AddLegend("CB7->CB7_STATPA == '1'"                                                                        , "BR_CINZA"    , "Pausa"       ) // legenda 2
    oBrowse:AddLegend("CB7->CB7_STATUS == '2' .OR. CB7->CB7_STATUS == ' ' "                                           , "BR_AMARELO"                  ) // legenda 3
    oBrowse:AddLegend("CB7->CB7_STATUS $ '345678' .or. (CB7->CB7_STATUS == '1' .and. AllTrim(CB7->CB7_HRINIS) <> '')" , "BR_AMARELO"  , "Em andamento") // legenda 4
    oBrowse:AddLegend("(CB7->CB7_STATUS == '1' .and. AllTrim(CB7->CB7_HRINIS) == '') .or. CB7->CB7_STATUS $ ' 0' "    , "BR_AZUL"     , "Nao iniciado") // legenda 5
    oBrowse:AddLegend("CB7->CB7_STATUS == '9'"                                                                        , "BR_VERDE"    , "Finalizado"  ) // legenda 6

	oBrowse:Activate()

Return

/*/{Protheus.doc}	MenuDef

@author				Paulo Lima
@since				22/04/2022
@return				Nil
/*/

Static Function MenuDef()
	
	Local aRotina := {}
	
	//ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.SEPAUTO' OPERATION 2 ACCESS 0
    aadd(aRotina,{'FINALIZAR ORDEM DE SEPARAÇÃO', 'u_xSepFinal()' , 0 , 3,0,NIL}) 
	aadd(aRotina,{'STATUS', 'u_zStatusP()' , 0 , 3,0,NIL}) 
	//ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.SEPAUTO' OPERATION 3 ACCESS 0
	//ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.SEPAUTO' OPERATION 4 ACCESS 0
	//ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.SEPAUTO' OPERATION 5 ACCESS 0
	
Return aRotina

/*/{Protheus.doc}	Modeldef

@author				Paulo Lima
@since				22/04/2022
@return				Nil

/*/
Static Function Modeldef()
	
	Local oModel     := NIL
	Local oStructGri := NIL
	
	//oStructCab := FWFormStruct( 1, 'SZI', { | cCampo | AllTrim( cCampo ) + '|' $ CAMPOSCAB })
	oStructCab := FWFormStruct( 1, 'CB7')
	oStructGri := FWFormStruct( 1, 'CB8')
	
	oModel := MPFormModel():New( 'CB7FORM', /*bPreValidacao*/, /*bPreValidacao == TUDOOK*/ {|| VldOK() }, /*bPosGrava*/, /*bCancel*/ )
	//oModel := MPFormModel():New( 'SZIFORM')
	
	oModel:AddFields( 'CB7MASTER', NIL, oStructCab )
	oModel:AddGrid( 'CB8DETAIL', 'CB7MASTER', oStructGri)
	
	oModel:SetDescription( cTitulo )
	
	oModel:GetModel( 'CB7MASTER' ):SetDescription( 'oRDEM DE sEPARAÇÃO' )
	oModel:GetModel( 'CB8DETAIL' ):SetDescription( 'iTENS da oRDEM DE sEPARAÇÃO' )
	
	oModel:SetRelation( 'CB8DETAIL', {	{ 'CB8_FILIAL'	, "xFilial( 'CB8' )" } ,; 
										{ 'CB8_ORDSEP'	, 'CB7_ORDSEP' }} , CB8->( IndexKey( 1 ) ) )
	oModel:SetPrimaryKey( {} )
	
	oModel:GetModel( 'CB8DETAIL' ):setNoInsertLine(.T.)
	
Return oModel

/*/{Protheus.doc}	ViewDef

@author				Paulo Lima
@since				22/04/2022
@return				Nil
/*/
Static Function ViewDef()
	
	Local oView
	Local oModel     := FWLoadModel( 'SEPAUTO' )
	//Local oStructCab := FWFormStruct( 2, 'SZI', { | cCampo | AllTrim( cCampo ) + '|' $ CAMPOSCAB })
	Local oStructCab := FWFormStruct( 2, 'CB7')
	Local oStructGri := FWFormStruct( 2, 'CB8')
	
	//oStructGri:RemoveField( 'ZJ_PRODUTO' )
	//oStructGri:RemoveField( 'ZJ_DESCPRO' )
	//oStructGri:RemoveField( 'ZJ_CODIGO' )
	
	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField( 'FLE001_CAB' , oStructCab, 'CB7MASTER'  )
	oView:AddGrid(  'FLE001_ITEM', oStructGri, 'CB8DETAIL'  )
	
	oView:CreateHorizontalBox( 'MASTER', 22 )
	oView:CreateHorizontalBox( 'DETAIL', 78 )
	
	oView:AddIncrementField( 'FLE001_ITEM', 'ZJ_ITEM' )
	
	oView:SetOwnerView( 'FLE001_CAB' , 'MASTER' )
	oView:SetOwnerView( 'FLE001_ITEM', 'DETAIL' )
	
	oView:SetDescription( cTitulo )
	
	// Exibe o Título do model
	oView:EnableTitleView('FLE001_CAB')
	oView:EnableTitleView('FLE001_ITEM')
	
Return oView

static function VldOK()
	
	local lRet 		:= .T.

return (lRet)

User Function xSepFinal()
	Local cQrySep 	:= ''
	Local nTotSEP 	:= 0
	Local cDataHr   := DtoS(Date()) + Time()
	Local nCx := 0

    If (CB7->CB7_STATUS == '1' .and. AllTrim(CB7->CB7_HRINIS) == '') .or. CB7->CB7_STATUS == '0'
       
        cQrySep += "Select * from "+RetSQLName("CB8")+" CB8 Where CB8.CB8_ORDSEP ='"+CB7->CB7_ORDSEP+"' AND CB8.D_E_L_E_T_ = ' ' ORDER BY CB8.CB8_ITEM" 
        
	    TCQuery cQrySep New Alias "QRY_CB8"
	    //TCSetField("QRY_CB8", "C5_EMISSAO", "D")
	    Count To nTotSEP

	    //Somente se houver ITENS
	    If nTotSEP != 0
			CB7->(recLock("CB7", .F.))
			 CB7->CB7_STATUS := '2'
			 CB7->CB7_CODOPE := '000003'
			 CB7->CB7_DTINIS := DATE()
			 CB7->CB7_HRINIS := SUBS(Time(),1,2)+SUBS(TIME(),4,2)+SUBS(TIME(),7,2)
			CB7->(msUnlock())

			dbSelectArea("SC5")
			If dbSeek(xFilial("SC5")+CB7->CB7_PEDIDO)
				RecLock("SC5",.F.)
					SC5->C5_ZZSTATU := "B" //AGUARDANDO CONFERENCIA
				MsUnlock()
			EndIf

        	dbSelectArea("ZZ1")
        	if dbSeek(xFilial("ZZ1")+CB7->CB7_PEDIDO)
            	RecLock("ZZ1",.F.)
                	/*/
                	ZZ1_FILIAL      := xFilial("ZZ1")
                	ZZ1->ZZ1_PEDIDO := cPedido
               		ZZ1->ZZ1_I_FS01 := SPACE(13)
                	ZZ1->ZZ1_F_FS01 := SPACE(13)
                	ZZ1->ZZ1_I_FS02 := SPACE(13)
                	ZZ1->ZZ1_F_FS02 := cDataHr
					
                	ZZ1->ZZ1_I_FS03 := cDataHr
					/*/
                	ZZ1->ZZ1_F_FS03 := cDataHr
                	ZZ1->ZZ1_I_FS04 := cDataHr
                	ZZ1->ZZ1_F_FS04 := SPACE(13)
                	ZZ1->ZZ1_I_FS05 := SPACE(13)
                	ZZ1->ZZ1_F_FS05 := SPACE(13)
                	ZZ1->ZZ1_I_FS06 := SPACE(13)
                	ZZ1->ZZ1_F_FS06 := SPACE(13)
                	//ZZ1->ZZ1_EXCLUS := cDataHr
            	MsUnlock()
        	EndIf

		    //Enquanto houver ITENS
		    QRY_CB8->(DbGoTop())
		    While ! QRY_CB8->(EoF())
              
			 //posiciona no produto para pegar o fator de conversão
			 DbSelectArea('SB1');SB1->(DbSetOrder(1));SB1->(DbSeek(xFilial('SB1')+QRY_CB8->CB8_PROD))

			 //quantidade de caixas
			 nQuantCx := IIF(ROUND(QRY_CB8->CB8_SALDOS / SB1->B1_CONV,0)<=0, 1, ROUND(QRY_CB8->CB8_SALDOS / SB1->B1_CONV,0))
			
			  For nCx :=1 To nQuantCx
				dbSelectArea("CB9")
				If CB9->(recLock("CB9", .T.))
						CB9->CB9_FILIAL := xFilial()
						CB9->CB9_ORDSEP := QRY_CB8->CB8_ORDSEP  // NUMERO DA ORDEM DE SEPARAÇÃO
						CB9->CB9_PROD   := QRY_CB8->CB8_PROD    // CODIGO DO PRODUTO
						CB9->CB9_SEQUEN := '01'                 // '01'
						CB9->CB9_QTESEP := SB1->B1_CONV  		// QUANTIDADE SEPARADA  // NÃO SERVE PARA QUANTIDADE QUEBRADA, AVISADO A TODOS SOBRE ISSO, CAIXA ABERTA NÃO FUNCIONA
						CB9->CB9_ITESEP := QRY_CB8->CB8_ITEM    // REFERE-SE AO ITEM DO CB8
						CB9->CB9_CODSEP := '000003'             // CODIGO DO SEPARADOR NO AUTOMATICO = '000003'
						CB9->CB9_STATUS := '1'                  // SEPARAÇÃO = '1'
						CB9->CB9_LOTECT := QRY_CB8->CB8_LOTECT  // LOTE
						CB9->CB9_LOCAL  := '01'                 // '01'
						CB9->CB9_LCALIZ := '01000'              // CHUMBADO LOCALIZAÇÃO '01000'
						CB9->CB9_LOTSUG := QRY_CB8->CB8_LOTECT  // LOTE
						CB9->CB9_PEDIDO := QRY_CB8->CB8_PEDIDO  // PEDIDO
					CB9->(msUnlock())
				EndIf
			  Next

			  CB8->(DbSetOrder(1))  //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD                                                                                                              
			  IF CB8->(DbSeek(xFilial('CB8')+QRY_CB8->CB8_ORDSEP+QRY_CB8->CB8_ITEM+'01'+QRY_CB8->CB8_PROD))
			 	 CB8->(recLock("CB8", .F.))
				  CB8->CB8_SALDOS := 0
				 CB8->(msUnlock())
			  EndIf

			 QRY_CB8->(DbSkip())
			EndDo
		EndIf
        
		QRY_CB8->(DBCLOSEAREA())
		MsgAlert("Ordem de Separação finalizada", "OK")
        
     Else
        MsgAlert("Impossível finalizar esta Ordem de Separação!", "Atensão")
    Endif

Return
