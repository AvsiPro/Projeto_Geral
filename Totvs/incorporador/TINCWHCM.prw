//#include 'tlpp-core.th'
#include 'protheus.ch'
#include "fileio.ch"


//using namespace TIIntegrador
//namespace ConferenciaMigracao

// IntegraMais - ConfereMigracao - Thread Principal
User Function TINCWHCM( cTab, cDocEmp, cFilDest )
    //Local nSeconds := Seconds( )

    Local oConfere := ConfereMigracao( ):New( cTab, cDocEmp, cFilDest )
    //oConfere:nQtdThreads   := 1 // Teste Mono
    oConfere:SetQtdRegistrosParaConferir( )

    If oConfere:nQtdRegParaProcessar > 0
        If oConfere:CsvThread( ) .and. oConfere:CsvDiverg( )

            //oConfere:nQtdRegParaProcessar := 10 // Teste Mono
            oConfere:CalculaRegistrosPorThread( )
            oConfere:StCpoJson( oConfere:cTabSX2, @oConfere:cCampos ) 
            //VarInfo("oConfere:cCampos", oConfere:cCampos )
            oConfere:ExecThreadsConferencia( ) // Multi

            //Teste Mono
            // ConferenciaMigracao.U_ThreadParalelaConfereMigracao(,;
            //             cEmpAnt,;
            //             oConfere:cFilDest,;
            //             oConfere:cTabSX2,;
            //             oConfere:cDocEmp,;
            //             oConfere:aLinhasDeAte[1,1],;
            //             oConfere:aLinhasDeAte[1,2],;
            //             1,;
            //             oConfere:cCampos;
            //         )

            oConfere:VerificaSeThreadsTerminaram( oConfere:cFuncaoConfere ) // Multi
            oConfere:ConcatenaLogsDasThreads( )
            
            //ConOut( "Tempo: " + AllTrim( Str( Seconds( ) - nSeconds ) ) )
        EndIf
    Else
        FWAlertWarning("Não há dados P98 da tabela " + oConfere:cTabSX2 , "Conferência de Migração" )
    EndIf

return

