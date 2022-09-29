#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTB001    บAutor  ณRogerio Ferreira    บ Data ณ  14/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณControla rotinas do processo Contabil.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Copel                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTB001

Private cAlias    := "SZC"
Private aRotina   := {}
Private lRefresh  := .T.
Private cCadastro := "Controla Processamento Contabil"
Private aCores    := {}
Private aButtons  := {}

aCores    := {{'ZC_EXEC = "1"' ,'BR_VERDE'	},;	//1=Ativo
{'ZC_EXEC = "2"' ,'BR_VERMELHO'}}	//2=Desativado

If cEmpAnt <> "02"
	Return
EndIf

aAdd( aRotina, {"Pesquisar" ,"AxPesqui",0,1} )
aAdd( aRotina, {"Visualizar","AxVisual",0,2} )
aAdd( aRotina, {"Incluir"   ,"AxInclui",0,3} )
aAdd( aRotina, {"Alterar"   ,"AxAltera",0,4} )
aAdd( aRotina, {"Excluir"   ,"AxDeleta",0,5} )

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias,,,,,,aCores)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTB002    บAutor  ณRogerio Ferreira    บ Data ณ  07/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se alguma rotina esta sendo processada.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Copel                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTB002(_cFuncop)

Local cHRPROC := SUBSTR(TIME(),1,5)
//Local cRotina := Posicione("SZC",2,xFilial("SZC")+"1","ZC_ROTINA")      	//Verifica se existe alguma rotina sendo processada.	// Retirado em 01/07/2014 - DGJR
//Local _cUser  := Posicione("SZC",2,xFilial("SZC")+"1","ZC_USUARIO")		// Retirado em 01/07/2014 - DGJR

// Incluido em 01/07/2014 - DGJR - INICIO
Local cRotina := ""
Local _cUser  := ""
Local _nRecSZC:= 0 

dbSelectArea("SZC")
SZC->(dbSetOrder(2))
If SZC->(dbSeek(xFilial("SZC")+"1"))
	cRotina := SZC->ZC_ROTINA
	_cUser  := SZC->ZC_USUARIO
EndIf
// Incluido em 01/07/2014 - DGJR - FINAL

If !Empty(cRotina)
	MsgStop("Rotina "+ALLTRIM(cRotina)+" esta sendo processada pelo usuario "+ALLTRIM(_cUser)+".",_cFuncop)
	Return
Endif

DbSelectArea("SZC")
DbSetOrder(1)
If DbSeek(xFilial("SZC")+Alltrim(Substring(_cFuncop,2,15)))
	If cHRPROC < ZC_HRBLINI .or. cHRPROC > ZC_HRBLFIM
		_nRecSZC := SZC->(Recno())
		GrvIni()
		_cFunCop := Substring(_cFuncop,2,Len(_cFunCop))+"()"
		&(_cFunCop)               
		SZC->(dbGoTo(_nRecSZC))
		GrvFim()
	Else
		MsgStop("Sใo "+cHRPROC+"hs essa rotina nใo pode ser processada entre as "+ZC_HRBLINI+"hs e "+ZC_HRBLFIM+"hs.",_cFuncop)
	Endif
Endif

Return


Static Function GrvIni

RecLock("SZC",.F.)
SZC->ZC_EXEC    := "1"
SZC->ZC_HRINI   := SUBSTR(TIME(),1,5)
SZC->ZC_HRFIM   := ""
SZC->ZC_DATAULT := dDataBase
SZC->ZC_USUARIO := Alltrim(cUserName)
SZC->(MsUnlock())

Return

Static Function GrvFim

RecLock("SZC",.F.)
SZC->ZC_EXEC    := "2"
SZC->ZC_HRFIM   := SUBSTR(TIME(),1,5)
SZC->ZC_DATAULT := dDataBase
SZC->(MsUnlock())

Return
