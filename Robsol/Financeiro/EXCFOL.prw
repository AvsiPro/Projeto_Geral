#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXCFOL  ºAutor  ³Rodrigo Barreto   º Data ³  20/01/2023   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclue registros da tabela ZZ1 conforme ID				º±±
±±º          ³										                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RobSol                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EXCFOL()

	Local aArea    := GetArea()
	Local aPergs := {}
	Local cIdTit := Space(9)
	Private lOK := .T.

	aAdd(aPergs, {1, "Informe o ID dos títulos ",			 		cIdTit,  "",  ".T.",   "",  ".T.", 80,  .T.})

	If ParamBox(aPergs, "Informe os parâmetros")
		Processa({||EXCZZ1()},,"Processando...")
		If lOK
			MsgAlert('ATENÇÃO: Registros de ID  '+ MV_PAR01 + ', excluídos! Exclua o título principal no contas a Pagar.')
		EndIf
	EndIf

	restArea(aArea)
return

//Deletar registros
Static Function EXCZZ1

	Local cIdZZ1 := MV_PAR01
	//Local lOK := .T.

	DbSelectArea("ZZ1")
	ZZ1->(DbSetOrder(2)) //Filial+Ordem Producao
	if ZZ1->(DbSeek(xFilial("ZZ1")+cIDZZ1)) //cGet1 = Numero da Ordem de Produção
		While ZZ1->(DbSeek(xFilial("ZZ1")+cIDZZ1))
			ZZ1->(RecLock("ZZ1",.F.))
			ZZ1->(DbDelete())
			ZZ1->(MsUnLock())
		EndDo
	else
		alert("Registro não localiado, verifique a filial logada.")
		lOk := .F.
	EndIf

return lOk
