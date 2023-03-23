#include 'protheus.ch'


/*/{Protheus.doc} JUBPF01
@author Rodrigo Barreto
@since 25/01/2023
@version 1.0
  Função consulta títulos em aberto no CR e tabela SYP e atualiza campo A1_OBS.
/*/

user function JUBPF01()

    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local aList := {} // Vetor com elementos do Browse
    Local nX := 0
    Local cQuery := ""

    cQuery := "SELECT E1_CLIENTE,E1_LOJA,A1_NOME,A1_NREDUZ,SUM(CASE WHEN E1_VENCREA < '" +DTOS(DATE())+ "'"
    cQuery += " THEN E1_VALOR END) AS VENCIDOS,SUM(CASE WHEN E1_VENCREA >  '" +DTOS(DATE())+ "'"
    cQuery += " THEN E1_VALOR END) AS ABERTOS,
    cQuery += " A1_OBS FROM "+RetSQLName('SE1')+" E1"
    cQuery += " INNER JOIN "+RetSQLName('SA1')+ " A1 ON"
    cQuery += " A1_FILIAL = E1_FILIAL AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1.D_E_L_E_T_='' "
    cQuery += " WHERE E1_SALDO > 0 AND E1.D_E_L_E_T_='' "
    cQuery += " GROUP BY E1_CLIENTE,E1_LOJA, A1_NOME,A1_NREDUZ,A1_OBS"
    cQuery += " ORDER BY E1_CLIENTE, E1_LOJA "

    If Select("TMP") <> 0
        DbSelectArea("TMP")
        DbCloseArea()
    EndIf

    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

    dbSelectArea("TMP")
    TMP->(dbGoTop())

    //nMens := 1

    While TMP->(!EOF())

        cHist := ""
        cChav := TMP->A1_OBS //chave da SYP
        //BUSCAR DADOS NA SYP
        If !EMPTY(cChav)

            cQueSYP := "SELECT YP_TEXTO,YP_CHAVE, * FROM"+RetSQLName('SYP')+" YP "
            cQueSYP += "WHERE YP_CAMPO = 'A1_OBS' AND YP_CHAVE = '"+cChav+"' AND YP.D_E_L_E_T_=''"

            If Select("TMPSYP") <> 0
                DbSelectArea("TMPSYP")
                DbCloseArea()
            EndIf

            cQueSYP := ChangeQuery(cQueSYP)
            DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueSYP),'TMPSYP',.F.,.T.	)

            dbSelectArea("TMPSYP")
            TMPSYP->(dbGoTop())

            nMens := 1


            While TMPSYP->(!EOF())

                //cHist :=""//+= strzero(nMens,3)
                //cHist += " Mensagem: "
                If substr(alltrim(TMPSYP->YP_TEXTO),-5,5) == "13\10"
                    cHist += substr(alltrim(TMPSYP->YP_TEXTO),1,LEN(alltrim(TMPSYP->YP_TEXTO))-5) +" "
                Else
                    cHist += alltrim(TMPSYP->YP_TEXTO)+"  "
                EndIf

                nMens += 1
                TMPSYP->(dbSkip())
            EndDo
        Else

            nMens := 1

        EndIf

        aListAux := {.T., TMP->E1_CLIENTE , TMP->A1_NREDUZ,TMP->A1_NOME,TMP->VENCIDOS, TMP->ABERTOS, cHist,;
            space(250),cChav,(nMens-1),TMP->E1_LOJA }

        aadd(aList, aListAux)

        TMP->(dbSkip())

    EndDo

    //DEFINE MSDIALOG oDlg FROM 0,0 TO 800,1400 PIXEL TITLE 'Painel Financeiro'
    DEFINE MSDIALOG oDlg FROM 0,0 TO 800,1900 PIXEL TITLE 'Painel Financeiro'

    // Cria objeto de fonte que sera usado na Browse
    Define Font oFont Name 'Courier New' Size 0, -12
    // Cria Browse
    // oList := TCBrowse():New( 01 , 01, 300, 200,,{'','Codigo','Descrição','Valor'},{20,50,50,50},oDlg,,,,,{||},,oFont,,,,,.F.,,.T.,,.F.,,, )
    oList := TCBrowse():New(01, 01, 950, 370,,{'','Codigo Cliente','Nome Fantasia','Nome','Vencidos','A Vencer','Histórico','Atualização'},{20,50,50,50},oDlg,,,,,{||},,oFont,,,,,.F.,,.T.,,.F.,,,)
    // Seta o vetor a ser utilizado
    oList:SetArray(aList)
    // Monta a linha a ser exibina no Browse
    oList:bLine := {||{ If(;
        aList[oList:nAt,01],oOK,oNO),;
        aList[oList:nAt,02],;
        aList[oList:nAt,03],;
        aList[oList:nAt,04],;
        Transform(aList[oList:nAT,05],'@E 99,999,999,999.99') ,;
        Transform(aList[oList:nAT,06],'@E 99,999,999,999.99'),;
        aList[oList:nAt,07],;
        aList[oList:nAt,08],;
        } }

    // Evento de DuploClick (troca o valor do primeiro elemento do Vetor)
    oList:bLDblClick := {|| aList[oList:nAt][1] :=;
        !aList[oList:nAt][1],oList:DrawSelect() }
    // Principais commandos
    // oBtn := TButton():New( 210, 001,'GoUp()' , oDlg,{||oList:GoUp()},40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
    //  oBtn := TButton():New( 220, 001,'GoDown()', oDlg,{||oList:GoDown()},40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
    //  oBtn := TButton():New( 230, 001,'GoTop()' , oDlg,{||oList:GoTop()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
    //   oBtn := TButton():New( 240, 001,'GoBottom()', oDlg,{||oList:GoBottom()},40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
    //   oBtn := TButton():New( 210, 060, 'nAt (Linha selecionada)' ,oDlg,{|| Alert(oList:nAt)},90, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
    //  oBtn := TButton():New( 220, 060, 'nRowCount (Nr de linhas visiveis)',oDlg,{|| Alert(oList:nRowCount()) }, 90, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
    //oBtn := TButton():New( 230, 060, 'nLen (Numero total de linhas)', oDlg,{|| Alert(oList:nLen) }, 90, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
    oBtn := TButton():New( 375, 675,"Pesquisar",oDlg,{|| u_PesCli()},040,015,,,,.T.,,"",,,,.F. )
    oBtn := TButton():New( 375, 725,"Excel",oDlg,{|| ExpExc01()},040,015,,,,.T.,,"",,,,.F. )
    oBtn := TButton():New( 375, 775, 'Atualizar Registro', oDlg,{|| lEditCell(@aList,oList,'@!',8) }, 060, 015,,,.F.,.T.,.F.,,.F.,,,.F. )
    oBtn := TButton():New( 375, 850,"Salvar",oDlg,{|| u_AtuaObs()},040,015,,,,.T.,,"",,,,.F. )

    ACTIVATE MSDIALOG oDlg CENTERED
