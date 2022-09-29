#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function ROBCMS03()

Local oBrowse := FwLoadBrw("ROBCMS03")
    
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

    oBrowse:SetAlias("Z32")
    oBrowse:SetDescription("Cadastro de Regras de Comiss�es")

   // DEFINE DE ONDE SER RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROBCMS03")
   oBrowse:SetFilterDefault( "Z32->Z32_ITEM == '0001'" )


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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ROBCMS03' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Novas'    ACTION 'U_xRBMS03' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Regras'    ACTION 'VIEWDEF.ROBCMS03' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ROBCMS03' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ROBCMS03' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("ROBCMR")
Local oStruSC5 := FwFormStruct(1, "Z32")
Local oStruSC6 := FwFormStruct(1, "Z32")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("Z32MASTER", NIL, oStruSC5)
    oModel:AddGrid("Z32DETAIL", "Z32MASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "Z32_FILIAL", "Z32_CODIGO", "Z32_ITEM" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    oModel:SetRelation("Z32DETAIL", {{"Z32_FILIAL", "FwXFilial('Z32')"}, {"Z32_CODIGO", "Z32_CODIGO"}}, Z32->(IndexKey(1)))

    //oStruSC6:AddTrigger("ZY1_VEND", "ZY1_NVEND",{|| .T.}, {|| POSICIONE("Z32",1,XFILIAL("Z32")+oModel:GetValue('ZY1DETAIL','ZY1_VEND'),"A3_NOME") })
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Regras")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("Z32MASTER"):SetDescription("Cabe�alho")
    oModel:GetModel("Z32DETAIL"):SetDescription("Itens")
    
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
Local oStruSC5 := FwFormStruct(2, "Z32")
Local oStruSC6 := FwFormStruct(2, "Z32")
Local oModel   := FwLoadModel("ROBCMS03")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("Z32_FILIAL")
    oStruSC5:RemoveField("Z32_ITEM")
    oStruSC5:RemoveField("Z32_TIPOCL")
    oStruSC5:RemoveField("Z32_VNDQT1")
    oStruSC5:RemoveField("Z32_VNDQT2")
    oStruSC5:RemoveField("Z32_QTDDS1")
    oStruSC5:RemoveField("Z32_QTDDS2")
    oStruSC5:RemoveField("Z32_VNDVL1")
    oStruSC5:RemoveField("Z32_VNDVL2")
    oStruSC5:RemoveField("Z32_CONDPG")
    oStruSC5:RemoveField("Z32_COMISS")
    oStruSC5:RemoveField("Z32_BONUS")
    
    oStruSC6:RemoveField("Z32_FILIAL")
    oStruSC6:RemoveField("Z32_CODIGO")
    oStruSC6:RemoveField("Z32_DESCRI")
    oStruSC6:RemoveField("Z32_PGTPOR")
    oStruSC6:RemoveField("Z32_DTINI")
    oStruSC6:RemoveField("Z32_DTFIM")
    oStruSC6:RemoveField("Z32_DIATOL")
    oStruSC6:RemoveField("Z32_MSBLQL")
    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "Z32MASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    oView:AddGrid("VIEW_SC6", oStruSC6, "Z32DETAIL")
    
    oView:AddIncrementField( 'VIEW_SC6', 'Z32_ITEM' )

    

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

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  FunctionUser
    @author user
    @ate
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xRBMS03

Local nOpc      :=  0
Private oDlg1
Private oGrp1
Private oSay1
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oSay7
Private oSay8
Private oSay9
Private oGet1
Private oCBox1
Private oGet2
Private oGet4
Private oGet5
Private oGet6
Private oGrp2
Private oBtn1
Private oBtn2
Private oBtn3
Private oBtn4
Private aItens := {'1=Pedido','2=Baixa Financeira'}
Private aTpCli := {'1=Varejo','2=Redes','3=Grandes_Redes'}
Private cCombo1  := aItens[1]
Private cCombo2  := aTpCli[1]
Private aList2  :=  {}
Private aList2b :=  {}
Private oList2
Private dDtDe   :=  ctod(" / / ")
Private dDtAt   :=  ctod(" / / ")
Private cDescr  :=  space(150)
Private nToler  :=  0
Private cNumero :=  GetSXEnum("Z32","Z32_CODIGO")
Private cCliEsp :=  space(14)
Private cGrpEsp :=  space(6)

Private oVd     := LoadBitmap(GetResources(),'BR_VERDE')
Private oVm     := LoadBitmap(GetResources(),'BR_VERMELHO')

Aadd(aList2,{0,0,0,0,0,0,space(3),0,'Sim',0,.T.})

oDlg1      := MSDialog():New( 081,213,636,1463,"Cadastro de Regras de Comiss�o",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 000,168,092,412,"Cabe�alho",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay1      := TSay():New( 012,184,{||"C�digo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay2      := TSay():New( 012,280,{||cNumero},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    
    oSay3      := TSay():New( 028,184,{||"Descri��o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 026,229,{|u| If(Pcount()>0,cDescr:=u,cDescr)},oGrp1,167,008,'',{||Libersave()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay4      := TSay():New( 044,184,{||"Pagamento por?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
    oCBox1     := TComboBox():New( 044,229,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItens,167,010,oGrp1,,{||Libersave()},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
    
    oSay5      := TSay():New( 060,184,{||"V�lida de?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2      := TGet():New( 060,229,{|u| If(Pcount()>0,dDtDe:=u,dDtDe)},oGrp1,060,008,'',{||Libersave()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay6      := TSay():New( 060,300,{||"V�lida at�?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet3      := TGet():New( 060,336,{|u| If(Pcount()>0,dDtAt:=u,dDtAt)},oGrp1,060,008,'',{||Libersave()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay7      := TSay():New( 076,184,{||"Toler�ncia "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet4      := TGet():New( 076,229,{|u| If(Pcount()>0,nToler:=u,nToler)},oGrp1,020,008,'@E 999',{||Libersave()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oSay8      := TSay():New( 076,250,{||"Cliente Especial "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
    oGet5      := TGet():New( 076,290,{|u| If(Pcount()>0,cCliEsp:=u,cCliEsp)},oGrp1,040,008,'@!',{|| },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oGet5:bF3:= &('{|| IIf(ConPad1(,,,"SA1",,,.F.),Eval({|| cCliEsp := SA1->A1_COD ,oGet5:Refresh()}),.T.)}') 
    
    oSay8      := TSay():New( 076,338,{||"Bandeira"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
    oGet6      := TGet():New( 076,360,{|u| If(Pcount()>0,cGrpEsp:=u,cGrpEsp)},oGrp1,040,008,'@!',{|| },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oGet6:bF3:= &('{|| IIf(ConPad1(,,,"Z01",,,.F.),Eval({|| cGrpEsp := Z01->Z01_CODBAN ,oGet6:Refresh()}),.T.)}') 
    
    oGrp2      := TGroup():New( 092,012,236,608,"Itens",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oList2:= 	TCBrowse():New(107,020,580,123,, {'Vendas de','Vendas ate','Desconto de','Desconto ate','Valor de','Valor ate','Cond.Pagto.','Comissao','Bonus',''},{60,60,60,60,60,60,60,60,60,60,10},;
                                        oGrp2,,,,{|| /*Fhelp2(oList2:nAt)*/},{|| editcol(oList2:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    
    oList2:SetArray(aList2)
    oList2:bLine := {||{Transform(aList2[oList2:nAt,01],"@E 999"),;
                        Transform(aList2[oList2:nAt,02],"@E 999"),;
                        Transform(aList2[oList2:nAt,03],"@E 999.99"),;
                        Transform(aList2[oList2:nAt,04],"@E 999.99"),;
                        Transform(aList2[oList2:nAt,05],"@E 999,999.99"),;
                        Transform(aList2[oList2:nAt,06],"@E 999,999.99"),;
                        aList2[oList2:nAt,07],;
                        Transform(aList2[oList2:nAt,08],"@E 999.99"),;
                        aList2[oList2:nAt,09],;
                        If(aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm)}}
                        
    oBtn1      := TButton():New( 096,576,"+",oGrp2,{|| incllin()},008,008,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 096,589,"-",oGrp2,{|| dellin(oList2:nAt)},008,008,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 248,216,"Salvar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn4      := TButton():New( 248,296,"Sair",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

    oBtn3:disable()

oDlg1:Activate(,,,.T.)

If nOpc > 0
    salvReg()
ENDIF

Return

/*/{Protheus.doc} editcol(nLinha)
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

Local aArea :=  GetArea()
Local nPos  :=  oList2:colpos()
Local lCond :=  .T.
Local cBkp  :=  aList2[nLinha,nPos]

If nPos < 3
    lEditCell( aList2, oList2, "@E 999", nPos)
ElseIf nPos == 7
    lCond	:= ConPad1(,,,"SE4",,,.f.)
    If lCond
        aList2[nLinha,07] := SE4->E4_CODIGO
    EndIf
ElseIf nPos == 9
    If aList2[nLinha,nPos] == "Sim"
        aList2[nLinha,nPos] := "Nao"
    else
        aList2[nLinha,nPos] := "Sim"
    EndIf
ElseIf nPos < 10
    lEditCell( aList2, oList2, "@E 999,999.99", nPos)
EndIf

If aList2[nLinha,nPos] <> cBkp
    aList2[nLinha,len(aList2[nLinha])] := .F.
EndIf

Libersave()

RestArea(aArea)

Return

/*/{Protheus.doc} incllin()
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
Static Function incllin()

Aadd(aList2,{0,0,0,0,0,0,space(3),0,'Sim',0,.T.})

oList2:SetArray(aList2)
oList2:bLine := {||{Transform(aList2[oList2:nAt,01],"@E 999"),;
                    Transform(aList2[oList2:nAt,02],"@E 999"),;
                    Transform(aList2[oList2:nAt,03],"@E 999.99"),;
                    Transform(aList2[oList2:nAt,04],"@E 999.99"),;
                    Transform(aList2[oList2:nAt,05],"@E 999,999.99"),;
                    Transform(aList2[oList2:nAt,06],"@E 999,999.99"),;
                    aList2[oList2:nAt,07],;
                    Transform(aList2[oList2:nAt,08],"@E 999.99"),;
                    aList2[oList2:nAt,09],;
                    If(aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm)}}

oList2:refresh()
oDlg1:refresh()

Libersave()

Return


/*/{Protheus.doc} dellin()
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
Static Function dellin(nLinha)

ADel(aList2,nLinha)
ASize(aList2,len(aList2)-1)

If len(aList2) < 1
    Aadd(aList2,{0,0,0,0,0,0,space(3),0,'Sim',0,.T.})
EndIf

oList2:SetArray(aList2)
oList2:bLine := {||{Transform(aList2[oList2:nAt,01],"@E 999"),;
                    Transform(aList2[oList2:nAt,02],"@E 999"),;
                    Transform(aList2[oList2:nAt,03],"@E 999.99"),;
                    Transform(aList2[oList2:nAt,04],"@E 999.99"),;
                    Transform(aList2[oList2:nAt,05],"@E 999,999.99"),;
                    Transform(aList2[oList2:nAt,06],"@E 999,999.99"),;
                    aList2[oList2:nAt,07],;
                    Transform(aList2[oList2:nAt,08],"@E 999.99"),;
                    aList2[oList2:nAt,09],;
                    If(aList2[oList2:nAt,len(aList2[oList2:nAt])],oVd,oVm)}}

oList2:refresh()
oDlg1:refresh()

Libersave()

Return

/*/{Protheus.doc} Libersave
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
Static Function Libersave

Local aArea     :=  GetArea()
Local lLibera   :=  .T.
Local nCont     :=  0

If Empty(cDescr)
    lLibera := .F.
EndIf

If Empty(dDtde)
    lLibera := .F.
EndIf

If nToler == 0
    lLibera := .F.
EndIf

For nCont := 1 to len(aList2)
    If aList2[nCont,len(aList2[nCont])]
        lLibera := .F.
    EndIf
Next nCont

If lLibera
    oBtn3:enable()
else
    oBtn3:disable()
EndIf

oDlg1:refresh()

RestArea(aArea)

Return .T.

/*/{Protheus.doc} salvReg
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
Static Function salvReg()

Local aArea :=  GetArea()
Local nCont :=  0

DbSelectArea("Z32")
For nCont := 1 to len(aList2)
//'Vendas de','Vendas ate','Desconto de','Desconto ate','Valor de','Valor ate','Cond.Pagto.','Comissao','Bonus',''
    Reclock("Z32",.T.)
    Z32->Z32_FILIAL :=  xFilial("Z32")
    Z32->Z32_CODIGO :=  cNumero
    Z32->Z32_ITEM   :=  strzero(nCont,4)
    //Z32->Z32_TIPOCL :=  
    Z32->Z32_PGTPOR :=  cCombo1   
    Z32->Z32_DTINI  :=  dDtDe
    Z32->Z32_DTFIM  :=  dDtAt
    Z32->Z32_DIATOL :=  nToler  
    Z32->Z32_VNDQT1 :=  aList2[nCont,01]
    Z32->Z32_VNDQT2 :=  aList2[nCont,02]
    Z32->Z32_QTDDS1 :=  aList2[nCont,03]
    Z32->Z32_QTDDS2 :=  aList2[nCont,04]
    Z32->Z32_VNDVL1 :=  aList2[nCont,05]  
    Z32->Z32_VNDVL2 :=  aList2[nCont,06]
    Z32->Z32_CONDPG :=  aList2[nCont,07]
    Z32->Z32_COMISS :=  aList2[nCont,08]
    Z32->Z32_BONUS  :=  If(aList2[nCont,09]=="Sim","1","2")
    Z32->Z32_DESCRI :=  cDescr
    Z32->Z32_CLIESP :=  cCliEsp
    Z32->Z32_GRPESP :=  cGrpEsp
    Z32->(MsUnlock())
Next nCont

RestArea(aArea)

Return
