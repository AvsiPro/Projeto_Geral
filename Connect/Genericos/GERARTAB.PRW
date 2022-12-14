#INCLUDE "PROTHEUS.CH"

User Function GERARTAB()

Local aTab  := {'AA1'}
//{'SA2','SA3','SB1','SF4','SE1','SE2','SE4','SED'}  
//{'AI0','AC8','SU5','SA3','SB1','SC5','SC6','SF2','SD2','CV8','PDR','SE1','SE2','SE5','SN1','SN3','AD2','ADK','ADY','ADZ'}
//{'CN9','CNA','CNB','CNC','PH4','PHG'}
//{'SA2'}
//

Local nCont :=  0
Private aHoBrw1 := {}

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

For nCont := 1 to len(aTab)
    lertab(aTab[nCont])
Next nCont 

GeraPlan(aTab)

Return

/*/{Protheus.doc} nomeStaticFunction
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
Static Function lertab(cTabela)

Local aAuxX3 := {}
Local nCont  := 0
Local aAux   := {}
Local cCombo := ''

aAuxX3 := FWSX3Util():GetAllFields( cTabela , .F. )

For nCont := 1 to len(aAuxX3)

    aAux := FWSX3Util():GetFieldStruct( aAuxX3[nCont] )
    
    lRet := X3Obrigat(aAux[1])
    cCombo := GetSX3Cache(aAux[1], "X3_CBOX") 
    cTitulo := FWX3Titulo( aAux[1] )
    Aadd(aHoBrw1,{  cTabela,;
                    aAux[1],;
                    cTitulo,;
                    Alltrim(FWSX3Util():GetDescription( aAuxX3[nCont]  ) ),;
                    aAux[2],;
                    aAux[3],;
                    aAux[4],;
                    Alltrim(cCombo),;
                    lRet} )
Next nCont


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
Static Function GeraPlan(aTab)

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Templates_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX 
Local nCont

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

For nCont := 1 to len(aTab)
    cTabela := FWX2Nome ( aTab[nCont] ) 
    oExcel:AddworkSheet(aTab[nCont]) 
    oExcel:AddTable (aTab[nCont],cTabela)
    oExcel:AddColumn(aTab[nCont],cTabela,"Campo",1,1)
    oExcel:AddColumn(aTab[nCont],cTabela,"Titulo",1,1) 
    oExcel:AddColumn(aTab[nCont],cTabela,"Descrição",1,1) 
    oExcel:AddColumn(aTab[nCont],cTabela,"Tipo",1,1) 
    oExcel:AddColumn(aTab[nCont],cTabela,"Tamanho",1,1) 
    oExcel:AddColumn(aTab[nCont],cTabela,"Decimais",1,1)
    oExcel:AddColumn(aTab[nCont],cTabela,"Obrigatorio",1,1)
    oExcel:AddColumn(aTab[nCont],cTabela,"Combobox",1,1)
    //AddColumn
    //AddRow
    For nX := 1 to len(aHoBrw1) 
        If Alltrim(aHoBrw1[nX,01]) == Alltrim(aTab[nCont])
            oExcel:AddRow(aTab[nCont],cTabela,{aHoBrw1[nX,02],;
                                            aHoBrw1[nX,03],; 
                                            aHoBrw1[nX,04],;
                                            aHoBrw1[nX,05],;
                                            aHoBrw1[nX,06],;
                                            aHoBrw1[nX,07],;
                                            If(aHoBrw1[nX,09],'Sim','Nao'),;
                                            aHoBrw1[nX,08]}) 
        EndIf 
    Next nX

    oExcel:AddworkSheet(aTab[nCont]+"_Template") 
    oExcel:AddTable (aTab[nCont]+"_Template",cTabela)
    oExcel:AddColumn(aTab[nCont]+"_Template",cTabela,"Campo",1,1)

    For nX := 1 to len(aHoBrw1)
        If Alltrim(aHoBrw1[nX,01]) == Alltrim(aTab[nCont])
            oExcel:AddColumn(aTab[nCont]+"_Template",cTabela,aHoBrw1[nX,02],1,1)
        EndIf 
    Next nX 
Next nCont


oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:Destroy()

	
Return(cDir+cArqXls)


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
Static Function GeraPlan2(aTab,cModulo)

Local oExcel 	:= FWMSEXCEL():New()
//Local cDir 		:= ""
Local cArqXls 	:= cModulo+"_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX 
Local nCont
Local aAuxReg   :=  {}
Local nLinha    :=  1

If Empty(cDir)
	Return
EndIf

For nCont := 1 to len(aTab)
    cTabela := FWX2Nome ( aTab[nCont] ) 
    oExcel:AddworkSheet(aTab[nCont]) 
    oExcel:AddTable (aTab[nCont],cTabela)
    oExcel:AddColumn(aTab[nCont],cTabela,"Campo",1,1)
    oExcel:AddColumn(aTab[nCont],cTabela,"Titulo",1,1) 
    oExcel:AddColumn(aTab[nCont],cTabela,"Descrição",1,1) 
    oExcel:AddColumn(aTab[nCont],cTabela,"Tipo",1,1) 
    oExcel:AddColumn(aTab[nCont],cTabela,"Tamanho",1,1) 
    oExcel:AddColumn(aTab[nCont],cTabela,"Decimais",1,1)
    oExcel:AddColumn(aTab[nCont],cTabela,"Obrigatorio",1,1)
    oExcel:AddColumn(aTab[nCont],cTabela,"Combobox",1,1)
    oExcel:AddColumn(aTab[nCont],cTabela,"Pesquisa",1,1)
    oExcel:AddColumn(aTab[nCont],cTabela,"DE/PARA",1,1)

    //AddColumn
    //AddRow
    For nX := 1 to len(aHoBrw1) 
        If Alltrim(aHoBrw1[nX,01]) == Alltrim(aTab[nCont])
            oExcel:AddRow(aTab[nCont],cTabela,{aHoBrw1[nX,02],;
                                            aHoBrw1[nX,03],; 
                                            aHoBrw1[nX,04],;
                                            aHoBrw1[nX,05],;
                                            aHoBrw1[nX,06],;
                                            aHoBrw1[nX,07],;
                                            If(aHoBrw1[nX,09],'Sim','Nao'),;
                                            aHoBrw1[nX,08],;
                                            aHoBrw1[nX,10],;
                                            aHoBrw1[nX,11]}) 
        EndIf 
    Next nX

    oExcel:AddworkSheet(aTab[nCont]+"_Template") 
    oExcel:AddTable (aTab[nCont]+"_Template",cTabela)
    oExcel:AddColumn(aTab[nCont]+"_Template",cTabela,"Campo",1,1)

    For nX := 1 to len(aHoBrw1)
        If Alltrim(aHoBrw1[nX,01]) == Alltrim(aTab[nCont])
            oExcel:AddColumn(aTab[nCont]+"_Template",cTabela,aHoBrw1[nX,02],1,1)
        EndIf 
    Next nX 

    //If Ascan(aHoBrw1,{|x| "_CLI" $ upper(x[2])}) > 0
        aAuxReg   :=  {}
        cQuery := "SELECT * FROM "+RetSQLName(aTab[nCont])
        cQuery += " WHERE D_E_L_E_T_=' ' "
        //cQuery += " AND "+aHoBrw1[Ascan(aHoBrw1,{|x| "_CLI" $ upper(x[2])}),02]+"='TEXHMP'"
        cQuery += "  AND ROWNUM < 2"
        cQuery += " ORDER BY R_E_C_N_O_ DESC"
        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        EndIf

        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
        Aadd(aAuxReg,"")

        DbSelectArea("TRB")
        For nX := 1 to len(aHoBrw1)
            If Alltrim(aHoBrw1[nX,01]) == Alltrim(aTab[nCont])
                If aHoBrw1[nX,05] <> "M"
                    Aadd(aAuxReg,&("TRB->"+aHoBrw1[nX,02]))
                Else
                    Aadd(aAuxReg,'campo_memo')
                endIf
            EndIf 
        Next nX 

        If len(aAuxReg) > 2
            oExcel:AddRow(aTab[nCont]+"_Template",cTabela,aAuxReg) 
        EndIf
      
    //EndIf 

Next nCont


oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:Destroy()

	
Return(cDir+cArqXls)

