//#include 'tlpp-core.th'
#include 'protheus.ch'
#include "fileio.ch"
 
//namespace TIIntegrador

/*/{Protheus.doc} TINCWHCNF
Rotina de chamada das conferencias de integrações das tabelas do Integramais
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
User Function TINCWHCNF()

Return(.T.)
/*/{Protheus.doc} ConfereMigracao
Classe ConfereMigracao
@type class
@version 1.0 
@author Wesley Pinheiro
@since 20/02/2025
/*/
CLASS ConfereMigracao FROM WHIntegraMais

    public Data cArqLogThread        as Character
    public Data cDirRootPath         as Character
    public Data cFuncaoConfere       as Character
    public Data cCamposCliOuForn     as Character
    public Data cTabCliOuFor         as Character
    public Data aCamposComDePara     as Array
    public Data nQtdCamposComDePara  as Numeric
    public Data aCamposSemDePara     as Array
    public Data nQtdCamposSemDePara  as Numeric
    public Data cCampo               as Character
    public Data xDadoJson            as Variant
    public Data xDadoTab             as Variant
    public Data xValType             as Variant
    public Data xVal                 as Variant
    public Data oHashP97             as Object

    // Construtores
    public Method New( cTabSX2, cDocEmp, cFilDest ) CONSTRUCTOR
    public Method NewConfereMigraAux( cTabSX2, cDocEmp, nRowNumDe, nRowNumAte, nThread, cCampos ) CONSTRUCTOR

    // Métodos de Arquivo
    public Method CriaArq( cArquivo )
    public Method CsvThread( )
    public Method SetNomeArquivoLogThread( nThread )
    public Method CsvDiverg( )
    public Method SaveMsgLog( cArquivo, cTexto )

    // Métodos Thread
    public Method ExecThreadsConferencia( )
    public Method ConcatenaLogsDasThreads( )

    // Auxiliares Processo
    public Method GetCpFor( )
    public Method SetQtdRegistrosParaConferir( )
    public Method MontaWhereP98( )
    public Method ExecQryConferenciaP98( )
    public Method SeparaCamposPorCatergoria( )
    public Method GetCpSDP( aCampos )
    static Method SetArrayCampos( cTabSX2, aCampos, nQtdCampos  )
    public Method ComparaDados( aCampos )
    public Method CriaHashMapP97( )

ENDCLASS

Method New( cTabSX2, cDocEmp, cFilDest ) Class ConfereMigracao
    _Super:New( cTabSX2, cDocEmp )
    ::cFilDest       := cFilDest
    ::cDirRootPath   := "spool\"
    ::cFuncaoConfere := "ConferenciaMigracao.U_ThreadParalelaConfereMigracao"
Return


/*/{Protheus.doc} TIIntegrador.ConfereMigracao:NewConfereMigraAux
Método Construtor objeto TIIntegrador.ConfereMigracao a ser utilizado na Thread Auxiliar
@type method
@version 1.0
@author Wesley Pinheiro
@since 20/02/2025
@param cTabSX2, character, alias da Tabela a ser validada
@param cDocEmp, character, documento da filial para realizar filtro dos registros P98
@param nRowNumDe, numeric, RowNumber inicial da paginação ( query )
@param nRowNumAte, numeric, RowNumber final da paginação ( query )
@param nThread, numeric, número da Thread ( utilizado para criar o nome do arquivo log da Thread )
@param cCampos, character, campos a serem utilizados para posicionar no Json e na tabela final
/*/
Method NewConfereMigraAux( cTabSX2, cDocEmp, nRowNumDe, nRowNumAte, nThread, cCampos ) Class ConfereMigracao
    ::cTabSX2          := cTabSX2
    ::cDocEmp          := cDocEmp
    ::nRowNumDe        := nRowNumDe
    ::nRowNumAte       := nRowNumAte
    ::cCampos          := cCampos
    ::cAliasQuery      := GetNextAlias( )
    ::cDirRootPath     := "spool\"
    ::aCamposComDePara := { }
    ::aCamposSemDePara := { }
    self:SetNomeArquivoLogThread( nThread )
Return

Method CriaArq( cArquivo ) Class ConfereMigracao

    Local lOK := .T.
    Local oFWriter := FWFileWriter():New( cArquivo, .F.)

    If oFWriter:Create()
        oFWriter:Close( )
    Else
        //conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
        lOK := .F.
    EndIf

Return lOK

Method CsvThread( ) Class ConfereMigracao

    Local nX
    Local lOk := .T.

    for nX := 1 to ::nQtdThreads
        self:SetNomeArquivoLogThread( nX )
        Ferase( ::cArqLogThread )

        If !self:CriaArq( ::cArqLogThread )
            lOK := .F.
            Exit
        EndIf

    next nX

Return lOK

Method SetNomeArquivoLogThread( nThread ) Class ConfereMigracao
    ::cArqLogThread := ::cDirRootPath + ::cTabSX2 + '_Thread_' + cValtochar( nThread ) + '.csv'
Return

Method CsvDiverg( ) Class ConfereMigracao

    Local lOk       := .T.
    Local cTexto    := ""
    Local cCpsChave := ""
    Local cArquivo

    cArquivo := ::cDirRootPath + 'Conferencia_' + ::cTabSX2 + '_' + StrTran( DtoC( ddatabase), "/", '-' ) + '.csv'
    Ferase( cArquivo )

    If self:CriaArq( cArquivo )
        cCpsChave := FWX2Unico( ::cTabSX2 )
        cTexto    := 'Tabela;Chave (' + cCpsChave + ');Campo Divergente;Conteudo Arq;Conteudo Tabela;Linha Arq;OBS'
        self:SaveMsgLog( cArquivo, cTexto )
    else
        lOK := .F.
    EndIf

Return lOK

Method SaveMsgLog( cArquivo, cTexto ) Class ConfereMigracao

   Local oFWriter := FWFileWriter():New( cArquivo, .F. )

    If File( cArquivo )
        oFWriter:Open( FO_WRITE )
        oFWriter:goBottom( )
        cTexto += Chr(13)+Chr(10)
        oFWriter:Write( cTexto )
        oFWriter:Close( )
    Else
        //conout( "Erro - Arquivo nao encontrado: " + cArquivo )
    EndIf

Return


Method ExecThreadsConferencia( ) Class ConfereMigracao

	Local nY 	  := 0
	Local nPosDe  := 1
    Local nPosAte := 2

	For nY := 1 to ::nQtdThreads
		StartJob(   ::cFuncaoConfere,;
					GetEnvServer(),;
					.F.,;
					cEmpAnt,;
					::cFilDest,;
					::cTabSX2,;
					::cDocEmp,;
					::aLinhasDeAte[nY,nPosDe],;
					::aLinhasDeAte[nY,nPosAte],;
					nY,;
					::cCampos;
				)
	Next nY

Return

Method ConcatenaLogsDasThreads( ) Class ConfereMigracao

    Local cArqFinal, cTempFile, cContent
    Local oFWriter
    Local nX := 0

    cArqFinal := ::cDirRootPath + 'Conferencia_' + ::cTabSX2 + '_' + StrTran( DtoC( ddatabase), "/", '-' ) + '.csv'

    If File( cArqFinal )
        oFWriter := FWFileWriter( ):New( cArqFinal, .F. )
        oFWriter:Open( FO_WRITE )
        For nX:= 1 To ::nQtdThreads
            cTempFile   := ::cDirRootPath + ::cTabSX2 + '_Thread_' + cValtochar( nX ) + '.csv'
            oFile       := FwFileReader( ):New( cTempFile )
            oFile:Open( )
            cContent    := oFile:FullRead( )
            oFWriter:goBottom( )
            oFWriter:Write( cContent )
            oFile:Close( )
            FErase(cTempFile)  // Apaga o arquivo temporário
            cContent := ""
        Next nX
        oFWriter:Close( )
    Else
        //conout( "ConcatenateFiles - Erro - Arquivo nao encontrado: " + cArquivo )
    EndIf

    //CpyS2T( cArqFinal, 'c:\temp\integramais\', .F. )
    //CpyS2TW( cArqFinal )
    FErase( cArqFinal )

Return

Method GetCpFor( ) Class ConfereMigracao

    ::cCamposCliOuForn := ""
    ::cTabCliOuFor     := ""

    If ::cTabSX2 == "SC5"
        ::cCamposCliOuForn := "C5_CLIENTE"
        ::cTabCliOuFor     := "SA1"
    ElseIf ::cTabSX2 == "SC6"
        ::cCamposCliOuForn := "C6_CLI"
        ::cTabCliOuFor     := "SA1"
    EndIf

Return

Method SetQtdRegistrosParaConferir( ) Class ConfereMigracao

    Local cQuery
    Local cAlsQry := GetNextAlias( )

    cQuery := " SELECT COUNT(*) QTD_REG " 
    cQuery += " FROM " + RetSqlName( "P98" ) + " P98 " 
    cQuery += self:MontaWhereP98( )

    PlsQuery( cQuery, cAlsQry )

    While ( cAlsQry )->( !Eof( ) )
        ::nQtdRegParaProcessar := ( cAlsQry )->QTD_REG
        ( cAlsQry )->( DbSkip( ) )
    EndDo

    ( cAlsQry )->( dbCloseArea( ) )

Return

/* 
    Vamos conferir apenas o que saiu da P98 para a tabela auxiliar temporária:
    Status 1 - PROCESSADO COM SUCESSO
    Se ocorrer erro da temporaria para a tabela final,
    pelo menos na P98 já será possível utilizar esse registro para conferência
*/
Method MontaWhereP98( ) Class ConfereMigracao

    Local cQuery
    cQuery := " WHERE P98_TABELA = '" + ::cTabSX2 + "' " 
    cQuery += " AND P98_CALLBA = '" + ::cDocEmp + "' " 
    cQuery += " AND P98_STATUS = '1' " 
    cQuery += " AND P98.D_E_L_E_T_ = ' ' " 

