#INCLUDE 'PROTHEUS.CH'
/*

    Rotina para impressão de ativo fixo 

*/
User Function ROTR001()

Local aArea  := GetArea()
Local dDatad := ctod("01/01/01")
Local dDataa := ctod("31/12/30")
Local aPergs := {}
Local aRet   := {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

aAdd(aPergs ,{1,"Filial de:"	,space(TamSx3("N1_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Filial Até:"	,padr('zz',TamSx3("N18_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Ativo de:"	    ,space(TamSx3("N1_CBASE")[1]),"@!",".T.","SN1",".T.",70,.F.})
aAdd(aPergs ,{1,"Ativo Até:"	,padr('zz',TamSx3("N1_CBASE")[1]),"@!",".T.","SN1",".T.",70,.F.})
aAdd(aPergs ,{1,"Aquisicao de"	,dDatad ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Aquisicao Até"	,dDataa ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Grupo de:"	    ,space(TamSx3("N1_GRUPO")[1]),"@!",".T.","SNG",".T.",70,.F.})
aAdd(aPergs ,{1,"Grupo Até:"	,padr('zz',TamSx3("N1_GRUPO")[1]),"@!",".T.","SNG",".T.",70,.F.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    MV_PAR01 := aRet[1]
    MV_PAR02 := aRet[2]
    MV_PAR03 := aRet[3]
    MV_PAR04 := aRet[4]
    MV_PAR05 := dtos(aRet[5])
    MV_PAR06 := dtos(aRet[6])
    MV_PAR07 := aRet[7]
    MV_PAR08 := aRet[8]
   
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
Local aAux  := {}
Private aItens   := {}
Private aCabec := {}
Private aAux1  := {'N1_GRUPO','N1_CBASE','N1_ITEM','N1_AQUISIC','N1_QUANTD','N1_DESCRIC','N1_CHAPA','N3_TIPO','N3_HISTOR','N3_TPDEPR','N3_CUSTBEM','N3_CCONTAB','N3_CDEPREC','N3_CCUSTO','N3_CCDEPR','N3_DINDEPR','N3_VORIG1','N3_TXDEPR1','N3_VRDACM1','N3_AQUISIC','N1_BMCONTR'} //,'N3_VRESID1''N3_VRDEPR',,'N3_CIP_CAP'

For nCont := 1 to len(aAux1)
    cConteudo := FWX3Titulo(aAux1[nCont])
    If Empty(cConteudo)
        cConteudo := aAux1[nCont]
    EndIf 
    Aadd(aAux,cConteudo)
Next nCont 

Aadd(aCabec,aAux)

cQuery := "SELECT N1_GRUPO,N1_CBASE,N1_ITEM,N1_AQUISIC,N1_QUANTD,N1_DESCRIC,N1_CHAPA,"
cQuery += "N3_TIPO,N3_HISTOR,N3_TPDEPR,N3_CUSTBEM,N3_CCONTAB,N3_CDEPREC,N3_CCUSTO,N3_CCDEPR,"
cQuery += "N3_DINDEPR,N3_VORIG1,N3_TXDEPR1,N3_VRDACM1,N3_AQUISIC," //N3_VRESID1,",N3_VRDEPR
cQuery += "N1_BMCONTR" //N3_CIP_CAP,
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " INNER JOIN "+RetSQLName("SN3")+" N3 ON N3_FILIAL=N1_FILIAL AND N3_CBASE=N1_CBASE"
cQuery += " AND N3_ITEM=N1_ITEM AND N3.D_E_L_E_T_=' ' "
cQuery += " WHERE N1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND N1_CBASE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " AND N1_AQUISIC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQuery += " AND N1_GRUPO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
cQuery += " AND N1.D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("ROTR001.SQL",cQuery)
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
