#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre VenÃ¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  CriaÃ§Ã£o do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function ROBCMS02()

Local oBrowse := FwLoadBrw("ROBCMS02")





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

    oBrowse:SetAlias("SA3")
    oBrowse:SetDescription("Cadastro de Meta de Vendas")

   // DEFINE DE ONDE SERÃ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROBCMS02")
   oBrowse:SetFilterDefault( "SA3->A3_XFUNCAO == '2'" )


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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ROBCMS02' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Metas'    ACTION 'U_xRBMS02' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre VenÃ¢ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  CriaÃ§Ã£o da regra de negÃ³cio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("ROBCMM")
Local oStruSC5 := FwFormStruct(1, "SA3")
Local oStruSC6 := FwFormStruct(1, "Z31")
    
    // DEFINE SE OS SUBMODELOS SERÃƒO FIELD OU GRID
    oModel:AddFields("SA3MASTER", NIL, oStruSC5)
    oModel:AddGrid("Z31DETAIL", "SA3MASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "A3_FILIAL", "A3_COD" } )

    // DEFINE A RELAÃ‡ÃƒO ENTRE OS SUBMODELOS
    oModel:SetRelation("Z31DETAIL", {{"Z31_FILIAL", "FwXFilial('Z31')"}, {"Z31_CODGER", "A3_COD"}}, Z31->(IndexKey(1)))

    //oStruSC6:AddTrigger("ZY1_VEND", "ZY1_NVEND",{|| .T.}, {|| POSICIONE("SA3",1,XFILIAL("SA3")+oModel:GetValue('ZY1DETAIL','ZY1_VEND'),"A3_NOME") })
    
    // DESCRIÃ‡ÃƒO DO MODELO
    oModel:SetDescription("Cadastro de Equipes")

    // DESCRIÃ‡ÃƒO DOS SUBMODELOS
    oModel:GetModel("SA3MASTER"):SetDescription("CabeÃ§alho")
    oModel:GetModel("Z31DETAIL"):SetDescription("Itens")
    
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
Local oStruSC5 := FwFormStruct(2, "SA3")
Local oStruSC6 := FwFormStruct(2, "Z31")
Local oModel   := FwLoadModel("ROBCMS02")

    // REMOVE CAMPOS DA EXIBIÃ‡ÃƒO
    oStruSC5:RemoveField("A3_FILIAL")
    oStruSC6:RemoveField("Z31_FILIAL")
        
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "SA3MASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    oView:AddGrid("VIEW_SC6", oStruSC6, "Z31DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÃTULOS DAS SUBVIEWS
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
User Function xRBMS02

Local nOpc      :=  0
Local lSair     :=  .F.
Local nSair     :=  0
Local aPer      := {}
Local nCont     :=  0

Private aList1  := {}
Private aList2  := {}
Private aList3  := {}
Private aList4  := {}
Private aList5  := {}
Private aList6  := {}
Private aList2b := {}
Private aList3b := {}
Private aList4b := {}
Private aList5b := {}
Private aList6b := {}

Private oDlg1
Private oGrp1
Private oGrp2
Private oGrp3
Private oGrp4
Private oGrp5
Private oGrp6
Private oGrp7
Private oCBox1
Private oBtn1
Private oBtn2
Private oBtn3
Private oBtn4
Private oBtn5
Private oBtn6

Private oList1
Private oList2
Private oList3
Private oList4
Private oList5
Private oList6

Private nVlr01 := 0
Private nVlr02 := 0
Private nVlr03 := 0
Private nVlr04 := 0
Private nVlr05 := 0

Private cPer1  := ''
Private cPer2  := ''
Private cPer3  := ''
Private cPer4  := ''
Private cQuad  := ''

RpcSetType(3)
RPCSetEnv("01","0101")

Private oVd     := LoadBitmap(GetResources(),'BR_VERDE')
Private oVm     := LoadBitmap(GetResources(),'BR_VERMELHO')
Private oAm     := LoadBitmap(GetResources(),'BR_AMARELO')

Aadd(aList1,{'','','','','','','','','',''})
Aadd(aList2,{'','','','','','','','','','',.T.})
Aadd(aList4,{'','',.T.})
Aadd(aList5,{'','',.T.})
Aadd(aList6,{'','',.T.})

aPer := Periodo()

If len(aPer) > 0
    Busca(aPer)

    cPer1 := substr(aPer[1],1,2)+"/"+substr(aPer[1],3)
    cPer2 := substr(aPer[2],1,2)+"/"+substr(aPer[2],3)
    cPer3 := substr(aPer[3],1,2)+"/"+substr(aPer[3],3)
    cPer4 := '' //substr(aPer[4],1,2)+"/"+substr(aPer[4],3)
    
    While !lSair
        oDlg1      := MSDialog():New( 092,207,797,1502,"Metas de 2021 área comercial ref 1 Quadrimestre",,,.F.,,,,,,.T.,,,.T. )

        oGrp1      := TGroup():New( 004,004,120,449,"Gerentes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            
            oList1:= 	TCBrowse():New(012,008,439,104,, {'Codigo','Nome','Qtd',cPer1,'Qtd',cPer2,'Qtd',cPer3,'Total Qtd.','Total R$'},{30,70,30,30,30,30,30,30,30,30},;
                                        oGrp1,,,,{|| Fhelp(oList1:nAt) },{|| },,,,,,,.F.,,.T.,,.F.,,,)
            oList1:SetArray(aList1)
            oList1:bLine := {||{aList1[oList1:nAt,01],;
                                aList1[oList1:nAt,02],;
                                Transform(aList1[oList1:nAt,08],"@E 999,999,999.99"),;
                                Transform(aList1[oList1:nAt,03],"@E 999,999,999.99"),;
                                Transform(aList1[oList1:nAt,09],"@E 999,999,999.99"),;
                                Transform(aList1[oList1:nAt,04],"@E 999,999,999.99"),;
                                Transform(aList1[oList1:nAt,10],"@E 999,999,999.99"),;
                                Transform(aList1[oList1:nAt,05],"@E 999,999,999.99"),;
                                Transform(aList1[oList1:nAt,08]+aList1[oList1:nAt,09]+aList1[oList1:nAt,10],"@E 999,999,999.99"),;
                                Transform(aList1[oList1:nAt,07],"@E 999,999,999.99")}}

        oGrp2      := TGroup():New( 124,004,248,636,"Representantes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            
            oList2:= 	TCBrowse():New(132,008,626,113,, {'','Região','Sub-Região','Mala','Codigo','Nome','Qtd',cPer1,'Qtd',cPer2,'Qtd',cPer3,'Total Qtd.','Total R$'},{10,30,40,30,30,30,30,30,30,30,30,30,30,30},;
                                        oGrp2,,,,{|| Fhelp2(oList2:nAt)},{|| editcol(oList2:nAt) },, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList2:SetArray(aList2)
            oList2:bLine := {||{If(aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm),;
                                aList2[oList2:nAt,01],;
                                aList2[oList2:nAt,02],;
                                aList2[oList2:nAt,03],;
                                aList2[oList2:nAt,04],;
                                aList2[oList2:nAt,05],;
                                Transform(aList2[oList2:nAt,20],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,06],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,21],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,07],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,22],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,08],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,20]+aList2[oList2:nAt,21]+aList2[oList2:nAt,22],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,10],"@E 999,999,999.99")}}

        oGrp3      := TGroup():New( 004,455,120,636,"Total Geral",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            
            oSay1      := TSay():New( 020,476,{||"Mês "+cPer1},oGrp3,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
            oSay2      := TSay():New( 020,516,{|| Transform(nVlr01,"@E 999,999,999.99")},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            oSay7      := TSay():New( 020,556,{|| ""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
            
            oSay3      := TSay():New( 040,476,{||"Mês "+cPer2},oGrp3,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
            oSay4      := TSay():New( 040,516,{|| Transform(nVlr02,"@E 999,999,999.99")},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            oSay8      := TSay():New( 040,556,{|| ""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            
            oSay5      := TSay():New( 060,476,{||"Mês "+cPer3},oGrp3,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
            oSay6      := TSay():New( 060,516,{|| Transform(nVlr03,"@E 999,999,999.99")},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            oSay11     := TSay():New( 060,556,{|| ""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            
            oSay9      := TSay():New( 080,476,{||"Total Geral"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
            oSay10     := TSay():New( 080,516,{|| Transform(nVlr05,"@E 999,999,999.99")},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            oSay12     := TSay():New( 080,556,{|| ""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            
            oSay13     := TSay():New( 100,476,{||"Total Representante"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,062,008)
            oSay14     := TSay():New( 100,526,{|| ""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            oSay15     := TSay():New( 100,566,{|| ""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
            
        oGrp4      := TGroup():New( 252,184,340,360,"Regiões",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            
            oList4:= 	TCBrowse():New(260,188,169,078,, {'','Codigo','Nome'},{10,50,90},;
                                        oGrp4,,,,{||  },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList4:SetArray(aList4)
            oList4:bLine := {||{If(aList4[oList4:nAt,len(aList4[oList4:nAt])],oVd,oVm),;
                                aList4[oList4:nAt,01],;
                                aList4[oList4:nAt,02]}}

        oGrp6      := TGroup():New( 252,364,340,540,"Sub-Regiões",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            
            oList6:= 	TCBrowse():New(260,368,169,078,, {'','Codigo','Nome'},{10,50,90},;
                                        oGrp6,,,,{||  },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList6:SetArray(aList6)
            oList6:bLine := {||{If(aList6[oList6:nAt,len(aList6[oList6:nAt])],oVd,oVm),;
                                aList6[oList6:nAt,01],;
                                aList6[oList6:nAt,02]}}

        oGrp5      := TGroup():New( 252,004,340,180,"Malas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            
            oList5:= 	TCBrowse():New(260,008,169,078,, {'','Codigo','Nome'},{10,50,90},;
                                        oGrp5,,,,{||  },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList5:SetArray(aList5)
            oList5:bLine := {||{If(aList5[oList5:nAt,len(aList5[oList5:nAt])],oVd,oVm),;
                                aList5[oList5:nAt,01],;
                                aList5[oList5:nAt,02]}}


        oGrp7      := TGroup():New( 252,544,340,636,"Opções",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

            //oCBox1     := TComboBox():New( 260,548,,{"0=Selecione","1=1 Quadrimestre","2=2 Quadrimestre","3=3 Quadrimestre"},084,010,oGrp7,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
            oBtn1      := TButton():New( 276,548,"Malas",oGrp7,{|| Mala(oList5:nAt,oList2:nAt)},037,012,,,,.T.,,"",,,,.F. )
            oBtn2      := TButton():New( 292,548,"Regiões",oGrp7,{|| Regiao(oList4:nAt,oList2:nAt)},037,012,,,,.T.,,"",,,,.F. )
            oBtn3      := TButton():New( 308,548,"Sub-Regiões",oGrp7,{|| SubReg(oList6:nAt,oList2:nAt)},037,012,,,,.T.,,"",,,,.F. )
            oBtn4      := TButton():New( 276,596,"Duplicar Linha",oGrp7,{|| dupllin(oList2:nAt) },037,012,,,,.T.,,"",,,,.F. )
            oBtn5      := TButton():New( 292,596,"Salvar",oGrp7,{|| Saveitm()},037,012,,,,.T.,,"",,,,.F. )
            oBtn6      := TButton():New( 308,596,"Sair",oGrp7,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

            
            MENU oMenu1 POPUP 
            MENUITEM "Remover Linha" ACTION ( dellin(oList2:nAt,1))
            ENDMENU                                                                           

            oList2:bRClicked := { |oObject,nX,nY| oMenu1:Activate( nX, (nY-10), oObject ) }


        oDlg1:Activate(,,,.T.)

        If nOpc == 0
            For nCont := 1 to len(aList2B)
                If !aList2B[nCont,len(aList2B[nCont])]
                    nSair++
                    exit
                EndIf
            Next nCont

            If nSair > 0
                If MsgYesNo("Existem itens alterados que não foram salvos, deseja realmente sair?")
                    lSair := .T.
                EndIf
            else
                lSair := .T.
            EndIf
        
        EndIf
    EndDo
EndIf

Return

 /*/{Protheus.doc} Periodo
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
Static Function Periodo()
    
    Local aArea     :=  GetArea()
    Local cPerg1    :=  year(ddatabase)
    Local aPerg     :=  {}
    Local aAux      :=  {}
    Local nCont     :=  0
    Local aGrupos   :=  {'1=Primeiro','2=Segundo','3=Terceiro','4=Quarto'}
    Local aQuadri   :=  {{'01','02','03'},{'04','05','06'},{'07','08','09'},{'10','11','12'}}
    
    aAdd(aPerg, {1, "Ano desejado" ,  cPerg1,  "", ".T.", "", ".T.", 50,  .F.})
    AAdd(aPerg, {2, "Trimestre" ,  aGrupos[1], aGrupos, 50,'.T.',.T.})
	
    If ParamBox(aPerg, "Confirme o ano desejado a ser configurado!")
        cPerg1 := cvaltochar(MV_PAR01)
        aAux   := aQuadri[val(MV_PAR02)]
        cQuad  := cvaltochar(MV_PAR02)

        For nCont := 1 to len(aAux)
            aAux[nCont] += cPerg1
        Next nCont
    else
        aAux := {}
    ENDIF

    RestArea(aArea)

Return(aAux)

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
Static Function Busca(aPer)

Local aArea := GetArea()
Local cQuery 
Local nCont1 := 0
Local nCont2 := 0

aList1 := {}
aList2 := {}
aList3 := {}
aList4 := {}
aList5 := {}
aList6 := {}

cQuery := "SELECT A3_COD,A3_NOME "
cQuery += " FROM "+RetSQLName("SA3")
cQuery += " WHERE A3_FILIAL='"+xFilial("SA3")+"' AND A3_MSBLQL<>'1' AND D_E_L_E_T_=' ' AND A3_XFUNCAO='2'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList1,{TRB->A3_COD,TRB->A3_NOME,0,0,0,0,0,0,0,0})
    Dbskip()
EndDo

If len(aList1) < 1
    Aadd(aList1,{'','',0,0,0,0,0,0,0,0})
EndIf

cQuery := "SELECT A3_COD,A3_NOME,A3_GEREN,Z31_MALA,Z31_REGIAO,Z31_SUBREG,Z31_ITEM,"
cQuery += " Z31_VLMS01,Z31_VLMS02,Z31_VLMS03,Z31_VLMS04,Z31_MSAN01,Z31_MSAN02,Z31_MSAN03,Z31_MSAN04,"
cQuery += " Z30_MALA,Z30_REGIAO,Z30_SUBREG,Z31_QTDMS1,Z31_QTDMS2,Z31_QTDMS3,Z31.R_E_C_N_O_ AS RECZ31"
cQuery += " FROM "+RetSQLName("SA3")+" A3"
cQuery += " LEFT JOIN "+RetSQLName("Z31")+" Z31 ON Z31_FILIAL='"+xFilial("Z31")+"' AND Z31_CODVEN=A3_COD AND Z31.D_E_L_E_T_=' '"

cQuery += "  AND (Z31_MSAN01 = '"+aPer[1]+"' OR Z31_MSAN02='"+aPer[2]+"' OR Z31_MSAN03='"+aPer[3]+"')" // OR Z31_MSAN04='"+aPer[4]+"')"

cQuery += " LEFT JOIN "+RetSQLName("Z30")+" Z30 ON Z30_FILIAL='"+xFilial("Z30")+"' AND Z30_CODVEN=A3_COD AND Z30.D_E_L_E_T_=' '"
cQuery += " WHERE A3_FILIAL='"+xFilial("SA3")+"' AND A3_MSBLQL<>'1' AND A3.D_E_L_E_T_=' ' AND A3_XFUNCAO<>'2'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
//'','Região','Sub-Região','Mala','Codigo','Nome','Total 1','Total 2','Total 3','Total 4','Total Geral'
    Aadd(aList2b,{Alltrim(TRB->Z31_REGIAO),Alltrim(TRB->Z31_SUBREG),Alltrim(TRB->Z31_MALA),;
                  TRB->A3_COD,TRB->A3_NOME,TRB->Z31_VLMS01,TRB->Z31_VLMS02,TRB->Z31_VLMS03,;
                  TRB->Z31_VLMS04,TRB->Z31_VLMS01+TRB->Z31_VLMS02+TRB->Z31_VLMS03+TRB->Z31_VLMS04,;
                  If(Empty(TRB->Z31_MSAN01),cPer1,TRB->Z31_MSAN01),;
                  If(Empty(TRB->Z31_MSAN02),cPer2,TRB->Z31_MSAN02),;
                  If(Empty(TRB->Z31_MSAN03),cPer3,TRB->Z31_MSAN03),;
                  If(Empty(TRB->Z31_MSAN04),cPer4,TRB->Z31_MSAN04),;
                  TRB->Z30_MALA,TRB->Z30_REGIAO,TRB->Z30_SUBREG,;
                  If(!Empty(TRB->Z31_ITEM),TRB->Z31_ITEM,strzero(len(aList2B),4)),;
                  TRB->A3_GEREN,TRB->Z31_QTDMS1,TRB->Z31_QTDMS2,TRB->Z31_QTDMS3,;
                  TRB->RECZ31,.T.})
    Dbskip()
EndDo

If len(aList2b) < 1
    Aadd(aList2b,{'','','','','',0,0,0,0,0,cPer1,cPer2,cPer3,cPer4,'','','','','',0,0,0,0,.T.})
EndIf

cQuery := "SELECT Z03_CODGRI,Z03_DESGRI"
cQuery += " FROM "+RetSQLName("Z03")
cQuery += " WHERE Z03_FILIAL='"+xFilial("Z03")+"' AND D_E_L_E_T_=' ' AND Z03_MSBLQL<>'1'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList5,{TRB->Z03_CODGRI,TRB->Z03_DESGRI,.F.})
    Dbskip()
EndDo

If len(aList5) < 1
    Aadd(aList5,{'','','','',.F.})
EndIF

cQuery := "SELECT X5_CHAVE,X5_DESCRI"
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
    Aadd(aList6b,{Alltrim(TRB->CC2_CODMUN),Alltrim(TRB->CC2_MUN)+'/'+TRB->CC2_EST,.F.})
    Dbskip()
EndDo

If len(aList6b) < 1
    Aadd(aList6b,{'','','','','','','','','',.F.})
EndIf 


For nCont1 := 1 to len(aList1)
    For nCont2 := 1 to len(aList2b)
        If aList1[nCont1,01] == aList2b[nCont2,len(aList2b[nCont2])-5]
            aList1[nCont1,03] += aList2b[nCont2,06]
            aList1[nCont1,04] += aList2b[nCont2,07]
            aList1[nCont1,05] += aList2b[nCont2,08]
            aList1[nCont1,06] += aList2b[nCont2,09]
            aList1[nCont1,07] += aList2b[nCont2,10]
            aList1[nCont1,08] += aList2b[nCont2,20]
            aList1[nCont1,09] += aList2b[nCont2,21]
            aList1[nCont1,10] += aList2b[nCont2,22]
        EndIf
    Next nCont2
Next nCont

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

oSay2:settext("")
oSay4:settext("")
oSay6:settext("")
oSay7:settext("")
oSay8:settext("")
oSay10:settext("")
oSay11:settext("")
oSay12:settext("")

nVlr01 := 0
nVlr02 := 0
nVlr03 := 0
nVlr04 := 0
nVlr05 := 0
nQtd01 := 0
nQtd02 := 0
nQtd03 := 0


For nCont := 1 to len(aList2B)
    If Alltrim(aList1[nLinha,01]) == Alltrim(aList2B[nCont,len(aList2B[nCont])-5])
        Aadd(aList2,aList2B[nCont])
    EndIf
Next nCont


For nCont := 1 to len(aList1)
    If Alltrim(aList1[nLinha,01]) == Alltrim(aList1[nCont,01])
        nVlr01 += aList1[nCont,03]
        nVlr02 += aList1[nCont,04]
        nVlr03 += aList1[nCont,05]
        nVlr04 += aList1[nCont,06]
        nVlr05 += aList1[nCont,07]
        nQtd01 += aList1[nCont,08]
        nQtd02 += aList1[nCont,09]
        nQtd03 += aList1[nCont,10]
    Endif
Next nCont

If len(aList2) < 1
    Aadd(aList2,{'','','','','',0,0,0,0,0,cPer1,cPer2,cPer3,cPer4,'','','','','',0,0,0,0,.T.})
EndIf

Asort(aList2,,,{|x,y| x[5] < y[5]})

oList2:SetArray(aList2)
oList2:bLine := {||{If(aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm),;
                                aList2[oList2:nAt,01],;
                                aList2[oList2:nAt,02],;
                                aList2[oList2:nAt,03],;
                                aList2[oList2:nAt,04],;
                                aList2[oList2:nAt,05],;
                                Transform(aList2[oList2:nAt,20],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,06],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,21],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,07],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,22],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,08],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,20]+aList2[oList2:nAt,21]+aList2[oList2:nAt,22],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,10],"@E 999,999,999.99")}}                  

oSay2:settext(Transform(nVlr01,"@E 999,999,999.99"))
oSay4:settext(Transform(nVlr02,"@E 999,999,999.99"))
oSay6:settext(Transform(nVlr03,"@E 999,999,999.99"))
oSay7:settext(Transform(nQtd01,"@E 999,999,999.99"))
oSay8:settext(Transform(nQtd02,"@E 999,999,999.99"))
oSay10:settext(Transform(nVlr05,"@E 999,999,999.99"))
oSay11:settext(Transform(nQtd03,"@E 999,999,999.99"))
oSay12:settext(Transform(nQtd01+nQtd02+nQtd03,"@E 999,999,999.99"))

oList1:refresh()
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
Local ccod  :=  aList2[nLinha,04]

oSay14:settext("")
oSay15:settext("")

aList6 := {}
nVlrR1 := 0
nQtdR1 := 0

If len(aList2) < 1
    Aadd(aList2,{'','','','','',0,0,0,0,0,cPer1,cPer2,cPer3,cPer4,'','','','','',0,0,0,.T.})
EndIf

Aeval(aList2,{|aList2| nVlrR1 += If(aList2[4] == ccod,aList2[10],0)})
Aeval(aList2,{|aList2| nQtdR1 += If(aList2[4] == ccod,aList2[20]+aList2[21]+aList2[22],0)})

//REGIAO 4 SUB-REGIAO 6 MALA 5

For nCont := 1 to len(aList4)
    If Alltrim(aList4[nCont,01]) $ Alltrim(aList2[nLinha,16]) 
        aList4[nCont,len(aList4[nCont])] := .T.
    else
        aList4[nCont,len(aList4[nCont])] := .F.
    EndIf
Next nCont

For nCont := 1 to len(aList6b)
    If Alltrim(aList6b[nCont,01]) $ Alltrim(aList2[nLinha,17]) 
        aList6b[nCont,len(aList6b[nCont])] := .T.
    else
        aList6b[nCont,len(aList6b[nCont])] := .F.
    EndIf
Next nCont

For nCont := 1 to len(aList6b)
    If aList6b[nCont,len(aList6b[nCont])]
        Aadd(aList6,aList6B[nCont])
    ENDIF
Next nCont

If len(aList6) < 1
    Aadd(aList6,{'','','','','','','','','',.F.})
EndIf

For nCont := 1 to len(aList5)
    If Alltrim(aList5[nCont,01]) $ Alltrim(aList2[nLinha,15]) 
        aList5[nCont,len(aList5[nCont])] := .T.
    else
        aList5[nCont,len(aList5[nCont])] := .F.
    EndIf
Next nCont

oList6:SetArray(aList6)
oList6:bLine := {||{If(aList6[oList6:nAt,len(aList6[oList6:nAt])],oVd,oVm),;
                    aList6[oList6:nAt,01],;
                    aList6[oList6:nAt,02]}}

oSay14:settext(Transform(nVlrR1,"@E 999,999,999.99"))
oSay15:settext(Transform(nQtdR1,"@E 999,999,999.99"))

oList4:refresh()
oList5:refresh()
oList6:refresh()
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
Local nPos2 :=  Ascan(aList2b,{|x| Alltrim(x[4])+Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList2[nLin2,04])+Alltrim(aList2[nLin2,01])+Alltrim(aList2[nLin2,02])+Alltrim(aList2[nLin2,03])})
Local cBarra:=  If(!Empty(aList2[nLin2,03]),"/","")
Local lCont :=  Alltrim(aList5[nLin1,01]) $ Alltrim(aList2[nLin2,03])
Local aAux  :=  {}
Local nCont :=  0

If aList5[nLin1,len(aList5[nLin1])]
    If !lCont
        aList2[nLin2,03] += cBarra + aList5[nLin1,01]
        aList2[nLin2,len(aList2[nLin2])] := .F.
        aList2b[nPos2,03] := aList2[nLin2,03]
    Else
        cBarra := ""
        
        aAux := Separa(aList2[nLin2,03], "/", .T.)
        
        aList2[nLin2,03] := ""
        aList2b[nPos2,03]:= ""

        For nCont := 1 to len(aAux)
            If Alltrim(aAux[nCont]) <> Alltrim(aList5[nLin1,01])
                aList2[nLin2,03] += cBarra + aAux[nCont]
                cBarra := "/"
            EndIf
            
        Next nCont

        aList2[nLin2,len(aList2[nLin2])] := .F.
        aList2b[nPos2,03] := aList2[nLin2,03]
    ENDIF
else
    MsgAlert("Somente Malas pré-configuradas no cadastro de equipes podem ser selecionadas.")
EndIf

oList2:refresh()
oList5:refresh()
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
Local nPos2 :=  Ascan(aList2b,{|x| Alltrim(x[4])+Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList2[nLin2,04])+Alltrim(aList2[nLin2,01])+Alltrim(aList2[nLin2,02])+Alltrim(aList2[nLin2,03])})
Local cBarra:=  If(!Empty(aList2[nLin2,01]),"/","")
Local lCont :=  Alltrim(aList4[nLin1,01]) $ Alltrim(aList2[nLin2,01])
Local aAux  :=  {}
Local nCont :=  0

If aList4[nLin1,len(aList4[nLin1])]
    If !lCont
        aList2[nLin2,01] += cBarra + aList4[nLin1,01]
        aList2[nLin2,len(aList2[nLin2])] := .F.
        aList2b[nPos2,01] := aList2[nLin2,01]
    Else
        cBarra := ""
        
        aAux := Separa(aList2[nLin2,01], "/", .T.)
        
        aList2[nLin2,01] := ""
        aList2b[nPos2,01]:= ""

        For nCont := 1 to len(aAux)
            If Alltrim(aAux[nCont]) <> Alltrim(aList4[nLin1,01])
                aList2[nLin2,01] += cBarra + aAux[nCont]
                cBarra := "/"
            EndIf
            
        Next nCont

        aList2[nLin2,len(aList2[nLin2])] := .F.
        aList2b[nPos2,01] := aList2[nLin2,01]
    ENDIF
else
    MsgAlert("Somente regiões pré-configuradas no cadastro de equipes podem ser selecionadas")
EndIf

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
Local nPos2 :=  Ascan(aList2b,{|x| Alltrim(x[4])+Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList2[nLin2,04])+Alltrim(aList2[nLin2,01])+Alltrim(aList2[nLin2,02])+Alltrim(aList2[nLin2,03])})
Local cBarra:=  If(!Empty(aList2[nLin2,02]),"/","")
Local lCont :=  Alltrim(aList6[nLin1,01]) $ Alltrim(aList2[nLin2,02])
Local aAux  :=  {}
Local nCont :=  0

If aList6[nLin1,len(aList6[nLin1])]
    If !lCont
        aAux := Separa(aList6[oList6:nAt,02], "/", .T.)
        If !aAux[2] $ Alltrim(aList2[oList2:nAt,16])
            MsgAlert("Cidade selecionada não esta relacionada com nenhuma Região do Vendedor")
        Else
            aList2[nLin2,02] += cBarra + aList6[nLin1,01]
            aList2[nLin2,len(aList2[nLin2])] := .F.
            aList2b[nPos2,02] := aList2[nLin2,02]
        EndIf
    Else
        cBarra := ""
        
            aAux := Separa(aList2[nLin2,02], "/", .T.)
            
            aList2[nLin2,02] := ""
            aList2b[nPos2,02]:= ""

            For nCont := 1 to len(aAux)
                If Alltrim(aAux[nCont]) <> Alltrim(aList6[nLin1,01])
                    aList2[nLin2,02] += cBarra + aAux[nCont]
                    cBarra := "/"
                EndIf
                
            Next nCont

            aList2[nLin2,len(aList2[nLin2])] := .F.
            aList2b[nPos2,02] := aList2[nLin2,02]
        //EndIf
    ENDIF
else
    MsgAlert("Somente sub-regiões pré-configuradas no cadastro de equipes podem ser selecionadas")
EndIf

oList2:refresh()
oList6:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} editcol(oList2:nAt)
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
Static Function editcol(nLinha)

Local aArea     :=  GetArea()
Local nColuna   :=  oList2:nColpos
Local nCont     := 0
Local nPos2     :=  Ascan(aList2b,{|x| Alltrim(x[4])+Alltrim(x[len(x)-5])+Alltrim(x[3]) == Alltrim(aList2[nLinha,04])+Alltrim(aList2[nLinha,len(aList2[nLinha])-5])+Alltrim(aList2[nLinha,03])})
Local aAuxPos   := {{7,20},{8,6},{9,21},{10,7},{11,22},{12,8}}
Local nPosArr   := Ascan(aAuxPos,{|x| x[1] == nColuna})

If nColuna >= 7 .And. nColuna <= 12 .And. nPosArr > 0
    While nColuna <= 12
        nPosArr   := Ascan(aAuxPos,{|x| x[1] == nColuna})
        cCpo1 := aList2[nLinha,aAuxPos[nPosArr,2]]
        cCpo2 := aList2[nLinha,nColuna]

        aList2[nLinha,nColuna] := cCpo1  //07
        lEditCell( aList2, oList2, "@E 999,999,999.99", nColuna)
        aList2[nLinha,aAuxPos[nPosArr,2]] := aList2[nLinha,nColuna]
        aList2[nLinha,nColuna] := cCpo2

        If aList2[nLinha,aAuxPos[nPosArr,2]] <> cCpo1 //06
            aList2[nLinha,len(aList2[nLinha])] := .F.
        EndIF

        
        aList2[nLinha,10] := aList2[nLinha,06] + aList2[nLinha,07] + aList2[nLinha,08] + aList2[nLinha,09] 
        
        aList2b[nPos2,06] := aList2[nLinha,06]
        aList2b[nPos2,07] := aList2[nLinha,07]
        aList2b[nPos2,08] := aList2[nLinha,08]
        aList2b[nPos2,09] := aList2[nLinha,09]
        aList2b[nPos2,10] := aList2[nLinha,10]
        aList2b[nPos2,20] := aList2[nLinha,20]
        aList2b[nPos2,21] := aList2[nLinha,21]
        aList2b[nPos2,22] := aList2[nLinha,22]


        aList1[oList1:nAt,03] := 0
        aList1[oList1:nAt,04] := 0
        aList1[oList1:nAt,05] := 0
        aList1[oList1:nAt,06] := 0
        aList1[oList1:nAt,07] := 0
        aList1[oList1:nAt,08] := 0
        aList1[oList1:nAt,09] := 0
        aList1[oList1:nAt,10] := 0

        For nCont := 1 to len(aList2)
            aList1[oList1:nAt,03] += aList2[nCont,06]
            aList1[oList1:nAt,04] += aList2[nCont,07]
            aList1[oList1:nAt,05] += aList2[nCont,08]
            aList1[oList1:nAt,06] += aList2[nCont,09]
            aList1[oList1:nAt,07] += aList2[nCont,10]
            aList1[oList1:nAt,08] += aList2[nCont,20]
            aList1[oList1:nAt,09] += aList2[nCont,21]
            aList1[oList1:nAt,10] += aList2[nCont,22]
            
        Next nCont
        nColuna++
    ENDDO
    
    Fhelp(oList1:nAt)

    oList1:refresh()
    oDlg1:refresh()
ENDIF

RestArea(aArea)

Return
/*/{Protheus.doc} dupllin()

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
Static Function dupllin(nLinha)

Local aArea :=  GetArea()

Aadd(aList2,{'','','',aList2[nLinha,04],aList2[nLinha,05],0,0,0,0,0,;
            aList2[nLinha,11],aList2[nLinha,12],aList2[nLinha,13],aList2[nLinha,14],;
            aList2[nLinha,15],aList2[nLinha,16],aList2[nLinha,17],strzero(len(aList2b)+1,4),aList2[nLinha,19],;
            0,0,0,0,.F.})

Aadd(aList2b,{'','','',aList2[nLinha,04],aList2[nLinha,05],0,0,0,0,0,;
            aList2[nLinha,11],aList2[nLinha,12],aList2[nLinha,13],aList2[nLinha,14],;
            aList2[nLinha,15],aList2[nLinha,16],aList2[nLinha,17],strzero(len(aList2b)+1,4),aList2[nLinha,19],;
            0,0,0,0,.F.})

Asort(aList2,,,{|x,y| x[5] < y[5]})

oList2:SetArray(aList2)
oList2:bLine := {||{If(aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm),;
                                aList2[oList2:nAt,01],;
                                aList2[oList2:nAt,02],;
                                aList2[oList2:nAt,03],;
                                aList2[oList2:nAt,04],;
                                aList2[oList2:nAt,05],;
                                Transform(aList2[oList2:nAt,20],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,06],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,21],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,07],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,22],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,08],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,20]+aList2[oList2:nAt,21]+aList2[oList2:nAt,22],"@E 999,999,999.99"),;
                                Transform(aList2[oList2:nAt,10],"@E 999,999,999.99")}}

oList2:refresh()
oDlg1:refresh()

Fhelp(oList1:nAt)
Fhelp2(nLinha)

RestArea(aArea)

Return

/*/{Protheus.doc} SaveItm()
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
Static Function SaveItm()

Local aArea :=  GetArea()
Local nCont :=  0
Local nPosG :=  0
Local cChave:=  ''
Local lOk   :=  .T.

DbSelectArea("Z31")
DbSetOrdeR(1)

aSort(aList2b,,,{|x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4]})

cChave := aList2b[1,1]+aList2b[1,2]+aList2b[1,3]+aList2b[1,4]

For nCont := 2 to len(aList2b)
    If aList2b[nCont,1]+aList2b[nCont,2]+aList2b[nCont,3]+aList2b[nCont,4] == cChave
        cCodGer := aList2b[nCont,len(aList2b[nCont])-5]
        cNomGer := aList1[Ascan(aList1,{|x| x[1] == cCodGer}),02]
        MsgAlert("Itens duplicados para o vendedor "+aList2b[nCont,5]+" Gerente "+cNomGer)
        lOk := .F.
    else
        cChave := aList2b[nCont,1]+aList2b[nCont,2]+aList2b[nCont,3]+aList2b[nCont,4]
    EndIf
Next nCont

If lOk
    For nCont := 1 to len(aList2b)
        If !aList2b[nCont,len(aList2b[nCont])]
            nPosG := Ascan(aList2,{|x| Alltrim(x[4])+x[len(x)-6] == Alltrim(aList2b[nCont,04])+aList2b[nCont,len(aList2b[nCont])-6]})
            
            If !Dbseek(xFilial("Z31")+Alltrim(aList2b[nCont,len(aList2b[nCont])-5])+Alltrim(aList2b[nCont,04]+aList2b[nCont,len(aList2b[nCont])-6]))
                Reclock("Z31",.T.)
            else
                Reclock("Z31",.F.)
            EndIf

    //REGIAO 4 SUB-REGIAO 6 MALA 5
    
            Z31->Z31_FILIAL := xFilial("Z31") 
            Z31->Z31_CODGER := aList2b[nCont,19]
            Z31->Z31_CODVEN := aList2b[nCont,04]
            Z31->Z31_MALA   := aList2b[nCont,03]
            Z31->Z31_REGIAO := aList2b[nCont,01]
            Z31->Z31_SUBREG := aList2b[nCont,02]
            Z31->Z31_MSAN01 := strtran(cPer1,"/")
            Z31->Z31_MSAN02 := strtran(cPer2,"/")
            Z31->Z31_MSAN03 := strtran(cPer3,"/") 
            Z31->Z31_MSAN04 := strtran(cPer4,"/") 
            Z31->Z31_VLMS01 := aList2b[nCont,06] 
            Z31->Z31_VLMS02 := aList2b[nCont,07] 
            Z31->Z31_VLMS03 := aList2b[nCont,08] 
            Z31->Z31_VLMS04 := aList2b[nCont,09] 
            Z31->Z31_ITEM   := aList2b[nCont,18]
            Z31->Z31_QTDMS1 := aList2b[nCont,20] 
            Z31->Z31_QTDMS2 := aList2b[nCont,21] 
            Z31->Z31_QTDMS3 := aList2b[nCont,22]  
            Z31->Z31_QUADRI := cQuad 
            Z31->(MsUnlock())

            aList2b[nCont,len(aList2b[nCont])] := .T.
            If nPosG > 0
                aList2[nPosG,len(aList2[nPosG])] := .T.
            EndIf
        EndIf
    Next nCont

    oList2:refresh()
    oDlg1:refresh()

    MsgAlert("Registros atualizados com sucesso!!!" )
EndIf



RestArea(aArea)

Return

/*/{Protheus.doc} dellin(oList2:nAt,1)
    (long_description)
    @type  Static Function
    @author user
    @since 14/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function dellin(nLinha,nOpc)

Local aArea :=  GetArea()
Local nPos2     :=  Ascan(aList2b,{|x| Alltrim(x[4])+Alltrim(x[len(x)-5])+Alltrim(x[3]) == Alltrim(aList2[nLinha,04])+Alltrim(aList2[nLinha,len(aList2[nLinha])-5])+Alltrim(aList2[nLinha,03])})

Adel(aList2,nLinha)
Asize(aList2, len(aList2) - 1)

Adel(aList2b,nPos2)
Asize(aList2b, len(aList2b) - 1)


oList2:refresh()
oDlg1:refresh()

RestArea(aArea)

Return 