Return cQuery

Method ExecQryConferenciaP98( ) Class ConfereMigracao

    Local cQuery
    //Local cCampoCod := PrefixoCPO( ::cTabCliOuFor ) +"_COD" // A1_COD ou A2_COD
    Local cSX2Unico := _Super:GtCpoX2Unico( ::cTabSX2, "||")

    cQuery := " SELECT * "
    cQuery += " FROM ( "
    cQuery += " 	SELECT P98.R_E_C_N_O_ AS RECNO "
    cQuery += " 		,ROW_NUMBER() OVER ( "
    cQuery += " 			ORDER BY P98_FILIAL "
    cQuery += " 				,P98_COD "
    cQuery += " 			) AS RN "

    //cQuery += " 		,"+ ::cCamposCliOuForn + " AS CODCLI " // C5_CLIENTE
    
    //cQuery += " 		," + cCampoCod + " AS A1A2_COD        " // A1_COD ou A2_COD
    //cQuery += " 		," + PrefixoCPO( ::cTabCliOuFor ) +"_CGC AS A1A2_CGC       " // A1_CGC ou A2_CGC

    cQuery += "     FROM " + RetSqlName( "P98" ) + " P98 "
    cQuery += " 	LEFT JOIN " + RetSQLName( ::cTabSX2 ) + " B ON "
    cQuery += "         " + PrefixoCPO( ::cTabSX2 ) + "_FILIAL = '" + cFilAnt + "' " // C5_FILIAL
    cQuery += "         AND " + cSX2Unico + " = P98_CODEXT " // C5_FILIAL || C5_NUM
    
    // cQuery += " 	LEFT JOIN " + RetSQLName( ::cTabCliOuFor ) + " C ON "
    // cQuery += "         " + PrefixoCPO( ::cTabCliOuFor ) + "_FILIAL = '" + xFilial( ::cTabCliOuFor ) + "' " // A1 ou A2 _FILIAL
    // cQuery += "         AND " + ::cCamposCliOuForn + " = " + cCampoCod + " " //  (SA1/SA2) / ( C5_CLIENTE = A1_COD ou A2_COD )

    cQuery += self:MontaWhereP98( )
    cQuery += " ) "
    cQuery += " WHERE RN BETWEEN " + cValToChar( ::nRowNumDe ) + " "
    cQuery += "         AND " + cValToChar( ::nRowNumAte ) + " "

    VarInfo( "cQuery", cQuery )

    PlsQuery( cQuery, ::cAliasQuery )

