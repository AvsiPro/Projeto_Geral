#INCLUDE 'PROTHEUS.CH'

/*
    Criação de Sinistros e orçamentos
    MIT 44_Sinistros_MULT006_Sinistros_

    DOC MIT
    https://docs.google.com/document/d/1RIx7ugu6S7MOWSZSqYqUzn6PaHrFFeut/edit
    DOC Entrega
    
    
*/

User Function JMULT002(cCodZPF)

Private oDlg1,oGrp1,oSay1,oSay2,oCBox1,oCBox2,oCBox3,oGet1,oGrp2,oSay3,oSay4,oSay5
Private oSay7,oCBox4,oGet2,oGet3,oGet4,oGet5,oGet6,oGrp3,oSay8,oSay9,oSay10,oSay11
Private oGet8,oGet9,oGet10,oGrp4,oBrw1,oGrp6,oBrw2,oBtn1,oBtn2,oSay12,oGet11

Private oList1 
Private oList2 
Private aList1  := {}
Private aList2  := {}
Private aTipos  := {"","1=Pagar","2=Receber"}
Private cTipo   := ''
Private cNumOs  := '000001'
Private lCheck1 := .F.
Private lCheck2 := .F.
Private lCheck3 := .F.
Private nVlr1   := 0
Private nQtd1   := 0
Private nVlr2   := 0
Private nQtd2   := 0
Private lVisual :=  .F.

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

Private dDtN1   := ctod(' / / ')
Private dDtN2   := ctod(' / / ')
Private cCli    := space(TamSX3("A1_COD")[1])
Private cLoj    := space(TamSX3("A1_LOJA")[1])
Private cVerb   := space(TamSX3("RV_COD")[1])
Private cCodRes := space(TamSX3("RA_MAT")[1])


Default cCodZPF := ''

If Empty(cCodZPF)
    cNumOs := GetSXENum("ZPF","ZPF_CODIGO")
    Aadd(aList1,{'','','','',''})
    Aadd(aList2,{'','','','',''})
else
    lVisual := .T.
    BuscarZPF(cCodZPF)
    cNumOS := cCodZPF
EndIf 



