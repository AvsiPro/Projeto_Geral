#include 'protheus.ch'
//#include 'tlpp-core.th'
#include "fileio.ch"

//namespace TIIntegrador

/*/{Protheus.doc} TINCWHIM
Função de controle das execuções em multithread da rotina Integramais
@type user function
@author user
@since 12/05/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function TINCWHIM()

Return(.T.)

/*/{Protheus.doc} WHIntegraMais
Classe IntegraMais
@type class
@version 1.0 
@author Wesley Pinheiro
@since 20/02/2025
/*/
Class WHIntegraMais //from LongNameClass

    public Data cTabSX2              as Character
    public Data cDocEmp              as Character
    public Data nQtdRegParaProcessar as Numeric
    public Data nQtdThreads          as Numeric
    public Data cCampos              as Character
    public Data aCampos              as Array
    public Data aCamposContratos     as Array
    public Data nQtdCampos           as Numeric
    public Data aLinhasDeAte         as Array
    public Data nRowNumDe            as Numeric
    public Data nRowNumAte           as Numeric
    public Data nThread              as Numeric
    public Data cAliasQuery          as Character

    public Data cCodEmpP97           as Character
    public Data cTabSX2Cabec         as Character
    public Data cTabAuxItemContrato  as Character
    public Data cTabAuxCabec         as Character
    public Data cTabSX2Itens         as Character
    public Data cTabAuxItens         as Character

    public Data cCamposCabec         as Character
    public Data cCamposItens         as Character
    public Data cFil                 as Character
    public Data aCamposCabec         as Array
    public Data nQtdCamposCabec      as Numeric
    public Data aCamposItens         as Array
    public Data nQtdCamposItens      as Numeric
    public Data aEstrutura           as Array

    public Data cUsrLog              as Character
    public Data cCodPN2              as Character
    public Data cQtdLog              as Character
    public Data cTextoLog            as Character
    public Data cLocArq              as Character
    public Data lDupla               as logical
    public Data nTipIncl             as Numeric
    public Data cFilDest             as Character
    public Data oTabA1               as Object
    public Data oTabB1               as Object
    public Data oTabC1               as Object
    public Data oTabD1               as Object
    public Data oTabE1               as Object
    public Data oTabF1               as Object
    public Data oTabG1               as Object
    public Data lMonoThrd            as logical
    public Data oPanel               as Object
    public Data oBtnA                as Object
    public Data oBtnB                as Object
    public Data oBtnC                as Object

    // Construtores
    public Method New( cTabSX2, cDocEmp ) CONSTRUCTOR
    public Method NPrMG( cTabSX2Cabec, cTabSX2Itens, cCodEmpP97 , cUsrLog, cCodPN2, cQtdLog, /*cTextoLog, cLocArq,*/ lDupla, nTipIncl, cFilDest ) CONSTRUCTOR
    public Method NPrMGAux( cFil, cTabCabec, cTabItens, nRowDe, nRowAte, nThread, cCmpsCabec, cCmpsItens, cCodEmpP97,cUsrLog, cCodPN2, cQtdLog, /*cTextoLog, cLocArq,*/ lDupla, nTipIncl, cFilDest ) CONSTRUCTOR

    // Set e Get
    public Method StCpoJson( cTabSX2, cCampos )
    public Method GtCpoJson( )
    public Method StCpo( )
    public Method StNomTabAuxCabec( )
    public Method GtTbAI( )
    public Method GtTbAIContratos( )
    public Method GtNomTabAux( cTabSX2 )
    public Method SetCodEmpP97( )
    public Method SetQtdRegExecProcessar( )
    public Method StCpoCabecalho( )
    public Method StCpoItens( )
    public Method StCpoArray( cCampos, nQtdCampos, aCampos, cTabSX2 )
    public Method StArrCamposCabec( )
    public Method StArr( ) 
    public Method StArrContratos( )

    // Métodos Thread
    public Method CalculaRegistrosPorThread(lMonoThrd)
	public Method VerificaSeThreadsTerminaram( )
    public Method ThreadsProcessaMigracao( oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,lMonoThrd,oPanel,oBtnA,oBtnB,oBtnC,oIntegraMais,cTimFProc )

    // Auxiliares Processo
    public Method ExecQryPaginacaoP98( )
    public Method EstructTemp( nQtdCampos, aCampos, cTabTemp )
    public Method QueryCb( )
    public Method QueryCbContratos( )
    public Method GtCpoX2Unico( cTabSX2, cSimbolo ) // "," para separar ou "||" para concatenar 
    public Method GetX9Relacionamento( )
    public Method EstructSX3Tabela( aEstrutura, cTabTemp )

EndClass

/*/{Protheus.doc} WHIntegraMais::New
Método Construtor objeto WHIntegraMais a ser utilizado na Thread Principal
@type method
@version 1.0
@author Wesley Pinheiro
@since 20/02/2025
@param cTabSX2, character, alias da Tabela a ser validada
@param cDocEmp, character, documento da filial para realizar filtro dos registros P98
/*/
Method New( cTabSX2, cDocEmp ) Class WHIntegraMais
    ::cTabSX2     := cTabSX2
    ::cDocEmp       := cDocEmp
    ::nQtdThreads   := SuperGetMV("TI_WHNTHRD",,4)
    ::aLinhasDeAte  := { }

Return


