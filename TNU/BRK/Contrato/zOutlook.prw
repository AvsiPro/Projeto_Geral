#Include "Protheus.ch"

User Function zOutlook(aEmail)

/*---------------------------
aEmail[1] -> Destinat?io
aEmail[2] -> Assunto
aEmail[3] -> Corpo E-mail
aEmail[4] -> Copia
aEmail[5] -> Copia Oculta
aEmail[6] -> Caminho do Arquivo Anexo
aEmail[7] -> Email remetente
----------------------------*/

    Local cExecute  := "/c ipm.note /m "
    Local cLocal    := ""
    Local cAss      := aEmail[2]
    Local cEmail    := aEmail[1]
    Local _cArquivo := aEmail[6]
    Local lret      := .f.

    If !Empty(Alltrim(cEmail))
    
        cLocal := GetTempPath()+"totvsprinter\"+_cArquivo

        //cAss   += StrTran(Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,'A2_NOME')), " ", "%20")
        cExecute += '"faturamento@brktecnologia.com.br?subject='+aEmail[2]+'&body='+aEmail[3] 
        cExecute += '%20&bcc='+aEmail[4]+''
        cExecute += '" /a "'+cLocal+'"'
        //Sleep( 10000 )
        ShellExecute("OPEN", "outlook.exe", cExecute, "", 1)
        Sleep( 6000 )
        lret := .t.
    Else
        MSGINFO("Fornecedor sem Email cadastrado!")    
    EndIf
Return(lret)
