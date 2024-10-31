#INCLUDE 'PROTHEUS.CH'

/*
    Rotina para digitação de inventário rotativo
    MIT 44_ESTOQUE_EST014 - Tela de lançamento do inventário

    DOC MIT
    https://docs.google.com/document/d/1gWLAfq1rFwx43DRVUBRK87BVvtTec4QD/edit
    DOC Entrega
    
    
*/

User Function JESTM002

Private lNewInv := .F.

Private cProdDe := ''
Private cProdAt := ''
Private cGrupDe := ''
Private cGrupAt := ''
Private cEndeDe := ''
Private cEndAte := ''
Private cMarcDe := ''
Private cMarcAt := ''
Private dDtDe   := CtoD(' / / ')
Private dDtAt   := CtoD(' / / ')
Private cLocIn  := ''
Private lSoMov  := .F.
Private dDtCnt := ctod(" / / ")
Private cHrCnt := space(5)

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00090276")
EndIf

TelaDig()



Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function TelaDig()

Local aArea     := GetArea()
Local nOpcao    := 0

Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oGrp2,oBtn1
Private oList1,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oSay11,oSay12
Private aList1  := {}
PRIVATE oOk     := LoadBitmap(GetResources(),'br_verde')  
PRIVATE oNo     := LoadBitmap(GetResources(),'br_vermelho')
Private cCodInv := ''
Private nContag := 0

Aadd(aList1,{.f.,'','','','','','','','','','','','','','',0,'','','','','','','','','','','','','','','',.f.,'','','','','',''})

