#INCLUDE 'PROTHEUS.CH'
/*
    Informações complementares ao finalização solicitação por ponto de pedido
*/
User Function MT170SC1

    Local aArea     := GetArea()
    Local aPergs    :=  {}
    Local aRet      :=  {}
    Local cTipSol   :=  '1'
    Local aStatusP  :=  {}
    Local aCombo    :=  RetSX3Box(GetSX3Cache("C1_XTIPCOT", "X3_CBOX"),,,1)

    Aeval(aCombo,{|x| Aadd(aStatusP,x[1]) })

    aAdd(aPergs ,{2,"Tipo Solicitação "+SC1->C1_PRODUTO	,"", aStatusP,50,'',.T.})

	
    If ParamBox(aPergs ,"Tipo de solicitação",@aRet)
        cTipSol := aRet[1]
    EndIf 

    Reclock("SC1",.F.)
    SC1->C1_OBS     := 'SC gerada por ponto de pedido'
    SC1->C1_XTIPCOT := cTipSol
    SC1->C1_XTPPROD := Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_TIPO") 
    SC1->(Msunlock())

    FWAlertSuccess("MT170SC1 - Gerada a solictação de numero : "+SC1->C1_NUM,"Atenção")

    RestArea(aArea)

Return




