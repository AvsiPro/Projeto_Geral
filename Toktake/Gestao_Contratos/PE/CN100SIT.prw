#DEFINE DEF_SCANC '01' //Cancelado
#DEFINE DEF_SELAB '02' //Em Elaboração
#DEFINE DEF_SEMIT '03' //Emitido
#DEFINE DEF_SAPRO '04' //Em Aprovação
#DEFINE DEF_SVIGE '05' //Vigente
#DEFINE DEF_SPARA '06' //Paralisado
#DEFINE DEF_SSPAR '07' //Sol Fina.
#DEFINE DEF_SFINA '08' //Finalizado
#DEFINE DEF_SREVS '09' //Revisão  
#DEFINE DEF_SREVD '10'//Revisado

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN100SIT  ºAutor  ³Microsiga           º Data ³  08/21/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE Utilizado para gravar a data correta de assinatura do   º±±
±±º          ³contrato quando ele se tornar vigente;                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN100SIT()
Local cAtu := PARAMIXB[1]
Local cDst := PARAMIXB[2]
Local aParamBox := {}        
Local dDtLibI	:=	ctod('  /  /  ')
Local aRet 		:= {}

If cEmpAnt == "01"
	
	// Nova situação do contrato;
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