#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function ROBFAT08
    @type  Function
    @author Diogo de Jesus Gasparini
    @since 02/12/2022
    @version 1
    /*/
User Function ROBFAT08()
    
    Local nLarg
    Local nAlt
    Local nLinha

    Private oDlg1,oGrp1,oList1,oList2,oList3,oBtn1,oBtn2,oBtn3,oBtn4,oBtn5,oSay1,oSay2
    Private aList1 := {}
    Private aList2 := {}
    Private aList3 := {}
	Private oFont1 := TFont():New( 'Arial',, 20,, .T.,,,,, .T., )
	Private oOk    := LoadBitmap(GetResources(),'br_verde')
	Private oNo    := LoadBitmap(GetResources(),'br_vermelho')
    Private lTroca := .T.

	If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01","01")
	EndIf

    Processa({|| buscaGeren()},"Aguarde")

    Aadd(aList2, {.T.,'','','','','','','','','',''})
    Aadd(aList3, {.T.,'','','','','','','','','',''})

    oDlg1      := MSDialog():New( 100, 200, 750, 1500, "",,, .F.,,,,,, .T.,,, .T. )
	oGrp1      := TGroup():New( 005, 005, 300, 645, "", oDlg1, CLR_BLACK, CLR_WHITE, .T., .F. )

	oList1     := TCBrowse():New( 012, 008, 190, 135,, {'', 'Codigo','Gerente','Regiao'}, {10,25,90,25},;
					oGrp1,,,, {|| Processa({|| buscaRepre(oList1:nAt)},"Aguarde")},,,,,,,,,, .T.,,,, .F., .T. )
	
	oList1:SetArray(aList1)
	oList1:bLine := {||{ 	If(aList1[oList1:nAt,01],oOk,oNo),;
							aList1[oList1:nAt,2],;
							aList1[oList1:nAt,3],;
							aList1[oList1:nAt,4]}}

	oList2     := TCBrowse():New( 012, 200, 440, 135,, {'','Codigo','Representante','Malas', 'Regioes'},,;
				 oGrp1,,,, {|| Processa({|| buscaProd(oList2:nAt)},"Aguarde")},;
				 			/*{|| editcol(oList2:nAt)}*/,,,,,,,,, .T.,,,, .F., .T. )
	
	oList2:SetArray(aList2)
	oList2:bLine := {||{	If(aList2[oList2:nAt,01],oOk,oNo),;
								aList2[oList2:nAt,2],;
								aList2[oList2:nAt,3],;
								aList2[oList2:nAt,4],;
								aList2[oList2:nAt,5]}}

	oList3     := TCBrowse():New( 150, 008, 550, 145,, {'', 'Codigo', 'Descricao', 'Saldo 3', 'Saldo Estoque', 'Preco UN', 'Nota', 'Data de Emissao'}, {,,200,,},;
				 oGrp1,,,,, {|| selecProd(oList3:nAt)},,,,,,,,, .T.,,,, .F., .T. )
	
	oList3:SetArray(aList3)
	oList3:bLine := {||{ 	If(aList3[oList3:nAt,01],oOk,oNo),;
								aList3[oList3:nAt,2],;
								aList3[oList3:nAt,3],;
								aList3[oList3:nAt,4],;
								aList3[oList3:nAt,5],;
								aList3[oList3:nAt,6],;
								aList3[oList3:nAt,11],;
								SubStr(aList3[oList3:nAt,9], 7, 2) + "/" + SubStr(aList3[oList3:nAt,9], 5, 2) + "/" + SubStr(aList3[oList3:nAt,9],1,4)}}

	nLarg  := 052*1.5
	nAlt   := 012*1.5
	nLinha := 128

	oBtn1      := TButton():New( nLinha+25,   564,  "Confirmar",            oGrp1, {|| oDlg1:end(nOpc:=1)},      nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn1      := TButton():New( nLinha+50,   564,  "Marcar Todos",         oGrp1, {|| marcarTodos()},           nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( nLinha+75,   564,  "Gera Excel",	        oGrp1, {|| fExcel(oList2:nAt)},   	 nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( nLinha+100,  564,  "Ir ao Início",         oGrp1, {|| oList3:GoTop()},          nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn4      := TButton():New( nLinha+125,  564,  "Ir ao Fim",            oGrp1, {|| oList3:GoBottom()},       nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn5      := TButton():New( nLinha+150,  564,  "Sair",                 oGrp1, {|| oDlg1:end(nOpc:=0)},      nLarg,    nAlt,,,,.T.,,"",,,,.F. )

	oSay1:= TSay():New( nLinha+180, 10, {||'Quantidade total de produtos: '}, oDlg1,,      ,,,, .T., CLR_BLACK,, 200, 20 )
	oSay2:= TSay():New( nLinha+177, 85, {||''},                               oDlg1,,oFont1,,,, .T., CLR_BLACK,, 200, 20 )

	oDlg1:Activate( ,,, .T. )

    if nOpc == 1
        if MsgYesNo("Deseja gerar documento de entrada?", "Confirma")
            Processa({|| geraDE()},"Aguarde")
        endif
    endif

Return 

Static Function buscaGeren()
    
    Local cQuery := ''

	cQuery := " "
	cQuery += " SELECT SA3.A3_COD,Z30.Z30_CODVEN,Z30.Z30_CODGER,SA3.A3_NOME,Z30.Z30_MALA,Z30.Z30_REGIAO "
	cQuery += " FROM " + RetSQLName("SA3") + " SA3 "
	cQuery += " LEFT JOIN " + RetSQLName("Z30") + " Z30 ON Z30.Z30_FILIAL=SA3.A3_FILIAL AND Z30.Z30_CODVEN = SA3.A3_COD AND Z30.D_E_L_E_T_=' ' "
	cQuery += " WHERE SA3.A3_FILIAL='"+xFilial("SA3")+"' AND SA3.A3_XFUNCAO = '2' AND SA3.D_E_L_E_T_=' '"

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    While !EOF()
        Aadd(aList1, { .F., TRB->A3_COD, AllTrim(TRB->A3_NOME), AllTrim(TRB->Z30_REGIAO)})
        DBSKIP()
    End

Return

Static Function buscaRepre(nLinha)

    Local cQuery := ''
    Local cGeren := aList1[nLinha,2]
    Local nX

    aList2 := {}
    
	cQuery := " "
	cQuery += " SELECT DISTINCT SA3.A3_COD,Z30.Z30_CODVEN,Z30.Z30_CODGER,"
	cQuery += " SA3.A3_NOME,Z30.Z30_MALA,Z30.Z30_REGIAO,SA1.A1_COD,"
	cQuery += " SA1.A1_LOJA,SA1.A1_TIPO,Z30.Z30_CODGER,SA2.A2_COD,SA2.A2_LOJA "
	cQuery += " FROM   " + RetSQLName("SA3") + " SA3 "
	cQuery += " INNER JOIN " + RetSQLName("Z30") + " Z30 ON Z30.Z30_FILIAL='"+xFilial("Z30")+"' AND SA3.A3_COD = Z30.Z30_CODVEN AND Z30.D_E_L_E_T_=' ' "
	cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON SA1.A1_FILIAL = SA3.A3_FILIAL AND SA1.A1_CGC = SA3.A3_CGC AND SA1.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN " + RetSQLName("SA2") + " SA2 ON SA2.A2_FILIAL = SA3.A3_FILIAL AND SA2.A2_CGC = SA3.A3_CGC AND SA2.D_E_L_E_T_=' '"
	cQuery += " WHERE SA3.A3_FILIAL = '" + xFilial("SA3") + "' " + "AND Z30.Z30_CODGER = '"+ cGeren +"' "
	cQuery += " AND  SA1.A1_TIPO = 'R' "
	cQuery += " AND  SA3.A3_XFUNCAO <> '2' "
	cQuery += " AND  SA3.A3_MSBLQL <> '1' "
	cQuery += " AND  Z30.Z30_MALA <> ' ' "
	cQuery += " AND  SA3.D_E_L_E_T_=' '"

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    While !EOF()
        Aadd(aList2, { .F., TRB->A3_COD, AllTrim(TRB->A3_NOME), AllTrim(TRB->Z30_MALA), AllTrim(TRB->Z30_REGIAO),TRB->A1_COD,TRB->A1_LOJA,TRB->A1_TIPO,TRB->A2_COD,TRB->A2_LOJA})
        DBSKIP()
    End

    If aList1[nLinha,1] == .T.
        aList1[nLinha,1] := .F.

    Else
        aList1[nLinha,1] := .T.
    EndIf

    for nX := 1 to len(aList1)
        if nX == nLinha
            nX++
        endif
        if !(nX > len(aList1))
            aList1[nX,1] := .F.
        endif
    next

    oList1:SetArray(aList1)
    oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),;
                                     aList1[oList1:nAt,2],;
                                     aList1[oList1:nAt,3],;
                                     aList1[oList1:nAt,4]}}
    oList1:Refresh()

    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
                                     aList2[oList2:nAt,2],;
                                     aList2[oList2:nAt,3],;
                                     aList2[oList2:nAt,4],;
                                     aList2[oList2:nAt,5]}}
    oList2:Refresh()

