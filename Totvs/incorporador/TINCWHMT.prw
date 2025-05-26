#include 'protheus.ch'
#include "fileio.ch"

User Function TINCWHMT( )

	RpcSetType(3)
	RpcSetEnv("00","05401000100")
    //U_xTincWH2()
    
    
Return

// IntegraMais - ValidaIntegração - Thread Principal

// IntegraMais - ValidaIntegração - Thread Auxiliar
User Function IM_VI_02_ThreadAuxiliarValidaIntegracao( cEmpAnt, cFilAnt, cTabFinal, cDocEmp, nRowNumDe, nRowNumAte, nThread, cCampos )
    //Local cIdThread := cValToChar(ThreadId())
    Local aDiverg  := {}
    Local lDiverg  := .F.
    Local cUniqKey := ""
    Local nX, nG
    Local xDadoTab, xValType
    Local oIntegraMais

	RpcClearEnv( )
    RpcSetType( 3 )
    RpcSetEnv( cEmpAnt, cFilAnt )

    oIntegraMais := WHIntegraMais():NewValidInteg( cTabFinal, cDocEmp, nRowNumDe, nRowNumAte, nThread, cCampos )
    oIntegraMais:ExecQryPaginacaoP98( )


    DbSelectArea("P98")
    DbSelectArea( oIntegraMais:cTabFinal )
    ( oIntegraMais:cTabFinal )->( DbSetOrder(1) )

    While ( oIntegraMais:cAliasQuery )->(!Eof())

        cDados := ""
        P98->( dbGoto( ( oIntegraMais:cAliasQuery )->RECNO ) )
        oJson:= JsonObject():new()
        oJson:FromJson( P98->P98_BODY )

        cUniqKey := oJson["fields"]["indiceFinal"] // 05401000100 +000001
        cUniqKey := StrTran(StrTran(cUniqKey, " ", ""), "+", "") // 05401000100000001

        If ( oIntegraMais:cTabFinal )->( DbSeek( cUniqKey ) )
        
            for nX := 1 to oIntegraMais:nQtdCampos
                cField    := oIntegraMais:aCampos[nX]
                xDadoJson := oJson["fields"][cField]
                xDadoTab  := &(oIntegraMais:cTabFinal+"->"+cField)
                xValType  := ValType( xDadoTab )

                If xValType == "C"
                    xDadoTab := AllTrim( xDadoTab )
                ElseIf xValType == "N"
                    xDadoTab := cValtochar( xDadoTab )
                ElseIf xValType ==  "D"
                    xDadoTab := Dtos(xDadoTab)
                EndIf

                If xDadoTab <> xDadoJson
                    lDiverg := .T.
                    aAdd(aDiverg,(oIntegraMais:cTabFinal+';'+cUniqKey+';'+cField+';'+xDadoJson+';'+xDadoTab+';'+cValToChar(nRowNumDe)))
                EndIf

            next nX

        Else
            lDiverg := .T.
            aAdd(aDiverg,(oIntegraMais:cTabFinal+';'+cUniqKey+';'+'Registro nao encontrado na Tabela;  ;  ;'+cValToChar(nRowNumDe)))
        EndIf

        If lDiverg  // se existir divergencia incrementa o arquivo 
            For nG := 1 to Len(aDiverg)
                If nG < Len(aDiverg)
                    cDados += aDiverg[nG]+CRLF
                Else
                    cDados += aDiverg[nG]
                EndIf
            Next nG

            oIntegraMais:SaveMsgLog( oIntegraMais:cArqLogThread, cDados )

            aDiverg := { }
            cDados := ''
        Else // senão exclui o arquivo criado com o cabeçalho
            Ferase( oIntegraMais:cArqLogThread )
        EndIf

        FreeObj( oJson )
        oJson := NIL 

        nRowNumDe++
        ( oIntegraMais:cAliasQuery )->(DbSkip())
    EndDo

    ( oIntegraMais:cAliasQuery )->(dbCloseArea())

Return

