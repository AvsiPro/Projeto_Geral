#INCLUDE 'PROTHEUS.CH'
/*
    Log de Envio de carta de cobrança com boletos
    MIT044 FINANCEIRO FIN015- LOG que informa os problemas ocorridos na transmissão

    Doc Mit
    https://docs.google.com/document/d/1rRvaxU6sg3Aej6zgsNvcgzUW2O8pSgHO/edit

    Doc Entrega
    
    
*/
User Function JFINM015 

Local aPergs := {}
Local aRet   := {}
Local dDtDe  := ctod(' / / ')
Local dDtAt  := ctod(' / / ')

aAdd(aPergs ,{1,"Data de "      ,dDtDe   ,"",".T.","",".T.",80,.F.})
aAdd(aPergs ,{1,"Data Ate"      ,dDtAt   ,"",".T.","",".T.",80,.F.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    dDtDe := aRet[1]
    dDtAt := aRet[2]
    Processa({||Busca(dDtDe,dDtAt)},"Aguarde")
EndIf

Return 

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(dDtDe,dDtAt)

Local cQuery 
Local aAux   := {}
Private aHeader := {}

cQuery := "SELECT CV8_FILIAL,CV8_DATA,CV8_HORA,CV8_USER,CV8_MSG,CV8_PROC,CV8_SBPROC,CV8_IDMOV,"
cQuery += " ISNULL(CAST(CAST(CV8_DET AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS"
cQuery += " FROM "+RetSQLName("CV8")
cQuery += " WHERE CV8_FILIAL BETWEEN ' ' AND 'ZZ'"
cQuery += " AND D_E_L_E_T_=' '"
cQuery += " AND CV8_PROC LIKE 'JFINM014%'"
cQuery += " AND CV8_SBPROC='JFINM014'"
cQuery += " AND CV8_DATA BETWEEN '"+dtos(dDtDe)+"' AND '"+dtos(dDtAt)+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTM002.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    Aadd(aAux,{TRB->CV8_FILIAL,;
                TRB->CV8_DATA,;
                TRB->CV8_HORA,;
                TRB->CV8_USER,;
                TRB->CV8_MSG,;
                TRB->CV8_PROC,;
                TRB->CV8_SBPROC,;
                TRB->CV8_IDMOV,;
                TRB->OBS})
    DbSkip()
Enddo

If len(aAux) > 0
    Aadd(aHeader,{  'CV8_FILIAL',;
                    'CV8_DATA',;
                    'CV8_HORA',;
                    'CV8_USER',;
                    'CV8_MSG',;
                    'CV8_PROC',;
                    'CV8_SBPROC',;
                    'CV8_IDMOV',;
                    'OBS'})
    
    GeraPlan(aAux)
EndIf 

Return

/*/{Protheus.doc} GeraPlan
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraPlan(aAuxExc)

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Log_Carta_Cobranca"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
Local cInterno  :=  'Log_Carta_Cobranca'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cInterno) 
oExcel:AddTable (cInterno,cInterno)

For nX := 1 to len(aHeader[1])
    oExcel:AddColumn(cInterno,cInterno,aHeader[1,nX],1,1)
Next nX


For nX := 1 to len(aAuxExc)
    aAux := {}
    For nY := 1 to len(aHeader[1])
        Aadd(aAux,aAuxExc[nX,nY])
    Next nY

    oExcel:AddRow(cInterno,cInterno,aAux)
Next nX


oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	    
Return(cDir+cArqXls)