oDlg1      := MSDialog():New( 092,232,809,1666,"Acuracidade Rotativa",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,056,040,640,"Informações Acuracidade",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oSay1      := TSay():New( 012,090,{||"Código"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
        oSay2      := TSay():New( 012,124,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
        oSay3      := TSay():New( 028,090,{||"Usuário"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
        oSay4      := TSay():New( 028,124,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,212,008)
    
        oSay5      := TSay():New( 012,290,{||"Data Inclusão"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oSay6      := TSay():New( 028,290,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)

        oSay7      := TSay():New( 012,380,{||"1ª Contagem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oSay8      := TSay():New( 028,380,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
    
        oSay9      := TSay():New( 012,440,{||"2ª Contagem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oSay10      := TSay():New( 028,440,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)

        oSay11     := TSay():New( 012,510,{||"3ª Contagem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oSay12     := TSay():New( 028,510,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
    
    oGrp2      := TGroup():New( 044,008,328,704,"Itens Acuracidade",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{052,012,324,700},,, oGrp2 ) 
        oList1    := TCBrowse():New(052,012,685,270,, {'','Local','Prateleira','Material','Descrição','Marca','Cod.Original',;
                                                    'Qtd Inicial','Qtd Entrada','Qtd Saida','Qtd Atual',;
                                                    'Sld Cnt 1','Contagem 1','Div. Cnt 1',;
                                                    'Sld Cnt 2','Contagem 2','Div. Cnt 2',;
                                                    'Sld Cnt 3','Contagem 3','Div. Cnt 3'},;
                                        {10,20,30,45,65,30,35,40,40,40,40,40,40,40,40,40,40,40,40,40},; //,40,40,40
                                        oGrp1,,,,{|| FHelp(oList1:nAt)},{|| editped(oList1:nAt,1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
                                        /* 'Divergência','Diverg. Valor','% Diverg.'},;*/
        oList1:SetArray(aList1)
        oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,07],;
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09],;
                            aList1[oList1:nAt,10],;
                            aList1[oList1:nAt,11],;
                            aList1[oList1:nAt,33],;
                            aList1[oList1:nAt,12],;
                            aList1[oList1:nAt,36],;
                            aList1[oList1:nAt,34],;
                            aList1[oList1:nAt,13],;
                            aList1[oList1:nAt,37],;
                            aList1[oList1:nAt,35],;
                            aList1[oList1:nAt,14],;
                            aList1[oList1:nAt,38]}}
                            /*aList1[oList1:nAt,15],;
                            aList1[oList1:nAt,18],;
                            aList1[oList1:nAt,19]}}*/

        //oBtn1      := TButton():New( 332,664,"oBtn1",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
        //Botões diversos
        oMenu := TMenu():New(0,0,0,0,.T.)
        // Adiciona itens no Menu
        oTMenuIte1 := TMenuItem():New(oDlg1,"Novo",,,,{|| _novoinv()},,,,,,,,,.T.)
        oTMenuIte2 := TMenuItem():New(oDlg1,"Digitar Cotagens",,,,{|| Processa({||_buscainv(),"Aguarde"})} ,,,,,,,,,.T.)
        oTMenuIte3 := TMenuItem():New(oDlg1,"Impressões",,,,{|| Processa({||imprexc(),"Aguarde"}) } ,,,,,,,,,.T.)
        //oTMenuIte4 := TMenuItem():New(oDlg1,"Importar Contagens",,,,{|| Processa({|| validPla(),"Aguarde"})} ,,,,,,,,,.T.)
        oTMenuIte5 := TMenuItem():New(oDlg1,"Gravar",,,,{||  Processa({||GravCont(),"Aguarde"})} ,,,,,,,,,.T.)
        oTMenuIte6 := TMenuItem():New(oDlg1,"Excluir Inventario",,,,{|| Processa({|| exclZPE(),"Aguarde"})} ,,,,,,,,,.T.)
        oTMenuIte0 := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end(nOpcao:=0)} ,,,,,,,,,.T.)


        oMenu:Add(oTMenuIte1)
        oMenu:Add(oTMenuIte2)
        oMenu:Add(oTMenuIte3)
        //oMenu:Add(oTMenuIte4)
        oMenu:Add(oTMenuIte5)
        oMenu:Add(oTMenuIte6)
        oMenu:Add(oTMenuIte0)

        // Cria botão que sera usado no Menu  
        oTButton1 := TButton():New( 332, 664, "Opções",oDlg1,{||},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
        // Define botão no Menu
        oTButton1:SetPopupMenu(oMenu)

        MENU oMenuP1 POPUP 
		MENUITEM "Marcar/Desmarcar Todos" ACTION (Processa({|| editped(,2)},"Aguarde"))
        MENUITEM "Estornar Contagens" ACTION (Processa({|| estorncnt()},"Aguarde"))
        ENDMENU                                                                           

		oList1:bRClicked := { |oObject,nX,nY| oMenuP1:Activate( nX, (nY-10), oObject ) }


oDlg1:Activate(,,,.T.)

/*
If nOpcao == 1
    Processa({||GravCont(),"Aguarde"})
EndIf 
*/

RestArea(aArea)

Return

/*/{Protheus.doc} FHelp
    Atualiza o cabeçalho
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

oSay6:settext("")
oSay8:settext("")
oSay10:settext("")
oSay12:settext("")

If aList1[nLinha,16] > 0
    DbSelectArea("ZPE")
    DbGoto(aList1[nLinha,16])

    oSay6:settext(cvaltochar(ZPE->ZPE_DATA)+" "+ZPE->ZPE_HRSLF1)
    If !Empty(ZPE_DTCNT1)
        oSay8:settext(cvaltochar(ZPE->ZPE_DTCNT1)+" "+ZPE->ZPE_HRCNT1)
    Else 
        If nContag == 1
            oSay8:settext(cvaltochar(dDtCnt)+" "+transform(cHrCnt,"@R 99:99"))
        EndIf 
    EndIf 
    If !Empty(ZPE_DTCNT2)
        oSay10:settext(cvaltochar(ZPE->ZPE_DTCNT2)+" "+ZPE->ZPE_HRCNT2)
    Else 
        If nContag == 2
            oSay10:settext(cvaltochar(dDtCnt)+" "+transform(cHrCnt,"@R 99:99"))
        EndIf 
    EndIf 
    If !Empty(ZPE_DTCNT3)
        oSay12:settext(cvaltochar(ZPE->ZPE_DTCNT3)+" "+ZPE->ZPE_HRCNT3)
    Else 
        If nContag == 3
            oSay12:settext(cvaltochar(dDtCnt)+" "+transform(cHrCnt,"@R 99:99"))
        EndIf 
    EndIf 
EndIf 

oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} editped
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editped(nLinha,nOpc)

Local nCont := 1
Local nPosCol := oList1:nColPos

If aList1[nLinha,17] == 'F'
    Return 
EndIf 

IF nPosCol < 3
    If nContag <> 4
        If nOpc == 1
            If !Empty(aList1[nLinha,04])
                If aList1[nLinha,01] 
                    aList1[nLinha,01] := .F.
                Else 
                    aList1[nLinha,01] := .T.
                EndIf
            endIf 
        Else 
            If !Empty(aList1[nCont,04])
                For nCont := 1 to len(aList1)
                    If aList1[nCont,01]
                        aList1[nCont,01] := .F.
                    Else 
                        aList1[nCont,01] := .T.
                    EndIF 
                Next nCont 
            EndIf 
        EndIf 
    EndIf 
Else 
    //If nPosCol >= 12 .And. nPosCol <= 14
    If nContag <> 4
        If aList1[oList1:nAt,01]
            nPosL := 0
            cBkp  := ""
            If nContag == 1
                nPosL := 13
                cBkp  := aList1[oList1:nAt,13]
                aList1[oList1:nAt,13] := aList1[oList1:nAt,12]
            ElseIf nContag == 2
                nPosL := 16
                cBkp  := aList1[oList1:nAt,16]
                aList1[oList1:nAt,16] := aList1[oList1:nAt,13]
            ElseIf nContag == 3
                nPosL := 19
                cBkp  := aList1[oList1:nAt,19]
                aList1[oList1:nAt,19] := aList1[oList1:nAt,14]
            EndIf 

            lEditCell(aList1,oList1,"@E 9999999",nPosL) //If(nContag==1,12,If(nContag==2,13,14))

            If nContag == 1
                //aList1[oList1:nAt,15] := aList1[oList1:nAt,12] - aList1[oList1:nAt,11]
                aList1[oList1:nAt,36] := aList1[oList1:nAt,13] - aList1[oList1:nAt,33]
                aList1[oList1:nAt,12] := aList1[oList1:nAt,13]
                aList1[oList1:nAt,13] := cBkp
            ElseIf nContag == 2
                //aList1[oList1:nAt,15] := aList1[oList1:nAt,13] - aList1[oList1:nAt,11]
                aList1[oList1:nAt,37] := aList1[oList1:nAt,16] - aList1[oList1:nAt,34]
                aList1[oList1:nAt,13] := aList1[oList1:nAt,16]
                aList1[oList1:nAt,16] := cBkp
            ElseIf nContag == 3
                //aList1[oList1:nAt,15] := aList1[oList1:nAt,14] - aList1[oList1:nAt,11]
                aList1[oList1:nAt,38] := aList1[oList1:nAt,19] - aList1[oList1:nAt,35]
                aList1[oList1:nAt,14] := aList1[oList1:nAt,19]
                aList1[oList1:nAt,19] := cBkp
            EndIf  
        EndIf 
    EndIf
EndIf 

oList1:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} GravCont
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GravCont()

Local nCont 
Local lEncerra  :=  .F.

If nContag == 4 //.Or. aList1[oList1:nAt,17] == "F"
    Return 
endIf 

If len(aList1) > 0 

    If MsgYesNo("Encerrar a contagem da acuracidade?","GravCont - JESTM002")
        lEncerra := .T.
    EndIf 

    For nCont := 1 to len(aList1)
        If aList1[nCont,1]
            Processa({||GravPrInv(nCont,lEncerra)}, "Aguarde")
        EndIf 
    Next nCont 

    lNewInv := .F.

    MsgAlert("Gravação finalizada")
EndIf
    
Return

/*/{Protheus.doc} estorncnt()
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function estorncnt()

Local aArea  := GetArea()
Local aPergs := {}
Local aRet   := {}
Local nCont  := 0
Local nAux   := 0

If aList1[oList1:nAt,17] == "F"
    Return 
EndIf 

aAdd(aPergs ,{2,"Contagem"	,"", {"1=Estornar a ultima","2=Estornar todas"},90,'',.T.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    nAux := val(aRet[1])
    DbSelectArea("ZPE")
    
    For nCont := 1 to len(aList1)
        DbGoto(aList1[nCont,16])
        Reclock("ZPE",.F.)

        If nAux == 1
            &("ZPE->ZPE_DTCNT"+aList1[nCont,17]) := ctod(' / / ')
            &("ZPE->ZPE_HRCNT"+aList1[nCont,17]) := ' '
            
            If val(aList1[nCont,17]) == 3
                aList1[nCont,14] := 0
                aList1[nCont,15] := aList1[nCont,13] - aList1[nCont,11]
            ElseIf val(aList1[nCont,17]) == 2
                aList1[nCont,13] := 0
                aList1[nCont,15] := aList1[nCont,12] - aList1[nCont,11]
            Else 
                aList1[nCont,12] := 0
                aList1[nCont,15] := 0 
            EndIf   

            ZPE->ZPE_STATUS := cvaltochar(val(aList1[nCont,17])-1)
            aList1[nCont,17] := cvaltochar(val(aList1[nCont,17])-1)
        Else 
            ZPE->ZPE_CONTA1 := 0
            ZPE->ZPE_CONTA2 := 0
            ZPE->ZPE_CONTA3 := 0
            ZPE->ZPE_RESULT := 0
            ZPE->ZPE_DTCNT1 := ctod(' / / ')
            ZPE->ZPE_DTCNT2 := ctod(' / / ')
            ZPE->ZPE_DTCNT3 := ctod(' / / ')
            ZPE->ZPE_HRCNT1 := ' '
            ZPE->ZPE_HRCNT2 := ' '
            ZPE->ZPE_HRCNT3 := ' '
            aList1[nCont,12] := 0
            aList1[nCont,13] := 0
            aList1[nCont,14] := 0
            aList1[nCont,15] := 0
            ZPE->ZPE_STATUS := '0'
        EndIf 

        ZPE->(Msunlock())

        

    Next nCont 
EndIf
    
oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} imprexc
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function imprexc()

Local aArea  := GetArea()
Local aPergs := {}
Local aRet   := {}
Local nTipo  := 0
Local nCont  := 0
Private aHeader := {}
Private aAuxExc := {}

aAdd(aPergs ,{2,"Tipo Impressão"	,"", {"1=Excel p/ Contagem","2=Conferência"},90,'',.T.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    nTipo := aRet[1]

    If val(nTipo) == 1
        Aadd(aHeader,{  'Local',;
                        'Prateleira',;
                        'Material',;
                        'Descrição',;
                        'Marca',;
                        'Codigo Original',;
                        'Contagem 1',;
                        'Contagem 2',;
                        'Contagem 3'})
        
        For nCont := 1 to len(aList1)
            Aadd(aAuxExc,{aList1[nCont,02],;
                        aList1[nCont,03],;
                        aList1[nCont,04],;
                        aList1[nCont,05],;
                        aList1[nCont,06],;
                        aList1[nCont,07],;  
                        '',;
                        '',;
                        ''  })
        Next nCont 

        Processa({|| GeraPlan()},"Aguarde")
    Else 
        Processa({|| GeraConf()},"Aguarde")
    EndIf 

EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} _novoinv
    Gera um novo inventário
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function _novoinv()

Local aPergs := {}
Local aRet   := {}


                                                                             //"ExistCpo('SB1', &(ReadVar()))"
aAdd(aPergs ,{1,"Produto de:"	,space(TamSx3("B1_COD")[1])             ,"@!","U_xJestm01(&(ReadVar()),'SB1')","SB1",".T.",70,.F.})
aAdd(aPergs ,{1,"Produto Até:"	,padr('zz',TamSx3("B1_COD")[1])         ,"@!","U_xJestm01(&(ReadVar()),'SB1')","SB1",".T.",70,.F.})
aAdd(aPergs ,{1,"Grupo de"	    ,space(TamSx3("B1_GRUPO")[1])           ,"@!","U_xJestm01(&(ReadVar()),'SBM')","SBM",".T.",60,.F.})
aAdd(aPergs ,{1,"Grupo Até"	    ,padr('zz',TamSx3("B1_GRUPO")[1])       ,"@!","U_xJestm01(&(ReadVar()),'SBM')","SBM",".T.",60,.F.})

aAdd(aPergs ,{1,"Endereço de"	,space(TamSx3("BE_LOCALIZ")[1])         ,"@!","U_xJestm01(&(ReadVar()),'SBE')","SBM",".T.",60,.F.})
aAdd(aPergs ,{1,"Endereço Até"	,padr('zz',TamSx3("BE_LOCALIZ")[1])     ,"@!","U_xJestm01(&(ReadVar()),'SBE')","SBM",".T.",60,.F.})

aAdd(aPergs ,{2,"Marca?"        ,""                                     ,{"1=Sim","2=Nao"},50,'',.T.}) 

aAdd(aPergs ,{1,"Data de"       ,dDtDe                                  ,"",".T.","",".T.",80,.F.})
aAdd(aPergs ,{1,"Data Até"      ,dDtAt                                  ,"",".T.","",".T.",80,.F.})
aAdd(aPergs ,{1,"Local"         ,space(TamSx3("D1_LOCAL")[1])           ,"@!","U_xJestm01(&(ReadVar()),'NNR')","NNR",".T.",80,.F.})
aAdd(aPergs ,{2,"Somente c/Mov.",""                                     , {"1=Sim","2=Nao"},50,'',.T.})


If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    cProdDe := aRet[1]
    cProdAt := aRet[2]
    cGrupDe := aRet[3]
    cGrupAt := aRet[4]
    cEndeDe := aRet[5]
    cEndAte := aRet[6]
    cMarcDe := If(aRet[7]=="1",.T.,.F.)//aRet[5]
    //cMarcAt := aRet[6]
    dDtDe   := aRet[8]
    dDtAt   := aRet[9]
    cLocIn  := aRet[10]
    lSoMov  := If(aRet[11]=="1",.T.,.F.)

    _xQrjest2(0)
    
    lNewInv := .T.
    
    nContag := 1

EndIf
    
Return

 /*/{Protheus.doc} nomeFunction
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
User Function xJestm01(cConteudo,cTabela)

Local aArea := GetArea()
Local lRet  := .T.

If !Empty(cConteudo) .And. !'ZZ' $ upper(cConteudo)
    lRet := ExistCpo(cTabela,cConteudo)
EndIf 

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} _buscainv
    Procura um inventário pelo código
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function _buscainv()

Local aPergs := {}
Local aRet   := {}
Local lLibCnt:= .F.

aAdd(aPergs ,{1,"Código:"	    ,space(TamSx3("ZPE_CODIGO")[1]),"@!",".T.","ZPE",".T.",70,.F.})
aAdd(aPergs ,{2,"Contagem"	    ,"", {"1=Contagem 1","2=Contagem 2","3=Contagem 3","4=Conferência"},50,'',.T.})
aAdd(aPergs ,{1,"Data Contagem" ,dDtCnt   ,"",".T.","",".T.",80,.T.})
aAdd(aPergs ,{1,"Data Contagem" ,cHrCnt   ,"@R 99:99",".T.","",".T.",70,.F.})

While !lLibCnt
    If ParamBox(aPergs ,"Filtrar por",@aRet)    
        
        cCodInv := aRet[1]
        nContag := val(aRet[2])
        dDtCnt  := aRet[3]
        cHrCnt  := aRet[4]
        lLibCnt := VldCnt(cCodInv,nContag,dDtCnt)
        

        /*If nContag > 1
            _xQrjest2(nContag)
        EndIf*/ 

        
    Else   
        exit
    EndIf
EndDo 
    

If lLibCnt

    PreaList(cCodInv,nContag,.f.)
    FHelp(1)

EndIf 

Return

/*/{Protheus.doc} VldCnt(cCodInv,nContag)
    Verifica se a contagem informada no parametro é igual a contagem atual do inventario
    @type  Static Function
    @author user
    @since 09/09/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function VldCnt(cCodInv,nContag,dDtCnt)

Local lRet := .T.
Local cQuery 

cQuery := "SELECT MAX(ZPE_STATUS) AS CONTAGEM FROM "+RetSQLName("ZPE")
cQuery += " WHERE D_E_L_E_T_=' ' AND ZPE_CODIGO='"+cCodInv+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTM002_VldCnt.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

If val(TRB->CONTAGEM) <> nContag
    If val(TRB->CONTAGEM) == 0 .and. nContag <> 1
        MsgAlert("Contagem informada divergente da contagem atual deste inventário, contagem atual "+If(val(TRB->CONTAGEM)==0,'1',TRB->CONTAGEM))
        lRet := .F.
    EndIf 
EndIF 

cQuery := "SELECT ZPE_DATA FROM "+RetSQLName("ZPE")
cQuery += " WHERE D_E_L_E_T_=' ' AND ZPE_CODIGO='"+cCodInv+"' AND ZPE_FILIAL='"+xFilial("ZPE")+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTM002_VldCnt.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

If stod(TRB->ZPE_DATA) > dDtCnt
    MsgAlert("Data de contagem não pode ser inferior a data de inclusão do inventário.")
    lRet := .F.
EndIf 

Return(lRet)
/*/{Protheus.doc} _xQrjest2
    Gera um novo inventário
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function _xQrjest2(nCntg)

Local cWhereD1 := '', cWhereD1C := ''
Local cWhereD2 := '', cWhereD2C := '', cWhereB1N := ''
Local cWhereD3 := '', cWhereD3C := '', cWhereB1C := ''

Local cFromSBE  := ''
Local cAliasTop := GetNextAlias()
Local aSalAtu   := { 0,0,0,0,0,0,0 }
Local cHora     := ''
Local nSaldoFim := 0
Local nCont     := 0
Local cBarra    := ''
Local aBkpProd  := {}
Local nPosic1

iF nCntg == 0
    aList1 := {}

Else 
    cLocIn := aList1[1,2]
    cGrupDe := ' '
    cGrupAt := 'ZZZ'
    cProdDe := ' '
    cProdAt := 'ZZZ'
    
    If nCntg == 2
        dDtDe   := STOD(alist1[1,20])
    ElseIf nCntg == 3
        dDtDe   := STOD(alist1[1,22])
    endif 


    If nCntg > 1
        For nCont := 1 to len(aList1)
            cWhereB1N += cBarra + alltrim(aList1[nCont,04])
            cBarra := "/"
        Next nCont 
    EndIf  

    dDtAt   := ddatabase //STOD(alist1[1,20])
    lSoMov  := .T.
    cMarcDe := .F.

    If nCntg == 2
        cHora := aList1[1,21]
    ElseIf nCntg == 3
        cHora := aList1[1,23]
    EndIf 
eNDiF 

cWhereB1A:= "%"
cWhereB1B:= "%"
cWhereB1C:= "%"
cWhereB1D:= "%"

cFromSBE := '%'+RetSqlName('SB1')+' SB1,'+RetSqlName('SBE')+' SBE %'

cWhereD1C := "%"
cWhereD1C += " D1_FILIAL ='" + xFilial("SD1") + "' AND "
cWhereD1C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
cWhereD1C += " F1_FILIAL =D1_FILIAL AND "
cWhereD1C += " F1_DOC =D1_DOC AND "
cWhereD1C += " F1_SERIE =D1_SERIE AND "
cWhereD1C += " F1_FORNECE =D1_FORNECE AND "
cWhereD1C += " F1_LOJA =D1_LOJA AND "

If nCntg > 1
    cWhereD1C += " (F1_HORA > '"+cHora+"' AND F1_DTDIGIT>='"+DTOS(dDtAt)+"') AND "
endif 

cWhereD1C += "%"


cWhereD1 := "%"
//cWhereD1 += "AND"
cWhereD1 += " D1_LOCAL = '" + cLocIn + "' AND"
cWhereD1 += "%"

cWhereB1C += " SB1.B1_GRUPO >= '"+cGrupDe+"' AND SB1.B1_GRUPO <= '"+cGrupAt+"' AND"
cWhereB1C += " SB1.D_E_L_E_T_=' '"

cWhereD2 := "%"
cWhereD2 += "AND"
cWhereD2 += " D2_LOCAL = '" + cLocIn + "' AND"
cWhereD2 += "%"	

cWhereD2C := "%"
cWhereD2C += " D2_FILIAL ='" + xFilial("SD2") + "' AND "
cWhereD2C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
cWhereD2C += " F2_FILIAL =D2_FILIAL AND "
cWhereD2C += " F2_DOC = D2_DOC AND "
cWhereD2C += " F2_SERIE = D2_SERIE AND "
cWhereD2C += " F2_CLIENTE = D2_CLIENTE AND "
cWhereD2C += " F2_LOJA = D2_LOJA AND "

If nCntg > 1
    cWhereD2C += " (F2_HORA > '"+cHora+"' AND F2_DTDIGIT>='"+DTOS(dDtAt)+"') AND "
endif

cWhereD2C += "%"


cWhereB1A+= " AND SB1.B1_COD >= '"+cProdDe+"' AND SB1.B1_COD <= '"+cProdAt+"'"
cWhereB1B+= " AND SB1.B1_COD = SB1EXS.B1_COD"

cWhereD3 := "%"
If A900GetMV(2, 'MV_D3ESTOR', .F., 'N') == 'N'
    cWhereD3 += " D3_ESTORNO <> 'S' AND"
EndIf

cWhereD3 += " D3_LOCAL = '"+cLocIn+"' AND"
cWhereD3 += " SB1.B1_COD >= '"+cProdDe+"' AND SB1.B1_COD <= '"+cProdAt+"' AND"
cWhereD3 += " SB1.B1_GRUPO >= '"+cGrupDe+"' AND SB1.B1_GRUPO <= '"+cGrupAt+"' AND "
cWhereD3 += " SB1.D_E_L_E_T_=' ' AND "
cWhereD3 += "%"
cWhereD3C := "%"
cWhereD3C += " D3_FILIAL ='" + xFilial("SD3")  + "' AND "
cWhereD3C += "%"

cQueryB1A:= Subs(cWhereB1A,2)
cQueryB1B:= Subs(cWhereB1B,2)
cQueryB1C:= Subs(cWhereB1C,2)
cQueryB1D:= Subs(cWhereB1D,2)

cWhereB1A+= "%"
cWhereB1B+= "%"
cWhereB1C+= "%"
cWhereB1D+= "%"

cOrder := "%"
cOrder += " 2"
cOrder += "%"


BeginSql Alias cAliasTop

    SELECT 	'SD1' ARQ, 				//-- 01 ARQ
            SB1.B1_COD PRODUTO, 	//-- 02 PRODUTO
            SB1.B1_TIPO TIPO, 		//-- 03 TIPO
            SB1.B1_UM,   			//-- 04 UM
            SB1.B1_GRUPO,      	//-- 05 GRUPO
            SB1.B1_DESC,      		//-- 06 DESCR
            SB1.B1_POSIPI, 		//-- 07
            SB1.B1_ZMARCA,
            SB1.B1_FABRIC,
            D1_SEQCALC SEQCALC,    //-- 08
            D1_DTDIGIT DTDIGIT,		//-- 09 DTDIGIT
            D1_TES TES,			//-- 10 TES
            D1_CF CF,				//-- 11 CF
            D1_NUMSEQ SEQUENCIA,	//-- 12 SEQUENCIA
            D1_DOC DOCUMENTO,		//-- 13 DOCUMENTO
            D1_SERIE SERIE,		//-- 14 SERIE
            D1_QUANT QUANTIDADE,	//-- 15 QUANTIDADE
            D1_QTSEGUM QUANT2UM,	//-- 16 QUANT2UM
            D1_LOCAL ARMAZEM,		//-- 17 ARMAZEM
            ' ' PROJETO,			//-- 18 PROJETO
            ' ' OP,				//-- 19 OP
            ' ' CC,				//-- 20 OP
            D1_FORNECE FORNECEDOR,	//-- 21 FORNECEDOR
            D1_LOJA LOJA,			//-- 22 LOJA
            ' ' PEDIDO,            //-- 23 PEDIDO
            D1_TIPO TIPONF,		//-- 24 TIPO NF
            ' ' TRT, 				//-- 26 TRT
            SD1.R_E_C_N_O_ NRECNO,  //-- 29 RECNO
            SD1.D1_LOCAL ARMLOC

    FROM %Exp:cFromSBE%,%table:SD1% SD1,%table:SF4% SF4,%table:SF1% SF1

    WHERE	SB1.B1_COD     =  SD1.D1_COD		AND  	%Exp:cWhereD1C%  
            SD1.D1_TES     =  SF4.F4_CODIGO	    AND   SF4.F4_ESTOQUE =  'S'	AND
            SD1.D1_DTDIGIT >= %Exp:dDtDe%	AND SD1.D1_DTDIGIT <= %Exp:dDtAt%	AND
            SBE.BE_LOCALIZ >= %Exp:cEndeDe% AND SBE.BE_LOCALIZ <= %Exp:cEndAte% AND
            SD1.D1_ORIGLAN <> 'LF' AND SF1.F1_DTDIGIT <= %Exp:dDtAt%  AND 
            %Exp:cWhereD1%                     
            SD1.%NotDel%    				  AND 	SF4.%NotDel%
            %Exp:cWhereB1A%                   AND
            %Exp:cWhereB1C%                    
            
    UNION

        SELECT 'SD2' ARQ,
            SB1.B1_COD,
            SB1.B1_TIPO,
            SB1.B1_UM,
            SB1.B1_GRUPO,
            SB1.B1_DESC,
            SB1.B1_POSIPI,
            SB1.B1_ZMARCA,
            SB1.B1_FABRIC,
            D2_SEQCALC,
            D2_EMISSAO,
            D2_TES,
            D2_CF,
            D2_NUMSEQ,
            D2_DOC,
            D2_SERIE,
            D2_QUANT ,
            D2_QTSEGUM,
            D2_LOCAL,
            ' ',
            ' ',
            ' ',
            D2_CLIENTE,
            D2_LOJA,
            D2_PEDIDO,
            D2_TIPO,
            ' ',
            SD2.R_E_C_N_O_ SD2RECNO, //-- 29 RECNO
            SD2.D2_LOCAL
        FROM %Exp:cFromSBE%,%table:SD2% SD2,%table:SF2% SF2 ,%table:SF4% SF4

        WHERE	SB1.B1_COD     =  SD2.D2_COD		AND	%Exp:cWhereD2C%
                SD2.D2_TES     =  SF4.F4_CODIGO		AND
                SF4.F4_ESTOQUE =  'S'				AND	
                SD2.D2_EMISSAO >= %Exp:dDtDe%	    AND SD2.D2_EMISSAO <= %Exp:dDtAt%	AND
                SBE.BE_LOCALIZ >= %Exp:cEndeDe% AND SBE.BE_LOCALIZ <= %Exp:cEndAte% AND
                SD2.D2_ORIGLAN <> 'LF'
                %Exp:cWhereD2%
                SD2.%NotDel%						AND SF4.%NotDel%
                %Exp:cWhereB1A%                     AND
                %Exp:cWhereB1C%                     
                
    UNION

        SELECT 	'SD3' ARQ,
                SB1.B1_COD,
                SB1.B1_TIPO,
                SB1.B1_UM,
                SB1.B1_GRUPO,
                SB1.B1_DESC,
                SB1.B1_POSIPI,
                SB1.B1_ZMARCA,
                SB1.B1_FABRIC,
                D3_SEQCALC,
                D3_EMISSAO,
                D3_TM,
                D3_CF,
                D3_NUMSEQ,
                D3_DOC,
                ' ',
                D3_QUANT,
                D3_QTSEGUM,
                D3_LOCAL,
                D3_PROJPMS,
                D3_OP,
                D3_CC,
                ' ',
                ' ',
                ' ',
                ' ',
                D3_TRT,
                SD3.R_E_C_N_O_ SD3RECNO, //-- 29 RECNO
                SD3.D3_LOCAL

        FROM %Exp:cFromSBE%,%table:SD3% SD3

        WHERE	SB1.B1_COD     =  SD3.D3_COD 		AND %Exp:cWhereD3C%
                SD3.D3_EMISSAO >= %Exp:dDtDe%	AND	SD3.D3_EMISSAO <= %Exp:dDtAt%	AND
                SBE.BE_LOCALIZ >= %Exp:cEndeDe% AND SBE.BE_LOCALIZ <= %Exp:cEndAte% AND
                %Exp:cWhereD3%
                SD3.%NotDel%    
                
    

    ORDER BY %Exp:cOrder%

EndSql
//%Exp:cUnion%
While !(cAliasTop)->(Eof())

    If nCntg > 1
        iF !alltrim((cAliasTop)->PRODUTO) $ cWhereB1N
            dbskip()
            loop
            
        EndIf 
    EndIF 

/*
    nSaldoB2 := 0
    aAreaB2 := GetArea()
    DbselectArea("SB2")
    DbSetOrder(1)
    If DbSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+cLocIn)
        nSaldoB2 := SaldoSB2()
    EndIF 
    RestArea(aAreaB2)
*/
    nPosic1 := Ascan(aList1,{|x| x[4] == (cAliasTop)->PRODUTO})

    nQtd1 := 0
    nQtd2 := 0
    nQtd3 := 0

    If (cAliasTop)->TES > '500'
        nQtd2 := (cAliasTop)->QUANTIDADE
    Else 
        nQtd1 := (cAliasTop)->QUANTIDADE
    EndIf 

    If nPosic1 == 0
        aSalAtu := {0,0,0,0}

        If Ascan(aBkpProd,{|x| alltrim(x) == alltrim((cAliasTop)->PRODUTO)}) == 0
            MR900ImpS1(@aSalAtu,cAliasTop,.T.,cLocIn)
        EndIf 
        
        cProdP := Posicione("SB1",1,xFilial("SB1")+(cAliasTop)->PRODUTO,"B1_XCODPAI")

        If Empty(cProdP)
            cPrat := Posicione("SBE",10,xFilial("SBE")+(cAliasTop)->PRODUTO+(cAliasTop)->ARMAZEM,"BE_LOCALIZ")
        Else 
            cPrat := Posicione("SBE",10,xFilial("SBE")+cProdP+(cAliasTop)->ARMAZEM,"BE_LOCALIZ")
        EndIf 

        nSaldoIni := aSalAtu[1]
        nSaldoFim := aSalAtu[1]+nQtd1-nQtd2
/*        If nSaldoB2 <> nSaldoFim .And. nCntg > 1
            nSaldoIni := (aSalAtu[1]+nQtd1-nQtd2) - nSaldoB2
            If nSaldoIni < 0
                nSaldoIni := nSaldoIni * (-1)
            EndIf
            nSaldoFim := nSaldoB2
            
        EndIF */

        Aadd(aList1,{ .T.,;
                    (cAliasTop)->ARMAZEM,;
                    cPrat,;
                    (cAliasTop)->PRODUTO,;
                    (cAliasTop)->B1_DESC,;
                    alltrim(Posicione("ZPM",1,xFilial("ZPM")+(cAliasTop)->B1_ZMARCA,"ZPM_DESC")),;
                    (cAliasTop)->B1_FABRIC,;
                    nSaldoIni,;
                    nQtd1,;
                    nQtd2,;
                    nSaldoFim,;
                    0,;
                    0,;
                    0,;
                    0,;
                    0,;
                    '',;
                    0,;
                    0,;
                    '',;
                    '',;
                    '',;
                    '',;
                    '',;
                    '',;
                    0,;
                    0,;
                    0,;
                    0,;
                    0,;
                    0,;
                    .f.,;
                    0,;
                    0,;
                    0,;
                    0,;
                    0,;
                    0})
    Else 
        
        //MR900ImpS1(@aSalAtu,cAliasTop,.T.,cLocIn)
        //If nCntg <= 1
        //    nSaldoIni := aList1[nPosic1,11] //if(nCntg<= 1,aList1[nPosic1,11],if(nCntg==2,aList1[nPosic1,28],aList1[nPosic1,31])) 
            
        //Else
        If nCntg <= 1
            nSaldoIni := aList1[nPosic1,08]
        Elseif nCntg == 2
            /*if aList1[nPosic1,11] < aList1[nPosic1,28]
                nSaldoIni := nSaldoFim
            else 
                nSaldoIni := aList1[nPosic1,12]
            endif */
            nSaldoIni := aList1[nPosic1,11]
        Elseif nCntg == 3
            if aList1[nPosic1,11] < aList1[nPosic1,30]
                nSaldoIni := nSaldoFim
            else 
                nSaldoIni := aList1[nPosic1,12]
            endif 
        endif 

        nSaldoFim := nSaldoIni+nQtd1-nQtd2 //nSaldoFim
        //If nSaldoB2 <> nSaldoFim
        //    nSaldoIni := (aList1[nPosic1,If(nCntg == 2,11,if(nCntg ==3,28,31))]-nQtd1+nQtd2) //- nSaldoB2
            // (nSaldoIni+nQtd1-nQtd2) - nSaldoB2
            //(aList1[nPosic1,If(nCntg <= 1,11,if(nCntg ==2,28,31))]+nQtd1-nQtd2) - nSaldoB2
            /*If nSaldoIni < 0
                nSaldoIni := nSaldoIni * (-1)
            EndIf*/
        //    nSaldoFim := nSaldoIni+nQtd1-nQtd2
            //nSaldoFim := nSaldoB2
            
        //EndIF 
        
        If !aList1[nPosic1,32]
            aList1[nPosic1,08] := nSaldoIni
        endif 

        If nCntg <= 1
            aList1[nPosic1,09] += nQtd1
            aList1[nPosic1,10] += nQtd2
            aList1[nPosic1,11] := nSaldoFim //aList1[nPosic1,11] + nQtd1 - nQtd2
        ElseIf nCntg == 2
            aList1[nPosic1,26] += nQtd1
            aList1[nPosic1,27] += nQtd2
            aList1[nPosic1,28] := nSaldoFim //aList1[nPosic1,28] + nQtd1 - nQtd2 // 
        ElseIf nCntg == 3
            aList1[nPosic1,29] += nQtd1
            aList1[nPosic1,30] += nQtd2
            aList1[nPosic1,31] := nSaldoFim //aList1[nPosic1,31] + nQtd1 - nQtd2 //
        EnDIf 

        aList1[nPosic1,32] := .t.
    EndIf 

    Dbskip()
EndDo 

For nPosic1 := 1 to len(aList1)
    If nCntg <= 1
        aList1[nPosic1,11] := aList1[nPosic1,08] + aList1[nPosic1,09] - aList1[nPosic1,10]
    EnDIf 
Next nPosic1

If !lSoMov
   
    cQuery := "SELECT ZPM_DESC,B1_COD AS PRODUTO,B1_LOCPAD, B1_COD AS B1_COD,B1.*  "
    cQuery += " FROM "+RetSqlName("SB1")+" B1"
    cQuery += " INNER JOIN "+RetSqlName("ZPM")+" ZPM ON ZPM_FILIAL='"+xFilial("ZPM")+"' AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
    cQuery += " INNER JOIN "+RetSqlName("SB2")+" SB2 ON B2_FILIAL='"+xFilial("SB2")+"' AND B2_COD=B1_COD AND B2_LOCAL='"+cLocIn+"' AND SB2.D_E_L_E_T_=' '"
    cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"
    cQuery += " AND B1.D_E_L_E_T_=' '"
    cQuery += " AND B1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAt+"'"
    cQuery += " AND B1_GRUPO BETWEEN '"+cGrupDe+"' AND '"+cGrupAt+"'"

    If cMarcDe
        //cQuery += " AND B1_ZMARCA BETWEEN '"+cMarcDe+"' AND '"+cMarcAt+"'"
        cQuery += " AND B1_XCODPAI<>' '"
    Else 
        cQuery += " AND B1_XCODPAI=' '"
    EndIf 

    //cQuery += " AND B1_LOCPAD ='"+cLocIn+"'"
    
        
    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    MemoWrite("JESTM002.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB") 

    While !EOF()
        If ascan(aList1,{|x| x[4] == TRB->B1_COD}) == 0
            
            cProdP := Posicione("SB1",1,xFilial("SB1")+TRB->PRODUTO+cLocIn,"B1_XCODPAI")

            If Empty(cProdP)
                cPrat := Posicione("SBE",10,xFilial("SBE")+TRB->PRODUTO+cLocIn,"BE_LOCALIZ")
            Else 
                cPrat := Posicione("SBE",10,xFilial("SBE")+cProdP+cLocIn,"BE_LOCALIZ")
            EndIf 

            MR900ImpS1(@aSalAtu,"TRB",.T.,cLocIn)
            Aadd(aList1,{ .T.,;
                            cLocIn,;
                            cPrat,;
                            TRB->B1_COD,;
                            TRB->B1_DESC,;
                            alltrim(TRB->ZPM_DESC),;
                            TRB->B1_FABRIC,;
                            aSalAtu[1],;
                            0,;
                            0,;
                            aSalAtu[1],;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            '',;
                            0,;
                            0,;
                            '',;
                            '',;
                            '',;
                            '',;
                            '',;
                            '',;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            .f.,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0})
        endif
        Dbskip()
    EndDo 
EndIf 

If len(aList1) < 1
    Aadd(aList1,{.f.,'','','','','','','','','','','','','','',0,'','','','','','','','','','','','','','','',.f.,'','','','','',''})
Else 
    Asort(aList1,,,{|x,y| x[4] < y[4]})
    lNovaCnt := .F.

    DbSelectArea("ZPE")
    While !lNovaCnt
        cCodInv := GETSXENUM("ZPE","ZPE_CODIGO")  
        If !Dbseek(xFilial("ZPE")+cCodInv)
            lNovaCnt := .T.
        EndIf 
        ConfirmSX8()   
    Enddo 

    oSay2:settext("")
    oSay4:settext("")
    oSay2:settext(cCodInv)
    oSay4:settext(cusername)                                                                                              
EndIf 


oList1:SetArray(aList1)
oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,07],;
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09],;
                            aList1[oList1:nAt,10],;
                            aList1[oList1:nAt,11],;
                            aList1[oList1:nAt,33],;
                            aList1[oList1:nAt,12],;
                            aList1[oList1:nAt,36],;
                            aList1[oList1:nAt,34],;
                            aList1[oList1:nAt,13],;
                            aList1[oList1:nAt,37],;
                            aList1[oList1:nAt,35],;
                            aList1[oList1:nAt,14],;
                            aList1[oList1:nAt,38]}}
                            /*aList1[oList1:nAt,15],;
                            aList1[oList1:nAt,18],;
                            aList1[oList1:nAt,19]}}*/

oList1:refresh()
oDlg1:refresh()

Return 

/*/{Protheus.doc} A900GetMV
	GetMV
	@type  Static Function
	@author g.moreira
	@since 10/04/2023
/*/
Static Function A900GetMV(nTipo, cParam, lHelp, xDefault, cFilMv)
	Local xRet := Nil
	If nTipo == 1
		xRet := GetMv(cParam, lHelp, xDefault)
	Else
		xRet := SuperGetMv(cParam, lHelp, xDefault, cFilMv)
	EndIf
Return xRet


/*/{Protheus.doc} MR900ImpS1
	busca saldo inicial na data informada
	@type  Static Function
	@author g.moreira
	@since 10/04/2023
/*/
Static Function MR900ImpS1(aSalAtu,cAliasTop,lQuery,cLocIn)

Local aArea     := GetArea()
Local i         := 0
Local nIndice   := 0
Local aSalAlmox := {}
Local cSeek     := ""
Local cFilBkp   := cFilAnt
Local cTrbSB2	:= CriaTrab(,.F.)
Local lSB2Mode  := .F.
Local lCusRep      := SuperGetMv("MV_CUSREP",.F.,.F.) .And. MA330AvRep()

Default lQuery   := .F.
Default cAliasTop:="SB1"
Default lCusFil  := .t.
default lCusEmp  := .F.
Default aFils    := {}

mv_par17 := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o Saldo Inicial do Produto             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusFil
	aArea:=GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1) //dDtAt
	dbSeek(cSeek:=xFilial("SB2") + If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD)+cLocIn)
	While !Eof() .And. B2_FILIAL+B2_COD+B2_LOCAL == cSeek
		aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,dDtDe,,, ( lCusRep .And. mv_par17==2 ) )
		For i:=1 to Len(aSalAtu)
			aSalAtu[i] += aSalAlmox[i]
		Next i
		dbSkip()
	End
	RestArea(aArea)
ElseIf lCusEmp
	aArea	 := GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1)
	nIndice := RetIndex("SB2")
	dbSetOrder(nIndice+1)
	dbSeek(cSeek:=If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD)+cLocIn)
	While !Eof() .And. SB2->B2_COD+cLocIn == cSeek
		If !Empty(xFilial("SB2"))
			cFilAnt := SB2->B2_FILIAL
		Else
			lSB2Mode := .T.
		EndIf
		If (!lSB2Mode .And. aScan(aFils, {|x| AllTrim(cFilAnt) $  AllTrim(x) }) > 0) .Or. lSB2Mode
			aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,,( lCusRep .And. mv_par17==2 ) )
			For i:=1 to Len(aSalAtu)
				aSalAtu[i] += aSalAlmox[i]
			Next i
		EndIf
		dbSkip()
	End
	dbSelectArea("SB2")
	If !Empty(cTrbSB2) .And. File(cTrbSB2 + OrdBagExt())
		RetIndex("SB2")
		Ferase(cTrbSB2+OrdBagExt())
	EndIf
	cFilAnt := cFilBkp
	RestArea(aArea)
Else
	aSalAtu := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),mv_par08,mv_par05,,, ( lCusRep .And. mv_par17==2 ) )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o Custo de Reposicao do Produto        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusRep .And. mv_par17==2
	aSalAtu := {aSalAtu[1],aSalAtu[18],aSalAtu[19],aSalAtu[20],aSalAtu[21],aSalAtu[22],aSalAtu[07]}
EndIf

dbSelectArea("SB2")
MsSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))


