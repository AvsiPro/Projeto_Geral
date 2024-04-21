#INCLUDE "PROTHEUS.CH"
/*
    Rotina para gerar arquivo excel de indicadores de produtos SBZ - Exportar e importar dados
    MIT 44_ESTOQUE_EST012 - Processamento rotina gerar pre-requisição de forma automática
    
    DOC MIT
    https://docs.google.com/document/d/1rAM0C2yu5RCbSzqiOUx3xwuG2ibxqY4N/edit
    DOC Entrega
    https://docs.google.com/document/d/1VBv__srwihwlfninPxz45jr8Xgx2-CV3/edit
    
*/
User Function JCOMM001()

Local aPergs    :=  {}
Local aRet      :=  {}
Local aTab      :=  {'SBZ'}

Private aHoBrw1 :=  {}
Private aDados  :=  {}
Private aCabec  :=  {}
Private nExcl   :=  0

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

aAdd(aPergs ,{1,"Filial de:"	,space(TamSx3("BZ_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Filial Até:"	,padr('zz',TamSx3("BZ_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Grupo de"	    ,space(TamSx3("B1_GRUPO")[1]) ,"@!",".T.","SBM",".T.",60,.F.})
aAdd(aPergs ,{1,"Grupo Até"	    ,padr('zz',TamSx3("B1_GRUPO")[1]) ,"@!",".T.","SBM",".T.",60,.F.})
aAdd(aPergs ,{1,"Produto de"    ,space(TamSx3("BZ_COD")[1])   ,"@!",".T.","SB1",".T.",80,.F.})
aAdd(aPergs ,{1,"Produto Até"	,padr('zz',TamSx3("BZ_COD")[1])   ,"@!",".T.","SB1",".T.",80,.F.})
aAdd(aPergs ,{2,"Tipo Execução"	,"", {"1=Exportar","2=Importar"},50,'',.T.})

	
If ParamBox(aPergs ,"Filtrar por",@aRet)
    MV_PAR01 := aRet[1]
    MV_PAR02 := aRet[2]
    MV_PAR03 := aRet[3]
    MV_PAR04 := aRet[4]
    MV_PAR05 := aRet[5]
    MV_PAR06 := aRet[6]
    MV_PAR07 := aRet[7]

    If MV_PAR07 == "1"
        Processa({|| lertab('SBZ')},"Montando layout")
        Processa({|| Busca('SBZ')},"Filtrando Dados")
        Processa({|| GeraPlan(aTab)},"Gerando Planilha")
    else
        Processa({|| aDados:= validPla()},"Validando linhas x layout")
        If len(aDados) > 0
            Processa({|| ImpPlan(aDados)},"Importando os Dados")
            MsgAlert("Importação finalizada!!!")
        EndIf
    Endif
EndIf 

Return

/*/{Protheus.doc} nomeStaticFunction
    Ler as tabelas para exportação do arquivo
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
    If aAux[2] <> "M"
        Aadd(aHoBrw1,{  cTabela,;
                        aAux[1],;
                        cTitulo,;
                        Alltrim(FWSX3Util():GetDescription( aAuxX3[nCont]  ) ),;
                        aAux[2],;
                        aAux[3],;
                        aAux[4],;
                        Alltrim(cCombo),;
                        lRet} )
    EndIf
Next nCont

If len(aHoBrw1) > 0
    Aadd(aHoBrw1,{  cTabela,;
                    'RECNO',;
                    'Recno',;
                    '',;
                    'N',;
                    999,;
                    0,;
                    '',;
                    .F.} )
Endif

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 08/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(cTabela)

Local cQuery    := ''
Local nCont     :=  0
Local aAux      :=  {}

cQuery := "SELECT BZ.R_E_C_N_O_ AS RECNO,*"
cQuery += " FROM "+RetSQLName(cTabela)+" BZ"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += "     AND B1_COD=BZ_COD AND B1.D_E_L_E_T_=' '"
cQuery += "     AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += "     AND B1_XCODPAI=' '"
cQuery += " WHERE "
cQuery += " BZ_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND BZ_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQuery += " AND BZ.D_E_L_E_T_=' '"

If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf             

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)  

dbSelectArea("TRB")

While !EOF()
    aAux := {}
    For nCont := 1 to len(aHoBrw1)
        Aadd(aAux,&("TRB->"+Alltrim(aHoBrw1[nCont,02])))
    Next nCont
    Aadd(aDados,aAux)
    Dbskip()
EndDo 

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
Local cArqXls 	:= "SBZ_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX 
Local nCont
//Local aAux      :=  {}


cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

For nCont := 1 to len(aTab)
    cTabela := FWX2Nome ( aTab[nCont] ) 
    oExcel:AddworkSheet(aTab[nCont]) 
    oExcel:AddTable (aTab[nCont],cTabela)

    For nX := 1 to len(aHoBrw1)
        oExcel:AddColumn(aTab[nCont],cTabela,aHoBrw1[nX,02]+" / ("+aHoBrw1[nX,05]+","+cvaltochar(aHoBrw1[nX,06])+")",1,1)
    Next nX
    
    
    For nX := 1 to len(aDados)
        oExcel:AddRow(aTab[nCont],cTabela,aDados[nX])
    Next nX
    
 
Next nCont


oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:Destroy()

	
Return(cDir+cArqXls)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 08/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function validPla()

Local cArqAux 
Local aAux      :=  {}
Local aRet      :=  {}
Local nCont     :=  0
Local nTamLin   :=  0
Local nX        :=  0

Local nY        :=  0

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
    For nCont := 1 to len(aAux)
        Aadd(aRet,Separa(aAux[nCont],";"))
        If nCont == 1
            nTamLin := len(aRet[1])
        Else 
            If len(aRet[len(aRet)]) <> nTamLin
                aRet := {}
                Return
            EndIf
        EndIf
    Next nCont

    For nCont := 1 to len(aRet)
        aAux := aRet[nCont]
        aCabec := separa(aAux[1],"/")
        aAux := FWSX3Util():GetFieldStruct( aCabec[1] )
        If len(aAux) > 0
            aAux := aRet[nCont]
            aCabec := {}
            For nX := 1 to len(aAux)
                Aadd(aCabec,Alltrim(separa(aAux[nX],"/")[1]))
            Next nX
            nExcl := nCont
            exit
        EndIf
    Next nCont

    nX := 1
    nY := 1
    While nX <= nExcl
        Adel(aRet,nY)
        Asize(aRet,len(aRet)-1)
        nX++
    EndDo
Else 
    MsgAlert("Não foi possível abrir o arquivo selecionado!!!")
EndIf 

Return(aRet)

/*/{Protheus.doc} ImpPlan(aDados)
    (long_description)
    @type  Static Function
    @author user
    @since 08/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ImpPlan(aDados)

Local nCont     :=  0
Local nX        :=  0
Local nPosFil   :=  Ascan(aCabec,{|x| x == "BZ_FILIAL"})
Local nPosCod   :=  Ascan(aCabec,{|x| x == "BZ_COD"})
Local aAux      :=  {}
Local nZ        :=  0

DbSelectArea("SBZ")
DbSetOrder(1)

If nPosCod > 0 .And. nPosFil > 0
    For nCont := 1 to len(aDados)
        lRecno := Upper(aCabec[len(aDados[nCont])]) == "RECNO" .And. VAL(aDados[nCont,len(aDados[nCont])]) > 0
        
        If lRecno 
            DbGoto(val(aDados[nCont,len(aDados[nCont])]))
            If Alltrim(&("SBZ->"+aCabec[nPosFil])+&("SBZ->"+aCabec[nPosCod])) == aDados[nCont,nPosFil]+aDados[nCont,nPosCod]
                Reclock("SBZ",.F.)
            ELSE
                Reclock("SBZ",.T.)
            ENDIF
        Else 
            If DbSeek(aDados[nCont,nPosFil]+aDados[nCont,nPosCod])
                Reclock("SBZ",.F.)
            Else 
                Reclock("SBZ",.T.)
            EndIf
        EndIf

        //-1 porque o ultimo campo é o recno
        For nX := 1 to len(aCabec)-1
            aAux := FWSX3Util():GetFieldStruct( aCabec[nX] )
            If aAux[2] == "N"
                SBZ->(&(aCabec[nX])) := val(aDados[nCont,nX])
            ElseIf aAux[2] == "D"
                SBZ->(&(aCabec[nX])) := stod(aDados[nCont,nX])
            ELSE
                SBZ->(&(aCabec[nX])) := aDados[nCont,nX]
            ENDIf
        Next nX 

        SBZ->(Msunlock())

        aFilhos := BuscaFilhos(aDados[nCont,nPosCod])

        For nZ := 1 to len(aFilhos)
            If DbSeek(aDados[nCont,nPosFil]+aFilhos[nZ])
                Reclock("SBZ",.F.)
            Else 
                Reclock("SBZ",.T.)
            EndIf

            For nX := 1 to len(aCabec)-1
                aAux := FWSX3Util():GetFieldStruct( aCabec[nX] )
                If aAux[2] == "N"
                    SBZ->(&(aCabec[nX])) := val(aDados[nCont,nX])
                ElseIf aAux[2] == "D"
                    SBZ->(&(aCabec[nX])) := stod(aDados[nCont,nX])
                ELSE
                    If nX == nPosCod
                        SBZ->(&(aCabec[nX])) := aFilhos[nZ]
                    Else 
                        SBZ->(&(aCabec[nX])) := aDados[nCont,nX]
                    EndIf 
                ENDIf
            Next nX 

            SBZ->(Msunlock())
        Next nZ 

    Next nCont  
Else 
    MsgAlert("Não foram encontrados os campos Filial e codigo do produto na planilha")
EndIf 

Return


/*/{Protheus.doc} nomeStaticFunction
    Busca os produtos filhos deste cadastro que esta sendo atualizado
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static function Buscafilhos(cCodigo)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT B1_COD"
cQuery += " FROM "+RetSQLName("SB1")+" B1"
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += " AND B1_XCODPAI='"+cCodigo+"' AND B1_XCODPAI<>' '"
cQuery += " AND D_E_L_E_T_=' '"


If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf             

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)  

dbSelectArea("TRB")

While !EOF()
    Aadd(aRet,TRB->B1_COD)

    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
