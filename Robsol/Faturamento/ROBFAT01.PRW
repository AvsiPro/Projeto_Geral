#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ROBFAT01 ³ Autor ³ Alexandre Venancio   ³ Data ³ 23/11/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Calculo de frete pedido de venda                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÝÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ROBFAT01
Local nX        := 0
Local nOpc      :=  0
Local aEtiqueta := {}
Local cGravObs := ''

Private aFrete  :=  {'0=Selecione','1=CIF','2=FOB','3=Terceiros'}
Private aTipoC  :=  {'1=Sedex','2=PAC'}
Private cCombo1 :=  ""
Private cCombo4 :=  ""
Private aForma  :=  {'0=Selecione','1=Rodoviario','2=Aereo','3=Maritimo'}
Private cCombo2 :=  ""
Private aEspeci :=  {'0=Selecione','1=Caixa/Pacote','2=Rolo/Prisma','3=Envelope'}
Private cCombo3 :=  ""
Private nPeso   :=  0
Private nVolume :=  0
Private nComprm :=  0
Private nLargur :=  0
Private nAltura :=  0
Private cEspeci :=  space(15)
Private nRadio  :=  0
Private cEmp1   :=  space(6)
Private nVlr1   :=  0
Private cEmp2   :=  space(6)
Private nVlr2   :=  0
Private nVlr3   :=  0
Private nVlr4   :=  0
Private nVlr5   :=  0

Private cFontUti   := "Tahoma"
Private oFontAno   := TFont():New(cFontUti,,-14)
Private oFontSub   := TFont():New(cFontUti,,-16)

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oGrp2","oSay5","oSay6","oSay7","oSay8","oGrp3")
SetPrvt("oSay18","oSay19","oSay20","oGrp4","oSay21","oSay22","oSay23","oSay24","oGrp5","oSay25","oSay26")
SetPrvt("oGet8","oGrp6","oSay27","oSay28","oGet9","oGet10","oGrp7","oSay9","oSay10","oSay11","oSay12")
SetPrvt("oSay14","oSay15","oSay16","oCBox1","oGet1","oGet2","oGet3","oGet4","oCBox2","oGet5","oGet6")
SetPrvt("oRMenu1","oBtn1","oBtn2","oBtn3","oCBox3")

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

If !Empty(SC5->C5_NOTA)
    MsgAlert("Somente pedidos em aberto podem utilizar esta rotina")
    Return
EndIf

If SC5->C5_FRETE <> 0 .Or. "FRETE R$" $ SC5->C5_XOBS002
    If MsgYesNo("Frete j� calculado para este pedido, deseja limpar os dados e calcular novamente?")
        Reclock("SC5",.F.)
        SC5->C5_TRANSP := ''
        SC5->C5_TPFRETE := 'C''
        SC5->C5_FRETE   := 0
        SC5->C5_PESOL   := 0
        SC5->C5_PBRUTO  := 0
        SC5->C5_VOLUME1 := 0
        SC5->C5_ESPECI1 := ''
        SC5->C5_XOBS002 := ''
        SC5->(MsUnlock())
    EndIf
EndIf

DbSelectaRea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

