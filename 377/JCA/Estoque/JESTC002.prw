#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JESTC002()

Local oBrowse := FwLoadBrw("JESTC002")
    
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

    oBrowse:SetAlias("ZPI")
    oBrowse:SetDescription("Cadastro de Ferramentas JCA")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JESTC002")
   //oBrowse:SetFilterDefault( "ZPI->A3_XFUNCAO == '2'" )
   oBrowse:AddLegend( "ZPI->ZPI_STATUS == 'L'"	, "GREEN",    	"Liberada" )
   oBrowse:AddLegend( "ZPI->ZPI_STATUS == 'B'"	, "RED",    	"Bloqueada" )
   oBrowse:AddLegend( "ZPI->ZPI_STATUS == 'M'"	, "BLACK",    	"Manutenção" )
   oBrowse:AddLegend( "ZPI->ZPI_STATUS == 'E'"	, "YELLOW",    	"Emprestada" )
   


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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JESTC002' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u__JestC2()'      OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JESTC002' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.JESTC002' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JESTC002' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("JESTC2")
Local oStruSC5 := FwFormStruct(1, "ZPI")
//Local oStruSC6 := FwFormStruct(1, "Z30")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("ZPIMASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "ZPIMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPI_FILIAL", "ZPI_CODFER" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    //oModel:SetRelation("Z30DETAIL", {{"Z30_FILIAL", "FwXFilial('Z30')"}, {"Z30_CODGER", "A3_COD"}}, Z30->(IndexKey(1)))

    //oStruSC5:AddTrigger("ZPI_CODPRT", "ZPI_CODPRT",{|| .T.}, {|| POSICIONE("SH4",1,XFILIAL("SH4")+oModel:GetValue('ZPIMASTER','ZPI_CODPRT'),"H4_DESCRI") })
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Ferramentas")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("ZPIMASTER"):SetDescription("Cabeçalho")
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
Local oStruSC5 := FwFormStruct(2, "ZPI")
//Local oStruSC6 := FwFormStruct(2, "Z30")
Local oModel   := FwLoadModel("JESTC002")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("ZPI_FILIAL")
    //oStruSC6:RemoveField("Z30_FILIAL")
    //oStruSC6:RemoveField("ZY1_CODIGO")

    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPIMASTER")

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


/*/{Protheus.doc} Legendas
(long_description)
@type user function
@author user
@since 25/10/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
USER FUNCTION _JestC2()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE"   ,    "Liberada"    })
    AADD(aLegenda,{"BR_VERMELHO",    "Bloqueada"    })
	AADD(aLegenda,{"BR_PRETO"	,    "Manutenção"        })
	AADD(aLegenda,{"BR_AMARELO"	,    "Emprestada"        })
	 
    BrwLegenda('Cadastro de Ferramentas', "Status", aLegenda)

RETURN

 /*/{Protheus.doc} JESTC2
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function JESTC2

Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.

Local nLinha     := 0
Local nQtdLinhas := 0
Local cMsg       := ''
Local nQtd       := 0
Local nQtF       := 0


