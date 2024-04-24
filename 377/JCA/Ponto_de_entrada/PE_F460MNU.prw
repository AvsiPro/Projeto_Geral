#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} Ponto de entrada
    Incluir itens no Menu da rotina de liquidação
    Utilizado para incluir a opção de envio do email da liquidação gerada
    @author user
    @since 26/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function F460MNU()
 
Local aRotRet   := aClone(PARAMIXB[1])
 
aAdd( aRotRet,{"Enviar Email Liq.", "u_xf460m()", 0, 7})
 
Return aRotRet

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 26/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function xf460m()
 
Local cQuery 
Local aPergs := {}
Local aRet   := {}
Local dDatad := ctod(' / / ')
Local dDataa := ctod(' / / ')
Local aAux   := {}
Local nCont 
Local aItens := {}
Local aNovos := {}

If MsgYesNo("Deseja enviar somente a selecionada?")

    aAdd(aPergs ,{1,"Banco"	        ,space(TamSx3("EE_CODIGO")[1])   ,"@!",".T.","SA6",".T.",80,.T.})
    aAdd(aPergs ,{1,"Agência"	    ,space(TamSx3("EE_AGENCIA")[1])   ,"@!",".T.","",".T.",80,.T.})
    aAdd(aPergs ,{1,"Conta"	        ,space(TamSx3("EE_CONTA")[1])   ,"@!",".T.","",".T.",80,.T.})
    aAdd(aPergs ,{1,"Sub-Conta"	    ,space(TamSx3("EE_SUBCTA")[1])   ,"@!",".T.","",".T.",80,.T.})
    
    If ParamBox(aPergs ,"Filtrar por",@aRet)    
        
        MV_PAR19 := aRet[4]
        MV_PAR20 := aRet[1]
        MV_PAR21 := aRet[2]
        MV_PAR22 := aRet[3]
    EndIf 

    cFil  := FO0->FO0_FILIAL
    cProc := FO0->FO0_PROCES
    cVers := FO0->FO0_VERSAO
    cNuml := FO0->FO0_NUMLIQ
    cCli  := FO0->FO0_CLIENT+FO0->FO0_LOJA+Posicione("SA1",1,xFilial("SA1")+FO0->FO0_CLIENT+FO0->FO0_LOJA,"A1_CGC")
    cNome := Posicione("SA1",1,xFilial("SA1")+FO0->FO0_CLIENT+FO0->FO0_LOJA,"A1_NOME")
    cEmail:= Posicione("SA1",1,xFilial("SA1")+FO0->FO0_CLIENT+FO0->FO0_LOJA,"A1_EMAIL")

    cTit := ''
    dDtv := ''
    nSld := 0
    nVlr := 0

    DbSelectArea("SE1")
    DbSetOrder(15)
    If Dbseek(cFil+FO0->FO0_NUMLIQ)
        While !EOF() .AND. SE1->E1_FILIAL == cFil .AND. SE1->E1_NUMLIQ == FO0->FO0_NUMLIQ
            cTit := SE1->E1_PREFIXO+'/'+SE1->E1_NUM+'/'+SE1->E1_PARCELA
            dDtv := dtos(SE1->E1_VENCREA) 
            dDtE := dtos(SE1->E1_EMISSAO) 
            nSld := SE1->E1_SALDO
            nVlr := SE1->E1_VALOR 
            Aadd(aNovos,{cTit,dDtv,nSld,nVlr,dDtE})
            Dbskip()
        ENDDO
    EndIf 


    Aadd(aAux,{cFil,cProc,cVers,cNuml,cCli,cNome,cEmail,aNovos})

    