Method NPrMG( cTabSX2Cabec, cTabSX2Itens, cCodEmpP97 , cUsrLog, cCodPN2, cQtdLog, /*cTextoLog, cLocArq,*/ lDupla, nTipIncl, cFilDest ) Class WHIntegraMais
    ::cTabSX2Cabec  := cTabSX2Cabec
    ::cTabSX2Itens  := cTabSX2Itens
    ::aLinhasDeAte  := { }
    ::nQtdThreads   := SuperGetMV( "TI_WHNTHRD",,4 )
    ::cCodEmpP97    := cCodEmpP97
    ::cUsrLog       := cUsrLog
    ::cCodPN2       := cCodPN2
    ::cQtdLog       := cQtdLog
    // ::cTextoLog     := cTextoLog
    // ::cLocArq       := cLocArq
    ::lDupla        := lDupla
    ::nTipIncl      := nTipIncl
    ::cFilDest      := cFilDest
    ::cTabAuxItemContrato := ''

Return


Method NPrMGAux( cTabCabec, cTabItens, nRowDe, nRowAte, nThread, cCodEmpP97,cUsrLog, cCodPN2, cQtdLog, /*cTextoLog, cLocArq,*/ lDupla, nTipIncl, cFilDest ) Class WHIntegraMais
    ::cTabSX2Cabec := cTabCabec
    ::cTabSX2Itens := cTabItens
    ::nRowNumDe    := nRowDe
    ::nRowNumAte   := nRowAte
    ::nThread      := nThread
    ::cCodEmpP97   := cCodEmpP97
    ::aCamposCabec := { }
    ::aCamposItens := { }
    ::aEstrutura   := { }

    ::cUsrLog      := cUsrLog
    ::cCodPN2      := cCodPN2
    ::cQtdLog      := cQtdLog
    // ::cTextoLog    := cTextoLog
    // ::cLocArq      := cLocArq
    ::lDupla       := lDupla
    ::nTipIncl     := nTipIncl
    ::cFilDest     := cFilDest
    ::cTabAuxItemContrato := ''

Return

Method StNomTabAuxCabec( ) Class WHIntegraMais
    ::cTabAuxCabec := self:GtNomTabAux( ::cTabSX2Cabec )
Return

Method GtTbAI( ) Class WHIntegraMais
    ::cTabAuxItens := self:GtNomTabAux( ::cTabSX2Itens )
Return

Method GtTbAIContratos( cTabAux ) Class WHIntegraMais
    ::cTabAuxItemContrato := self:GtNomTabAux( cTabAux )
Return

Method GtNomTabAux( cTabSX2 ) Class WHIntegraMais
Return IIf( cEmpAnt == "00", "BR", IIF( cEmpAnt == "60", "DM", "MI" ) ) + "P98" + cTabSX2 + ::cCodEmpP97

Method SetCodEmpP97( ) Class WHIntegraMais

    Local cQuery
    Local cAlsQry := GetNextAlias( )

    cQuery := " SELECT P97_CODIGO "
    cQuery += " FROM " + RetSqlName( "P97" ) + " p "
    cQuery += " WHERE P97_CNPJ = '" + ::cDocEmp + "' "
    cQuery += " FETCH FIRST 1 ROW ONLY "
    
    PlsQuery( cQuery, cAlsQry )

    While ( cAlsQry )->( !Eof( ) )
        ::cCodEmpP97 := ( cAlsQry )->P97_CODIGO
        ( cAlsQry )->( DbSkip( ) )
    EndDo

    ( cAlsQry )->( dbCloseArea( ) )

Return


Method StCpoCabecalho( ) Class WHIntegraMais
    self:StCpoJson( ::cTabSX2Cabec, @::cCamposCabec )
Return

Method StCpoItens( ) Class WHIntegraMais
    self:StCpoJson( ::cTabSX2Itens, @::cCamposItens )
Return


Method StCpoJson( cTabSX2, cCampos ) Class WHIntegraMais

    Local cFields := ""
    Local aAux    := { }
    Local cQuery  := ""
    Local cAlsQry := GetNextAlias( )
    Local nX, nRecno, nQtdCampos

    cQuery := " SELECT R_E_C_N_O_ RECNO   "
    cQuery += " FROM " + RetSqlName( "P98" ) + " p "
    cQuery += " where P98_TABELA = '" + cTabSX2 + "' "
    cQuery += " and P98_CALLBA = '" + ::cDocEmp + "' "
    cQuery += " and p.D_E_L_E_T_ = ' ' "
    cQuery += " FETCH FIRST 1 ROW ONLY "

    PlsQuery( cQuery, cAlsQry )

    While ( cAlsQry )->( !Eof( ) )
        nRecno := ( cAlsQry )->RECNO
        ( cAlsQry )->( DbSkip( ) )
    EndDo

    ( cAlsQry )->( dbCloseArea( ) )

    DbSelectArea( "P98" )
    P98->( dbGoto( nRecno ) )
    oJson := JsonObject( ):new( )
    oJson:FromJson( P98->P98_BODY )
    aAux := oJson["fields"]:GetNames( )
    nQtdCampos := Len( aAux )

    DbSelectArea( cTabSX2 ) // "SC5"
    for nX:= 1 to nQtdCampos
        If FieldPos( aAux[nX] ) > 0
            cFields += aAux[nX] + ";"
        EndIf
    next nX

    cCampos := SUBSTR( cFields, 1, Len( cFields ) -1 )

