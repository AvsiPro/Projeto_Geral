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

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

aAdd(aPergs ,{1,"Data de "      ,dDtDe   ,"",".T.","",".T.",80,.F.})
aAdd(aPergs ,{1,"Data Ate"      ,dDtAt   ,"",".T.","",".T.",80,.F.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    dDtDe := aRet[1]
    dDtAt := aRet[2]
    Processa({||Busca(dDtDe,dDtAt)},"Aguarde")
EndIf

Return 

/*/{Protheus.doc} Busca
    Consulta log de envio
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
Local aAux      := {}
Local aQuebra   := {}
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
    aQuebra := separa(TRB->OBS,"|")

    Aadd(aAux,{TRB->CV8_FILIAL,;
                If(len(aQuebra)>0,aQuebra[1],""),;
                If(len(aQuebra)>1,aQuebra[2],""),;
                If(len(aQuebra)>2,aQuebra[3],""),;
                If(len(aQuebra)>3,aQuebra[4],""),;
                If(len(aQuebra)>4,aQuebra[5],""),;
                If(len(aQuebra)>5,aQuebra[6],""),;
                If(len(aQuebra)>6,aQuebra[7],""),;
                If(len(aQuebra)>7,aQuebra[8],""),;
                If(len(aQuebra)>8,aQuebra[9],""),;
                cvaltochar(stod(TRB->CV8_DATA)),;
                TRB->CV8_HORA,;
                TRB->CV8_USER,;
                TRB->CV8_MSG,;
                TRB->CV8_PROC,;
                TRB->OBS})
    DbSkip()
Enddo

If len(aAux) > 0
    Aadd(aHeader,{  'Filial',;
                    'Nome Empresa',;
                    'Codigo',;
                    'Loja',;
                    'Nome',;
                    'Prefixo',;
                    'Titulo',;
                    'Parcela',;
                    'Vencimento',;
                    'Valor',;
                    'Data',;
                    'Hora',;
                    'Usuario',;
                    'Status',;
                    'Processamento',;
                    'OBS'})
    
    GeraPlan(aAux)
EndIf 

Return

/*/{Protheus.doc} GeraPlan
    Gera planilha
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
