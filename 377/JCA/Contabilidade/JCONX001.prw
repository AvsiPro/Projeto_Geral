#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
    Importação lançamentos contabeis através de arquivo.
    MIT 44_Contabilidade_CTB007_Importação lançamento a partir do Excel_

    DOC MIT
    https://docs.google.com/document/d/1LshFpooQY7ZrcqFsghxe3jDQ5OIykBSm/edit
    DOC Entrega
    
    
*/

User Function JCONX001()

Local aTab          := {'CT2'}
LOCAL cDesc1	    := "Relação entrega de materiais"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico JCA"
Local nCont         :=  0
Local nOpcRel       :=  0
Local aAux          :=  {}
Local aRet          :=  {}
Local aAuxC         :=  {}
Local aCabec        :=  {}
Local nPosCb        :=  0
Private aHoBrw1     :=  {}

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

cPerg	 	:= Padr("RESTAT1",10)

ProcLogIni( {},"JCONX001" )

ProcLogAtu("INICIO", "CT2 - Importação lançamentos contabeis ")


@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio de Entrega de peças")
@ 008,010 TO 084,222
@ 018,020 SAY OemToAnsi(cDesc1)
@ 030,020 SAY OemToAnsi(cDesc2)
@ 045,020 SAY OemToAnsi(cDesc3)

@ 095,120 BMPBUTTON TYPE 6 	ACTION Eval( { || nOpcRel := 2, oDlg:End() } )
//@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)
@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )

ACTIVATE DIALOG oDlg CENTERED

If nOpcRel == 1
    
    cArqAux := cGetFile( '*.csv|*.csv',; //[ cMascara], 
                            'Selecao de Arquivos',;                  //[ cTitulo], 
                            0,;                                      //[ nMascpadrao], 
                            'C:\',;                            //[ cDirinicial], 
                            .F.,;                                    //[ lSalvar], 
                            GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                            .T.)   
                                                            //[ lArvore] 
    oFile := FwFileReader():New(cArqAux)

    If (oFile:Open())
        aAux := oFile:GetAllLines()

        nPosCb := Ascan(aAux,{|x| "_FILIAL" $ Alltrim(x)})

        If nPosCb == 0
            MsgAlert("Não foi encontrado o cabeçalho da tabela no arquivo")
            Return 
        Else 

            Aadd(aAuxC,Separa(aAux[nPosCb],";"))

            For nCont := 1 to len(aAuxC[1])
                aAuxX3 := FWSX3Util():GetFieldStruct( aAuxC[1,nCont] )
                If len(aAuxX3) > 0
                    Aadd(aCabec,{Alltrim(aAuxX3[1]),aAuxX3[2],aAuxX3[3],.T.})
                Else 
                    Aadd(aCabec,{Alltrim(aAuxC[1,nCont]),'','',.f.})
                EndIf 
            Next nCont

            For nCont := nPosCb+1 to len(aAux)

                Aadd(aRet,Separa(aAux[nCont],";"))

            Next nCont

            geraCT2(aCabec,aRet)

        EndIf 
       
        ProcLogAtu("MENSAGEM", 'Arquivo processado '+cArqAux)

        MsgAlert("Processo finalizado")

    EndIf 

ElseIf nOpcRel == 2
    For nCont := 1 to len(aTab)
        lertab(aTab[nCont])
    Next nCont 

    GeraPlan(aTab)
    GeraPlan2(aTab,'CONTABIL')
EndIf 

ProcLogAtu("FIM")

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
Local cDir 

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
    //oExcel:AddColumn(aTab[nCont],cTabela,"Pesquisa",1,1)
    //oExcel:AddColumn(aTab[nCont],cTabela,"DE/PARA",1,1)
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
    //If Ascan(aHoBrw1,{|x| "_CLI" $ upper(x[2])}) > 0
        aAuxReg   :=  {}
        cQuery := "SELECT TOP(2) * FROM "+RetSQLName(aTab[nCont])
        cQuery += " WHERE D_E_L_E_T_=' ' "
        //cQuery += " AND "+aHoBrw1[Ascan(aHoBrw1,{|x| "_CLI" $ upper(x[2])}),02]+"='TEXHMP'"
        //cQuery += "  AND ROWNUM < 2"
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