Return

Method EstructTemp( nQtdCampos, aCampos, cTabTemp ) Class WHIntegraMais

    Local cQuery
    Local aArea := GetArea( )

    cQuery := " SELECT COLUMN_NAME"
    cQuery += " FROM USER_TAB_COLUMNS"
    cQuery += " WHERE TABLE_NAME = '" + cTabTemp + "'"

    If Select( "QRTTBL" ) > 0
        ( "QRTTBL" )->( dbCloseArea( ) )
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QRTTBL", .T., .T. )
    DbSelectArea( "QRTTBL" )

    While !EOF( )
        Aadd( aCampos, Alltrim( QRTTBL->COLUMN_NAME ) )
        Dbskip( )
    Enddo 

    nQtdCampos := Len( aCampos )

    RestArea( aArea )

Return

Method EstructSX3Tabela( aEstrutura, cTabTemp ) Class WHIntegraMais
    Local aArea := GetArea()
    Local aAxX3 := FWSX3Util():GetListFieldsStruct( cTabTemp , .F. )

    aEval(aAxX3,{|x| aadd(x,.T.)})

    Aadd(aEstrutura,aAxX3)
    Aadd(aEstrutura[len(aEstrutura)], cTabTemp)

    RestArea(aArea)
Return

Method GtCpoJson( ) Class WHIntegraMais
Return ::cCampos

Method StCpo( ) Class WHIntegraMais
    ::aCampos    := StrTokArr( ::cCampos, ";" )
    ::nQtdCampos := Len( ::aCampos )
Return


Method StArrCamposCabec( ) Class WHIntegraMais
    ::cTabAuxCabec := self:GtNomTabAux( ::cTabSX2Cabec )
    self:EstructTemp( @::nQtdCamposCabec, @::aCamposCabec, ::cTabAuxCabec )
    self:EstructSX3Tabela( @::aEstrutura, ::cTabSX2Cabec ) 
Return

Method StArr( ) Class WHIntegraMais
    ::cTabAuxItens := self:GtNomTabAux( ::cTabSX2Itens )
    self:EstructTemp( @::nQtdCamposItens, @::aCamposItens, ::cTabAuxItens )
    self:EstructSX3Tabela( @::aEstrutura, ::cTabSX2Itens )
Return

Method StArrContratos( cTabelaAux ) Class WHIntegraMais
    ::cTabAuxItens := self:GtNomTabAux( cTabelaAux )
    self:EstructTemp( @::nQtdCamposItens, @::aCamposItens, ::cTabAuxItens )
    self:EstructSX3Tabela( @::aEstrutura, cTabelaAux )
Return


//self:StCpoArray( ::cCamposCabec, @::nQtdCamposCabec, @::aCamposCabec, ::cTabSX2Cabec )
//self:StCpoArray( ::cCamposItens, @::nQtdCamposItens, @::aCamposItens, ::cTabSX2Itens )
Method StCpoArray( cCampos, nQtdCampos, aCampos, cTabSX2 )  Class WHIntegraMais

    Local aAux := { }
    aCampos    := StrTokArr( cCampos, ";" )
    nQtdCampos := Len( aCampos )

    aAux := { }
    aEval( aCampos, { |x| aadd( aAux, { x } ) } )
    aAux := FWVetByDic( aAux, cTabSX2 ) // Ordena array de acordo com a SX3

    aCampos := { }
    //aEval( aAux , { |x| aadd( aCampos, x[1] ) } )
    aEval( aAux , { |x| aadd( aCampos, { x[1], GetSX3Cache(x[1], "X3_TIPO")} ) } )
    /*
    aCampos[1] -> ARRAY (    2) [...]
        aCampos[1][1] -> C (    9) [C6_FILIAL]
        aCampos[1][2] -> C (    1) [C]
    */

Return


