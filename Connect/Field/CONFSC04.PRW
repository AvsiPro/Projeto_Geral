#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CONFSC03  ³ Autor ³ Vendas Clientes       ³ Data ³ 02/12/2022 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inclui/Excluir registro da base instalada atraves de rotina automatica³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Field Service                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CONFSC04(cXContrato,cxCdCli,cxLjCli)

Local aArea  :=  GetArea()
Local nOpc   :=  0
Local nX     :=  0
Local cCham  :=  ""

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10")
SetPrvt("oGet1","oGet2","oGet3","oGet4","oBtn1","oBtn2","oList1","oList2","oCBox1","oGet5")

DEFAULT cXContrato := Space(15)
DEFAULT cxCdCli :=  space(9)
DEFAULT cxLjCli :=  space(4)


Private cAtivo  :=  ""
Private cContrt :=  cXContrato
Private cCodCli :=  cxCdCli
Private cLojCli :=  cxLjCli
Private cPntVnd :=  space(6)

Private cCodPro :=  ""
Private cMapa   :=  ""
Private cCliPri :=  space(4)
Private aMapa   :=  {}
Private aList1  :=  {}
Private aList2  :=  {}

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

//If !Empty(cContrt)
    if Z15->Z15_TIPO != "B"
        MsgAlert("Não é possível abrir a rotina de retirada de ativos para uma solicitação de atribuição!", "Erro!")
        Return
    endif

    DbSelectArea("AAM")
    DbSetOrder(1)
    if !AAM->(DbSeek(xFilial("AAM") + Z15->Z15_CONTRA))
        MsgAlert("Nao foi possivel acessar AAM", "Erro!")
        Return
    EndIf
//EndIF 

Aadd(aList1, {"", "", "","",""})

