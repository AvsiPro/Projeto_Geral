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

User Function RRFAT01

Local nOpc := 0
Local nCont 
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oGet1","oGet2","oGet3")
SetPrvt("oGrp2","oBrw1","oBtn1","oBtn2")

Private aList1 := {}
Private oList1
Private oOk   		:= LoadBitmap(GetResources(),'br_verde') 
Private oNo   		:= LoadBitmap(GetResources(),'br_vermelho')  

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

Private dDtEnt := ctod(' / / ')
Private cMotor := space(6)
Private cCarro := space(6)
Private cRegiao:= space(3)
Private cNomMot:= ''
Private cNomCar:= ''

//Aadd(aList1,{'','','','','','','','',0,.F.,'','','',''})
busca()

If len(aList1) > 0
    oDlg1      := MSDialog():New( 092,232,752,1396,"Confirmação de Entrega",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,008,096,568,"Dados Entrega",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oSay1      := TSay():New( 016,028,{||"Data Entrega"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
        oGet1      := TGet():New( 016,068,{|x| If(PCount() > 0,dDtEnt := x,dDtEnt)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtEnt",,)
        
        oSay2      := TSay():New( 036,028,{||"Motorista"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        //{|| updlist(cMotor,1)}
        oGet2      := TGet():New( 036,068,{|x| If(PCount() > 0,cMotor := x,cMotor)},oGrp1,060,008,'',{|| oSay3:settext(Posicione("DA4",1,xFilial("DA4")+cMotor,"DA4_NOME"))},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMotor",,)
        oGet2:bF3:= &('{|| IIf(ConPad1(,,,"DA4",,,.F.),Eval({|| cMotor := DA4->DA4_COD, oGet2:Refresh()}),.T.)}') 
        oSay3      := TSay():New( 036,140,{||''},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,008)
        
        oSay4      := TSay():New( 056,028,{||"Veículo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        //{|| updlist(cCarro,2)}
        oGet3      := TGet():New( 056,068,{|x| If(PCount() > 0,cCarro := x,cCarro)},oGrp1,060,008,'',{|| oSay5:settext(Posicione("DA3",1,xFilial("DA3")+cCarro,"DA3_DESC"))},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCarro",,)
        oGet3:bF3:= &('{|| IIf(ConPad1(,,,"DA3",,,.F.),Eval({|| cCarro := DA3->DA3_COD, oGet3:Refresh()}),.T.)}') 
        oSay5      := TSay():New( 056,140,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,252,008)
        
        oSay7      := TSay():New( 076,140,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,236,008)
        
        /*oSay6      := TSay():New( 076,028,{||"Região"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        //{|| updlist(cRegiao,3)}
        oGet4      := TGet():New( 076,068,{|x| If(PCount() > 0,cRegiao := x,cRegiao)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cRegiao",,)
        oGet4:bF3:= &('{|| IIf(ConPad1(,,,"A2",,,.F.),Eval({|| cRegiao := SX5->X5_CHAVE, oGet4:Refresh()}),.T.)}') 
        */
    oGrp2      := TGroup():New( 100,008,296,568,"Pedidos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{108,012,288,564},,, oGrp2 )
            //Pedido,codcliente,loja,nome,codvend,nomevend,recnoc5,status,totalpedido 
        oList1:= 	TCBrowse():New(108,012,550,180,, {'','Pedido','Cliente','Vendedor','Emissão','Status','Valor Pedido'},;
                                    {10,30,130,90,40,75,60},;
                                    oGrp2,,,,{|| Fhelp(oList1:nAt)},{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{If(aList1[oList1:nAt,10],oOk,oNo),; 
                            aList1[oList1:nAt,01],; 
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,19],;
                            aList1[oList1:nAt,08],;
                            Transform(aList1[oList1:nAt,09],"@E 999,999,999.99")}}

    oBtn1      := TButton():New( 304,172,"Salvar",oDlg1,{|| gravar()},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 304,336,"Sair",oDlg1,{||oDlg1:end(nOpc := 0)},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

    
else
    MsgAlert("Não encontrados itens para confirmação")
ENDIF

Return


/*/{Protheus.doc} busca
    (long_description)
    @type  Static Function
    @author user
    @since 26/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function busca(param_name)

Local aArea :=  GetArea()
Local cQuery 
Local nCont

cQuery := "SELECT DISTINCT C5_NUM,C5_CLIENTE,C5_LOJACLI,A1_NOME,C5_VEND1,A3_NOME,"
cQuery += " C5.R_E_C_N_O_ AS RECC5,C5_ZZSTATU,C5_EMISSAO,C5_XZONTRA,"
cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" C6 WHERE C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6_CLI=C5_CLIENTE AND C6_LOJA=C5_LOJACLI AND C6.D_E_L_E_T_=' ') AS TOTAL"
cQuery += " FROM "+RetSQLName("SC5")+" C5"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " WHERE C5.D_E_L_E_T_=' '"
cQuery += " AND C5_ZZSTATU='E'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")
//Pedido,codcliente,loja,nome,codvend,nomevend,recnoc5,status,totalpedido
While !EOF()
    Aadd(aList1,{   TRB->C5_NUM,;
                    TRB->C5_CLIENTE,;
                    TRB->C5_LOJACLI,;
                    TRB->A1_NOME,;
                    TRB->C5_VEND1,;
                    TRB->A3_NOME,;
                    TRB->RECC5,;
                    TRB->C5_ZZSTATU,;
                    TRB->TOTAL,;
                    .F.,;
                    '',;
                    '',;
                    '',;
                    '',;
                    '',;
                    '',;
                    '',;
                    '',;
                    stod(TRB->C5_EMISSAO),;
                    TRB->C5_XZONTRA  })
    Dbskip()
ENDDO

DbSelectArea("SC5")
For nCont := 1 to len(aList1)
    DbGoto(aList1[nCont,07])
    aList1[nCont,08] := Alltrim(aList1[nCont,08])+' - '+U_ZZSTATUAL()
Next nCont

RestArea(aArea)

Return

/*/{Protheus.doc} updlist(cMotor,1)
    (long_description)
    @type  Static Function
    @author user
    @since 26/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function updlist(cOpc,nOpc)

Local aArea :=  GetArea()

If nOpc == 1
    aList1[oList1:nAt,11] := cOpc
    aList1[oList1:nAt,14] := Posicione("DA4",1,xFilial("DA4")+cOpc,"DA4_NOME")
    oSay3:settext("")
    oSay3:settext(aList1[oList1:nAt,14])
    aList1[oList1:nAt,10] := .T.
ElseIf nOpc == 2
    aList1[oList1:nAt,12] := cOpc
    aList1[oList1:nAt,15] := Posicione("DA3",1,xFilial("DA3")+cOpc,"DA3_DESC")
    oSay5:settext("")
    oSay5:settext(aList1[oList1:nAt,15])
    aList1[oList1:nAt,10] := .T.
ElseIf nOpc == 3
    aList1[oList1:nAt,13] := cOpc
    aList1[oList1:nAt,16] := Posicione("SX5",1,xFilial("SX5")+"A2"+cOpc,"X5_DESCRI")
    oSay7:settext("")
    oSay7:settext(aList1[oList1:nAt,16])
    aList1[oList1:nAt,10] := .T.
EndIf

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} Fhelp
    (long_description)
    @type  Static Function
    @author user
    @since 26/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Fhelp(nLinha)
    
Local aArea := GetArea()

oSay7:settext("")

oSay7:settext(If(!Empty(aList1[nLinha,20]),"Zona: "+aList1[nLinha,20],""))

oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} editcol
    (long_description)
    @type  Static Function
    @author user
    @since 30/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha)

Local aArea :=  GetArea()

If aList1[nLinha,10]
    aList1[nLinha,10] := .F.
else
    If dDtEnt < aList1[nLinha,19]
        If MsgYesno("Data de entrega inferior a emissão desta nota, confirma?")
            aList1[nLinha,10] := .T.
        ENDIF
    else
        aList1[nLinha,10] := .T.
    EndIf
ENDIF

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} gravar
    (long_description)
    @type  Static Function
    @author user
    @since 30/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gravar()
    
Local nCont
Local lOk       := .F.

If !Empty(dDtEnt) .And. !Empty(cMotor).And. !Empty(cCarro) //.And. !Empty(cRegiao)

    DbSelectArea("SC5")
    For nCont := 1 to len(aList1)
        If aList1[nCont,10]
            DbGoto(aList1[nCont,07])
            Reclock("SC5",.F.)
            SC5->C5_ZZSTATU := 'X'
            SC5->C5_XMOTOR  := cMotor + '-' + Posicione("DA4",1,xFilial("DA4")+cMotor,"DA4_NOME")
            SC5->C5_XCARRO  := cCarro 
            //SC5->C5_XREGIAO := cRegiao
            SC5->C5_FECENT  := dDtEnt
            lOk := .T.
            SC5->(MsUnlock())
        EndIf
    Next nCont
EndIf

If lOk
    MsgAlert("Registros atualizados")
    oDlg1:end()
EndIf 

Return
