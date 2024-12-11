#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JESTC003()

Local oBrowse := FwLoadBrw("JESTC003")
    
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

    oBrowse:SetAlias("ZPJ")
    oBrowse:SetDescription("Cadastro de Caixa de Ferramentas")

   // DEFINE DE ONDE SER RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JESTC003")
   oBrowse:SetFilterDefault( "ZPJ->ZPJ_ITEM == '001'" )


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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JESTC003' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'U_xJestc3(1)' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Regras'    ACTION 'VIEWDEF.JESTC003' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'U_xJestc3(2)' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JESTC003' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("JESTC3")
Local oStruSC5 := FwFormStruct(1, "ZPJ")
Local oStruSC6 := FwFormStruct(1, "ZPJ")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("ZPJMASTER", NIL, oStruSC5)
    oModel:AddGrid("ZPJDETAIL", "ZPJMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPJ_FILIAL", "ZPJ_CODBOX", "ZPJ_ITEM" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    oModel:SetRelation("ZPJDETAIL", {{"ZPJ_FILIAL", "FwXFilial('ZPJ')"}, {"ZPJ_CODBOX", "ZPJ_CODBOX"}}, ZPJ->(IndexKey(1)))

    oStruSC6:AddTrigger("ZPJ_CODFER", "ZPJ_DESCFE",{|| .T.}, {|| POSICIONE("ZPI",1,XFILIAL("ZPI")+oModel:GetValue('ZPJDETAIL','ZPJ_CODFER'),"ZPI_DESCRI") })
    oStruSC6:AddTrigger("ZPJ_CODFER", "ZPJ_DESCRI",{|| .T.}, {|| M->ZPJ_DESCRI })
    oStruSC6:AddTrigger("ZPJ_CODFER", "ZPJ_CODBOX",{|| .T.}, {|| M->ZPJ_CODBOX })
    //oStruSC6:SetProperty('ZPJ_DESCRI', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, M->ZPJ_DESCRI))
	
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Caixa de Ferramentas")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("ZPJMASTER"):SetDescription("Cabe�alho")
    oModel:GetModel("ZPJDETAIL"):SetDescription("Itens")
    
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
Local oStruSC5 := FwFormStruct(2, "ZPJ")
Local oStruSC6 := FwFormStruct(2, "ZPJ")
Local oModel   := FwLoadModel("JESTC003")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("ZPJ_FILIAL")
    oStruSC5:RemoveField("ZPJ_ITEM")
    oStruSC5:RemoveField("ZPJ_CODFER")
    oStruSC5:RemoveField("ZPJ_DESCFE")
    
    
    oStruSC6:RemoveField("ZPJ_CODBOX")
    oStruSC6:RemoveField("ZPJ_DESCRI")
    
    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPJMASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    oView:AddGrid("VIEW_SC6", oStruSC6, "ZPJDETAIL")
    
    oView:AddIncrementField( 'VIEW_SC6', 'ZPJ_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÝTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    oView:EnableTitleView("VIEW_SC6", "REGRAS", RGB(224, 30, 43))
    
Return (oView)

/*/{Protheus.doc}
Inclusao de Box de Ferramentas
@type user function
@author user
@since 12/06/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function xJestc3(nChamada)

Local nOpcao := 0
Local nCont 

Private cCodigo   :=  ''
Private cDescri  := space(100)
Private cFermta  := space(6)  
Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oGet1,oGet2,oGrp2,oBtn1,oBtn2
Private aList := {}
Private nLin  := 1
PRIVATE oOk     := LoadBitmap(GetResources(),'br_verde')  
PRIVATE oNo     := LoadBitmap(GetResources(),'br_vermelho')

Default nChamada := 1

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf


If nChamada == 1
    Aadd(aList,{'001','','',.f.})
    cCodigo := GetSXEnum("ZPJ","ZPJ_CODBOX")
Else 
    cQuery := "SELECT COUNT(*) AS QTD"
    cQuery += " FROM "+RetSQLName("ZPK")
    cQuery += " WHERE ZPK_FILIAL='"+xfilial("ZPK")+"' AND ZPK_CODBOX='"+ZPJ->ZPJ_CODBOX+"'"
    cQuery += " AND D_E_L_E_T_=' ' AND ZPK_DTDEVO=' '"

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)
    lOkAlt := .F.

    If (cAliasTMP)->(!EoF()) 
        lOkAlt := (cAliasTMP)->QTD > 0
    endIf 

    If lOkAlt
        MsgAlert("Caixa n�o poder� ser alterada, por estar com o status de empr�stimo")
        Return
    else 

        Busca(ZPJ->ZPJ_CODBOX)
        cCodigo := ZPJ->ZPJ_CODBOX
        cDescri := ZPJ->ZPJ_DESCRI
    EndIf 
    
EndIf 

oDlg1      := MSDialog():New( 092,232,743,1127,"Cadastro de Box",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 008,076,086,388,"Caixa de Ferramentas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oSay1      := TSay():New( 024,176,{||"C�digo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay2      := TSay():New( 024,236,{||cCodigo},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
    oSay3      := TSay():New( 040,094,{||"Descri��o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 040,166,{|u| If(Pcount()>0,cDescri:=u,cDescri)},oGrp1,158,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oSay4      := TSay():New( 065,094,{||"Incluir Ferramenta"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
    oGet2      := TGet():New( 065,166,{|u| If(Pcount()>0,cFermta:=u,cFermta)},oGrp1,088,008,'@!',{||inclfer()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZPI","",,)
    
    If nChamada <> 1
        oGet1:disable()
    endif 
    
oGrp2      := TGroup():New( 090,004,288,440,"Itens",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{068,008,244,332},,, oGrp2 ) 
    oList    := TCBrowse():New(098,008,425,185,, {'','Item','Codigo','Descri��o'},;
                                                            {10,30,60,90},;
                                                            oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| editcol(oList:nAT)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
        oList:bLine := {||{ If(aList[oList:nAt,04],oOk,oNo),;
                            aList[oList:nAt,01],;
                            aList[oList:nAt,02],;
                            aList[oList:nAt,03]}}
                            
    oBtn1      := TButton():New( 307,088,"Salvar",oDlg1,{||oDlg1:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 307,230,"Cancelar",oDlg1,{||oDlg1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpcao == 1
   

    For nCont := 1 to len(aList)
        If aList[nCont,04]
            IF !Empty(aList[nCont,01]) .And. !Empty(aList[nCont,02])
                If !Dbseek(xFilial("ZPJ")+cCodigo+aList[nCont,02])
                    Reclock("ZPJ",.T.)
                Else 
                    Reclock("ZPJ",.F.)
                EndIf 

                ZPJ->ZPJ_FILIAL := xFilial("ZPJ")
                ZPJ->ZPJ_CODBOX := cCodigo 
                ZPJ->ZPJ_DESCRI := cDescri
                ZPJ->ZPJ_ITEM   := aList[nCont,01]
                ZPJ->ZPJ_CODFER := aList[nCont,02]
                ZPJ->ZPJ_DESCFE := aList[nCont,03]

                ZPJ->(Msunlock())
            EndIf 
        Else 
            If Dbseek(xFilial("ZPJ")+cCodigo+aList[nCont,02])
                Reclock("ZPJ",.F.)
                ZPJ->(DbDelete())
                ZPJ->(Msunlock())
            EndIF 
        EndIf 
    Next nCont 
EndIf 

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 12/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(cCodBox)
    
Local aArea := GetArea()

aList := {}

cQuery := "SELECT ZPJ_FILIAL,ZPJ_CODBOX,ZPJ_DESCRI,ZPJ_ITEM,ZPJ_CODFER,ZPJ_DESCFE"
cQuery += " FROM "+RetSQLName("ZPJ")
cQuery += " WHERE ZPJ_FILIAL='"+xFilial("ZPJ")+"' AND ZPJ_CODBOX='"+cCodBox+"'"
cQuery += " AND D_E_L_E_T_=' '"


IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTC004.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList,{TRB->ZPJ_ITEM,TRB->ZPJ_CODFER,TRB->ZPJ_DESCFE,.t.})
    
    Dbskip()
EndDo 

RestArea(aArea)


Return

/*/{Protheus.doc} editcol
    Edita a linha do grid
    @type  Static Function
    @author user
    @since 12/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha)

Local lOk     := .F.
Local nPosic  := oList:nColPos
Local cBckp1   := ''
Local cBckp2   := ''

If nPosic == 1
    If !Empty(aList[oList:nAt,02])
        If aList[oList:nAt,04]
            aList[oList:nAt,04] := .F.
        Else 
            aList[oList:nAt,04] := .T.
        EndIf 
    EndIf 
Elseif nPosic == 3
    cBckp1 := aList[oList:nAt,02] 
    cBckp2 := aList[oList:nAt,03] 
        
    lOk := ConPad1(,,,"ZPI",,,.f.)

    If lOk 
        aList[oList:nAt,02] := ZPI->ZPI_CODFER
        aList[oList:nAt,03] := ZPI->ZPI_DESCRI
    Else 
        aList[oList:nAt,03] := aList[oList:nAt,02] 

        lEditCell(aList,oList,"@!",3)

        aList[oList:nAt,02] := aList[oList:nAt,03] 

    EndIf 

    if !Empty(aList[oList:nAt,02])
        nPos :=  Ascan(aList,{|x| alltrim(x[2]) == aList[oList:nAt,02]})
        If nPos > 0 .and. nPos <> oList:nAt
            MsgAlert("Item j� adicionado a caixa")
            aList[oList:nAt,02] := cBckp1
            aList[oList:nAt,03] := cBckp2
        ELSE 
            If VldFerBox(aList[oList:nAt,02])
                aList[oList:nAt,03] := Posicione("ZPI",1,xFilial("ZPI")+aList[oList:nAt,02],"ZPI_DESCRI")
                
                aList[oList:nAt,04] := .T.
            Else 

                MsgAlert("Ferramenta j� esta sendo utilizada em outra caixa")
                aList[oList:nAt,02] := cBckp1
                aList[oList:nAt,03] := cBckp2
            EndIF
        EndIF 
 
        oList:refresh()
        oDlg1:refresh()
    EndIf 
EndIf 

Return

/*/{Protheus.doc} inclfer
    Incluir ferramentas na caixa
    @type  Static Function
    @author user
    @since 08/11/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function inclfer()

Local aArea := GetArea()
Local lRet  := .T.
Local cDescr:= ""

If empty(cFermta)
    Return 
endIf 

If Ascan(aList,{|x| alltrim(x[2]) == cFermta}) > 0
    MsgAlert("Item j� adicionado a caixa")
    lRet := .F.
EndIF 

If lRet
    If !VldFerBox(cFermta)
        MsgAlert("Ferramenta j� adicionada a outra caixa")
        lRet := .F.
    EndIf 
EndIf 

If lRet
    DbSelectArea("ZPI")
    DbSetOrder(1)
    If !Dbseek(xFilial("ZPI")+cFermta)
        MsgAlert("Ferramenta n�o existe no cadastro")
        lRet := .F.
    Else 
        cDescr := ZPI->ZPI_DESCRI
    EndIf 
Endif 

If lRet
    If Empty(aList[len(aList),02])
        aList[oList:nAt,02] := cFermta
        aList[oList:nAt,03] := cDescr
        aList[oList:nAt,04] := .T.
    Else 
        Aadd(aList,{strzero(len(aList)+1,3),cFermta,cDescr,.T.})
    EndIf 

    oList:SetArray(aList)
    oList:bLine := {||{ If(aList[oList:nAt,04],oOk,oNo),;
                            aList[oList:nAt,01],;
                            aList[oList:nAt,02],;
                            aList[oList:nAt,03]}}
    
    //oList:nAt := len(aList)
    cFermta := space(6)

    oList:refresh()
    oDlg1:refresh()
EndIf 


RestArea(aArea)

Return

/*/{Protheus.doc} VldFerBox(cFermta)
    (long_description)
    @type  Static Function
    @author user
    @since 02/12/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function VldFerBox(cFermta)

Local lRet := .T. 
Local cQuery
Local nQtF := 0

cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName("ZPJ")
cQuery += " WHERE ZPJ_FILIAL='"+xFilial("ZPJ")+"' AND D_E_L_E_T_=' '"
cQuery += " AND ZPJ_CODFER='"+cFermta+"'"

cAliasTMP := GetNextAlias()
MPSysOpenQuery(cQuery, cAliasTMP)

If (cAliasTMP)->(!EoF()) 
    nQtF := (cAliasTMP)->QTD
endIf 

If nQtF > 0
    lRet := .F.
EndIf 

Return(lRet)
