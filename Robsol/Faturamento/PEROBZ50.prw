#Include 'PROTHEUS.CH'
#Include 'PARMTYPE.CH'

/*/{Protheus.doc} ROBZ50M
    @description Ponto de entrada tela MVC ROBZ50
    @type User Function
    @author Felipe Mayer
    @since 04/10/2022
/*/
User Function ROBZ50M()

Local aParam := PARAMIXB
Local xRet := .T.
Local oObj := ''
Local cIdPonto := ''
 
If aParam <> NIL
    oObj := aParam[1]
    cIdPonto := aParam[2]

    If cIdPonto == 'BUTTONBAR'
        xRet := {}

        aAdd(xRet, {"Imagens Enviadas", "", {|| Processa( {||  U_fAbreImg() }, "Processando Imagens..." ) }, "Tooltip 1"})
    EndIf
EndIf

Return xRet


/*/{Protheus.doc} fAbreImg
    @description Abrir imagens enviadas via chamado
    @type User Function
    @author Felipe Mayer
    @since 04/10/2022
/*/
User Function fAbreImg(cCodigo)

Local nX         := 0
Local oModelx    := nil
Local oModelxDet := nil
Local cChamado   := ''
Local cDir       := '\updchamados\'
Local aFiles     := {}
Local cTemp      := GetTempPath()
Local nCount     := 0

Default cCodigo  := ''

    If Empty(cCodigo)
        oModelx    := FWModelActive()
        oModelxDet := oModelx:GetModel('FORMZ50')
        cChamado   := 'chamado_'+oModelxDet:getValue('Z50_CODIGO')
    Else
        cChamado := 'chamado_'+cCodigo
    EndIf

    aFiles     := Directory(cDir+cChamado+"\*.*", "D")
    nCount     := Len(aFiles)

    For nX := 1 to nCount
        If aFiles[nX,2] > 0
            CpyS2T(cDir+cChamado+"\"+aFiles[nX,1],cTemp,.F.)
            Sleep(500)
        
            If File(cTemp+ aFiles[nX,1]) .And. Alltrim(Upper(aFiles[nX,1])) != 'NOTIFICATION.TXT'
                ShellExecute("OPEN", aFiles[nX,1], "", cTemp, 1)
            EndIf
        EndIf
    Next nX

Return