Return

Method SeparaCamposPorCatergoria( ) Class ConfereMigracao

    Local nPos,aCampos,aAux,nLen,nX
    Local cParamd  := SuperGetMv('TI_TINCH1',.F.,'CLIENT/CODCLI/CLIFOR/FORNEC/CLIENTE/FORNECE/TITPAI') + "/CLI" // C6_CLI -> Para retirar o campo do array, é necessário o nPos correto, por isso incluído "CLI"
    Local cPrefixo := PrefixoCPO( ::cTabSX2 )

    aCampos := StrTokArr( ::cCampos, ";" )

    // Retirar campo de cliente do Array
    // nPos := ascan( aCampos, { |x| AllTrim( x ) == ::cCamposCliOuForn } )

    // VarInfo("oValid:aCampos_antes",aCampos)

    // aDel( aCampos, nPos )
    // aSize( aCampos, Len( aCampos ) - 1 )
    // nQtdCampos := Len( aCampos )

    VarInfo("oValid:aCampos_antes",aCampos)
    
    aAux := Separa( cParamd, '/' )
    nLen := Len( aAux )

    for nX := 1 To nLen
        cCampoCli := cPrefixo + "_" + aAux[nX]

        nPos := ascan( aCampos, { |x| AllTrim( x ) == cCampoCli } )
        If nPos > 0 
            aDel( aCampos, nPos )
            aSize( aCampos, Len( aCampos ) - 1 )
            nQtdCampos := Len( aCampos )
        EndIf

    next nX

    VarInfo("oValid:aCampos_depois",aCampos)

    self:GetCpSDP( aCampos )