If aParam <> NIL
      
       oObj       := aParam[1]
       cIdPonto   := aParam[2]
       cIdModel   := aParam[3]
       lIsGrid    := ( Len( aParam ) > 3 )
      
       
      
    If     cIdPonto == 'MODELPOS'
        xRet := .t.

        If !ALTERA .AND. !INCLUI 
            If ZPI->ZPI_STATUS <> 'L'
                ApMsgInfo("Status da ferramenta não permite a exclusão")
                xRet := .f.
            EndIf 
            
            If xRet
                cQuery := "SELECT 'J',COUNT(*) AS QTD FROM "+RetSQLName("ZPJ")
                cQuery += " WHERE D_E_L_E_T_=' ' AND ZPJ_CODFER='"+ZPI->ZPI_CODFER+"'"
                cQuery += " UNION " 
                cQuery += " SELECT 'K',COUNT(*) AS QTD FROM "+RetSQLName("ZPK")
                cQuery += " WHERE D_E_L_E_T_=' ' AND ZPK_CODFER='"+ZPI->ZPI_CODFER+"'"
                cQuery += " UNION
                cQuery += " SELECT 'L',COUNT(*) AS QTD FROM "+RetSQLName("ZPL")
                cQuery += " WHERE D_E_L_E_T_=' ' AND ZPL_CODFER='"+ZPI->ZPI_CODFER+"'"

                cQuery := ChangeQuery(cQuery)

                If Select("TMPZPC") > 0
                    TMPZPC->( dbclosearea() )
                Endif

                DbUseArea(.T.,'TOPCONN', TcGenQry(,,cQuery),'TMPZPC', .T., .T.)

                TMPZPC->( dbgotop() )

                lBox := .F.
                
                While TMPZPC->(!eof())
                    If TMPZPC->QTD > 0
                        lBox := .T.
                    EndIF 
                    Dbskip()
                EndDo 

                If lBox
                    ApMsgInfo("Ferramenta já atrelada a caixa ou com ocorrência, não será permitido a exclusão")
                    xRet := .f.
                    
                EndIf 
            EndIf 
        EndIf 
    elseIf     cIdPonto == 'MODELPRE'
        xRet := .t.
            
    ElseIf cIdPonto == 'FORMPOS'
            xRet := .t.

            DbSelectArea("SH4")
            DbSetOrder(1)
            If Dbseek(xFilial("SH4")+M->ZPI_CODPRT)
                nQtd := SH4->H4_QUANT
            EndIf 
            
            cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName("ZPI")
            cQuery += " WHERE D_E_L_E_T_=' ' AND ZPI_CODPRT='"+M->ZPI_CODPRT+"'"
            cQuery += " AND ZPI_FILIAL='"+xFilial("ZPI")+"'"

            cAliasTMP := GetNextAlias()
            MPSysOpenQuery(cQuery, cAliasTMP)

            If (cAliasTMP)->(!EoF()) 
                nQtF := (cAliasTMP)->QTD
            endIf 

            If nQtF >= nQtd
                ApMsgInfo("Não será permitido a inclusão por ter sido ultrapassada a quantidade de ferramentas disponíveis para este código")
                xRet := .f.
            endif

            (cAliasTMP)->(DbCloseArea())
            
    ElseIf cIdPonto == 'FORMLINEPRE'
            xRet := .t.
            If aParam[5] == 'DELETE'
                If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
                    Help( ,, 'Help',, 'O FORMLINEPRE retornou .F.', 1, 0 )
                EndIf
            endIf
            
    ElseIf cIdPonto == 'FORMLINEPOS'

        xRet := .t.
       /* cMsg := 'Chamada na validação da linha do formulário (FORMLINEPOS).' 
        cMsg += 'ID ' + cIdModel + CRLF
        cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
        cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
            
        If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
            Help( ,, 'Help',, 'O FORMLINEPOS retornou .F.', 1, 0 )
        EndIf*/
            
    ElseIf cIdPonto == 'MODELCOMMITTTS'
        //ApMsgInfo('Chamada apos a gravação total do modelo e dentro da transação (MODELCOMMITTTS).' + CRLF + 'ID ' + cIdModel )
            
    ElseIf cIdPonto == 'MODELCOMMITNTTS'
        //ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
            
    ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
            
    ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
        //ApMsgInfo('Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
            
    ElseIf cIdPonto == 'MODELCANCEL'
        xRet := .t.
      /*  cMsg := 'Chamada no Botão Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'
            
        If !( xRet := ApMsgYesNo( cMsg ) )
            Help( ,, 'Help',, 'O MODELCANCEL retornou .F.', 1, 0 )
        endIf*/
            
    ElseIf cIdPonto == 'BUTTONBAR'
        xRet := .t.
        //ApMsgInfo('Adicionando Botao na Barra de Botoes (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )
        //xRet := { {'Salvar', 'SALVAR', { || Alert( 'Salvou' ) }, 'Este botao Salva' } }
            
    EndIf

EndIf

Return xRet
