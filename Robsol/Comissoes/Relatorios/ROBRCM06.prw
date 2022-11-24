#INCLUDE 'protheus.ch'
#Include 'tbiconn.ch'

Static Function PPeri()
    
    Local aArea     :=    GetArea()
    Local cPerg1    :=    FirstDate(Date())
    Local cPerg2    :=    LastDate(Date())
    Local cPerg3    :=    "000000"
    Local cPerg4    :=    "ZZZZZZ"
    Local cPerg5    :=    "000000"
    Local cPerg6    :=    "ZZZZZZ"
    Local cPerg7    :=    "626" + Space(20)
    Local aPerg     :=    {}
    Local aAux      :=    {}

    aAdd(aPerg, {1, "Data de Emissao de: " ,   cPerg1,  "", ".T.", "",    ".T.",    90,  .T.})
    aAdd(aPerg, {1, "Data de Emissao ate: " ,  cPerg2,  "", ".T.", "",    ".T.",    90,  .T.})
    aAdd(aPerg, {1, "Representante de: " ,     cPerg3,  "", ".T.", "SA3", ".T.",    90,  .T.})
    aAdd(aPerg, {1, "Representante ate: " ,    cPerg4,  "", ".T.", "SA3", ".T.",    90,  .T.})
    aAdd(aPerg, {1, "Pedido de: " ,            cPerg5,  "", ".T.", "SC5", ".T.",    90,  .T.})
    aAdd(aPerg, {1, "Pedido ate: " ,           cPerg6,  "", ".T.", "SC5", ".T.",    90,  .T.})
    aAdd(aPerg, {1, "TES: " ,                  cPerg7,  "", ".T.", "",    ".T.",    90,  .T.})
    aAdd(aPerg, {9, "Caso queira adicionar outras TES ao relatório, adicionar no formato '001,002,003,004'", 250, 7, .F.})

    If ParamBox(aPerg, "Informe os parâmetros desejados!")
        
        cPerg1  := "'" + DtoS(MV_PAR01) + "'"
        cPerg2  := "'" + DtoS(MV_PAR02) + "'"
        cPerg3  := "'" + MV_PAR03 + "'"
        cPerg4  := "'" + MV_PAR04 + "'"
        cPerg5  := "'" + MV_PAR05 + "'"
        cPerg6  := "'" + MV_PAR06 + "'"
        cPerg7  := "'" + StrTran(AllTrim(MV_PAR07), ",", "','") + "'"

        Aadd(aAux, cPerg1)
        Aadd(aAux, cPerg2)
        Aadd(aAux, cPerg3)
        Aadd(aAux, cPerg4)
        Aadd(aAux, cPerg5)
        Aadd(aAux, cPerg6)
        Aadd(aAux, cPerg7)
        
    else
        
        aAux := {}

    ENDIF

    RestArea(aArea)

Return(aAux)

/*/{Protheus.doc} User Function ROBRCM06
    @type  Function
    @author Diogo de Jesus Gasparini
    @since 21/11/2022
    @version 1
    /*/

