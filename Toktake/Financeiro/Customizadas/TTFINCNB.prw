#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINCNB  ºAutor  ³Microsiga           º Data ³  12/22/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenchimento do campo codigo da empresa no cnab Santander º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTFINCNB()

Local aArea	:=	GetArea()
Local cRet	:=	''

cRet := Alltrim(SEE->EE_AGENCIA)
cRet += strzero(val(substr(SEE->EE_CODEMP,1,7)),8)
cRet += strzero(val(substr(SEE->EE_CONTA,1,7)),8)
  
/*
0643
05297362
01300180 */  

RestArea(aArea)

Return(cRet)

User Function TTFINCJR(nOpc)

Local aArea	:=	Getarea()
Local cRet	:=	''

If nOpc == 1
	If SE1->E1_VALJUR > 0
		cRet := STRZERO(INT(SE1->E1_VALJUR*100),13)
	Else
		cRet := If(SE1->E1_PORTADO=="001",STRZERO(((SE1->E1_VALOR * GETMV("MV_XTAXA"))/30)*100,13),STRZERO((SE1->E1_VALOR * GETMV("MV_XTAXA")/30),13))
	EndIf
ElseIf nOpc == 2
	If SE1->E1_PORTADO == "341" .OR. SE1->E1_PORTADO == "001"
		cRet := STRZERO(GETMV("MV_XMULTA")*100,IF(SE1->E1_PORTADO == "341",13,12))
	Else 
		cRet := STRZERO(GETMV("MV_XMULTA")*100,4)
		
	EndIF
Else
	cRet := dtos(SE1->E1_VENCREA+1)
	cRet := substr(cRet,7,2)+substr(cRet,5,2)+IF(SE1->E1_PORTADO <> "001",substr(cRet,1,4),substr(cRet,3,2))
EndIf

RestArea(aArea)

Return(cRet)