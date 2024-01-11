#Include 'Protheus.ch'

/*
    Replicar Pneus

    MIT 44_PNEUS PNEU003_criacao_de_cadastro_de_pneus_com_base_em_um_ja_cadastrado_

    Doc Mit
    https://docs.google.com/document/d/1s8xV8QXObsMAKG7nH1nTinIv11RsfMws/edit

    Doc Validação entrega
    
    
    
*/

User Function JGFRA006()

Local nCont  := 1

Private aAuxX1 := FWSX3Util():GetAllFields( 'ST9' , .F. )
Private aAuxX2 := FWSX3Util():GetAllFields( 'TQS' , .F. )
Private aCabec := {}
Private aItens := {}
Private nPosFg := Ascan(aAuxX2,{|x| x == "TQS_NUMFOG"})
Private nPosSt := Ascan(aAuxX1,{|x| x == "T9_STATUS"})
Private nPosTM := Ascan(aAuxX1,{|x| x == "T9_TIPMOD"})
Private nPosBm := Ascan(aAuxX1,{|x| x == "T9_CODBEM"})
Private nPosFm := Ascan(aAuxX1,{|x| x == "T9_CODFAMI"})
Private nPosCc := Ascan(aAuxX1,{|x| x == "T9_CCUSTO"})
Private nPosBT := Ascan(aAuxX2,{|x| x == "TQS_CODBEM"})

For nCont := 1 to len(aAuxX1)
    Aadd(aCabec,{aAuxX1[nCont],&("ST9->"+aAuxX1[nCont])})
Next nCont 

DbSelectArea("TQS")
DbSetOrder(1)
DbSeek(xFilial("TQS")+ST9->T9_CODBEM)

For nCont := 1 to len(aAuxX2)
    Aadd(aItens,{aAuxX2[nCont],&("TQS->"+aAuxX2[nCont])})
Next nCont 

If len(aCabec) > 0
    xreplicar()
EndIf 

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 11/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
static Function xreplicar()

Local nOpca := 0
Local nCont
Local nX 

Private aList := {}
Private oList 

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

Private cFogIn := space(TamSX3("TQS_NUMFOG")[1])
Private cFogFi := space(TamSX3("TQS_NUMFOG")[1])


SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oGet1","oGet2","oGrp2","oBrw1","oBtn1","oBtn2")

Aadd(aList,{'','','','','','','','','','','',''})

