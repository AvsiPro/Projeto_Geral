#INCLUDE 'PROTHEUS.CH'

User Function MT120TEL()
    Local aArea     := GetArea()
    Local oDlg      := PARAMIXB[1] 
    Local aPosGet   := PARAMIXB[2]
    Local nOpcx     := PARAMIXB[4]
    Local nRecPC    := PARAMIXB[5]
    Local lEdit     := IIF(nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx ==  9, .T., .F.) //Somente será editável, na Inclusão, Alteração e Cópia
    Local oXObsAux
    Local aStatusP  := {}
    Public cXObsAux := ""
    Public cOpcao
    
    //;;;;;;;                                  
    aAdd(aStatusP , "1=Padrao")
    aAdd(aStatusP , "2=Emergencial")
    aAdd(aStatusP , "3=Teste")
    aAdd(aStatusP , "4=Prova de Conceito")
    aAdd(aStatusP , "5=Regularização")
    aAdd(aStatusP , "6=VTR")
    aAdd(aStatusP , "7=Contratação Direta")

    //cOpcao := aStatusP[1]
    //Define o conteúdo para os campos
    SC7->(DbGoTo(nRecPC))
    If nOpcx == 3
        cOpcao := CriaVar("C7_ZTPCOM",.F.)
    Else
        cOpcao := SC7->C7_ZTPCOM
    EndIf
 
    //Criando na janela o campo OBS
    @ 062, aPosGet[1,08] - 012 SAY Alltrim(RetTitle("C7_ZTPCOM")) OF oDlg PIXEL SIZE 050,006
    //@ 061, aPosGet[1,09] - 006 MSGET oXObsAux VAR cXObsAux SIZE 100, 006 OF oDlg COLORS 0, 16777215  PIXEL
    //oXObsAux:bHelp := {|| ShowHelpCpo( "C7_ZTPCOM", {GetHlpSoluc("C7_ZTPCOM")[1]}, 5  )}

    
    @ 061, aPosGet[1,09] MSCOMBOBOX oEdit1 VAR cOpcao ITEMS aStatusP SIZE 140, 013 OF oDlg PIXEL COLORS 0, 16777215
 
   
 
    RestArea(aArea)
Return
  
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MTA120G2                                                                                              |
 | Desc:  Ponto de Entrada para gravar informações no pedido de compra a cada item (usado junto com MT120TEL)   |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085572                                          |
 *--------------------------------------------------------------------------------------------------------------*/
  
User Function MTA120G2()
    Local aArea := GetArea()
 
    //Atualiza a descrição, com a variável pública criada no ponto de entrada MT120TEL
    SC7->C7_ZTPCOM := cXObsAux
 
    RestArea(aArea)
Return