Method CalculaRegistrosPorThread(lMonoThrd ) Class WHIntegraMais

    Local n1QtdRegsPorThread := 0
    Local n2QtdAux           := 0
    Local n3QtdRegSobraram   := 0
    Local nLinIni            := 1
    Local nLinFim            := 0
    Local nY                 := 1
	Local cMsg
    Local cMsg2              := ""
    Local aMessage
	// Default nQuebra          := 1000
	Default lShowLog         := .T.
    Default lMonoThrd        := .F.

    // If ::nQtdRegParaProcessar < ::nQtdThreads 
    //     ::nQtdThreads := 1
    // EndIf
			
    // If ::nQtdRegParaProcessar >= nQuebra
    If !lMonoThrd
        n1QtdRegsPorThread := NoRound( ::nQtdRegParaProcessar / ::nQtdThreads, 0 )
        n2QtdAux := n1QtdRegsPorThread * ::nQtdThreads
        n3QtdRegSobraram := ::nQtdRegParaProcessar - n2QtdAux
    Else
        ::nQtdThreads := 1
        n1QtdRegsPorThread := ::nQtdRegParaProcessar
    EndIF

    If n1QtdRegsPorThread == 0
        ::nQtdThreads := 1
    EndIf

	If lShowLog
        aMessage := {}
		cMsg     := "--- Registros: " + cValToChar( ::nQtdRegParaProcessar )
        aadd( aMessage, {"",cMsg} )
		
		if( n3QtdRegSobraram > 0 )
			cMsg := "--- " + cvaltochar( n3QtdRegSobraram ) + " threads com " + cValToChar( n1QtdRegsPorThread + 1 ) + " registros - " + " Threads: " + cValToChar( nY ) + " - " + cValToChar( n3QtdRegSobraram )
            aadd( aMessage, { "", cMsg } )
			cMsg := "--- " + cvaltochar( ::nQtdThreads - n3QtdRegSobraram ) + " threads com " + cValToChar( n1QtdRegsPorThread ) + " registros - " + " Threads: " + cValToChar( n3QtdRegSobraram + 1 ) + " - " + cValToChar( ::nQtdThreads )
		    aadd( aMessage, { "", cMsg } )
		Else
			cMsg := "--- " + cvaltochar( ::nQtdThreads ) + " threads com " + cValToChar( n1QtdRegsPorThread ) + " registros - " + " Threads: " + cValToChar( n3QtdRegSobraram + 1 ) + " - " + cValToChar( ::nQtdThreads )
            aadd( aMessage, { "", cMsg } )
		EndIf
	EndIf

    for nY := 1 to ::nQtdThreads

        If nY <= n3QtdRegSobraram
            nLinFim += ( n1QtdRegsPorThread + 1 )
        Else
            nLinFim += n1QtdRegsPorThread
        EndIF

        aadd( ::aLinhasDeAte, {nLinIni, nLinFim })
        
		If lShowLog
            cMsg := "--- Thread "  + cValToChar( nY ) + " ini: " + cValToChar( ::aLinhasDeAte[nY,1] ) + " fim: " + cValToChar( ::aLinhasDeAte[nY,2] )
            aadd( aMessage, { "", cMsg } )
            cMsg2 += chr( 10 ) + chr( 13 ) + cMsg
		EndIf
		
		nLinIni :=  nLinFim + 1

    next nY

    IIf( lShowLog, FWLogMsg( "INFO", /*cTransactionId*/, "CalculaRegistrosPorThread", /*cCategory*/, /*cStep*/, /*cMsgId*/,"" , /*nMensure*/, /*nElapseTime*/, aMessage ), "" )
    FWMonitorMsg( cMsg2 )
Return

Method SetQtdRegExecProcessar( ) Class WHIntegraMais

    Local cQuery
    Local cAlsQry := GetNextAlias( )

    cQuery := " SELECT COUNT(*) QTD_REG "
    cQuery += " FROM " + ::cTabAuxCabec + " p "
    cQuery += " WHERE " + PrefixoCPO( ::cTabSX2Cabec )  + "_P98STA = 0 "

    PlsQuery( cQuery, cAlsQry )

    While ( cAlsQry )->( !Eof( ) )
        ::nQtdRegParaProcessar := ( cAlsQry )->QTD_REG
        ( cAlsQry )->( DbSkip( ) )
    EndDo

    ( cAlsQry )->( dbCloseArea( ) )

Return


Method VerificaSeThreadsTerminaram( cFunction ) Class WHIntegraMais
	
    Local lThreadInExec := .T.
	Local aInfoThreads
    cFunction := Upper( cFunction )

	sleep( 10000 )

    While lThreadInExec
        aInfoThreads := GetUserInfoArray( )
        
        IF asCan( aInfoThreads, {|x| x[5] == cFunction} ) == 0
            lThreadInExec := .F.
        Else
			aInfoThreads := { }
            FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/, "THREAD PRINCIPAL MONITORANDO -------- Threads Auxiliares ( " + cFunction + " ) em execucao!!!", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

            sleep( 1000 )
        EndIf
    Enddo

    FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/, "THREAD PRINCIPAL FINALIZANDO MONITORAMENTO: Threads executadas com sucesso!!!", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

Return


Method ExecQryPaginacaoP98( ) Class WHIntegraMais

    Local cQuery

	cQuery := " SELECT RECNO "
    cQuery += " FROM ( "
    cQuery += "     SELECT P.R_E_C_N_O_ as RECNO "
    cQuery += "          ,ROW_NUMBER() OVER ( "
    cQuery += "             ORDER BY P98_FILIAL,P98_COD "
    cQuery += "             ) AS RN "
    cQuery += "     FROM " + RetSqlName( "P98" ) + " P "
    cQuery += "     WHERE P98_TABELA = '" + ::cTabSX2 + "' "
    cQuery += "     AND P98_CALLBA = '" + ::cDocEmp + "' "
    cQuery += "     AND P.D_E_L_E_T_ = ' ' "
    cQuery += "     ) "
    cQuery += " WHERE RN BETWEEN " + cValToChar( ::nRowNumDe ) + " "
    cQuery += "         AND " + cValToChar( ::nRowNumAte ) + " "

    PlsQuery( cQuery, ::cAliasQuery )

Return


