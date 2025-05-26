// Bibliotecas necessárias
#Include "TOTVS.ch"

// Constantes do fonte
#Define SLASH_REMOTE IIf(CValToChar(GetRemoteType()) $ "-1|2", "\", "/")
#Define SLASH_SERVER IIf(IsSrvUnix(), "/", "\")

/*/{Protheus.doc} BACGetCId
    Retorna o código identificador de cliente da empresa atual na Benefício Certo.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 24/08/2022
    @return Character, Código identificador da empresa atual na Benefício Certo
    @obs BARQCOMP = (B)enef. (ARQ)uivo (COMP)lementar
/*/
User Function BACGetCId() As Character
    // Variáveis locais
    Local nLine As Numeric   // Linha do fornecedor na tabela S018
    Local cId   As Character // Identificador da empresa na Benefício Certo

    // Inicialização de variáveis
    nLine := FPosTab("S018", AllTrim(MV_PAR01), "==", 4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, cFilAnt)
    cId   := AllTrim(FTabela("S018", 4, 6, NIL, cFilAnt))
Return (cId)

/*/{Protheus.doc} BACValid
    Efetua validações customizadas para funcionamento do fonte BENEFARQ.prw nos parâmetros da Benefício Certo.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 24/08/2022
    @return Logical, Se .T., a validação foi bem sucedida, se .F., ocorreram erros no processo
    @obs A função Alert() foi utilizada nesta função para manter o mesmo formato utilizado no fonte BENEFARQ.prw
/*/
User Function BACValid() As Logical
    // Variáveis locais
    Local lValid As Logical   // Flag de validação bem sucedida
    Local nLine  As Numeric   // Linha do fornecedor na tabela S018
    Local cId    As Character // Identificador da empresa na Benefício Certo

    // Inicialização de variáveis
    lValid := .F.
    nLine  := FPosTab("S018", AllTrim(MV_PAR01), "==", 4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, cFilAnt)
    cId    := AllTrim(FTabela("S018", 4, 6, NIL, cFilAnt))

    // Inicia a sequência de validações
    BEGIN SEQUENCE
        // Gera exceção se os parâmetros "Filial de?" e "Filial até?" estiverem diferentes
        // Obs: Validação para funcionamento do RDMAKE padrão devido a não preparação do fonte BENEFARQ.prw para o uso em ambiente com gestão de empresas
        If (!MV_PAR07 == MV_PAR08)
            Alert("Não é possível processar filiais diferentes quando usado Gestão de Empresas (MV_PAR07 e MV_PAR08)!")
            BREAK
        EndIf

        // Gera exceção caso o código identificador da empresa atualmente conectada não esteja cadastrado no parâmetro BR_CDID
        nLine := FPosTab("S018", AllTrim(MV_PAR01), "==", 4, NIL, NIL, NIL, NIL, NIL, NIL, NIL, cFilAnt)
        cId   := AllTrim(FTabela("S018", 4, 6, NIL, cFilAnt))
        If (Empty(cId))
            Alert("Identificador da empresa como cliente na Benefício Certo não informado na tabela S018!")
            BREAK
        EndIf

        // Gera exceção caso não haja dados de usuário responsável no parâmetro BR_BCUSR
        If (Empty(SuperGetMV("BR_BCUSR", .F., "DAIANA MELLO|F|19930402")) .Or. !Len(StrTokArr2(SuperGetMV("BR_BCUSR", .F., "DAIANA MELLO|F|19930402"), "|")) == 3)
            Alert("Usuário responsável pelo pedido à Benefício Certo não informado no parâmetro BR_BCUSR!")
            BREAK
        EndIf

        // Gera exceção caso o e-mail do usuário responsável pelo pedido não esteja no parâmetro BR_BCMAIL
        If (Empty(SuperGetMV("BR_BCMAIL", .F., "BENEFICIOS@BRASILRISK.COM.BR")))
            Alert("Usuário responsável pelo pedido à Benefício Certo não informado no parâmetro BR_BCUSR!")
            BREAK
        EndIf

        // Define a flag como sucesso se não forem geradas exceções
        lValid := .T.
    END SEQUENCE
Return (lValid)

/*/{Protheus.doc} BAC01Query
    Retorna os campos da SRA para complemento da query de busca dos dados da seção "FUNCIONARIOS".
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 29/08/2022
    @return Character, Complemento da query contendo os campos da SRA
/*/
User Function BAC01Query() As Character
    // Variáveis locais
    Local cQuery As Character // Lista de campos extras adicionados na query

    // Inicialização de variáveis
    cQuery := ", RA_DEPTO, RA_CARGO, RA_DTRGEXP "