oDlg1      := MSDialog():New( 092,232,849,1597,"Sinistros",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,008,064,672,"Sinistro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay1      := TSay():New( 016,032,{||"Responsável"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
        oCBox1     := TCheckBox():New( 016,096,"Empresa",{|u|If(Pcount()>0,lCheck1:=u,lCheck1)},oGrp1,048,008,,{|| trocaChk(1)},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
        oCBox2     := TCheckBox():New( 016,172,"Motorista",{|u|If(Pcount()>0,lCheck2:=u,lCheck2)},oGrp1,048,008,,{|| trocaChk(2)},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
        oCBox3     := TCheckBox():New( 016,248,"Terceiro",{|u|If(Pcount()>0,lCheck3:=u,lCheck3)},oGrp1,048,008,,{|| trocaChk(3)},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
        
        oSay2      := TSay():New( 036,032,{||"Número OS"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1      := TGet():New( 036,096,{|u| If(Pcount()>0,cNumOS:=u,cNumOs)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        oGet1:disable()

    oGrp2      := TGroup():New( 064,008,112,672,"Negociação Financeira",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay3      := TSay():New( 084,032,{||"Tipo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oCBox4     := TComboBox():New( 084,096,{|u|If(Pcount()>0,cTipo:=u,cTipo)},aTipos,056,010,oGrp2,,{||trocaF3(cTipo)},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cTipo )
        
        oSay4      := TSay():New( 084,172,{||"Cli/For"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet2      := TGet():New( 084,212,{|u| If(Pcount()>0,cCli:=u,cCli)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,If(cTipo=="1","SA2","SA1"),"",,)
        oGet3      := TGet():New( 084,280,{|u| If(Pcount()>0,cLoj:=u,cLoj)},oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay5      := TSay():New( 084,328,{||"Valor"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet4      := TGet():New( 084,360,{|u| If(Pcount()>0,nVlr1:=u,nVlr1)},oGrp2,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay6      := TSay():New( 084,436,{||"Qtd Parcelas"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet5      := TGet():New( 084,476,{|u| If(Pcount()>0,nQtd1:=u,nQtd1)},oGrp2,036,008,'@E 999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay7      := TSay():New( 084,532,{||"Data Inicio"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet6      := TGet():New( 084,568,{|u| If(Pcount()>0,dDtN1:=u,dDtN1)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oGrp3      := TGroup():New( 116,008,164,672,"Negociação RH",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay8      := TSay():New( 136,032,{||"Verba"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet7      := TGet():New( 136,096,{|u| If(Pcount()>0,cVerb:=u,cVerb)},oGrp3,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRV","",,)
        
        oSay9      := TSay():New( 136,176,{||"Valor"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet8      := TGet():New( 136,212,{|u| If(Pcount()>0,nVlr2:=u,nVlr2)},oGrp3,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay10     := TSay():New( 136,304,{||"Qtd Parcelas"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet9      := TGet():New( 136,360,{|u| If(Pcount()>0,nQtd2:=u,nQtd2)},oGrp3,044,008,'@E 999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay11     := TSay():New( 136,440,{||"Data Inicio"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet10     := TGet():New( 136,476,{|u| If(Pcount()>0,dDtN2:=u,dDtN2)},oGrp3,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
        oSay12     := TSay():New( 136,540,{||"Motorista"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet11     := TGet():New( 136,576,{|u| If(Pcount()>0,cCodRes:=u,cCodRes)},oGrp3,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SRA","",,)
    
    oGrp4      := TGroup():New( 172,008,344,328,"Orçamento Filial",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{184,016,332,320},,, oGrp4 )
        oList1    := TCBrowse():New(184,016,305,155,, {'Origem','Orçamento','Item','Valor'},;
                                                        {10,50,100,60},;
                                                        oGrp4,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*inverte(1)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{aList1[oList1:nAt,01],;
                            aList1[oList1:nAt,02],; 
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04]}} 
    
    oGrp6      := TGroup():New( 172,352,344,672,"Orçamento Terceiro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{184,360,332,664},,, oGrp6 ) 
        oList2    := TCBrowse():New(184,360,305,155,, {'','Orçamento','Item','Valor'},;
                                                        {10,50,100,60},;
                                                        oGrp6,,,,{|| /*FHelp(oList2:nAt)*/},{|| /*inverte(1)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList2:SetArray(aList2)
        oList2:bLine := {||{aList2[oList2:nAt,01],;
                            aList2[oList2:nAt,02],; 
                            aList2[oList2:nAt,03],;
                            aList2[oList2:nAt,04]}}     
    
    oBtn1      := TButton():New( 352,228,"Confirmar",oDlg1,{|| verifDados()},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 352,396,"Cancelar",oDlg1,{|| oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

    If lVisual
        oCBox1:disable()
        oCBox2:disable()
        oCBox3:disable()
        oCBox4:disable()
        oGet2:disable()
        oGet3:disable()
        oGet4:disable()
        oGet5:disable()
        oGet6:disable()
        oGet7:disable()
        oGet8:disable()
        oGet9:disable()
        oGet10:disable()
        oGet11:disable()
        oBtn1:disable()
    Else 
        MENU oMenuP1 POPUP 
        MENUITEM "Incluir Orçamento" ACTION (Processa({|| inclOrc(1)},"Aguarde"))
        MENUITEM "Incluir itens ao orçamento" ACTION (Processa({|| inclItm(1)},"Aguarde"))
        MENUITEM "Excluir Orçamento" ACTION (Processa({|| exclOrc(1)},"Aguarde"))
        MENUITEM "Excluir item do orçamento" ACTION (Processa({|| exclItm(1)},"Aguarde"))
        ENDMENU                                                                           

        oList1:bRClicked := { |oObject,nX,nY| oMenuP1:Activate( nX, (nY-10), oObject ) }

        MENU oMenuP2 POPUP 
        MENUITEM "Incluir Orçamento" ACTION (Processa({|| inclOrc(2)},"Aguarde"))
        MENUITEM "Incluir itens ao orçamento" ACTION (Processa({|| inclItm(2)},"Aguarde"))
        MENUITEM "Excluir Orçamento" ACTION (Processa({|| exclOrc(2)},"Aguarde"))
        MENUITEM "Excluir item do orçamento" ACTION (Processa({|| exclItm(2)},"Aguarde"))
        ENDMENU                                                                           

        oList2:bRClicked := { |oObject,nX,nY| oMenuP2:Activate( nX, (nY-10), oObject ) }
    EndIf

oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} BuscarZPF(cCodZPF)
    (long_description)
    @type  Static Function
    @author user
    @since 25/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscarZPF(cCodZPF)

Local aArea  := GetArea()
Local cQuery := ""
Local nCont  := 1

cQuery := "SELECT * FROM "+RetSQLName("ZPF")
cQuery += " WHERE ZPF_FILIAL='"+xFilial("ZPF")+"' AND ZPF_CODIGO='"+cCodZPF+"'"
cQuery += " AND D_E_L_E_T_=' '"


IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("BuscarZPF.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    If nCont == 1
        lCheck1 := If(TRB->ZPF_RESPON=='1',.T.,.F.)
        lCheck2 := If(TRB->ZPF_RESPON=='2',.T.,.F.)
        lCheck3 := If(TRB->ZPF_RESPON=='3',.T.,.F.)
        cTipo   := TRB->ZPF_TIPO
        cVerb   := TRB->ZPF_VERBA
        nVlr1   := TRB->ZPF_VALOR1
        nVlr2   := TRB->ZPF_VALOR2
        nQtd1   := TRB->ZPF_PARCE1
        nQtd2   := TRB->ZPF_PARCE2
        dDtN1   := STOD(TRB->ZPF_DTINIC)
        dDtN2   := STOD(TRB->ZPF_DTINDE)
        cCodRes := TRB->ZPF_CODRES
        cCli    := TRB->ZPF_CLIFOR
        cLoj    := TRB->ZPF_LOJA
        nCont++
    EndIf 

    If substr(TRB->ZPF_ITMORC,1,1) == "1"
        Aadd(aList1,{TRB->ZPF_FILORC,TRB->ZPF_ORCAME,TRB->ZPF_DESCIT,TRB->ZPF_VALOR,TRB->ZPF_ITMORC})
    Else 
        Aadd(aList2,{TRB->ZPF_FILORC,TRB->ZPF_ORCAME,TRB->ZPF_DESCIT,TRB->ZPF_VALOR,TRB->ZPF_ITMORC})
    EndIf 

    Dbskip()
EndDo 

If len(aList1) < 1
    Aadd(aList1,{'','','','',''})
EndIf 

If len(aList2) < 1
    Aadd(aList2,{'','','','',''})
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} trocaF3
    (long_description)
    @type  Static Function
    @author user
    @since 25/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function trocaF3(cTipo)

If cTipo == "1" 
    oGet2:cF3 := "SA2"
ElseIf cTipo == "2" 
    oGet2:cF3 := "SA1"
EndIf 

oGet2:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} trocaChk(1)
    (long_description)
    @type  Static Function
    @author user
    @since 25/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function trocaChk(nOpcao)

If nOpcao == 1
    If lCheck1
        lCheck2 := .F.
        lCheck3 := .F.
    EndIf 
ElseIf nOpcao == 2
    If lCheck2 
        lCheck1 := .F.
        lCheck3 := .F.
    EndIf 
ElseIf nOpcao == 3
    If lCheck3
        lCheck1 := .F.
        lCheck2 := .F.
    EndIf 
EndIF 

oCBox1:refresh()
oCBox2:refresh()
oCBox3:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} inclOrc(1)
    (long_description)
    @type  Static Function
    @author user
    @since 25/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function inclOrc(nOpcao)

Local nCont     := 1
Local nOrc      := 1
Local cFilNF    := space(TamSX3("ZPD_FILIAL")[1])
Local aRet      := {}
Local aPergs    := {}

If nOpcao == 1
    
    aAdd(aPergs ,{1,"Filial",cFilNF   ,""  ,""  ,"SM0"	,"", 60,.F.})	// MV_PAR01

    If ParamBox(aPergs ,"Filtrar por",@aRet) 
        cFilNF := aRet[1]
    Else 
        Return
    EndIf 

    If Empty(aList1[oList1:nAt,02])
        aList1 := {}
        Aadd(aList1,{cFilNF,strzero(nOrc,3),'Orçamento '+strzero(nOrc,3),'','1'+strzero(nOrc,3)})
    Else 
        For nCont := 1 to len(aList1)
            If 'Orçamento' $ aList1[nCont,03]
                nOrc++
            EndIf 
        Next nCont  

        Aadd(aList1,{cFilNF,strzero(nOrc,3),'Orçamento '+strzero(nOrc,3),'','1'+strzero(nOrc,3)})
    EndIf
    
    

    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],;
                        aList1[oList1:nAt,02],; 
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04]}} 
else
    If Empty(aList2[oList2:nAt,02])
        aList2 := {}
        Aadd(aList2,{'',strzero(nOrc,3),'Orçamento '+strzero(nOrc,3),'','2'+strzero(nOrc,3)})
    Else 
        For nCont := 1 to len(aList2)
            If 'Orçamento' $ aList2[nCont,03]
                nOrc++
            EndIf 
        Next nCont  

        Aadd(aList2,{'',strzero(nOrc,3),'Orçamento '+strzero(nOrc,3),'','2'+strzero(nOrc,3)})
    EndIf
    
    
    oList2:SetArray(aList2)
    oList2:bLine := {||{aList2[oList2:nAt,01],;
                        aList2[oList2:nAt,02],; 
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04]}}
EndIf 

oList1:refresh()
oList2:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} exclOrc(1)
    (long_description)
    @type  Static Function
    @author user
    @since 25/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function exclOrc(nOpcao)

Local nCont := 1
Local cOrc  := ''

If nOpcao == 1
    
    If Empty(aList1[oList1:nAt,03])
        Return 
    EndIf 
    If Empty(aList1[oList1:nAt,02])
        MsgAlert("Selecione a linha do cabeçalho do orçamento a ser excluído")
        RETURN
    Else 
        cOrc := aList1[oList1:nAt,02]
        If MsgYesNo("Confirma a exclusão do orçamento "+aList1[oList1:nAt,02]+" e de seus itens?")
            While nCont <= len(aList1)
                If substr(aList1[nCont,05],1,3) == Alltrim(cOrc)
                    Adel(aList1,nCont)
                    Asize(aList1,len(aList1)-1)
                    nCont--
                EndIf 
                nCont++
            EndDo
            
            If len(aList1) < 1
                Aadd(aList1,{'','','','',''})
            EndIf 

            oList1:SetArray(aList1)
            oList1:bLine := {||{aList1[oList1:nAt,01],;
                                aList1[oList1:nAt,02],; 
                                aList1[oList1:nAt,03],;
                                aList1[oList1:nAt,04]}} 
        Else 
            Return
        Endif 
    Endif 
Else 
    If Empty(aList2[oList2:nAt,03])
        Return 
    EndIf 
    If Empty(aList2[oList2:nAt,02])
        MsgAlert("Selecione a linha do cabeçalho do orçamento a ser excluído")
        RETURN
    Else 
        cOrc := aList2[oList2:nAt,02]
        If MsgYesNo("Confirma a exclusão do orçamento "+aList2[oList2:nAt,02]+" e de seus itens?")
            While nCont <= len(aList2)
                If substr(aList2[nCont,05],1,3) == Alltrim(cOrc)
                    Adel(aList2,nCont)
                    Asize(aList2,len(aList2)-1)
                    nCont--
                EndIf 
                nCont++
            EndDo
            
            If len(aList2) < 1
                Aadd(aList2,{'','','','',''})
            EndIf 

            oList2:SetArray(aList2)
            oList2:bLine := {||{aList2[oList2:nAt,01],;
                                aList2[oList2:nAt,02],; 
                                aList2[oList2:nAt,03],;
                                aList2[oList2:nAt,04]}} 
        Else 
            Return
        Endif 
    Endif 
EndIf 

oList1:refresh()
oList2:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} inclItm(1)
    (long_description)
    @type  Static Function
    @author user
    @since 25/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function inclItm(nOpcao)

Local aRet      := {}
Local aPergs    := {}
Local nVlrItm   := 0
Local cItem     := space(20)

If nOpcao == 1
    If Empty(aList1[oList1:nAt,03])
        Return 
    EndIf 

    If Empty(aList1[oList1:nAt,02])
        MsgAlert('Selecione a linha do orçamento que será incluído o item')
        Return
    EndIf  
Else 
    If Empty(aList2[oList2:nAt,03])
        Return 
    EndIf 
    
    If Empty(aList2[oList2:nAt,02])
        MsgAlert('Selecione a linha do orçamento que será incluído o item')
        Return
    EndIf 
EndIf 

aAdd(aPergs ,{1,"Item:"	,cItem    ,"@!",".T.","",".T.",70,.F.})
aAdd(aPergs ,{1,"Valor:",nVlrItm  ,"@E 999,999.99",".T.","",".T.",70,.F.})


If ParamBox(aPergs ,"Filtrar por",@aRet) 
    cItem   := aRet[1]
    nVlrItm := aRet[2]

    If nOpcao == 1
        Aadd(aList1,{'','',cItem,nVlrItm,aList1[oList1:nAt,05]})
        aList1[len(aList1),05] += '1'+cvaltochar(len(aList1))
        Asort(aList1,,,{|x,y| x[5] < y[5]})
    Else 
        Aadd(aList2,{'','',cItem,nVlrItm,aList2[oList2:nAt,05]})
        aList2[len(aList2),05] += '2'+cvaltochar(len(aList2))
        Asort(aList2,,,{|x,y| x[5] < y[5]})
    EndIf 

    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],;
                        aList1[oList1:nAt,02],; 
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04]}}
    
    oList2:SetArray(aList2)
    oList2:bLine := {||{aList2[oList2:nAt,01],;
                        aList2[oList2:nAt,02],; 
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04]}}
    
    oList1:refresh()
    oList2:refresh()
    oDlg1:refresh()
EndIf 

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 25/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function exclItm(nOpcao)

If nOpcao == 1
    If Empty(aList1[oList1:nAt,03])
        Return 
    EndIf 
    If !Empty(aList1[oList1:nAt,02])
        MsgAlert("Selecione a linha do item do orçamento a ser excluído")
        RETURN
    Else 
        Adel(aList1,oList1:nAt)
        Asize(aList1,len(aList1)-1)
    EndIf 

    If len(aList1) < 1
        Aadd(aList1,{'','','','',''})
    EndIf 

    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],;
                        aList1[oList1:nAt,02],; 
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04]}}
Else 
    If Empty(aList2[oList2:nAt,03])
        Return 
    EndIf 
    If !Empty(aList2[oList2:nAt,02])
        MsgAlert("Selecione a linha do item do orçamento a ser excluído")
        RETURN
    Else 
        Adel(aList2,oList2:nAt)
        Asize(aList2,len(aList2)-1)
    EndIf 

    If len(aList2) < 1
        Aadd(aList2,{'','','','',''})
    EndIf 

    oList2:SetArray(aList2)
    oList2:bLine := {||{aList2[oList2:nAt,01],;
                        aList2[oList2:nAt,02],; 
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04]}}
Endif 

oList1:refresh()
oList2:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 25/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function verifDados()

Local nCont     :=  1
Local lOk       :=  .T.
Local lOrcamI   :=  .F.
Local lOrcamE   :=  .F.
Local nItem     :=  1
Local cCodZPD   :=  ''

If !lCheck1 .And. !lCheck2 .And. !lCheck3
    MsgAlert("Não foi informado o responsável pelo Sinistro")
    lOk   := .F.
    Return
Endif 

If Empty(cTipo)
    MsgAlert("Não foi informado o tipo de titulo a ser gerado para o Sinistro (Pagar ou Receber)")
    lOk   := .F.
    Return 
Else 
    If Empty(cCli) .Or. Empty(cLoj)
        MsgAlert('Não foi informado o '+If(cTipo=='1','cliente','fornecedor')+' a ser gerado o titulo')
        lOk   := .F.
        Return
    EndIf  
EndIf 

If nVlr1 == 0
    MsgAlert('Não foi informado o valor de negociação com o '+If(cTipo=='1','cliente','fornecedor'))
    lOk   := .F.
    Return
EndIf 

If nQtd1 == 0
    MsgAlert('Não foi informado a quantidade de parcelas negociadas')
    lOk   := .F.
    Return
EndIf 

If Empty(dDtN1)
    MsgAlert('Não foi informada a data de inicio do pagamento')
    lOk   := .F.
    Return
EndIf 

For nCont := 1 to len(aList1)
    If Empty(aList1[nCont,02]) .And. !Empty(aList1[nCont,03])
        lOrcamI := .T.
    EndIf 
Next nCont 

For nCont := 1 to len(aList2)
     If Empty(aList2[nCont,02]) .And. !Empty(aList2[nCont,03])
        lOrcamE := .T.
    EndIf 
Next nCont 

If !lOrcamI
    If !MsgYesNo("Não foi informado um orçamento interno, Confirma?")
        lOk := .F.
        RETURN
    EndIf 
EndIf 

If !lOrcamE
    If !MsgYesNo("Não foi informado um orçamento externo, Confirma?")
        lOk := .F.
        RETURN
    EndIf 
EndIf

If Empty(cCodRes)
    MsgAlert("Não foi informado o motorista do Sinistro")
    lOk := .F.
    Return 
EndIf 

If lOk
    DbSelectArea("ZPF")
    Confirmsx8()

    cCodZPD := GetSXENum("ZPD","ZPD_CODIGO")

    For nCont := 1 to len(aList1)
        If !Empty(aList1[nCont,03])
            Reclock("ZPF",.T.)
            ZPF->ZPF_FILIAL := xFilial("ZPF")
            ZPF->ZPF_CODIGO := cNumOs
            ZPF->ZPF_RESPON := If(lCheck1,'1',If(lCheck2,'2','3'))
            ZPF->ZPF_TIPO   := cTipo 
            ZPF->ZPF_ITEM   := Strzero(nItem,4)
            ZPF->ZPF_VERBA  := cVerb 
            ZPF->ZPF_VALOR1 := nVlr1
            ZPF->ZPF_PARCE1 := nQtd1
            ZPF->ZPF_DTINIC := dDtN1
            ZPF->ZPF_CLIFOR := cCli
            ZPF->ZPF_LOJA   := cLoj 
            ZPF->ZPF_VALOR2 := nVlr2
            ZPF->ZPF_PARCE2 := nQtd2
            ZPF->ZPF_DTINDE := dDtN2
            ZPF->ZPF_FILORC := aList1[nCont,01]
            ZPF->ZPF_ORCAME := aList1[nCont,02]
            ZPF->ZPF_DESCIT := aList1[nCont,03]
            ZPF->ZPF_VALOR  := If(valtype(aList1[nCont,04])<>'N',0,aList1[nCont,04])
            ZPF->ZPF_ITMORC := aList1[nCont,05]
            ZPF->ZPF_CODRES := cCodRes
            ZPF->ZPF_CODNEG := cCodZPD
            nItem++
            ZPF->(Msunlock())
        EndIf 
    Next nCont

    For nCont := 1 to len(aList2)
        If !Empty(aList2[nCont,03])
            Reclock("ZPF",.T.)
            ZPF->ZPF_FILIAL := xFilial("ZPF")
            ZPF->ZPF_CODIGO := cNumOs
            ZPF->ZPF_RESPON := If(lCheck1,'1',If(lCheck2,'2','3'))
            ZPF->ZPF_TIPO   := cTipo 
            ZPF->ZPF_ITEM   := Strzero(nItem,4)
            ZPF->ZPF_VERBA  := cVerb 
            ZPF->ZPF_VALOR1 := nVlr1
            ZPF->ZPF_PARCE1 := nQtd1
            ZPF->ZPF_DTINIC := dDtN1
            ZPF->ZPF_CLIFOR := cCli
            ZPF->ZPF_LOJA   := cLoj 
            ZPF->ZPF_VALOR2 := nVlr2
            ZPF->ZPF_PARCE2 := nQtd2
            ZPF->ZPF_DTINDE := dDtN2
            ZPF->ZPF_FILORC := aList2[nCont,01]
            ZPF->ZPF_ORCAME := aList2[nCont,02]
            ZPF->ZPF_DESCIT := aList2[nCont,03]
            ZPF->ZPF_VALOR  := If(valtype(aList2[nCont,04])<>'N',0,aList2[nCont,04])
            ZPF->ZPF_ITMORC := aList2[nCont,05]
            ZPF->ZPF_CODRES := cCodRes
            ZPF->ZPF_CODNEG := cCodZPD
            nItem++
            ZPF->(Msunlock())
        EndIf 
    Next nCont

    cVinculo := If(val(cTipo)==1,'2','3')

    Confirmsx8()
    DbSelectArea("ZPD")
    Reclock("ZPD",.T.)

    ZPD->ZPD_FILIAL := xFilial("ZPD")
    ZPD->ZPD_CODIGO := cCodZPD
    ZPD->ZPD_TIPO   := 'S'
    ZPD->ZPD_VINCUL := cVinculo
    ZPD->ZPD_MULTA  := nVlr1
    ZPD->ZPD_VERBA  := cVerb
    ZPD->ZPD_VALOR  := If(nVlr2==0,nVlr1,nVlr2)
    ZPD->ZPD_PARCEL := If(nQtd2==0,nQtd1,nQtd2)
    ZPD->ZPD_DTINIC := If(Empty(dDtN2),dDtN1,dDtN2)
    ZPD->ZPD_RESPON := cCodRes
    ZPD->ZPD_STATUS := '1'
    ZPD->ZPD_TABELA := If(cVinculo=='1','SRC',If(cVinculo=='2','SE2','SE1'))
    ZPD->ZPD_SOLICI := cusername
    ZPD->ZPD_DTSOLI := ddatabase
    ZPD->ZPD_HORASO := cvaltochar(time())
    ZPD->ZPD_CODZPF := cNumOs
    ZPD->(Msunlock())  

    oDlg1:end()
EndIf 

Return
