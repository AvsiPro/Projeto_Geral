#INCLUDE 'PROTHEUS.CH'
/*
    Relatorio calculo IRRF Anexo008

    
    MIT 44_Fiscal_FIS003_FIS004_FIS005_FIS006_FIS007_FIS008_FIS010_FIS011_FIS012_FIS013_FIS014_FIS015_FIS016_FIS017_Relatorios Fiscal_

    Doc Mit
    https://docs.google.com/document/d/1-xSmdtV1-d1fnVcVp5GDBf6l4co5JhOm/edit
    Doc Validação entrega
    
    
    
*/
User Function JFISR004()

Local aArea := GetArea()
Local dDatad := ctod(" / / ")
Local dDataa := ctod(" / / ")
Local aPergs := {}
Local aRet   := {}

aAdd(aPergs ,{1,"Filial de:"	,space(TamSx3("E2_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Filial Até:"	,padr('zz',TamSx3("E2_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Natureza de:"	,space(TamSx3("E2_NATUREZ")[1]),"@!",".T.","SED",".T.",70,.F.})
aAdd(aPergs ,{1,"Natureza Até:"	,padr('zz',TamSx3("E2_NATUREZ")[1]),"@!",".T.","SED",".T.",70,.F.})
aAdd(aPergs ,{1,"Pagamento de"	    ,dDatad ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Pagamento Até"	    ,dDataa ,"@!",".T.","",".T.",60,.F.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    MV_PAR01 := aRet[1]
    MV_PAR02 := aRet[2]
    MV_PAR03 := aRet[3]
    MV_PAR04 := aRet[4]
    MV_PAR05 := dtos(aRet[5])
    MV_PAR06 := dtos(aRet[6])

    Processa({|| gerar()},"Aguarde")

EndIf

RestAreA(aArea)

Return 

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 11/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerar()

Local cQuery 
Private aItens   := {}
Private aCabec := {}

cQuery := "SELECT DISTINCT E2_FILIAL,E2_FORNECE,E2_LOJA,A2_CGC,A2_NOME,E2_NUM,E2_EMISSAO,E5_DATA,E2_VENCREA,E2_VALOR,E2_IRRF,E2_INSS,E2_VALLIQ,E2_NATUREZ,ED_DESCRIC
cQuery += " FROM "+RetSQLName("SE2")+" E2"
cQuery += " INNER JOIN "+RetSQLName("SE5")+" E5 ON E5_FILIAL=E2_FILIAL AND E5_NUMERO=E2_NUM AND E5_PREFIXO=E2_PREFIXO AND E5_PARCELA=E2_PARCELA AND E5.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA AND A2.D_E_L_E_T_=' '
cQuery += " LEFT JOIN "+RetSQLName("SED")+" ED ON ED_FILIAL='"+xFilial("SED")+"' AND ED_CODIGO=E2_NATUREZ AND ED.D_E_L_E_T_= ' '
cQuery += " WHERE E2.D_E_L_E_T_=' '"
cQuery += " AND E2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND E2_NATUREZ BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR03+"'"
cQuery += " AND E2_VENCREA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'""

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFISR004.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  
//E2_FILIAL,E2_FORNECE,E2_LOJA,A2_CGC,A2_NOME,E2_NUM,E2_EMISSAO,E5_DATA,E2_VENCREA,E2_VALOR,E2_IRRF,E2_INSS,E2_VALLIQ
Aadd(aCabec,{   "E2_FILIAL",;
                "E2_FORNECE",;
                "E2_LOJA",;
                "A2_CGC",;
                "A2_NOME",;
                "E2_NUM",;
                "E2_EMISSAO",;
                "E5_DATA",;
                "E2_VENCREA",;
                "E2_VALOR",;
                "E2_IRRF",;
                "E2_INSS",;
                "E2_VALLIQ"})
            
While !EOF()
    Aadd(aItens,{TRB->E2_FILIAL,;
                TRB->E2_FORNECE,;
                TRB->E2_LOJA,;
                TRB->A2_CGC,;
                TRB->A2_NOME,;
                TRB->E2_NUM,;
                cvaltochar(stod(TRB->E2_EMISSAO)),;
                cvaltochar(stod(TRB->E5_DATA)),;
                cvaltochar(stod(TRB->E2_VENCREA)),;
                TRB->E2_VALOR,;
                TRB->E2_IRRF,;
                TRB->E2_INSS,;
                TRB->E2_VALLIQ})
    Dbskip()
ENDDO

GeraPlan()


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
Local cArqXls 	:= "Calculo_irrf_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
//Local cGuia     :=  'Conciliação'
Local cExterno  :=  'Calculo_IRRF'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cExterno) 
oExcel:AddTable (cExterno,cExterno)

For nX := 1 to len(aCabec[1])
    oExcel:AddColumn(cExterno,cExterno,aCabec[1,nX],1,1)
Next nX


For nX := 1 to len(aItens)
    aAux := {}
    For nY := 1 to len(aCabec[1])
        Aadd(aAux,aItens[nX,nY])
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
