#INCLUDE 'protheus.ch'
#Include 'tbiconn.ch'

//SELECT C5_NUM,C6_TES,C5_CLIENTE,C5_VEND1,C5_NOTA FROM SC5010 INNER JOIN SC6010 ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL WHERE C6_TES IN ('626') AND C5_EMISSAO BETWEEN '20221110' AND '20221117' AND C5_CLIENTE BETWEEN '000000001' AND '100000000' ORDER BY C5_NUM

Static Function PPeri()
    
    Local aArea     :=    GetArea()
    Local cPerg1    :=    FirstDate(Date())
    Local cPerg2    :=    LastDate(Date())
    Local cPerg3    :=    "00000000"
    Local cPerg4    :=    "ZZZZZZZZZZ"
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

User Function ROBRCM06()

    Local cQuery   := ""
    Local cArq     := ""
    Local cNome    := "Tabela"
    Local aParams  := {}
    Local aAux1    := {}
    Local aAux2    := {}
    Local nX       := 0
    Local nY       := 0
    Local cDirTmp  := ""
    Local oExcel

    RpcSetType(3)
    RpcSetEnv('01', '0103')

    aParams  := PPeri()

    oExcel   := FWMSEXCEL():New()

    cQuery := " "
    cQuery += " SELECT C5_NUM,C5_CLIENTE,C5_VEND1,A3_NOME,C5_NOTA FROM " + RetSQLName("SC5") + " SC5 "
    cQuery += " INNER JOIN " + RetSQLName("SC6") + " SC6 ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL "
    cQuery += " INNER JOIN " + RetSQLName("SA3") + " SA3 ON A3_COD = C5_VEND1 AND A3_FILIAL = " + xFilial("SA3") + " "
    cQuery += " WHERE C6_TES IN (" + aParams[7] + ") "
    cQuery += " AND C5_EMISSAO BETWEEN " + aParams[1] + " AND " + aParams[2] + " "
    cQuery += " AND C5_VEND1 BETWEEN " + aParams[3] + " AND " + aParams[4] + " "
    cQuery += " AND C5_NUM BETWEEN " + aParams[5] + " AND " + aParams[6] + " "
    cQuery += " AND C5_FILIAL = " + xFilial("SC5") + " "
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

        Aadd(aAux1, {TRB->C5_NUM,TRB->C5_CLIENTE,TRB->C5_VEND1,TRB->A3_NOME,TRB->C5_NOTA})

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

            Aadd(aAux2[nX], {TRB->C6_ITEM,TRB->C6_PRODUTO,TRB->C6_DESCRI,TRB->C6_QTDVEN,TRB->C6_PRCVEN,TRB->C6_VALOR})

            DBSKIP()
        ENDDO
        
    next

    oExcel:AddworkSheet(cNome) 

    oExcel:AddTable (cNome,"Tabela")
    oExcel:AddColumn(cNome,"Tabela","" ,1,1)
    oExcel:AddColumn(cNome,"Tabela","" ,1,1)
    oExcel:AddColumn(cNome,"Tabela","" ,1,1)
    oExcel:AddColumn(cNome,"Tabela","" ,1,1)
    oExcel:AddColumn(cNome,"Tabela","" ,1,1)
    oExcel:AddColumn(cNome,"Tabela","" ,1,1)

    for nX := 1 to len(aAux1)

        oExcel:AddRow(cNome, "Tabela", {"Numero do PV","COD Cliente","COD Vendedor","Nome Vendedor","Nota",""})

        //Aadd(aAux1, {TRB->C5_NUM,TRB->C5_CLIENTE,TRB->C5_VEND1,TRB->A3_NOME,TRB->C5_NOTA})
        oExcel:AddRow(cNome, "Tabela", {aAux1[nX,1],aAux1[nX,2],aAux1[nX,3],aAux1[nX,4],aAux1[nX,5],""})
        
        oExcel:AddRow(cNome, "Tabela", {"","","","","",""})

        oExcel:AddRow(cNome, "Tabela", {"N Item","COD Produto","Descricao","Quantidade","Preco","Total"})

        for nY := 1 to len(aAux2[nX])
            
            //Aadd(aAux2[nX], {TRB->C6_ITEM,TRB->C6_PRODUTO,TRB->C6_DESCRI,TRB->C6_QTDVEN,TRB->C6_PRCVEN,TRB->C6_VALOR})
            oExcel:AddRow(cNome, "Tabela", {aAux2[nX,nY,1],aAux2[nX,nY,2],aAux2[nX,nY,3],aAux2[nX,nY,4],aAux2[nX,nY,5],aAux2[nX,nY,6]})

        next
        oExcel:AddRow(cNome, "Tabela", {"","","","","",""})
        oExcel:AddRow(cNome, "Tabela", {"--------------------","--------------------","--------------------","--------------------","--------------------","--------------------"})
        oExcel:AddRow(cNome, "Tabela", {"","","","","",""})
    next


    cDirTmp := cGetFile( '*.csv|*.csv' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

    oExcel:Activate()

    cArq := CriaTrab(NIL, .F.) +"teste.xml"  
    oExcel:GetXMLFile(cArq)
    
    If __CopyFile(cArq,cDirTmp + cArq)
        
        oExcelApp := MSExcel():New()
        oExcelApp:WorkBooks:Open(cDirTmp + cArq)
        oExcelApp:SetVisible(.T.)
        oExcelApp:Destroy()
        MsgInfo("O arquivo Excel foi gerado no dirtério: " + cDirTmp + cArq + ". ")
    
    Else
        MsgAlert("Erro ao criar o arquivo Excel!")
    EndIf

RETURN
