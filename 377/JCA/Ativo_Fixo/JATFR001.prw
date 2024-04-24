#INCLUDE 'PROTHEUS.CH'
/*
    Relatório com posição Saldo Ativo Fixo 

    MIT 44_Ativo_ATF001_Relatorios Ativo_

    Doc Mit
    https://docs.google.com/document/d/1pVSf-sbrHWkuva7h3IaJunWKAF6xdYhv/edit
    
    
    
*/
User Function JATFR001()

Local aArea := GetArea()
Local dDatad := ctod(" / / ")
Local dDataa := ctod(" / / ")
Local aPergs := {}
Local aRet   := {}

aAdd(aPergs ,{1,"Data de"	    ,dDatad ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Data Até"	    ,dDataa ,"@!",".T.","",".T.",60,.F.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    

    MV_PAR03 := dtos(aRet[1])
    MV_PAR04 := dtos(aRet[2])

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

cQuery := "SELECT N3_CCONTAB AS CONTA,N1_DESCRIC,N1_CBASE,N1_XPLACA,N1_XPREF,N1_XCHASSI,"
cQuery += " N1_CHAPA,A2_NOME,N1_AQUISIC,N1_ITEM,N3_VORIG1,N3_TXDEPR1,N3_VRCACM1,N3_VRDMES1,N3_VRDACM1"
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " INNER JOIN "+RetSQLName("SN3")+" N3 ON N3_FILIAL=N1_FILIAL AND N3_CBASE=N1_CBASE AND N3_ITEM=N1_ITEM AND N3.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN " + RetSQLName("SA2") + " A2 ON A2_COD=N1_FORNEC AND A2_LOJA=N1_LOJA AND A2.D_E_L_E_T_=' ' " 
cQuery += " WHERE N1_FILIAL='"+xFilial("SN1")+"'"
cQuery += " AND N1.D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

Aadd(aCabec,{"CONTA",;
            "DESCRICAO",;
            "Cod. Bem",;
            "Placa",;
            "Prefixo Onibus",;
            "Chassis",;
            "Num. Plaqueta",;
            "Fornecedor",;
            "Data Aquisicao",;
            "Item",;
            "Valor Original M1",;
            "Taxa Depreciação",;
            "Corr Acum M1",;
            "Depr Mes M1",;
            "Depr.Acum M1",;
            "Saldo Residual"})
            
While !EOF()
    Aadd(aItens,{TRB->CONTA,;
                TRB->N1_DESCRIC,;
                TRB->N1_CBASE,;
                TRB->N1_XPLACA,;
                TRB->N1_XPREF,;
                TRB->N1_XCHASSI,;
                TRB->N1_CHAPA,;
                TRB->A2_NOME,;
                stod(TRB->N1_AQUISIC),;
                TRB->N1_ITEM,;
                TRB->N3_VORIG1,;
                TRB->N3_TXDEPR1,;
                TRB->N3_VRCACM1,;
                TRB->N3_VRDMES1,;
                TRB->N3_VRDACM1,;
                TRB->N3_VORIG1-TRB->N3_VRDACM1})
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

Local aSM0Data2 :=  FWSM0Util():GetSM0Data(cempant,CFILANT)
Local nPos1     :=  Ascan(aSM0Data2,{|x| alltrim(x[1]) == "M0_FILIAL"})
Local nPos2     :=  Ascan(aSM0Data2,{|x| alltrim(x[1]) == "M0_NOMECOM"})

Local cExterno  :=  CFILANT + ' ' + aSM0Data2[nPos1,2] + ' ' + aSM0Data2[nPos2,2] + CRLF

cExterno += 'Periodo '+cvaltochar(MV_PAR03)+' e '+cvaltochar(MV_PAR04)

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

MsgAlert("Relatório finalizado")
	
    
Return(cDir+cArqXls)
