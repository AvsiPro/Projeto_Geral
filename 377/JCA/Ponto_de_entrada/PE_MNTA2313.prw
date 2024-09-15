#INCLUDE 'PROTHEUS.CH'
/*
    PNEU002
    Ponto de entrada para incluir pneu no estoque correto de acordo com cadatro
    20/08/24 - Toninho solicitou ajustar o ponto de entrada, pois o 2319 só estava fazendo o tratamento
    de movimentar o item quando a opção estoque de novos era selecionada
*/

User function MNTA2313

LOCAL aArea     := GetArea()
Local aRet      := {}
Local lRet      := .T.
Local nPos      := 0
Local aStatus   := {}
Local _atotitem := {}
Local _aCab1    := {}
Local aItemD3   := {}
Local aItens    := SuperGetMV("TI_NGSOPC",.F.,"MV_NGSTAGR/MV_NGSTAGC/MV_NGSTAEU/MV_NGSTAEN")
Local aDados    := {}
Private lMsErroAuto := .f.
/*
Reforma: MV_NGSTAGR = 02    //AGUARDANDO REFORMA
Conserto: MV_NGSTAGC = 03   //AGUARDANDO CONSERTO
Usado: MV_NGSTAEU = 08      //ESTOQUE USADO
Novo: MV_NGSTAEN = 10       //ESTOQUE NOVO
*/

aDados := separa(aItens,"/")

For nPos := 1 to len(aDados)
    cOpcao := ""
    cOpcao := alltrim(SuperGetMV(aDados[nPos],.f.,""))
    Aadd(aStatus,cOpcao)
Next nPos 

nPos := Ascan(aStatus,{|x| x == TQY_STATUS })

If nPos > 0
    DbSelectArea("ST9")
    DbSetOrder(1)
    If Dbseek(xFilial("ST9")+cPneu)
        If nPos == 1
            Aadd(aRet,ST9->T9_XMATNOV)
        ElseIf nPos == 2    
            Aadd(aRet,ST9->T9_XMATUSA)
        ElseIf nPos == 3
            Aadd(aRet,ST9->T9_XMATCON)
        ElseIf nPos == 4
            Aadd(aRet,ST9->T9_XMATREF)
        EndIf 

        DbSelectArea("SB1")
        DbSetOrder(1)
        Dbseek(xFilial("SB1")+aRet[1])

        //Aadd(aRet,Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_LOCPAD"))
        Aadd(aRet,SB1->B1_LOCPAD)

        DbSelectArea("SB2")
        DbSetOrder(1)
        If !DbSeek(xFilial("SB2")+aRet[1]+aRet[2])
            CriaSB2(aRet[1],aRet[2])
        EndIf

        _aCab1 := {{"D3_DOC" ,NextNumero("SD3",2,"D3_DOC",.T.), NIL},;
                    {"D3_TM" ,'002' , NIL},;
                    {"D3_CC" ,M->TP9_CCUSTO, NIL},;
                    {"D3_EMISSAO" ,ddatabase, NIL}}


        aItemD3:={{"D3_COD"  ,aRet[1]                ,NIL},;
                {"D3_UM"    ,SB1->B1_UM             ,NIL},; 
                {"D3_QUANT" ,1                      ,NIL},;
                {"D3_LOCAL" ,aRet[2]                ,NIL},;
                {"D3_CONTA" ,SB1->B1_CONTA          ,NIL},;
                {"D3_OP"    ,CNUMOS+"OS001"   ,NIL}}

        aadd(_atotitem,aItemD3) 

        MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
        
        If lMsErroAuto 
            Mostraerro() 
            lRet := .f.
        EndIF 

    EndIf 
EndIf

RestArea(aArea)

Return(lRet)