RestArea(aArea)

RETURN

/*/{Protheus.doc} XJESTM2       
Retorno consulta padrão do campo codigo do inventário
@type user function
@author user
@since 22/08/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function XJESTM2()

Local cQuery 
Local aRet  :=  {}
Local lRet  := .T.
Local oDlg2,oSay1,oGrp1,oBtn1,oBtn2,oLista

cQuery := "SELECT ZPE_CODIGO, ZPE_CODUSU, ZPE_DATA, R_E_C_N_O_ AS RECNOZPE"
cQuery += " FROM "+RetSqlName("ZPE")+" AS main"
cQuery += " WHERE D_E_L_E_T_ = ' ' AND main.ZPE_FILIAL='"+xFilial("ZPE")+"'"
cQuery += "   AND R_E_C_N_O_ = ("
cQuery += "       SELECT MAX(sub.R_E_C_N_O_) "
cQuery += "       FROM "+RetSqlName("ZPE")+" AS sub "
cQuery += "       WHERE sub.ZPE_CODIGO = main.ZPE_CODIGO "
cQuery += "         AND sub.D_E_L_E_T_ = ' ' AND sub.ZPE_FILIAL='"+xFilial("ZPE")+"')"
cQuery += " ORDER BY ZPE_CODIGO"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTM002.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    Aadd(aRet,{TRB->ZPE_CODIGO,UsrRetName(TRB->ZPE_CODUSU),stod(TRB->ZPE_DATA),TRB->RECNOZPE})
    Dbskip()
EndDo 

If len(aRet) > 0
    oDlg2      := MSDialog():New( 269,536,608,1040,"Consulta",,,.F.,,,,,,.T.,,,.T. )
    oSay1      := TSay():New( 004,104,{||"Selecione"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGrp1      := TGroup():New( 016,016,136,228,"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{024,020,128,224},,, oGrp1 ) 

    oLista    := TCBrowse():New(024,020,210,110,, {'Codigo','Inventariante','Data'},;
                                        {40,90,40},;
                                        oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*editped(oList1:nAt,1)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oLista:SetArray(aRet)
        oLista:bLine := {||{aRet[oLista:nAt,01],;
                            aRet[oLista:nAt,02],;
                            aRet[oLista:nAt,03]}}

    oBtn1      := TButton():New( 144,064,"Confirmar",oDlg2,{||oDlg2:end(nOpcao:=oLista:nAt)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 144,144,"Cancelar",oDlg2,{||oDlg2:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

    oDlg2:Activate(,,,.T.)

    If nOpcao <> 0
        DbSelectArea("ZPE")
        DbGoto(aRet[nOpcao,04])
    Endif 
else 
    MsgAlert("Não há itens a serem apresentados")
    lRet := .F.
EndIf 

Return(lRet)

/*/{Protheus.doc} PreaList(cCodInv)
    Preenche array com o inventário ja cadastrado.
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
Static Function PreaList(cCodInv,nContag,lRel)

