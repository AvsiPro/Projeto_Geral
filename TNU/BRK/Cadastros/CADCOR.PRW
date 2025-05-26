#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'

/*
Cadastro de Seguradoras
*/

User Function CADCOR()

Local cAlias := "ZZ2"
Local cTitulo := "Cadastro de Corretoras"
Local cFunExc := "u_CadCor1()"
Local cFunAlt := "u_CadCor2()"

AxCadastro(cAlias, cTitulo, cFunExc, cFunAlt)

Return

User Function CADCOR1()

Local lRet := MsgBox("Tem certeza que deseja excluir o registro selecionado?","Confirmacao","YESNO")

Return lRet

Return

User Function CADCOR2()

Local lRet := .F.
Local cMsg := ""

If Inclui
	cMsg := "Confirma a inclusao do registro?"
Else
	cMsg := "Confirma a alteracao do registro?"
EndIf

lRet := MsgBox(cMsg, "Confirmação", "YESNO")

Return lRet