// Bibliotecas necess�rias
#Include "TOTVS.ch"

// Constantes do fonte
#Define SLASH_REMOTE IIf(CValToChar(GetRemoteType()) $ "-1|2", "\", "/")
#Define SLASH_SERVER IIf(IsSrvUnix(), "/", "\")

/*/{Protheus.doc} BACGetCId
    Retorna o c�digo identificador de cliente da empresa atual na Benef�cio Certo.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 24/08/2022
    @return Character, C�digo identificador da empresa atual na Benef�cio Certo
    @obs BARQCOMP = (B)enef. (ARQ)uivo (COMP)lementar
/*/
User Function BACGetCId() As Character
    // Vari�veis locais
    Local nLine As Numeric   // Linha do fornecedor na tabela S018
    Local cId   As Character // Identificador da empresa na Benef�cio Certo

    // Inicializa��o de vari�veis
    nLine := FPosTab("S018", AllTrim(MV_PAR01), "==", 4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, cFilAnt)
    cId   := AllTrim(FTabela("S018", 4, 6, NIL, cFilAnt))
Return (cId)

/*/{Protheus.doc} BACValid
    Efetua valida��es customizadas para funcionamento do fonte BENEFARQ.prw nos par�metros da Benef�cio Certo.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 24/08/2022
    @return Logical, Se .T., a valida��o foi bem sucedida, se .F., ocorreram erros no processo
    @obs A fun��o Alert() foi utilizada nesta fun��o para manter o mesmo formato utilizado no fonte BENEFARQ.prw
/*/
User Function BACValid() As Logical
    // Vari�veis locais
    Local lValid As Logical   // Flag de valida��o bem sucedida
    Local nLine  As Numeric   // Linha do fornecedor na tabela S018
    Local cId    As Character // Identificador da empresa na Benef�cio Certo

    // Inicializa��o de vari�veis
    lValid := .F.
    nLine  := FPosTab("S018", AllTrim(MV_PAR01), "==", 4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, cFilAnt)
    cId    := AllTrim(FTabela("S018", 4, 6, NIL, cFilAnt))

    // Inicia a sequ�ncia de valida��es
    BEGIN SEQUENCE
        // Gera exce��o se os par�metros "Filial de?" e "Filial at�?" estiverem diferentes
        // Obs: Valida��o para funcionamento do RDMAKE padr�o devido a n�o prepara��o do fonte BENEFARQ.prw para o uso em ambiente com gest�o de empresas
        If (!MV_PAR07 == MV_PAR08)
            Alert("N�o � poss�vel processar filiais diferentes quando usado Gest�o de Empresas (MV_PAR07 e MV_PAR08)!")
            BREAK
        EndIf

        // Gera exce��o caso o c�digo identificador da empresa atualmente conectada n�o esteja cadastrado no par�metro BR_CDID
        nLine := FPosTab("S018", AllTrim(MV_PAR01), "==", 4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, cFilAnt)
        cId   := AllTrim(FTabela("S018", 4, 6, NIL, cFilAnt))
        If (Empty(cId))
            Alert("Identificador da empresa como cliente na Benef�cio Certo n�o informado na tabela S018!")
            BREAK
        EndIf

        // Gera exce��o caso n�o haja dados de usu�rio respons�vel no par�metro BR_BCUSR
        If (Empty(SuperGetMV("BR_BCUSR", .F., "DAIANA MELLO|F|19930402")) .Or. !Len(StrTokArr2(SuperGetMV("BR_BCUSR", .F., "DAIANA MELLO|F|19930402"), "|")) == 3)
            Alert("Usu�rio respons�vel pelo pedido � Benef�cio Certo n�o informado no par�metro BR_BCUSR!")
            BREAK
        EndIf

        // Gera exce��o caso o e-mail do usu�rio respons�vel pelo pedido n�o esteja no par�metro BR_BCMAIL
        If (Empty(SuperGetMV("BR_BCMAIL", .F., "BENEFICIOS@BRASILRISK.COM.BR")))
            Alert("Usu�rio respons�vel pelo pedido � Benef�cio Certo n�o informado no par�metro BR_BCUSR!")
            BREAK
        EndIf

        // Define a flag como sucesso se n�o forem geradas exce��es
        lValid := .T.
    END SEQUENCE
Return (lValid)

/*/{Protheus.doc} BAC01Query
    Retorna os campos da SRA para complemento da query de busca dos dados da se��o "FUNCIONARIOS".
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 29/08/2022
    @return Character, Complemento da query contendo os campos da SRA
/*/
User Function BAC01Query() As Character
    // Vari�veis locais
    Local cQuery As Character // Lista de campos extras adicionados na query

    // Inicializa��o de vari�veis
    cQuery := ", RA_DEPTO, RA_CARGO, RA_DTRGEXP "