oDlg1      := MSDialog():New( 092,232,800 /*Y*/,1200 /*X*/,"Retirar Ativos do contrato",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 004,012,346/*Y*/, 475/*X*/,"Ativo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay3      := TSay():New( 020,024,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet4      := TGet():New( 020,80,{|u| If(pcount()>0,cContrt:=u,cContrt)},oGrp1,060,008,'',{|| If(!Empty(cContrt),xatuatv(3),)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"AAM","",,)
        
        oSay2      := TSay():New( 044,024,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet2      := TGet():New( 044,80,{|u| If(pcount()>0,cCodCli:=u,cCodCli)},oGrp1,060,008,'',{|| xatuatv(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","",,)
        oGet3      := TGet():New( 044,155,{|u| If(pcount()>0,cLojCli:=u,cLojCli)},oGrp1,028,008,'',{|| xatuatv(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1CON","",,)
        oGet2:disable()
        oGet3:disable()
/*
        oSay5      := TSay():New( 044,205,{||"Ponto de Venda"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oGet5      := TGet():New( 044,255,{|u| If(pcount()>0,cPntVnd:=u,cPntVnd)},oGrp1,028,008,'',{|| },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"NNR2","",,)
*/        
        oSay6      := TSay():New( 125,024,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay7      := TSay():New( 125,050,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay8      := TSay():New( 150,024,{||"Endereço"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay9      := TSay():New( 150,050,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay10     := TSay():New( 175,024,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay11     := TSay():New( 175,050,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)

        oList1     := TCBrowse():New( 200/*Y*/, 024/*X*/, 200/*X*/, 125/*Y*/,, {'Patrimonio','Produto','Descricao'}, {5,15,40,200},;
                        oGrp1,,,, {|| },{|| editcol(oList1:nAt)},,,,,,,,, .T.,,,, .F., .F. )
        
        oList1:SetArray(aList1)
        oList1:bLine := {||{ 	aList1[oList1:nAt,01],;
                                aList1[oList1:nAt,02],;
                                aList1[oList1:nAt,03]}}

        oBtn1      := TButton():New( 330,150,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 330,250,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
        oBtn3      := TButton():New( 200/*Y*/,225/*X*/,"+",oDlg1,{|| inclin()},021,012,,,,.T.,,"",,,,.F. )
        oBtn4      := TButton():New( 215/*Y*/,225/*X*/,"-",oDlg1,{|| dellin(oList1:nAt)},021,012,,,,.T.,,"",,,,.F. )

        //oBtn1:disable()

        if !Empty(cXContrato) 
            xatuatv(3)
            oGet4:Disable()
        endif

        if !Empty(cMapa)
            Mapa()
        endif        

oDlg1:Activate(,,,.T.)

If nOpc == 1
    BEGIN TRANSACTION

    Processa({|| cCham := Tca300()},"Aguarde, gerando chamado técnico")
    
    If !Empty(cCham)
        MsgAlert("Gerado o chamado técnico "+cCham+" para atender esta solicitação de retirada da maquina.")

        DbSelectArea("SN1")
        DbSetOrder(1)

        for nX := 1 to len(aList1)
            if DbSeek(xFilial("SN1") + aList1[nX,01])
                cAtivo += aList1[nX,01] + "/"
            endif
        next

        RecLock("Z15", .F.)
            Z15->Z15_STATUS := "C"
            Z15->Z15_NRCHAM := cCham
            Z15->Z15_DTATEN := ddatabase
            Z15->Z15_HRATEN := cvaltochar(Time())
            Z15->Z15_CBASE  := StrTran(cAtivo," ", "")
        Z15->(MsUnlock())

    EndIf 

    END TRANSACTION 
EndIf 

RestArea(aArea)

Return 

/*/{Protheus.doc} xatuatv()
    (long_description)
    @type  Static Function
    @author user
    @since 02/12/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xatuatv(nTip)

Local aArea  :=  GetArea()
/*
    DbSelectArea("AAM")
    DbSetOrder(1)
    IF Dbseek(xFilial("AAM")+cContrt)
        cCodCli := AAM->AAM_CODCLI //Z15->Z15_CLIENT
        cLojCli := AAM->AAM_LOJA //Z15->Z15_LOJA
    Else
        MsgAlert("Contrato não encontrado")
        Return
    EndIf 
*/
    cCodCli := Z15->Z15_CLIENT
    cLojCli := Z15->Z15_LOJA

    oSay7:settext("")
    oSay9:settext("")

    DbSelectArea("SA1")
    DbSetOrder(1)
    If DbSeek(xFilial("SA1")+cCodCli+cLojCli)
        oSay7:settext(Alltrim(SA1->A1_NOME)+' / '+Alltrim(SA1->A1_NREDUZ))
        oSay9:settext(Alltrim(SA1->A1_END)+' - '+Alltrim(SA1->A1_BAIRRO)+' - '+Alltrim(SA1->A1_MUN)+' - '+SA1->A1_EST)
        if len(Alltrim(SA1->A1_END)+' - '+Alltrim(SA1->A1_BAIRRO)+' - '+Alltrim(SA1->A1_MUN)+' - '+SA1->A1_EST) > 75
            oSay10:settext(SubStr(Alltrim(SA1->A1_END)+' - '+Alltrim(SA1->A1_BAIRRO)+' - '+Alltrim(SA1->A1_MUN)+' - '+SA1->A1_EST,75))
        endif
    EndIf 

    oGet2:disable()
    oGet3:disable()

    //If !Empty(cPntVnd) .And. !Empty(cContrt)
        oBtn1:enable()       
    //EndIF

    oDlg1:refresh()
    
RestArea(aArea)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 02/12/2022
    @version version
    @param param_name, param_type, param_descr
    @return
*/    
Static Function Tca300()

    Local aCabec    := {}
    Local aItens    := {} 
    Local aItem     := {} 
    Local nX        := 1
    Local cChamado  := ""
    Local lOk       := .T.

    PRIVATE lMsErroAuto := .F.

    Default cDescLocal := "" 

    DbSelectArea("SA1")
    Dbseek(xFilial("SA1")+cCodCli+cLojCli)

    dbSelectArea("AB1")
    dbSetOrder(1)

    cChamado := GetSXENum("AB1","AB1_NRCHAM")

    While dbSeek( xFilial("AB1") +AvKey(cChamado,"AB1_NRCHAM") )
        cChamado := GetSXENum("AB1","AB1_NRCHAM")
    End

    aCabec := {  } 
    aItens := {  } 

    aAdd(aCabec,{ "AB1_NRCHAM"  , cChamado          ,Nil})
    aAdd(aCabec,{ "AB1_EMISSA"  , dDataBase         ,Nil})
    aAdd(aCabec,{ "AB1_CODCLI"  , SA1->A1_COD       ,Nil})
    aAdd(aCabec,{ "AB1_LOJA"    , SA1->A1_LOJA      ,Nil})
    aAdd(aCabec,{ "AB1_HORA"    ,cValToChar(Time()) ,Nil})
    aAdd(aCabec,{ "AB1_ATEND"   ,cUserName          ,Nil})

    for nX := 1 to len(aList1)
        aItem := {  }
        aAdd(aItem,{ "AB2_ITEM"     ,StrZero(nX,2)                           ,Nil})
        aAdd(aItem,{ "AB2_TIPO"     ,"3"                                     ,Nil})
        aAdd(aItem,{ "AB2_CLASSI"   ,"005"                                   ,Nil})
        aAdd(aItem,{ "AB2_CODPRO"   ,Posicione("SB1", 1, xFilial("SB1") + aList1[nX,02], "B1_COD")                           ,Nil})
        aAdd(aItem,{ "AB2_NUMSER"   ,AvKey(aList1[nX,04], "AB2_NUMSER")      ,Nil})
        aAdd(aItem,{ "AB2_CODPRB"   ,'000003'                                ,Nil}) //AAG->AAG_CODPRB
        aAdd(aItem,{ "AB2_XCONTR"   ,cContrt                                 ,Nil})
        aAdd(aItem,{ "AB2_XCBASE"   ,aList1[nX,01]                           ,Nil})
        aAdd(aItens,aItem)
    next

    TECA300(,,aCabec,aItens,3)

    If !lMsErroAuto
        ConfirmSx8()
        TECR300(cChamado)
    Else
        MostraErro() 
        RollBackSx8()
        lOk := .F.
        cChamado := ""
    EndIf

Return cChamado

/*/{Protheus.doc} FichTec
    (long_description)
    @type  Static Function
    @author user
    @since 18/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FichTec(cAtivo)

Private oDlg1,oGrp1,oGrp2,oBtn1
Private aList1 := {}
Private oList1 
Private aList2 := {}
Private oList2

Aadd(aList1,{'',''})
oDlg1      := MSDialog():New( 092,230,482,914,"Atribuir Leiaute",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 008,016,076,320,"Modelos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{016,024,072,312},,, oGrp1 ) 
    oList1            := TCBrowse():New(124,024,345,180,, {'','Modelo'},{30,80},;
                            oGrp3,,,,{|| },{|| /*editcol(oList1:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],; 
                        aList1[oList1:nAt,02]}}

    oGrp2      := TGroup():New( 080,016,164,320,"Leiaute",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{088,024,160,312},,, oGrp2 ) 

    oBtn1      := TButton():New( 169,144,"Confirmar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return

Static Function editcol(nLin)

    Local aArea     :=  GetArea()
    Local nPosic    :=  oList1:nColpos
    Local aPosTam   :=  {TamSX3("N1_CBASE")[1],TamSX3("B1_COD")[1],TamSX3("B1_DESC")[1]}
    Local lProd     :=  .F.

    If nPosic == 1
        lProd    := ConPad1(,,,"AANX",,,.f.)
        
        If lProd

            DbSelectArea("SN1")
            SN1->(DbSetOrder(2))
            SN1->(DbSeek(xFilial("SN1") + AAN->AAN_XCBASE))

            aList1[nLin,1] := SN1->N1_CBASE

            dbSelectArea("SB1")
            DbSetOrder(1)
            if !DbSeek(xFilial("SB1") + SN1->N1_PRODUTO)
                MsgAlert("Produto do ativo não cadastrado!", "Erro!")
                aList1[nLin,1] := ""
                Return .F.
            EndIf

            if Empty(SN1->N1_XNUMSER)
                MsgAlert("Ativo sem número de série cadastrado!", "Erro!")
                aList1[nLin,1] := ""
                Return
            endif

            aList1[nLin,2] := SB1->B1_COD
            aList1[nLin,3] := SB1->B1_DESC
            aList1[nLin,4] := SN1->N1_XNUMSER
            aList1[nLin,5] := SN1->N1_ITEM
        Else 
            If Empty(aList1[nLin,nPosic])
                aList1[nLin,nPosic] := space(aPosTam[nPosic])
            EndIf 

            lEditCell( aList1, oList1, "@!", nPosic)
        EndIf
        
    EndIf

    oList1:refresh()
    oDlg1:refresh()

    RestArea(aArea)

Return

Static Function inclin()

    Local aArea :=  GetArea()

    Aadd(aList1,{'','','','',''})

    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03]}}

    oList1:refresh()
    oDlg1:refresh()

    RestArea(aArea)

Return

Static Function dellin(nLin)
    
    Local aArea :=  GetArea()

    Adel(aList1,nLin)
    ASize(aList1,len(aList1)-1)

    If len(aList1) < 1
        Aadd(aList1,{'','','','',''})

        oList1:SetArray(aList1)
        oList1:bLine := {||{aList1[oList1:nAt,01],; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03]}} 
    EndIf 

    oList1:refresh()
    oDlg1:refresh()

    RestArea(aArea)

Return
