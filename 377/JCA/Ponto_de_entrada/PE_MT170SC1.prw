#INCLUDE 'PROTHEUS.CH'
/*
    Informa��es complementares ao finaliza��o solicita��o por ponto de pedido
*/
User Function MT170SC1

    Local aArea     := GetArea()
    Local aPergs    :=  {}
    Local aRet      :=  {}
    Local cTipSol   :=  '1'
    Local aStatusP  :=  {}
    Local aCombo    :=  RetSX3Box(GetSX3Cache("C1_XTIPCOT", "X3_CBOX"),,,1)

    Aeval(aCombo,{|x| Aadd(aStatusP,x[1]) })

    aAdd(aPergs ,{2,"Tipo Solicita��o "+SC1->C1_PRODUTO	,"", aStatusP,50,'',.T.})

	
    If ParamBox(aPergs ,"Tipo de solicita��o",@aRet)
        cTipSol := aRet[1]
    EndIf 

    Reclock("SC1",.F.)
    SC1->C1_OBS     := 'SC gerada por ponto de pedido'
    SC1->C1_XTIPCOT := cTipSol
    SC1->C1_XTPPROD := Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_TIPO") 
    SC1->(Msunlock())

    FWAlertSuccess("MT170SC1 - Gerada a solicta��o de numero : "+SC1->C1_NUM,"Aten��o")

    RestArea(aArea)

Return