Return (cQuery)

/*/{Protheus.doc} BAC02Query
    Retorna a condição para que apenas os funcionários não demitidos sejam listados.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 29/08/2022
    @return Character, Complemento da query contendo os campos da SRA
/*/
User Function BAC02Query() As Character
    // Variáveis locais
    Local cQuery As Character // Condicional extra para adição nas queries

    // Inicialização de variáveis
    cQuery := " AND RA_DEMISSA = ' ' "
Return (cQuery)

/*/{Protheus.doc} BAC03Query
    Retorna a condição para listagem apenas de funcionários com quantidade de benefícios maior que zero.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 29/08/2022
    @return Character, Complemento da query contendo os campos da SRA
/*/
User Function BAC03Query() As Character
    // Variáveis locais
    Local cQuery As Character // Condicional extra para adição nas queries

    // Inicialização de variáveis
    cQuery := " AND R0_QDIACAL > 0 AND R0_VLRVALE > 0 "
Return (cQuery)

/*/{Protheus.doc} BACGetUser
    Retorna o nome do usuário, sexo ou data de nascimento do usuário responsável pelo pedido.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 29/08/2022
    @param nInfo, Numeric, Número da informação solicitada (1=Nome | 2=Sexo | 3=Data de nascimento)
    @return Variant, Caractere ou data conforme informado no parâmetro nInfo
/*/
User Function BACGetUser(nInfo As Numeric) As Variant
    // Variáveis locais
    Local aInfo As Array     // Vetor de informações do usuário
    Local xInfo As Character // Informação buscada do usuário

    // Inicialização de variáveis
    aInfo := StrTokArr2(SuperGetMV("BR_BCUSR", .F., "DAIANA MELLO|F|19930402"), "|")
    xInfo := aInfo[nInfo]

    // Converte a data de nascimento de caractere para data
    If (nInfo == 3)
        xInfo := SToD(xInfo)
    EndIf
Return (xInfo)

/*/{Protheus.doc} BACCopy
    Realiza a cópia do arquivo gerado para o diretório C:/Temp do usuário.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 08/09/2022
    @param cFile, Character, Nome do arquivo gerado
    @return Variant, Retorno nulo fixado
    @obs A função Alert() foi utilizada nesta função para manter o mesmo formato utilizado no fonte BENEFARQ.prw
/*/
User Function BACCopy(cFile As Character) As Variant
    // Variáveis locais
    Local cSource  As Character // Caminho que o arquivo de benefícios foi gerado
    Local cTarget  As Character // Pasta destino do arquivo que será copiado
    Local cNewFile As Character // Nome do novo arquivo que será criado

    // Inicialização de variáveis
    cSource  := SLASH_SERVER + "system" + SLASH_SERVER + cFile
    cTarget  := "C:" + SLASH_REMOTE + "temp"
    cNewFile := StrTokArr2(cFile, ".")[1] + "_" + DToS(Date()) + "_" + StrTran(Time(), ":") + ".txt"

    // Inicia a sequência de validação
    BEGIN SEQUENCE
        // Cria o diretório de destino da cópia do arquivo caso ele não exista
        If (!File(cTarget) .And. !FwMakeDir(cTarget))
            Alert("Não foi possível criar o diretório " + cTarget + " na máquina do usuário para cópia do arquivo!")
            BREAK
        EndIf

        // Gera exceção se o arquivo não se arquivo não puder ser copiado
        If (!__CopyFile(cSource, cTarget + SLASH_REMOTE + cNewFile, NIL, NIL, .F.))
            Alert("O arquivo " + cFile + " não pode ser copiado do servidor para " + cTarget + "!")
            BREAK
        EndIf

        // Exibe mensagem ao usuário de cópia bem sucedida
        FwAlertSuccess("Arquivo " + StrTran(cFile, ".TXT", ".txt") + " copiado para a máquina do usuário sob o nome " + cNewFile + " no diretório " + cTarget + ".", "Sucesso")
    END SEQUENCE
Return (NIL)

/*/{Protheus.doc} BACVld01
    Validação para não inserção de linhas com quantidade de benefício zerada.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 14/09/2022
    @param nQuant, Numeric, Quantidade de itens de benefício para o colaborador
    @param nQuant, Numeric, Quantidade de itens de benefício para o colaborador
    @return Logical, Flag liberação para adição de linha no arquivo de integração
/*/
User Function BACVld01(nQuant As Numeric, nValue As Numeric) As Logical
Return (nQuant > 0 .And. nValue > 0)
