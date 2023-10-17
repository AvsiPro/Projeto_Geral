#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 02/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function JGFRA004()

Local aRet      :=  {}
Local aPergs    :=  {}
Local dDatad    :=  ctod(" / / ")
Local dDataa    :=  ctod(" / / ")

Private aList1  :=  {}
Private aList2  :=  {}
Private aHeader1:=  {}
Private aHeader2:=  {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

aAdd(aPergs ,{1,"Filial de:"	,space(TamSx3("BZ_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Filial Até:"	,padr('zz',TamSx3("BZ_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Data de"	    ,dDatad ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Data Até"	    ,dDataa ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Fornecedor de" ,space(TamSx3("A2_COD")[1])   ,"@!",".T.","SA2",".T.",80,.F.})
aAdd(aPergs ,{1,"Fornecedor Até",padr('zz',TamSx3("A2_COD")[1])   ,"@!",".T.","SA2",".T.",80,.F.})


If ParamBox(aPergs ,"Filtrar por",@aRet)    
    MV_PAR01 := aRet[1]
    MV_PAR02 := aRet[2]
    MV_PAR03 := aRet[3]
    MV_PAR04 := aRet[4]
    MV_PAR05 := aRet[5]
    MV_PAR06 := aRet[6]
EndIf


Processa({|| Buscal()},"Buscando Abastecimentos locais!!!")

Processa({|| Buscae()},"Buscando Abastecimentos externos!!!")

Processa({|| tela()},"Gerando Tela de conferência")


Return

/*/{Protheus.doc} Buscal
    (long_description)
    @type  Static Function
    @author user
    @since 02/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Buscal()

Local cQuery := ""

cQuery := "SELECT TQN_FILIAL,TQN_FILORI,TQN_NABAST,TQN_FROTA,TQN_PLACA,T9_NOME,TQN_CNPJ,TQN_POSTO,"
cQuery += " TQF_NREDUZ,TQF_BAIRRO,TQF_ESTADO,TQN_DTABAS,TQN_HRABAS,TQN_QUANT,TQN_VALUNI,TQN_VALTOT,TQN_HODOM"
cQuery += " FROM "+RetSQLName("TQN")+" TQN"
cQuery += " INNER JOIN "+RetSQLName("TQF")+" TQF ON TQF_FILIAL=TQN_FILIAL AND TQF_CODIGO=TQN_POSTO AND TQF_TIPPOS='1' AND TQF.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("ST9")+" ST9 ON T9_FILIAL='"+xFilial("ST9")+"' AND T9_CODBEM=TQN_FROTA AND ST9.D_E_L_E_T_=' '"
cQuery += " WHERE TQN_POSTO = '315062'"


IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

Aadd(aHeader1,{     "CONCILIADO",;
                    "TQN_FILIAL",;
                    "TQN_FROTA",;
                    "TQN_PLACA",;
                    "T9_NOME",;
                    "TQN_POSTO",;
                    "TQF_NREDUZ",;
                    "TQF_BAIRRO",;
                    "TQF_ESTADO",;
                    "TQN_DTABAS",;
                    "TQN_HRABAS",;
                    "TQN_QUANT",;
                    "TQN_VALUNI",;
                    "TQN_VALTOT",;
                    "TQN_HODOM",;
                    "TQN_CNPJ",;
                    "TQN_NABAST",;
                    "TQN_FILORI"})

WHILE !EOF()
    Aadd(aList1,{   "N",;
                    TRB->TQN_FILIAL,;
                    TRB->TQN_FROTA,;
                    TRB->TQN_PLACA,;
                    TRB->T9_NOME,;
                    TRB->TQN_POSTO,;
                    TRB->TQF_NREDUZ,;
                    TRB->TQF_BAIRRO,;
                    TRB->TQF_ESTADO,;
                    stod(TRB->TQN_DTABAS),;
                    TRB->TQN_HRABAS,;
                    TRB->TQN_QUANT,;
                    TRB->TQN_VALUNI,;
                    TRB->TQN_VALTOT,;
                    TRB->TQN_HODOM,;
                    TRB->TQN_CNPJ,;
                    TRB->TQN_NABAST,;
                    TRB->TQN_FILORI})
    Dbskip()
EndDo 

Return

/*/{Protheus.doc} Buscae
    (long_description)
    @type  Static Function
    @author user
    @since 02/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Buscae()

Local cQuery := ""
Local cCodAb := SuperGetMv("TI_ABASTER",.F.,"000004")


cQuery := "SELECT TTH_FILIAL,TTH_TANQUE,TTH_CODCOM,TTH_BOMBA,TTH_DTABAS,TTH_HRABAS,TTH_NUMSEQ,"
cQuery += " TTH_QUANT,TTH_POSTO,TQF_NREDUZ,TQF_BAIRRO,TQF_ESTADO,TTH_LOJA,TTH_ZPLACA,TTH_ZKMVEI,"
cQuery += " TTH_ZCODFO,TTH_ZLOJA,A2_NOME,TTH_ZOBS,TQH_PRENEG"
cQuery += " FROM "+RetSQLName("TTH")+" TTH"
cQuery += " INNER JOIN "+RetSQLName("TQF")+" TQF ON TQF_FILIAL=TTH_FILIAL AND TQF_CODIGO=TTH_POSTO AND TQF.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=TTH_ZCODFO AND A2_LOJA=TTH_ZLOJA AND A2.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("TQH")+" TQH ON TQH_FILIAL=TTH_FILIAL AND TQH_CODPOS=TTH_ZCODFO AND TQH_CODCOM=TTH_CODCOM AND TQH.D_E_L_E_T_=' '"
cQuery += " WHERE " //TTH_ZCODFO = '315062'"
cQuery += " TTH_MOTIV2='"+cCodAb+"'"



IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

Aadd(aHeader2,{     "CONCILIADO",;
                    "TTH_FILIAL",;
                    "TTH_ZPLACA",;
                    "TTH_ZCODFO",;
                    "A2_NOME",;
                    "TQF_BAIRRO",;
                    "TQF_ESTADO",;
                    "TTH_DTABAS",;
                    "TTH_HRABAS",;
                    "TTH_QUANT",;
                    "TQH_PRENEG",;
                    "TTH_TOTAL",;
                    "TTH_ZKMVEI",;
                    "TQF_NREDUZ",;
                    "TTH_TANQUE",;
                    "TTH_ZOBS",;
                    "TTH_CODCOM",;
                    "TTH_BOMBA",;
                    "TTH_NUMSEQ",;
                    "TTH_POSTO",;
                    "TTH_LOJA"})

WHILE !EOF()
    Aadd(aList2,{   "N",;
                    TRB->TTH_FILIAL,;
                    TRB->TTH_ZPLACA,;
                    TRB->TTH_ZCODFO,;
                    TRB->A2_NOME,;
                    TRB->TQF_BAIRRO,;
                    TRB->TQF_ESTADO,;
                    stod(TRB->TTH_DTABAS),;
                    TRB->TTH_HRABAS,;
                    TRB->TTH_QUANT,;
                    TRB->TQH_PRENEG,;
                    TRB->TTH_QUANT*TRB->TQH_PRENEG,;
                    TRB->TTH_ZKMVEI,;
                    TRB->TQF_NREDUZ,;
                    TRB->TTH_ZOBS,;
                    TRB->TTH_TANQUE,;
                    TRB->TTH_CODCOM,;
                    TRB->TTH_BOMBA,;
                    TRB->TTH_NUMSEQ,;
                    TRB->TTH_POSTO,;
                    TRB->TTH_LOJA})
    Dbskip()
EndDo 


Return


/*/{Protheus.doc} Tela
    (long_description)
    @type  Static Function
    @author user
    @since 02/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Tela()

Local nOpcao        :=  0
Private oDlg1
Private oGrp1
Private oGrp2
Private oBtn1
Private oBtn2
Private oList1
Private oList2
PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')


If len(aList1) < 1
    Aadd(aList1,{'','','','','','','','','','','','','','','','','','','',''})
EndIF 

If len(aList2) < 1
    Aadd(aList2,{'','','','','','','','','','','','','','','','','','','',''})
EndIf 

oDlg1      := MSDialog():New( 149,172,739,1412,"Conciliação de Abastecimentos",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,004,124,608,"Abastecimentos internos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,120,604},,, oGrp1 ) 
    oList1    := TCBrowse():New(012,008,595,107,, {'','Filial','Veiculo','Placa','Modelo','Posto','Nome Posto','Cidade','UF',;
                                                    'Data Abast.','Hora Abast.','Qtde','Vlr Unt.','Vlr Tot.'},;
                                        {10,30,30,30,40,50,30,30,10,25,25,30,30,30},;
                                        oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| editped(oList1:nAt,1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{iF(aList1[oList1:nAt,01]=="N",oNo,oOk),; 
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],;
                        aList1[oList1:nAt,05],;
                        aList1[oList1:nAt,06],;
                        aList1[oList1:nAt,07],;
                        aList1[oList1:nAt,08],;
                        aList1[oList1:nAt,09],;
                        aList1[oList1:nAt,10],;
                        aList1[oList1:nAt,11],;
                        aList1[oList1:nAt,12],;
                        Transform(aList1[oList1:nAt,13],"@E 999,999,999.99"),;
                        Transform(aList1[oList1:nAt,14],"@E 999,999,999.99")}}

    oGrp2      := TGroup():New( 128,004,256,608,"Abastecimentos externos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{136,008,252,604},,, oGrp2 ) 
    oList2    := TCBrowse():New(136,008,595,117,, {'','Filial','Placa','Posto','Nome Posto','Cidade','UF','Data','Hora',;
                                                    'Qtde','Vlr Negoc.','Vlr Total','KM Veic.','Conveniado'},;
                                        {10,30,30,30,50,30,20,30,30,30,30,30,30,30},;
                                        oGrp2,,,,{|| /*FHelp(oList2:nAt)*/},{|| editped(oList2:nAt,2)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01]=="N",oNo,oOk),; 
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04],;
                        aList2[oList2:nAt,05],;
                        aList2[oList2:nAt,06],;
                        aList2[oList2:nAt,07],;
                        aList2[oList2:nAt,08],;
                        aList2[oList2:nAt,09],;
                        aList2[oList2:nAt,10],;
                        Transform(aList2[oList2:nAt,11],"@E 999,999,999.99"),;
                        Transform(aList2[oList2:nAt,12],"@E 999,999,999.99"),;
                        aList2[oList2:nAt,13],;
                        aList2[oList2:nAt,14]}}

