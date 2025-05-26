// Bibliotecas necess�rias
#Include "TOTVS.ch"

/*/{Protheus.doc} OUTLOOK
    Respons�vel pela abertura do Outlook para envio de um novo e-mail.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 21/08/2022
    @param cTo, Character, E-mails de destino da mensagem
    @param cSubject, Character, Assunto do e-mail a ser enviado
    @param aAttach, Array, Arquivos para envio como anexo
    @param cBody, Character, Corpo do e-mail para envio
    @param cCC, Character, E-mails enviados como "em c�pia" (carbon copy)
    @param cBCC, Character, E-mails enviados como "em c�pia oculta" (blind carbon copy)
    @return Variant, Retorno nulo fixado
    @link https://support.microsoft.com/en-us/office/command-line-switches-for-microsoft-office-products-079164cd-4ef5-4178-b235-441737deb3a6
/*/
User Function OUTLOOK(cTo As Character, cSubject As Character, aAttach As Array, cBody As Character, cCC As Character, cBCC As Character) As Variant
    // Vari�veis locais
    Local cAux   As Character // Auxiliar de montagem dos nome dos anexo
    Local cParam As Character // Linha de comando para envio ao execut�vel do Outlook
    Local lStart As Logical   // Flag de concatena��o de par�metros do Outlook

    // Inicializa��o padr�o de par�metros
    Default cTo      := ""
    Default cSubject := ""
    Default aAttach  := {}
    Default cBody    := ""
    Default cCC      := ""
    Default cBCC     := ""

    // Inicializa��o de var�aveis
    cAux   := ""
    cParam := "/c ipm.note "
    lStart := .T.

    // Inicia a sequ�ncia de preenchimento de par�metros
    BEGIN SEQUENCE
        // Adiciona os e-mails de destino aos par�metros do Outlook
        If (!Empty(cTo))
            cParam += '/m "' + AllTrim(cTo) + "?"
        Else
            Help(NIL, NIL, "OUTLOOK_EMPTY_EMAIL", NIL, "O e-mail do destinat�rio � obrigat�rio para prosseguir com o envio.",;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique a origem do conte�do enviado no primeiro par�metro da fun��o e tente novamente."})
            BREAK
        EndIf

        // Adiciona o assunto aos par�metros do Outlook se ele for enviado
        If (!Empty(cSubject))
            cParam += "subject=" + Escape(AllTrim(cSubject))
            lStart := .F.
        EndIf

        // Converte os saltos de linha do corpo do e-mail e anexo aos par�metros se ele for enviado
        If (!Empty(cBody))
            cBody  := StrTran(cBody, CRLF, "%0D%0A")
            cParam += IIf(!lStart, "&", "") + "body=" + AllTrim(Escape(cBody))
            lStart := .F.
        EndIf

        // Adiciona os endere�os de e-mail em c�pia aos par�metros do Outlook se eles forem enviados
        If (!Empty(cCC))
            cParam += IIf(!lStart, "&", "") + "cc=" + AllTrim(cCC)
            lStart := .F.
        EndIf

        // Adiciona os endere�os de e-mail em c�pia oculta aos par�metros do Outlook se eles forem enviados
        If (!Empty(cBCC))
            cParam += IIf(!lStart, "&", "") + "bcc=" + AllTrim(cBCC)
            lStart := .F.
        EndIf

        // Fecha a string de par�metros b�sicos do e-mail
        cParam += '"'

        // Adiciona os anexos aos par�metros do Outlook se eles forem enviados
        If (!Empty(aAttach))
            // Se for anexado mais um arquivo, compacta todos em um �nico arquivo devido � limita��o
            // de apenas um arquivo em anexo quando usado o Outlook atrav�s de linha de comando
            cAux := IIf(Len(aAttach) > 1, GroupFiles(aAttach), AllTrim(aAttach[1]))

            // Apenas adiciona o par�metro de anexo se algum anexo obtido em cAux
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
    de diversos outros diret�rios.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 22/08/2022
    @param aFile, Array, Lista de arquivos para compacta��o
    @return Character, Caminho completo + nome do arquivo compactado
/*/
Static Function GroupFiles(aFile As Array) As Character
    // Inicializa��o de vari�veis
    Local nX     As Numeric   // Contador do la�o de arquivos
    Local cPath  As Character // Local onde o arquivo ser� gerado
    Local cFile  As Character // Pasta ra�z + nome do arquivo .ZIP que ser� gerado
    Local cSlash As Character // Barra de separa��o de diret�rios
    Local cStamp As Character // Carimbo de tempo das pastas criadas
    Local cDrive As Character // Letra do diret�rio onde o arquivo � ser zipado esta contigo
    Local cDir   As Character // Diret�rio anterior ao arquivo que ser� zipado
    Local cName  As Character // Nome do arquivo que ser� anexado zipado
    Local cExt   As Character // Extens�o do arquivo que ser� zipado
    Local cAux   As Character // Vari�vel auxiliar de navega��o de diret�rios

    // Inicializa��o de vari�veis
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

    // Inicia a sequ�ncia de processamento
    BEGIN SEQUENCE
        // Cria o diret�rio caso ele n�o exista
        If (!File(cPath) .And. !FwMakeDir(cPath))
            Help(NIL, NIL, "OUTLOOK_CREATE_DIR", NIL, "N�o foi poss�vel criar o diret�rio " + cSlash + "totvs-outlook" + cSlash + cStamp + " em " + GetTempPath(),;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique as permiss�es do sistema para escrita neste diret�rio e tente novamente."})
            BREAK
        EndIf

        // Deleta o arquivo caso ele j� exista na pasta
        If (File(cPath + cSlash + cFile) .And. FErase(cPath + cSlash + cFile) != -1)
            Help(NIL, NIL, "OUTLOOK_COULDNT_DELETE", NIL, "N�o foi poss�vel deletar o arquivo " + StrTokArr2(cFile, cSlash)[2] + " do diret�rio " + cPath + cSlash + cStamp,;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Delete o arquivo manualmente e tente realizar o envio do e-mail novamente."})
            BREAK
        EndIf

        // Percorre a lista de arquivos para anexo
        For nX := 1 To Len(aFile)
            // Captura o nome do arquivo + extens�o para preparar a c�pia no diret�rio tempor�rio
            SplitPath(aFile[nX], @cDrive, @cDir, @cName, @cExt)
            cAux := cPath + cSlash + cName + cExt

            // Copia o arquivo para o diret�rio de compacta��o
            __CopyFile(aFile[nX], cAux)

            // Verifica se o arquivo realmente foi copiado
            If (!File(cAux))
                Help(NIL, NIL, "OUTLOOK_NOT_COPIED", NIL, "N�o foi poss�vel criar o arquivo " + cName + cExt +" para o diret�rio " + cPath,;
                    1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique as permiss�es do sistema para escrita neste diret�rio e tente novamente."})
                BREAK
            EndIf

            // Atualiza o vetor com o novo caminho do arquivo
            aFile[nX] := cAux
        Next

        // Compacta todos os arquivos em apenas uma pasta
        cAux := cPath + cSlash +  "attachments.zip"
        FZip(cAux, aFile, cPath)

        // Gera exce��o caso o arquivo compactado n�o tenha sido criado
        If (!File(cAux))
            Help(NIL, NIL, "OUTLOOK_COMPACT_FILE", NIL, "N�o foi poss�vel criar o arquivo " + cFile +" no diret�rio " + cPath,;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique as permiss�es do sistema para escrita neste diret�rio e tente novamente."})
            BREAK
        EndIf
        cFile := cAux
    RECOVER
        // Limpa o nome de arquivo para retorno da fun��o em caso de erro
        cFile := ""
    END SEQUENCE
Return (cFile)