Return

Static Function buscaProd(nLinha)

    Local cQuery       :=    ""
    Local nX         
    Local cValid       :=    ""

	cQuery := " "
	cQuery += " SELECT BM_XMODELO,B1_COD,B1_DESC,B2_QATU,B1_PRV1,BM_XMODELO,B1_LOCPAD,B6_SALDO,B6_PRUNIT,B6_DOC,B6_EMISSAO,B6_CLIFOR,B1_UM "+CRLF
	cQuery += " FROM " + RetSQLName("SB6") + " SB6 "+CRLF
	cQuery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND B6_PRODUTO = B1_COD AND SB1.B1_MSBLQL <> '1' AND SB1.D_E_L_E_T_ = ' '"+CRLF
	cQuery += " INNER JOIN " + RetSQLName("SBM") + " SBM ON BM_FILIAL = '" + xFilial("SBM") + "' AND BM_GRUPO = B1_GRUPO AND SBM.D_E_L_E_T_=' '"+CRLF
	cQuery += " INNER JOIN " + RetSQLName("SB2") + " SB2 ON B2_FILIAL = B6_FILIAL AND B2_COD = B1_COD AND B2_LOCAL = B6_LOCAL AND SB2.D_E_L_E_T_=' '"+CRLF
	cQuery += " WHERE " 
	//"B6_CLIFOR = '" + aList2[nLinha,6] + "'"
	cQuery += " B6_CLIFOR = '"+aList2[nLinha,6]+"'"

	cQuery += " AND B6_TIPO = 'E' AND B6_SALDO > '0' "+CRLF
	cQuery += " AND B6_PODER3 = 'R' "+CRLF
	cQuery += " AND B6_FILIAL = '" + xFilial("SB6") + "' "+CRLF
	cQuery += " AND SB6.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND B2_QATU <= '15' "+CRLF
	cQuery += " AND B1_GRUPO != ' ' "+CRLF
	cQuery += " ORDER BY B1_COD "+CRLF

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    aList3 := {}

    While !EOF()
        if cValid != TRB->B1_COD
            Aadd(aList3, { .T., AllTrim(TRB->B1_COD), AllTrim(TRB->B1_DESC), TRB->B6_SALDO, TRB->B2_QATU, TRB->B6_PRUNIT, TRB->BM_XMODELO,TRB->B1_LOCPAD,TRB->B6_DOC,TRB->B6_EMISSAO,TRB->B1_UM})
            cValid := TRB->B1_COD
        endif
        DBSKIP()
    End

    if aList2[nLinha,1] == .T.
        aList2[nLinha,1] := .F.
    else
        aList2[nLinha,1] := .T.
    endif

    for nX := 1 to len(aList2)
        if nX == nLinha
            nX++
        endif
        if !(nX > len(aList2))
            aList2[nX,1] := .F.
        endif
    Next

    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
                                     aList2[oList2:nAt,2],;
                                     aList2[oList2:nAt,3],;
                                     aList2[oList2:nAt,4],;
                                     aList2[oList2:nAt,5]}}
    oList2:Refresh()

    aList3B := aList3

    oList3:SetArray(aList3)
    oList3:bLine := {||{ If(aList3[oList3:nAt,01],oOk,oNo),;
                                      aList3[oList3:nAt,2],;
                                      aList3[oList3:nAt,3],;
                                      aList3[oList3:nAt,4],;
                                      aList3[oList3:nAt,5],;
                                      aList3[oList3:nAt,6]}}
    oList3:Refresh()

    qtdTot()

