// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} OUTLOOK
    Responsável pela abertura do Outlook para envio de um novo e-mail.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 21/08/2022
    @param cTo, Character, E-mails de destino da mensagem
    @param cSubject, Character, Assunto do e-mail a ser enviado
    @param aAttach, Array, Arquivos para envio como anexo
    @param cBody, Character, Corpo do e-mail para envio
    @param cCC, Character, E-mails enviados como "em cópia" (carbon copy)
    @param cBCC, Character, E-mails enviados como "em cópia oculta" (blind carbon copy)
    @return Variant, Retorno nulo fixado
    @link https://support.microsoft.com/en-us/office/command-line-switches-for-microsoft-office-products-079164cd-4ef5-4178-b235-441737deb3a6
/*/
User Function OUTLOOK(cTo As Character, cSubject As Character, aAttach As Array, cBody As Character, cCC As Character, cBCC As Character) As Variant
    // Variáveis locais
    Local cAux   As Character // Auxiliar de montagem dos nome dos anexo
    Local cParam As Character // Linha de comando para envio ao executável do Outlook
    Local lStart As Logical   // Flag de concatenação de parâmetros do Outlook

    // Inicialização padrão de parâmetros
    Default cTo      := ""
    Default cSubject := ""
    Default aAttach  := {}
    Default cBody    := ""
    Default cCC      := ""
    Default cBCC     := ""

    // Inicialização de varíaveis
    cAux   := ""
    cParam := "/c ipm.note "
    lStart := .T.

    // Inicia a sequência de preenchimento de parâmetros
    BEGIN SEQUENCE
        // Adiciona os e-mails de destino aos parâmetros do Outlook
        If (!Empty(cTo))
            cParam += '/m "' + AllTrim(cTo) + "?"
        Else
            Help(NIL, NIL, "OUTLOOK_EMPTY_EMAIL", NIL, "O e-mail do destinatário é obrigatório para prosseguir com o envio.",;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique a origem do conteúdo enviado no primeiro parâmetro da função e tente novamente."})
            BREAK
        EndIf

        // Adiciona o assunto aos parâmetros do Outlook se ele for enviado
        If (!Empty(cSubject))
            cParam += "subject=" + Escape(AllTrim(cSubject))
            lStart := .F.
        EndIf

        // Converte os saltos de linha do corpo do e-mail e anexo aos parâmetros se ele for enviado
        If (!Empty(cBody))
            cBody  := StrTran(cBody, CRLF, "%0D%0A")
            cParam += IIf(!lStart, "&", "") + "body=" + AllTrim(Escape(cBody))
            lStart := .F.
        EndIf

        // Adiciona os endereços de e-mail em cópia aos parâmetros do Outlook se eles forem enviados
        If (!Empty(cCC))
            cParam += IIf(!lStart, "&", "") + "cc=" + AllTrim(cCC)
            lStart := .F.
        EndIf

        // Adiciona os endereços de e-mail em cópia oculta aos parâmetros do Outlook se eles forem enviados
        If (!Empty(cBCC))
            cParam += IIf(!lStart, "&", "") + "bcc=" + AllTrim(cBCC)
            lStart := .F.
        EndIf

        // Fecha a string de parâmetros básicos do e-mail
        cParam += '"'

        // Adiciona os anexos aos parâmetros do Outlook se eles forem enviados
        If (!Empty(aAttach))
            // Se for anexado mais um arquivo, compacta todos em um único arquivo devido à limitação
            // de apenas um arquivo em anexo quando usado o Outlook através de linha de comando
            cAux := IIf(Len(aAttach) > 1, GroupFiles(aAttach), AllTrim(aAttach[1]))

            // Apenas adiciona o parâmetro de anexo se algum anexo obtido em cAux
            If (!Empty(cAux))
                cParam += ' /a "'+ cAux + '"'
            EndIf
        EndIf

        // Efetua a abertura do Outlook
        ShellExecute("OPEN", "outlook.exe", cParam, "", 1)
    END SEQUENCE
Return (NIL)

/*/{Protheus.doc} GroupFiles
    Retorna o caminho + nome de um arquivo compactado (.ZIP) contendo outros arquivos
    de diversos outros diretórios.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 22/08/2022
    @param aFile, Array, Lista de arquivos para compactação
    @return Character, Caminho completo + nome do arquivo compactado
