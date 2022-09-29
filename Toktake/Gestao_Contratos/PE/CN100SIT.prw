#DEFINE DEF_SCANC '01' //Cancelado
#DEFINE DEF_SELAB '02' //Em Elabora��o
#DEFINE DEF_SEMIT '03' //Emitido
#DEFINE DEF_SAPRO '04' //Em Aprova��o
#DEFINE DEF_SVIGE '05' //Vigente
#DEFINE DEF_SPARA '06' //Paralisado
#DEFINE DEF_SSPAR '07' //Sol Fina.
#DEFINE DEF_SFINA '08' //Finalizado
#DEFINE DEF_SREVS '09' //Revis�o  
#DEFINE DEF_SREVD '10'//Revisado

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CN100SIT  �Autor  �Microsiga           � Data �  08/21/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE Utilizado para gravar a data correta de assinatura do   ���
���          �contrato quando ele se tornar vigente;                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CN100SIT()
Local cAtu := PARAMIXB[1]
Local cDst := PARAMIXB[2]
Local aParamBox := {}        
Local dDtLibI	:=	ctod('  /  /  ')
Local aRet 		:= {}

If cEmpAnt == "01"
	
	// Nova situa��o do contrato;
	If cDst == DEF_SVIGE    
		aAdd(aParamBox,{1,"Data de Assinatura?",dDtLibI,"99/99/99","","","",0,.F.}) 
		If ParamBox(aParamBox,"Data de Entrega",@aRet)
			DbSelectArea("CN9")
			Reclock("CN9",.F.)
			CN9->CN9_DTASSI := aRet[1]
			CN9->(Msunlock())
		EndIf
	EndIf 
EndIF

Return