Method ThreadsProcessaMigracao(oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,lMonoThrd,oPanel,oBtnA,oBtnB,oBtnC,oIntegraMais,cTimFProc) Class WHIntegraMais

    Local nY 
    Local nSeconds  := Seconds( )
    Local cTimeInic := Time()
    Local cRun      := 'EXECUTANDO'
    Local cFinish   := 'FINALIZADO'
    Local cTable    := Self:cTabSX2Cabec

    Default lMonoThrd := .F.

    cFilAnt := oIntegraMais:cFildest
    cFil := cFilAnt

    // Atualiza o Status do Wizard
    fAtuPainel(oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,oPanel,oBtnA,oBtnB,oBtnC,cRun)

    // Abre a Tela de Monitoramento das Threads
            // (cTimeInic,cTable,nQtdReg                  ,aLinhas          ,nQtdThreads  )
    U_LogWindow(cTimeInic,cTable,Self:nQtdRegParaProcessar,Self:aLinhasDeAte,::nQtdThreads)

    // Calcula a quebra por thread
    Self:CalculaRegistrosPorThread(lMonoThrd)

    If !lMonoThrd
        If self:cTabsx2cabec <> "CN9"
            For nY:=1 to ::nQtdThreads

                // PutGlbVars( "_INTEGRAMAIS" + cTable + cValToChar( nY ), aLinhas[ny,1] )

                StartJob(   "U_IM_MD_02_ThreadAuxiliarMigracaoDados",;
                            GetEnvServer(),;
                            .F.,;
                            cEmpAnt,;
                            cFilAnt,;
                            ::cTabSX2Cabec,;
                            ::cTabSX2Itens,;
                            ::aLinhasDeAte[nY,1],;
                            ::aLinhasDeAte[nY,2],;
                            nY,;
                            ::cCodEmpP97,;
                            ::cUsrLog,;
                            ::cCodPN2,;
                            ::cQtdLog,;
                            ::lDupla,;
                            ::nTipIncl,;
                            ::cFilDest,;
                        )
            Next nY
        Else 
            For nY:=1 to ::nQtdThreads

                // PutGlbVars( "_INTEGRAMAIS" + cTable + cValToChar( nY ), aLinhas[ny,1] )

                StartJob(   "U__MigCtrHMT",;
                            GetEnvServer(),;
                            .F.,;
                            cEmpAnt,;
                            cFilAnt,;
                            ::cTabSX2Cabec,;
                            ::cTabSX2Itens,;
                            ::aLinhasDeAte[nY,1],;
                            ::aLinhasDeAte[nY,2],;
                            nY,;
                            ::cCodEmpP97,;
                            ::cUsrLog,;
                            ::cCodPN2,;
                            ::cQtdLog,;
                            ::lDupla,;
                            ::nTipIncl,;
                            ::cFilDest,;
                        )
            Next nY
        EndIf 
    Else
        nY := 1
        If self:cTabsx2cabec <> "CN9"
            For nY:=1 to 1 // oIntegraMais:nQtdThreads

                // PutGlbVars( "_INTEGRAMAIS" + cTable + cValToChar( nY ), aLinhas[ny,1] )

                U_IM_MD_02_ThreadAuxiliarMigracaoDados(;
                    cEmpAnt,;
                    cFilAnt,;
                    ::cTabSX2Cabec,;
                    ::cTabSX2Itens,;
                    ::aLinhasDeAte[nY,1],;
                    ::aLinhasDeAte[nY,2],;
                    nY,;
                    ::cCodEmpP97,;
                    ::cUsrLog,;
                    ::cCodPN2,;
                    ::cQtdLog,;
                    ::lDupla,;
                    ::nTipIncl,;
                    ::cFilDest,;
                )
            Next nY
        Else 
            For nY:=1 to 1 // oIntegraMais:nQtdThreads

                // PutGlbVars( "_INTEGRAMAIS" + cTable + cValToChar( nY ), aLinhas[nY,1] )

                U__MigCtrHMT(;
                    cEmpAnt,;
                    cFilAnt,;
                    ::cTabSX2Cabec,;
                    ::cTabSX2Itens,;
                    ::aLinhasDeAte[nY,1],;
                    ::aLinhasDeAte[nY,2],;
                    nY,;
                    ::cCodEmpP97,;
                    ::cUsrLog,;
                    ::cCodPN2,;
                    ::cQtdLog,;
                    ::lDupla,;
                    ::nTipIncl,;
                    ::cFilDest,;
                )
            Next nY
        EndIf 
    EndIf

    self:VerificaSeThreadsTerminaram( "U_IM_MD_02_ThreadAuxiliarMigracaoDados" )
    FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Tempo: " + AllTrim(Str(Seconds() - nSeconds)), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

    //Grava a hora final do Processamento
    cTimFProc := Time() 
    // Atualiza o Status do Wizard
    fAtuPainel(oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,oPanel,oBtnA,oBtnB,oBtnC,cFinish)

Return .T.



