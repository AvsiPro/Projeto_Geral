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
   //oBrowse:SetFilterDefault( "ZPK->ZPK_ITEM == '001'" )

   oBrowse:AddLegend( "EMPTY(ZPK->ZPK_DTDEVO) .and. EMPTY(ZPK->ZPK_CODOCO) .And. EMPTY(ZPK->ZPK_DTDEVO)"	, "GREEN",    	"Em Aberto" )
   oBrowse:AddLegend( "!EMPTY(ZPK->ZPK_CODOCO) .And. EMPTY(ZPK->ZPK_DTDEVO)"	, "YELLOW",    	"Ocorrência" )
   oBrowse:AddLegend( "!EMPTY(ZPK->ZPK_DTDEVO)"	, "RED",    	"Encerrada" )
    


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
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'u_xJestM3(0)' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'u_xJestM3(1)' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JESTM003' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Legendas'   ACTION 'u__Jestm8()' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	
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
Private oSay7,oBrw1,oGet5,oBtn1,oBtn2,oBtn3,oList1,oSay8,oSay9,oGet8,oSay14

Private dDtEmp := CTOD(' / / ')
Private cHrEmp := space(5)
Private dDtDev := CTOD(' / / ')
Private cHrDev := space(5)
Private cAlmSa := space(6)
Private cAlmEn := space(6)
Private cFunEm := space(6)
Private cCodFr := space(6)
Private cCodBx := space(6)
Private aList1 := {}
Private lDevol := .F.

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

            If Empty(ZPK->ZPK_DTDEVO)
                Aadd(aList1,{.F.,;
                            ZPK->ZPK_CODFER,;
                            Alltrim(Posicione("ZPI",1,XFILIAL("ZPI")+ZPK->ZPK_CODFER,"ZPI_DESCRI")),;
                            ZPK->ZPK_DTEMPR,;
                            TRANSFORM(ZPK->ZPK_HREMPR,"@R 99:99"),;
                            ZPK->ZPK_CODOCO,;
                            ZPK->ZPK_CODBOX})
            EndIf 
            
            cFunEm := ZPK->ZPK_FUNCIO
            cAlmSa := ZPK->ZPK_ALMOXS
            cAlmEn := ZPK->ZPK_ALMOXE

            Dbskip()
        EndDo 

        If len(aList1) < 1
            MsgAlert("Todos os itens já foram devolvidos")
            return
        EndIf 
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
        oGet6      := TGet():New( 045,290,{|u| If(Pcount()>0,dDtDev:=u,dDtDev)},oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay11     := TSay():New( 045,350,{||"Hora Entrada"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
        oGet7      := TGet():New( 045,390,{|u| If(Pcount()>0,cHrDev:=u,cHrDev)},oGrp1,030,008,'@R 99:99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oGrp2      := TGroup():New( 064,008,256,464,"Ferramentas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay7      := TSay():New( 076,104,{||"Ferramenta"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet5      := TGet():New( 075,148,{|u| If(Pcount()>0,cCodFr:=u,cCodFr)},oGrp2,060,008,'',{||inclfer(cCodFr,1)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZPI","",,)
        
        oSay1      := TSay():New( 076,230,{||"Box"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet8      := TGet():New( 075,268,{|u| If(Pcount()>0,cCodBx:=u,cCodBx)},oGrp2,060,008,'',{||inclfer(cCodBx,2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZPJ","",,)
        
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{092,012,252,460},,, oGrp2 ) 
        oList1    := TCBrowse():New(092,012,445,150,, {'','Codigo','Descricao','Data Saída','Hora Saída','Ocorrência'},;
                                        {10,60,90,45,45,40},;
                                        oGrp2,,,,{|| FHelp(oList1:nAt,nOpc)},{|| editped(oList1:nAt,nOpc)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                                aList1[oList1:nAt,02],;
                                aList1[oList1:nAt,03],;
                                aList1[oList1:nAt,04],;
                                aList1[oList1:nAt,05],;
                                aList1[oList1:nAt,06]}}

    oBtn1      := TButton():New( 260,104,"Confirmar",oDlg1,{||oDlg1:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )
    
    iF nOpc <> 0
        oBtn2      := TButton():New( 260,200,"Devolver",oDlg1,{|| IF(VldDev(),oDlg1:end(nOpcao:=1),) },037,012,,,,.T.,,"",,,,.F. )
        oGet1:disable()
        oGet2:disable()
        oGet3:disable()
        oGet4:disable()
        xnome(1)
        xnome(2)
    Endif 
    
    oBtn3      := TButton():New( 260,296,"Cancelar",oDlg1,{||oDlg1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

    oBtn1:disable()

oDlg1:Activate(,,,.T.)

If nOpcao == 1
    DbselectArea("ZPK")
    DbSetOrder(1)
    For nCont := 1 to len(aList1)
        If aList1[nCont,01]
            If !Dbseek(xFilial("ZPK")+cCodigo+aList1[nCont,02])
                Reclock("ZPK",.T.)
            else 
                Reclock("ZPK",.F.)
            endif 

            ZPK->ZPK_FILIAL := xFilial("ZPK")
            ZPK->ZPK_CODIGO := cCodigo
            ZPK->ZPK_ITEM   := strzero(nCont,3)
            ZPK->ZPK_ALMOXS := cAlmSa
            ZPK->ZPK_FUNCIO := cFunEm
            ZPK->ZPK_DTEMPR := aList1[nCont,04]
            ZPK->ZPK_HREMPR := aList1[nCont,05]
            ZPK->ZPK_CODFER := aList1[nCont,02]
            ZPK->ZPK_CODBOX := aList1[nCont,07]

            If lDevol
                ZPK->ZPK_DTDEVO := dDtDev
                ZPK->ZPK_HRDEVO := cHrDev
                ZPK->ZPK_ALMOXE := cAlmEn
            EndIf 

            ZPK->(Msunlock())
            
            If !lDevol
                Dbselectarea("ZPI")
                DbSetOrder(1)
                If Dbseek(xFilial("ZPI")+aList1[nCont,02])
                    Reclock("ZPI",.F.)
                    ZPI->ZPI_STATUS := 'E'
                    ZPI->(Msunlock())
                EndIf 
            Else 
                Dbselectarea("ZPI")
                DbSetOrder(1)
                If Dbseek(xFilial("ZPI")+aList1[nCont,02])
                    Reclock("ZPI",.F.)
                    ZPI->ZPI_STATUS := 'L'
                    ZPI->(Msunlock())
                EndIf 
            EndIf 
        EndIf 
    Next nCont 
EndIf 

Return

/*/{Protheus.doc} FHelp
    (long_description)
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
Static Function FHelp(nLinha,nOpc)

If nOpc <> 0
    dDtEmp := aList1[nLinha,04]
    cHrEmp := aList1[nLinha,05]

    oDlg1:refresh()
endIf 

Return

/*/{Protheus.doc} editped
    Marcar e desmarcar itens a devolver
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
Static Function editped(nLinha,nOpc)
    
If nOpc <> 0
    If aList1[nLinha,01]
        aList1[nLinha,01] := .F.
    Else 
        aList1[nLinha,01] := .T.
    EndIf 

    oList1:refresh()
    oDlg1:refresh() 
EndIf 

Return

/*/{Protheus.doc} VldDev
    Valida devolução dos itens
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
Static Function VldDev()

Local lRet := .F.
Local nCont 

For nCont := 1 to len(aList1)
    If aList1[nCont,01]
        lRet := .T.
    EndIf 
Next nCont 

If !lRet 
    Msgalert("Não foi informado o item a ser devolvido")
    return(lRet)
EndIf 

If Empty(dDtDev)
    MsgAlert("Não foi informada a data de devolução da ferramenta.")
    lRet := .F.
Endif 
If Empty(cAlmEn)
    MsgAlert("Não foi informado o almoxarife de devolução da ferramenta.")
    lRet := .F.
Endif 
If Empty(cHrDev)
    MsgAlert("Não foi informada a hora de devolução da ferramenta.")
    lRet := .F.
Endif 

If lRet
    lDevol := .T.
Else 
    lDevol := .F. 
EndIF 

Return(lRet)
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
Static Function inclfer(cCodFer,nOpc)

Local aArea := GetArea()
Local lRet  := .T.
Local nPos  := Ascan(aList1,{|x| x[2] == cCodFer})

If !Empty(cCodFer)
    If Empty(aList1[1,2])
        aList1 := {}
    EndIf 

    If nOpc == 1
        If nPos == 0

            DBSelectArea("ZPI")
            DBSetOrder(1)
            If Dbseek(xFilial("ZPI")+cCodFer)
                If ZPI->ZPI_STATUS <> 'L'
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

                
            Else
                MsgAlert("Ferramenta não existe no cadastro")
                lRet := .F.
            EndIf 
        EndIf 

        cCodFr := space(6)
    Else 
        If Ascan(aList1,{|x| x[7] == cCodFer}) == 0
             
            DbSelectArea("ZPJ")
            DBSetOrder(1)
            If Dbseek(xFilial("ZPJ")+cCodFer)
                While !EOF() .AND. ZPJ->ZPJ_CODBOX == cCodFer
                    lLib := Posicione("ZPI",1,xFilial("ZPI")+ZPJ->ZPJ_CODFER,"ZPI_STATUS") == "L"
                    If lLib 
                        Aadd(aList1,{.T.,;
                                    ZPJ->ZPJ_CODFER,;
                                    alltrim(ZPJ->ZPJ_DESCFE),;
                                    If(empty(dDtEmp),ddatabase,dDtEmp),;
                                    if(empty(cHrEmp),cvaltochar(time()),cHrEmp),;
                                    '',;
                                    ZPJ->ZPJ_CODBOX,;
                                    '',;
                                    '',;
                                    ''})
                    EndIf 
                    Dbskip()
                EndDo 
            endif 
            
        EndIf
        cCodBx := space(6)
    EndIf 

    If len(aList1) < 1
        Aadd(aList1,{.F.,'','','','','','','','','',''})
        MsgAlert("Não encontrado itens que atendam a solicitação")
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
EndIf 

RestArea(aArea)

Return(lRet)


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
USER FUNCTION _Jestm8()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE"   ,    "Em aberto"    })
    AADD(aLegenda,{"BR_AMARELO"	,    "Com ocorrência"        })
	AADD(aLegenda,{"BR_VERMELHO",    "Encerrada"    })
	 
    BrwLegenda('Venda perdida', "Status", aLegenda)

RETURN