oSay1      := TSay():New( 260,014,{||"Saldo"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay2      := TSay():New( 260,048,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay3      := TSay():New( 260,120,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay4      := TSay():New( 270,014,{||"Saldo"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay5      := TSay():New( 270,048,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay6      := TSay():New( 270,120,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay7      := TSay():New( 280,014,{||"Saldo Final"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)
oSay8      := TSay():New( 280,048,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay9      := TSay():New( 280,120,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)

oBtn1      := TButton():New( 264,300,"Impressão",oDlg1,{|| Processa({ || GeraPlan()},"Aguarde")},030,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 264,350,"Salvar",oDlg1,{||oDlg1:end(nOpcao:=1)},030,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 264,400,"Sair",oDlg1,{||oDlg1:end(nOpcao:=1)},030,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpcao == 1

EndIF 

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 02/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editped(nLinha,nOpc)

Local nSaldo1 := 0
Local nSaldo2 := 0
Local nCont   := 0
//Local cFornC  := aList1[nLinha,06]

oSay2:settext("")
oSay3:settext("")
oSay5:settext("")
oSay6:settext("")
oSay8:settext("")
oSay9:settext("")

If nOpc == 1 
    If aList1[nLinha,01] == "N"
        aList1[nLinha,01] := "S"
    Else 
        aList1[nLinha,01] := "N"
    EndIF 
Else 
    If aList2[nLinha,01] == "N"
        aList2[nLinha,01] := "S"
    Else 
        aList2[nLinha,01] := "N"
    EndIF 
EndIF 

For nCont := 1 to len(aList1)
    nSaldo1 += If(aList1[nCont,01]=="S",aList1[nCont,14],0)
Next nCont 

For nCont := 1 to len(aList2)
    //If aList2[nCont,04] == cFornC .AND. 
    iF aList2[nCont,01] == "S"
        nSaldo2 += aList2[nCont,12]
    EndIf 
Next nCont

oSay2:settext(Transform(nSaldo1,"@E 999,999,999.99"))
oSay3:settext("A Receber")
oSay5:settext(Transform(nSaldo2,"@E 999,999,999.99"))
oSay6:settext("A Pagar")
oSay8:settext(If(nSaldo2>nSaldo1,"Pagar","Receber"))
oSay9:settext(If(nSaldo2>nSaldo1,Transform(nSaldo2-nSaldo1,"@E 999,999,999.99"),Transform(nSaldo1-nSaldo2,"@E 999,999,999.99")))

oList1:refresh()
oList2:refresh()
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
Local cArqXls 	:= "Concilia_Abastecimento_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
//Local cGuia     :=  'Conciliação'
Local cInterno  :=  'Abastecimento Interno'
Local cExterno  :=  'Abastecimento Externo'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cInterno) 
oExcel:AddTable (cInterno,cInterno)

For nX := 1 to len(aHeader1[1])
    oExcel:AddColumn(cInterno,cInterno,aHeader1[1,nX],1,1)
Next nX


For nX := 1 to len(aList1)
    aAux := {}
    For nY := 1 to len(aHeader1[1])
        Aadd(aAux,aList1[nX,nY])
    Next nY

    oExcel:AddRow(cInterno,cInterno,aAux)
Next nX


oExcel:AddworkSheet(cExterno) 
oExcel:AddTable (cExterno,cExterno)

For nX := 1 to len(aHeader2[1])
    oExcel:AddColumn(cExterno,cExterno,aHeader2[1,nX],1,1)
Next nX


For nX := 1 to len(aList2)
    aAux := {}
    For nY := 1 to len(aHeader2[1])
        Aadd(aAux,aList2[nX,nY])
    Next nY

    oExcel:AddRow(cExterno,cExterno,aAux)
Next nX



oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	
    
Return(cDir+cArqXls)