Else

    aAdd(aPergs ,{1,"Filial de:"	,space(TamSx3("BZ_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
    aAdd(aPergs ,{1,"Filial Até:"	,padr('zz',TamSx3("BZ_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
    aAdd(aPergs ,{1,"Data de"	    ,dDatad ,"@!",".T.","",".T.",60,.F.})
    aAdd(aPergs ,{1,"Data Até"	    ,dDataa ,"@!",".T.","",".T.",60,.F.})
    aAdd(aPergs ,{1,"Cliente de"    ,space(TamSx3("A1_COD")[1])   ,"@!",".T.","SA1",".T.",80,.F.})
    aAdd(aPergs ,{1,"Cliente Até"	,padr('zz',TamSx3("A1_COD")[1])   ,"@!",".T.","SA1",".T.",80,.F.})

    aAdd(aPergs ,{1,"Banco"	        ,space(TamSx3("EE_CODIGO")[1])   ,"@!",".T.","SA6",".T.",80,.T.})
    aAdd(aPergs ,{1,"Agência"	    ,space(TamSx3("EE_AGENCIA")[1])   ,"@!",".T.","",".T.",80,.T.})
    aAdd(aPergs ,{1,"Conta"	        ,space(TamSx3("EE_CONTA")[1])   ,"@!",".T.","",".T.",80,.T.})
    aAdd(aPergs ,{1,"Sub-Conta"	    ,space(TamSx3("EE_SUBCTA")[1])   ,"@!",".T.","",".T.",80,.T.})
    
    If ParamBox(aPergs ,"Filtrar por",@aRet)    
        MV_PAR01 := aRet[1]
        MV_PAR02 := aRet[2]
        MV_PAR03 := aRet[3]
        MV_PAR04 := aRet[4]
        MV_PAR05 := aRet[5]
        MV_PAR06 := aRet[6]

        MV_PAR19 := aRet[7]
        MV_PAR20 := aRet[8]
        MV_PAR21 := aRet[9]
        MV_PAR22 := aRet[10]
        

        cQuery := "SELECT DISTINCT FO0.FO0_FILIAL,FO0.FO0_PROCES,"
        cQuery += " FO0.FO0_VERSAO,FO0.FO0_NUMLIQ,"
        cQuery += " SA1.A1_COD,SA1.A1_NOME,SA1.A1_EMAIL,SA1.A1_LOJA,SA1.A1_CGC,SE1.E1_EMISSAO,"
        cQuery += " SE1.E1_PREFIXO+'/'+SE1.E1_NUM+'/'+SE1.E1_PARCELA AS TIT,SE1.E1_VENCREA,SE1.E1_SALDO,SE1.E1_VALOR" 
        cQuery += " FROM "+RetSQLName("FO0")+" FO0"
        cQuery += " INNER JOIN "+RetSQLName("SA1")+" SA1 ON A1_FILIAL='"+xFilial("SA1")+"'" 
        cQuery += "        AND FO0.FO0_CLIENT = SA1.A1_COD "
        cQuery += " INNER JOIN "+RetSQLName("SE1")+" SE1 ON E1_FILIAL=FO0_FILIAL AND E1_NUMLIQ=FO0_NUMLIQ AND SE1.D_E_L_E_T_=' '"
        cQuery += " WHERE  FO0.FO0_DATA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
        cQuery += "        AND FO0.FO0_DTVALI BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'" 
        cQuery += "        AND FO0.FO0_CLIENT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'" 
        cQuery += "        AND FO0.FO0_LOJA BETWEEN ' ' AND 'ZZ' "
        cQuery += "        AND FO0.FO0_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND FO0.D_E_L_E_T_=' ' "
        cQuery += "        AND SA1.D_E_L_E_T_=' ' "
        cQuery += " ORDER BY  FO0.FO0_FILIAL, FO0.FO0_PROCES, FO0.FO0_VERSAO "

        IF Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        ENDIF

        MemoWrite("F460MNU.SQL",cQuery)
        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        DbSelectArea("TRB")  

        WHILE !EOF()
            lNew := .F.
            If Ascan(aNovos,{|x| x[1] == TRB->TIT}) == 0
                Aadd(aNovos,{TRB->TIT,;
                            TRB->E1_VENCREA,;
                            TRB->E1_SALDO,;
                            TRB->E1_VALOR,;
                            TRB->E1_EMISSAO})
                lNew := .T.
            EndIf 

            nPos := Ascan(aAux,{|x| x[1]+x[2]+x[3] == TRB->FO0_FILIAL+TRB->FO0_PROCES+TRB->FO0_VERSAO})
            If nPos == 0
                Aadd(aAux,{TRB->FO0_FILIAL,;
                            TRB->FO0_PROCES,;
                            TRB->FO0_VERSAO,;
                            TRB->FO0_NUMLIQ,;
                            TRB->A1_COD+TRB->A1_LOJA+TRB->A1_CGC,;
                            TRB->A1_NOME,;
                            TRB->A1_EMAIL,;
                            aNovos})
            Else 
                If lNew 
                    Aadd(aAux[len(aAux),08],aNovos)
                EndIf
            EndIf 
            Dbskip()
        EndDo 

    EndIf 

EndIF 


If len(aAux) > 0

    For nCont := 1 to len(aAux)
        
        Aadd(aItens,aAux[nCont])

        cQuery := "SELECT 	FO1.FO1_FILIAL ,
        cQuery += " 		SE1.E1_PREFIXO+'/'+SE1.E1_NUM+'/'+SE1.E1_PARCELA+'/'+SE1.E1_TIPO TIT,
        cQuery += " 		SE1.E1_NOMCLI,SE1.E1_NATUREZ,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_EMISSAO,"
        cQuery += " 		FO1.FO1_SALDO,FO1.FO1_TXMUL,FO1.FO1_VLMUL,FO1.FO1_TXJUR,"
        cQuery += " 		FO1.FO1_VLJUR,FO1.FO1_VLDIA,FO1.FO1_ACRESC,FO1.FO1_DECRES,FO1.FO1_DESCON,"
        cQuery += " 		FO1.FO1_VLABT,FO1.FO1_VACESS,FO1.FO1_TOTAL"
        cQuery += " 		FROM "+RetSQLName("FO1")+" FO1,"+RetSQLName("FK7")+" FK7,"+RetSQLName("SE1")+" SE1"		
        cQuery += " 		WHERE		  				        
        cQuery += " 		FO1.FO1_FILIAL = '"+aAux[nCont,01]+"' AND			       			  
        cQuery += " 		FO1.FO1_PROCES = '"+aAux[nCont,02]+"'	AND
        cQuery += " 		FO1.FO1_VERSAO = '"+aAux[nCont,03]+"'	AND	 
        cQuery += " 		FO1.FO1_IDDOC = FK7.FK7_IDDOC AND    
        cQuery += " 		SE1.E1_FILIAL + '|' + SE1.E1_PREFIXO + '|' + SE1.E1_NUM + '|' + SE1.E1_PARCELA + '|' + SE1.E1_TIPO + '|' + SE1.E1_CLIENTE + '|' + SE1.E1_LOJA	= FK7.FK7_CHAVE AND  
        cQuery += " 		FO1.D_E_L_E_T_=' ' AND SE1.D_E_L_E_T_=' ' AND FK7.D_E_L_E_T_=' '"
        cQuery += " 		ORDER BY FO1.FO1_FILIAL"

        IF Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        ENDIF

        MemoWrite("F460MNU.SQL",cQuery)
        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        DbSelectArea("TRB")  

        WHILE !EOF()
            Aadd(aItens[len(aItens)],{TRB->TIT,TRB->E1_VENCREA,TRB->FO1_SALDO,TRB->FO1_TOTAL,TRB->E1_EMISSAO})    
            Dbskip()
        EndDo 

    Next nCont 
EndIF 

If len(aItens) > 0
    Processa({|| xf460a(aItens)},"Aguarde")
EndIF 

Return

/*/{Protheus.doc} xf460a()escription)
    @type  Static Function
    @author user
    @since 26/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xf460a(aItens)

Local nCont 
Local aAttach := {}

Private oHtml


Private cMarca  	:= GetMark()

If len(aItens[1]) >= 8
    For nCont := 1 to len(aItens[1,8])
        aChave := separa(aItens[1,8,nCont,01],"/")
        DbSelectArea("SE1")
        DbsetOrder(1)
        If Dbseek(aItens[1,1]+aChave[1]+aChave[2]+aChave[3]) //+aChave[4])
            Reclock("SE1",.F.)
            Replace E1_OK With cMarca
            MsUnLock()
        EndIf
    Next nCont 

    lBolSeparado := .f.
/*
    MV_PAR19 := SUPERGETMV("TI_SUBCTA",.F.,'123') //sub-conta
    MV_PAR20 := SUPERGETMV("TI_BNCBOL",.F.,'001') //banco
    MV_PAR21 := SUPERGETMV("TI_AGEBOL",.F.,'0005') //agencia     
    MV_PAR22 := SUPERGETMV("TI_CNTBOL",.F.,'139074') // conta
*/
    CCMPVENCTO := SE1->E1_VENCTO


    cFileBol := U_RF01BImp(.f.)
    If !'.pdf' $ cFileBol
        cFileBol := alltrim(cFileBol)+'.pdf'
    EndIf 

    cpyt2s(alltrim(cFileBol),'\spool\')
    aAux := separa(cFileBol,"\")
    cNewloc := '\spool\'+aaux[len(aaux)]
    
    Aadd(aAttach,cNewloc)

    cArqHTML    := "\workflow\Aviso_Liquidacao.html"
    cPathHTML   := GetMV("MV_WFDIR") 

    For nCont := 1 to len(aItens)
        oHtml := TWFHtml():New( cArqHTML )

        //oHTML:ValByName("E1_TIT",aItens[nCont,8])
        oHTML:ValByName("E1_EMISSAO",stod(aItens[nCont,8,1,5]))
        oHTML:ValByName("A1_NOME",aItens[nCont,6])
        oHTML:ValByName("A1_CODIGO",substr(aItens[nCont,5],1,6))
        oHTML:ValByName("A1_CGC",Transform(substr(aItens[nCont,5],9),"@R 99.999.999/9999-99"))
        oHTML:ValByName("A1_LOJA",substr(aItens[nCont,5],7,2))
        
        cItens := xGermail(aItens[nCont,8],1)
        oHTML:ValByName("linhasnovo",cItens)
        
        cItens := xGermail(aItens[nCont],2)
        oHTML:ValByName("linhasliq",cItens)
        //cMail := 'alexandre.venancio@avsipro.com.br' // pode ser obtido de um parâmetro
        aSM0Data2 := FWSM0Util():GetSM0Data(cEmpAnt,aItens[1,1])
		cDetalhe := Alltrim(aSM0Data2[3,02])
        cSubject := 'FATURAS '+substr(aItens[1,8,1,1],4,9)+' | '+cDetalhe
        
        cAssina := Alltrim(aSM0Data2[3,02])+"<br>"
        cAssina += 'Departamento Financeiro <br>'
        cAssina += Alltrim(aSM0Data2[14,02])+"<br>"
        cAssina += 'Tel '+Alltrim(aSM0Data2[6,02])+"<br>"
        cAssina += "financeiro@jca.com.br<br>"
        oHTML:ValByName("assinatura",cAssina)

        cFileName    := CriaTrab(NIL,.F.) + ".htm"
        cFileName    := cPathHTML + "\" + cFileName 
        oHtml:SaveFile(cFileName)

        cRet         := WFLoadFile(cFileName)
        cMensagem    := StrTran(cRet,chr(13),"")
        cMensagem    := StrTran(cRet,chr(10),"")
        cMensagem    := OemtoAnsi(cMensagem)
        
        cEmailTst := SUPERGETMV( "TI_EMAILTST", .F., "" ) // email de teste
        U_JGENX002(cEmailTst,cSubject,cMensagem,cNewloc,.F.)

    Next nCont 
EndIf

Return


/*/{Protheus.doc} xGermail
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xGermail(aArray,nOpc)

Local aArea := GetArea()
Local nCont1 := 0
Local cRet   := ''
Local cConteudo := ''
Local cLinha := ''
Local aArray2 := {'E1_NUM','E1_VENCREA','E1_SALDO','E1_VALOR'}
Local nX 

cRet := '<tr>'     
cRet += '    <td width=200><strong>!E1_NUM!</strong></td>'
cRet += '    <td width=070><strong>!E1_VENCREA!</strong></td>'
cRet += '    <td width=100 align=right><strong>!E1_SALDO!</strong></td>'
cRet += '    <td width=100 align=right><strong>!E1_VALOR!</strong></td>'
cRet += '</tr>'

For nCont1 := If(nOpc==1,1,9) to len(aArray)
    cLinha += cRet
    For nX := 1 to len(aArray2)
        aAuxCmp := FWSX3Util():GetFieldStruct( FwCutOff(aArray2[nX]) )
        cConteudo := ''
        If aAuxCmp[2] == "N"
            cConteudo := Transform(aArray[nCont1,nX],"@E 999,999,999.99")
        ElseIf aAuxCmp[2] == "D"
            cConteudo := cvaltochar(stod(aArray[nCont1,nX]))
        Else 
            cConteudo := FwCutOff(aArray[nCont1,nX],.t.)
        EndIf
        cLinha := strtran(cLinha,"!"+aArray2[nX]+"!",cConteudo)
    Next nX
Next nCont1

RestArea(aArea)

Return(cLinha)