//Thread auxiliar de migração
User function IM_MD_02_ThreadAuxiliarMigracaoDados( _cEmpAnt, _cFilAnt, cTabCabec, cTabItens, nRowDe, nRowAte, nThread, cCodEmpP97, cUsrLog, cCodPN2, cQtdLog, /*cTextoLog, cLocArq,*/ lDupla, nTipIncl, cFilDest )

    Local cIdThread := cValToChar( ThreadId( ) )
    Local oIntegraMais
    Local nX,nY, nLen
    Local cRowNumber
    Local aCabec, aItens, aLinha
    Local aAuxAtf := { }
    Local aTabAux := If("/" $ cTabItens,separa(cTabItens,"/"),{ })
    Local nCont 

    Private CCODIGO := ""

    RpcSetType( 3 )
    RpcSetEnv( _cEmpAnt, _cFilAnt )

    oIntegraMais := WHIntegraMais():NPrMGAux( cTabCabec, cTabItens, nRowDe, nRowAte, nThread, cCodEmpP97, cUsrLog, cCodPN2, cQtdLog, /*cTextoLog, cLocArq,*/ lDupla, nTipIncl, cFilDest )

    cRowNumAte := cvaltochar( oIntegraMais:nRowNumAte )
    FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/,  "@@@@@@ FUCNTION IM_MD_02_ThreadAuxiliarMigracaoDados -> THREAD " + cValToChar( nThread ) + " ID( " + cIdThread + " ) processando row_numbers de " + cvaltochar( oIntegraMais:nRowNumDe ) + " ate " + cvaltochar( oIntegraMais:nRowNumAte ) + " " , /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

    oIntegraMais:StArrCamposCabec( ) // VarInfo( "aCabec", oIntegraMais:aCamposCabec )

    If lDupla
        If len(aTabAux) > 0
            For nCont := 1 to len(aTabAux)
                oIntegraMais:StArrContratos( aTabAux[nCont] )
            Next nCont 
        Else 
            oIntegraMais:StArr( ) //VarInfo( "aItens", oIntegraMais:aCamposItens )    
        EndIf 
    EndIf 

    If cTabCabec <> "CN9"
        oIntegraMais:QueryCb( )
    Else
        oIntegraMais:QueryCbContratos( )
    EndIf 

    While( oIntegraMais:cAliasQuery )->( !Eof( ) )

        FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/, "@@@@@@ FUCNTION IM_MD_02_ThreadAuxiliarMigracaoDados -> THREAD " + cValToChar( nThread ) + " ID( " + cIdThread + " ) processando RowNumber " + cvaltochar(( oIntegraMais:cAliasQuery )->RN) + " de " + cRowNumAte + " ", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
        aAuxAtf    := { }
        aCabec     := { }
        aItens     := { }
        cRowNumber := ( oIntegraMais:cAliasQuery )->RN

        If cTabCabec == "CT2"
            While( oIntegraMais:cAliasQuery )->( !Eof( ) ) .And. ( cRowNumber == ( oIntegraMais:cAliasQuery )->RN  )
                aLinha := { }
                for nX := 1 to oIntegraMais:nQtdCamposCabec
                    aadd( aLinha, { oIntegraMais:aCamposCabec[nX], ( oIntegraMais:cAliasQuery )->&( oIntegraMais:aCamposCabec[nX] ) , Nil } )
                next nX
                
                aadd( aAuxAtf, aLinha )
                ( oIntegraMais:cAliasQuery )->( DbSkip( ) )

            EndDo
        Else 
            for nX := 1 to oIntegraMais:nQtdCamposCabec
                aadd( aCabec, { oIntegraMais:aCamposCabec[nX], ( oIntegraMais:cAliasQuery )->&( oIntegraMais:aCamposCabec[nX] ) , Nil } )
            next nX

            aadd( aAuxAtf, aCabec ) // VarInfo( "aCabec", aCabec )

            If lDupla 
                While( oIntegraMais:cAliasQuery )->( !Eof( ) ) .And. ( cRowNumber == ( oIntegraMais:cAliasQuery )->RN  )

                    aLinha := { }
                    for nY := 1 to oIntegraMais:nQtdCamposItens
                        aadd( aLinha, { oIntegraMais:aCamposItens[nY], ( oIntegraMais:cAliasQuery )->&( oIntegraMais:aCamposItens[nY] ) , Nil } )
                    next nY

                    aadd( aAuxAtf, aLinha )
                    ( oIntegraMais:cAliasQuery )->( DbSkip( ) )

                EndDo 
            EndIf 
        EndIf 

        CCODIGO := cCodEmpP97
        nLen    := len( aAuxAtf )

        If nTipIncl == 4 
            nPos98   := Ascan( aAuxAtf[1], { |x| "P98REC" $ x[1] } )
            nRec1P98 := aAuxAtf[1, nPos98, 2]
            cRet := U_TINCWHXF( nTipIncl, aAuxAtf, cTabCabec, nRec1P98, , cUsrLog, , cCodPN2, 0, cQtdLog, /*cTextoLog, cLocArq,*/ oIntegraMais ) 
        Else        
            For nX := 1 to nLen
                nPos98   := Ascan( aAuxAtf[nX], { |x| "P98REC" $ x[1] } )
                nRec1P98 := aAuxAtf[nX, nPos98, 2]
                Begin Transaction
                    // If nTipIncl == 4 
                    //     cRet := U_TINCWHXF( nTipIncl, aAuxAtf, Aliascpo( aAuxAtf[nX, 2, 1] ), nRec1P98, , cUsrLog, , cCodPN2, 0, cQtdLog, /*cTextoLog, cLocArq,*/ oIntegraMais ) 
                    // Else 
                        cRet := U_TINCWHXF( nTipIncl, aAuxAtf[nX], Aliascpo( aAuxAtf[nX, 2, 1] ), nRec1P98, , cUsrLog, , cCodPN2, 0, cQtdLog, /*cTextoLog, cLocArq,*/ oIntegraMais ) 
                    // EndIf 
                End Transaction
            Next nX
        EndIf  

        If !lDupla .And. !cTabCabec == "CT2"
            ( oIntegraMais:cAliasQuery )->( DbSkip( ) )
        EndIf 

    EndDo

    ( oIntegraMais:cAliasQuery )->( dbCloseArea( ) )

