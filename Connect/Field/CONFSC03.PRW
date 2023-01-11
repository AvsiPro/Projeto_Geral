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
User Function CONFSC03(cXContrato)

Local aArea :=  GetArea()
Local nOpc  :=  0
Local lRet  :=  .F.
Local cCham :=  ""

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10")
SetPrvt("oGet1","oGet2","oGet3","oGet4","oBtn1","oBtn2")

DEFAULT cXContrato := Space(20)

Private cAtivo  :=  space(10)
Private cCodCli :=  space(9)
Private cLojCli :=  space(4)
Private cContrt :=  cXContrato
Private cCodPro :=  ""

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

if Z15->Z15_TIPO != "A"
    MsgAlert("Não é possível abrir a rotina de atribuição de ativos para uma solicitação de retirada!", "Erro!")
    Return
endif

oDlg1      := MSDialog():New( 092,232,479,932,"Preparar Ativo para contrato",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 004,012,164,332,"Ativo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay1      := TSay():New( 020,092,{||"Código do Ativo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oGet1      := TGet():New( 020,152,{|u| If(pcount()>0,cAtivo:=u,cAtivo)},oGrp1,060,008,'',{|| xatuatv(1)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SN1X","",,)
        
        oSay3      := TSay():New( 044,092,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet4      := TGet():New( 044,152,{|u| If(pcount()>0,cContrt:=u,cContrt)},oGrp1,060,008,'',{|| xatuatv(3)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"AAM","",,)
        
        oSay2      := TSay():New( 068,092,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet2      := TGet():New( 068,152,{|u| If(pcount()>0,cCodCli:=u,cCodCli)},oGrp1,060,008,'',{|| xatuatv(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1","",,)
        oGet3      := TGet():New( 068,224,{|u| If(pcount()>0,cLojCli:=u,cLojCli)},oGrp1,028,008,'',{|| xatuatv(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        oSay4      := TSay():New( 096,024,{||"Informações Ativo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
        oSay5      := TSay():New( 096,092,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay6      := TSay():New( 112,024,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay7      := TSay():New( 112,072,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay8      := TSay():New( 128,024,{||"Endereço"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay9      := TSay():New( 128,072,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        oSay10     := TSay():New( 144,024,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oSay11     := TSay():New( 144,072,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
    
oBtn1      := TButton():New( 169,100,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 169,208,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

        if AllTrim(cXContrato) != ""
            xatuatv(3)
            oGet4:Disable()
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
                Z15->Z15_STATUS := "B"
            MsUnlock()

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
Local cQuery := ""

If nTip == 1

    oSay5:settext("")

    DbSelectArea("SN1")
    DbSetOrder(1)
    If DbSeek(xFilial("SN1")+cAtivo)
        IF !Empty(SN1->N1_XCLIENT)
            MsgAlert("Ativo já atribuído a outro cliente")
            Return .f.
        EndIf 

        DbSelectArea("SB1")
        DbSetOrder(1)
        If Dbseek(xFilial("SB1")+SN1->N1_PRODUTO)
            oSay5:settext(SB1->B1_DESC)
            cCodPro := SN1->N1_PRODUTO
        EndIF 
    EndIf 

ElseIf nTip == 2

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
    
elseif nTip == 3
    
    cQuery := " "
    cQuery += " SELECT DISTINCT AAM_CODCLI,AAM_LOJA   " 
    cQuery += " FROM   " + RetSQLName("AAN") + " AAN   " 
    cQuery += " INNER JOIN " + RetSQLName("AAM") + " AAM ON AAM_CONTRT = AAN_CONTRT   " 
    cQuery += " WHERE  AAN_CONTRT = '" + cContrt + "'   " 
    cQuery += "        AND AAN.D_E_L_E_T_ = ' '   " 
    cQuery += "        AND AAM.D_E_L_E_T_ = ' '   " 

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	while !EOF()

        cCodCli := TRB->AAM_CODCLI
        cLojCli := TRB->AAM_LOJA

		DBSKIP()
	end

    oGet2:disable()
    oGet3:disable()
    
    xatuatv(2)

EndIf 

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
Local nI
Local aNrsSerie := {} // Array com o numero de serie para exclusao da base instalada
Local nRegs     := 0
Local dData     := ddatabase 

PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//| Abertura do ambiente                                        
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(aNrsSerie,cAtivo)

nRegs     := Len(aNrsSerie) 

For nI := 1 to nRegs                                        
    Aadd(aCab040, { "AA3_FILIAL"    , xFilial("AA3")    , NIL } )               
    Aadd(aCab040, { "AA3_CODCLI"    , cCodCli           , NIL } )               
    Aadd(aCab040, { "AA3_LOJA"      , cLojCli           , NIL } )               
    Aadd(aCab040, { "AA3_CODPRO"    , cCodPro           , NIL } )               
    Aadd(aCab040, { "AA3_NUMSER"    , SN1->N1_XNUMSER            , NIL } )                
    Aadd(aCab040, { "AA3_CBASE"     , cAtivo            , NIL } )                
    Aadd(aCab040, { "AA3_ITEM"      , '0001'            , NIL } )                
    Aadd(aCab040, { "AA3_CHAPA"     , cAtivo            , NIL } )                
    Aadd(aCab040, { "AA3_DTVEN"     , dData             , NIL } )

    TECA040(,aCab040,aItens040,3)   

    If lMsErroAuto  
        MostraErro()                            
        lRet := !lMsErroAuto  
    else
        DbSelectArea("SN1")
        DbSetOrder(1)
        If Dbseek(xFilial("SN1")+cAtivo)
            Reclock("SN1",.F.)
            SN1->N1_XCLIENT :=  cCodCli
            SN1->N1_XLOJA   :=  cLojCli 
            SN1->(MsUnlock())
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
aAdd(aCabec,{ "AB1_HORA"    ,Time()             ,Nil})
aAdd(aCabec,{ "AB1_ATEND"   ,cUserName          ,Nil})

aItem := {  }

aAdd(aItem,{ "AB2_ITEM"     ,StrZero(nX,2)      ,Nil})
aAdd(aItem,{ "AB2_TIPO"     ,"3"                ,Nil})
aAdd(aItem,{ "AB2_CLASSI"   ,"003"              ,Nil})
aAdd(aItem,{ "AB2_CODPRO"   ,cCodPro            ,Nil})
aAdd(aItem,{ "AB2_NUMSER"   ,SN1->N1_XNUMSER             ,Nil})
aAdd(aItem,{ "AB2_CODPRB"   ,'000002'           ,Nil}) //AAG->AAG_CODPRB
aAdd(aItem,{ "AB2_XCONTR"   ,cContrt            ,Nil})

aAdd(aItens,aItem)

TECA300(,,aCabec,aItens,3)

If !lMsErroAuto
    ConfirmSx8()
    TECR300(cChamado)
Else
    MostraErro() 
    RollBackSx8()
    lOk := .F.
EndIf

Return cChamado
