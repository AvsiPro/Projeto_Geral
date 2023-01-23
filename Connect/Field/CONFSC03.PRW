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
User Function CONFSC03(cXContrato,cxCdCli,cxLjCli)

Local aArea  :=  GetArea()
Local nOpc   :=  0
Local lRet   :=  .F.
Local cCham  :=  ""
Local cQuery :=  ""

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10")
SetPrvt("oGet1","oGet2","oGet3","oGet4","oBtn1","oBtn2","oList1","oList2","oCBox1")

DEFAULT cXContrato := Space(20)
DEFAULT cxCdCli :=  space(9)
DEFAULT cxLjCli :=  space(4)


Private cAtivo  :=  ""
Private cContrt :=  cXContrato
Private cCodCli :=  cxCdCli
Private cLojCli :=  cxLjCli
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

if Z15->Z15_TIPO != "A"
    MsgAlert("Não é possível abrir a rotina de atribuição de ativos para uma solicitação de retirada!", "Erro!")
    Return
endif

cQuery := "SELECT Z07_CHAPA FROM " + RetSQLName("Z07") + " WHERE SUBSTRING(Z07_CHAPA,1,6) = 'MODELO' GROUP BY Z07_CHAPA"

If Select("TRB") > 0
    DbSelectArea("TRB")
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

Aadd(aMapa, "Sem Mapa")

while !EOF()
    Aadd(aMapa, AllTrim(TRB->Z07_CHAPA))
    dbskip()
end

Aadd(aList1, {"", "", "","",""})
Aadd(aList2, {"", "", ""})

