#include "totvs.ch"  
 
User Function SPED1400()
 
//Local dDataDe       := ParamIXB[1] // Parametro data De
//Local dDataAte      := ParamIXB[2] // Parametro data até
//Local cFilDe        := ParamIXB[3] // Parametro Filial De
//Local cFilAte       := ParamIXB[4] // Parametro Filial Até
//Local aLisFil       := ParamIXB[5] // Lista de filiais selecionadas (Pergunta: Seleciona Filial = SIM)
Local aMyReg1400    := {}               //  DADOS DO REGISTRO 1400
Local nPos          := 0
Local nX 

If len(ParamIXB) > 5
	For nX := 1 to len(ParamIXB[6])
		aAdd(aMyReg1400, {})
		
		nPos   :=     Len(aMyReg1400)  
		
		aAdd (aMyReg1400[nPos], ParamIXB[6,nX,01])                     //01 - REG
		aAdd (aMyReg1400[nPos], "SPDIPAM11")                           //02 - COD_ITEM_IPM  
		aAdd (aMyReg1400[nPos], ParamIXB[6,nX,03])                     //03 - MUN  
		aAdd (aMyReg1400[nPos], ParamIXB[6,nX,04])                     //04 - VALOR
	Next nX
EndIf
  
Return aMyReg1400
