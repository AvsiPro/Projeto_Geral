#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre VenÃ¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  CriaÃ§Ã£o do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JESTM003()

Local oBrowse := FwLoadBrw("JESTM003")
    
oBrowse:Activate()

Return (NIL)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre VenÃ¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  CriaÃ§Ã£o do Browse                                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function BrowseDef()

Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("ZPK")
    oBrowse:SetDescription("Emprétimos de Ferramentas")

   // DEFINE DE ONDE SERA RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JESTM003")
   oBrowse:SetFilterDefault( "ZPK->ZPK_ITEM == '001'" )


Return (oBrowse)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre VenÃ¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  CriaÃ§Ã£o do menu DEF                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()

Local aRot := {}
     
    //Adicionando opÃ§Ãµes
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JESTM003' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'u_xJestM3(0)' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Regras'    ACTION 'VIEWDEF.JESTM003' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'u_xJestM3(1)' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JESTM003' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre VenÃ¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  CriaÃ§Ã£o da regra de negÃ³cio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("xJESTM3")
Local oStruSC5 := FwFormStruct(1, "ZPK")
Local oStruSC6 := FwFormStruct(1, "ZPK")
    
    // DEFINE SE OS SUBMODELOS SERÃƒO FIELD OU GRID
    oModel:AddFields("ZPKMASTER", NIL, oStruSC5)
    oModel:AddGrid("ZPKDETAIL", "ZPKMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPK_FILIAL", "ZPK_CODIGO", "ZPK_ITEM" } )
    //oModel:SetPrimaryKey( { "ZPK_FILIAL", "ZPK_CODIGO" } )

    // DEFINE A RELAÃ‡ÃƒO ENTRE OS SUBMODELOS
    oModel:SetRelation("ZPKDETAIL", {{"ZPK_FILIAL", "FwXFilial('ZPK')"}, {"ZPK_CODIGO", "ZPK_CODIGO"}}, ZPK->(IndexKey(1)))

    //oStruSC6:AddTrigger("ZY1_VEND", "ZY1_NVEND",{|| .T.}, {|| POSICIONE("ZPK",1,XFILIAL("ZPK")+oModel:GetValue('ZY1DETAIL','ZY1_VEND'),"A3_NOME") })
    
    // DESCRIÃ‡ÃƒO DO MODELO
    oModel:SetDescription("Cadastro de Caixa de Ferramentas")

    // DESCRIÃ‡ÃƒO DOS SUBMODELOS
    oModel:GetModel("ZPKMASTER"):SetDescription("Cabeçalho")
    oModel:GetModel("ZPKDETAIL"):SetDescription("Itens")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre VenÃ¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  CriaÃ§Ã£o // INTERFACE GRÃFICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "ZPK")
