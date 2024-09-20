#INCLUDE 'PROTHEUS.CH'
/*
    PNEU002
    Ponto de entrada para incluir pneu no estoque correto de acordo com cadatro
    11/06/24 - Foi solicitado para que o conteúdo do estoque seja fixo em 08 através da atualização da mit pneu002
*/
User function MNTA2319

LOCAL aArea     := GetArea()
Local aPneu     := Paramixb
Local aRet      := {}
//Local aStatus   := {'10','08','04','09'}
Local nPos      := 0
Local aStatus   := {}
Local aItens    := SuperGetMV("TI_NGSOPC",.F.,"MV_NGSTAGR/MV_NGSTAGC/MV_NGSTAEU/MV_NGSTAEN")
Local aDados    := {}
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


If M->TQY_STATUS <> '08'
    M->TQY_STATUS := '08'
    MsgAlert("O Estoque de destino deve ser obrigatoriamente o 08","MNTA2319")

EndIf 

nPos := Ascan(aStatus,{|x| x == TQY_STATUS })

If nPos > 0
    DbSelectArea("ST9")
    DbSetOrder(1)
    If Dbseek(xFilial("ST9")+aPneu[1])
        If nPos == 1
            Aadd(aRet,ST9->T9_XMATNOV)
        ElseIf nPos == 2    
            Aadd(aRet,ST9->T9_XMATUSA)
        ElseIf nPos == 3
            Aadd(aRet,ST9->T9_XMATCON)
        ElseIf nPos == 4
            Aadd(aRet,ST9->T9_XMATREF)
        EndIf 
        
        Aadd(aRet,Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_LOCPAD"))

        DbSelectArea("SB2")
        DbSetOrder(1)
        If !DbSeek(xFilial("SB2")+aRet[1]+aRet[2])
            CriaSB2(aRet[1],aRet[2])
        EndIf
    EndIf 
EndIf

RestArea(aArea)

Return(aRet)