Local aArea := GetArea()
Local cQuery 
Local cCodUsr := ''
Local lCusRep      := SuperGetMv("MV_CUSREP",.F.,.F.) .And. MA330AvRep()

mv_par17 := 1

aList1 := {}

cQuery := "SELECT ZPE.R_E_C_N_O_ AS RECZPE,B1_ZMARCA,ZPM_DESC,B1_LOCPAD,B1_DESC,B1_COD,B1_XCODPAI,B1_FABRIC,ZPE.* "
cQuery += " FROM "+RetSqlName("ZPE")+" ZPE "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=ZPE_PRODUT AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSqlName("ZPM")+" ZPM ON ZPM_FILIAL='"+xFilial("ZPM")+"' AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
cQuery += " WHERE ZPE_FILIAL = '"+xFilial("ZPE")+"' "
cQuery += " AND ZPE_CODIGO = '"+cCodInv+"' "
cQuery += " AND ZPE.D_E_L_E_T_= ' ' "

If !lRel 
    If nContag <> 4
        cQuery += " AND ZPE_FLAGOK <> '1' " 

        If nContag > 1
            cQuery += " AND ZPE_STATUS = '"+cvaltochar(nContag-1)+" ' " 
        EndIf 
    EndIf 
EndIf 

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTM002.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    /* If val(TRB->ZPE_STATUS)+1 <> nContag .And. val(TRB->ZPE_STATUS) <> 3 .And. nContag <> 4
        MsgAlert("Número da digitação informada é inválido, a contagem para este Acuracidade atual é a numero "+cvaltochar(val(TRB->ZPE_STATUS)+1))
        exit
    EndIf */ 
    
    If Empty(cHrCnt)
        If nContag == 1 .And. !Empty(TRB->ZPE_HRCNT1)
            cHrCnt := TRB->ZPE_HRCNT1
            dDtCnt := TRB->ZPE_DTCNT1
        ElseIf nContag == 2 .And. !Empty(TRB->ZPE_HRCNT2)
            cHrCnt := TRB->ZPE_HRCNT2
            dDtCnt := TRB->ZPE_DTCNT2
        ElseIf nContag == 3 .And. !Empty(TRB->ZPE_HRCNT3)
            cHrCnt := TRB->ZPE_HRCNT3
            dDtCnt := TRB->ZPE_DTCNT3
        EndIf 
    EndIf 

    aSldData := CalcEst(TRB->B1_COD,TRB->ZPE_LOCAL,dDtCnt+1,,, ( lCusRep .And. mv_par17==2 ) )

    cCodUsr := TRB->ZPE_CODUSU
    
    If Empty(TRB->B1_XCODPAI)
        cPrat := Posicione("SBE",10,xFilial("SBE")+TRB->B1_COD+TRB->ZPE_LOCAL,"BE_LOCALIZ")
    Else 
        cPrat := Posicione("SBE",10,xFilial("SBE")+TRB->B1_XCODPAI+TRB->ZPE_LOCAL,"BE_LOCALIZ")
    EndIf

    cVlrCm := Posicione("SB2",1,xFilial("SB2")+TRB->ZPE_PRODUT+TRB->ZPE_LOCAL,"B2_CM1")

    Aadd(aList1,{   .T.,;                           //1
                    TRB->ZPE_LOCAL,;                //2
                    cPrat,;                         //3
                    TRB->ZPE_PRODUT,;               //4
                    TRB->B1_DESC,;                  //5
                    TRB->ZPM_DESC,;                 //6
                    TRB->B1_FABRIC,;                //7
                    TRB->ZPE_SLDINI,;               //8
                    TRB->ZPE_QTDENT,;               //9
                    TRB->ZPE_QTDSAI,;               //10
                    TRB->ZPE_SLDFIM,;               //11
                    TRB->ZPE_CONTA1,;               //12
                    TRB->ZPE_CONTA2,;               //13
                    TRB->ZPE_CONTA3,;               //14
                    TRB->ZPE_RESULT,;               //15 TRB->ZPE_RESULT  0
                    TRB->RECZPE,;                   //16
                    TRB->ZPE_STATUS,;               //17
                    cVlrCm*TRB->ZPE_RESULT,;        //18 cVlrCm*TRB->ZPE_RESULT 0
                    If(nContag>3,3,(TRB->ZPE_RESULT * &('TRB->ZPE_CONTA'+cvaltochar(nContag)))/100),; //19
                    TRB->ZPE_DTCNT1,;               //20
                    TRB->ZPE_HRCNT1,;               //21
                    TRB->ZPE_DTCNT2,;               //22
                    TRB->ZPE_HRCNT2,;               //23
                    TRB->ZPE_DTCNT3,;               //24
                    TRB->ZPE_HRCNT3,;               //25
                    TRB->ZPE_QTDEN2,;               //26
                    TRB->ZPE_QTDSA2,;               //27
                    TRB->ZPE_QTDFI2,;               //28
                    TRB->ZPE_QTDEN3,;               //29
                    TRB->ZPE_QTDSA3,;               //30
                    TRB->ZPE_QTDFI3,;               //31
                    .f.            ,;               //32
                    if(nContag==1,aSldData[1],TRB->ZPE_SLDCN1),;  //33
                    if(nContag==2,aSldData[1],TRB->ZPE_SLDCN2),;  //34
                    if(nContag==3,aSldData[1],TRB->ZPE_SLDCN3),;  //35
                    TRB->ZPE_QTDFI1,;                             //36
                    TRB->ZPE_QTDFI2,;                             //37
                    TRB->ZPE_QTDFI3})                             //38
    Dbskip()