Local oStruSC6 := FwFormStruct(2, "ZPK")
Local oModel   := FwLoadModel("JESTM003")

    // REMOVE CAMPOS DA EXIBIÃ‡ÃƒO
    oStruSC5:RemoveField("ZPK_FILIAL")
    oStruSC5:RemoveField("ZPK_ITEM")
    oStruSC5:RemoveField("ZPK_CODFER")
    oStruSC5:RemoveField("ZPK_CODOCO")
    oStruSC5:RemoveField("ZPK_DESCRI")
    
    oStruSC6:RemoveField("ZPK_FILIAL")
    oStruSC6:RemoveField("ZPK_CODIGO")
    oStruSC6:RemoveField("ZPK_ALMOXS")
    oStruSC6:RemoveField("ZPK_FUNCIO")
    //oStruSC6:RemoveField("ZPK_DESCRI")
    oStruSC6:RemoveField("ZPK_ALMOXE")
    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPKMASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    oView:AddGrid("VIEW_SC6", oStruSC6, "ZPKDETAIL")
    
    oView:AddIncrementField( 'VIEW_SC6', 'ZPK_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÃTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    oView:EnableTitleView("VIEW_SC6", "REGRAS", RGB(224, 30, 43))
    
Return (oView)


/*/{Protheus.doc} nomeFunction
inclusão de empréstimo
@type user function
@author user
@since 04/06/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function xJestM3(nOpc)

Local nOpcao   := 0
Local nCont 
Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oGet1,oGet2,oGet3,oGet4
Private oSay7,oBrw1,oGet5,oBtn1,oBtn2,oBtn3,oList1,oSay8,oSay9

Private dDtEmp := CTOD(' / / ')
Private cHrEmp := space(5)
Private dDtDev := CTOD(' / / ')
Private cHrDev := space(5)
Private cAlmSa := space(6)
Private cAlmEn := space(6)
Private cFunEm := space(6)
Private cCodFr := space(6)
Private aList1 := {}

Default nOpc   := 0

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

PRIVATE oOk     := LoadBitmap(GetResources(),'br_verde')  
PRIVATE oNo     := LoadBitmap(GetResources(),'br_vermelho')
If nOpc == 0
    Aadd(aList1,{.F.,'','','','','','','','','',''})

    cCodigo := GetSXEnum("ZPK","ZPK_CODIGO")
Else 
    cCodigo := ZPK->ZPK_CODIGO 
    DbSelectArea("ZPK")
    DbSetOrder(1)
    If Dbseek(xfilial("ZPK")+cCodigo)
        While !EOF() .AND. ZPK->ZPK_CODIGO == cCodigo 
            //'','Codigo','Descricao','Data Saída','Hora Saída','Ocorrência'
            Aadd(aList1,{.F.,;
                        ZPK->ZPK_CODFER,;
                        Alltrim(Posicione("ZPI",1,XFILIAL("ZPI")+ZPK->ZPK_CODFER,"ZPI_DESCRI")),;
                        ZPK->ZPK_DTEMPR,;
                        TRANSFORM(ZPK->ZPK_HREMPR,"@R 99:99"),;
                        ZPK->ZPK_CODOCO})
            
            cFunEm := ZPK->ZPK_FUNCIO
            cAlmSa := ZPK->ZPK_ALMOXS
            cAlmEn := ZPK->ZPK_ALMOXE

            Dbskip()
        EndDo 
    EndIF 
endIF 

oDlg1      := MSDialog():New( 092,232,661,1192,"Cadastro de Empréstimos",,,.F.,,,,,,.T.,,,.T. )
   
    oGrp1      := TGroup():New( 008,024,060,458,"Informações Gerais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay1      := TSay():New( 016,050,{||"Código"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay2      := TSay():New( 016,090,{||cCodigo},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
        
        oSay3      := TSay():New( 016,172,{||"Solicitante"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1      := TGet():New( 016,202,{|u| If(Pcount()>0,cFunEm:=u,cFunEm)},oGrp1,030,008,'@!',{||xnome(1)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA","",,)
        oSay3t     := TSay():New( 016,250,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,132,008)
        
        oSay4      := TSay():New( 032,042,{||"Almox. Saída"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
        oGet2      := TGet():New( 032,082,{|u| If(Pcount()>0,cAlmSa:=u,cAlmSa)},oGrp1,030,008,'@!',{||xnome(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA","",,)
        oSay4t     := TSay():New( 032,120,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,132,008)
        
        oSay5      := TSay():New( 045,042,{||"Data Saída"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet3      := TGet():New( 045,082,{|u| If(Pcount()>0,dDtEmp:=u,dDtEmp)},oGrp1,030,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay6      := TSay():New( 045,140,{||"Hora Saída"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet4      := TGet():New( 045,180,{|u| If(Pcount()>0,cHrEmp:=u,cHrEmp)},oGrp1,030,008,'@R 99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

        oSay12     := TSay():New( 032,250,{||"Almox. Entrada"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
        oGet5      := TGet():New( 032,290,{|u| If(Pcount()>0,cAlmEn:=u,cAlmEn)},oGrp1,030,008,'@!',{||xnome(3)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA","",,)
        oSay12t    := TSay():New( 032,330,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,132,008)
        
        oSay10     := TSay():New( 045,250,{||"Data Entrada"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
        oGet6      := TGet():New( 045,290,{|u| If(Pcount()>0,dDtDev:=u,dDtDev)},oGrp1,030,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay11     := TSay():New( 045,350,{||"Hora Entrada"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
        oGet7      := TGet():New( 045,390,{|u| If(Pcount()>0,cHrDev:=u,cHrDev)},oGrp1,030,008,'@R 99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oGrp2      := TGroup():New( 064,008,256,464,"Ferramentas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay7      := TSay():New( 076,144,{||"Ferramenta"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet5      := TGet():New( 075,208,{|u| If(Pcount()>0,cCodFr:=u,cCodFr)},oGrp2,060,008,'',{||inclfer(cCodFr)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZPI","",,)
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{092,012,252,460},,, oGrp2 ) 
        oList1    := TCBrowse():New(092,012,445,150,, {'','Codigo','Descricao','Data Saída','Hora Saída','Ocorrência'},;
                                        {10,60,90,45,45,40},;
                                        oGrp2,,,,{||/* FHelp(oList1:nAt)*/},{|| /*editped(oList1:nAt,1)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                                aList1[oList1:nAt,02],;
                                aList1[oList1:nAt,03],;
                                aList1[oList1:nAt,04],;
                                aList1[oList1:nAt,05],;
                                aList1[oList1:nAt,06]}}

    oBtn1      := TButton():New( 260,104,"Confirmar",oDlg1,{||oDlg1:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )
    
    iF nOpc <> 0
        oBtn2      := TButton():New( 260,200,"Devolver",oDlg1,{|| },037,012,,,,.T.,,"",,,,.F. )
    Endif 
    
    oBtn3      := TButton():New( 260,296,"Cancelar",oDlg1,{||oDlg1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

    oBtn1:disable()

oDlg1:Activate(,,,.T.)

If nOpcao == 1
    DbselectArea("ZPK")
    For nCont := 1 to len(aList1)
        If aList1[nCont,01]
            Reclock("ZPK",.T.)
            ZPK->ZPK_FILIAL := xFilial("ZPK")
            ZPK->ZPK_CODIGO := cCodigo
            ZPK->ZPK_ITEM   := strzero(nCont,3)
            ZPK->ZPK_ALMOXS := cAlmSa
            ZPK->ZPK_FUNCIO := cFunEm
            ZPK->ZPK_DTEMPR := aList1[nCont,04]
            ZPK->ZPK_HREMPR := aList1[nCont,05]
            ZPK->ZPK_CODFER := aList1[nCont,02]
            ZPK->(Msunlock())

            Dbselectarea("ZPI")
            DbSetOrder(1)
            If Dbseek(xFilial("ZPI")+aList1[nCont,02])
                Reclock("ZPI",.F.)
                ZPI->ZPI_STATUS := 'E'
                ZPI->(Msunlock())
            EndIf 
        EndIf 
    Next nCont 
EndIf 

Return

/*/{Protheus.doc} xnome
    Atualiza o nome do funcionario
    @type  Static Function
    @author user
    @since 04/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xnome(nopc)


If nopc == 1
    oSay3t:settext("")
    If !Empty(cFunEm) .AND. ExistCpo("SRA",cFunEm)
        oSay3T:settext(Posicione("SRA",1,xFilial("SRA")+cFunEm,"RA_NOME"))
    else 
        cFunEm:=SPACE(6)
    EndIf 
ElseIf nopc == 2
    oSay4T:settext('')
    If !Empty(cAlmSa) .AND. ExistCpo("SRA",cAlmSa)
        oSay4T:settext(Posicione("SRA",1,xFilial("SRA")+cAlmSa,"RA_NOME"))
    else 
        cAlmSa:=SPACE(6)
    EndIf 
ElseIf nopc == 3
    oSay12T:settext('')
    If !Empty(cAlmEn) .AND. ExistCpo("SRA",cAlmEn)
        oSay12T:settext(Posicione("SRA",1,xFilial("SRA")+cAlmEn,"RA_NOME"))
    else 
        cAlmEn := space(6)
    EndIf 
EndIf 

liberok()

oDlg1:refresh()

Return

/*/{Protheus.doc} liberok
    Liberar o botao de confirmar
    @type  Static Function
    @author user
    @since 05/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function liberok()

Local lRet := .F.    
Local nCont 
Local lItens := .F.

If !Empty(cFunEm) .And. !Empty(cAlmSa)
    For nCont := 1 to len(aList1)
        If aList1[nCont,01]
            lItens := .T.
            exit 
        EndIf 
    Next nCont 

    If lItens
        oBtn1:enable()
    else 
        oBtn1:disable()
    EndIf 
EndIf

Return(lRet)

/*/{Protheus.doc} inclfer
    incluir a ferramenta no grid de empréstimo
    @author user
    @since 05/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function inclfer(cCodFer)

Local aArea := GetArea()
Local lRet  := .T.
Local nPos  := Ascan(aList1,{|x| x[2] == cCodFer})

If nPos == 0

    If Empty(aList1[1,2])
        aList1 := {}
    EndIf 

    DBSelectArea("ZPI")
    DBSetOrder(1)
    If Dbseek(xFilial("ZPI")+cCodFer)
        If ZPI->ZPI_STATUS == 'L'
            MsgAlert("Ferramenta não está liberada para empréstimo!!!")
            lRet := .F.
        Else 
            Aadd(aList1,{.T.,;
                        ZPI->ZPI_CODFER,;
                        alltrim(ZPI->ZPI_DESCRI),;
                        If(empty(dDtEmp),ddatabase,dDtEmp),;
                        if(empty(cHrEmp),cvaltochar(time()),cHrEmp),;
                        '',;
                        '',;
                        '',;
                        '',;
                        ''})
        EndIf 

        If len(aList1) < 1
            Aadd(aList1,{.F.,'','','','','','','','','',''})
        EndIf 

        oList1:SetArray(aList1)
        oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                                aList1[oList1:nAt,02],;
                                aList1[oList1:nAt,03],;
                                aList1[oList1:nAt,04],;
                                aList1[oList1:nAt,05],;
                                aList1[oList1:nAt,06]}}
        
        
        liberok()

        oList1:refresh()
        oDlg1:refresh()
    Else
        MsgAlert("Ferramenta não existe no cadastro")
        lRet := .F.
    EndIf 
EndIf 

RestArea(aArea)

Return(lRet)