Return

Method GetCpSDP( aCampos ) Class ConfereMigracao

    Local cAlsQry := GetNextAlias( )
    Local cQuery
    Local nX,nPos

    // Criar array campos ComDePara - P97
    cQuery := " SELECT DISTINCT(P97_CAMPO) " 
    cQuery += " FROM " + RetSqlName( "P97" ) + " "
    cQuery += " WHERE P97_CNPJ = '" + ::cDocEmp + "' " 
    cQuery += " 	AND P97_TABELA = '" + ::cTabSX2 + "' " 
    cQuery += " 	AND D_E_L_E_T_ = ' ' " 

    PlsQuery( cQuery, cAlsQry )

    While ( cAlsQry )->( !Eof( ) )
        aadd( ::aCamposComDePara, Alltrim( ( cAlsQry )->P97_CAMPO ) )
        ( cAlsQry )->( DbSkip( ) )
    EndDo
    ( cAlsQry )->( dbCloseArea( ) )
    self:SetArrayCampos( ::cTabSX2, @::aCamposComDePara, @::nQtdCamposComDePara )
    //-------------

    // Criar array campos SemDePara
    ::aCamposSemDePara := aClone( aCampos )

    for nX := 1 to ::nQtdCamposComDePara
        nPos := ascan( ::aCamposSemDePara, { |x| AllTrim( x ) == ::aCamposComDePara[nX][1] } )
        aDel( ::aCamposSemDePara, nPos )
        aSize( ::aCamposSemDePara, Len( ::aCamposSemDePara ) - 1 )
    next nX

    self:SetArrayCampos( ::cTabSX2, @::aCamposSemDePara, @::nQtdCamposSemDePara )
    //-------------

Return

