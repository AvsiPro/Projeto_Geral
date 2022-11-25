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
    Local cNome       :=    "Relatorio"
    Local cTabela     :=    "Relatorio"
    Local aParams     :=    {}
    Local aAux        :=    {}
    Local cDirTmp     :=    ""
    Local nX          :=    0
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
    cQuery += " SELECT C5_FILIAL,C5_NUM,C5_CLIENT,A1_NOME,C5_VEND1,A3_NOME,C5_EMISSAO,C5_NOTA,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_TES   " 
    cQuery += " FROM   " + RetSQLName("SC5") + " SC5   " 
    cQuery += " INNER JOIN " + RetSQLName("SC6") + " SC6 ON C5_FILIAL = C6_FILIAL   " 
    cQuery += "        AND C5_NUM = C6_NUM   " 
    cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON C5_CLIENT = A1_COD   " 
    cQuery += "        AND C5_LOJACLI = A1_LOJA   " 
    cQuery += " INNER JOIN " + RetSQLName("SA3") + " SA3 ON C5_VEND1 = A3_COD   " 
    cQuery += " WHERE  C5_FILIAL = " + xFilial("SC5") + "   " 
    cQuery += "        AND C5_EMISSAO BETWEEN " + aParams[1] + "   " 
    cQuery += "        AND " + aParams[2] + "   " 
    cQuery += "        AND C5_VEND1 BETWEEN " + aParams[3] + "   " 
    cQuery += "        AND " + aParams[4] + "   " 
    cQuery += "        AND C5_NUM BETWEEN " + aParams[5] + "   " 
    cQuery += "        AND " + aParams[6] + "   " 
    cQuery += "        AND C6_TES IN (" + aParams[7] + ")   " 
    cQuery += "        AND SA1.D_E_L_E_T_ = ' '   " 
    cQuery += "        AND SA3.D_E_L_E_T_ = ' '   " 
    cQuery += "        AND SC5.D_E_L_E_T_ = ' '   " 
    cQuery += "        AND SC6.D_E_L_E_T_ = ' '   " 
    cQuery += " ORDER BY  C5_NUM,C6_ITEM   " 

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

        Aadd(aAux, {TRB->C5_FILIAL,;
                       TRB->C5_NUM,;
                       TRB->C5_CLIENT,;
                       TRB->A1_NOME,;
                       TRB->C5_VEND1,;
                       TRB->A3_NOME,;
                       SubStr(TRB->C5_EMISSAO, 7, 2) + "/" + SubStr(TRB->C5_EMISSAO, 5, 2) + "/" + SubStr(TRB->C5_EMISSAO,1,4),;
                       cNota,;
                       TRB->C6_ITEM,;
                       TRB->C6_PRODUTO,;
                       TRB->C6_DESCRI,;
                       TRB->C6_QTDVEN,;
                       TRB->C6_PRCVEN,;
                       TRB->C6_VALOR,;
                       TRB->C6_TES})

        DBSKIP()

    ENDDO

    oExcel:AddworkSheet(cNome) 

    oExcel:AddTable (cNome,cTabela)
    oExcel:AddColumn(cNome,cTabela,"Filial"          ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Numero do PV"    ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Cod Cliente"     ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Nome Cliente"    ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Cod Vendedor"    ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Nome Vendedor"   ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Data de Emissao" ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Nota"            ,1,1)
    oExcel:AddColumn(cNome,cTabela,"N Item"          ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Cod Produto"     ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Descricao"       ,1,1)
    oExcel:AddColumn(cNome,cTabela,"QTD"             ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Preco"           ,1,1)
    oExcel:AddColumn(cNome,cTabela,"Valor Total"     ,1,1)
    oExcel:AddColumn(cNome,cTabela,"TES"             ,1,1)
    
    for nX := 1 to len(aAux)
    
        oExcel:AddRow(cNome, cTabela, {aAux[nX,1],aAux[nX,2],aAux[nX,3],aAux[nX,4],aAux[nX,5],aAux[nX,6],aAux[nX,7],aAux[nX,8],aAux[nX,9],aAux[nX,10],aAux[nX,11],aAux[nX,12],aAux[nX,13],aAux[nX,14],aAux[nX,15]})

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