oDlg1      := MSDialog():New( 092,232,774,1563,"Réplica de Pneus",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 004,164,072,448,"Informações",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay1      := TSay():New( 016,204,{||"Pneu Origem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
        oSay2      := TSay():New( 016,264,{||Alltrim(aCabec[nPosBm,2])+" - "+aCabec[nPosTM,2]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
    
        oSay3      := TSay():New( 036,180,{||"Número de Fogo Inicio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
        oGet1      := TGet():New( 036,352,{|u| If(Pcount()>0,cFogIn:=u,cFogIn)},oGrp1,060,008,'',{|| Processa({|| Libok(2)},"Aguarde")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
        

        oSay4      := TSay():New( 056,180,{||"Número de Fogo Fim"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
        oGet2      := TGet():New( 056,352,{|u| If(Pcount()>0,cFogFi:=u,cFogFi)},oGrp1,060,008,'',{|| Processa({|| Libok(2)},"Aguarde")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oGrp2      := TGroup():New( 076,012,308,652,"Itens a replicar",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{084,016,304,648},,, oGrp2 ) 
        oList    := TCBrowse():New(084,016,630,220,, {'Bem','Modelo','Descrição','Familia','Nome Familia','Cod. Fogo','Centro de Custo'},;
                                                        {50,50,90,50,90,50,50},;
                                                        oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| inverte(1,1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
        oList:bLine := {||{ aList[oList:nAt,01],;
                            aList[oList:nAt,02],; 
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],; 
                            aList[oList:nAt,05],;
                            aList[oList:nAt,06],;
                            aList[oList:nAt,07]}}

    oBtn1      := TButton():New( 316,196,"Confirmar",oDlg1,{||oDlg1:end(nOpca:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 316,400,"Cancelar",oDlg1,{||oDlg1:end(nOpca:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpca == 1
    For nCont := 1 to len(aList)
        DbSelectArea("ST9")
        Reclock("ST9",.T.)
    
        For nX := 1 to len(aCabec)
            If nX == nPosBm
                aCabec[nX,02] := cvaltochar(aList[nCont,01])
            EndIF 
            If nX == nPosSt 
                aCabec[nX,02] := "04"
            EndIf 

            &("ST9->"+aCabec[nX,01]) := aCabec[nX,02]
        Next nX

        ST9->(MSUNLOCK())

        DbSelectArea("TQS")
        Reclock("TQS",.T.)
        
        For nX := 1 to len(aItens)

            If nX == nPosFg
                aItens[nX,02] := cvaltochar(aList[nCont,06])
            EndIF 

            If nX == nPosBT
                aItens[nX,02] := cvaltochar(aList[nCont,01])
            EndIf 

            &("TQS->"+aItens[nX,01]) := aItens[nX,02]

        Next nX 

        TQS->(MSUNLOCK())
    Next nCont
EndIf 


Return


/*/{Protheus.doc} Libok
    Libera o botão ok para salvar o cadastro da negociação da multa.
    @type  Static Function
    @author user
    @since 04/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Libok(nOpcao)

Local nOk := 0
Local nX  := 0
Local cCodBem := ''
Local aUsados := {}
Private lTiraU := .T.


If nOpcao == 1 .or. val(cFogIn) > 0
    //cFogIn
    If !Empty(cFogIn)
        nOk++
    EndIf 
EndIf 

If nOpcao == 2 .or. val(cFogFi) > 0
    //cFogFi
    If !Empty(cFogFi)
        nOk++
    EndIf
ENDIF

If nOk == 2
    nTotal := (val(cFogFi) - val(cFogIn)) + 1
    If nTotal < 0
        MsgAlert("Número final não pode ser inferior ao inicial")
        Return 
    EndIf 

    aUsados := VerBase(cFogIn,cFogFi)

    IF nTotal <> len(aList) .And. lTiraU
        aList := {}
        cCodBem := val(cFogIn)
        
        If len(aUsados) > 0
            For nX := 1 to nTotal
            //'Bem','Modelo','Descrição','Familia','Nome Familia','Cod. Fogo','Centro de Custo'
                If Ascan(aUsados,{|x| alltrim(x) == cvaltochar(cCodBem)}) == 0
                    Aadd(aList,{cCodBem,;
                                aCabec[nPosTM,2],;
                                POSICIONE("TQR",1,XFILIAL("TQR")+ST9->T9_TIPMOD,"TQR_DESMOD"),;
                                aCabec[nPosFm,2],;
                                POSICIONE("ST6",1,XFILIAL("ST6")+ST9->T9_CODFAMI,"T6_NOME"),;
                                cCodBem,;
                                aCabec[nPosCc,2]})
                EndIf 

                cCodBem++ 
            Next nX
        Else
            For nX := 1 to nTotal
            //'Bem','Modelo','Descrição','Familia','Nome Familia','Cod. Fogo','Centro de Custo'
                
                Aadd(aList,{cCodBem,;
                            aCabec[nPosTM,2],;
                            POSICIONE("TQR",1,XFILIAL("TQR")+ST9->T9_TIPMOD,"TQR_DESMOD"),;
                            aCabec[nPosFm,2],;
                            POSICIONE("ST6",1,XFILIAL("ST6")+ST9->T9_CODFAMI,"T6_NOME"),;
                            cCodBem,;
                            aCabec[nPosCc,2]})

                cCodBem++ 
            Next nX
        EndIf  

        oList:SetArray(aList)
        oList:bLine := {||{ aList[oList:nAt,01],;
                            aList[oList:nAt,02],; 
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],; 
                            aList[oList:nAt,05],;
                            aList[oList:nAt,06],; 
                            aList[oList:nAt,07]}}
        
        oList:refresh()
        oDlg1:refresh()
    EndIf 
EndIf 

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 11/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function VerBase(cInicio,cFinal)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery := ""
Local cUsados := ""
Local cVirgula := ""

cQuery := "SELECT TQS_NUMFOG"
cQuery += " FROM "+RetSQLName("TQS")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND CAST(TQS_NUMFOG AS INT) BETWEEN '"+alltrim(cInicio)+"' AND '"+alltrim(cFinal)+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("TIINCP01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    cUsados += cVirgula + TRB->TQS_NUMFOG
    cVirgula := ","
    Aadd(aRet,TRB->TQS_NUMFOG)
    Dbskip()
EndDo 

If len(aRet) > 0
    If MsgYesNo("Número de Fogos já utilizados "+CRLF+cUsados+CRLF+"Deseja utilizar os demais?")
        lTiraU := .T.
    Else 
        lTiraU := .F.
    EndIf 
EndIf

RestArea(aArea)

Return(aRet)
