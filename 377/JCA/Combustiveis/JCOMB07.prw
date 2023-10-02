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
User Function JCOMB07()

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
cQuery += " INNER JOIN "+RetSQLName("TQF")+" TQF ON TQF_FILIAL=TQN_FILIAL AND TQF_CODIGO=TQN_POSTO AND TQF.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("ST9")+" ST9 ON T9_FILIAL='"+xFilial("ST9")+"' AND T9_CODBEM=TQN_FROTA AND ST9.D_E_L_E_T_=' '"
cQuery += " WHERE TQN_POSTO = '315062'"


IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

Aadd(aHeader1,{     "TQN_FILIAL",;
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
    Aadd(aList1,{   TRB->TQN_FILIAL,;
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

cQuery := "SELECT TTH_FILIAL,TTH_TANQUE,TTH_CODCOM,TTH_BOMBA,TTH_DTABAS,TTH_HRABAS,TTH_NUMSEQ,"
cQuery += " TTH_QUANT,TTH_POSTO,TQF_NREDUZ,TQF_BAIRRO,TQF_ESTADO,TTH_LOJA,TTH_ZPLACA,TTH_ZKMVEI,"
cQuery += " TTH_ZCODFO,TTH_ZLOJA,A2_NOME,TTH_ZOBS"
cQuery += " FROM "+RetSQLName("TTH")+" TTH"
cQuery += " INNER JOIN "+RetSQLName("TQF")+" TQF ON TQF_FILIAL=TTH_FILIAL AND TQF_CODIGO=TTH_POSTO AND TQF.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=TTH_ZCODFO AND A2_LOJA=TTH_ZLOJA AND A2.D_E_L_E_T_=' '"
cQuery += " WHERE TTH_ZCODFO = '315062'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

Aadd(aHeader2,{     "TTH_FILIAL",;
                    "TTH_ZPLACA",;
                    "TTH_POSTO",;
                    "TQF_NREDUZ",;
                    "TQF_BAIRRO",;
                    "TQF_ESTADO",;
                    "TTH_DTABAS",;
                    "TTH_HRABAS",;
                    "TTH_QUANT",;
                    "TTH_ZKMVEI",;
                    "A2_NOME",;
                    "TTH_TANQUE",;
                    "TTH_ZOBS",;
                    "TTH_CODCOM",;
                    "TTH_BOMBA",;
                    "TTH_NUMSEQ",;
                    "TTH_ZCODFO",;
                    "TTH_LOJA"})

WHILE !EOF()
    Aadd(aList2,{   TRB->TTH_FILIAL,;
                    TRB->TTH_ZPLACA,;
                    TRB->TTH_POSTO,;
                    TRB->TQF_NREDUZ,;
                    TRB->TQF_BAIRRO,;
                    TRB->TQF_ESTADO,;
                    stod(TRB->TTH_DTABAS),;
                    TRB->TTH_HRABAS,;
                    TRB->TTH_QUANT,;
                    TRB->TTH_ZKMVEI,;
                    TRB->A2_NOME,;
                    TRB->TTH_TANQUE,;
                    TRB->TTH_ZOBS,;
                    TRB->TTH_CODCOM,;
                    TRB->TTH_BOMBA,;
                    TRB->TTH_NUMSEQ,;
                    TRB->TTH_ZCODFO,;
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

Private oDlg1
Private oGrp1
Private oGrp2
Private oBtn1
Private oBtn2
Private oList1
Private oList2

If len(aList1) < 1
    Aadd(aList1,{'','','','','','','','','','','','','','','','','','','',''})
EndIF 

If len(aList2) < 1
    Aadd(aList2,{'','','','','','','','','','','','','','','','','','','',''})
EndIf 

oDlg1      := MSDialog():New( 149,172,739,1412,"Conciliação de Abastecimentos",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,004,124,608,"Abastecimentos internos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,120,604},,, oGrp1 ) 
    oList1    := TCBrowse():New(012,008,595,107,, {'Filial','Veiculo','Placa','Modelo','Posto','Nome Posto','Cidade','UF',;
                                                    'Data Abast.','Hora Abast.','Qtde','Vlr Unt.','Vlr Tot.'},;
                                        {30,30,30,40,50,30,30,10,25,25,30,30,30},;
                                        oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*editped(oList1:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],; 
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
                        Transform(aList1[oList1:nAt,12],"@E 999,999,999.99"),;
                        Transform(aList1[oList1:nAt,13],"@E 999,999,999.99")}}

    oGrp2      := TGroup():New( 128,004,256,608,"Abastecimentos externos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{136,008,252,604},,, oGrp2 ) 
    oList2    := TCBrowse():New(136,008,595,117,, {'Filial','Placa','Posto','Nome Posto','Cidade','UF','Data','Hora',;
                                                    'Qtde','KM Veic.','Fornecedor','Tanque','Obs'},;
                                        {30,30,30,50,30,20,30,30,30,30,30,30,30},;
                                        oGrp2,,,,{|| /*FHelp(oList2:nAt)*/},{|| /*editped(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList2:SetArray(aList2)
    oList2:bLine := {||{aList2[oList2:nAt,01],; 
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04],;
                        aList2[oList2:nAt,05],;
                        aList2[oList2:nAt,06],;
                        aList2[oList2:nAt,07],;
                        aList2[oList2:nAt,08],;
                        aList2[oList2:nAt,09],;
                        aList2[oList2:nAt,10],;
                        aList2[oList2:nAt,11],;
                        aList2[oList2:nAt,12],;
                        aList2[oList2:nAt,13]}}

oBtn1      := TButton():New( 264,180,"Impressão",oDlg1,{|| GeraPlan()},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 264,388,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

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