Method QueryCb( ) class WHIntegraMais

    Local cQuery         := ""
    Local cTabSemX9      := 'SE5/PHH'
    Local aIndices       := FWSIXUtil():GetAliasIndexes( ::cTabSX2Cabec  )
    Local aAuxIndice     := If(::cTabSX2Cabec=="PHH",aIndices[6],If(::cTabSX2Cabec=="SE5",aIndices[7],{}))
    Local cIndice        := ""
    Local cCampoFilCabec := PrefixoCPO( ::cTabSX2Cabec ) + "_FILIAL"
    Local cCampoP98STA   := PrefixoCPO( ::cTabSX2Cabec ) + "_P98STA"
    Local cCampoFilItem  := If(::lDupla,PrefixoCPO( ::cTabSX2Itens ) + "_FILIAL","")
    Local cOrdByCabec    := self:GtCpoX2Unico( ::cTabSX2Cabec ) 
    Local cOrdByItens    := If(::lDupla .And. !::cTabSX2Cabec $ cTabSemX9,self:GtCpoX2Unico( ::cTabSX2Itens ),"")
    Local cJoin          := If(::lDupla .And. !::cTabSX2Cabec $ cTabSemX9,self:GetX9Relacionamento( ),"")

    //Gean - revisar estes pontos que mexemos para o order by funcionar na SE5
    If ::cTabSX2Cabec $ cTabSemX9
        Aeval(aAuxIndice,{|x| cIndice += x + ","})
        cOrdByCabec     := strtran(alltrim(cIndice),",E5_SEQ,","")
    EndIf 

    //GEAN ARRUMAR AQUI PARA VER A MELHOR FORMA
    cOrdByCabec := strtran(cOrdByCabec,"DTOS","")
    cOrdByItens := strtran(cOrdByItens,"DTOS","")

    //Priorizar sempre o tipo NF quando forem titulos SE1 e SE2
    If ::cTabSX2Cabec == "SE1"
        cOrdByCabec:= strtran(cOrdByCabec,",E1_TIPO",",CASE WHEN E1_TIPO = 'NF' THEN 0 ELSE 1 END,E1_TIPO")
    EndIf 

    If ::cTabSX2Cabec == "CT2"
        cOrdByCabec := "CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC"
    EndIf 

    ::cAliasQuery   := GetNextAlias( )
    
    cQuery := " SELECT * "
    cQuery += " FROM ( "
    cQuery += "     SELECT DENSE_RANK() OVER ( "
    cQuery += "             ORDER BY " + cOrdByCabec + " "                      // ORDER BY C5_FILIAL, C5_NUM
    cQuery += "             ) AS RN "
    cQuery += "         ,CABEC.* "

    
    If ::lDupla
        cQuery += "         ,ITENS.* "
    EndIf 
    
    cQuery += "     FROM " + ::cTabAuxCabec + " CABEC "                         // BRP98SC5000012
    
    If ::lDupla
        cQuery += "     JOIN " + ::cTabAuxItens + " ITENS "                         // BRP98SC6000012
        cQuery += "         ON " + cCampoFilCabec + " = " + cCampoFilItem + " AND " // C5_FILIAL = C6_FILIAL
        cQuery += cJoin                                                             // AND C5_NUM = C6_NUM
    EndIf

    cQuery += "     WHERE " + cCampoFilCabec + " = '" +  If(FWMODEACCESS(::cTabSX2Cabec , 3)=="E",::cFilDest, xFilial(::cTabSX2Cabec )) + "' "           // C5_FILIAL = '05401000100'   cFilAnt  wesley rever aqui com relação a campos de filial compartilhada
    
    cQuery += "         AND " + cCampoP98STA + " = '0' "

    If ::lDupla
        cQuery += "     ORDER BY " + cOrdByItens + " "                              // C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO
    Else 
        cQuery += "     ORDER BY " + cOrdByCabec + " "        
    EndIf 

    cQuery += "     ) "
    cQuery += " WHERE RN BETWEEN " + cValToChar( ::nRowNumDe ) + " "
    cQuery += "         AND " + cvaltochar( ::nRowNumAte )
    
    FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Thread " + cvaltochar( ::nThread ) + " QUERY ############################" + cQuery , /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

    PlsQuery( cQuery, ::cAliasQuery )

Return

