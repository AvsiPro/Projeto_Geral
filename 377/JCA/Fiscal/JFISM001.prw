#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JFISM001 ³ Autor ³ Alexandre Venancio  ³ Data ³ 01/03/2024 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Rotina de cadastro de amarração de TES para integraçao
    Tracker                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function JFISM001

Local nOpcao     := 0
Local nCont 

Private aGrupos  := {}
Private nGrupo   := 0
Private aEstados := {}
Private nEstado  := 0
Private nEstado2 := 0
Private cOperInt := space(2)
Private cOperLoc := space(2)
Private cCSTInt  := space(2)
Private cCSTLoc  := space(2)
Private cCFOPIn  := space(4)
Private cCFOPLo  := space(4)
Private cTESInt  := space(3)
Private cTESLoc  := space(3)
Private aList1   := {}
Private aList2   := {}
Private oList1
Private oList2
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')


SetPrvt("oDlg1","oSay9","oGrp1","oSay1","oSay2","oSay3","oGet1","oCBox1","oCBox2","oBtn3","oGrp2","oSay4")
SetPrvt("oSay6","oSay7","oBrw1","oGet2","oGet3","oGet4","oGet5","oBtn1","oGrp3","oSay8","oSay10","oSay11")
SetPrvt("oBrw2","oGet6","oGet7","oGet8","oGet9","oBtn2","oBtn4","oBtn5","oBtn6")

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00080264")
    //RPCSetEnv("T1","D MG 01")
EndIf

aSm0 := FWLoadSM0()
//DEIXAR SOMENTE A EMPRESA GRUPO 0008  - SOLICITADO TANIA 03/04/24
/*For nCont := 1 to len(aSm0)
    If Ascan(aGrupos,{|x| x == aSM0[nCont,03]+'-'+aSm0[nCont,17]}) == 0 
        Aadd(aGrupos,aSM0[nCont,03]+'-'+aSm0[nCont,17])
    EndIf 
Next nCont*/
nPosE8 := Ascan(aSM0,{|x| x[3] == '0008'})
If nPosE8 > 0
    Aadd(aGrupos,aSM0[nPosE8,03]+'-'+aSm0[nPosE8,17])
EndIf 

DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial("SX5")+"12")

While !EOF() .And. SX5->X5_TABELA == '12'
    Aadd(aEstados,Alltrim(SX5->X5_CHAVE))
    Dbskip()
EndDo 

Aadd(aEstados,'Todos')
Aadd(aEstados,'Todos Exceto Est.Filial')

nEstado := len(aEstados)-1
nEstado2 := len(aEstados)-1

Aadd(aList1,{.F.,'','','','','','','',0})
Aadd(aList2,{.F.,'','','','','','','',0})

