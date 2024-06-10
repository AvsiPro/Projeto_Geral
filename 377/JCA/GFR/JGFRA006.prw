#Include 'Protheus.ch'

/*
    Replicar Pneus

    MIT 44_PNEUS PNEU003_criacao_de_cadastro_de_pneus_com_base_em_um_ja_cadastrado_

    Doc Mit
    https://docs.google.com/document/d/1s8xV8QXObsMAKG7nH1nTinIv11RsfMws/edit

    Doc Validação entrega
    
    //PLACA T9_PLACA COM TQS_PLACA 
    
*/

User Function JGFRA006()

Local nCont  := 1

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

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
Private cFogIn := space(TamSX3("TQS_NUMFOG")[1])
Private cFogFi := space(TamSX3("TQS_NUMFOG")[1])
Private cStats := space(TamSX3("T9_STATUS")[1])
Private cFrota := space(TamSX3("T9_CODBEM")[1])
Private cEixo  := space(TamSX3("TQS_POSIC")[1])

Private aNotRep:= {'TQS_PLACA','TQS_NOMPAI','TQS_POSIC','TQS_EIXO','TQS_TIPEIX'}

Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oGet1,oGet2,oGrp2,oBrw1,oBtn1,oBtn2,oGrp3,oSay5,oGet3
Private oSay6,oGet4,oSay7,oGet5

Aadd(aList,{'','','','','','','','','','','',''})