Method QueryCbContratos( ) class WHIntegraMais

    Local cQuery         := ""
    Local aIndices       := {}
    //Local aAuxIndice     := {} 
    //Local cIndice        := ""
    Local cCampoFilCabec := PrefixoCPO( ::cTabSX2Cabec ) + "_FILIAL"
    Local cCampoP98STA   := PrefixoCPO( ::cTabSX2Cabec ) + "_P98STA"
    Local cCampoFilItem  := '' //If(::lDupla,PrefixoCPO( ::cTabSX2Itens ) + "_FILIAL","")
    Local cOrdByCabec    := self:GtCpoX2Unico( ::cTabSX2Cabec ) 
    Local cOrdByItens    := '' //self:GtCpoX2Unico( ::cTabSX2Itens )
    Local cJoin          := '' //self:GetX9Relacionamento( )
    Local nCont          := 0
    Local nCont2         := 0
    Local cItens         := ::cTabSX2Itens
    Local aTabAux        := separa(alltrim(cItens),"/")
    Local aRetRelations  := {}
    Local aCposJoin      := {}
    
    ::cAliasQuery   := GetNextAlias( )
    
    cQuery := " SELECT * "
    cQuery += " FROM ( "
    cQuery += "     SELECT DENSE_RANK() OVER ( "
    cQuery += "             ORDER BY " + cOrdByCabec + " "                      // ORDER BY C5_FILIAL, C5_NUM
    cQuery += "             ) AS RN "
    cQuery += "         ,CABEC.* "

    
    If ::lDupla
        For nCont := 1 to len(aTabAux)
            cQuery += ",ITENS"+cvaltochar(nCont)+".* "
        Next nCont 
    EndIf 
    
    cQuery += "     FROM " + ::cTabAuxCabec + " CABEC "                         // BRP98SC5000012
    
    If ::lDupla
        //Gean - revisar estes pontos que mexemos para o order by e join
        For nCont := 1 to len(aTabAux)
            aIndices       := FWSIXUtil():GetAliasIndexes( aTabAux[nCont]  )
            //aAuxIndice := If(aTabAux[nCont]=="PHH",aIndices[6], separa(Alltrim(self:GtCpoX2Unico( aTabAux[nCont] )),",") )

            cCampoFilItem :=  PrefixoCPO( aTabAux[nCont] ) + "_FILIAL"

            //Aeval(aAuxIndice,{|x| cIndice += x + ","})
            //cOrdByItens     := substr(cIndice,1,len(cIndice)-1)

            //cTabAuxItemContrato := 
            self:GtTbAIContratos( aTabAux[nCont] )
            
            aRetRelations := {}
            aCposJoin     := {}

            FWSX9Util():SearchX9Paths( ::cTabSX2Cabec, aTabAux[nCont], @aRetRelations ) //self:GetX9Relacionamento( )

            If len(aRetRelations) > 0
                cJoin := ""
                If "+" $ aRetRelations[1,2] 
                    Aadd(aCposJoin,separa(aRetRelations[1,2],'+'))
                    Aadd(aCposJoin,separa(aRetRelations[1,4],'+'))
                    cBarra := ""
                    For nCont2 := 1 to len(aCposJoin[1])
                        cJoin += cBarra +  alltrim(aCposJoin[1,nCont2]) + " = " + alltrim(aCposJoin[2,nCont2])
                        cBarra := " AND "
                    Next nCont2
                Else 
                    cJoin  := Alltrim(aRetRelations[1,2]) + " = " + Alltrim(aRetRelations[1,4])
                EndIF 

                cQuery += "     JOIN " + ::cTabAuxItemContrato + " ITENS"+cvaltochar(nCont)+" "
                cQuery += "         ON " + cCampoFilCabec + " = " + cCampoFilItem + " AND " // C5_FILIAL = C6_FILIAL
                cQuery += cJoin 
            EndIf 

             
        Next nCont  

        // cQuery += "     JOIN " + ::cTabAuxItens + " ITENS "                         // BRP98SC6000012
        // cQuery += "         ON " + cCampoFilCabec + " = " + cCampoFilItem + " AND " // C5_FILIAL = C6_FILIAL
        // cQuery += cJoin                                                             // AND C5_NUM = C6_NUM
    EndIf

    cQuery += "     WHERE " + cCampoFilCabec + " = '" +  If(FWMODEACCESS(::cTabSX2Cabec , 3)=="E",::cFilDest, xFilial(::cTabSX2Cabec )) + "' "           // C5_FILIAL = '05401000100'   cFilAnt  wesley rever aqui com relação a campos de filial compartilhada
    
    cQuery += "         AND " + cCampoP98STA + " = '0' "
    //Gean, revisar o order by
    If ::lDupla
        cOrdByItens := "CNA_FILIAL,CNA_CONTRA,CNB_FILIAL,CNB_CONTRA,CNB_ITEM,CNC_FILIAL,CNC_NUMERO,CNC_CLIENT,CNC_LOJACL"
        cQuery += "     ORDER BY " + cOrdByItens + " "                              
    Else 
        cQuery += "     ORDER BY " + cOrdByCabec + " "        
    EndIf 

    cQuery += "     ) "
    cQuery += " WHERE RN BETWEEN "+ cValToChar( ::nRowNumDe ) + " "
    cQuery += "         AND " + cvaltochar( ::nRowNumAte )
    
    FWLogMsg("INFO", /*cTransactionId*/, "WHINTEGRAMAIS", /*cCategory*/, /*cStep*/, /*cMsgId*/, "Thread " + cvaltochar( ::nThread ) + " QUERY ############################" + cQuery, /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

    PlsQuery( cQuery, ::cAliasQuery )

    /*
        SELECT *              
            FROM   (              
                SELECT DENSE_RANK() OVER (              
                ORDER BY  CN9_FILIAL,CN9_NUMERO ) AS RN,CABEC.*,ITENS1.*,ITENS2.*,ITENS3.*                            
                FROM   BRP98CN9000012 CABEC              
                JOIN BRP98CNA000012 ITENS1 ON CN9_FILIAL = CNA_FILIAL AND CN9_NUMERO = CNA_CONTRA           
                JOIN BRP98CNB000012 ITENS2 ON CN9_FILIAL = CNB_FILIAL AND CN9_NUMERO = CNB_CONTRA          
                JOIN BRP98CNC000012 ITENS3 ON CN9_FILIAL = CNC_FILIAL AND CN9_NUMERO = CNC_NUMERO          
                WHERE  CN9_FILIAL = '           ' AND CN9_P98STA = '0'              
            ORDER BY  CNA_FILIAL,CNA_CONTRA,CNB_FILIAL,CNB_CONTRA,CNB_ITEM,CNC_FILIAL,CNC_NUMERO,CNC_CLIENT,CNC_LOJACL )              
            WHERE  RN BETWEEN 1 AND 1207              


    */

Return


Method GtCpoX2Unico( cTabSX2, cSimbolo ) class WHIntegraMais
	Default cSimbolo := ","
Return StrTran( GetSx2Unico( cTabSX2 ), "+", cSimbolo )

Method GetX9Relacionamento(  ) class WHIntegraMais

    Local nQtd, nX, nPosCabec, nPosItem
    Local cQuery, cJoin
    Local aCabec, aItens
    Local lTemTodosOsCampos := .T.
    Local cAlsQry := GetNextAlias( )

    cQuery := " SELECT X9_DOM AS ORIGEM "
    cQuery += "     ,X9_CDOM AS DESTINO "
    cQuery += "     ,X9_EXPDOM AS TAB_ORIGEM "
    cQuery += "     ,X9_EXPCDOM AS TAB_DESTINO "
    cQuery += " FROM SX9" + cEmpAnt + "0" // RetSQLName( "SX9" ) não funcionou -> revisar
    cQuery += " WHERE D_E_L_E_T_ = ' ' "
    cQuery += " AND X9_DOM = '" + ::cTabSX2Cabec + "' and X9_CDOM = '" + ::cTabSX2Itens + "' "

    PlsQuery( cQuery, cAlsQry )
    Count To nQtd

    /*
        Algumas tabelas tem mais de um relacionamento ( nQtd > 1 )
        Nesses casos é necessário confirmar se os campos da chave SX9 existem na tabela auxiliar
        para pegar o relacionamento correto

        Ex: Tabela SC5 e SC6 tem 2 relacionamentos:
        TAB_ORIGEM | TAB_DESTINO
        C5_NUM     | C6_PEDVINC
        C5_NUM     | C6_NUM

        Se o campo C6_PEDVINC não existir na tabela auxiliar, ocorrerá erro de missing expression na execução da query
    */

    If nQtd == 1

        aCabec := StrTokArr( AllTrim( ( cAlsQry )->TAB_ORIGEM  ), "+" )
        aItens := StrTokArr( AllTrim( ( cAlsQry )->TAB_DESTINO ), "+" )

        VarInfo( "aCabec", aCabec )
        VarInfo( "aItens", aItens )

        nQtd := Len( aCabec )
        cJoin := ""

        for nX := 1 to nQtd
            cJoin += aCabec[nX] + " = " + aItens[nX] + " AND "
        next nX

    Else
        While ( cAlsQry )->( !Eof( ) )

            aCabec := StrTokArr( AllTrim( ( cAlsQry )->TAB_ORIGEM ), "+" )
            aItens := StrTokArr( AllTrim( ( cAlsQry )->TAB_DESTINO ), "+" )
            lTemTodosOsCampos := .T.

            VarInfo( "aCamposCabec", ::aCamposCabec )
            VarInfo( "aCamposItens", ::aCamposItens )
            VarInfo( "aCabec", aCabec )
            VarInfo( "aItens", aItens )

            nQtd  := Len( aCabec )
            cJoin := ""

            For nX := 1 to nQtd

                nPosCabec := ascan( ::aCamposCabec,{ |x| x == aCabec[nX] } )
                nPosItem  := ascan( ::aCamposItens,{ |x| x == aItens[nX] } )

                VarInfo( "nPosCabec", nPosCabec )
                VarInfo( "nPosItem", nPosItem )
                
                If nPosCabec > 0 .and. nPosItem > 0
                    cJoin += aCabec[nX] + " = " + aItens[nX] + " AND "
                Else
                    lTemTodosOsCampos := .F.
                    exit
                EndIf
                
            Next nX

        If lTemTodosOsCampos
            Exit
        EndIf

        ( cAlsQry )->( DbSkip( ) )

        EndDo
    End

    cJoin := SUBSTR( cJoin, 1, Len( cJoin ) -4 )
    VarInfo( "cJoin", cJoin )

    ( cAlsQry )->( dbCloseArea( ) )

Return cJoin

/*/{Protheus.doc} fAtuPainel
	Atualiza a Segunda pagina do Wizard.
	@author Geanlucas Sousa	
	@since 28/03/2025
/*/
Static Function fAtuPainel(oTabA1,oTabB1,oTabC1,oTabD1,oTabE1,oTabF1,oTabG1,oPanel,oBtnA,oBtnB,oBtnC,cInfoPn2)

    Local aArea     := FwGetArea()
    Local cColor    := ''
    Local cStatus   := ''

    If cInfoPn2 == 'EXECUTANDO'
        cColor := 'QWidget { color: #FF0000; }'
        cStatus := cInfoPn2
    Else
        cColor := 'QWidget { color: #008000; }'
        cStatus := cInfoPn2
    EndIf
    
    oBtnA:Disable()
    oBtnB:Disable()

    If !Empty(oTabA1)
        oTabA1:cCaption := cStatus
        oTabA1:SetCSS(cColor)
        oTabA1:Refresh(.T.)

        If !Empty(oTabB1)
            oTabB1:cCaption := cStatus
            oTabB1:SetCSS(cColor)
            oTabB1:Refresh(.T.)

            If !Empty(oTabC1)
                oTabC1:cCaption := cStatus
                oTabC1:SetCSS(cColor)
                oTabC1:Refresh(.T.)

                If !Empty(oTabD1)
                    oTabD1:cCaption := cStatus
                    oTabD1:SetCSS(cColor)
                    oTabD1:Refresh(.T.)

                    If !Empty(oTabE1)
                        oTabE1:cCaption := cStatus
                        oTabE1:SetCSS(cColor)
                        oTabE1:Refresh(.T.)

                        If !Empty(oTabF1)
                            oTabF1:cCaption := cStatus
                            oTabF1:SetCSS(cColor)
                            oTabF1:Refresh(.T.)

                            If !Empty(oTabG1)
                                oTabG1:cCaption := cStatus
                                oTabG1:SetCSS(cColor)
                                oTabG1:Refresh(.T.)
                            EndIf

                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf

        oPanel:Refresh(.T.)

    EndIf

    FwRestArea(aArea)

Return .T.