return


//Atualizar registro
//ExpExc01
User function AtuaObs()
    Local nAtu := 0

    For nAtu := 1 to len(Olist:AARRAY)
        If !EMPTY(Olist:AARRAY[nAtu][8])
            If !EMPTY(Olist:AARRAY[nAtu][9])
                //  MSMM(Olist:AARRAY[nAtu][9],,,ALLTRIM(Olist:AARRAY[nAtu][8])+" " + dtoc(Date()),1,40,.F.,'SA1','A1_OBS',,.T.)
                MSMM(Olist:AARRAY[nAtu][9],,, dtoc(Date()) + ": " + ALLTRIM(Olist:AARRAY[nAtu][8])+" ",1,40,.F.,'SA1','A1_OBS',,.T.)
                //MSMM(,6[1],,ALLTRIM(Olist:AARRAY[nAtu][8]) + dtoc(Date()),1,,,"SA1","A1_OBS")
            Else
                SA1->(DbSetOrder(1))
                If SA1->(DbSeek(xFilial("SA1") + Olist:AARRAY[nAtu][2] + Olist:AARRAY[nAtu][11] ))
                    // SA1->A1_OBS := MSMM(Olist:AARRAY[nAtu][9],,,ALLTRIM(Olist:AARRAY[nAtu][8]) +" "+ dtoc(Date()),1,40,.F.,'SA1','A1_OBS',,.f.)
                    SA1->A1_OBS := MSMM(Olist:AARRAY[nAtu][9],,,dtoc(Date()) + ": " + ALLTRIM(Olist:AARRAY[nAtu][8]) +" ",1,40,.F.,'SA1','A1_OBS',,.f.)
                    //MSMM(Olist:AARRAY[nAtu][9],,,,ALLTRIM(Olist:AARRAY[nAtu][8]) + dtoc(Date()),1,,,"SA1","A1_OBS")
                EndIf
            EndIf
        EndIf
    Next nAtu