EndDo 


If len(aList1) < 1
    Aadd(aList1,{.f.,'','','','','','','','','','','','','','',0,'','','','','','','','','','','','','','','',.f.,'','','','','',''})
Else 
    oSay2:settext("")
    oSay4:settext("")
    oSay2:settext(cCodInv)
    oSay4:settext(FwGetUserName(cCodUsr))                                                                                              
EndIf 

                    
oList1:SetArray(aList1)
oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,07],;
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09],;
                            aList1[oList1:nAt,10],;
                            aList1[oList1:nAt,11],;
                            aList1[oList1:nAt,33],;
                            aList1[oList1:nAt,12],;
                            aList1[oList1:nAt,36],;
                            aList1[oList1:nAt,34],;
                            aList1[oList1:nAt,13],;
                            aList1[oList1:nAt,37],;
                            aList1[oList1:nAt,35],;
                            aList1[oList1:nAt,14],;
                            aList1[oList1:nAt,38]}}
                            /*aList1[oList1:nAt,15],;
                            aList1[oList1:nAt,18],;
                            aList1[oList1:nAt,19]}}*/
                    //aList1[oList1:nAt,If(nContag == 1,11,If(nContag==2,28,31))],;
                    /*aList1[oList1:nAt,If(nContag == 1,09,If(nContag==2,26,29))],;
                    aList1[oList1:nAt,If(nContag == 1,10,If(nContag==2,27,30))],;
                    aList1[oList1:nAt,If(nContag == 1,11,If(nContag==2,28,31))],;*/

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} GravPrInv
description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/


