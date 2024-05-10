#INCLUDE 'PROTHEUS.CH'
/*
    Classificação de ativo em lote
    Rotina criada para classificar um lote de ativos pelo grupo e nota fiscal

    MIT 44_Ativo_ATF002_classificação de vários itens de uma única nota fiscal integrada no ativo fixo_

    Doc Mit
    https://docs.google.com/document/d/18po4v29SXvEsJhZ4MxdWKZ3AP12SmRH9/edit
    Doc Validação entrega
    
    
    
*/
User Function JATFA001

Local aParamBox	:= {}
Local cNota     := space(9)
Local cSerie    := space(3)
Local cFilNF    := space(8)
Local cForn     := space(6)
Local cLoj      := space(2)
Local nOpc      := 0
Local nCont     := 0

Private aList := {}
Private oList 
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')
Private lAchou  := .F.
Private aCabec  :=  {}
/*Private cGrupo  := space(TamSx3("N1_GRUPO")[1])
Private cChapa  := space(TamSx3("N1_CHAPA")[1])
Private cConta1 := space(TamSx3("N3_CCONTAB")[1])
Private cCusto1 := space(TamSx3("N3_CUSTBEM")[1])
Private cConta2 := space(TamSx3("N3_CDEPREC")[1])
Private cCusto2 := space(TamSx3("N3_CCUSTO")[1])*/

SetPrvt("oDlg1","oGrp1","oBrw1","oGrp2","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8")
SetPrvt("oSay10","oSay11","oGet1","oGet2","oGet3","oGet4","oGet5","oGet6","oBtn1","oBtn2")


If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","00060228") //00020087
EndIf

aAdd(aParamBox,{01,"Filial"		  			,cFilNF		,""					,"","SM0"	,"", 60,.F.})	// MV_PAR01
aAdd(aParamBox,{01,"Nota"		  			,cNota 		,""					,"","SF1"	,"", 60,.F.})	// MV_PAR01
aAdd(aParamBox,{01,"Serie"		  			,cSerie 	,""					,"",""		,"", 60,.F.})	// MV_PAR01
aAdd(aParamBox,{01,"Fornecedor" 			,cForn 		,""					,"","SA2"	,"", 60,.F.})	// MV_PAR01
aAdd(aParamBox,{01,"Loja"		  			,cLoj    	,""					,"",""		,"", 60,.F.})	// MV_PAR01

