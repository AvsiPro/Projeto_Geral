#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function ROBCMS01()

Local oBrowse := FwLoadBrw("ROBCMS01")
    
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

    oBrowse:SetAlias("SA3")
    oBrowse:SetDescription("Cadastro de Equipe de Vendas")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROBCMS01")
   oBrowse:SetFilterDefault( "SA3->A3_XFUNCAO == '2'" )


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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ROBCMS01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Equipes'    ACTION 'U_xRBMS01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
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

Local oModel   := MPFormModel():New("ROBCMS")
Local oStruSC5 := FwFormStruct(1, "SA3")
Local oStruSC6 := FwFormStruct(1, "Z30")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("SA3MASTER", NIL, oStruSC5)
    oModel:AddGrid("Z30DETAIL", "SA3MASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "A3_FILIAL", "A3_COD" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    oModel:SetRelation("Z30DETAIL", {{"Z30_FILIAL", "FwXFilial('Z30')"}, {"Z30_CODGER", "A3_COD"}}, Z30->(IndexKey(1)))

    //oStruSC6:AddTrigger("ZY1_VEND", "ZY1_NVEND",{|| .T.}, {|| POSICIONE("SA3",1,XFILIAL("SA3")+oModel:GetValue('ZY1DETAIL','ZY1_VEND'),"A3_NOME") })
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Equipes")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("SA3MASTER"):SetDescription("Cabeçalho")
    oModel:GetModel("Z30DETAIL"):SetDescription("Itens")
    
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
Local oStruSC5 := FwFormStruct(2, "SA3")
Local oStruSC6 := FwFormStruct(2, "Z30")
Local oModel   := FwLoadModel("ROBCMS01")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("A3_FILIAL")
    oStruSC6:RemoveField("Z30_FILIAL")
    //oStruSC6:RemoveField("ZY1_CODIGO")

    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "SA3MASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    oView:AddGrid("VIEW_SC6", oStruSC6, "Z30DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÍTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    oView:EnableTitleView("VIEW_SC6", "REPRESENTANTES", RGB(224, 30, 43))
    
Return (oView)

/*/{Protheus.doc} Equipes


    (long_descr
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xRBMS01

Local nOpc      :=  0
Private aList1  := {}
Private aList2  := {}
Private aList3  := {}
Private aList4  := {}
Private aList5  := {}
Private aList2b := {}
Private aList3b := {}
Private aList4b := {}
Private aList5b := {}

Private oDlg1
Private oGrp1
Private oGrp2
Private oGrp3
Private oGrp4
Private oGrp5
Private oBtn1
Private oBtn2
Private oBtn3
Private oBtn4
Private oBtn5
Private oBtn6
Private oBtn7
Private oMenu1
Private oMenu2

Private oList1
Private oList2
Private oList3
Private oList4
Private oList5

Private oVd     := LoadBitmap(GetResources(),'BR_VERDE')
Private oVm     := LoadBitmap(GetResources(),'BR_VERMELHO')
Private oAm     := LoadBitmap(GetResources(),'BR_AMARELO')

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

//Busca itens a exibir na tela equipe comercial
Busca()

oDlg1      := MSDialog():New( 088,212,759,1583,"Equipe Área Comercial",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,200,188,"Gerentes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList1:= 	TCBrowse():New(012,008,176,185,, {'Codigo','Nome'},{50,90},;
                                 oGrp1,,,,{|| Fhelp(oList1:nAt) },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],;
                        aList1[oList1:nAt,02]}}

oGrp2      := TGroup():New( 004,192,200,666,"Representantes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList2:= 	TCBrowse():New(012,196,466,185,, {'','Codigo','Nome','Mala','Regiões','Sub-Regiões'},{10,40,90,80,80,80},;
                                 oGrp2,,,,{|| Fhelp2(oList2:nAt) },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm),;
                        aList2[oList2:nAt,01],;
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04],;
                        aList2[oList2:nAt,05]}}

oGrp3      := TGroup():New( 204,004,316,188,"Malas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList3:= 	TCBrowse():New(212,008,176,102,, {'','Codigo','Nome'},{10,50,90},;
                                 oGrp3,,,,{||  },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList3:SetArray(aList3)
    oList3:bLine := {||{If(aList3[oList3:nAt,len(aList3[oList3:nAt])],oVd,oVm),;
                        aList3[oList3:nAt,01],;
                        aList3[oList3:nAt,02]}}

oGrp4      := TGroup():New( 204,192,316,376,"Regiões",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList4:= 	TCBrowse():New(212,196,176,102,, {'','Codigo','Nome'},{10,50,90},;
                                 oGrp4,,,,{||  },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList4:SetArray(aList4)
    oList4:bLine := {||{If(aList4[oList4:nAt,len(aList4[oList4:nAt])],oVd,oVm),;
                        aList4[oList4:nAt,01],;
                        aList4[oList4:nAt,02]}}

oGrp5      := TGroup():New( 204,380,316,567,"Sub-Regiões",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList5:= 	TCBrowse():New(212,384,176,102,, {'','Codigo','Nome'},{10,50,90},;
                                 oGrp5,,,,{||  },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList5:SetArray(aList5)
    oList5:bLine := {||{If(aList5[oList5:nAt,len(aList5[oList5:nAt])],oVd,oVm),;
                        aList5[oList5:nAt,01],;
                        aList5[oList5:nAt,02]}}

oBtn1      := TButton():New( 319,065,"Incluir/Excluir Mala",oDlg1,{|| Mala(oList3:nAt,oList2:nAt)},062,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 319,245,"Incluir/Excluir Região",oDlg1,{|| Regiao(oList4:nAt,oList2:nAt)},062,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 319,430,"Incluir/Excluir Sub-Região",oDlg1,{|| SubReg(oList5:nAt,oList2:nAt)},062,012,,,,.T.,,"",,,,.F. )
oBtn5      := TButton():New( 212,576,"Vendedor s/ Gerente",oDlg1,{|| VendGer()},062,012,,,,.T.,,"",,,,.F. )
oBtn6      := TButton():New( 257,576,"Salvar Alterações",oDlg1,{|| Processa({|| SalvGrid()},"Aguarde") },062,012,,,,.T.,,"",,,,.F. )
oBtn7      := TButton():New( 302,576,"Sair",oDlg1,{|| oDlg1:end(nOpc := 0)},062,012,,,,.T.,,"",,,,.F. )

MENU oMenu1 POPUP 
MENUITEM "Remover Equipe" ACTION ( RemGer(oList1:nAt,1))
//MENUITEM "Bloquear Vendedor" ACTION ( savevend())
ENDMENU                                                                           

oList1:bRClicked := { |oObject,nX,nY| oMenu1:Activate( nX, (nY-10), oObject ) }

MENU oMenu2 POPUP 
MENUITEM "Remover Amarração Gerente" ACTION ( RemGer(oList2:nAt,2))
//MENUITEM "Bloquear Vendedor" ACTION ( savevend())
ENDMENU                                                                           

oList2:bRClicked := { |oObject,nX,nY| oMenu2:Activate( nX, (nY-10), oObject ) }

MENU oMenu5 POPUP 
MENUITEM "Localizar Cidade" ACTION ( loccity(oList5:nAt,2))
ENDMENU                                                                           

oList5:bRClicked := { |oObject,nX,nY| oMenu5:Activate( nX, (nY-10), oObject ) }

oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} Busca()
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function Busca()

Local aArea := GetArea()
Local cQuery 

cQuery := "SELECT DISTINCT A3_COD,A3_NOME "
cQuery += " FROM "+RetSQLName("SA3")
cQuery += " WHERE A3_FILIAL='"+xFilial("SA3")+"' AND A3_MSBLQL<>'1' AND D_E_L_E_T_=' ' AND A3_XFUNCAO='2'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList1,{TRB->A3_COD,TRB->A3_NOME})
    Dbskip()
EndDo

If len(aList1) < 1
    Aadd(aList1,{'',''})
EndIf

cQuery := "SELECT DISTINCT A3_COD,A3_NOME,A3_GEREN,Z30_MALA,Z30_REGIAO,Z30_SUBREG "
cQuery += " FROM "+RetSQLName("SA3")+" A3"
cQuery += " LEFT JOIN "+RetSQLName("Z30")+" Z30 ON Z30_FILIAL='"+xFilial("Z30")+"' AND Z30_CODVEN=A3_COD AND Z30.D_E_L_E_T_=' '"
cQuery += " WHERE A3_FILIAL='"+xFilial("SA3")+"' AND A3_MSBLQL<>'1' AND A3.D_E_L_E_T_=' ' AND A3_XFUNCAO<>'2'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    If !Empty(A3_GEREN)
        //Vendedores com amarração de gerente
        Aadd(aList2b,{TRB->A3_COD,TRB->A3_NOME,Alltrim(TRB->Z30_MALA),;
                    Alltrim(TRB->Z30_REGIAO),Alltrim(TRB->Z30_SUBREG),TRB->A3_GEREN,.T.})
    else
        //Vendedores sem gerente amarrado
        Aadd(aList2b,{TRB->A3_COD,TRB->A3_NOME,Alltrim(TRB->Z30_MALA),;
                    Alltrim(TRB->Z30_REGIAO),Alltrim(TRB->Z30_SUBREG),TRB->A3_GEREN,.T.})
    EndIf
    Dbskip()
EndDo

If len(aList2b) < 1
    Aadd(aList2b,{'','','','','','','','','',.T.})
EndIf

cQuery := "SELECT DISTINCT Z03_CODGRI,Z03_DESGRI"
cQuery += " FROM "+RetSQLName("Z03")
cQuery += " WHERE Z03_FILIAL='"+xFilial("Z03")+"' AND D_E_L_E_T_=' ' AND Z03_MSBLQL<>'1'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList3,{TRB->Z03_CODGRI,TRB->Z03_DESGRI,.F.})
    Dbskip()
EndDo

If len(aList3) < 1
    Aadd(aList3,{'','','','',.F.})
EndIF

cQuery := "SELECT DISTINCT X5_CHAVE,X5_DESCRI"
cQuery += " FROM "+RetSQLName("SX5")
cQuery += " WHERE X5_FILIAL='"+xFilial("SX5")+"' AND D_E_L_E_T_=' ' AND X5_TABELA='12'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList4,{Alltrim(TRB->X5_CHAVE),Alltrim(TRB->X5_DESCRI),.F.})
    Dbskip()
EndDo

If len(aList4) < 1
    Aadd(aList4,{'','','','','','','','','',.F.})
EndIf 
/*
cQuery := "SELECT DISTINCT X5_CHAVE,X5_DESCRI"
cQuery += " FROM "+RetSQLName("SX5")
cQuery += " WHERE X5_FILIAL='"+xFilial("SX5")+"' AND D_E_L_E_T_=' ' AND X5_TABELA='A2'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList5,{Alltrim(TRB->X5_CHAVE),Alltrim(TRB->X5_DESCRI),.F.})
    Dbskip()
EndDo
*/
cQuery := "SELECT DISTINCT CC2_CODMUN,CC2_MUN,CC2_EST"
cQuery += " FROM "+RetSQLName("CC2")
cQuery += " WHERE CC2_FILIAL='"+xFilial("CC2")+"' AND D_E_L_E_T_=' '"
cQuery += " ORDER BY CC2_MUN"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    //CC2_CODMUN,CC2_MUN,CC2_EST
    Aadd(aList5,{Alltrim(TRB->CC2_CODMUN),Alltrim(TRB->CC2_MUN)+'/'+TRB->CC2_EST,.F.})
    Dbskip()
EndDo
If len(aList5) < 1
    Aadd(aList5,{'','','','','','','','','',.F.})
EndIf 


RestArea(aArea)

Return

/*/{rotheus.doc} Fhelp(nLinha)
    (long_descri
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function Fhelp(nLinha)

Local aArea :=  GetArea()
Local nCont :=  0

aList2 := {}

For nCont := 1 to len(aList2B)
    If Alltrim(aList1[nLinha,01]) == Alltrim(aList2B[nCont,06])
        Aadd(aList2,aList2B[nCont])
    EndIf
Next nCont

If len(aList2) < 1
    Aadd(aList2,{'','','','','','','','','',.T.})
EndIf

oList2:SetArray(aList2)
oList2:bLine := {||{If(aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm),;
                    aList2[oList2:nAt,01],;
                    aList2[oList2:nAt,02],;
                    aList2[oList2:nAt,03],;
                    aList2[oList2:nAt,04],;
                    aList2[oList2:nAt,05]}}

oList2:refresh()
oDlg1:refresh()

Fhelp2(1)

RestArea(aArea)

Return 

/*/{rotheus.doc} Fhelp2(nLinha)
    (long_descri
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function Fhelp2(nLinha)

Local aArea :=  GetArea()
Local nCont :=  0

For nCont := 1 to len(aList3)
    If Alltrim(aList3[nCont,01]) $ Alltrim(aList2[nLinha,03]) 
        aList3[nCont,len(aList3[nCont])] := .T.
    else
        aList3[nCont,len(aList3[nCont])] := .F.
    EndIf
Next nCont

For nCont := 1 to len(aList4)
    If Alltrim(aList4[nCont,01]) $ Alltrim(aList2[nLinha,04]) 
        aList4[nCont,len(aList4[nCont])] := .T.
    else
        aList4[nCont,len(aList4[nCont])] := .F.
    EndIf
Next nCont

For nCont := 1 to len(aList5)
    If Alltrim(aList5[nCont,01]) $ Alltrim(aList2[nLinha,05]) 
        aList5[nCont,len(aList5[nCont])] := .T.
    else
        aList5[nCont,len(aList5[nCont])] := .F.
    EndIf
Next nCont

oList3:refresh()
oList4:refresh()
oList5:refresh()
oDlg1:refresh()

RestArea(aArea)

Return 

/*/{Protheus.doc} Mala
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function Mala(nLin1,nLin2)

Local aArea :=  GetArea()
Local nPos2 :=  Ascan(aList2b,{|x| Alltrim(x[1]) == Alltrim(aList2[nLin2,01])})
Local cBarra:=  If(!Empty(aList2[nLin2,03]),"/","")
Local lCont :=  Alltrim(aList3[nLin1,01]) $ Alltrim(aList2[nLin2,03])
Local aAux  :=  {}
Local nCont :=  0

If !lCont
    aList2[nLin2,03] += cBarra + aList3[nLin1,01]
    aList2[nLin2,len(aList2[nLin2])] := .F.
    aList3[nLin1,len(aList3[nLin1])] := .T.
    aList2b[nPos2,03] := aList2[nLin2,03]
Else
    cBarra := ""
    
    aAux := Separa(aList2[nLin2,03], "/", .T.)
    
    aList2[nLin2,03] := ""
    aList2b[nPos2,03]:= ""

    For nCont := 1 to len(aAux)
        If Alltrim(aAux[nCont]) <> Alltrim(aList3[nLin1,01])
            aList2[nLin2,03] += cBarra + aAux[nCont]
            cBarra := "/"
        EndIf
        
    Next nCont

    aList2[nLin2,len(aList2[nLin2])] := .F.
    aList3[nLin1,len(aList3[nLin1])] := .F.
    aList2b[nPos2,03] := aList2[nLin2,03]
ENDIF

oList2:refresh()
oList3:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} Região
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function Regiao(nLin1,nLin2)

Local aArea :=  GetArea()
Local nPos2 :=  Ascan(aList2b,{|x| Alltrim(x[1]) == Alltrim(aList2[nLin2,01])})
Local cBarra:=  If(!Empty(aList2[nLin2,04]),"/","")
Local lCont :=  Alltrim(aList4[nLin1,01]) $ Alltrim(aList2[nLin2,04])
Local aAux  :=  {}
Local nCont :=  0

If !lCont
    aList2[nLin2,04] += cBarra + aList4[nLin1,01]
    aList2[nLin2,len(aList2[nLin2])] := .F.
    aList4[nLin1,len(aList4[nLin1])] := .T.
    aList2b[nPos2,04] := aList2[nLin2,04]
Else
    cBarra := ""
    
    aAux := Separa(aList2[nLin2,04], "/", .T.)
    
    aList2[nLin2,04] := ""
    aList2b[nPos2,04]:= ""

    For nCont := 1 to len(aAux)
        If Alltrim(aAux[nCont]) <> Alltrim(aList4[nLin1,01])
            aList2[nLin2,04] += cBarra + aAux[nCont]
            cBarra := "/"
        EndIf
        
    Next nCont

    aList2[nLin2,len(aList2[nLin2])] := .F.
    aList4[nLin1,len(aList4[nLin1])] := .F.
    aList2b[nPos2,04] := aList2[nLin2,04]
ENDIF

oList2:refresh()
oList4:refresh()
oDlg1:refresh()

RestArea(aArea)

Return


/*/{Protheus.doc} Sub-Região
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function SubReg(nLin1,nLin2)

Local aArea :=  GetArea()
Local nPos2 :=  Ascan(aList2b,{|x| Alltrim(x[1]) == Alltrim(aList2[nLin2,01])})
Local cBarra:=  If(!Empty(aList2[nLin2,05]),"/","")
Local lCont :=  Alltrim(aList5[nLin1,01]) $ Alltrim(aList2[nLin2,05])
Local aAux  :=  {}
Local aAux2 :=  {}
Local nCont :=  0

If !lCont
    aAux := Separa(aList5[oList5:nAt,02], "/", .T.)
    If !aAux[2] $ Alltrim(aList2[oList2:nAt,04])
        MsgAlert("Cidade selecionada não esta relacionada com nenhuma Região do Vendedor")
    Else
        aList2[nLin2,05] += cBarra + aList5[nLin1,01]
        aList2[nLin2,len(aList2[nLin2])] := .F.
        aList5[nLin1,len(aList5[nLin1])] := .T.
        aList2b[nPos2,05] := aList2[nLin2,05]
    EndIf
Else
    cBarra := ""
    aAux2 := Separa(aList5[oList5:nAt,02], "/", .T.)
    If !aAux2[2] $ Alltrim(aList2[oList2:nAt,04])
        MsgAlert("Cidade selecionada não esta relacionada com nenhuma Região do Vendedor")
    Else
        aAux := Separa(aList2[nLin2,05], "/", .T.)
        
        aList2[nLin2,05] := ""
        aList2b[nPos2,05]:= ""

        For nCont := 1 to len(aAux)
            If Alltrim(aAux[nCont]) <> Alltrim(aList5[nLin1,01])
                aList2[nLin2,05] += cBarra + aAux[nCont]
                cBarra := "/"
            EndIf
            
        Next nCont

        aList2[nLin2,len(aList2[nLin2])] := .F.
        aList5[nLin1,len(aList5[nLin1])] := .F.
        aList2b[nPos2,05] := aList2[nLin2,05]
    EndIf
ENDIF

oList2:refresh()
oList5:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} SalvGrid()
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function SalvGrid(nPosC)

Local aArea :=  GetArea()
Local nCont :=  0
Local nPosG :=  0

DbSelectArea("Z30")
DbSetOrdeR(1)

For nCont := 1 to len(aList2b)
    If !aList2b[nCont,len(aList2b[nCont])]
        nPosG := Ascan(aList2,{|x| Alltrim(x[1]) == Alltrim(aList2b[nCont,01])})
        /*    Aadd(aList2b,{TRB->A3_COD,TRB->A3_NOME,Alltrim(TRB->Z30_MALA),;
                  Alltrim(TRB->Z30_REGIAO),Alltrim(TRB->Z30_SUBREG),TRB->A3_GEREN,.T.})
        */
        If !Dbseek(xFilial("Z30")+Alltrim(aList2b[nCont,06])+Alltrim(aList2b[nCont,01]))
            Reclock("Z30",.T.)
        else
            Reclock("Z30",.F.)
        EndIf

        Z30->Z30_FILIAL := xFilial("Z30") 
        Z30->Z30_CODGER := aList2b[nCont,06]
        Z30->Z30_CODVEN := aList2b[nCont,01]
        Z30->Z30_MALA   := aList2b[nCont,03]
        Z30->Z30_REGIAO := aList2b[nCont,04]
        Z30->Z30_SUBREG := aList2b[nCont,05]

        Z30->(MsUnlock())
        aList2b[nCont,len(aList2b[nCont])] := .T.
        If nPosG > 0
            aList2[nPosG,len(aList2[nPosG])] := .T.
        EndIf
    EndIf
Next nCont

oList2:refresh()
oDlg1:refresh()

MsgAlert("Registros atualizados com sucesso!!!" )

RestArea(aArea)

Return

/*/{Protheus.doc} VendGer
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function VendGer

Local aArea     :=  GetArea()
Local nCont     :=  0
Local nOpc      :=  0
Local nPosV     :=  0
Private aList22 :=  {}
Private aList23 :=  {}

Private oDlg2
Private oGrp12
Private oGrp22
Private oBtn12
Private oBtn22
Private oList22
Private oList23

For nCont := 1 to len(aList2b)
    If Empty(aList2b[nCont,06])
        Aadd(aList22,{aList2b[nCont,01],aList2b[nCont,02],aList2b[nCont,06],.F.,0})
    EndIf
Next nCont 

For nCont := 1 to len(aList1)
    Aadd(aList23,{.F.,aList1[nCont,01],aList1[nCont,02]})
Next nCont 

If len(aList22) > 0
    Asort(aList22,,,{|x,y| x[2] < y[2]})

    oDlg2      := MSDialog():New( 092,232,660,781,"Vendedores sem Amarração",,,.F.,,,,,,.T.,,,.T. )

    oGrp12     := TGroup():New( 000,004,148,264,"Vendedores",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,140,260},,, oGrp1 ) 
        oList22:= 	TCBrowse():New(008,008,254,135,, {'Codigo','Nome',''},{50,90,50},;
                                        oGrp12,,,,{|| Fhelp3(oList22:nAt,oList23:nAt) },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList22:SetArray(aList22)
            oList22:bLine := {||{aList22[oList22:nAt,01],;
                                 aList22[oList22:nAt,02],;
                                 aList22[oList22:nAt,03]}}

    oGrp22     := TGroup():New( 152,004,244,264,"Gerentes",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{160,008,240,260},,, oGrp2 ) 
        oList23:= 	TCBrowse():New(160,008,254,082,, {'','Codigo','Nome'},{10,50,90},;
                                        oGrp22,,,,{||  },{|| Amarrar(oList23:nAt,oList22:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList23:SetArray(aList23)
            oList23:bLine := {||{If(aList23[oList23:nAt,01],oVd,oVm),;
                                    aList23[oList23:nAt,02],;
                                    aList23[oList23:nAt,03]}}

    oBtn1      := TButton():New( 252,068,"Salvar",oDlg2,{||oDlg2:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 252,144,"Sair",oDlg2,{||oDlg2:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

    oDlg2:Activate(,,,.T.)
else
    MsgAlert("Não há vendedores sem amarração com seus respectivos gerentes!!!")
Endif

If nOpc == 1
    For nCont := 1 to len(aList22)
        If aList22[nCont,04]
            nPosV := Ascan(aList2b,{|x| Alltrim(x[1]) == Alltrim(aList22[nCont,01])})
            aList2b[nPosV,06] := aList22[nCont,03]
            
            DbSelectArea("Z30")
            DbSetOrder(1)
            
            If !Dbseek(xFilial("Z30")+aList2b[nPosV,06]+aList2b[nPosV,02])
                Reclock("Z30",.T.)
            else
                Reclock("Z30",.F.)
            EndIf
            
            Z30->Z30_FILIAL := xFilial("Z30")
            Z30->Z30_CODGER := aList2b[nPosV,06]
            Z30->Z30_CODVEN := aList2b[nPosV,01]
            Z30->(MsUnlock())

            DbSelectArea("SA3")
            DbSetOrder(1)
            If Dbseek(xFilial("SA3")+aList2b[nPosV,01])
                Reclock("SA3",.F.)
                SA3->A3_GEREN := aList2b[nPosV,06]
                SA3->(MsUnlock())
            EndIf

            nPosV := Ascan(aList2,{|x| Alltrim(x[1]) == Alltrim(aList22[nCont,01])})

            If nPosV > 0
                aList2[nPosV,06] := aList22[nCont,03]
            EndIf
        EndIf
    Next nCont

    oList1:nAt := 1
    oList2:nAt := 1
    oList2:SetArray(aList2)
    oList2:bLine := {||{If( aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm),;
                            aList2[oList2:nAt,01],;
                            aList2[oList2:nAt,02],;
                            aList2[oList2:nAt,03],;
                            aList2[oList2:nAt,04],;
                            aList2[oList2:nAt,05]}}

    oList1:refresh()
    oList2:refresh()
    oDlg1:refresh()
    Fhelp(oList1:nAt)
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} Fhelp3(nLinha)
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function Fhelp3(nLin1,nLin2)

Local aArea :=  GetArea()
Local nCont :=  0

For nCont := 1 to len(aList23)
    aList23[nCont,01] := .F.
Next nCont

If aList22[nLin1,05] > 0
    aList23[aList22[nLin1,05],01] := .T.
EndIf

oList22:refresh()
oList23:refresh()
oDlg2:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} Amarrar
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function Amarrar(nLin1,nLin2)

Local aArea := GetArea()
Local nPos2 := aList22[nLin2,05]

If nPos2 > 0
    aList23[nPos2,01] := .F.
EndIf

aList23[nLin1,01] := .T.

aList22[nLin2,03] := aList23[nLin1,02]
aList22[nLin2,04] := .T.
aList22[nLin2,05] := nLin1

oList22:refresh()
oList23:refresh()
oDlg2:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} RemGer()
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function RemGer(nLinha,nTipo)

Local aArea :=  GetArea()
Local nPosB :=  If(nTipo==2,Ascan(aList2b,{|x| Alltrim(x[1]) == Alltrim(aList2[nLinha,01])}),0)
Local cPerg1:=  ddatabase
Local aPerg :=  {}
Local nCont :=  0

If nTipo == 1
    aAdd(aPerg, {1, "Data final" ,  cPerg1,  "", ".T.", "", ".T.", 50,  .F.})

    If ParamBox(aPerg, "Confirme a data final de amarração?")
        DbSelectArea("Z30")
        DbSetOrder(1)
        If Dbseek(xFilial("Z30")+aList1[oList1:nAt,01])
            
            While !EOF() .And. Z30->Z30_CODGER == aList1[oList1:nAt,01]
                Reclock("Z30",.F.)
                Z30->Z30_DTFIM := MV_PAR01
                Z30->Z03_MSBLQL:= '1'
                Z30->(MsUnlock())
                Dbskip()
            EndDo

            DbSelectArea("SA3")
            DbSetOrder(1)
            For nCont := 1 to len(aList2b)
                If Alltrim(aList2b[nCont,06]) == Alltrim(aList1[oList1:nAt,01])
                    If DbSeek(xFilial("SA3")+aList2b[nCont,01])
                        Reclock("SA3",.F.)
                        SA3->A3_GEREN := SPACE(6)
                        SA3->(MsUnlock())
                    EndIf
                EndIf
            Next nCont
        EndIf
    EndIf
ElseIf nTipo == 2
    DbSelectArea("Z30")
    DbSetOrder(1)
    If Dbseek(xFilial("Z30")+aList2[nLinha,06]+aList2[nLinha,01])
        Reclock("Z30",.F.)
        DbDelete()
        Z30->(MsUnlock())
        aList2b[nPosB,06] := ""
    EndIf

    DbSelectArea("SA3")
    DbSetOrder(1)
    If Dbseek(xFilial("SA3")+aList2[nLinha,01])
        Reclock("SA3",.F.)
        SA3->A3_GEREN := Space(6)
        SA3->(MsUnlock())
        aList2[nLinha,06] := ""
    EndIf

    If nPosB > 0
        ADel(aList2,nLinha)
        ASize(aList2,len(aList2)-1)
        
        If len(aList2) < 1
            Aadd(aList2,{'','','','','','','','','',.T.})
        EndIf

        oList1:nAt := 1
        oList2:nAt := 1
        oList2:SetArray(aList2)
        oList2:bLine := {||{If( aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm),;
                                aList2[oList2:nAt,01],;
                                aList2[oList2:nAt,02],;
                                aList2[oList2:nAt,03],;
                                aList2[oList2:nAt,04],;
                                aList2[oList2:nAt,05]}}

        oList1:refresh()
        oList2:refresh()
        oDlg1:refresh()
        Fhelp(oList1:nAt)
    EndIf 
EndIf

RestArea(aArea)

Return

/*/{Protheus.doc} loccity
    (long_description)
    @type  Static Function
    @author user
    @since 15/03/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function loccity(nLinha)

Local aPerg := {}
Local cCity := space(254)
Local nPos

aAdd(aPerg, {1, "Cidade" ,  cCity,  "@!", ".T.", "", ".T.", 70,  .F.})

If ParamBox(aPerg, "Informe a cidade a ser consultada?")
    nPos := Ascan(aList5,{|x| Alltrim(MV_PAR01) $ Alltrim(x[2])})
    If nPos > 0
        oList5:nAt := nPos
        oList5:refresh()
        oDlg1:refresh()
    Else
        MsgAlert("Cidade não encontrada")
    EndIf
endif    

Return