// IntegraMais - ConfereMigracao - Thread Auxiliar
User Function ThreadParalelaConfereMigracao( cEmpresa, cFilDest, cTabSX2, cDocEmp, nRowNumDe, nRowNumAte, nThread, cCampos )
    //Local cIdThread := cValToChar( ThreadId( ) )
    Local aDiverg   := { }
    Local lDiverg   := .F.
    Local cUniqKey  := ""
    Local nX, nG
    Local oConfere

    RpcSetType( 3 )
    RpcSetEnv( cEmpresa, cFilDest )

    oConfere := ConfereMigracao():NewConfereMigraAux( cTabSX2, cDocEmp, nRowNumDe, nRowNumAte, nThread, cCampos )
    //oConfere:GetCpFor( )
    oConfere:SeparaCamposPorCatergoria( )
    oConfere:CriaHashMapP97( )
    oConfere:ExecQryConferenciaP98( )

    DbSelectArea( "P98" )
    DbSelectArea( oConfere:cTabSX2 )
    ( oConfere:cTabSX2 )->( DbSetOrder(1) )

    While ( oConfere:cAliasQuery )->( !Eof( ) )
        //conout( "ThreadAuxiliarMigracaoDados -> THREAD " + cValToChar( nThread ) + " ID( " + cIdThread + ") processando row_numbers " + cvaltochar( ( oConfere:cAliasQuery )->RN ) + " de " + cvaltochar( oConfere:nRowNumAte ) + " " )
        cDados := ""
        P98->( dbGoto( ( oConfere:cAliasQuery )->RECNO ) )
        oJson:= JsonObject( ):new( )
        oJson:FromJson( P98->P98_BODY )

        cUniqKey := oJson["fields"]["indiceFinal"]

        If ( oConfere:cTabSX2 )->( DbSeek( cUniqKey ) )

            // Validar Cliente
            // cCNPJCLiOuForn := oJson["fields"][oConfere:cCamposCliOuForn]

            // If !Empty( ( oConfere:cAliasQuery )->A1A2_CGC )
            //     If ( oConfere:cAliasQuery )->A1A2_COD != ( oConfere:cAliasQuery )->CODCLI
            //         lDiverg := .T.
            //         aAdd( aDiverg, ( oConfere:cTabSX2 + ';' + cUniqKey + ';' + 'Codigo ' + ( oConfere:cAliasQuery )->A1A2_COD + ' da Tabela ' + oConfere:cTabCliOuFor + ' diferente do Codigo ' + ( oConfere:cAliasQuery )->CODCLI + ' da Tabela ' + oConfere:cTabSX2 + ';  ;  ;' + cValToChar( nRowNumDe ) ) )
            //     EndIf
            // Else
            //     lDiverg := .T.
            //     aAdd( aDiverg, ( oConfere:cTabSX2 + ';' + cUniqKey + ';' + 'CNPJ ' + cCNPJCLiOuForn + ' nao encontrado na Tabela ' + oConfere:cTabCliOuFor + ';' + cCNPJCLiOuForn +';' + &( oConfere:cTabSX2 + "->" + oConfere:cCamposCliOuForn ) +  ';' + cValToChar( nRowNumDe ) ) )
            // EndIf

            // Validação campos com DePara - P97
            for nx := 1 to oConfere:nQtdCamposComDePara

                oConfere:ComparaDados( oConfere:aCamposComDePara[nX] )

                If oConfere:xDadoTab <> oConfere:xDadoJson
                    
                    // Verifica se existe a chave no HashMap para validar DePara -> P97_CAMPO + P97_CONTOR
                    If oConfere:oHashP97:Get( oConfere:aCamposComDePara[nX,1] + oConfere:xDadoJson , @oConfere:xVal )

                        If oConfere:xValType == "C"
                            oConfere:xVal := AllTrim( oConfere:xVal )
                        ElseIf oConfere:xValType == "N"
                            oConfere:xVal := cvaltochar( oConfere:xVal )
                            oConfere:xVal := Alltrim( Transform( Val( oConfere:xVal ) , oConfere:aCamposComDePara[nX,3] ) )
                        ElseIf oConfere:xValType ==  "D"
                            oConfere:xVal := stod( oConfere:xVal ) // "20220714"
                            oConfere:xVal := dtoc( oConfere:xVal ) // "14/07/2022"
                        EndIf

                        If oConfere:xDadoTab <> oConfere:xVal
                            lDiverg := .T.
                            aAdd(aDiverg,(oConfere:cTabSX2+';'+cUniqKey+';'+oConfere:cCampo+';'+oConfere:xDadoJson+';'+oConfere:xDadoTab+';'+cValToChar(nRowNumDe) + ";" ))
                        EndIf
                        
                    Else
                        lDiverg := .T.
                        aAdd(aDiverg,(oConfere:cTabSX2+';'+cUniqKey+';'+oConfere:cCampo+';'+oConfere:xDadoJson+';'+oConfere:xDadoTab+';'+cValToChar(nRowNumDe) + ";" ))
                    EndIf
                EndIf

            next nX

            // Validação campos sem DePara
            for nx := 1 to oConfere:nQtdCamposSemDePara

                oConfere:ComparaDados( oConfere:aCamposSemDePara[nX] )

                If oConfere:xDadoTab <> oConfere:xDadoJson
                    lDiverg := .T.
                    aAdd(aDiverg,(oConfere:cTabSX2+';'+cUniqKey+';'+oConfere:cCampo+';'+oConfere:xDadoJson+';'+oConfere:xDadoTab+';'+cValToChar(nRowNumDe)  + ";" ))
                EndIf

            next nX

        Else
            lDiverg := .T.
            aAdd(aDiverg,(oConfere:cTabSX2+';'+cUniqKey+';;;;'+cValToChar(nRowNumDe) + ";Registro nao encontrado na Tabela" ))
        EndIf

        If lDiverg  // se existir divergencia incrementa o arquivo 
            For nG := 1 to Len(aDiverg)
                If nG < Len(aDiverg)
                    cDados += aDiverg[nG]+CRLF
                Else
                    cDados += aDiverg[nG]
                EndIf
            Next nG

            oConfere:SaveMsgLog( oConfere:cArqLogThread, cDados )

        // Else
        //     cDados := oConfere:cTabSX2+';'+cUniqKey+';;;;'+cValToChar(nRowNumDe)+';Sem divergencia - Campos do registro validados com sucesso'
        //     oConfere:SaveMsgLog( oConfere:cArqLogThread, cDados )
        EndIf

        FreeObj( oJson )
        oJson := NIL 

        aDiverg := { }
        cDados  := ''
        lDiverg := .F.

        nRowNumDe++
        ( oConfere:cAliasQuery )->( DbSkip( ) )
    EndDo

    ( oConfere:cAliasQuery )->( dbCloseArea( ) )
    oConfere:oHashP97:Clean( )
    FreeObj( oConfere )
    oConfere := NIL 

Return