Return 

Static Function selecProd(nLinha)
    
    if aList3[nLinha,1] == .T.
        aList3[nLinha,1] := .F.
    else
        aList3[nLinha,1] := .T.
    endif

    oList3:SetArray(aList3)
    oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
                                     aList3[oList3:nAt,2],;
                                     aList3[oList3:nAt,3],;
                                     aList3[oList3:nAt,4],;
                                     aList3[oList3:nAt,5],;
                                     aList3[oList3:nAt,6]}}
    oList3:Refresh()

    qtdTot()

Return

Static Function qtdTot()
    
    Local nQtd := 0
    Local nX

    for nX := 1 to len(aList3)
        if aList3[nX,1]
            nQtd += aList3[nX,4]    
        endif
    next

	oSay2:SetText(cValToChar(nQtd))
	oSay2:CtrlRefresh()

Return 


Static Function fExcel(nLinha)

    Local oExcel 	:= FWMSEXCEL():New()
    Local cDir 		:= ""
    Local nX 
    Local cArqXls 	:= "Inventario"+dtos(ddatabase)+strtran(time(),":")+".xls" 

    cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

    If Empty(cDir)
        Return
    EndIf

    oExcel:AddworkSheet("Inventario") 

    oExcel:AddTable ("Inventario","Representante")

    oExcel:AddColumn("Inventario","Representante","Cliente/Fornecedor",1,1)     
    oExcel:AddColumn("Inventario","Representante","Marca",1,1)         
    oExcel:AddColumn("Inventario","Representante","Codigo",1,1)      
    oExcel:AddColumn("Inventario","Representante","Saldo em Terceiro",1,1)      
    oExcel:AddColumn("Inventario","Representante","Saldo Estoque",1,1)     
    oExcel:AddColumn("Inventario","Representante","Nota",1,1)  
    oExcel:AddColumn("Inventario","Representante","Data Emissao",1,1)  

    For nX := 1 to len(aList3)
        If aList3[nX,01]
            oExcel:AddRow("Inventario","Representante",{  aList2[nLinha,06],;
                                                            aList3[nX,07],;
                                                            aList3[nX,02],;
                                                            aList3[nX,04],;
                                                            aList3[nX,05],;
                                                            aList3[nX,09],;
                                                            aList3[nX,10]})
        EndIf
    Next nX