Return

User function _MigCtrHMT( _cEmpAnt, _cFilAnt, cTabCabec, cTabItens, nRowDe, nRowAte, nThread, cCodEmpP97, cUsrLog, cCodPN2, cQtdLog, /*cTextoLog, cLocArq,*/ lDupla, nTipIncl, cFilDest )

    Local cIdThread := cValToChar( ThreadId( ) )
    Local oIntegraMais
    Local nX,nY, nLen
    Local cRowNumber
    Local aCabec, aItens, aLinha
    Local aAuxAtf := { }
    Local aTabAux := If("/" $ cTabItens,separa(cTabItens,"/"),{ })
    Local nCont 
    Local cTabAux := ''
    Local lPassou := .F.

    Private CCODIGO := ""

    RpcSetType( 3 )
    RpcSetEnv( _cEmpAnt, _cFilAnt )

    //INCLUIR NA BRANCH
    oIntegraMais := WHIntegraMais():NPrMGAux( cTabCabec, cTabItens, nRowDe, nRowAte, nThread, cCodEmpP97, cUsrLog, cCodPN2, cQtdLog, /*cTextoLog, cLocArq,*/ lDupla, nTipIncl, cFilDest )

    cRowNumAte := cvaltochar( oIntegraMais:nRowNumAte )
    FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/, "@@@@@@ FUCNTION IM_MD_02_ThreadAuxiliarMigracaoDados -> THREAD " + cValToChar( nThread ) + " ID( " + cIdThread + " ) processando row_numbers de " + cvaltochar( oIntegraMais:nRowNumDe ) + " ate " + cvaltochar( oIntegraMais:nRowNumAte ) + " " , /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
    oIntegraMais:StArrCamposCabec( ) // VarInfo( "aCabec", oIntegraMais:aCamposCabec )

    If lDupla
        If len(aTabAux) > 0
            For nCont := 1 to len(aTabAux)
                oIntegraMais:StArrContratos( aTabAux[nCont] )
            Next nCont 
        Else 
            oIntegraMais:StArr( ) //VarInfo( "aItens", oIntegraMais:aCamposItens )    
        EndIf 
    EndIf 

    If cTabCabec <> "CN9"
        oIntegraMais:QueryCb( )
    Else
        oIntegraMais:QueryCbContratos( )
    EndIf 

    While( oIntegraMais:cAliasQuery )->( !Eof( ) )

        FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/, "@@@@@@ FUCNTION IM_MD_02_ThreadAuxiliarMigracaoDados -> THREAD " + cValToChar( nThread ) + " ID( " + cIdThread + " ) processando RowNumber " + cvaltochar(( oIntegraMais:cAliasQuery )->RN) + " de " + cRowNumAte + " ", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
        aAuxAtf    := { }
        aCabec     := { }
        aItens     := { }
        cRowNumber := ( oIntegraMais:cAliasQuery )->RN

        for nX := 1 to oIntegraMais:nQtdCamposCabec
            aadd( aCabec, { oIntegraMais:aCamposCabec[nX], ( oIntegraMais:cAliasQuery )->&( oIntegraMais:aCamposCabec[nX] ) , Nil } )
        next nX

        aadd( aAuxAtf, {'CN9'} )

        aadd( aAuxAtf[len(aAuxAtf)], aCabec ) // VarInfo( "aCabec", aCabec )
        
        cTabAux := ""

        While( oIntegraMais:cAliasQuery )->( !Eof( ) ) .And. ( cRowNumber == ( oIntegraMais:cAliasQuery )->RN  )

            aLinha := { }
            If !lPassou
                for nY := 1 to oIntegraMais:nQtdCamposItens
                    If Substr(oIntegraMais:aCamposItens[nY],5) $ "P98REC/P98STA"
                        loop 
                    EndIf 

                    //Gambi provisoria
                    If ALIASCPO(oIntegraMais:aCamposItens[nY]) == "CNB"
                        loop
                    EndIf 

                    If cTabAux <> ALIASCPO(oIntegraMais:aCamposItens[nY])
                        If len(aLinha) > 0
                            aadd( aAuxAtf[len(aAuxAtf)], aLinha )
                        EndIf 
                        
                        cTabAux := ALIASCPO(oIntegraMais:aCamposItens[nY])
                        aadd( aAuxAtf, { cTabAux })
                        aLinha := {}

                    EndIf 

                    aadd( aLinha, { oIntegraMais:aCamposItens[nY], ( oIntegraMais:cAliasQuery )->&( oIntegraMais:aCamposItens[nY] ) , Nil } )

                next nY

                If len(aLinha) > 0
                    aadd( aAuxAtf[len(aAuxAtf)], aLinha )
                EndIf 
            EndIf 

            lPassou := .T.

            //Gambi provisoria
            aLinha := { }
            //cTabAux := ""
            for nY := 1 to oIntegraMais:nQtdCamposItens
                If Substr(oIntegraMais:aCamposItens[nY],5) $ "P98REC/P98STA"
                    loop 
                EndIf 

                //Gambi provisoria
                If ALIASCPO(oIntegraMais:aCamposItens[nY]) != "CNB"
                    loop
                EndIf 
                
                If cTabAux <> ALIASCPO(oIntegraMais:aCamposItens[nY]) .And. Ascan(aAuxAtf,{|x| x[1] == "CNB"}) == 0
                    If len(aLinha) > 0
                        aadd( aAuxAtf[len(aAuxAtf)], aLinha )
                    EndIf 
                    
                    cTabAux := ALIASCPO(oIntegraMais:aCamposItens[nY])
                    aadd( aAuxAtf, { cTabAux })
                    aLinha := {}

                EndIf 

                aadd( aLinha, { oIntegraMais:aCamposItens[nY], ( oIntegraMais:cAliasQuery )->&( oIntegraMais:aCamposItens[nY] ) , Nil } )

            next nY

            If len(aLinha) > 0
                aadd( aAuxAtf[len(aAuxAtf)], aLinha )
            EndIf 


            ( oIntegraMais:cAliasQuery )->( DbSkip( ) )

        EndDo 
    
        CCODIGO := cCodEmpP97
        nLen    := len( aAuxAtf )

        //For nX := 1 to nLen
            nPos98   := 0 //Ascan( aAuxAtf[nX], { |x| "P98REC" $ x[1] } )
            nRec1P98 := 0 //aAuxAtf[nX, nPos98, 2] 
            Begin Transaction
                cRet := U_TINCWHXF( nTipIncl, aAuxAtf, 'CN9', nRec1P98, , cUsrLog, , cCodPN2, 0, cQtdLog, /*cTextoLog, cLocArq,*/ oIntegraMais ) 
            End Transaction
        //Next nX 

        lPassou := .F.
        cTabAux := ""
       
    EndDo

    ( oIntegraMais:cAliasQuery )->( dbCloseArea( ) )

Return
