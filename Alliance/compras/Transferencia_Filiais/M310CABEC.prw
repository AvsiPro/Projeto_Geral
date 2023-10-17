#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function M310CABEC

Local aRet  := {}
Local aPar2 := PARAMIXB[2]
Local nPosPV:= Ascan(aPar2,{|x| alltrim(x[1]) == "C5_NUM"})
Local nPosNE:= Ascan(aPar2,{|x| alltrim(x[1]) == "F1_DOC"})

Private cTransp :=  Space(6)
Private nQtd    :=  0
Private cEspec  :=  space(25)
Private cPlaca  :=  space(8)
Private cNumera :=  space(15)
Private nPesoB  :=  0
Private nPesoL  :=  0
Private cTexto  :=  space(254)
Private aTipo   :=  {'C=CIF','F=FOB'}
Private cTipo   :=  aTipo[1]
Private cMarca  :=  space(25)

//cTransp,nQtd,cEspec,cPlaca,nPesoB,nPesoL,FwCutOff(cTexto,.T.)

If nPosPv > 0
    aRet := XTRS311F()

    If len(aRet) > 0
        Aadd(aPar2,{"C5_TRANSP" , aRet[1,1], Nil})
        Aadd(aPar2,{"C5_VOLUME1", aRet[1,2], Nil})
        Aadd(aPar2,{"C5_ESPECI1", aRet[1,3], Nil})
        Aadd(aPar2,{"C5_VEICULO", aRet[1,4], Nil})
        Aadd(aPar2,{"C5_PESOL"  , aRet[1,5], Nil})
        Aadd(aPar2,{"C5_PBRUTO" , aRet[1,6], Nil})
        Aadd(aPar2,{"C5_TPFRETE", aRet[1,7], Nil})
        //Aadd(aPar2,{"C5_", aRet[1,8], Nil})
        //Aadd(aPar2,{"C5_", aRet[1,9], Nil})
        Aadd(aPar2,{"C5_MENNOTA", aRet[1,10], Nil})

        
    EndIf 
ElseIf nPosNE > 0
    //F1_TRANSP
    //F1_PLIQUI
    //F1_PBRUTO
    //F1_ESPECI1
    //F1_VOLUME1
    //F1_TPFRETE
    //F1_MENNOTA
EndIf

Return(aPar2)

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

static Function XTRS311F

Local aRet      :=  {}
Local nTipo     :=  0


SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oGet1","oGrp2","oSay4","oSay5","oSay6","oSay7","oSay8","oGet8")
SetPrvt("oGet2","oGet3","oGet4","oGet5","oGet6","oGet7","oGrp3","oMGet1","oBtn1","oSay9","oSay10","oSay11")

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

oDlg1      := MSDialog():New( 092,232,617,910,"Transportadora x Observações Nota",,,.F.,,,,,,.T.,,,.T. )
    oGrp1      := TGroup():New( 008,012,068,324,"Transportadora",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oSay1      := TSay():New( 020,104,{||"Codigo Transp."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
        oGet1      := TGet():New( 020,152,{|x|If(Pcount()>0,cTransp:=x,cTransp)},oGrp1,060,008,'',{||dadostrp(cTransp)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA4","",,)
        oSay2      := TSay():New( 036,024,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
        oSay3      := TSay():New( 052,024,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
    
    oGrp2      := TGroup():New( 072,012,144,324,"Informações Carga",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        
        oSay4      := TSay():New( 088,024,{||"Quantidade"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet2      := TGet():New( 088,064,{|x|If(Pcount()>0,nQtd:=x,nQtd)},oGrp2,040,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
        oSay5      := TSay():New( 088,118,{||"Espécie"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet3      := TGet():New( 088,170,{|x|If(Pcount()>0,cEspec:=x,cEspec)},oGrp2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

        oSay10     := TSay():New( 088,225,{||"Numeração"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet5      := TGet():New( 088,265,{|x|If(Pcount()>0,cNumera:=x,cNumera)},oGrp2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay6      := TSay():New( 108,024,{||"Veículo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet4      := TGet():New( 108,064,{|x|If(Pcount()>0,cPlaca:=x,cPlaca)},oGrp2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DA3","",,)
    
        oSay7      := TSay():New( 108,118,{||"Tipo Frete"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oCBox1	:= TComboBox():New( 108/*Y*/,170/*X*/,{ |u| If(PCount()>0,cTipo:=u,cTipo) },aTipo,044,010,oGrp2,,{ ||  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cTipo)

        oSay11     := TSay():New( 108,225,{||"Marca"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet8      := TGet():New( 108,265,{|x|If(Pcount()>0,cMarca:=x,cMarca)},oGrp2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay8      := TSay():New( 128,024,{||"Peso Bruto"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet6      := TGet():New( 128,064,{|x|If(Pcount()>0,nPesoB:=x,nPesoB)},oGrp2,040,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
        oSay9      := TSay():New( 128,118,{||"Peso Liquido"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet7      := TGet():New( 128,170,{|x|If(Pcount()>0,nPesoL:=x,nPesoL)},oGrp2,040,008,'@E 999,999,999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
    oGrp3      := TGroup():New( 148,012,232,324,"Dados adicionais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oMGet1     := TMultiGet():New( 156,016,{|x|If(Pcount()>0,cTexto:=x,cTexto)},oGrp3,304,072,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

oBtn1      := TButton():New( 236,136,"Confirmar",oDlg1,{||oDlg1:end(nTipo:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 236,186,"Cancelar",oDlg1,{||oDlg1:end(nTipo:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nTipo == 1
    aadd(aRet,{cTransp,nQtd,cEspec,cPlaca,nPesoB,nPesoL,cTipo,cNumera,cMarca,FwCutOff(cTexto,.T.)})
EndIf 

Return(aRet)

/*/{Protheus.doc} cTransp
    (long_description)
    @type  Static Function
    @author user
    @since 11/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function dadostrp(cTranp)

oSay2:settext("")
oSay3:settext("")

If !Empty(cTransp)
    oSay2:settext(SA4->A4_NOME+Transform(SA4->A4_CGC,"@E99.999.999/9999-99"))
    oSay3:settext(SA4->A4_END+SA4->A4_BAIRRO+SA4->A4_MUN+SA4->A4_EST)
ENDIF

oDlg1:refresh()

Return
