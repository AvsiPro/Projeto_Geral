#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
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

User Function ROBFAT05

Local nOpc,nX   := 0
Local lOk       := .F.
Local aStatCm   := {'0=Selecione',;
                    '1=Conferido',;
    '2=Bloquear p/ inadimplência',;
             '3=Aguardar cliente',;
         '4=Liberar para estoque',;
                    '5=Impresso',;
                     '6=Cancelado'}
Local aStatCm2  := {'1=Informacoes cadastrais',;
                         '2=Limite de credito',;
                         '3=Boletos em atraso',;
                            '4=Aguardando blu',;
                            '5=Aguardando pix',;
                            '6=Aguardando chq',;
                  '7=Aguardando representante',;
                                    '8=Serasa',;
                                     '9=Outros'}
Local aParam    := { { 2, "Status Comissao", 1, aStatCm, 60, , .T. } }
Local aParam2   := { { 2, "Informacao Complementar", 1, aStatCm2, 120, , .T. } }
Local cBloqueia := ""
Local cStat     :=  ''
SetPrvt("oDlg1","oGrp1","oGrp2","oFld1","oSay1","oSay2")
SetPrvt("oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14")
SetPrvt("oSay16","oSay17","oBtn1","oBtn2")
Private oList1
Private oList2
Private oList3
Private oList4
Private oList5
Private aList1   := {}
Private aList2   := {}
Private aList3   := {}
Private aList4   := {}
Private aList5   := {}
Private cMsgObs  := StrTran(StrTran(AllTrim(SC5->C5_XOBSLIB), "<mpen>", ""), "</mpen>", "")
Private cMsgObs2 := Alltrim(SC5->C5_XOBSLIB)
Private cMsgNew  := space(1024)


If !Empty(SC5->C5_NOTA).Or.SC5->C5_LIBEROK=='E' .And. Empty(ALLTRIM(SC5->C5_BLQ))
    MsgAlert('Não é possível liberar pedido encerrado.', 'ROBFAT05')
    Return
EndIf

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)
While !EOF() .And. SC5->C5_FILIAL == SC6->C6_FILIAL .AND. SC5->C5_NUM == SC6->C6_NUM
//'Item','Codigo','Descricao','Qtd','Vlr Unit.','Valor Total','Desconto'
    Aadd(aList1,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_DESCRI,SC6->C6_QTDVEN,;
                SC6->C6_PRCVEN,SC6->C6_VALOR,SC6->C6_DESCONT})
    Dbskip()
EndDo 

