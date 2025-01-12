#INCLUDE 'PROTHEUS.CH'
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT120TEL                                                                                              |
 | Desc:  Ponto de Entrada para gravar informa��es no pedido de compra a cada item (usado junto com MTA120G2)   |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085572                                          |
 *--------------------------------------------------------------------------------------------------------------*/
  
User Function MT120TEL()
    Local aArea     := GetArea()
    Local oDlg      := PARAMIXB[1] 
    Local aPosGet   := PARAMIXB[2]
    Local nOpcx     := PARAMIXB[4]
    Local nRecPC    := PARAMIXB[5]
    Local aStatusP  := {}
    Private aCombo   := RetSX3Box(GetSX3Cache("C1_XTIPCOT", "X3_CBOX"),,,1)

    Public cXObsAux := ""
    //Public cOpcao

    Aeval(aCombo,{|x| Aadd(aStatusP,x[1]) })
    //;;;;;;;
    /*                                  
    aAdd(aStatusP , "1=Padrao")
    aAdd(aStatusP , "2=Emergencial")
    aAdd(aStatusP , "3=Estrategico")
    aAdd(aStatusP , "4=Planejado")
    aAdd(aStatusP , "5=Regulariza��o")
    aAdd(aStatusP , "6=VTR")*/
    //aAdd(aStatusP , "7=Contrata��o Direta")

    //cOpcao := aStatusP[1]
    //Define o conte�do para os campos
    SC7->(DbGoTo(nRecPC))
    If nOpcx == 3
        cXObsAux := CriaVar("C7_ZTPCOM",.F.)
    Else
        cXObsAux := SC7->C7_ZTPCOM
    EndIf
 
    //Criando na janela o campo OBS
    @ 062, aPosGet[1,08] - 012 SAY Alltrim(RetTitle("C7_ZTPCOM")) OF oDlg PIXEL SIZE 050,006
    
    
    @ 061, aPosGet[1,09] MSCOMBOBOX oEdit1 VAR cXObsAux ITEMS aStatusP SIZE 140, 013 OF oDlg PIXEL COLORS 0, 16777215
 
   
 
    RestArea(aArea)
Return
  
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MTA120G2                                                                                              |
 | Desc:  Ponto de Entrada para gravar informa��es no pedido de compra a cada item (usado junto com MT120TEL)   |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085572                                          |
 *--------------------------------------------------------------------------------------------------------------*/
  
User Function MTA120G2()
    Local aArea := GetArea()
    
    If !"CNTA" $ Funname()
    //Atualiza a descri��o, com a vari�vel p�blica criada no ponto de entrada MT120TEL
        IF type('cXObsAux') != 'U'
            SC7->C7_ZTPCOM := cXObsAux
        ELSEIF Funname() == "MATA173"
            SC7->C7_ZTPCOM := SC3->C3_XTIPCOT
        ENDIF
    EndIf 

    RestArea(aArea)
Return
