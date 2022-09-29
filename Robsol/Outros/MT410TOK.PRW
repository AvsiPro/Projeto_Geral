#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH" 

User Function MT410TOK()

Local _nX       := 0
Local _nOPC     := PARAMIXB[1]
Local nPosTOT   := ASCAN(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPosQTD   := ASCAN(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPosDSC   := ASCAN(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local _nTotQTD  := 0
Local _nTotVAL  := 0
Local _nTotDSC  := 0

Local lRet      := .T.

If _nOPC == 3 .OR. _nOPC == 4 //3=Inclusão / 4=Alteração
    For _nX := 1 To LEN(aCols)
        _nTotQTD += aCols[_nX][nPosQTD]
        _nTotVAL += aCols[_nX][nPosTOT]
        _nTotDSC += aCols[_nX][nPosDSC]
    Next _nX
EndIf

M->C5_XQUANT    := _nTotQTD
M->C5_XTOTAL    := _nTotVAL
M->C5_XTOTDES   := _nTotDSC

Return lRet
