#INCLUDE 'PROTHEUS.CH'
User Function MNTA2315(cTipo)

If cTipo == 'D'	
    MsgAlert("Pneus deletados")
ElseIf cTipo == 'S'	
    MsgAlert("Pneus de saida")
ElseIf cTipo == 'T'	
    MsgAlert("Troca de Pneu")
ElseIf cTipo == 'E'	
    MsgAlert("Pneus de entrada")
EndIf

Return Nil

User Function MNTA2314(xy)
Local nT   := Len(aARTROLOC)
Local nTRB := nTamTRB+1
//A array aARRAYINI foi aumentada em algum momento do programa e agora o conteúdo está sendo //jogado na ultima posição da array 
aARTROLOCaAdd(aARTROLOC[nT],aARRAYINI[xy][nTRB])

Return Nil




USER FUNCTION MNTA2301

LOCAL CQ := ''

RETURN(CQ)

USER FUNCTION MNTA2311

LOCAL CQ := ''

RETURN(CQ)
USER FUNCTION MNTA2312

LOCAL CQ := ''

RETURN(CQ)
USER FUNCTION MNTA2313

LOCAL CQ := ''

RETURN

User Function MNTA2322()
 
    Local cOpcao := ParamIXB[1]
     
    If cOpcao = "R"
        Alert("Ponto de entrada ativo - Recape")
    ElseIf cOpcao = "S"
        Alert("Ponto de entrada ativo - Sucata")
    ElseIf cOpcao = "E"
        Alert("Ponto de entrada ativo - Estoque")
    ElseIf cOpcao = "A"
        Alert("Ponto de entrada ativo - Análise")
    EndIf
 
Return .T.

USER FUNCTION MNTA2323

LOCAL CQUERY

RETURN

USER FUNCTION MNTA2325

LOCAL CQUERY

RETURN

USER FUNCTION MNTA2326

LOCAL CQUERY

RETURN

USER FUNCTION MNTA2327

LOCAL CQUERY

RETURN