User Function ROBRCM06()

    Local cQuery      :=    ""
    Local cArq        :=    ""
    Local cNome       :=    "Relatorio Bonificacoes"
    Local cTabela     :=    "Relatorio"
    Local aParams     :=    {}
    Local aAux1       :=    {}
    Local aAux2       :=    {}
    Local nX          :=    0
    Local nY          :=    0
    Local cDirTmp     :=    ""
    Local oExcel
    Local dDataGer    :=    Date()
    Local cHoraGer    :=    Time()

    if Select("SM0") == 0
        
        RpcSetType(3)
        RpcSetEnv('01', '0103')

    endif

    aParams  := PPeri()

    if len(aParams) == 0
        
        RETURN

    endif

    oExcel := FWMSEXCEL():New()

    cQuery := " "
    cQuery += " SELECT DISTINCT C5_FILIAL,C5_NUM,C5_CLIENTE,A1_NOME,C5_VEND1,A3_NOME,C5_EMISSAO,C5_NOTA FROM " + RetSQLName("SC5") + " SC5 "
    cQuery += " INNER JOIN " + RetSQLName("SC6") + " SC6 ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL "
    cQuery += " INNER JOIN " + RetSQLName("SA3") + " SA3 ON A3_COD = C5_VEND1 AND A3_FILIAL = '" + xFilial("SA3") + "' "
    cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON A1_COD = C5_CLIENTE AND A1_FILIAL = '" + xFilial("SA1") + "' "
    cQuery += " WHERE C6_TES IN (" + aParams[7] + ") "
    cQuery += " AND C5_EMISSAO BETWEEN " + aParams[1] + " AND " + aParams[2] + " "
    cQuery += " AND C5_VEND1 BETWEEN " + aParams[3] + " AND " + aParams[4] + " "
    cQuery += " AND C5_NUM BETWEEN " + aParams[5] + " AND " + aParams[6] + " "
    cQuery += " AND C5_FILIAL = '" + xFilial("SC5") + "' "
    cQuery += " AND SC5.D_E_L_E_T_ = '' "
    cQuery += " AND SC6.D_E_L_E_T_ = '' "
    cQuery += " AND SA3.D_E_L_E_T_ = '' "
    cQuery += " ORDER BY C5_NUM "

    If Select('TRB') > 0
		
        dbSelectArea('TRB')
		dbCloseArea()

	EndIf
    
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
    While !EOF()

        if AllTrim(TRB->C5_NOTA) == ''
            
            cNota := "Sem nota"

        else
            
            cNota := TRB->C5_NOTA

        endif

        Aadd(aAux1, {TRB->C5_FILIAL,TRB->C5_NUM,TRB->C5_CLIENTE,TRB->A1_NOME,TRB->C5_VEND1,TRB->A3_NOME, SubStr(TRB->C5_EMISSAO, 7, 2) + "/" + SubStr(TRB->C5_EMISSAO, 5, 2) + "/" + SubStr(TRB->C5_EMISSAO,1,4),cNota})

        DBSKIP()

    ENDDO

    for nX := 1 to len(aAux1)
        
        Aadd(aAux2, {})

        cQuery := " "
        cQuery += " SELECT * "
        cQuery += " FROM " + RetSQLName("SC6") + " SC6 "
        cQuery += " INNER JOIN " + RetSQLName("SC5") + " SC5 ON C6_FILIAL = C5_FILIAL "
        cQuery += " AND C6_NUM = C5_NUM "
        cQuery += " WHERE C5_NUM = '" + aAux1[nX,1] + "' "
        cQuery += " AND C6_TES IN (" + aParams[7] + ") "
        cQuery += " AND SC6.D_E_L_E_T_ = '' "
        cQuery += " AND SC5.D_E_L_E_T_ = '' "
        cQuery += " AND C6_FILIAL = " + xFilial('SC6') + " "
        cQuery += " ORDER BY C6_ITEM "

        If Select('TRB') > 0
            
            dbSelectArea('TRB')
            dbCloseArea()

        EndIf
        
        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
        
        While !EOF()

            Aadd(aAux2[nX], {TRB->C6_ITEM,TRB->C6_PRODUTO,TRB->C6_DESCRI,TRB->C6_QTDVEN,TRB->C6_PRCVEN,TRB->C6_VALOR, "",""})

            DBSKIP()

        ENDDO
        
    next

    oExcel:AddworkSheet(cNome) 

    oExcel:AddTable (cNome,cTabela)
    oExcel:AddColumn(cNome,cTabela,"" ,1,1)
    oExcel:AddColumn(cNome,cTabela,"" ,1,1)
    oExcel:AddColumn(cNome,cTabela,"" ,1,1)
    oExcel:AddColumn(cNome,cTabela,"" ,1,1)
    oExcel:AddColumn(cNome,cTabela,"" ,1,1)
    oExcel:AddColumn(cNome,cTabela,"" ,1,1)
    oExcel:AddColumn(cNome,cTabela,"" ,1,1)
    oExcel:AddColumn(cNome,cTabela,"" ,1,1)

    for nX := 1 to len(aAux1)

        oExcel:AddRow(cNome, cTabela, {"Filial","Numero do PV","COD Cliente","Nome Cliente","COD Vendedor","Nome Vendedor","Data de Emissao","Nota"})

        //Aadd(aAux1, {TRB->C5_NUM,TRB->C5_CLIENTE,TRB->C5_VEND1,TRB->A3_NOME,TRB->C5_EMISSAO,TRB->C5_NOTA})
        oExcel:AddRow(cNome, cTabela, {aAux1[nX,1],aAux1[nX,2],aAux1[nX,3],aAux1[nX,4],aAux1[nX,5],aAux1[nX,6],aAux1[nX,7],aAux1[nX,8]})
        
        oExcel:AddRow(cNome, cTabela, {"","","","","","","",""})

        oExcel:AddRow(cNome, cTabela, {"N Item","COD Produto","Descricao","Quantidade","Preco Unit","Valor Total", "",""})

        for nY := 1 to len(aAux2[nX])
            
            //Aadd(aAux2[nX], {TRB->C6_ITEM,TRB->C6_PRODUTO,TRB->C6_DESCRI,TRB->C6_QTDVEN,TRB->C6_PRCVEN,TRB->C6_VALOR})
            oExcel:AddRow(cNome, cTabela, {aAux2[nX,nY,1],aAux2[nX,nY,2],aAux2[nX,nY,3],aAux2[nX,nY,4],aAux2[nX,nY,5],aAux2[nX,nY,6],"",""})

        next

        oExcel:AddRow(cNome, cTabela, {"","","","","","","",""})
        oExcel:AddRow(cNome, cTabela, {"--","--","--","--","--","--","--","--"})
        oExcel:AddRow(cNome, cTabela, {"","","","","","","",""})

    next

    cDirTmp := cGetFile( '*.csv|*.csv' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

    oExcel:Activate()

    cArq := dTos(dDataGer) + "_" + StrTran(cHoraGer, ':', '-') + ".xml"  
    oExcel:GetXMLFile(cArq)
    
    If __CopyFile(cArq,cDirTmp + cArq)
        
        oExcelApp := MSExcel():New()
        oExcelApp:WorkBooks:Open(cDirTmp + cArq)
        oExcelApp:SetVisible(.T.)
        oExcelApp:Destroy()
        MsgInfo("O arquivo Excel foi gerado no diretório: " + cDirTmp + cArq + ". ")
    
    Else
        
        MsgAlert("Erro ao criar o arquivo Excel!")

    EndIf

RETURN
