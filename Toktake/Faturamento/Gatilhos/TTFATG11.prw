
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFATG11  ºAutor  ³Jackson E. de Deus  º Data ³  08/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho utilizado para validar quantidade fracionada       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTFATG11()
      
Local CRLF := CHR(13)+CHR(10)
Local _nFator	:= SB1->B1_CONV	
Local _cMsg


// Tratamento para AMC
If cEmpAnt == "10"
	Return M->C6_QTDVEN
EndIf


_cMsg	:= "Não é permitida quantidade fracionada!" + CRLF
_cMsg	+= "Fator de Conversão: " + Str(_nFator)                                                                                     

If !IsInCallStack("U_TTEDI100") .And. !IsInCallStack("U_TSTPV") .And. !IsInCallStack("U_MT100AGR") .And. !IsInCallStack("U_DIVSF1") .And. !IsIncallstack("CNTA120")
	
	// Módulo da divisao
	If M->C6_QTDVEN % _nFator <> 0
		
		AVISO("TTFATG11",_cMsg,{"Ok"},1)
		M->C6_QTDVEN := 0
		               
		U_TTFAT04C()
		
		Return M->C6_QTDVEN
	Else            
	
		U_TTFAT04C()
		Return M->C6_QTDVEN
		
	EndIf
	
EndIf


Return M->C6_QTDVEN