DbSelectArea("SE1")
DbSetOrder(2)
DbSeek(xFilial("SE1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
While !EOF() .AND. SE1->E1_CLIENTE == SC5->C5_CLIENTE .AND. SE1->E1_LOJA == SC5->C5_LOJACLI
    Aadd(aList2,{SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_EMISSAO,;
        SE1->E1_VENCTO,SE1->E1_VENCREA,SE1->E1_VALOR,SE1->E1_SALDO,SE1->E1_BAIXA})
    Dbskip()
Enddo 

If len(aList2) < 1
    Aadd(aList2,{'','','','','','','','','',''})
EndIf 

PedidosAnt(SC5->C5_CLIENTE,SC5->C5_LOJACLI)

oDlg1      := MSDialog():New( 086,213,756,1508,"Conferências",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,008,120,632,"Observações de atendimentos do pedido",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oMGet1     := TMultiGet():New( 012,012,{|u| cMsgObs },oGrp1,316,100,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
    oMGet2     := TMultiGet():New( 012,332,{|u| If(PCount()>0,cMsgNew:=u,cMsgNew) },oGrp1,292,100,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

oGrp2      := TGroup():New( 124,008,308,632,"Dados Pedido x Dados do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oFld1      := TFolder():New( 132,012,{"Informações cadastrais","Itens Pedido","Titulos Cliente","Pedidos Anteriores","Itens Pedidos Anteriores"},{},oGrp2,,,,.T.,.F.,616,172,) 
    
    oSay1      := TSay():New( 008,008,{||"Razão Social / Nome Fantasia"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
    oSay2      := TSay():New( 008,088,{||SA1->A1_NOME},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,248,008)
    oSay3      := TSay():New( 008,348,{||SA1->A1_NREDUZ},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,256,008)
    oSay4      := TSay():New( 028,008,{||"Endereço"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay5      := TSay():New( 028,088,{||SA1->A1_END},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,256,008)
    oSay6      := TSay():New( 028,348,{||SA1->A1_BAIRRO},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,092,008)
    oSay7      := TSay():New( 028,452,{||SA1->A1_MUN},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
    oSay8      := TSay():New( 028,572,{||SA1->A1_EST},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay9      := TSay():New( 052,008,{||"Email"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay10     := TSay():New( 052,088,{||SA1->A1_EMAIL},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,256,008)
    oSay11     := TSay():New( 052,348,{||"Telefones"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay12     := TSay():New( 052,400,{||SA1->A1_DDD+'-'+SA1->A1_TEL+" / "+SA1->A1_XDDD+'-'+SA1->A1_XTELEFO},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,204,008)
    oSay13     := TSay():New( 076,008,{||"Endereço de Entrega"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
    oSay14     := TSay():New( 076,088,{||SA1->A1_ENDENT},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,260,008)
    oSay15     := TSay():New( 076,348,{||SA1->A1_BAIRROE+SA1->A1_MUNE},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,256,008)
    oSay16     := TSay():New( 104,008,{||"Observações APP"},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
    oSay17     := TSay():New( 104,088,{||SC5->C5_X_OBS},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,516,020)

    oList1:= 	TCBrowse():New(004,004,600,143,, {'Item','Codigo','Descricao','Qtd','Vlr Unit.','Valor Total','Desconto %'},;
                                                {20,60,230,35,35,35,30},;
                                        oFld1:aDialogs[2],,,,{|| /*Fhelp2(oList2:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],;
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],;
                        Transform(aList1[oList1:nAt,05],"@E 999,999,999.99"),;
                        Transform(aList1[oList1:nAt,06],"@E 999,999,999.99"),;
                        aList1[oList1:nAt,07]}}

    oList2:= 	TCBrowse():New(004,004,600,143,, {'Prefixo','Titulo','Parcela','Emissao','Vencto','Vcto. Real','Valor','Saldo','Data Baixa'},;
                                                {30,60,30,45,45,45,40,40,40},;
                                        oFld1:aDialogs[3],,,,{|| /*Fhelp2(oList2:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    
    oList2:SetArray(aList2)
    oList2:bLine := {||{aList2[oList2:nAt,01],;
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04],;
                        aList2[oList2:nAt,05],;
                        aList2[oList2:nAt,06],;
                        Transform(aList2[oList2:nAt,07],"@E 999,999,999.99"),;
                        Transform(aList2[oList2:nAt,08],"@E 999,999,999.99"),;
                        aList2[oList2:nAt,09]}}

    oList3:= 	TCBrowse():New(004,004,600,143,, {'Pedido','Emissão','Nota','Vendedor','Material PVD'},;
                                                {40,40,40,100},;
                                        oFld1:aDialogs[4],,,,{|| /*Fhelp2(oList2:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    
    oList3:SetArray(aList3)
    oList3:bLine := {||{aList3[oList3:nAt,01],;
                        aList3[oList3:nAt,02],;
                        aList3[oList3:nAt,03],;
                        aList3[oList3:nAt,04],;
                        aList3[oList3:nAt,05]}}

    oList4:= 	TCBrowse():New(004,004,600,143,, {'Pedido','Item','Codigo','Descricao','Qtd','Vlr Unit.','Valor Total','Desconto %'},;
                                                {30,20,60,230,35,35,35,30},;
                                        oFld1:aDialogs[5],,,,{|| /*Fhelp2(oList2:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    
    oList4:SetArray(aList4)
    oList4:bLine := {||{aList4[oList4:nAt,08],;
                        aList4[oList4:nAt,01],;
                        aList4[oList4:nAt,02],;
                        aList4[oList4:nAt,03],;
                        aList4[oList4:nAt,04],;
                        Transform(aList4[oList4:nAt,05],"@E 999,999,999.99"),;
                        Transform(aList4[oList4:nAt,06],"@E 999,999,999.99"),;
                        aList4[oList4:nAt,07]}}

oBtn1      := TButton():New( 312,212,"Salvar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 312,296,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpc == 1
    lOk := .F.
    While !lOk
        If ParamBox(aParam ,"Selecione uma opção",,,,.F.,420,100)
            MV_PAR01 := IIF(VALTYPE(MV_PAR01) != 'N',VAL(MV_PAR01),MV_PAR01)
            If MV_PAR01 <> 0
                lOk := .T.
            EndIf 
        EndIf
    ENDDO

    // '0=Selecione','1=Conferido'
    // '2=Bloquear p/ inadimplência'
    // '3=Aguardar cliente'
    // '4=Liberar para estoque'
    cStatus := ''
    cStaOpc := ''
    If MV_PAR01 == 1
        cStatus := 'A'
        cStaOpc := 'Pedido Conferido'
    ElseIf MV_PAR01 == 2
        cStatus := 'B'
        cStaOpc := 'Bloqueio Inadimplência'
    ElseIf MV_PAR01 == 3
        cStatus := 'C'
        cStaOpc := 'Aguardando resposta cliente'

        If ParamBox(aParam2, "Informe o motivo da pendencia!")
            MV_PAR01 := IIF(VALTYPE(MV_PAR01) != 'N',VAL(MV_PAR01),MV_PAR01)
        Else 
            Return
        EndIf

    ElseIf MV_PAR01 == 4
        cStatus := 'H'
        cStaOpc := 'Liberado para estoque'
    ElseIf MV_PAR01 == 5
        cStatus := 'F'
        cStaOpc := 'Impresso'
    ElseIf MV_PAR01 == 6
        cStatus   := 'G'
        cStaOpc   := 'Cancelado'
        cBloqueia := '1'
    EndIf
//053037
    cMsgGrv := 'Data '+cvaltochar(dDatabase)+' Hora '+cvaltochar(time())+CRLF
    cMsgGrv += 'Usuário '+cusername+CRLF 
    cMsgGrv += 'Opção selecionada '+cStaOpc+CRLF
    
    If cStatus == 'C'
        cMsgGrv += 'Motivo de pendencia <mpen>'+SubStr(aStatCm2[MV_PAR01],3)+'</mpen>'+CRLF
    Else

        cAuxObs := FwCutOff(cMsgObs2)
        For nX := 1 To len(cAuxObs)

            If At("<mpen>",  cAuxObs, nX) != 0
                nPosIni  := At("<mpen>",  cAuxObs, nX)
                nPosFim  := At("</mpen>",  cAuxObs, nX) + Len("</mpen>")
                nLeitura := nPosFim - nPosIni

                cStat    := SubStr(cAuxObs, nPosIni, nLeitura)
            EndIf
        Next nX

        If !Empty(cStat)
            cMsgGrv += 'Motivo de pendencia '+cStat +CRLF
        EndIf
    EndIf

    cMsgGrv += 'Observações anotadas '+cMsgNew+CRLF
    cMsgGrv += '--------------------------------------------'+CRLF
    
    RecLock("SC5", .F.)
        SC5->C5_XOBSLIB := Alltrim(cMsgObs2)+cMsgGrv
        SC5->C5_ZZSTATU := cStatus
        if cBloqueia != ""
            SC5->C5_MSBLQL := cBloqueia
        endif
    SC5->(MsUnlock())    
EndIf 

Return

/*/{Protheus.doc} PedidosAnt
    (long_description)
    @type  Static Function
    @author user
    @since 17/06/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function PedidosAnt(ccli,cloja)

Local aArea :=  GetArea()
Local cQuery 

cQuery := "SELECT C5_NUM,C5_EMISSAO,C5_NOTA,A3_NOME,C6_ITEM,"
cQuery += " C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_DESCONT,B1_GRUPO"
cQuery += " FROM "+RetSQLName("SC5")+ " C5"
cQuery += " INNER JOIN "+RetSQLName("SC6")+ " C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA3")+ " A3 ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+ " B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=' '"
cQuery += " WHERE C5_CLIENTE='"+ccli+"' AND C5_LOJACLI='"+cloja+"' AND C5.D_E_L_E_T_=' '"
cQuery += " AND C5_FILIAL BETWEEN ' ' AND 'ZZZ'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    nPos := Ascan(aList3,{|x| x[1] == TRB->C5_NUM})
    cAuxGr := ''
    If Alltrim(TRB->B1_GRUPO) == "9900000"
        If nPos > 0
            If !Empty(aList3[nPos,05])
                cAuxGr := ' / ' +  Alltrim(TRB->C6_DESCRI) 
            else
                cAuxGr :=  Alltrim(TRB->C6_DESCRI) 
            EndIf 
        EndIf 
    EndIf 

    If nPos == 0
        Aadd(aList3,{TRB->C5_NUM,;
                    STOD(TRB->C5_EMISSAO),;
                    TRB->C5_NOTA,;
                    TRB->A3_NOME,;
                    cAuxGr})
    else
        aList3[nPos,05] := Alltrim(aList3[nPos,05]) + cAuxGr
    EndIf 

    Aadd(aList4,{TRB->C6_ITEM,;
                TRB->C6_PRODUTO,;
                TRB->C6_DESCRI,;
                TRB->C6_QTDVEN,;
                TRB->C6_PRCVEN,;
                TRB->C6_VALOR,;
                TRB->C6_DESCONT,;
                TRB->C5_NUM})
    Dbskip()
EndDo 

If len(aList3) < 1
    Aadd(aList3,{'','','','',''})
EndIf 

If len(aList4) < 1
    Aadd(aList4,{'','','','','','',''})
EndIf 

RestArea(aArea)

Return