Method SetArrayCampos( cTabSX2, aCampos, nQtdCampos  )  Class ConfereMigracao
    
    Local aAux := { }
    Local nX
    Local cCampo, cTipo

    nQtdCampos := Len( aCampos )
    aEval( aCampos, { |x| aadd( aAux, { x } ) } )
    aAux := FWVetByDic( aAux, cTabSX2 ) // Ordena array de acordo com a SX3

    aCampos := { }
     
    for nX := 1 to nQtdCampos
        cCampo := aAux[nX,1]
        cTipo  := GetSX3Cache( cCampo, "X3_TIPO" )

        If  cTipo == "N"
            aadd( aCampos, { cCampo, cTipo ,AllTrim( GetSX3Cache( cCampo, "X3_PICTURE" ) ) } )
        Else
             aadd( aCampos, { cCampo, cTipo } )
        EndIf
    next nX

    /*
    aCampos[1] -> ARRAY (    2) [...]
        aCampos[1][1] -> C (    9) [C6_FILIAL]
        aCampos[1][2] -> C (    1) [C]
        aCampos[1][3] -> C (   21) [@E 999,999,999.999999]
    */

Return

Method ComparaDados( aCampo ) Class ConfereMigracao

    ::cCampo    := aCampo[1]
    ::xDadoJson := oJson["fields"][::cCampo]
    ::xDadoTab  := &(::cTabSX2+"->"+::cCampo)
    ::xValType  := aCampo[2]

    If ::xValType == "C"
        ::xDadoJson := AllTrim( ::xDadoJson )
        ::xDadoTab  := AllTrim( ::xDadoTab  )
    ElseIf ::xValType == "N"
        /*
            Estava comparando 
            xDadoJson := "20.0000" com xDadoTab := "20"
            por isso foi necessário transformar o xDadoJson em númerico para usar o cValtoChar
            A vantagem de usar cValtoChar na primeira conversão, 
            é porque mesmo que o xDadoJson seja caracter não causa erro, se xDadoJson for númerico retorna caracter normalmente

            xDadoJson := cvaltochar( Val( xDadoJson ) ) -> De: "20.0000" Para: "20"

            Utilizado Transform para evitar erro de comparação:
            C6_PRCVEN -> X3_PICURE ( "@E 999,999,999.999999" )
            planilha -> 6.85266687
            tabela -> 6.852667 ( devido a mascara na tabela é inserindo apenas 6 digitos depois da vírgula, de modo que "87" não é inserido no campo da tabela )
        */
        ::xDadoJson := cvaltochar( ::xDadoJson )
        ::xDadoJson := Alltrim( Transform( Val( ::xDadoJson ) , aCampo[3] ) )
        ::xDadoTab  := Alltrim( Transform( ::xDadoTab , aCampo[3] ) )
    ElseIf ::xValType ==  "D"
        ::xDadoJson := stod( ::xDadoJson ) // "20220714"
        ::xDadoJson := dtoc( ::xDadoJson ) // "14/07/2022"
        ::xDadoTab  := dtoc( ::xDadoTab ) // "14/07/2022"
    EndIf

Return

Method CriaHashMapP97( ) Class ConfereMigracao

    Local cAlsQry := GetNextAlias( )
    Local cQuery
    
    ::oHashP97   := tHashMap( ):New( )

    cQuery := " SELECT Trim(P97_CAMPO) || Trim(P97_CONTOR) as P97CHV, P97_CONTDE " 
    cQuery += " FROM " + RetSqlName( "P97" ) + " "
    cQuery += " WHERE P97_CNPJ = '" + ::cDocEmp + "'   " 
    cQuery += " 	AND P97_TABELA = '" + ::cTabSX2 + "' " 
    cQuery += " 	AND D_E_L_E_T_ = ' '   " 

    PlsQuery( cQuery, cAlsQry )

    While ( cAlsQry )->( !Eof( ) )
        ::oHashP97:Set( Alltrim( ( cAlsQry )->P97CHV ), AllTrim( ( cAlsQry )->P97_CONTDE ) )
        ( cAlsQry )->( DbSkip( ) )
    EndDo
   ( cAlsQry )->( dbCloseArea( ) )

Return