oDlg1      := MSDialog():New( 092,232,592,1282,"Escolha de Frete",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,028,068,248,"Origem",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay1      := TSay():New( 020,044,{||'Filial'},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay2      := TSay():New( 020,104,{||Alltrim(SM0->M0_FILIAL)},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,136,008)
    oSay3      := TSay():New( 044,044,{||"CEP Origem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay4      := TSay():New( 044,104,{||Alltrim(SM0->M0_CEPENT)},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,136,008)

oGrp2      := TGroup():New( 004,272,068,492,"Destino",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay5      := TSay():New( 020,292,{||"Cliente"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay6      := TSay():New( 020,344,{|| SA1->A1_NOME},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
    oSay7      := TSay():New( 044,292,{||"CEP Destino"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay8      := TSay():New( 044,344,{|| If(!Empty(SA1->A1_CEPE),SA1->A1_CEPE,SA1->A1_CEP)},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)

oGrp3      := TGroup():New( 076,028,128,120,"Correios",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oCBox20     := TComboBox():New( 076 ,076,{|u|if(PCount()>0,cCombo4:=u,cCombo4)},aTipoC,045,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
    oSay17     := TSay():New( 092,040,{||"Prazo"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
    oSay19     := TSay():New( 092,076,{||""},oGrp3,,oFontAno,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
    
    oSay18     := TSay():New( 108,040,{||"Valor"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
    oSay20     := TSay():New( 108,066,{||""},oGrp3,,oFontSub,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,060,010)

oGrp4      := TGroup():New( 076,156,128,248,"Braspress",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay21     := TSay():New( 092,164,{||"Prazo"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
    oSay23     := TSay():New( 092,196,{||""},oGrp4,,oFontAno,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
    
    oSay22     := TSay():New( 108,164,{||"Valor"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
    oSay24     := TSay():New( 108,186,{||""},oGrp4,,oFontSub,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,060,010)

oGrp6      := TGroup():New( 076,272,128,364,"JadLog",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay27     := TSay():New( 092,280,{||"Prazo"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)

    oSay29     := TSay():New( 092,312,{||""},oGrp4,,oFontAno,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
    //oGet9      := TGet():New( 092,432,{|u|if(PCount()>0,cEmp2:=u,cEmp2)},oGrp6,056,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"SA4",,,.F.,.F.,,.F.,.F.,"","",,)
    //oGet9:cF3 := "SA4"

    oSay28     := TSay():New( 112,280,{||"Valor"},oGrp6,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
    oSay30     := TSay():New( 112,312,{||""},oGrp4,,oFontSub,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,060,010)
    //oGet10     := TGet():New( 112,432,{|u|if(PCount()>0,nVlr2:=u,nVlr2)},oGrp6,056,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oGrp5      := TGroup():New( 076,400,128,492,"Motoboy",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay25     := TSay():New( 092,404,{||"Empresa"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
    oGet7      := TGet():New( 092,432,{|u|if(PCount()>0,cEmp1:=u,cEmp1)},oGrp5,048,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    oGet7:cF3 := "SA4"

    oSay26     := TSay():New( 112,404,{||"Valor R$"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
    oGet8      := TGet():New( 112,432,{|u|if(PCount()>0,nVlr1:=u,nVlr1)},oGrp5,048,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)


oGrp7      := TGroup():New( 132,028,216,248,"Informa��es Cubagem",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay9      := TSay():New( 144,040,{||"Frete"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oCBox1     := TComboBox():New( 144,080,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aFrete,060,010,oGrp7,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
    
    oSay14     := TSay():New( 144,148,{||"Tipo"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
    oCBox2     := TComboBox():New( 144,176,{|u|if(PCount()>0,cCombo2:=u,cCombo2)},aForma,060,010,oGrp7,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
    
    oSay10     := TSay():New( 160,040,{||"Peso"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet1      := TGet():New( 160,080,{|u|if(PCount()>0,nPeso:=u,nPeso)},oGrp7,060,008,'@R 999.999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay13     := TSay():New( 160,148,{||"Volumes"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
    oGet4      := TGet():New( 160,176,{|u|if(PCount()>0,nVolume:=u,nVolume)},oGrp7,060,008,'@R 999.999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay11     := TSay():New( 176,040,{||"Comprimento"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2      := TGet():New( 176,080,{|u|if(PCount()>0,nComprm:=u,nComprm)},oGrp7,060,008,'@R 999.999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay15     := TSay():New( 176,148,{||"Altura"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
    oGet5      := TGet():New( 176,176,{|u|if(PCount()>0,nAltura:=u,nAltura)},oGrp7,060,008,'@R 999.999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay12     := TSay():New( 192,040,{||"Largura"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet3      := TGet():New( 192,080,{|u|if(PCount()>0,nLargur:=u,nLargur)},oGrp7,060,008,'@R 999.999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oSay16     := TSay():New( 192,148,{||"Especie"},oGrp7,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
    oCBox3     := TComboBox():New( 192,176,{|u|if(PCount()>0,cCombo3:=u,cCombo3)},aEspeci,060,010,oGrp7,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )


oGrp8      := TGroup():New( 132,272,216,492,"Frete vencedor",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
    //GoRMenu1   := TGroup():New( 140,300,212,484,"",oGrp8,CLR_BLACK,CLR_WHITE,.T.,.F. )
    oRMenu1    := TRadMenu():New( 150,336,{"1 - Correios","2 - Braspress","3 - Motoboy","4 - JadLog","5 - Cliente Retira"},,oGrp8,,,CLR_BLACK,CLR_WHITE,"",,,65,14,,.F.,.F.,.T. )
    oRMenu1:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}
    oRMenu1:bChange := {|| ValidRad(nRadio)}

    oBtn1      := TButton():New( 224,104,"Consultar",oDlg1,{|| BuscaFrete()},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 224,328,"Salvar",oDlg1,{|| oDlg1:end(nOpc := 1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 224,404,"Sair",oDlg1,{|| oDlg1:end(nOpc := 0)},037,012,,,,.T.,,"",,,,.F. )

    oBtn2:disable()

oDlg1:Activate(,,,.T.)

If nOpc == 1
    
    RecLock("SC5", .F.)

    If nRadio == 1   
        SC5->C5_TRANSP := 'T3'
        If cCombo1 $ "2/3"  
            SC5->C5_FRETE   := nVlr4
        Else
            cGravObs := 'FRETE R$ ' + Alltrim(Transform(nVlr4,"@E 999,999.99"))
        EndIf
        SC5->C5_XOBS002 := cGravObs + ' <TpFrete>'+Iif(cCombo4 == '1','03220','03298')+'</TpFrete>'

        /*Processa({|| aEtiqueta := U_ROBWS04(nVolume)},"Aguarde..."+CRLF+"Gerando Etiqueta")
        
        cVirg := ''
        cEtiqueta := ''

        If Len(aEtiqueta) > 0

            For nX := 1 To Len(aEtiqueta)
                cEtiqueta += cVirg+aEtiqueta[nX]
                cVirg := ','
            Next nX

            SC5->C5_XETIQUE := cEtiqueta
        Else
            MsgAlert('Nao foi possivel gerar a etiqueta', 'ROBFAT01')
        EndIf
        */
    ElseIf nRadio == 2 
        If cCombo2 == "1"
            If SC5->C5_FILIAL == '0101'
                SC5->C5_TRANSP := 'T1'
            else
                SC5->C5_TRANSP := 'T16'
            EndIf 
        ElseIf cCombo2 == "2"
            SC5->C5_TRANSP := 'T2'
        EndIf
        If cCombo1 $ "2/3"  
            SC5->C5_FRETE   := nVlr3
        Else
            SC5->C5_XOBS002 := 'FRETE R$ '+Transform(nVlr3,"@E 999,999.99")
        EndIf
    ElseIf nRadio == 3 
        SC5->C5_TRANSP := cEmp1
        If cCombo1 $ "2/3" 
            SC5->C5_FRETE   := nVlr1
        Else
            SC5->C5_XOBS002 := 'FRETE R$ '+Transform(nVlr1,"@E 999,999.99")
        EndIf
    ElseIf nRadio == 4
        SC5->C5_TRANSP := 'T4'
        If cCombo1 $ "2/3" 
            SC5->C5_FRETE   := nVlr5
        Else
            SC5->C5_XOBS002 := 'FRETE R$ '+Transform(nVlr5,"@E 999,999.99")
        EndIf
    EndIf

    SC5->C5_TPFRETE := If(cCombo1=="1","C",If(cCombo1=="2","F","T"))
    
    SC5->C5_PESOL   := nPeso
    SC5->C5_PBRUTO  := nPeso
    SC5->C5_VOLUME1 := nVolume
    SC5->C5_ESPECI1 := If(cCombo3=="1","Caixa","Pacote")

    SC5->(MsUnlock())

    If nRadio == 1
        DbSelectArea("Z51")
        DbSetOrder(1)
        If DbSeek(SC5->C5_FILIAL+SC5->C5_NUM+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
            Reclock("Z51",.F.)
        Else
            Reclock("Z51",.T.)
        EndIf 
        Z51->Z51_FILIAL := SC5->C5_FILIAL
        Z51->Z51_PEDIDO := SC5->C5_NUM
        Z51->Z51_CODCLI := SC5->C5_CLIENTE
        Z51->Z51_LOJCLI := SC5->C5_LOJACLI
        Z51->Z51_ESPECI := 1
        Z51->Z51_ALTURA := nAltura
        Z51->Z51_LARGUR := nLargur
        Z51->Z51_COMPRI := nComprm
        Z51->(MsUnlock())
    EndIf 
ENDIF

Return

/*/{Protheus.doc} BuscaFrete
    (long_description)
    @type  Static Function
    @author user
    @since 23/11/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaFrete()

Local aArea     :=  GetArea()
Local cValido   :=  ''
Local cJson     :=  ''
Local cRet      :=  ''
Local nVlrPed   :=  0

If cCombo1 == "0"
    cValido += "Frete nao selecionado"+CRLF
EndIf

If cCombo2 == "0"
    cValido += "Tipo nao selecionado"+CRLF
EndIf

If cCombo3 == "0"
    cValido += "Especie nao selecionada"+CRLF
EndIf

If nPeso == 0
    cValido += "Peso nao informado"+CRLF
EndIf

If nVolume == 0
    cValido += "Volume nao informado"+CRLF
EndIf

If nComprm == 0
    cValido += "Comprimento nao informado"+CRLF
EndIf

If nLargur == 0
    cValido += "Largura nao informado"+CRLF
EndIf

If nAltura == 0
    cValido += "Altura nao informado"+CRLF
EndIf

If !Empty(cValido)
    MsgAlert(cValido)
Else
    If SM0->M0_CODFIL <> SC5->C5_FILIAL 
        cFilant := SC5->C5_FILIAL 
    EndIf 
    
    nVlrPed := PegaVlrC6(SC5->C5_FILIAL,SC5->C5_NUM)
    cJson := '{'
    cJson += '"cnpjRemetente": "'+SM0->M0_CGC+'",'
    cJson += '"cnpjDestinatario":"'+SA1->A1_CGC+'",'
    cJson += '"modal":"'+If(cCombo2=="1","R","A")+'",'
    cJson += '"tipoFrete":"'+cCombo1+'",'
    cJson += '"cepOrigem":"'+SM0->M0_CEPENT+'",'
    cJson += '"cepDestino":"'+If(!Empty(SA1->A1_CEPE),SA1->A1_CEPE,SA1->A1_CEP)+'",'
    cJson += '"vlrMercadoria":'+cvaltochar(nVlrPed)+','
    cJson += '"peso":'+cvaltochar(nPeso)+','
    cJson += '"volumes":'+cvaltochar(nVolume)+','
    cJson += '"cubagem": [{"altura":'+cvaltochar(nAltura/100)+',"largura":'+cValToChar(nLargur/100)+',"comprimento":'+cvaltochar(nComprm/100)+',"volumes":'+cvaltochar(nVolume)+'}]'
    cJson += '}'

    Processa({|| cRet := U_ROBWS01(cJson)},"Aguarde..."+CRLF+"Pesquisando Braspress")

    If !"ERRO" $ cRet
        aAux := separa(cRet,";")
        oSay23:settext("")
        oSay24:settext("")
        oSay23:settext(aAux[2]+" Dias")
        oSay24:settext("R$ "+transform(VAL(aAux[3]),"@E 99,999.99"))
        nVlr3 := val(aAux[3])
        oDlg1:refresh()
    ELSE
        MsgAlert("Erro ao consultar API da Braspress")
    EndIf

    cJson := "?"
    cJson += "nCdEmpresa=18257836"  //04669
    cJson += "&sDsSenha="+substr(SM0->M0_CGC,1,8)
    cJson += "&sCepOrigem="+Alltrim(SM0->M0_CEPENT)
    cJson += "&sCepDestino="+Alltrim(If(!Empty(SA1->A1_CEPE),SA1->A1_CEPE,SA1->A1_CEP))
    cJson += "&nVlPeso="+cvaltochar(nPeso)
    cJson += "&nCdFormato="+cCombo3
    cJson += "&nVlComprimento="+cvaltochar(nComprm)
    cJson += "&nVlAltura="+cvaltochar(nAltura)
    cJson += "&nVlLargura="+cValToChar(nLargur)
    cJson += "&sCdMaoPropria=n"
    cJson += "&nVlValorDeclarado=0"
    cJson += "&sCdAvisoRecebimento=n"
    cJson += "&nCdServico="+Iif(cCombo4 == '1','03220','03298')+"" //sedex 03220 / pac 03298
    cJson += "&nVlDiametro=0"
    cJson += "&StrRetorno=xml"
    cJson += "&nIndicaCalculo=3"
    
    Processa({|| cRet := U_ROBWS02(cJson)},"Aguarde..."+CRLF+"Pesquisando Correios")

    If !"ERRO" $ cRet
        aAux := separa(cRet,";")
        oSay19:settext("")
        oSay20:settext("")
        oSay19:settext(aAux[1]+" Dias")
        oSay20:settext("R$ "+transform(VAL(aAux[2]),"@E 99,999.99"))
        nVlr4 := val(aAux[2])
        oDlg1:refresh()
    Else
        MsgAlert("Erro ao consultar API dos Correios")
    EndIf

    cJson := ''
    cJson += '{ "frete": [
    cJson += '{ 
    cJson += '    "cepori": "'+Alltrim(SM0->M0_CEPENT)+'",'
    cJson += '    "cepdes": "'+strzero(val(If(!Empty(SA1->A1_CEPE),SA1->A1_CEPE,SA1->A1_CEP)),8)+'",'
    cJson += '    "frap": null,' //+If(cCombo1=='2','S','N')+','
    cJson += '    "peso": '+cvaltochar(nPeso)+','
    cJson += '    "conta": "112684",'
    cJson += '    "contrato": "",'
    cJson += '    "modalidade": 3,'
    cJson += '    "tpentrega": "D",'
    cJson += '    "tpseguro": "N",'
    cJson += '    "vldeclarado": '+cvaltochar(nVlrPed)+','
    cJson += '    "vlcoleta": null'
    cJson += '}'
    cJson += '] } '

    Processa({|| cRet := U_ROBWS03(cJson)},"Aguarde..."+CRLF+"Pesquisando JadLog")

    If !"ERRO" $ cRet .And. !Empty(cRet)
        aAux := separa(cRet,";")
        oSay29:settext("")
        oSay30:settext("")
        oSay29:settext(aAux[1]+" Dias")
        oSay30:settext("R$ "+transform(VAL(aAux[2]),"@E 99,999.99"))
        nVlr5 := val(aAux[2])
        oDlg1:refresh()
    Else
        MsgAlert("Erro ao consultar API dos JadLog "+cRet)
    EndIf
EndIf

RestArea(aArea)

Return

/*/{Protheus.doc} ValidRadio
    (long_description)
    @type  Static Function
    @author user
    @since 23/11/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ValidRad(nRadio)

Local aArea :=  GetArea()
//Local lOk   :=  .F.
//"1 - Correios","2 - Braspress","3 - Motoboy","4 - Outros","5 - Cliente Retira"
If nRadio == 1 .Or. nRadio == 2 .Or. nRadio == 4 .Or. nRadio == 5
    oBtn2:enable()
ElseIf nRadio == 3 
    If !Empty(cEmp1)
        oBtn2:enable()
    else
        MsgAlert("Selecione a empresa primeiro")
        oBtn2:disable()
        nRadio := 0
        oRMenu1:SetOption(0)
    EndIf*/
/*ElseIf nRadio == 4 
    If !Empty(cEmp2)
        oBtn2:enable()
    Else
        MsgAlert("Selecione a empresa primeiro")
        oBtn2:disable()
        nRadio := 0
        oRMenu1:SetOption(0)
    EndIf*/
else
    oBtn2:disable()
EndIf

oDlg1:refresh()

RestArea(aArea)

Return

/*/{ProthSs.doc} PegaVlrC6(cFil,cNum)
    (lon
    
    @type  Static Function
    @author user
    
    RestArea(aArea)
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function PegaVlrC6(cFil,cNum)

Local aArea :=  GetArea()
Local nRet  :=  0

DbSelectArea("SC6")
DbSetOrder(1)
If DBSeek(cFil+cNum)
    While !EOF() .And. SC6->C6_FILIAL == cFil .And. SC6->C6_NUM == cNum
        If Empty(SC6->C6_NOTA)
            nRet += SC6->C6_VALOR
        EndIf 
        Dbskip()
    ENDDO
EndIf

RestArea(aArea)

Return(nRet) 
