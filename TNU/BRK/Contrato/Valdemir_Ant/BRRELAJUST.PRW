#INCLUDE "PROTHEUS.CH"

Static cContrato as Character

/*/{Protheus.doc} BRRELAJUST
Rotina para Impressão Relatório 
Reajuste de Contrato
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 09/10/2023
@return variant, Nil
/*/
USER FUNCTION BRRELAJUST(pContrato)
    Private oReport

    cContrato := pContrato

    oReport := ReportDef()
    oReport:PrintDialog()

RETURN 


/*/{Protheus.doc} ReportDef
Funcao Statica para montagem 
das colunas do relatório
@type function
@version  12.1.22
@author Valdemir José Rabelo
@since 10/10/2023
@return variant, Objeto
/*/
Static Function ReportDef(pContrato)
    Local oReport
    Local oSection1

    oReport := TReport():New("RELAJUS","RELATORIO DE REAJUSTE CONTRATO","",{ |oReport| ReportPrint(oReport)},"Imprime LOG com os erros de importacao das reservas.")
    oReport:SetLandScape(.T.)

    oSection1 := TRSection():New(oReport,"RELATORIO DE REAJUSTE CONTRATO",{"CNA"})

    TRCell():New(oSection1, "CONTRATO" , , "Contrato"     , , 020, .F.,)
    TRCell():New(oSection1, "PLANILHA" , , "Planilha"     , , 050, .F.,)
    TRCell():New(oSection1, "FANTASIA" , , "Fantasia"     , , 020, .F.,)
    TRCell():New(oSection1, "CODSERV"  , , "Cod.Serv."    , , 020, .F.,)
    TRCell():New(oSection1, "DESCRICAO", , "Descrição"    , , 050, .F.,)
    TRCell():New(oSection1, "ULT_COMP" , , "Dt.Ult.Pr"    , , 018, .F.,)
    TRCell():New(oSection1, "PRC_ATUAL", , "Preço Atual"  , , 050, .F.,)
    TRCell():New(oSection1, "REAJUSTE" , , "Reajuste"     , , 015, .F.,)
    TRCell():New(oSection1, "PRCATUALI", , "Prc.Atualiz." , , 015, .F.,)

    oSection1:SetHeaderSection(.T.)
    oSection1:Setnofilter("CNA")

Return oReport

/*/{Protheus.doc} ReportPrint
Funcao statica que carrega os dados
a serem apresentado no relatório
@type function
@version  12.1.22
@author Valdemir José Rabelo
@since 10/10/2023
@param oReport, object, Objeto Relatorio
@return variant, Objeto
/*/
Static Function ReportPrint(oReport)
    Local cALIAS    := ""
    Local nTotReg   := 0
    Local oSection1 := oReport:Section(1)
    Local aDADOS    := Array(10)
        
    oSection1:Cell("CONTRATO" ):SetBlock( {|| aDADOS[01] } )
    oSection1:Cell("PLANILHA" ):SetBlock( {|| aDADOS[02] } )
    oSection1:Cell("FANTASIA" ):SetBlock( {|| aDADOS[03] } )
    oSection1:Cell("CODSERV"  ):SetBlock( {|| aDADOS[04] } )
    oSection1:Cell("DESCRICAO"):SetBlock( {|| aDADOS[05] } )
    oSection1:Cell("ULT_COMP" ):SetBlock( {|| aDADOS[06] } )
    oSection1:Cell("PRC_ATUAL"):SetBlock( {|| aDADOS[07] } )
    oSection1:Cell("REAJUSTE" ):SetBlock( {|| aDADOS[08] } )
    oSection1:Cell("PRCATUALI"):SetBlock( {|| aDADOS[09] } )

    oReport:SetTitle("RELATORIO DE REAJUSTE CONTRATO")
        
    Processa({|| cALIAS := getFiltra() },"Compondo Relatorio")

    (cALIAS)->( dbEval( {|| nTotReg++},,{ || !Eof() }))
    (cALIAS)->( dbGotop() )
    aFill(aDADOS,Nil)
    oSection1:Init()
    oReport:SetMeter(nTotReg)

    While (cALIAS)->( ! Eof() )
        oReport:IncMeter()
        aDADOS[01] := (cALIAS)->CONTRATO
        aDADOS[02] := (cALIAS)->PLANILHA
        aDADOS[03] := (cALIAS)->FANTASIA
        aDADOS[04] := (cALIAS)->CODSERV
        aDADOS[05] := (cALIAS)->DESCRICAO
        aDADOS[06] := (cALIAS)->ULT_COMP
        aDADOS[07] := (cALIAS)->PRC_ATUAL
        aDADOS[08] := (cALIAS)->REAJUSTE
        aDADOS[09] := (cALIAS)->PRCATUALI

        oSection1:PrintLine()
        aFill(aDADOS,Nil)
        (cALIAS)->( dbSkip() )
    EndDo 

    oSection1:PrintLine()

Return oReport


/*/{Protheus.doc} getFiltra
Funcao Statica para Filtrar os 
Dados informado no parametro
@type function
@version  12.1.22
@author Valdemir José Rabelo
@since 10/10/2023
@return variant, TabelaTemporria
/*/
Static Function getFiltra()
    Local cAliasTMP as Character
    Local cCondicao as Character

    // Inicializador
    cAliasTMP := GetNextALias()
    cCondicao += "%CNA.CNA_CONTRA= '"+cContrato+"' " + CRLF 
    cCondicao += "%"

        BeginSql Alias cAliasTMP
            SELECT
                CNA.CNA_CONTRA CONTRATO,
                CNA.CNA_NUMERO PLANILHA,
                CASE WHEN CNA.CNA_CLIENT <> '' THEN 
                    SA1.A1_NREDUZ
                CASE WHEN CNA.CNA_FORNEC <> '' THEN 
                    SA2.A2_NREDUZ
                ELSE
                    ' '
                END AS FANTASIA,
                CNB.CNB_PRODUT CODSERV,
                CNB.CNB_DESCRI DESCRICAO,
                SB1.B1_UCOM ULT_COMP,
                SB1.B1_PRV1 PRC_ATUAL
                
            FROM %Table:CNA% CNA
            INNER JOIN %Table:CNB% CNB
            ON CNB.CB_FILIAL=CNA.CNA_FILIAL
                AND CNB.CNB_CONTRA=CNA.CNA_CONTRA
                AND CNB.CNB_REVISA=CNA.CNA_REVISA
                AND CNB.CNB_NUMERO=CNA.CNA_NUMERO
                AND CNB.%NotDel%
            LEFT JOIN %Table:SA1% SA1
            ON SA1.A1_FILIAL=%XFILIAL:SA1%
               AND SA1.A1_COD=CNA.CNA_CLIENT
               AND SA1.A1_LOJA=CNA.CNA_LOJACL
               AND SA1.%NotDel%
            LEFT JOIN %Table:SA2% SA2
            ON SA2.A2_FILIAL=%XFILIAL:SA2%
               AND SA2.A2_COD=CNA.CNA_CLIENT
               AND SA2.A2_LOJA=CNA.CNA_LOJACL
               AND SA2.%NotDel%
            INNER JOIN %Table:SB1% SB1
            ON SB1.B1_FILIAL=%XFILIAL:SB1%
               AND SB1.B1_COD=CNB.CNB_PRODUT
               AND SB1.%NotDel%
            WHERE CNA.%NotDel%
             AND %EXP:cCondicao%
        EndSql

Return cAliasTMP