oDlg1      := MSDialog():New( 092,232,744,1563,"Réplica de Pneus",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 004,164,072,448,"Informações",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay1      := TSay():New( 013,224,{||"Pneu Origem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
        oSay2      := TSay():New( 013,284,{||Alltrim(aCabec[nPosBm,2])+" - "+aCabec[nPosTM,2]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
    
        oSay3      := TSay():New( 025,180,{||"Número de Fogo Inicio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
        oGet1      := TGet():New( 025,352,{|u| If(Pcount()>0,cFogIn:=u,cFogIn)},oGrp1,060,008,'',{|| Processa({|| Libok(2)},"Aguarde")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
        oSay4      := TSay():New( 042,180,{||"Número de Fogo Fim"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
        oGet2      := TGet():New( 042,352,{|u| If(Pcount()>0,cFogFi:=u,cFogFi)},oGrp1,060,008,'',{|| Processa({|| Libok(2)},"Aguarde")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

        oSay5      := TSay():New( 059,180,{||"Status"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
        oGet3      := TGet():New( 059,352,{|u| If(Pcount()>0,cStats:=u,cStats)},oGrp1,060,008,'',{|| Processa({|| Libok(3)},"Aguarde")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"TQYFIL","",,)

    oGrp2      := TGroup():New( 076,012,288,652,"Itens a replicar",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{084,016,304,648},,, oGrp2 ) 
        oList    := TCBrowse():New(084,016,630,200,, {'Bem','Modelo','Descrição','Familia','Nome Familia','Cod. Fogo','Centro de Custo','Frota','Placa','Nome do Bem','Posição do Pneu'},;
                                                        {50,50,60,50,60,50,50,50,50,50,50},;
                                                        oGrp1,,,,{|| FHelp(oList:nAt)},{|| editcol(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
        oList:bLine := {||{ aList[oList:nAt,01],;
                            aList[oList:nAt,02],; 
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],; 
                            aList[oList:nAt,05],;
                            aList[oList:nAt,06],;
                            aList[oList:nAt,07],;
                            aList[oList:nAt,08],; 
                            aList[oList:nAt,09],;
                            aList[oList:nAt,10],;
                            aList[oList:nAt,11]}}

    oBtn1      := TButton():New( 295,196,"Confirmar",oDlg1,{||oDlg1:end(nOpca:=1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 295,400,"Cancelar" ,oDlg1,{||oDlg1:end(nOpca:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpca == 1
    If MsgYesNo("Confirma a réplica dos itens E atualização dos pneus aplicados?")
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

            If !Empty(aList[nCont,10]) .And. !Empty(aList[nCont,11])
                LimpaTQS(alltrim(aList[nCont,10]),alltrim(aList[nCont,11]))
            EndIf 

            DbSelectArea("TQS")
            Reclock("TQS",.T.)
            
            For nX := 1 to len(aItens)

                If cStats == "04"
                    //Nao replicar informações do pneu aplicado no status igual a 04
                    If Ascan(aNotRep,{|x| alltrim(x) == alltrim(aItens[nX,01])}) > 0
                        loop
                    EndIf 
                EndIf 

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
EndIf 


Return

/*/{Protheus.doc} FHelp(oList:nAt)
    Atualiza tela de acordo com a  linha do grid
    @type  Static Function
    @author user
    @since 07/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelp(nLinha)

If !Empty(aList[nLinha,08])
    cFrota := aList[nLinha,08]
Else    
    cFrota := space(TamSX3("T9_CODBEM")[1])
EndIf 

If !Empty(aList[nLinha,11])
    cEixo := aList[nLinha,11]
Else 
    cEixo  := space(TamSX3("TQS_POSIC")[1])
EndIf 

If valtype(oGet4) == "O"
    oGet4:refresh()
    oGet5:refresh()
EndIf 

oList:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} oList:nAt
    (long_description)
    @type  Static Function
    @author user
    @since 07/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha)

Local nColPos := oList:nColPos

If cStats == "01"
    If nColPos == 8 
        If Empty(aList[nLinha,08])
            aList[nLinha,08] := space(TamSX3("T9_CODBEM")[1])
        endIf 
        lEditCell(aList,oList,"@!",8)
        cFrota := aList[nLinha,08]
        If !ChgList(1)
            aList[nLinha,08] := space(TamSX3("T9_CODBEM")[1])
            cFrota := aList[nLinha,08]
        EndIF 
    ElseIf nColPos == 11
        If Empty(aList[nLinha,11])
            aList[nLinha,11] := space(TamSX3("TQS_POSIC")[1])
        EndIf 

        lEditCell(aList,oList,"@!",11)
        cEixo := aList[nLinha,11]
        If !ChgList(2)
            aList[nLinha,11] := space(TamSX3("TQS_POSIC")[1])
            cEixo := aList[nLinha,11]
        EndIf 
    EndIf 
EndIf 

oList:refresh()
oDlg1:refresh()


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

If nOpcao == 2 .or. val(cStats) > 0
    //cStats
    If !Empty(cStats)
        nOk++

        If cStats == "01"
            oGrp3      := TGroup():New( 004,464,072,568,"Aplicar Veículos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        
            oSay6      := TSay():New( 019,500,{||"Frota"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
            oGet4      := TGet():New( 029,490,{|u| If(Pcount()>0,cFrota:=u,cFrota)},oGrp1,060,008,'@!',{|| Processa({|| ChgList(1)},"Aguarde")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ST9","",,)

            oSay7      := TSay():New( 043,500,{||"Eixo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
            oGet5      := TGet():New( 053,490,{|u| If(Pcount()>0,cEixo:=u,cEixo)},oGrp1,060,008,'@!',{|| Processa({|| ChgList(2)},"Aguarde")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"TPS","",,)

        else
            If valtype(oGet4) == "O"
                oGet4:disable()
                oGet5:disable()
                oGet4:refresh()
                oGet5:refresh()
            endIf 
        Endif 
        
        oDlg1:refresh()
      
    EndIf
ENDIF

If nOk == 3

    nTotal := (val(cFogFi) - val(cFogIn)) + 1
    If nTotal < 0
        MsgAlert("Número final não pode ser inferior ao inicial")
        Return 
    EndIf 

    If Empty(aList[1,1])
        aList := {}
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
                                alltrim(POSICIONE("TQR",1,XFILIAL("TQR")+ST9->T9_TIPMOD,"TQR_DESMOD")),;
                                aCabec[nPosFm,2],;
                                alltrim(POSICIONE("ST6",1,XFILIAL("ST6")+ST9->T9_CODFAMI,"T6_NOME")),;
                                cCodBem,;
                                aCabec[nPosCc,2],;
                                '',;
                                '',;
                                '',;
                                '',;
                                ''})
                EndIf 

                cCodBem++ 
            Next nX
        Else
            For nX := 1 to nTotal
            //'Bem','Modelo','Descrição','Familia','Nome Familia','Cod. Fogo','Centro de Custo'
                
                Aadd(aList,{cCodBem,;
                            aCabec[nPosTM,2],;
                            alltrim(POSICIONE("TQR",1,XFILIAL("TQR")+ST9->T9_TIPMOD,"TQR_DESMOD")),;
                            aCabec[nPosFm,2],;
                            alltrim(POSICIONE("ST6",1,XFILIAL("ST6")+ST9->T9_CODFAMI,"T6_NOME")),;
                            cCodBem,;
                            aCabec[nPosCc,2],;
                            '',;
                            '',;
                            '',;
                            '',;
                            ''})

                cCodBem++ 
            Next nX
        EndIf  

        If len(aList) < 1
            Aadd(aList,{'','','','','','','','','','','',''})
        Endif 
        
        oList:SetArray(aList)
        oList:bLine := {||{ aList[oList:nAt,01],;
                            aList[oList:nAt,02],; 
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],; 
                            aList[oList:nAt,05],;
                            aList[oList:nAt,06],;
                            aList[oList:nAt,07],;
                            aList[oList:nAt,08],; 
                            aList[oList:nAt,09],;
                            aList[oList:nAt,10],;
                            aList[oList:nAt,11]}}
        
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
//cQuery += " AND CAST(TQS_NUMFOG AS INT) BETWEEN '"+alltrim(cInicio)+"' AND '"+alltrim(cFinal)+"'"
cQuery += " AND RTRIM(TQS_NUMFOG) BETWEEN '"+alltrim(cInicio)+"' AND '"+alltrim(cFinal)+"'"

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

/*/{Protheus.doc} ChgList
    Atualiza as informações o grid
    @type  Static Function
    @author user
    @since 07/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ChgList(nOpcao)

Local lRet      := .T.
Local cFami     := ''
Local cTipM     := ''
Local lEixos    := .F.
Local nCont     := 0
Local lOk       := .F.

If nOpcao == 1
    If !Empty(cFrota)
        If ExistCpo("ST9",cFrota)
            If !Empty(aList[oList:nAt,01])
                DbSelectArea("ST9")
                DbSetOrder(1)
                Dbseek(xfilial("ST9")+cFrota)
                aList[oList:nAt,08] := cFrota 
                aList[oList:nAt,09] := ALLTRIM(ST9->T9_NOME)
                aList[oList:nAt,10] := ST9->T9_PLACA
            EndIf 
        Else 
            MsgAlert("Veículo não encontrado")  
            cFrota := space(TamSX3("T9_CODBEM")[1])
            lRet := .F.
        endIf 
    EndIf 
Else 
    If !Empty(cEixo)
        If !Empty(cFrota)
            DbSelectArea("ST9")
            DbSetOrder(1)
            If Dbseek(xfilial("ST9")+cFrota)
                cFami := ST9->T9_CODFAMI
                cTipM := ST9->T9_TIPMOD 
                DbSelectArea("TQ1")
                DbSetOrder(1)
                If Dbseek(xFilial("TQ1")+cFami+cTipM)
                    lEixos := .T.
                EndIF 
            endIf 
        EndIf 

        If ExistCpo("TPS",cEixo)
            If !Empty(aList[oList:nAt,01])
                While !EOF() .AND. TQ1->TQ1_DESENH == cFami .AND. Alltrim(TQ1->TQ1_TIPMOD) == Alltrim(cTipM)
                    For nCont := 1 to 10
                        If alltrim(&("TQ1->TQ1_LOCPN"+cvaltochar(if(nCont==10,0,nCont)))) == alltrim(cEixo)
                            lOk := .T.
                            exit
                        EndIf     
                    Next nCont 

                    If lOk 
                        exit 
                    EndIf 
                    Dbskip()
                EndDo 

                If lOk 
                    aList[oList:nAt,11] := cEixo 
                Else 
                    MsgAlert("Eixo não cadastrado no desenho do veículo")
                    cEixo := space(TamSX3("TQS_POSIC")[1])
                    lRet := .F.
                EndIf 
            EndIf 
        Else
            MsgAlert("Eixo não cadastrado")
            cEixo := space(TamSX3("TQS_POSIC")[1])
            lRet := .F.
        EndIf  

    EndIf 
EndIf 

oList:refresh()
oDlg1:refresh()

Return(lRet)

/*/{Protheus.doc} LimpaTQS
    Limpar os itens que foram aplicados
    @type  Static Function
    @author user
    @since 10/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function LimpaTQS(cPlaca,cEixo)

Local aArea := GetArea()
Local cUpdQry 

cUpdQry := "UPDATE "+RetSQLName("TQS")
cUpdQry += " SET TQS_EIXO=' ',TQS_TIPEIX=' ',TQS_PLACA=' ',TQS_POSIC=' '"
cUpdQry += " WHERE TQS_FILIAL='"+xFilial("TQS")+"'"
cUpdQry += " AND TQS_PLACA='"+cPlaca+"' AND TQS_POSIC='"+cEixo+"'"
cUpdQry += " AND D_E_L_E_T_=' '"

TcSqlExec(cUpdQry)

RestArea(aAreA)

Return