Static Function GravPrInv(nLinha,lEncerra)

Local aArea := GetArea()

If aList1[nLinha,17] == 'F'
    Return 
EndIf 

DbSelectArea("ZPE")

If lNewInv
    Reclock("ZPE",.T.)
    ZPE->ZPE_FILIAL := xFilial("ZPE")
    ZPE->ZPE_CODIGO := cCodInv
    ZPE->ZPE_CODUSU := RetCodUsr()
    ZPE->ZPE_LOCAL  := aList1[nLinha,02]
    ZPE->ZPE_PRATEL := aList1[nLinha,03]
    ZPE->ZPE_PRODUT := aList1[nLinha,04]
    ZPE->ZPE_SLDINI := aList1[nLinha,08]
    ZPE->ZPE_QTDENT := aList1[nLinha,09]
    ZPE->ZPE_QTDSAI := aList1[nLinha,10]
    ZPE->ZPE_SLDFIM := aList1[nLinha,11]
    ZPE->ZPE_STATUS := '0'
    ZPE->ZPE_DATA   := DDATABASE
    ZPE->ZPE_HRSLF1 := cvaltochar(time())
Else 
    Dbgoto(aList1[nLinha,16])
    Reclock("ZPE",.F.)
    ZPE->ZPE_CONTA1 := aList1[nLinha,12]
    ZPE->ZPE_CONTA2 := aList1[nLinha,13]
    ZPE->ZPE_CONTA3 := aList1[nLinha,14]
    ZPE->ZPE_RESULT := aList1[nLinha,15]

    If lEncerra
        ZPE->ZPE_STATUS := cvaltochar(nContag)
    EndIf 