oDlg1      := MSDialog():New( 092,232,834,1648,"Cadastro TES CTe",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 008,208,092,388,"Empresa / Filiais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay1      := TSay():New( 020,220,{||"Empresa"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    //oGet1      := TGet():New( 020,288,{|u| If(Pcount()>0,cGrupo:=u,cGrupo) },oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oCBox1     := TComboBox():New( 020,268,{|u| If(Pcount()>0,nGrupo:=u,nGrupo)},aGrupos,110,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

    oSay2      := TSay():New( 040,220,{||"Estado Filial"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oCBox2     := TComboBox():New( 040,268,{|u| If(Pcount()>0,nEstado:=u,nEstado)},aEstados,090,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

    oSay3      := TSay():New( 060,220,{||"Estado Tomador"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
    oCBox3     := TComboBox():New( 060,268,{|u| If(Pcount()>0,nEstado2:=u,nEstado2)},aEstados,090,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

    oBtn3      := TButton():New( 076,280,"Pesquisar",oGrp1,{|| Busca(nGrupo,nEstado,nEstado2)},037,012,,,,.T.,,"",,,,.F. )

oGrp2      := TGroup():New( 096,004,332,336,"Operação Interestadual",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay4      := TSay():New( 108,008,{||"Operação"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
    oGet2      := TGet():New( 108,040,{|u| If(Pcount()>0,cOperInt:=u,cOperInt)},oGrp2,024,008,'',{||vldcpo('DJ',cOperInt)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DJ","",,)

    oSay5      := TSay():New( 108,076,{||"CST"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
    oGet3      := TGet():New( 108,096,{|u| If(Pcount()>0,cCSTInt:=u,cCSTInt)},oGrp2,024,008,'',{||vldcpo('S2',cCSTInt)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"S2","",,)

    oSay6      := TSay():New( 108,132,{||"CFOP"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
    oGet4      := TGet():New( 108,152,{|u| If(Pcount()>0,cCFOPIn:=u,cCFOPIn)},oGrp2,036,008,'',{||vldcpo('13',cCFOPIn)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"13","",,)

    oSay7      := TSay():New( 108,196,{||"TES"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
    oGet5      := TGet():New( 108,212,{|u| If(Pcount()>0,cTESInt:=u,cTESInt)},oGrp2,028,008,'',{||vldcpo('SF4',cTESInt)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","",,)

    oBtn1      := TButton():New( 107,252,"Incluir",oGrp2,{|| AdicInt(1)},033,012,,,,.T.,,"",,,,.F. )
    oBtn1:disable()

    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,008,324,292},,, oGrp2 ) 
    oList1    := TCBrowse():New(124,008,320,200,, {'','Operação','CST','CFOP','Descricao','TES','Finalidade'},;
                                        {10,25,25,30,30,30,70},;
                                        oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| editped(oList1:nAt,1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{if(aList1[oList1:nAt,01],oOk,oNo),; 
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],;
                        aList1[oList1:nAt,05],;
                        aList1[oList1:nAt,06],;
                        aList1[oList1:nAt,07]}}
    
oGrp3      := TGroup():New( 096,364,332,696,"Operação Intermunicipal",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay8      := TSay():New( 108,372,{||"Operação"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
    oGet6      := TGet():New( 108,400,{|u| If(Pcount()>0,cOperLoc:=u,cOperLoc)},oGrp3,024,008,'',{||vldcpo('DJ',cOperLoc)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DJ","",,)
    
    oSay10     := TSay():New( 108,432,{||"CST"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
    oGet7      := TGet():New( 108,452,{|u| If(Pcount()>0,cCSTLoc:=u,cCSTLoc)},oGrp3,024,008,'',{||vldcpo('S2',cCSTLoc)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"S2","",,)
    
    oSay11     := TSay():New( 108,484,{||"CFOP"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
    oGet8      := TGet():New( 108,504,{|u| If(Pcount()>0,cCFOPLo:=u,cCFOPLo)},oGrp3,036,008,'',{||vldcpo('13',cCFOPLo)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"13","",,)
    
    oSay12     := TSay():New( 108,548,{||"TES"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
    oGet9      := TGet():New( 108,564,{|u| If(Pcount()>0,cTESLoc:=u,cTESLoc)},oGrp3,028,008,'',{||vldcpo('SF4',cTESLoc)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","",,)
    
    //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,308,324,592},,, oGrp3 ) 
    
    oList2    := TCBrowse():New(124,368,320,200,, {'','Operação','CST','CFOP','Descricao','TES','Finalidade'},;
                                        {10,25,25,30,30,30,70},;
                                        oGrp2,,,,{|| /*FHelp(oList1:nAt)*/},{|| editped(oList2:nAt,2)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04],;
                        aList2[oList2:nAt,05],;
                        aList2[oList2:nAt,06],;
                        aList2[oList2:nAt,07]}}

    oBtn2      := TButton():New( 106,612,"Incluir",oGrp3,{|| AdicInt(2)},033,012,,,,.T.,,"",,,,.F. )
    oBtn2:disable()

    oBtn4      := TButton():New( 335,220,"Salvar",oDlg1,{|| oDlg1:end(nOpcao := 1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn5      := TButton():New( 335,440,"Sair",oDlg1,{|| oDlg1:end(nOpcao := 0)},037,012,,,,.T.,,"",,,,.F. )

    oBtn6      := TButton():New( 335,330,"Reprocessar",oDlg1,{|| Processa({|| Represa()},"Aguarde")},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)


If nOpcao == 1
    cCodigo := ''
    cEstFil := ''
    cEstTom := ''

    If !Empty(nGrupo)
        cCodigo := substr(nGrupo,1,4)
    EndIf 

    If valtype(nEstado) == "N"
        cEstFil := aEstados[nEstado]
    Else 
        cEstFil := If(nEstado=='Todos','*',nEstado)
    EndIf 

    If valtype(nEstado2) == "N"
        cEstTom := aEstados[nEstado2]
    Else 
        cEstTom := If(nEstado2=='Todos','*',nEstado2)
    EndIf 

    
    If !Empty(cCodigo) .And. !Empty(cEstFil) .And. !Empty(cEstTom)
        For nCont := 1 to len(aList1)
            If aList1[nCont,01]
                DbSelectArea("ZPG")
                If aList1[nCont,09] == 0
                    Reclock("ZPG",.T.)
                else
                    DbGoto(aList1[nCont,09])
                    Reclock("ZPG",.F.)
                EndIf 

                ZPG->ZPG_CODIGO := cCodigo
                ZPG->ZPG_ESTFIL := If(upper(cEstFil)=="TODOS",'*',cEstFil)
                ZPG->ZPG_ESTTOM := If(upper(cEstTom)=="TODOS",'*',cEstTom)
                ZPG->ZPG_OPERAC := aList1[nCont,02]
                ZPG->ZPG_CSTOPE := aList1[nCont,03]
                ZPG->ZPG_CFOP   := aList1[nCont,04]
                ZPG->ZPG_TES    := aList1[nCont,06]
                ZPG->ZPG_TIPOOP := aList1[nCont,08]

                ZPG->(Msunlock())
            Else 
                If aList1[nCont,09] > 0
                    Dbgoto(aList1[nCont,09])
                    Reclock("ZPG",.F.)
                    Dbdelete()
                    ZPG->(Msunlock())
                EndIf 
            EndIf 
        Next nCont

        For nCont := 1 to len(aList2)
            If aList2[nCont,01]
                DbSelectArea("ZPG")
                If aList2[nCont,09]  == 0
                    Reclock("ZPG",.T.)
                else
                    Dbgoto(aList2[nCont,09])
                    Reclock("ZPG",.F.)
                EndIf

                ZPG->ZPG_CODIGO := cCodigo
                ZPG->ZPG_ESTFIL := If(upper(cEstFil)=="TODOS",'*',cEstFil)
                ZPG->ZPG_ESTTOM := If(upper(cEstTom)=="TODOS",'*',cEstTom)
                ZPG->ZPG_OPERAC := aList2[nCont,02]
                ZPG->ZPG_CSTOPE := aList2[nCont,03]
                ZPG->ZPG_CFOP   := aList2[nCont,04]
                ZPG->ZPG_TES    := aList2[nCont,06]
                ZPG->ZPG_TIPOOP := aList2[nCont,08]

                ZPG->(Msunlock())
            Else 
                If aList2[nCont,09] > 0
                    Dbgoto(aList2[nCont,09])
                    Reclock("ZPG",.F.)
                    Dbdelete()
                    ZPG->(Msunlock())
                EndIf 
            EndIf 
        Next nCont
    EndIf 

    MsgAlert("Processo finalizado!!!")
EndIf 

Return

/*/{Protheus.doc} Busca(nGrupo,nEstado,nEstado2)
    @type  Static Function
    @author user
    @since 23/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(nGrupo,nEstado,nEstado2)

Local aArea   := GetArea()
Local cQuery 
Local cGrupo  := ''
Local cEstFil := ''
Local cEstTom := ''

aList1 := {}
aList2 := {}

If Empty(nGrupo)
    MsgAlert("Grupo de empresas não preenchido")
Else 
    cGrupo = substr(nGrupo,1,4)
EndIf 

If valtype(nEstado) == "N"
    cEstFil := aEstados[nEstado]
else
    cEstFil := nEstado
EndIf

If valtype(nEstado2) == "N"
    cEstTom := aEstados[nEstado2]
else
    cEstTom := nEstado2
EndIf

cQuery := "SELECT ZPG_OPERAC,ZPG_CSTOPE,ZPG_CFOP,ZPG_TES,ZPG_TIPOOP,ZPG.R_E_C_N_O_ AS RECZPG"
cQuery += " FROM "+RetSQLName("ZPG")+" ZPG"
cQuery += " WHERE ZPG_FILIAL='"+xFilial("ZPG")+"' AND ZPG_CODIGO='"+cGrupo+"' AND D_E_L_E_T_=' '"
cQuery += " AND ZPG_ESTFIL = '"+If(cEstFil=="Todos","*",cEstFil)+"'"
cQuery += " AND ZPG_ESTTOM = '"+If(cEstTom=="Todos","*",cEstTom)+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFISM001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
    cFinalid := alltrim(Posicione("SF4",1,xFilial("SF4")+ZPG_TES,"F4_FINALID"))
    cDescCF  := alltrim(Posicione("SX5",1,xFilial("SX5")+'13'+TRB->ZPG_CFOP,"X5_DESCRI"))

    If TRB->ZPG_TIPOOP == '1'
        Aadd(aList1,{.T.,;
                     TRB->ZPG_OPERAC,;
                     TRB->ZPG_CSTOPE,;
                     TRB->ZPG_CFOP,;
                     cDescCF,;
                     TRB->ZPG_TES,;
                     cFinalid,;
                     TRB->ZPG_TIPOOP,;
                     TRB->RECZPG})
    Else 
        Aadd(aList2,{.T.,;
                     TRB->ZPG_OPERAC,;
                     TRB->ZPG_CSTOPE,;
                     TRB->ZPG_CFOP,;
                     cDescCF,;
                     TRB->ZPG_TES,;
                     cFinalid,;
                     TRB->ZPG_TIPOOP,;
                     TRB->RECZPG})
    EndIF 
    Dbskip()
EndDo 

If len(aList1) < 1
    Aadd(aList1,{.F.,'','','','','','','',0})
EndIf 

If len(aList2) < 1
    Aadd(aList2,{.F.,'','','','','','','',0})
EndIf 

oList1:SetArray(aList1)
oList1:bLine := {||{if(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],;
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06],;
                    aList1[oList1:nAt,07]}}

oList2:SetArray(aList2)
oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
                    aList2[oList2:nAt,02],;
                    aList2[oList2:nAt,03],;
                    aList2[oList2:nAt,04],;
                    aList2[oList2:nAt,05],;
                    aList2[oList2:nAt,06],;
                    aList2[oList2:nAt,07]}}

oBtn1:enable()
oBtn2:enable()

RestArea(aArea)

Return
/*/{Protheus.doc} vldcpo('S2',cCSTLoc)
    (long_description)
    @type  Static Function
    @author user
    @since 23/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function vldcpo(cTabela,cConteudo)

Local aArea := GetArea()
Local lRet  := .T.

If !Empty(cConteudo)
    If cTabela == "SF4"
        DbselectArea("SF4")
        DbSetOrder(1)
        If !Dbseek(xFilial("SF4")+cConteudo)
            lRet := .F.
        EndIf 
    Else 
        DbSelectArea("SX5")
        DbSetOrder(1)
        If !Dbseek(xFilial("SX5")+cTabela+cConteudo)
            lRet := .F.
        EndIf 
    EndIf 
EndIf 

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} AdicInt

    @type  Static Function
    @author user
    @since 23/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AdicInt(nOpc)

Local aArea := GetArea()
Local lRet  := .T.
Local nPosS := 0

If cvaltochar(nGrupo) == '0'
    MsgAlert("Não foi informado o grupo de empresas")
    Return(.f.)
EndIf

If nOpc == 1
    If Empty(cOperInt)
        lRet := .F.
    EndIf 

    If Empty(cCstInt)
        lRet := .F.
    EndIf 

    If Empty(cCFOPIn)
        lRet := .F.
    EndIf 

    If Empty(cTESInt)
        lRet := .F.
    EndIf 
    nPosS := Ascan(aList1,{|x| x[2]+x[3]+x[4] == cOperInt+cCstInt+cCFOPIn})
    If nPosS > 0
        lRet := .F.
        MsgAlert("Combinação já cadastrada")
    EndIf 
Else 
    If Empty(cOperLoc)
        lRet := .F.
    EndIf 

    If Empty(cCSTLoc)
        lRet := .F.
    EndIf 

    If Empty(cCFOPLo)
        lRet := .F.
    EndIf 

    If Empty(cTESLoc)
        lRet := .F.
    EndIf 

    nPosS := Ascan(aList2,{|x| Alltrim(x[2]+x[3]+x[4]) == alltrim(cOperLoc+cCSTLoc+cCFOPLo)})
    If nPosS > 0
        lRet := .F.
        MsgAlert("Combinação já cadastrada")
    EndIf 
EndIf 

If lRet 
    If nOpc == 1
        
        If Empty(aList1[1,2])
            aList1 := {}
        EndIf 

        cFinalid := Posicione("SF4",1,xFilial("SF4")+cTESInt,"F4_FINALID")
        cDescCF  := Posicione("SX5",1,xFilial("SX5")+'13'+cCFOPIn,"X5_DESCRI")

        Aadd(aList1,{.T.,cOperInt,cCstInt,cCFOPIn,cDescCF,cTESInt,cFinalid,'1',0})
        cOperInt := space(2)
        cCstInt  := spacE(2)
        cCFOPIn  := space(4)
        cTESInt  := space(3)
    Else 
        
        If Empty(aList2[1,2])
            aList2 := {}
        EndIf 
        
        cFinalid := Posicione("SF4",1,xFilial("SF4")+cTESLoc,"F4_FINALID")
        cDescCF  := Posicione("SX5",1,xFilial("SX5")+'13'+cCFOPLo,"X5_DESCRI")

        Aadd(aList2,{.T.,cOperLoc,cCSTLoc,cCFOPLo,cDescCF,cTESLoc,cFinalid,'2',0})
        cOperLoc := space(2)
        cCSTLoc  := space(2)
        cCFOPLo  := space(4)
        cTESLoc  := space(3)
    EndIf 

    oList1:SetArray(aList1)
    oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),; 
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],;
                        aList1[oList1:nAt,05],;
                        aList1[oList1:nAt,06],;
                        aList1[oList1:nAt,07]}}

    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04],;
                        aList2[oList2:nAt,05],;
                        aList2[oList2:nAt,06],;
                        aList2[oList2:nAt,07]}}

    oList1:refresh()
    oList2:refresh()
    oDlg1:refresh()
EndIf 

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} editped
    (long_description)
    @type  Static Function
    @author user
    @since 25/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editped(nLinha,nOpc)


If nOpc == 1
    If aList1[nLinha,01]
        aList1[nLinha,01] := .F.
    Else 
        aList1[nLinha,01] := .T.
    EndIf 
Else 
    If aList2[nLinha,01]
        aList2[nLinha,01] := .F.
    Else 
        aList2[nLinha,01] := .T.
    EndIf 
EndIf 

oList1:refresh()
oList2:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} Represa
    Itens represados na tabela transitoria
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
Static Function Represa()

Local aArea  := GetArea()
Local nOpcao := 0
Local nCont 
Local aPars  := {}
Local lRet   := .f.

Private oDlgR,oGrpR1,oBtnR1,oGrpR2,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay23
Private oSay9,oSay10,oSay11,oSay12,oSay13,oSay14,oSay15,oSay16,oSay17,oSay18,oSay19
Private oLisR1

Private aListR1 := {}

aPars := Prmrepr()


If Len(aPars) > 0
    BuscaZph(aPars)
Endif 

If len(aListR1) > 0
    
//Aadd(aListR1,{.F.,'','','','','','',0})
    If aPars[1] == '1'
        oDlgR      := MSDialog():New( 215,516,684,1418,"Itens Integrados",,,.F.,,,,,,.T.,,,.T. )
    Else 
    oDlgR      := MSDialog():New( 215,516,684,1418,"Itens Represados",,,.F.,,,,,,.T.,,,.T. )
    Endif
        oGrpR1     := TGroup():New( 004,004,144,440,"Itens",oDlgR,CLR_BLACK,CLR_WHITE,.T.,.F. )
            //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,140,436},,, oGrpR1 ) 
            oLisR1    := TCBrowse():New(012,008,425,130,, {'','Filial','Documento','Serie','Cliente','Razão Social','Chave CT-e', 'Log de Erro'},;
                                                        {10,25,25,30,30,30,70,100},;
                                                        oGrpR1,,,,{|| FHelp(oLisR1:nAt)},{|| chvcte(oLisR1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
            oLisR1:SetArray(aListR1)
            //oLisR1:bLine := {||{if(aListR1[oLisR1:nAt,01],oOk,oNo),; 
            oLisR1:bLine := {||{if(aPars[1] == '1',oOk,oNo),; 
                                    aListR1[oLisR1:nAt,02],;
                                    aListR1[oLisR1:nAt,03],;
                                    aListR1[oLisR1:nAt,04],;
                                    aListR1[oLisR1:nAt,05],;
                                    aListR1[oLisR1:nAt,06],;
                                    aListR1[oLisR1:nAt,21],;
                                    aListR1[oLisR1:nAt,22]}}

        oGrpR2     := TGroup():New( 148,004,204,440,"Combinação",oDlgR,CLR_BLACK,CLR_WHITE,.T.,.F. )

        oSay1      := TSay():New( 160,012,{||"Filial"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay2      := TSay():New( 160,052,{||"00020087"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
        
        oSay3      := TSay():New( 160,096,{||"Estado Filial"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay4      := TSay():New( 160,140,{||"MG"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,016,008)
        
        oSay5      := TSay():New( 160,172,{||"CFOP"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
        oSay6      := TSay():New( 160,204,{||"5405"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,020,008)
        
        oSay7      := TSay():New( 160,236,{||"Estado Inicial"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
        oSay8      := TSay():New( 160,276,{||"MG"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,016,008)
        
        oSay9      := TSay():New( 160,304,{||"Estado Final"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay10     := TSay():New( 160,348,{||"SP"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,016,008)
        
        oSay11     := TSay():New( 176,012,{||"Municipio Inicio"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
        oSay12     := TSay():New( 176,052,{||"35805"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
        
        oSay13     := TSay():New( 176,096,{||"Municipio Final"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
        oSay14     := TSay():New( 176,140,{||"54547"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,024,008)
        
        oSay15     := TSay():New( 176,172,{||"CST"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
        oSay16     := TSay():New( 176,204,{||"00"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,012,008)
        
        oSay17     := TSay():New( 176,236,{||"Estado Tomador"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
        oSay18     := TSay():New( 176,284,{||"RS"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,012,008)
        
        oSay19     := TSay():New( 176,304,{||"Valor R$"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay20     := TSay():New( 176,348,{||"125.505,22"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)

        oSay21     := TSay():New( 189,132,{||"TES"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay22     := TSay():New( 189,208,{||"501"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)

        oSay23     := TSay():New( 195,200,{||""},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,132,008)

        oLg1 := TBitmap():Create(oDlgR,205,10,10,10,"BR_VERMELHO"			,,.T., {|| },,.F.,.F.,,,.F.,,.T.,,.F.)			// programadas
       // oLg1 := TBitmap():Create(oDlgR,205,10,10,10,"BR_VERDE"			,,.T., {|| },,.F.,.F.,,,.F.,,.T.,,.F.)			// programadas
        oLg2 := TBitmap():Create(oDlgR,215,10,10,10,"BR_VERDE"			,,.T., {|| },,.F.,.F.,,,.F.,,.T.,,.F.)			// programadas
        //oLg2 := TBitmap():Create(oDlgR,215,10,10,10,"BR_VERMELHO"			,,.T., {|| },,.F.,.F.,,,.F.,,.T.,,.F.)			// programadas
	    oSay24     := TSay():New( 205,020,{||"Habilitado para reprocessar"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,132,008)
        oSay25     := TSay():New( 215,020,{||"Não habilitado para reprocessar"},oGrpR2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,132,008)

        oBtnR1     := TButton():New( 208,120,"Reprocessar",oDlgR,{|| If(MsgYesNo("Confirma o reprocessamento?"),oDlgR:end(nOpcao:=1),)},037,012,,,,.T.,,"",,,,.F. )
        oBtnR2     := TButton():New( 208,240,"Sair",oDlgR,{|| oDlgR:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )
        

    oDlgR:Activate(,,,.T.)

    If nOpcao == 1
        For nCont := 1 to len(aListR1)
            If !aListR1[nCont,01]
                CFILANT := aListR1[nCont,02]
                lRet := U_xvldws13(1,aListR1[nCont,07],2,aListR1[nCont,08])

                If lRet 
                    DbSelectArea("ZPH")
                    DbGoto(aListR1[nCont,08])
                    Reclock("ZPH",.F.)
                    ZPH->ZPH_STATUS := '1'
                    ZPH->(Msunlock())
                EndIf 
            EndIf 
        Next nCont
        
        If lRet
            MsgAlert("itens represados")
        Else
             MsgAlert("nf não integrada")
        Endif
    EndIF 
Else 
    MsgAlert("Não há itens represados")
EndIF 

RestArea(aArea)

Return

/*/{Protheus.doc} BuscaZph
    Busca itens represados na ZPH
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
Static Function BuscaZph(aPars)

Local aArea := GetArea()
Local cQuery 
Local nCont 
Local aListR12 := {}
Local lLegenda := .F.
Private aRet := {}
Default aPars := {}

cQuery := "SELECT ZPH_FILIAL,ZPH_DOC,ZPH_SERIE,ZPH_FORNEC,ZPH_LOJA,A1_NOME,ZPH.R_E_C_N_O_ AS RECZPH,"
cQuery += " ISNULL(CAST(CAST(ZPH_XML AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS ZPH_XML"
cQuery += " FROM "+RetSQLName("ZPH")+" ZPH"
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=ZPH_FORNEC AND A1_LOJA=ZPH_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE ZPH.D_E_L_E_T_=' ' "
cQuery += " AND ZPH_STATUS = '"+cvaltochar(aPars[1])+"'"
//nGrupo,cFilPar,cNotPar,cSerPar,cCliPar,cLojPar,cDtPar1,cDtPar2
If !Empty(aPars[2])
    cQuery += " AND ZPH_FILIAL='"+aPars[2]+"'"
Else 
    cQuery += " AND ZPH_FILIAL BETWEEN ' ' AND 'ZZZ'"
EndIF 

If !Empty(aPars[3])
    cQuery += " AND ZPH_DOC='"+aPars[3]+"'"
Endif 

If !Empty(aPars[4])
    cQuery += " AND ZPH_SERIE='"+aPars[4]+"'"
Endif 

If !Empty(aPars[5])
    cQuery += " AND ZPH_FORNEC='"+aPars[5]+"'"
Endif 

If !Empty(aPars[6])
    cQuery += " AND ZPH_LOJA='"+aPars[6]+"'"
Endif 

If !Empty(aPars[7]) .or. !Empty(aPars[8])
    cQuery += " AND ZPH_DATA BETWEEN '"+dtos(aPars[7])+"' AND '"+dtos(aPars[8])+"'"
Endif 

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFISM001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
    Aadd(aListR12,{.F.,;
                  TRB->ZPH_FILIAL,;
                  TRB->ZPH_DOC,;
                  TRB->ZPH_SERIE,;
                  TRB->ZPH_FORNEC+'-'+TRB->ZPH_LOJA,;
                  TRB->A1_NOME,;
                  TRB->ZPH_XML,;
                  TRB->RECZPH,;
                  '',;
                  '',;
                  '',;
                  '',;
                  '',;
                  '',;
                  '',;
                  '',;
                  '',;
                  '',;
                  '' ,;
                  .f.,;
                  '',;
                  ''})
    Dbskip()
EndDo 

For nCont := 1 to len(aListR12)
    CFILANT := aListR12[nCont,02]
    aRet := U_xvldws13(1,aListR12[nCont,07],1,aListR12[nCont,08])
    If VALTYPE(aRet) == "A"
        If len(aRet) > 0

            If !aRet[12] .AND. aPars[1] = '1' 
                Loop
            Endif

            If aRet[12] .AND. aPars[1] = '0' 
                Loop
            Endif   

            If !Empty(aRet[11]) .And. !Empty(aListR12[nCont,06]) .And. !aRet[12]
                If aRet[12] .AND. aPars[1] = '1' 
                    lLegenda := .T.
                Endif     
            EndIf 

            Aadd(aListR1,{lLegenda ,;
                          aListR12[nCont,02],;
                          aListR12[nCont,03],;
                          aListR12[nCont,04],;
                          aListR12[nCont,05],;
                          aListR12[nCont,06],;
                          aListR12[nCont,07],;
                          aListR12[nCont,08],;
                          aRet[1],;
                          aRet[2],;
                          aRet[3] ,;
                          aRet[4],;
                          aRet[5],;
                          aRet[6],;
                          aRet[7],;
                          aRet[8],;
                          aRet[9],;
                          aRet[10],;
                          aRet[11],;
                          aRet[12],;
                          aRet[13],;
                          aRet[14]})
                            
            
            
        EndIf 
    EndIf 
Next nCont 

RestArea(aArea)

Return

/*/{Protheus.doc} FHelp(nLinha)
    Atualiza objetos say com informações do xml
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
Static Function FHelp(nLinha)

Local aArea := GetArea()

oSay2:settext("")
oSay4:settext("")
oSay6:settext("")
oSay8:settext("")
oSay10:settext("")
oSay12:settext("")
oSay14:settext("")
oSay16:settext("")
oSay18:settext("")
oSay20:settext("")
oSay22:settext("")
oSay23:settext("")

oSay2:settext(aListR1[nLinha,09])
oSay4:settext(aListR1[nLinha,10])
oSay6:settext(aListR1[nLinha,11])
oSay8:settext(aListR1[nLinha,12])
oSay10:settext(aListR1[nLinha,13])
oSay12:settext(aListR1[nLinha,14])
oSay14:settext(aListR1[nLinha,15])
oSay16:settext(aListR1[nLinha,16])
oSay18:settext(aListR1[nLinha,17])
oSay20:settext(aListR1[nLinha,18])
oSay22:settext(aListR1[nLinha,19])
oSay23:settext(If(aListR1[nLinha,20],"Nota já lançada",""))

oDlgR:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} chvcte(oList1:nAt)
    Copiar chave CTe
    @type  Static Function
    @author user
    @since 08/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function chvcte(nLinha)

Local aArea := GetArea()
Local cBkp1 := aListR1[nLinha,21]
Local cBkp2 := aListR1[nLinha,07]

aListR1[nLinha,07] := aListR1[nLinha,21]

lEditCell(aListR1,oLisR1,"",7)

aListR1[nLinha,21] := cBkp1
aListR1[nLinha,07] := cBkp2

RestArea(aArea)

Return
/*
    Parametros para reprocessamento das CTEs na tabela ZPH
*/
Static Function Prmrepr

Local aArea     :=  GetArea()
Local nOpcao    :=  0
Local aRet1      :=  {}

Local oRepr,oSay1,oSay2,oSay3,oSay4,oSay5,oGet1,oGet2
Local oGet4,oGet5,oGet6,oGet7,oBtn1,oBtn2,oSay6,oSay7

Local cFilPar := space(TamSX3("F2_FILIAL")[1])
Local cNotPar := space(TamSX3("F2_DOC")[1])
Local cSerPar := space(TamSX3("F2_SERIE")[1])
Local cCliPar := space(TamSX3("F2_CLIENTE")[1])
Local cLojPar := space(TamSX3("F2_LOJA")[1])
Local cDtPar1 := ctod(' / / ')
Local cDtPar2 := ctod(' / / ')
Local aOpcoes := {'0=Represados','1=Processados'}
Local nGrupo  := aOpcoes[1]

oRepr      := MSDialog():New( 139,752,537,1103,"Reprocessar",,,.F.,,,,,,.T.,,,.T. )
    
    oCBox1     := TComboBox():New( 020,052,{|u| If(Pcount()>0,nGrupo:=u,nGrupo)},aOpcoes,072,010,oRepr,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

    oSay1      := TSay():New( 052,024,{||"Filial"},oRepr,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 050,088,{|u| If(Pcount()>0,cFilPar:=u,cFilPar)},oRepr,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0","",,)
    
    oSay2      := TSay():New( 068,024,{||"Nota"},oRepr,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2      := TGet():New( 068,088,{|u| If(Pcount()>0,cNotPar:=u,cNotPar)},oRepr,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF2","",,)
    
    oSay3      := TSay():New( 084,024,{||"Serie"},oRepr,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet3      := TGet():New( 084,088,{|u| If(Pcount()>0,cSerPar:=u,cSerPar)},oRepr,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay4      := TSay():New( 100,024,{||"Cliente"},oRepr,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet4      := TGet():New( 100,088,{|u| If(Pcount()>0,cCliPar:=u,cCliPar)},oRepr,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","",,)
    
    oSay5      := TSay():New( 116,024,{||"Loja"},oRepr,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet5      := TGet():New( 116,088,{|u| If(Pcount()>0,cLojPar:=u,cLojPar)},oRepr,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay6      := TSay():New( 132,024,{||"Data De"},oRepr,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet6      := TGet():New( 132,088,{|u| If(Pcount()>0,cDtPar1:=u,cDtPar1)},oRepr,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay7      := TSay():New( 148,024,{||"Data Ate "},oRepr,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet7      := TGet():New( 148,088,{|u| If(Pcount()>0,cDtPar2:=u,cDtPar2)},oRepr,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oBtn1      := TButton():New( 172,024,"Confirmar",oRepr,{||oRepr:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 172,112,"Cancelar",oRepr,{||oRepr:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

oRepr:Activate(,,,.T.)

If nOpcao == 1
    Aadd(aRet1,nGrupo)
    Aadd(aRet1,cFilPar)
    Aadd(aRet1,cNotPar)
    Aadd(aRet1,cSerPar)
    Aadd(aRet1,cCliPar)
    Aadd(aRet1,cLojPar)
    Aadd(aRet1,cDtPar1)
    Aadd(aRet1,cDtPar2)
endIf 

RestArea(aArea)

Return(aRet1)