Return

//gera excel

Static Function ExpExc01()

    Local cDirTmp
    Local cArq 	  := ""
    Local oExcel  := FWMSEXCEL():New()
    Local lOK 	  := .F.
    Local x := 0

    oExcel:SetLineFrColor("#000")
    oExcel:SetTitleFrColor("#000")
    oExcel:SetFrColorHeader("#000")

    oExcel:AddWorkSheet("Painel Financeiro")
    oExcel:AddTable("Painel Financeiro","Painel Financeiro")
    oExcel:AddColumn("Painel Financeiro","Painel Financeiro", Olist:AHEADERS[2]               		,2,1)
    oExcel:AddColumn("Painel Financeiro","Painel Financeiro",Olist:AHEADERS[3]          	,1,1)
    oExcel:AddColumn("Painel Financeiro","Painel Financeiro",Olist:AHEADERS[4]            	,2,1)
    oExcel:AddColumn("Painel Financeiro","Painel Financeiro",Olist:AHEADERS[5]          	  			,2,1)
    oExcel:AddColumn("Painel Financeiro","Painel Financeiro",Olist:AHEADERS[6]      			,2,1)
    oExcel:AddColumn("Painel Financeiro","Painel Financeiro",Olist:AHEADERS[7]        		,1,1)
    oExcel:AddColumn("Painel Financeiro","Painel Financeiro",Olist:AHEADERS[8]              		,2,1)

    x := 0
    For x := 1 to len(Olist:AARRAY)

        oExcel:AddRow("Painel Financeiro","Painel Financeiro",;
            {Olist:AARRAY[x][2],Olist:AARRAY[x][3],Olist:AARRAY[x][4],Olist:AARRAY[x][5],Olist:AARRAY[x][6],Olist:AARRAY[x][7],Olist:AARRAY[x][8]})

        lOK := .T.
    Next x

    cDirTmp:= cGetFile( '*.csv|*.csv' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

    oExcel:Activate()

    cArq := CriaTrab(NIL, .F.) +"_FUP-Compras_"+dToS(date())+ ".xml"
    oExcel:GetXMLFile(cArq)

    If __CopyFile(cArq,cDirTmp + cArq)
        If lOK
            oExcelApp := MSExcel():New()
            oExcelApp:WorkBooks:Open(cDirTmp + cArq)
            oExcelApp:SetVisible(.T.)
            oExcelApp:Destroy()
            MsgInfo("O arquivo Excel foi gerado no dirtério: " + cDirTmp + cArq + ". ")
        EndIf
    Else
        MsgAlert("Erro ao criar o arquivo Excel!")
    EndIf

Return

//PesCli
User Function PesCli

    Local nX := 0
    Local cBusc := space(20)
    Local aPergs := {}
    Local cPar1   := ""
    Local cPar2 := ""
    Local nOpc := Space(1)

    aAdd(aPergs, {1, "Digite a consulta:  ",			 		cBusc,  "",  ".T.",   "",  ".T.", 80,  .T.})
    aAdd(aPergs, {2, "Buscar por ? ", 				nOpc,{"1=Nome", "2=Fantasia"}, 80, ".T.", .F.	})

    If ParamBox(aPergs, "Pesquisando.. ")
        cPar1 := UPPER(MV_PAR01)
        cPar2 := MV_PAR02

        For Nx := Olist:nAt to Len(Olist:AARRAY)

            If cPar2 == '1'
                If alltrim(cPar1) $ Olist:AARRAY[Nx][4]
                    Olist:GoPosition(Nx)
                    Olist:setFocus()
                EndIf
            Else
                If alltrim(cPar1) $ Olist:AARRAY[Nx][3]
                    Olist:GoPosition(Nx)
                    Olist:setFocus()
                EndIf
            EndIf
        Next nX
    EndIf


Return