/*
    ZPE->ZPE_QTDEN2 := If(valtype(aList1[nLinha,26])<>"N",val(aList1[nLinha,26]),aList1[nLinha,26])
    ZPE->ZPE_QTDSA2 := If(valtype(aList1[nLinha,27])<>"N",val(aList1[nLinha,27]),aList1[nLinha,27])
    ZPE->ZPE_QTDFI2 := If(valtype(aList1[nLinha,28])<>"N",val(aList1[nLinha,28]),aList1[nLinha,28])
    ZPE->ZPE_QTDEN3 := If(valtype(aList1[nLinha,29])<>"N",val(aList1[nLinha,29]),aList1[nLinha,29])
    ZPE->ZPE_QTDSA2 := If(valtype(aList1[nLinha,30])<>"N",val(aList1[nLinha,30]),aList1[nLinha,30])
    ZPE->ZPE_QTDFI2 := If(valtype(aList1[nLinha,31])<>"N",val(aList1[nLinha,31]),aList1[nLinha,31])
 */   
    ZPE->ZPE_SLDCN1 := aList1[nLinha,33]
    ZPE->ZPE_SLDCN2 := aList1[nLinha,34]
    ZPE->ZPE_SLDCN3 := aList1[nLinha,35]
    ZPE->ZPE_QTDFI1 := aList1[nLinha,36]
    ZPE->ZPE_QTDFI2 := aList1[nLinha,37]
    ZPE->ZPE_QTDFI3 := aList1[nLinha,38]

    If nContag == 1 
        If ZPE->ZPE_QTDFI1 == 0 .And. lEncerra
            ZPE->ZPE_FLAGOK := '1'
        Else 
            ZPE->ZPE_FLAGOK := '0'
        EndIF

        If Empty(ZPE->ZPE_HRCNT1)
            ZPE->ZPE_DTCNT1 := dDtCnt // ddatabase
            ZPE->ZPE_HRCNT1 := cHrCnt //cvaltochar(time())
        EndIf 
    ElseIf nContag == 2 

        If ZPE->ZPE_QTDFI2 == 0 .And. lEncerra
            ZPE->ZPE_FLAGOK := '1'
        Else 
            ZPE->ZPE_FLAGOK := '0'
        EndIF

        If Empty(ZPE->ZPE_HRCNT2)
            ZPE->ZPE_DTCNT2 := dDtCnt //ddatabase
            ZPE->ZPE_HRCNT2 := cHrCnt //cvaltochar(time())
        EndIf 
    ElseIf nContag == 3 
        
        If ZPE->ZPE_QTDFI3 == 0 .And. lEncerra
            ZPE->ZPE_FLAGOK := '1'
        Else 
            ZPE->ZPE_FLAGOK := '0'
        EndIF

        If Empty(ZPE->ZPE_HRCNT3)
            ZPE->ZPE_DTCNT3 := dDtCnt //ddatabase
            ZPE->ZPE_HRCNT3 := cHrCnt //cvaltochar(time())
        EndIf 
    EndIf 

    
EndIf 

aList1[nLinha,16] := Recno()

ZPE->(Msunlock())

RestArea(aArea)

Return


/*/{Protheus.doc} GeraPlan
description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function GeraPlan()

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Contagem"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
Local cInterno  :=  'Contagem'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cInterno) 
oExcel:AddTable (cInterno,cInterno)

For nX := 1 to len(aHeader[1])
    oExcel:AddColumn(cInterno,cInterno,aHeader[1,nX],1,1)
Next nX


For nX := 1 to len(aAuxExc)
    aAux := {}
    For nY := 1 to len(aHeader[1])
        Aadd(aAux,aAuxExc[nX,nY])
    Next nY

    oExcel:AddRow(cInterno,cInterno,aAux)
Next nX


oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	    
Return(cDir+cArqXls)

/*/{Protheus.doc} GeraConf
    Gera relatório de conferência de inventário.
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraConf()

Local oReport

Private nTamCod    := 500

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

oReport:= ReportDef()
oReport:PrintDialog()

