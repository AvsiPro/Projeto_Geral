#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JESTM004()

Local oBrowse := FwLoadBrw("JESTM004")
    
oBrowse:Activate()

Return (NIL)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do Browse                                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function BrowseDef()

Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("ZPL")
    oBrowse:SetDescription("Cadastro de Ocorrencias")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JESTM004")
   //oBrowse:SetFilterDefault( "ZPL->A3_XFUNCAO == '2'" )


Return (oBrowse)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu DEF                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()

Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JESTM004' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JESTM004' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.JESTM004' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("JESTM4")
Local oStruSC5 := FwFormStruct(1, "ZPL")
//Local oStruSC6 := FwFormStruct(1, "Z30")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("ZPLMASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "ZPLMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPL_FILIAL", "ZPL_CODIGO" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    //oModel:SetRelation("Z30DETAIL", {{"Z30_FILIAL", "FwXFilial('Z30')"}, {"Z30_CODGER", "A3_COD"}}, Z30->(IndexKey(1)))

    //oStruSC6:AddTrigger("ZY1_VEND", "ZY1_NVEND",{|| .T.}, {|| POSICIONE("ZPL",1,XFILIAL("ZPL")+oModel:GetValue('ZY1DETAIL','ZY1_VEND'),"A3_NOME") })
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Ocorrencias")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("ZPLMASTER"):SetDescription("Cabeçalho")
    //oModel:GetModel("Z30DETAIL"):SetDescription("Itens")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação // INTERFACE GRÁFICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "ZPL")
//Local oStruSC6 := FwFormStruct(2, "Z30")
Local oModel   := FwLoadModel("JESTM004")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("ZPL_FILIAL")
    //oStruSC6:RemoveField("Z30_FILIAL")
    //oStruSC6:RemoveField("ZY1_CODIGO")

    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPLMASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    //oView:AddGrid("VIEW_SC6", oStruSC6, "Z30DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    //oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    //oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÍTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    //oView:EnableTitleView("VIEW_SC6", "REPRESENTANTES", RGB(224, 30, 43))
    
Return (oView)


User Function JESTM4()

Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.

Local nLinha     := 0
Local nQtdLinhas := 0
Local cMsg       := ''


If aParam <> NIL
      
       oObj       := aParam[1]
       cIdPonto   := aParam[2]
       cIdModel   := aParam[3]
       lIsGrid    := ( Len( aParam ) > 3 )
      
       If     cIdPonto == 'MODELPOS'
             cMsg := 'Chamada na validação total do modelo (MODELPOS).' + CRLF
             
       ElseIf cIdPonto == 'FORMPOS'
             cMsg := 'Chamada na validação total do formulário (FORMPOS).' + CRLF
             
       ElseIf cIdPonto == 'FORMLINEPRE'
             If aParam[5] == 'DELETE'
                    cMsg := 'Chamada na pre validação da linha do formulário (FORMLINEPRE).' + CRLF
                   
             /*       If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
                           Help( ,, 'Help',, 'O FORMLINEPRE retornou .F.', 1, 0 )
                    EndIf*/
             EndIf
            
       ElseIf cIdPonto == 'FORMLINEPOS'
            cMsg := 'Chamada na validação da linha do formulário (FORMLINEPOS).' + CRLF
            
            
       ElseIf cIdPonto == 'MODELCOMMITTTS'
                       
            DbSelectArea("ZPI")
            DbSetOrder(1)
            If DbSeek(xFilial('ZPI')+ZPL->ZPL_CODFER)
                Reclock("ZPI",.F.)
                ZPI->ZPI_STATUS := If(ZPL->ZPL_STATUS=='A','B','M')
                ZPI->(Msunlock())
            EndIf 
            
            DbSelectArea("ZPK")
            DbSetOrder(2)
            If Dbseek(xFilial("ZPK")+ZPL->ZPL_CODFER)
                While !Eof() .and. ZPK->ZPK_FILIAL == ZPL->ZPL_FILIAL .AND. ZPK_CODFER == ZPL->ZPL_CODFER .AND. EMPTY(ZPK_DTDEVO)
                    Reclock("ZPK",.F.)
                    ZPK->ZPK_CODOCO = ZPL_CODIGO
                    ZPK->(Msunlock())
                    Dbskip()
                Enddo 
            EndIf 
       ElseIf cIdPonto == 'MODELCOMMITNTTS'
            //ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
            
            
       ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
            //ApMsgInfo('Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
            
       ElseIf cIdPonto == 'MODELCANCEL'
            cMsg := 'Chamada no Botão Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'
            
            
       ElseIf cIdPonto == 'BUTTONBAR'
            
       EndIf

EndIf

Return xRet