//cliente,marca,codigo,saldo,estoque,nota,emissao
    oExcel:Activate()

    oExcel:GetXMLFile(cDir +cArqXls)

    WinExec('Explorer.exe /select,"' + substr(cDir,1,len(cDir)-1) + '"', 1)

    oExcelApp := MsExcel():New()
    oExcelApp:Destroy()

Return 

Static Function marcarTodos()
    
    Local nX

    if lTroca
        for nX := 1 to len(aList3)
            aList3[nX,1] := .F.
        next
        lTroca := .F.
    else
        for nX := 1 to len(aList3)
            aList3[nX,1] := .T.
        next
        lTroca := .T.
    endif

    oList3:SetArray(aList3)
    oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
                                     aList3[oList3:nAt,2],;
                                     aList3[oList3:nAt,3],;
                                     aList3[oList3:nAt,4],;
                                     aList3[oList3:nAt,5],;
                                     aList3[oList3:nAt,6]}}
    oList3:Refresh()

    qtdTot()

Return 
//5577
Static Function geraDE()

    Local aCab      := {}
    Local aItem     := {}
    Local aItens    := {}
    Local aItensRat := {}
    Local aCodRet   := {}
    Local aAux      := {}
    Local nOpc      := 3
    Local cNum      := ""
    // Local nI := 0
    Local nX        := 0
    // Local nReg := 1

    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.

    for nX := 1 to len(aList2)
        if aList2[nX,1]
            Aadd(aAux, aList2[nX])
        endif
    next

    for nX := 1 to len(aList3)
        if aList3[nX,1]
            Aadd(aAux, aList3[nX])
        endif
    next

    cNum := GetSxeNum("SF1","F1_DOC")
    SF1->(dbSetOrder(1))
    While SF1->(dbSeek(xFilial("SF1")+cNum))
        ConfirmSX8()
        cNum := GetSxeNum("SF1","F1_DOC")
    EndDo

    //Cabeçalho
    aadd( aCab,{"F1_TIPO"    ,"B"                     ,NIL} )
    aadd( aCab,{"F1_FORMUL"  ,"S"                     ,NIL} )
    aadd( aCab,{"F1_DOC"     ,cNum                    ,NIL} )
    aadd( aCab,{"F1_SERIE"   ,"1 "                    ,NIL} )
    aadd( aCab,{"F1_EMISSAO" ,DDATABASE               ,NIL} )
    aadd( aCab,{"F1_DTDIGIT" ,DDATABASE               ,NIL} )
    aadd( aCab,{"F1_FORNECE" ,aAux[1,9]               ,NIL} )
    aadd( aCab,{"F1_LOJA"    ,aAux[1,10]              ,NIL} )
    aadd( aCab,{"F1_ESPECIE" ,"SPED"                  ,NIL} )
    // aadd( aCab,{"F1_COND"    ,"001"                  ,NIL} )
    // aadd( aCab,{"F1_DESPESA" ,10                     ,NIL} )
    // aadd( aCab,{"F1_DESCONT" , 0                     ,Nil} )
    // aadd( aCab,{"F1_SEGURO"  , 0                     ,Nil} )
    // aadd( aCab,{"F1_FRETE"   , 0                     ,Nil} )
    aadd( aCab,{"F1_MOEDA"   ,1                       ,Nil} )
    // aadd( aCab,{"F1_TXMOEDA" , 1                     ,Nil} )
    aadd( aCab,{"F1_STATUS"  ,"A"                     ,Nil} )

    //Itens
    For nX := 2 To len(aAux)

        aItem := {}
        aadd( aItem,{"D1_ITEM"   ,StrZero(nX - 1,4) ,NIL} )
        aadd( aItem,{"D1_COD"    ,aAux[nX,2]        ,NIL} )
        aadd( aItem,{"D1_UM"     ,aAux[nX,11]       ,NIL} )
        aadd( aItem,{"D1_LOCAL"  ,aAux[nX,8]        ,NIL} )
        aadd( aItem,{"D1_QUANT"  ,aAux[nX,4]        ,NIL} )
        aadd( aItem,{"D1_VUNIT"  ,aAux[nX,6]        ,NIL} )
        aadd( aItem,{"D1_TOTAL"  ,aAux[nX,6]        ,NIL} )
        aadd( aItem,{"D1_TES"    ,"131"             ,NIL} )
        // aadd( aItem,{"D1_RATEIO" ,"2"               ,NIL} )
        aAdd( aItens, aItem )
        
    Next nX

    //Rateio de Centro de Custo
    aItem := {}
    aAdd( aItensRat, Array(2) )
    aItensRat[Len(aItensRat)][1] := "0001"
    aItensRat[Len(aItensRat)][2] := {}

    aAdd( aItem,{"DE_FILIAL"  ,xFilial("SDE")                  ,Nil} )
    aAdd( aItem,{"DE_ITEM"    ,StrZero(1,TamSx3("DE_ITEM")[1]) ,Nil} )
    aAdd( aItem,{"DE_DOC"     ,cNum                            ,Nil} )
    aAdd( aItem,{"DE_SERIE"   ,"1"                             ,Nil} )
    aAdd( aItem,{"DE_FORNECE" ,"001 "                          ,Nil} )
    aAdd( aItem,{"DE_LOJA"    ,"01"                            ,Nil} )
    aAdd( aItem,{"DE_ITEMNF"  ,"0001"                          ,Nil} )
    aAdd( aItem,{"DE_PERC"    ,100                             ,Nil} )
    aAdd( aItem,{"DE_CC"      ,"01"                            ,Nil} )
    aAdd( aItensRat[Len(aItensRat)][2], aClone(aItem) )

    //Array contendo a informação se gera DIRF e os códigos de retenção por imposto
    aAdd( aCodRet,{01 ,"0297" ,1 ,"..."} )
    aAdd( aCodRet,{02 ,"0297" ,1 ,"IRR"} )
    aAdd( aCodRet,{03 ,"5979" ,1 ,"PIS"} )
    aAdd( aCodRet,{04 ,"5960" ,1 ,"COF"} )
    aAdd( aCodRet,{05 ,"5987" ,1 ,"CSL"} )

    //3-Inclusão / 4-Classificação / 5-Exclusão
    MSExecAuto({|x,y,z,a,b| MATA103(x,y,z,,,,,/*a*/,,,/*b*/)},aCab,aItens,nOpc,/*aItensRat*/,/*aCodRet*/)
    // MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,,,,,/*a*/,,,/*b*/)},aCab,aItens,nOpc,/*aItensRat*/,/*aCodRet*/)

    If !lMsErroAuto
        MsgInfo("Incluido NF: " + cNum, "Informa")
    Else
        MostraErro()
        RollBackSX8()
        MsgAlert("Erro ao incluir nota", "Erro")
    EndIf

Return