return
/*/{Protheus.doc} GeraConf
    Gera relatório de conferência de inventário.
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static function ReportDef()

Local oReport
//Local oSection1
Local cPicD1Qt     := PesqPict("SD1","D1_QUANT" ,18)
Local cPicD1Cust   := PesqPict("SD1","D1_CUSTO",18)
Local cPicD2Qt     := PesqPict("SD2","D2_QUANT" ,18)
Local cPicB2Cust   := PesqPict("SB2","B2_CM1",18)


oReport:= TReport():New("JESTM002","Conferência","", {|oReport| ReportPrint(oReport)},"Conferência de Acuracidade")
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)  

oSection0 := TRSection():New(oReport,'Conferência',{"SD1","SD2","SD3"}) //"Movimentação dos Produtos"
//oSection0 :SetTotalInLine(.F.)
//oSection0 :SetReadOnly()
//oSection0 :SetLineStyle()

TRCell():New(oSection0, 'B1_LOCPAD'     , " ", 'Local'         	, /*Picture*/,  5   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "B1_COD"        , " ", 'Prateleira'		, /*Picture*/, 10   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "B1_COD"    	, " ", 'Produto'		, /*Picture*/, 15   , /*lPixel*/, )
TRCell():New(oSection0, "B1_DESC"   	,""  ,'Descrição'      , /*Picture*/, 35   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "B1_XMARCA"   	, " ", 'Marca'          , /*Picture*/, 15   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "B1_COD"  		, " ", 'Cod.Original'   , /*Picture*/, 17   , /*lPixel*/, )
TRCell():New(oSection0, "D1_QTD"  		, " ", 'Saldo Inicial'  , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD"  		, " ", 'Entradas'       , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD"  		, " ", 'Saídas'         , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Saldo Final'    , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Saldo Cnt 1'    , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Contagem 1'     , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Diverg. 1'      , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Saldo Cnt 2'    , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Contagem 2'     , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Diverg. 2'      , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Saldo Cnt 3'    , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Contagem 3'     , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "D1_QTD" 		, " ", 'Diverg. 3'      , /*Picture*/, 11   , /*lPixel*/, /*{|| code-block de impressao }*/)

oSection1 := TRSection():New(oSection0,'Conferência',{"SD1","SD2","SD3"}) //"Movimentação dos Produtos"


TRCell():New(oSection1, "cLocal"    	, " ", ''       	, "@!"       , 5   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "cPrateleira"   , " ", ''			, /*Picture*/, 10      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "cProduto"   	, " ", ''			, /*Picture*/, 15    , /*lPixel*/, )
TRCell():New(oSection1, "cDescric" 		,"SB1",''           , /*Picture*/, 35         , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "cMarca"   		, " ", ''           , "@!"       , 15   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "cCodOri"  		, " ", ''	        , /*Picture*/, 17             , /*lPixel*/, )
TRCell():New(oSection1, "nENTQtd"  		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nENTCus"  		, " ", ''           , cPicD2Qt   , 11    , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nSAIQtd"  		, " ", ''           , cPicD2Qt   , 11    , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nSALDQtd" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nSldI1" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nCont1" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nDivg1" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nSldI2" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nCont2" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nDivg2" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nSldI3" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nCont3" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nDivg3" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
//TRCell():New(oSection1, "nDiverg" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)

oSection1:SetHeaderPage()
//oSection1 :SetTotalInLine(.F.)
//oSection1 :SetReadOnly()
//oSection1 :SetLineStyle()

Return(oReport)

/*/{Protheus.doc} GeraConf
    Gera relatório de conferência de inventário.
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
static function ReportPrint(oReport)

Local nSldDia

Local oSection0 := oReport:Section(1)
Local oSection1 := oReport:Section(1):Section(1)
Local aListBkp  := aList1 

aList1 := {}

PreaList(cCodInv,nContag,.T.)

oSection0:Init()

oSection0:PrintLine()
oSection0:Finish()

oSection1:Init()

For nSldDia := 1 to len(aList1)
    oSection1:Cell("cLocal"):SetValue(aList1[nSldDia,02])
    oSection1:Cell("cPrateleira"):SetValue(Avkey(aList1[nSldDia,03],"B1_COD")) 
    oSection1:Cell("cProduto"):SetValue(aList1[nSldDia,04])
    oSection1:Cell("cDescric"):SetValue(aList1[nSldDia,05])
    oSection1:Cell("cMarca"):SetValue(aList1[nSldDia,06])
    oSection1:Cell("cCodOri"):SetValue(aList1[nSldDia,07])
    oSection1:Cell("nENTQtd"):SetValue(aList1[nSldDia,08])
    oSection1:Cell("nENTCus"):SetValue(aList1[nSldDia,09])
    oSection1:Cell("nSAIQtd"):SetValue(aList1[nSldDia,10])
    oSection1:Cell("nSALDQtd"):SetValue(aList1[nSldDia,11])
    oSection1:Cell("nSldI1"):SetValue(aList1[nSldDia,33])
    oSection1:Cell("nCont1"):SetValue(aList1[nSldDia,12])
    oSection1:Cell("nDivg1"):SetValue(aList1[nSldDia,36])
    oSection1:Cell("nSldI2"):SetValue(aList1[nSldDia,34])
    oSection1:Cell("nCont2"):SetValue(aList1[nSldDia,12])
    oSection1:Cell("nDivg2"):SetValue(aList1[nSldDia,37])
    oSection1:Cell("nSldI3"):SetValue(aList1[nSldDia,35])
    oSection1:Cell("nCont3"):SetValue(aList1[nSldDia,12])
    oSection1:Cell("nDivg3"):SetValue(aList1[nSldDia,38])
    //oSection1:Cell("nDiverg"):SetValue(aList1[nSldDia,15])

    oSection1:PrintLine()
Next


aList1 := aListBkp

oReport:EndPage()

Return 

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 08/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function validPla()

Local cArqAux 
Local aAux      :=  {}
Local aRet      :=  {}
Local nCont     :=  0
Local nTamLin   :=  0
Local aPergs    := {}
Local aRetP     := {}
Local nY        :=  0
Local lOk       := .T.

If nContag == 4 
    Return 
Endif 

nContag   :=  0

cArqAux := cGetFile( '*.csv|*.csv',; //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         'C:\',;                            //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)   
                                                           //[ lArvore] 
oFile := FwFileReader():New(cArqAux)

If (oFile:Open())

    If Empty(cCodInv)
        aAdd(aPergs ,{1,"Código da Acuracidade:"	,space(TamSx3("ZPE_CODIGO")[1]),"@!",".T.","ZPE",".T.",70,.F.})

        If ParamBox(aPergs ,"Filtrar por",@aRetP)    
        
            cCodInv := aRetP[1]
            
            DbSelectArea("ZPE")
            dbSetOrder(1)
            If !Dbseek(xFilial("ZPE")+cCodInv)
                MsgAlert("Acuracidade inexistente, verifique!!!")
                Return 
            endIf 

        EndIf 
    endIf 

    aAux := oFile:GetAllLines()
     
    For nCont := 1 to len(aAux)
        Aadd(aRet,Separa(aAux[nCont],";"))
        If nCont == 1
            nTamLin := len(aRet[1])
        Else 
            If len(aRet[len(aRet)]) <> nTamLin
                aRet := {}
                Return
            EndIf
        EndIf
    Next nCont

    nY := Ascan(aret,{|x| x[1] == "Local"})

    DBSelectArea("ZPE")
    dbSetOrder(2)
    For nCont := nY+1 to len(aRet)
        If !Dbseek(xFilial("ZPE")+cCodInv+aRet[nCont,03])
            MsgAlert("Erro na linha "+cvaltochar(nCont)+" - Produto não se encontra na Acuracidade")
            lOk := .F.
            exit 
        EndIf 
        
    Next nCont
    
    If lOk 
        DBSelectArea("ZPE")
        dbSetOrder(2)
        For nCont := nY+1 to len(aRet)
            If Dbseek(xFilial("ZPE")+cCodInv+aRet[nCont,03])
                nContag := 0

                Reclock("ZPE",.F.) 
                ZPE->ZPE_CONTA1 := val(aRet[nCont,07])
                ZPE->ZPE_CONTA2 := val(aRet[nCont,08])
                ZPE->ZPE_CONTA3 := val(aRet[nCont,09])
                
                If !Empty(aRet[nCont,07])
                    ZPE->ZPE_DTCNT1 := ddatabase
                    ZPE->ZPE_HRCNT1 := cvaltochar(time())
                    nContag++
                EndIF 

                If !Empty(aRet[nCont,08])
                    ZPE->ZPE_DTCNT2 := ddatabase
                    ZPE->ZPE_HRCNT2 := cvaltochar(time())
                    nContag++
                EndIF 

                If !Empty(aRet[nCont,09])
                    ZPE->ZPE_DTCNT3 := ddatabase
                    ZPE->ZPE_HRCNT3 := cvaltochar(time())
                    nContag++
                EndIF 

                ZPE->ZPE_STATUS := cvaltochar(nContag)

                ZPE->(Msunlock())
            EndIf

            nPosL1 := Ascan(aList1,{|x| Alltrim(x[4]) == Alltrim(aRet[nCont,03])})

            IF nPosL1 > 0
                aList1[nPosL1,12] := val(aRet[nCont,07])
                aList1[nPosL1,13] := val(aRet[nCont,08])
                aList1[nPosL1,14] := val(aRet[nCont,09])
                aList1[nPosL1,15] := If(nContag==1,val(aRet[nCont,07]),If(nContag==2,val(aRet[nCont,08]),val(aRet[nCont,09]))) - aList1[nPosL1,11]
            EndIf 

        Next nCont 
    EndIF 
    
    oList1:refresh()
    oDlg1:refresh()
    
Else 
    MsgAlert("Não foi possível abrir o arquivo selecionado!!!")
EndIf 

Return(aRet)


/*/{Protheus.doc} exclZPE
    Excluir inventário rotativo
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
Static Function exclZPE()

Local aArea := GetArea()
Local aPergs := {}
Local aRet   := {}
Local cCodigo:= ''

aAdd(aPergs ,{1,"Código:"	,space(TamSx3("ZPE_CODIGO")[1]),"@!",".T.","ZPE",".T.",70,.F.})

If ParamBox(aPergs ,"Informe o código",@aRet)    
    cCodigo := aRet[1]

    DbSelectArea("ZPE")
    DbSetOrder(1)
    If Dbseek(xFilial("ZPE")+cCodigo)
        While !EOF() .And. ZPE->ZPE_CODIGO == cCodigo .And. ZPE->ZPE_FILIAL == xFilial("ZPE")
            Reclock("ZPE",.F.)
            ZPE->(DBDelete())
            ZPE->(Msunlock())

            Dbskip()
        EndDo 

        MsgAlert("Finalizado")
    EndIf 

    aList1 := {}

    If len(aList1) < 1
        Aadd(aList1,{.f.,'','','','','','','','','','','','','','',0,'','','','','','','','','','','','','','','',.f.,'','','','','',''})
    Else 
        oSay2:settext("")
        oSay4:settext("")
    EndIf 

                    
    oList1:SetArray(aList1)
    oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,07],;
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09],;
                            aList1[oList1:nAt,10],;
                            aList1[oList1:nAt,11],;
                            aList1[oList1:nAt,33],;
                            aList1[oList1:nAt,12],;
                            aList1[oList1:nAt,36],;
                            aList1[oList1:nAt,34],;
                            aList1[oList1:nAt,13],;
                            aList1[oList1:nAt,37],;
                            aList1[oList1:nAt,35],;
                            aList1[oList1:nAt,14],;
                            aList1[oList1:nAt,38]}}
                            /*aList1[oList1:nAt,15],;
                            aList1[oList1:nAt,18],;
                            aList1[oList1:nAt,19]}}*/
                    
                        /* aList1[oList1:nAt,If(nContag == 1,09,If(nContag==2,26,29))],;
                        aList1[oList1:nAt,If(nContag == 1,10,If(nContag==2,27,30))],;
                        aList1[oList1:nAt,If(nContag == 1,11,If(nContag==2,28,31))],; */
                        
                    
    oList1:refresh()
    oDlg1:refresh()

EndIf 

RestArea(aArea)

Return
