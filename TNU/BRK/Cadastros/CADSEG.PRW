#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'

/*
Cadastro de Seguradoras
*/

User Function CADSEG()

Local cAlias := "ZZ1"
Local cTitulo := "Cadastro de Seguradoras"
Local cFunExc := "u_CadSeg1()"
Local cFunAlt := "u_CadSeg2()"

AxCadastro(cAlias, cTitulo, cFunExc, cFunAlt)

Return

User Function CADSEG1()

Local lRet := MsgBox("Tem certeza que deseja excluir o registro selecionado?","Confirmacao","YESNO")

Return lRet

Return

User Function CADSEG2()

Local lRet := .F.
Local cMsg := ""

If Inclui
	cMsg := "Confirma a inclusao do registro?"
Else
	cMsg := "Confirma a alteracao do registro?"
EndIf

lRet := MsgBox(cMsg, "Confirmacao", "YESNO")

Return lRet