Return (cQuery)

/*/{Protheus.doc} BAC02Query
    Retorna a condi��o para que apenas os funcion�rios n�o demitidos sejam listados.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 29/08/2022
    @return Character, Complemento da query contendo os campos da SRA
/*/
User Function BAC02Query() As Character
    // Vari�veis locais
    Local cQuery As Character // Condicional extra para adi��o nas queries

    // Inicializa��o de vari�veis
    cQuery := " AND RA_DEMISSA = ' ' "
Return (cQuery)

/*/{Protheus.doc} BAC03Query
    Retorna a condi��o para listagem apenas de funcion�rios com quantidade de benef�cios maior que zero.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 29/08/2022
    @return Character, Complemento da query contendo os campos da SRA
/*/
User Function BAC03Query() As Character
    // Vari�veis locais
    Local cQuery As Character // Condicional extra para adi��o nas queries

    // Inicializa��o de vari�veis
    cQuery := " AND R0_QDIACAL > 0 AND R0_VLRVALE > 0 "
Return (cQuery)

/*/{Protheus.doc} BACGetUser
    Retorna o nome do usu�rio, sexo ou data de nascimento do usu�rio respons�vel pelo pedido.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 29/08/2022
    @param nInfo, Numeric, N�mero da informa��o solicitada (1=Nome | 2=Sexo | 3=Data de nascimento)
    @return Variant, Caractere ou data conforme informado no par�metro nInfo
/*/
User Function BACGetUser(nInfo As Numeric) As Variant
    // Vari�veis locais
    Local aInfo As Array     // Vetor de informa��es do usu�rio
    Local xInfo As Character // Informa��o buscada do usu�rio

    // Inicializa��o de vari�veis
    aInfo := StrTokArr2(SuperGetMV("BR_BCUSR", .F., "DAIANA MELLO|F|19930402"), "|")
    xInfo := aInfo[nInfo]

    // Converte a data de nascimento de caractere para data
    If (nInfo == 3)
        xInfo := SToD(xInfo)
    EndIf
Return (xInfo)

/*/{Protheus.doc} BACCopy
    Realiza a c�pia do arquivo gerado para o diret�rio C:/Temp do usu�rio.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 08/09/2022
    @param cFile, Character, Nome do arquivo gerado
    @return Variant, Retorno nulo fixado
    @obs A fun��o Alert() foi utilizada nesta fun��o para manter o mesmo formato utilizado no fonte BENEFARQ.prw
/*/
User Function BACCopy(cFile As Character) As Variant
    // Vari�veis locais
    Local cSource  As Character // Caminho que o arquivo de benef�cios foi gerado
    Local cTarget  As Character // Pasta destino do arquivo que ser� copiado
    Local cNewFile As Character // Nome do novo arquivo que ser� criado

    // Inicializa��o de vari�veis
    cSource  := SLASH_SERVER + "system" + SLASH_SERVER + cFile
    cTarget  := "C:" + SLASH_REMOTE + "temp"
    cNewFile := StrTokArr2(cFile, ".")[1] + "_" + DToS(Date()) + "_" + StrTran(Time(), ":") + ".txt"

    // Inicia a sequ�ncia de valida��o
    BEGIN SEQUENCE
        // Cria o diret�rio de destino da c�pia do arquivo caso ele n�o exista
        If (!File(cTarget) .And. !FwMakeDir(cTarget))
            Alert("N�o foi poss�vel criar o diret�rio " + cTarget + " na m�quina do usu�rio para c�pia do arquivo!")
            BREAK
        EndIf

        // Gera exce��o se o arquivo n�o se arquivo n�o puder ser copiado
        If (!__CopyFile(cSource, cTarget + SLASH_REMOTE + cNewFile, NIL, NIL, .F.))
            Alert("O arquivo " + cFile + " n�o pode ser copiado do servidor para " + cTarget + "!")
            BREAK
        EndIf

        // Exibe mensagem ao usu�rio de c�pia bem sucedida
        FwAlertSuccess("Arquivo " + StrTran(cFile, ".TXT", ".txt") + " copiado para a m�quina do usu�rio sob o nome " + cNewFile + " no diret�rio " + cTarget + ".", "Sucesso")
    END SEQUENCE
Return (NIL)

/*/{Protheus.doc} BACVld01
    Valida��o para n�o inser��o de linhas com quantidade de benef�cio zerada.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 14/09/2022
    @param nQuant, Numeric, Quantidade de itens de benef�cio para o colaborador
    @param nQuant, Numeric, Quantidade de itens de benef�cio para o colaborador
    @return Logical, Flag libera��o para adi��o de linha no arquivo de integra��o
/*/
User Function BACVld01(nQuant As Numeric, nValue As Numeric) As Logical
Return (nQuant > 0 .And. nValue > 0)
