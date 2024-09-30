#INCLUDE 'PROTHEUS.CH'
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT125TEL                                                                                               |
 | Desc:  Se encontra dentro da rotina que monta a dialog do contrato de parceria antes  da montagem dos folders.   |
 | Link:  https://tdn.totvs.com/display/public/PROT/MT125TEL                                       |
 | Requi: Leonardo, vedido a erro ao gerar autoriza��o de entrega manual 10/09/2024 Rodrigo Barreto
  *--------------------------------------------------------------------------------------------------------------*/
  
User Function MT125TEL()
    Local aArea     := GetArea()
    Local oDlg      := PARAMIXB[1] 
    Local aPosGet   := PARAMIXB[2]
    Local nOpcx     := PARAMIXB[4]
    Local nRecPC    := PARAMIXB[5]
    Local aStatusP  := {}
    Private aCombo   := RetSX3Box(GetSX3Cache("C1_XTIPCOT", "X3_CBOX"),,,1)

    Public cXObsAux := ""
    Public cOpcao

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
    SC3->(DbGoTo(nRecPC))
    If nOpcx == 3
        cXObsAux := CriaVar("C3_XTIPCOT",.F.)
    Else
        cXObsAux := SC3->C3_XTIPCOT
    EndIf
 
    //Criando na janela o campo OBS
    @ 065, aPosGet[1,07] - 450 SAY "Tipo de Compra" OF oDlg PIXEL SIZE 050,006    
    
    @ 066, aPosGet[1,08] - 250 MSCOMBOBOX oEdit1 VAR cXObsAux ITEMS aStatusP SIZE 140, 013 OF oDlg PIXEL COLORS 0, 16777215
 
    RestArea(aArea)
Return
  
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT125GRV                                                                                              |
 | Desc:  Ponto de Entrada para gravar informa��es no pedido de compra a cada item (usado junto com MT120TEL)   |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085572                                          |
 *--------------------------------------------------------------------------------------------------------------*/
  
User Function MT125GRV()
    Local aArea := GetArea()
    
    If !"CNTA" $ Funname()
    //Atualiza a descri��o, com a vari�vel p�blica criada no ponto de entrada MT125TEL
        IF type('cXObsAux') != 'U'
            SC7->C7_ZTPCOM := cXObsAux
        ELSEIF Funname() == "MATA173"
            SC7->C7_ZTPCOM := SC3->C3_XTIPCOT
        ENDIF
    EndIf 
    
    RestArea(aArea)
Return
