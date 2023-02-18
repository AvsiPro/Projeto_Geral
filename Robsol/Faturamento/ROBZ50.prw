#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "Fileio.ch"

Static cTitulo := "Chamados Portal - Robsol"

/*/{Protheus.doc} ROBZ50
    @long_description  Tela MVC Chamados Portal - Robsol
    @type User Function
    @author Felipe Mayer
    @since 23/08/2022
    @version 1
/*/

User Function ROBZ50()

    Local oBrowseZ50
    Local nIgnore := 1

    SetFunName("ROBZ50")

    oBrowseZ50 := FwmBrowse():new()
    oBrowseZ50:SetAlias("Z50")
    oBrowseZ50:SetDescription(cTitulo)

    oBrowseZ50:AddLegend( "Z50->Z50_STATUS == '1'", "YELLOW", "Chamado Aberto",'1' )
    oBrowseZ50:AddLegend( "Z50->Z50_STATUS == '2'", "BLUE",   "Chamado Atendido",'1')
    oBrowseZ50:AddLegend( "Z50->Z50_STATUS == '3'", "RED",    "Chamado Negado",'1')
    oBrowseZ50:AddLegend( "Z50->Z50_STATUS == '4'", "GREEN",  "Chamado Finalizado",'1')

    oBrowseZ50:AddLegend( "u_ROBNOTF()", "EDITABLE",  "Chamado Finalizado",'2')

    //Tratativa para ignorar warnings de ViewDef e ModelDef nunca chamados
    If nIgnore == 0
        ModelDef()
        ViewDef()
    EndIf

    oBrowseZ50:Activate()
    
Return NIL

 
Static Function MenuDef()

Local aRot := {}

    ADD OPTION aRot TITLE 'Visualizar'        ACTION 'VIEWDEF.ROBZ50'  OPERATION MODEL_OPERATION_VIEW  ACCESS 0
    ADD OPTION aRot TITLE 'Atender Chamado'   ACTION 'u_ROBFAT06'      OPERATION 3                     ACCESS 0
    ADD OPTION aRot TITLE 'Finalizar Chamado' ACTION 'u_ENCERCHM'      OPERATION 6                     ACCESS 0
    ADD OPTION aRot TITLE 'Legenda'           ACTION 'u_ROBTLEG'       OPERATION 7                     ACCESS 0

Return aRot

 
Static Function ModelDef()

Local oModel := Nil
Local oStZ50 := FWFormStruct(1, "Z50")
     
    oStZ50:SetProperty('Z50_CODIGO',MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN,'.F.'))
    
    oModel := MPFormModel():New("ROBZ50M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
    oModel:AddFields("FORMZ50",/*cOwner*/,oStZ50)
    oModel:SetPrimaryKey({'Z50_FILIAL','Z50_NOTA','Z50_CODCLI','Z50_LOJCLI','Z50_EMISSA','Z50_PROD'})
    oModel:SetDescription(cTitulo)
    oModel:GetModel("FORMZ50"):SetDescription(cTitulo)

Return oModel

 
Static Function ViewDef()
     
Local oModel := FWLoadModel("ROBZ50")
Local oStZ50 := FWFormStruct(2,"Z50")
Local oView := Nil
 
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_Z50", oStZ50, "FORMZ50")
    oView:CreateHorizontalBox("TELA",100)
    oView:EnableTitleView('VIEW_Z50', 'Dados - '+cTitulo )  
    oView:SetCloseOnOk({||.T.})
    oView:SetOwnerView("VIEW_Z50","TELA")

    oStZ50:RemoveField('Z50_NOTA')
     
Return oView


User Function ROBTLEG()

Local aLegenda := {}
     
    AADD(aLegenda,{"BR_AZUL",        "Chamado Atendido"   })
    AADD(aLegenda,{"BR_AMARELO",     "Chamado Aberto"     })
    AADD(aLegenda,{"BR_VERMELHO",    "Chamado Negado"     })
    AADD(aLegenda,{"BR_VERDE",       "Chamado Finalizado" })
     
    BrwLegenda(cTitulo, "Status", aLegenda)
Return


User Function ROBNOTF()

Local cNotif  := ''

oFile := FWFileReader():New('\updchamados\chamado_'+AllTrim(Z50->Z50_CODIGO)+'\notification.txt')

If (oFile:Open())
    If !(oFile:EoF())
        cNotif := oFile:FullRead()
    EndIf
    
    oFile:Close()
EndIf

Return cNotif == 'visualizou'