If ParamBox(aParamBox,"Filtro",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
    cFilNF := MV_PAR01 
    cNota  := MV_PAR02
    cSerie := MV_PAR03
    cForn  := MV_PAR04
    cLoj   := MV_PAR05
Else 
    Return
EndIf 


cGrupo  := space(TamSx3("N1_GRUPO")[1])
//cChapa  := space(TamSx3("N1_CHAPA")[1])
cConta1 := space(TamSx3("N3_CCONTAB")[1])
cCusto1 := space(TamSx3("N3_CUSTBEM")[1])
cConta2 := space(TamSx3("N3_CDEPREC")[1])
cCusto2 := space(TamSx3("N3_CCUSTO")[1])

aList := Busca(cFilNF,cNota,cSerie,cForn,cLoj)

If len(aList) < 1
    Aadd(aList,{.t.,'','','','','',''})
    MsgAlert("Não foram encontrados registros")
Else 
    lAchou := .T.
EndIf

oDlg1      := MSDialog():New( 092,232,695,1422,"Classificação em Lote",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,008,200,580,"Itens",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,192,576},,, oGrp1 ) 
        oList    := TCBrowse():New(012,012,560,180,, {'','Filial','Código Bem','Item','Quant.','Descrição','Chapa'},;
                                                        {10,60,90,60,50,150,50},;
                                                        oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| /*inverte(1,1)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
        oList:bLine := {||{ If( aList[oList:nAt,01],oOk,oNo),;
                                aList[oList:nAt,02],; 
                                aList[oList:nAt,03],;
                                aList[oList:nAt,04],; 
                                aList[oList:nAt,05],;
                                aList[oList:nAt,06],;
                                aList[oList:nAt,07]}}

    oGrp2      := TGroup():New( 204,008,272,580,"Dados para classificação",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay1      := TSay():New( 220,020,{||"Grupo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet1      := TGet():New( 220,064,{|u| If(Pcount()>0,cGrupo:=u,cGrupo)},oGrp2,060,008,'',{|| Libok(1)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SNG","",,)
        oSay7      := TSay():New( 220,272,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,296,008)
        
        //oSay2      := TSay():New( 220,144,{||"Chapa"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        //oGet2      := TGet():New( 220,196,{|u| If(Pcount()>0,cChapa:=u,cChapa)},oGrp2,060,008,'',{|| Libok(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
        
        
        oSay3      := TSay():New( 244,020,{||"Conta Contabil"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oGet3      := TGet():New( 244,064,{|u| If(Pcount()>0,cConta1:=u,cConta1)},oGrp2,060,008,'',{|| Libok(3)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CT1","",,)
        oSay8      := TSay():New( 259,020,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,008)
        
        oSay4      := TSay():New( 244,144,{||"C.Custo Conta Bem"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,058,008)
        oGet4      := TGet():New( 244,196,{|u| If(Pcount()>0,cCusto1:=u,cCusto1)},oGrp2,060,008,'',{|| Libok(4)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","",,)
        oSay9      := TSay():New( 259,144,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,116,008)
        
        oSay5      := TSay():New( 244,268,{||"Conta Desp. Depreciacao"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
        oGet5      := TGet():New( 244,340,{|u| If(Pcount()>0,cConta2:=u,cConta2)},oGrp2,060,008,'',{|| Libok(5)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CT1","",,)
        oSay10     := TSay():New( 260,268,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,136,008)
        
        
        oSay6      := TSay():New( 244,412,{||"Centro de Custo Despesa"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
        oGet6      := TGet():New( 244,480,{|u| If(Pcount()>0,cCusto2:=u,cCusto2)},oGrp2,060,008,'',{|| Libok(6)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","",,)
        oSay11     := TSay():New( 259,412,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,148,008)
        
    oBtn1      := TButton():New( 276,184,"Confirmar",oDlg1,{||If(MsgYesNo("Confirma a Classificação do grupo?"),oDlg1:end(nOpc:=1),)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 276,336,"Cancelar",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
    oBtn1:disable()

oDlg1:Activate(,,,.T.)

If nOpc == 1
    For nCont := 1 to len(aList)
        If aList[nCont,04] <> '0001'
            cNovoN1 := GETSXENUM("SN1","N1_CBASE")
            ConfirmSX8()
            aList[nCont,03] := cNovoN1
            aList[nCont,04] := '0001'
            aList[nCont,07] := cNovoN1
        Else 
            aList[nCont,07] := aList[nCont,03]
        EndIf 
    Next nCont 

    DbSelectArea("SN3") //9
    For nCont := 1 to len(aList)
        If aList[nCont,01]
            DbSelectArea("SN1") //8
            DbGoto(aList[nCont,08])
            Reclock("SN1",.F.)
            SN1->N1_GRUPO := cGrupo
            SN1->N1_CHAPA := aList[nCont,07]
            SN1->N1_STATUS:= '1'
            SN1->N1_CBASE := aList[nCont,03] 
            SN1->N1_ITEM  := aList[nCont,04]
            SN1->(Msunlock())
            DbSelectArea("SN3")
            DbGoto(aList[nCont,09])
            Reclock("SN3",.F.)
            SN3->N3_HISTOR  := aList[nCont,06]
            SN3->N3_CCONTAB := cConta1
            SN3->N3_CUSTBEM := cCusto1
            SN3->N3_CDEPREC := cConta2
            SN3->N3_CCUSTO  := cCusto2
            SN3->N3_CBASE   := aList[nCont,03] 
            SN3->N3_ITEM    := aList[nCont,04]
            SN3->(Msunlock())
        EndIf 
    Next nCont 

    
    MsgAlert("Processo finalizado!!!")

    GeraPlan()

ENDIF

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 05/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(cFilNF,cNota,cSerie,cForn,cLoj)

Local aArea := GetArea()
Local aRet  := {}

cQuery := "SELECT N1_FILIAL,N1_CBASE,N1_ITEM,N1_QUANTD,N1_DESCRIC,N1.R_E_C_N_O_ AS RECSN1,N3.R_E_C_N_O_ AS RECSN3"
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " INNER JOIN "+RetSQLName("SN3")+" N3 ON N3_FILIAL=N1_FILIAL AND N3_CBASE=N1_CBASE AND N3_ITEM=N1_ITEM AND N3.D_E_L_E_T_=' '"
cQuery += " WHERE N1_FILIAL ='"+cFilNF+"' AND N1.D_E_L_E_T_=' '"
cQuery += " AND N1_NSERIE='"+cSerie+"' AND N1_NFISCAL='"+cNota+"'"
cQuery += " AND N1_FORNEC='"+cForn+"' AND N1_LOJA='"+cLoj+"'"
cQuery += " AND N1_STATUS='0'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("TIINCP01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{.F.,;
                TRB->N1_FILIAL,;
                TRB->N1_CBASE,;
                TRB->N1_ITEM,;
                TRB->N1_QUANTD,;
                TRB->N1_DESCRIC,;
                '',;
                TRB->RECSN1,;
                TRB->RECSN3})
    Dbskip()
EndDo 

Aadd(aCabec,{'Filial',;
            'Codigo_Base',;
            'Item',;
            'Quantidade',;
            'Descrição',;
            'Chapa'})

RestArea(aArea)

Return(aRet)

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

Local nOk   := 0
Local lOk   := .F.
Local nTot  := 5
Local nCont := 1
//Local cBkpCh:= cChapa 

If nOpcao == 1
    lOk := ExistCPO("SNG", cGrupo)
    If !lOk .And. !Empty(cGrupo)
        MsgAlert("Grupo inexistente")
    Else 
        SNG->(Dbseek(xFilial("SNG")+cGrupo))
        cConta1 := SNG->NG_CCONTAB
        cCusto1 := SNG->NG_CUSTBEM 
        cConta2 := SNG->NG_CDEPREC  
        cCusto2 := SNG->NG_CCDESP  
    EndIf 
    oSay7:settext("")
    oSay7:settext(Posicione("SNG",1,xFilial("SNG")+cGrupo,"NG_DESCRIC"))
EndIf

/*
If nOpcao == 2
    DbSelectArea("SN1")
    DbSetOrder(1)
    If Dbseek(xFilial("SN1")+Avkey(cChapa,"N1_CHAPA"))
        MsgAlert("Código de chapa já classificado")
        cChapa := space(TamSx3("N1_CHAPA")[1])
    ELSE
        cChapa := Alltrim(cChapa)
        For nCont := 1 to len(aList)
            aList[nCont,07] := cChapa 
            cChapa := Soma1(cChapa)
        Next nCont 

        cChapa := cBkpCh

    EndIf 
EndIf 
*/
If nOpcao == 3 .Or. !Empty(cConta1)
    lOk := ExistCPO("CT1", cConta1)
    If !lOk .And. !Empty(cConta1)
        MsgAlert("Conta inexistente")
    EndIf

    oSay8:settext("")
    oSay8:settext(Posicione("CT1",1,xFilial("CT1")+cConta1,"CT1_DESC01"))
EndIf 

If nOpcao == 4 .Or. !Empty(cCusto1)
    lOk := ExistCPO("CTT", cCusto1)
    If !lOk .And. !Empty(cCusto1)
        MsgAlert("Centro de Custo inexistente")
    EndIf

    oSay9:settext("")
    oSay9:settext(Posicione("CTT",1,xFilial("CTT")+cCusto1,"CTT_DESC01"))
EndIf 

If nOpcao == 5 .Or. !Empty(cConta2)
    lOk := ExistCPO("CT1", cConta2)
    If !lOk .And. !Empty(cConta2)
        MsgAlert("Conta inexistente")
    EndIf
    oSay10:settext("")
    oSay10:settext(Posicione("CT1",1,xFilial("CT1")+cConta2,"CT1_DESC01"))
EndIf 

If nOpcao == 6 .Or. !Empty(cCusto2)
    lOk := ExistCPO("CTT", cCusto2)
    If !lOk .And. !Empty(cCusto2)
        MsgAlert("Centro de Custo inexistente")
    EndIf

    oSay11:settext("")
    oSay11:settext(Posicione("CTT",1,xFilial("CTT")+cCusto2,"CTT_DESC01"))
EndIf 


If !Empty(cGrupo)
    nOk++
EndIf 
/*
If !Empty(cChapa)
    nOk++
ENDIF*/

If !Empty(cConta1)
    nOk++
EndIf 

If !Empty(cCusto1)
    nOk++
EndIf 

If !Empty(cConta2)
    nOk++
EndIf

If !Empty(cCusto2)
    nOk++
EndIf

If nOk == nTot .And. lAchou
    oBtn1:enable()
    For nCont := 1 to len(aList)
        aList[nCont,01] := .T.
    Next nCont
Else
    oBtn1:disable()
    For nCont := 1 to len(aList)
        aList[nCont,01] := .F.
    Next nCont
EndIf 

oList:refresh()
oDlg1:refresh()

Return


/*/{Protheus.doc} GeraPlan
    (long_description)
    @type  Static Function
    @author user
    @since 04/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraPlan()

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Ativos_classificados_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}

lOCAL cExterno := 'Ativos Classificados'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cExterno) 
oExcel:AddTable (cExterno,cExterno)

For nX := 1 to len(aCabec[1])
    oExcel:AddColumn(cExterno,cExterno,aCabec[1,nX],1,1)
Next nX


For nX := 1 to len(aList)
    aAux := {}
    For nY := 1 to len(aCabec[1])
        Aadd(aAux,aList[nX,nY+1])
    Next nY

    oExcel:AddRow(cExterno,cExterno,aAux)
Next nX



oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

MsgAlert("Relatório finalizado")
	
    
Return(cDir+cArqXls)
