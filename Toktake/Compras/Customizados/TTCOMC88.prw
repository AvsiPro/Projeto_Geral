#include "protheus.ch"  
#include "fwmvcdef.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC88  บAutor  ณMicrosiga           บ Data ณ  11/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCOMC88()

lOCAL OBROWSE
Private cCadastro := "Abastecimentos SZ0"

If cEmpAnt == "01"
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SZ0")
	oBrowse:SetDescription(cCadastro)
	
	oBrowse:Activate()
EndIf

Return
                   

Static Function MenuDef()

Local aRotina	:= {} 
Local cAlias	:= "SZ0"
                                               
ADD OPTION aRotina TITLE 'Pesquisar'	ACTION "PesqBrw"					OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar'	ACTION "AxVisual('SZ0',Recno(),2)"	OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Incluir'		ACTION "AxInclui('SZ0',Recno(),3)"	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'		ACTION "AxAltera('SZ0',Recno(),4)"	OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Excluir'		ACTION "AxExclui('SZ0',Recno(),5)"	OPERATION 5 ACCESS 0
                    
Return(aRotina)