/*/
Static Function GroupFiles(aFile As Array) As Character
    // Inicialização de variáveis
    Local nX     As Numeric   // Contador do laço de arquivos
    Local cPath  As Character // Local onde o arquivo será gerado
    Local cFile  As Character // Pasta raíz + nome do arquivo .ZIP que será gerado
    Local cSlash As Character // Barra de separação de diretórios
    Local cStamp As Character // Carimbo de tempo das pastas criadas
    Local cDrive As Character // Letra do diretório onde o arquivo à ser zipado esta contigo
    Local cDir   As Character // Diretório anterior ao arquivo que será zipado
    Local cName  As Character // Nome do arquivo que será anexado zipado
    Local cExt   As Character // Extensão do arquivo que será zipado
    Local cAux   As Character // Variável auxiliar de navegação de diretórios

    // Inicialização de variáveis
    nX     := 0
    cSlash := IIf(CValToChar(GetRemoteType()) $ "-1|2", "\", "/")
    cStamp := FwTimeStamp()
    cPath  := GetTempPath() + "totvs-outlook" + cSlash + cStamp
    cFile  := "attachments.zip"
    cDrive := ""
    cDir   := ""
    cName  := ""
    cExt   := ""
    cAux   := ""

    // Inicia a sequência de processamento
    BEGIN SEQUENCE
        // Cria o diretório caso ele não exista
        If (!File(cPath) .And. !FwMakeDir(cPath))
            Help(NIL, NIL, "OUTLOOK_CREATE_DIR", NIL, "Não foi possível criar o diretório " + cSlash + "totvs-outlook" + cSlash + cStamp + " em " + GetTempPath(),;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique as permissões do sistema para escrita neste diretório e tente novamente."})
            BREAK
        EndIf

        // Deleta o arquivo caso ele já exista na pasta
        If (File(cPath + cSlash + cFile) .And. FErase(cPath + cSlash + cFile) != -1)
            Help(NIL, NIL, "OUTLOOK_COULDNT_DELETE", NIL, "Não foi possível deletar o arquivo " + StrTokArr2(cFile, cSlash)[2] + " do diretório " + cPath + cSlash + cStamp,;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Delete o arquivo manualmente e tente realizar o envio do e-mail novamente."})
            BREAK
        EndIf

        // Percorre a lista de arquivos para anexo
        For nX := 1 To Len(aFile)
            // Captura o nome do arquivo + extensão para preparar a cópia no diretório temporário
            SplitPath(aFile[nX], @cDrive, @cDir, @cName, @cExt)
            cAux := cPath + cSlash + cName + cExt

            // Copia o arquivo para o diretório de compactação
            __CopyFile(aFile[nX], cAux)

            // Verifica se o arquivo realmente foi copiado
            If (!File(cAux))
                Help(NIL, NIL, "OUTLOOK_NOT_COPIED", NIL, "Não foi possível criar o arquivo " + cName + cExt +" para o diretório " + cPath,;
                    1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique as permissões do sistema para escrita neste diretório e tente novamente."})
                BREAK
            EndIf

            // Atualiza o vetor com o novo caminho do arquivo
            aFile[nX] := cAux
        Next

        // Compacta todos os arquivos em apenas uma pasta
        cAux := cPath + cSlash +  "attachments.zip"
        FZip(cAux, aFile, cPath)

        // Gera exceção caso o arquivo compactado não tenha sido criado
        If (!File(cAux))
            Help(NIL, NIL, "OUTLOOK_COMPACT_FILE", NIL, "Não foi possível criar o arquivo " + cFile +" no diretório " + cPath,;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique as permissões do sistema para escrita neste diretório e tente novamente."})
            BREAK
        EndIf
        cFile := cAux
    RECOVER
        // Limpa o nome de arquivo para retorno da função em caso de erro
        cFile := ""
    END SEQUENCE
Return (cFile)
