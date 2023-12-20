#INCLUDE 'PROTHEUS.CH'

User Function MT120TEL()
    Local aArea     := GetArea()
    Local oDlg      := PARAMIXB[1] 
    Local aPosGet   := PARAMIXB[2]
    Local nOpcx     := PARAMIXB[4]
    Local nRecPC    := PARAMIXB[5]
    Local aStatusP  := {}
    Public cXObsAux := ""
    Public cOpcAD
                                     
    aAdd(aStatusP , "1=Sim")
    aAdd(aStatusP , "2=Não")

    //cOpcAD := aStatusP[1]
    //Define o conteúdo para os campos
    SC7->(DbGoTo(nRecPC))
    If nOpcx == 3
        cOpcAD := CriaVar("C7_XAD",.F.)
        
    Else
        cOpcAD := SC7->C7_XAD
    EndIf

    If Empty(cOpcAD)
        cOpcAD := '2'
    EndIf 
 
    //Criando na janela o campo OBS
    @ 062, aPosGet[1,08] - 012 SAY Alltrim(RetTitle("C7_XAD")) OF oDlg PIXEL SIZE 050,006
    
    
    @ 061, aPosGet[1,09] MSCOMBOBOX oEdit1 VAR cOpcAD ITEMS aStatusP SIZE 060, 012 OF oDlg PIXEL COLORS 0, 16777215
 
   
 
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
    SC7->C7_XAD := cOpcAD
 
    RestArea(aArea)
Return