/*/{Protheus.doc} geraCT2
    (long_description)
    @type  Static Function
    @author user
    @since 08/02/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function geraCT2(aCabec,aArray)

Local nPos1 := Ascan(aCabec,{|x| x[1] == "CT2_DATA"})
Local nPos2 := Ascan(aCabec,{|x| x[1] == "CT2_LOTE"})
Local nPos3 := Ascan(aCabec,{|x| x[1] == "CT2_SBLOTE"})
Local nPos4 := Ascan(aCabec,{|x| x[1] == "CT2_DOC"})
Local dDataLanc
Local cLote 
Local cSBLote 
Local cDoc 
Local nCont 
Local aAux  := {}
Local nX 
Local aItens    :=  {}
Local cCpoExc   := Alltrim(Supergetmv("TI_CPOEXC",.F.,"CT2_CODPAR"))

Private lMsErroAuto := .F.

SetFunName("JGENX004")

If nPos1 > 0 .And. nPos2 > 0 .And. nPos3 > 0
    
    dDataLanc   :=  StoD(if(!"/" $ aArray[1,nPos1],aArray[1,nPos1],dtos(ctod(aArray[1,nPos1]))))
    cLote       :=  aArray[1,nPos2]
    cSBLote     :=  aArray[1,nPos3]
    cDoc        :=  aArray[1,nPos4]
Else 
    MsgAlert("Arquivo sem informações principais para importação Data/Lote/Sub-lote")
    Return 
Endif 


aCab := {}

aAdd(aCab, {'DDATALANC' ,dDataLanc		    ,NIL} )
aAdd(aCab, {'CLOTE' 	,cLote      	    ,NIL} )
aAdd(aCab, {'CSUBLOTE'  ,cSBLote            ,NIL} )
aAdd(aCab, {'CPADRAO' 	,'' 				,NIL} )
aAdd(aCab, {'NTOTINF' 	,0 					,NIL} )
aAdd(aCab, {'NTOTINFLOT',0 					,NIL} )

For nCont := 1 to len(aArray)
    aAux := {}
    For nX := 1 to len(aCabec)
        If aCabec[nX,04] .And. !aCabec[nX,01] $ cCpoExc 
            If aCabec[nX,02] == "N"
                cConteudo := val(aArray[nCont,nX])
            ElseIf aCabec[nX,02] == "D"
                cConteudo := stod(aArray[nCont,nX])
            Else 
                cConteudo := aArray[nCont,nX]
            EndIf 
             
            Aadd(aAux,{aCabec[nX,01] , cConteudo    ,   Nil})
        EndIf 
    Next nX 

    Aadd(aItens,aAux)
Next nCont 
/*
aAdd(aItens,{ ;
            {'CT2_FILIAL' 	,cFilAnt 					, NIL},;
            {'CT2_LINHA' 	,StrZero(nLinha,3)			, NIL},;
            {'CT2_MOEDLC'	,cMoeda					 	, NIL},;
            {'CT2_DC' 		,cDC				 		, NIL},;
            {'CT2_DEBITO' 	,cDebito				 	, NIL},;
            {'CT2_CREDIT' 	,cCredit				 	, NIL},;
            {'CT2_CCD' 		,cCCD				 		, NIL},;
            {'CT2_CCC' 		,cCCC				 		, NIL},;
            {'CT2_ITEMD' 	,cItemD						, NIL},;
            {'CT2_ITEMC' 	,cItemC					 	, NIL},;
            {'CT2_CLVLDB' 	,cClVlDb 					, NIL},;
            {'CT2_CLVLCR' 	,cClVlCr 					, NIL},;
            {'CT2_VALOR' 	,nValor						, NIL},;
            {'CT2_ORIGEM'   ,cOrigem				 	, NIL},;
            {'CT2_HIST' 	,cHist						, NIL},;
            {'CT2_EMPORI' 	,cEmpAnt 					, NIL},;
            {'CT2_FILORI' 	,cFilAnt 					, NIL}})*/


lMsErroAuto := .f.

MSExecAuto({|x, y,z| CTBA102(x,y,z)}, aCab ,aItens, 3)

If lMsErroAuto
    Mostraerro()
EndIf 

Return
