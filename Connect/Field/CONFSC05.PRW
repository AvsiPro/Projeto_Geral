#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TBICONN.CH" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CONFSC05 ³ Autor ³                      ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  Status do Contrato atual                                  ³±±
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

User Function CONFSC05

SetPrvt("oDlg1","oBmp1","oGrp1","oSay2","oSay3","oSay4","oGet2","oBtn1")
Private cContra     :=  space(15)

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

oDlg1      := MSDialog():New( 092,232,486,1009,"Status Contrato",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,012,060,372,"Informações Contrato/Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

    oSay2      := TSay():New( 015,088,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oSay3      := TSay():New( 028,028,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,336,008)
    oSay4      := TSay():New( 044,028,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,336,008)
    oGet2      := TGet():New( 014,152,{|u| If(PCount()>0,cContra:=u,cContra)},oGrp1,088,008,'',{|| StatCnt()},CLR_BLACK,CLR_WHITE,,,,.T.,,,,,,,,,"AAM",,,)

oBmp1      := TBitmap():New( 068,012,360,096,,"",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )

oBtn1      := TButton():New( 172,172,"Sair",oDlg1,{|| oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return


/*/{Protheus.doc} StatCnt
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function StatCnt()

Local cStatus   :=  Strzero(VAL(cContra),15)
Local nStatus   :=  0
Local nCont     :=  0
Local lOsAb     :=  .F.
Local lGerPv    :=  .F.
Local lGerNf    :=  .F.

DbSelectArea("AAM")
DbSetOrder(1)
If Dbseek(xFilial("AAM")+cStatus)
    nStatus++
    DbSelectArea("SA1")
    DbSetOrder(1)
    Dbseek(xFilial("SA1")+AAM->AAM_CODCLI+AAM->AAM_LOJA)
    
    oSay3:settext(Alltrim(SA1->A1_NOME)+ ' / '+Alltrim(SA1->A1_NREDUZ))
    oSay4:settext(Alltrim(SA1->A1_END)+ ' - '+Alltrim(SA1->A1_BAIRRO)+' - '+Alltrim(SA1->A1_MUN)+' - '+SA1->A1_EST)
    
    DbSelectArea("Z15")
    DbSetOrder(1)
    If Dbseek(xFilial("Z15")+AAM->AAM_CONTRT)
        nStatus++
        aChamOS := buscaos(cStatus)
        For nCont := 1 to len(aChamOS)
            If Empty(aChamOS[nCont,03])
                lOsAb := .T.
            else
                DbSelectArea("SC5")
                DbSetOrder(1)
                If Dbseek(xFilial("SC5")+SUBSTR(aChamOS[nCont,03],1,6))
                    lGerPv := .T.
                    nStatus++
                    If !Empty(SC5->C5_NOTA) 
                        lGerNf := .T.
                        nStatus++
                    EndIf
                EndIf
            EndIf
        Next nCont

        If !lOsAb
            nStatus++
        EndIf 
    EndIf 

    //oBmp1:SetEmpty()
    oBmp1:Load("STATUS"+cvaltochar(nStatus)+".BMP")
    oBmp1:SetBmp("STATUS"+cvaltochar(nStatus)+".BMP")
EndIf 

Return

/*/{Protheus.doc} Buscaos
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Buscaos(cContr)

Local aArea  := Getarea()
Local aRet   := {}
Local cQuery 

cQuery := "SELECT AB2_STATUS,AB2_NUMOS,AB8_NUMPV"
cQuery += " FROM "+RetSQLName("AB2")+" AB2"
cQuery += " LEFT JOIN "+RetSQLName("AB8")+" AB8 ON AB8_FILIAL=AB2_FILIAL AND AB8_NUMOS+AB8_ITEM=AB2_NUMOS AND AB8.D_E_L_E_T_=' '"
cQuery += " WHERE AB2_FILIAL='"+xFilial("AB2")+"' AND AB2_XCONTR='"+cContr+"'"
cQuery += " AND AB2.D_E_L_E_T_=' ' "

If Select("TRB") > 0
    dbSelectArea("TRB")
    dbCloseArea()
EndIf

MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

While !EOF()
    Aadd(aRet,{ TRB->AB2_STATUS,;
                TRB->AB2_NUMOS,;
                TRB->AB8_NUMPV})
    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
