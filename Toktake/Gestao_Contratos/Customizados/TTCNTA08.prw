#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA08     ºAutor  ³Microsiga           º Data ³  09/26/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTCNTA08()

Local aPergs := {}
Local aRet		:= {}
Local dDtIni
Local dDtFim
Local cUsrPerm := If(cEmpAnt=="01",SuperGetMv("MV_XGCT001",.T.,"ADMIN#AVENANCIO"),"")

If cEmpAnt == "01"
	
	If !cUserName $ cUsrPerm
		Aviso("TTCNTA08","Você não tem permissão de acesso." +CRLF +"Parâmetro: MV_XGCT001",{"Ok"})
		//Return
	EndIf
	
	aAdd(aPergs ,{1,"Contrato"		,space(TamSx3("CN9_NUMERO")[1]),"@!",".T.","CN9",".T.",70,.F.})
	aAdd(aPergs ,{1,"Data Inicial"	,dDataBase,PesqPict("SD1", "D1_DTDIGIT"),".T.",/*F3*/,".T.",50,.F.})
	aAdd(aPergs ,{1,"Data Final"	,dDataBase,PesqPict("SD1", "D1_DTDIGIT"),".T.",/*F3*/,".T.",50,.F.})
	
	If !ParamBox(aPergs ,"Atualização de contrato",@aRet)
		Return
	EndIf
	
	//If aRet[10] == 1 .And. aRet[11] == 0
	dbSelectArea("CN9")
	dbSetOrder(1)
	If dbSeek(xFilial("CN9")+aRet[1])
		dDtIni := CN9->CN9_DTINIC
		dDtfim := CN9->CN9_DTFIM
		
		RecLock("CN9",.F.)
		CN9->CN9_DTINIC := aRet[2]
		CN9->CN9_DTFIM := aRet[3]
		MsUnLock()
		Aviso("TTCNTA07","Contrato "+aRet[1] +" atualizado com sucesso.",{"Ok"})
		
		// Salva Log na tabela SZL
		If FindFunction("U_TTGENC01")
			U_TTGENC01(xFilial("CN9"),"SIGAGCT","ALTERACAO DE CADASTR","",CN9->CN9_NUMERO,"",cusername,dtos(dATE()),time(),,"Data de vigencia alterada. Valores anteriores: "+DtoS(dDtIni)+"/"+DtoS(dDtFim),CN9->CN9_CLIENT,CN9->CN9_LOJACL,"CN9")	
		EndIf
	EndIf
EndIf			

Return