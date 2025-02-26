#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"


/*/{Protheus.doc}	CONFAUTO
Ordem de separação automática (solução paliativa)

@author				Paulo Lima
@since				28/04/2022
@return				Nil
/*/
User Function CONFAUTO()
	
	Local oBrowse
	
	Private cTitulo := "Conferencia Paliativa" 
	
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
	
	//ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CONFAUTO' OPERATION 2 ACCESS 0
    aadd(aRotina,{'FINALIZAR CONFERENCIA', 'u_xConFinal()' , 0 , 3,0,NIL}) 
	aadd(aRotina,{'STATUS', 'u_zStatusP()' , 0 , 3,0,NIL}) 
	//ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CONFAUTO' OPERATION 3 ACCESS 0
	//ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CONFAUTO' OPERATION 4 ACCESS 0
	//ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CONFAUTO' OPERATION 5 ACCESS 0
	
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
	Local oModel     := FWLoadModel( 'CONFAUTO' )
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

User Function xConFinal()
	Local cQrySep 	:= ''
	Local nTotSEP 	:= 0
	Local cDataHr   := DtoS(Date()) + Time()
    Local _cNewVol  := ""

    If (CB7->CB7_STATUS == '2' .and. AllTrim(CB7->CB7_NOTA) == '')
       
        cQrySep += "Select * from "+RetSQLName("CB9")+" CB9 Where CB9.CB9_ORDSEP ='"+CB7->CB7_ORDSEP+"' AND CB9.D_E_L_E_T_ = ' ' ORDER BY CB9.CB9_ITESEP" 
        
	    TCQuery cQrySep New Alias "QRY_CB9"
	    //TCSetField("QRY_CB9", "C5_EMISSAO", "D")
	    Count To nTotSEP

	    //Somente se houver ITENS na CB9 (itens separados)
	    If nTotSEP != 0
			CB7->(recLock("CB7", .F.))
			 CB7->CB7_STATUS := '4'
			CB7->(msUnlock())

			dbSelectArea("SC5")
			If dbSeek(xFilial("SC5")+CB7->CB7_PEDIDO)
				RecLock("SC5",.F.)
					SC5->C5_ZZSTATU := "C" //AGUARDANDO PRE NOTA FISCAL
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
                	ZZ1->ZZ1_F_FS03 := cDataHr
					
                	ZZ1->ZZ1_I_FS04 := cDataHr
					/*/
                    ZZ1->ZZ1_F_FS04 := cDataHr
                	ZZ1->ZZ1_I_FS05 := cDataHr
                	ZZ1->ZZ1_F_FS05 := SPACE(13)
                	ZZ1->ZZ1_I_FS06 := SPACE(13)
                	ZZ1->ZZ1_F_FS06 := SPACE(13)
                	//ZZ1->ZZ1_EXCLUS := cDataHr
            	MsUnlock()
        	EndIf

		    //Enquanto houver ITENS
		    QRY_CB9->(DbGoTop())
		    While ! QRY_CB9->(EoF())
              
			 //ir no cadastro de volumes CB6 e criar o volume para esse item do SB9
             _cNewVol := GetSX8Num("CB6", "CB6_VOLUME")
             If CB6->(recLock("CB6", .T.))
                    CB6->CB6_FILIAL     := xFilial()
                    CB6->CB6_VOLUME     := _cNewVol
                    CB6->CB6_PEDIDO     := QRY_CB9->CB9_PEDIDO
                    CB6->CB6_TIPVOL     := "001"
                    CB6->CB6_STATUS     := "1"
                CB7->(msUnlock())
                ConfirmSX8()
              Else
                RollBackSX8()	
             EndIf

             //ir no CB8 e regularizar para conferência
             //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD                                                                                                              
			 DbSelectArea('CB8');CB8->(DbSetOrder(1));CB8->(DbSeek(xFilial('CB8')+QRY_CB9->CB9_ORDSEP+QRY_CB9->CB9_ITESEP+"01"+QRY_CB9->CB9_PROD))
             If CB8->(recLock("CB8", .F.))
                    CB8->CB8_SALDOE     := CB8->CB8_QTDORI
                CB8->(msUnlock())
             EndIf

             //ir no CB9 e regularizar para conferência
             //CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER+CB9_LOTSUG+CB9_SLOTSU+CB9_SUBVOL+CB9_CODETI                     
			 DbSelectArea('CB9');CB9->(DbGoTo(QRY_CB9->R_E_C_N_O_))
				If CB9->(recLock("CB9", .F.))
						CB9->CB9_VOLUME := _cNewVol
						CB9->CB9_STATUS := '2'                  // EMBALAGEM FINALIZADA = '2'
					CB9->(msUnlock())
				EndIf

			 QRY_CB9->(DbSkip())
			EndDo
		EndIf
        
        QRY_CB9->(DBCLOSEAREA())
		MsgAlert("Conferência finalizada", "OK")
        
     Else
        MsgAlert("Impossível conferir esta Ordem de Separação!", "Atensão")
    Endif

Return
