#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada na baixa de requisição ao armazém
    Localização: Function A185Gera(Gera requisicoes.) e A185GeraAut(Gera as requisicoes usando o Movimentos Modelo 2).

    Em que ponto: E chamado apos a gravação de todos os dados, inclusive apos gerar a requisição no arquivo de movimentos internos (SD3).

*/
User Function M185GRV() 
Local lRet := .T.    
Local aAux1 := aDadosCQ
Local aAux2 := {}
Local nCont := 0

DbSelectArea("SCP")

For nCont := 1 to len(aAux1)
    Dbgoto(aAux1[nCont,21])
    If SCP->CP_QUANT > aAux1[nCont,09]
        Aadd(aAux2,{aAux1[nCont,04],;
                    aAux1[nCont,05],;
                    SCP->CP_QUANT,;
                    (aAux1[nCont,09] - SCP->CP_QUANT) * (-1),;
                    "",;
                    "",;
                    aAux1[nCont,21]})
    Endif 
Next nCont 

If len(aAux2) > 0
    VendPerd(aAux2)
EndIf 

Return(lRet)

static Function VendPerd(aAux2)

Local nOpc      := 0
Local nX        := 0

Private cMotivo :=  space(2)
Private oDlg1,oGrp1,oBrw1,oGrp2,oSay1,oSay2,oGet1,oBtn1,oList
Private aList   :=  {}


For nX := 1 to len(aAux2)

    Aadd(aList,{aAux2[nX,01],;
                aAux2[nX,02],;
                aAux2[nX,03],;
                aAux2[nX,04],;
                aAux2[nX,05],;
                aAux2[nX,06],;
                aAux2[nX,07]})

Next nX 

While nOpc == 0

    oDlg1      := MSDialog():New( 092,232,640,1230,"Venda Perdida",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 016,020,192,472,"Itens não atendidos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{028,028,184,464},,, oGrp1 ) 
        oList    := TCBrowse():New(027,026,440,160,, {'Codigo','Descrição','Qtd solicitada','Qtd Nao Atendida','Motivo'},;
                                                        {60,90,60,60},;
                                                        oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| /*inverte(1,1)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
        oList:bLine := {||{ aList[oList:nAt,01],;
                            aList[oList:nAt,02],; 
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],;
                            aList[oList:nAt,05]+'-'+aList[oList:nAt,06]}}

    oGrp2      := TGroup():New( 196,020,240,472,"Motivo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

        oSay1      := TSay():New( 212,116,{||"Informe o motivo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
        oGet1      := TGet():New( 210,208,{|u| If(Pcount()>0,cMotivo:=u,cMotivo)},oGrp2,060,008,'@!',{|| TrocaMot()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZPV","",,)
        oSay2      := TSay():New( 212,284,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,176,008)

        oBtn1      := TButton():New( 248,216,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:= 1)},037,012,,,,.T.,,"",,,,.F. )
        //oBtn1:disable()
        oGet1:setfocus()
        oDlg1:lEscClose := .F.

    oDlg1:Activate(,,,.T.)
    
EndDo 

If nOpc == 1
    DbSelectArea("SCP")
    For nX := 1 to len(aList)
        DbGoto(aList[nX,07])
        Reclock("SCP",.F.)
        SCP->CP_XTIPO := aList[nX,05]
        SCP->(Msunlock())

        Reclock("ZPC",.T.)
        ZPC->ZPC_FILIAL := SCP->CP_FILIAL 
        ZPC->ZPC_CODIGO := SCP->CP_PRODUTO 
        ZPC->ZPC_REQUIS := SCP->CP_NUM 
        ZPC->ZPC_DATA   := dDatabase
        ZPC->ZPC_QUANT  := SCP->CP_QUANT 
        ZPC->ZPC_PREFIX := SCP->CP_NUM
        ZPC->ZPC_SOLICI := SCP->CP_XMATREQ
        ZPC->ZPC_STATUS := '1'
        ZPC->ZPC_ITEM   := SCP->CP_ITEM
        ZPC->ZPC_LOCAL  := SCP->CP_LOCAL
        ZPC->ZPC_ALMOXA := SCP->CP_CODSOLI
        ZPC->ZPC_TIPO   := SCP->CP_XTIPO
        ZPC->(Msunlock())
    Next nX 
EndIf 

Return

/*/{Protheus.doc} nomeStaticFunction
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
Static Function TrocaMot()

Local aArea := GetArea()
Local lRet  := .T.
Local nX    := 0

If Existcpo("ZPV",cMotivo)

    oSay2:settext("")
    
    cDesc := Posicione("ZPV",1,xFilial("ZPV")+cMotivo,"ZPV_DESCRI")
    
    If !Empty(cDesc)
        oSay2:settext(cDesc)
        If len(aList) > 1
            If MsgYesNo("Sim ==> todos os itens do grid / Não ==> Somente o item posicionado")
                For nX := 1 to len(aList)
                    aList[nX,05] := cMotivo
                    aList[nX,06] := cDesc
                Next nX 
            Else 
                aList[oList:nAt,05] := cMotivo
                aList[oList:nAt,06] := cDesc
            EndIF 
        Else 
            aList[oList:nAt,05] := cMotivo
            aList[oList:nAt,06] := cDesc
        EndIf 

        oList:SetArray(aList)
        oList:bLine := {||{ aList[oList:nAt,01],;
                            aList[oList:nAt,02],; 
                            aList[oList:nAt,03],;
                            aList[oList:nAt,04],;
                            aList[oList:nAt,05]+'-'+aList[oList:nAt,06]}}

        oList:refresh()
        oDlg1:refresh()

    Else 
        MsgAlert("Motivo não encontrado")
        lRet := .F.
    EndIf 

Else 
    MsgAlert("Informe o código para o motivo da perda de venda")
    lRet := .F.
EnDIf 

RestArea(aArea)

Return(lRet) 
