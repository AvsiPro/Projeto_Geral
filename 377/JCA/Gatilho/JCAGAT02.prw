#INCLUDE 'PROTHEUS.CH'
/*
    xx Gatilho campo Grupo para produto para criar sequencial do codigo de acordo
    xx com grupo selecionado
    xxxMIT 44_ESTOQUE_EST001 - Codificação de Produtos
    xxxhttps://docs.google.com/document/d/10vxbtI4iBcPuf7l3qImxY1BYB1OKtP3Q/edit
    
*/
User Function JCAGAT02()

Local aAuxX3 := {}
Local nCont  := 1
Local cTabela:= "SB1"
Local aHoBrw1:= {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

If DbSeek(xFilial("SB1")+SB1->B1_COD) //

    //aAuxX3 := FWSX3Util():GetAllFields( cTabela , .F. )
    aAuxX3 := FWSX3Util():GetListFieldsStruct( cTabela , .F. )

    For nCont := 1 to len(aAuxX3)
        lUsado := X3USO(GetSX3Cache(aAuxX3[nCont,1], "X3_USADO"))
        If lUsado
            Aadd(aHoBrw1,{aAuxX3[nCont,1],&("SB1->"+aAuxX3[nCont,1])})
        EndIf
    Next nCont

    oModel  := FwLoadModel ("MATA010")
    oModel:SetOperation(3) //MODEL_OPERATION_INSERT
    oModel:Activate()

    oModel:SetValue("SB1MASTER","B1_COD"      ,'01030001-899')
    
    For nCont := 1 to len(aHoBrw1)
        //&("M->"+aHoBrw1[nCont,01]) := aHoBrw1[nCont,02]
        If !Alltrim(aHoBrw1[nCont,01]) $ 'B1_COD/B1_GRADE/B1_OK/B1_INTEG/B1_ZMARCA'
            oModel:SetValue("SB1MASTER",aHoBrw1[nCont,01]      ,aHoBrw1[nCont,02])
        EndIf
    Next nCont
    
    
    If oModel:VldData()
        oModel:CommitData()
        MsgAlert("Registro INCLUIDO!", "Atenção")
    Else
        VarInfo("",oModel:GetErrorMessage())
    EndIf       

    oModel:DeActivate()
    oModel:Destroy()

    oModel := NIL
else 
    MsgAlert("Código Pai inexistente")
EndIf 

Return
