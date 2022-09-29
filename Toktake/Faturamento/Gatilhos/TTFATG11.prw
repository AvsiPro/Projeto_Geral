
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATG11  �Autor  �Jackson E. de Deus  � Data �  08/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho utilizado para validar quantidade fracionada       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFATG11()
      
Local CRLF := CHR(13)+CHR(10)
Local _nFator	:= SB1->B1_CONV	
Local _cMsg


// Tratamento para AMC
If cEmpAnt == "10"
	Return M->C6_QTDVEN
EndIf


_cMsg	:= "N�o � permitida quantidade fracionada!" + CRLF
_cMsg	+= "Fator de Convers�o: " + Str(_nFator)                                                                                     

If !IsInCallStack("U_TTEDI100") .And. !IsInCallStack("U_TSTPV") .And. !IsInCallStack("U_MT100AGR") .And. !IsInCallStack("U_DIVSF1") .And. !IsIncallstack("CNTA120")
	
	// M�dulo da divisao
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