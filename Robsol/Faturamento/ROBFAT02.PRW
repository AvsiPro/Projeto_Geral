#Include "TOTVS.ch"
#INCLUDE 'PROTHEUS.CH'
#Include "FWMVCDEF.ch"
#include "fileio.ch"

/*/{Protheus.doc} ROBFAT02
    Rotina de inclusão de catalogos no Portal Robsol
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
User Function ROBFAT02

Local oBrowse := FwLoadBrw("ROBFAT02")
Public cFileLoc := ""

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

    oBrowse:SetAlias("Z41")
    oBrowse:SetDescription("Cadastro de Catalogos no Portal Robsol")

   // DEFINE DE ONDE SERÝ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROBFAT02")
   //oBrowse:SetFilterDefault( "SA3->A3_XFUNCAO == '2'" )


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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ROBFAT02' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    //ADD OPTION aRot TITLE 'Equipes'    ACTION 'U_xRBMS01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ROBFAT02' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ROBFAT02' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ROBFAT02' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("ROBFAT")
Local oStruSC5 := FwFormStruct(1, "Z41")
//Local oStruSC6 := FwFormStruct(1, "Z30")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("Z41MASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "Z41MASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "Z41_FILIAL", "Z41_CODIGO" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    //oModel:SetRelation("Z30DETAIL", {{"Z30_FILIAL", "FwXFilial('Z30')"}, {"Z30_CODGER", "A3_COD"}}, Z30->(IndexKey(1)))

    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Catalogos")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("Z41MASTER"):SetDescription("Cabeçalho")
    //oModel:GetModel("Z30DETAIL"):SetDescription("Itens")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação // INTERFACE GRÝFICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "Z41")
//Local oStruSC6 := FwFormStruct(2, "Z30")
Local oModel   := FwLoadModel("ROBFAT02")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("Z41_FILIAL")
        
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z41", oStruSC5, "Z41MASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    //oView:AddGrid("VIEW_SC6", oStruSC6, "Z30DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    //oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_Z41", "EMCIMA")
    //oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÝTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_Z41")
    //oView:EnableTitleView("VIEW_SC6", "REPRESENTANTES", RGB(224, 30, 43))
    
Return (oView)
/*---------------------------------------------------------------------*
 | Func:  Pónto de entrada                                             |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação //                                                   |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
User Function ROBFAT()

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

       /*If lIsGrid
       nQtdLinhas := oObj:GetQtdLine()
       nLinha     := oObj:nLine
       EndIf*/

       If     cIdPonto == 'MODELPOS'
              /*cMsg := 'Chamada na validação total do modelo (MODELPOS).' + CRLF
              cMsg += 'ID ' + cIdModel + CRLF
              
              If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
                     Help( ,, 'Help',, 'O MODELPOS retornou .F.', 1, 0 )
              EndIf*/
              
       ElseIf cIdPonto == 'FORMPOS'
              
              /*
              If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
                     Help( ,, 'Help',, 'O FORMPOS retornou .F.', 1, 0 )
              EndIf*/
              
       ElseIf cIdPonto == 'FORMLINEPRE'
              /*If aParam[5] == 'DELETE'
                     cMsg := 'Chamada na pre validação da linha do formulário (FORMLINEPRE).' + CRLF
                                   cMsg += 'Onde esta se tentando deletar uma linha' + CRLF
                                   cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) +;
                     ' linha(s).' + CRLF
                     cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) +  CRLF
                     cMsg += 'ID ' + cIdModel + CRLF 
                     
                     If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
                            Help( ,, 'Help',, 'O FORMLINEPRE retornou .F.', 1, 0 )
                     EndIf
              EndIf*/
              
       ElseIf cIdPonto == 'FORMLINEPOS'
              /*cMsg := 'Chamada na validação da linha do formulário (FORMLINEPOS).' + CRLF
                     cMsg += 'ID ' + cIdModel + CRLF
                     cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ;
              ' linha(s).' + CRLF
                     cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
              
              If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
                     Help( ,, 'Help',, 'O FORMLINEPOS retornou .F.', 1, 0 )
              EndIf*/
              
       ElseIf cIdPonto == 'MODELCOMMITTTS'
              //ApMsgInfo('Chamada apos a gravação total do modelo e dentro da transação (MODELCOMMITTTS).' + CRLF + 'ID ' + cIdModel )
              
       ElseIf cIdPonto == 'MODELCOMMITNTTS'
              //ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
              
              //ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
              
       ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
              //ApMsgInfo('Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
              
       ElseIf cIdPonto == 'MODELCANCEL'
              cMsg := 'Chamada no Botão Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'
              
              If !( xRet := ApMsgYesNo( cMsg ) )
                     Help( ,, 'Help',, 'O MODELCANCEL retornou .F.', 1, 0 )
              EndIf
              
       ElseIf cIdPonto == 'BUTTONBAR'
              //ApMsgInfo('Adicionando Botao na Barra de Botoes (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )
              xRet := { {'Incluir Catalogo', 'Catalog', { || u__IncPdf(aparam) }, 'Incluir Catalogo' } }
              //msgalert(M->Z41_ARQUIV)
              
       EndIf
     
       /*If !Empty(M->Z41_ARQUIV)  //.And. cIdPonto == 'BUTTONBAR'*/
              //If cIdPonto != 'FORMPOS' // AttIsMemberOf(aparam[1],"ADATAMODEL")
                     
              //endIf
       /*EndIf*/

EndIf

If !Empty(cFileLoc) .And. CIDPONTO == 'FORMPRE'//.And. AttIsMemberOf(aparam[1],"ADATAMODEL")

       APARAM[1]:ADATAMODEL[1][6][2]      :=     cFileLoc
       M->Z41_ARQUIV                      :=     cFileLoc

EndIf 

Return xRet

/*/{Protheus.doc} _incpdf
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
User Function _IncPdf(aparam)

Local cCaminho
Local aAux    :=     {}
Local cRet    :=     ""

cCaminho := cGetFile( '*.pdf|*.pdf' , 'Selecionar um diretório', 0, 'C:\', .F., GETF_ONLYSERVER+GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_OVERWRITEPROMPT)
//       AllTrim(cGetFile(cFormat, "Selecione o arquivo ",0,"", .F.,GETF_ONLYSERVER+GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_OVERWRITEPROMPT))

aAux := strtokarr(cCaminho,"\")

cRet := aAux[len(aAux)]

Processa({|| CpyT2S(cCaminho,'\catalogos\',.T.,.T.), "Aguarde, copiando o arquivo para o servidro"}) 


cFileLoc := '/catalogos/'+cRet 

Return(cRet)