oDlg1      := MSDialog():New( 092,232,800 /*Y*/,1200 /*X*/,"Preparar Ativos para contrato",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 004,012,346/*Y*/, 475/*X*/,"Ativo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        // oSay1      := TSay():New( 020,024,{||"Código do Ativo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        // oGet1      := TGet():New( 020,80,{|u| If(pcount()>0,cAtivo:=u,cAtivo)},oGrp1,060,008,'',{|| xatuatv(1)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SN1X","",,)
        
        oSay3      := TSay():New( 020,024,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet4      := TGet():New( 020,80,{|u| If(pcount()>0,cContrt:=u,cContrt)},oGrp1,060,008,'',{|| xatuatv(3)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"AAM","",,)
        
        oSay2      := TSay():New( 044,024,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet2      := TGet():New( 044,80,{|u| If(pcount()>0,cCodCli:=u,cCodCli)},oGrp1,060,008,'',{|| xatuatv(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","",,)
        oGet3      := TGet():New( 044,155,{|u| If(pcount()>0,cLojCli:=u,cLojCli)},oGrp1,028,008,'',{|| xatuatv(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1CON","",,)
        oGet2:disable()
        oGet3:disable()

        // oSay4      := TSay():New( 096,024,{||"Informações Ativo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
        // oSay5      := TSay():New( 096,092,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay6      := TSay():New( 125,024,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay7      := TSay():New( 125,050,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay8      := TSay():New( 150,024,{||"Endereço"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay9      := TSay():New( 150,050,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay10     := TSay():New( 175,024,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay11     := TSay():New( 175,050,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay12     := TSay():New( 020,150,{||"Escolha a selecao: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)

        oList1     := TCBrowse():New( 200/*Y*/, 024/*X*/, 200/*X*/, 125/*Y*/,, {'Patrimonio','Produto','Descricao'}, {5,15,40,200},;
                        oGrp1,,,, {|| },{|| editcol(oList1:nAt)},,,,,,,,, .T.,,,, .F., .F. )
        
        oList1:SetArray(aList1)
        oList1:bLine := {||{ 	aList1[oList1:nAt,01],;
                                aList1[oList1:nAt,02],;
                                aList1[oList1:nAt,03]}}

        oCBox1	:= TComboBox():New( 020/*Y*/,200/*X*/,{ |u| If(PCount()>0,cMapa:=u,cMapa) },aMapa,044,010,oGrp1,,{ || Mapa() },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cMapa)

        oList2     := TCBrowse():New( 200/*Y*/, 250/*X*/, 200/*X*/, 125/*Y*/,, {'Selecao','Produto','Descricao'}, {5,15,40,200},;
                        oGrp1,,,, {|| },,,,,,,,,, .T.,,,, .F., .F. )
        
        oList2:SetArray(aList2)
        oList2:bLine := {||{ 	aList2[oList2:nAt,01],;
                                aList2[oList2:nAt,02],;
                                aList2[oList2:nAt,03]}}
            
        oBtn1      := TButton():New( 330,150,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 330,250,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
        oBtn3      := TButton():New( 200/*Y*/,225/*X*/,"+",oDlg1,{|| inclin()},021,012,,,,.T.,,"",,,,.F. )
        oBtn4      := TButton():New( 215/*Y*/,225/*X*/,"-",oDlg1,{|| dellin(oList1:nAt)},021,012,,,,.T.,,"",,,,.F. )

        oBtn1:disable()

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

    Processa({|| lRet := GeraBase()},"Aguarde, gerando base de atendimento")

    If lRet
        Processa({|| cCham := Tca300()},"Aguarde, gerando chamado técnico")
        
        If !Empty(cCham)
            MsgAlert("Gerado o chamado técnico "+cCham+" para atender esta solicitação de preparação da maquina.")

            RecLock("Z15", .F.)
                Z15->Z15_STATUS := "C"
                Z15->Z15_NRCHAM := cCham
                Z15->Z15_DTATEN := ddatabase
                Z15->Z15_HRATEN := cvaltochar(Time())
                Z15->Z15_CBASE  := StrTran(cAtivo," ", "")
            Z15->(MsUnlock())

        EndIf 
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

    // oSay5:settext("")

    // DbSelectArea("SN1")
    // DbSetOrder(1)
    // If DbSeek(xFilial("SN1")+cAtivo)
        // IF !Empty(SN1->N1_XCLIENT)
        //     MsgAlert("Ativo já atribuído a outro cliente")
        //     Return .f.
        // EndIf 

        // DbSelectArea("SB1")
        // DbSetOrder(1)
        // If Dbseek(xFilial("SB1")+SN1->N1_PRODUTO)
        //     // oSay5:settext(SB1->B1_DESC)
        //     cCodPro := SN1->N1_PRODUTO
        // EndIF

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
        oBtn1:enable()       
    // else
    //     If !Empty(cAtivo)
    //         MsgAlert("Ativo não encontrado na base")
    //         Return .F. 
    //     EndIf 
    // EndIf 

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Ex040Aut ³ Autor ³ Vendas Clientes       ³ Data ³ 02/12/2022 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inclui/Excluir registro da base instalada atraves de rotina automatica³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Field Service                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraBase()

    Local aCab040   := {}    // Cabecalho do AA3
    Local aItens040 := {}    // Itens AA4
    Local lRet      := .T.  
    Local nX        := 0
    Local nY        := 0
    Local aNrsSerie := {} // Array com o numero de serie para exclusao da base instalada
    Local dData     := ddatabase 

    PRIVATE lMsErroAuto := .F.

    DbSelectArea("SN1")
    DbSetOrder(1)

    for nX := 1 to len(aList1)
        if DbSeek(xFilial("SN1") + aList1[nX,01])
            Aadd(aNrsSerie, aList1[nX])
            cAtivo += aList1[nX,01] + "/"
        endif
    next

    For nX := 1 to Len(aNrsSerie)
        Aadd(aCab040, { "AA3_FILIAL"    , xFilial("AA3")    , NIL } )               
        Aadd(aCab040, { "AA3_CODCLI"    , cCodCli           , NIL } )               
        Aadd(aCab040, { "AA3_LOJA"      , cLojCli           , NIL } )               
        Aadd(aCab040, { "AA3_CODPRO"    , aNrsSerie[nX,02]  , NIL } )               
        Aadd(aCab040, { "AA3_NUMSER"    , aNrsSerie[nX,04]  , NIL } )                
        Aadd(aCab040, { "AA3_CBASE"     , aNrsSerie[nX,01]  , NIL } )                
        Aadd(aCab040, { "AA3_ITEM"      , aNrsSerie[nX,05]  , NIL } )                
        Aadd(aCab040, { "AA3_CHAPA"     , aNrsSerie[nX,01]  , NIL } )                
        Aadd(aCab040, { "AA3_DTVEN"     , dData             , NIL } )

        TECA040(,aCab040,aItens040,3)   

        If lMsErroAuto  
            MostraErro()                            
            lRet := .F.  
        else
            DbSelectArea("SN1")
            DbSetOrder(1)
            If Dbseek(xFilial("SN1")+aNrsSerie[nX,01])
                Reclock("SN1",.F.)
                    SN1->N1_XCLIENT :=  cCodCli
                    SN1->N1_XLOJA   :=  cLojCli 
                SN1->(MsUnlock())

                DbSelectArea("SB1")
                DbSetOrder(1)
                If !DbSeek(xFilial("SB1") + AvKey(aNrsSerie[nX,02], "B1_COD"))
                    MsgAlert("Não foi possível acessar SB1!", "Erro!")
                    Return
                EndIf

                DbSelectArea("Z01")
                DbSetOrder(1)
                If !DbSeek(xFilial("Z01") + SB1->B1_XTIPOCN)
                    MsgAlert("Não foi possível acessar Z01!", "Erro!")
                    Return
                EndIf

                if cMapa != "Sem Mapa" .AND. !(SubStr(AllTrim(Z01->Z01_DESCRI),1,5) == "GABIN")
                    DbSelectArea("Z07")
                    for nY := 1 to len(aList2)
                        RecLock("Z07", .T.)
                            Z07->Z07_CHAPA  := SN1->N1_CBASE
                            Z07->Z07_SELECA := aList2[nY,01]
                            Z07->Z07_CODMAQ := SN1->N1_PRODUTO
                            Z07->Z07_CODPRO := aList2[nY,02]
                            Z07->Z07_CLIENT := SA1->A1_COD
                            Z07->Z07_LOJA   := SA1->A1_LOJA
                            Z07->Z07_DINICI := dDataBase
                        MsUnlock()
                    next
                endif

            EndIF              

        Endif

        aCab040 := {}
    Next

Return lRet

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
        aAdd(aItem,{ "AB2_CLASSI"   ,"003"                                   ,Nil})
        aAdd(aItem,{ "AB2_CODPRO"   ,aList1[nX,02]                           ,Nil})
        aAdd(aItem,{ "AB2_NUMSER"   ,AvKey(aList1[nX,04], "AB2_NUMSER")      ,Nil})
        aAdd(aItem,{ "AB2_CODPRB"   ,'000002'                                ,Nil}) //AAG->AAG_CODPRB
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
        lProd    := ConPad1(,,,"SN1X",,,.f.)
        
        If lProd
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

Static Function Mapa()
    
    Local aArea := GetArea()

    if cMapa == "Sem Mapa"
        Return
    endif

    aList2 := {}

    cQuery := " SELECT Z07_SELECA,Z07_CODPRO,B1_DESC "
    cQuery += " FROM " + RetSQLName("Z07") + " "
    cQuery += " INNER JOIN " + RetSQLName("SB1") + " "
    cQuery += " ON B1_COD = Z07_CODPRO AND B1_FILIAL = '" + xFilial("SB1") + "' "
    cQuery += " WHERE Z07_CHAPA = '" + cMapa + "' "
    cQuery += " ORDER BY Z07_SELECA "

    If Select("TRB") > 0
        DbSelectArea("TRB")
        DbCloseArea()
    EndIf

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

    while !EOF()
        Aadd(aList2, {AllTrim(TRB->Z07_SELECA), AllTrim(TRB->Z07_CODPRO), AllTrim(TRB->B1_DESC)})
        dbskip()
    end

    if len(aList2) < 1
        aList2 := {"", "", ""}
    endif

    oList2:SetArray(aList2)
    oList2:SetArray(aList2)
    oList2:bLine := {||{	aList2[oList2:nAt,01],;
                            aList2[oList2:nAt,02],;
                            aList2[oList2:nAt,03]}}

    oList2:refresh()
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
