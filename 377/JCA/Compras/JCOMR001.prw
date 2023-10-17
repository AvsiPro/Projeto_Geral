#INCLUDE 'PROTHEUS.CH'

User Function JCOMR001()

Local aArea := GetArea()
Local dDatad := ctod(" / / ")
Local dDataa := ctod(" / / ")
Local aPergs := {}
Local aRet   := {}

aAdd(aPergs ,{1,"Cotação de:"	,space(TamSx3("C8_NUM")[1]),"@!",".T.","SC8",".T.",70,.F.})
aAdd(aPergs ,{1,"Cotação Até:"	,padr('zz',TamSx3("C8_NUM")[1]),"@!",".T.","SC8",".T.",70,.F.})
aAdd(aPergs ,{1,"Data de"	    ,dDatad ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Data Até"	    ,dDataa ,"@!",".T.","",".T.",60,.F.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    MV_PAR01 := aRet[1]
    MV_PAR02 := aRet[2]
    MV_PAR03 := dtos(aRet[3])
    MV_PAR04 := dtos(aRet[4])

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

cQuery := "SELECT ZL_DOCTO,ZL_ITEM,ZL_USUARIO,ZL_DATA,ZL_HORA,ZL_OBS,"
cQuery += "ZL_QTD,ZL_VALOR,ZL_TOTAL,ZL_QTDANT,ZL_VLRANT,ZL_TOTLANT"
cQuery += " FROM "+RetSQLName("SZL")
cQuery += " WHERE ZL_FILIAL='"+xFilial("SZL")+"'"
cQuery += " AND ZL_DOCTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND ZL_DATA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " AND D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

Aadd(aCabec,{"ZL_DOCTO",;
            "ZL_ITEM",;
            "ZL_USUARIO",;
            "ZL_DATA",;
            "ZL_HORA",;
            "ZL_OBS",;
            "ZL_QTD",;
            "ZL_VALOR",;
            "ZL_TOTAL",;
            "ZL_QTDANT",;
            "ZL_VLRANT",;
            "ZL_TOTLANT"})
            
While !EOF()
    Aadd(aItens,{TRB->ZL_DOCTO,;
                TRB->ZL_ITEM,;
                TRB->ZL_USUARIO,;
                TRB->ZL_DATA,;
                TRB->ZL_HORA,;
                TRB->ZL_OBS,;
                TRB->ZL_QTD,;
                TRB->ZL_VALOR,;
                TRB->ZL_TOTAL,;
                TRB->ZL_QTDANT,;
                TRB->ZL_VLRANT,;
                TRB->ZL_TOTLANT})
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
Local cArqXls 	:= "Negociacoes_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
//Local cGuia     :=  'Conciliação'
Local cExterno  :=  'Negociacoes'

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
