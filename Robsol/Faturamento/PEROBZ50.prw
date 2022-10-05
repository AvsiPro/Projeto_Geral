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

        aAdd(xRet, {"Imagens Enviadas", "", {|| fAbreImg() }, "Tooltip 1"})
    EndIf
EndIf

Return xRet


/*/{Protheus.doc} fAbreImg
    @description Abrir imagens enviadas via chamado
    @type Static Function
    @author Felipe Mayer
    @since 04/10/2022
/*/
Static Function fAbreImg()

Local nX         := 0
Local oModelx    := FWModelActive()
Local oModelxDet := oModelx:GetModel('FORMZ50')
Local cChamado   := 'chamado_'+oModelxDet:getValue('Z50_CODIGO')
Local cDir       := '\updchamados\'
Local aFiles     := Directory(cDir+cChamado+"\*.*", "D")
Local cTemp      := GetTempPath()
Local nCount     := Len(aFiles)

    For nX := 1 to nCount
        If aFiles[nX,2] > 0
            CpyS2T(cDir+cChamado+"\"+aFiles[nX,1],cTemp,.F.)
            Sleep(500)
        
            If File(cTemp+ aFiles[nX,1])
                ShellExecute("OPEN", aFiles[nX,1], "", cTemp, 1)
            EndIf
        EndIf
    Next nX

Return
