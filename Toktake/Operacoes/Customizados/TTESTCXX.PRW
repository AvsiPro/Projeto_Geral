#include "protheus.ch"  
#include "fwmvcdef.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTCXX  บAutor  ณMicrosiga           บ Data ณ  11/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTESTCXX()

Local oBrowse
Private cCadastro := "Contagens"

If cEmpAnt == "01"
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SZC")
	oBrowse:SetDescription(cCadastro)
	
	oBrowse:Activate()
EndIF

Return
                   

Static Function MenuDef()

Local aRotina	:= {} 
Local cAlias	:= "SZC"
                                               
ADD OPTION aRotina TITLE 'Pesquisar'	ACTION "PesqBrw"					OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar'	ACTION "AxVisual('SZC',Recno(),2)"	OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Incluir'		ACTION "AxInclui('SZ0',Recno(),3)"	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'		ACTION "AxAltera('SZC',Recno(),4)"	OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Excluir'		ACTION "AxExclui('SZ0',Recno(),5)"	OPERATION 5 ACCESS 0
                    
Return aRotina