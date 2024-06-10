#INCLUDE 'PROTHEUS.CH'
/*

    Rotina para impressão de Lançamentos contabeis para ativo

*/
User Function ROTR002()

Local aArea  := GetArea()
Local dDatad := ctod(" / / ")
Local dDataa := ctod(" / / ")
Local aPergs := {}
Local aRet   := {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

aAdd(aPergs ,{1,"Filial de:"	    ,space(TamSx3("N1_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Filial Até:"	    ,padr('zz',TamSx3("N18_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Conta Debito de:"	,space(TamSx3("CT1_CONTA")[1]),"@!",".T.","CT1",".T.",70,.F.})
aAdd(aPergs ,{1,"Conta Debito Até:" ,padr('zz',TamSx3("CT1_CONTA")[1]),"@!",".T.","CT1",".T.",70,.F.})
aAdd(aPergs ,{1,"Conta Credito de:"	,space(TamSx3("CT1_CONTA")[1]),"@!",".T.","CT1",".T.",70,.F.})
aAdd(aPergs ,{1,"Conta Credito Até:",padr('zz',TamSx3("CT1_CONTA")[1]),"@!",".T.","CT1",".T.",70,.F.})
aAdd(aPergs ,{1,"CC Debito de:"	    ,space(TamSx3("CTT_CUSTO")[1]),"@!",".T.","CTT",".T.",70,.F.})
aAdd(aPergs ,{1,"CC Debito Até:"   	,padr('zz',TamSx3("CTT_CUSTO")[1]),"@!",".T.","CTT",".T.",70,.F.})
aAdd(aPergs ,{1,"CC Credito de:"    ,space(TamSx3("CTT_CUSTO")[1]),"@!",".T.","CTT",".T.",70,.F.})
aAdd(aPergs ,{1,"CC Credito Até:"  	,padr('zz',TamSx3("CTT_CUSTO")[1]),"@!",".T.","CTT",".T.",70,.F.})
aAdd(aPergs ,{1,"Item Credito de:"  ,space(TamSx3("CT2_ITEMC")[1]),"@!",".T.","CTD",".T.",70,.F.})
aAdd(aPergs ,{1,"Item Credito Até:" ,padr('zz',TamSx3("CT2_ITEMC")[1]),"@!",".T.","CTD",".T.",70,.F.})
aAdd(aPergs ,{1,"Item Debito de:"  ,space(TamSx3("CT2_ITEMC")[1]),"@!",".T.","CTD",".T.",70,.F.})
aAdd(aPergs ,{1,"Item Debito Até:" ,padr('zz',TamSx3("CT2_ITEMC")[1]),"@!",".T.","CTD",".T.",70,.F.})
aAdd(aPergs ,{1,"Classe Credito de:"  ,space(TamSx3("CT2_CLVLCR")[1]),"@!",".T.","CTH",".T.",70,.F.})
aAdd(aPergs ,{1,"Classe Credito Até:" ,padr('zz',TamSx3("CT2_CLVLCR")[1]),"@!",".T.","CTH",".T.",70,.F.})
aAdd(aPergs ,{1,"Classe Debito de:"  ,space(TamSx3("CT2_CLVLCR")[1]),"@!",".T.","CTH",".T.",70,.F.})
aAdd(aPergs ,{1,"Classe Debito Até:" ,padr('zz',TamSx3("CT2_CLVLCR")[1]),"@!",".T.","CTH",".T.",70,.F.})
aAdd(aPergs ,{1,"Data de"	        ,dDatad ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Data Até"	        ,dDataa ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{2,"Integrados"	,"", {"1=Sim","2=Nao","3=Ambos"},50,'',.T.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    MV_PAR01 := aRet[1]
    MV_PAR02 := aRet[2]
    MV_PAR03 := aRet[3]
    MV_PAR04 := aRet[4]
    MV_PAR05 := aRet[5]
    MV_PAR06 := aRet[6]

    MV_PAR07 := aRet[7]
    MV_PAR08 := aRet[8]
    MV_PAR09 := aRet[9]
    MV_PAR10 := aRet[10]
    MV_PAR11 := aRet[11]
    MV_PAR12 := aRet[12]
    MV_PAR13 := aRet[13]
    MV_PAR14 := aRet[14]
    MV_PAR15 := aRet[15]
    MV_PAR16 := aRet[16]
    MV_PAR17 := aRet[17]
    MV_PAR18 := aRet[18]
    
    MV_PAR19 := dtos(aRet[19])
    MV_PAR20 := dtos(aRet[20])
    MV_PAR21 := aRet[21]
   
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
Local nCont  
Local aAux     := {}
Local cCampos  := ''
Local cBarra   := ''
Private aItens := {}
Private aCabec := {}
Private aAux1  := {'CT2_FILIAL','CT2_DATA','CT2_LOTE','CT2_SBLOTE','CT2_DOC','CT2_LINHA','CT2_MOEDLC','CT2_DC','CT2_DEBITO','CT2_CREDIT','CT2_ZZINTA','CT2_ZZFILA','CT2_ZZCAI','CT2_VALOR','CT2_ZZITAI','CT2_ZZDTAI','CT2_ZZHRAI','CT2_HIST','CT2_CCD','CT2_CCC','CT2_ITEMD','CT2_ITEMC','CT2_CLVLDB','CT2_CLVLCR','CT2_EMPORI','CT2_FILORI','CT2_ORIGEM','CT2_XDOC','CT2_XNAT','CT2_XHIST','CT2_XTES','CT2_XCFOP','CT2_XPROD','CT2_XPED','CT2_XMEDIC'}  //'CT2_XLGI','CT2_XLGA',

For nCont := 1 to len(aAux1)
    cCampos += cBarra + aAux1[nCont]
    cBarra := ","
    cConteudo := FWX3Titulo(aAux1[nCont])
    If Empty(cConteudo)
        cConteudo := aAux1[nCont]
    EndIf 
    Aadd(aAux,cConteudo)
Next nCont 

Aadd(aCabec,aAux)

cQuery := "SELECT "+cCampos
cQuery += " FROM "+RetSQLName("CT2")+" CT2"
cQuery += " WHERE CT2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND CT2_DEBITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " AND CT2_CREDIT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQuery += " AND CT2_CCD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
cQuery += " AND CT2_CCC BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
cQuery += " AND CT2_ITEMD BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"
cQuery += " AND CT2_ITEMC BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'"
cQuery += " AND CT2_CLVLDB BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR16+"'"
cQuery += " AND CT2_CLVLCR BETWEEN '"+MV_PAR17+"' AND '"+MV_PAR18+"'"
cQuery += " AND CT2_DATA BETWEEN '"+MV_PAR19+"' AND '"+MV_PAR20+"'"

If MV_PAR21 == '1'
    cQuery += " AND CT2_ZZINTA='1'"
ElseIf MV_PAR21 == '2'
    cQuery += " AND CT2_ZZINTA=' '"
EndIf 

cQuery += " AND CT2.D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("ROTR002.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  
            
While !EOF()
    aAux := {}
    For nCont := 1 to len(aAux1) 
        Aadd(aAux,&('TRB->'+aAux1[nCont]))
    Next nCont 
    
    Aadd(aItens,aAux)

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
Local cArqXls 	:= "Ativos_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
//Local cGuia     :=  'Conciliação'
Local cExterno  :=  'Ativos'

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
        aAuxx := FWSX3Util():GetFieldStruct( aAux1[nY] )
        If aAuxx[2] == "D"
            Aadd(aAux,cvaltochar(stod(aItens[nX,nY])))
        Else 
            Aadd(aAux,aItens[nX,nY])
        EndIf 
    Next nY

    oExcel:AddRow(cExterno,cExterno,aAux)
Next nX

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	
    
Return(cDir+cArqXls)
