#include "totvs.ch"
#include "fwmvcdef.ch"

#DEFINE CONFCEGA 1
#DEFINE LEITURA 2
#DEFINE SANGRIA 3 
#DEFINE ABAST 4


// Cadastro de Tecnico x Agente Equipe Remota
User Function TTTECC01()

Local oBrowse
Local oColumn
Local oDlg   
Local oLayer		:= FWLayer():new()
Local oPnlLayer
Local cTitulo		:= "Técnicos"
Local aDimension	:= MsAdvSize()
Local aCampos		:= {}
Local aButton		:= {}
Local nOpca			:= 0
Local aButton := {	{ "", { || Incluir()  }, "Incluir" ,"Incluir"  },;
  					{ "", { || Alterar()  }, "Alterar","Alterar" },;
  					{ "", { || Rotadia()  }, "Ver trajeto","Ver trajeto" } }

Private cCadastro	:= cTitulo          

If cEmpAnt <> "01"
	Return
EndIf

DEFINE MSDIALOG oDlg FROM 0,0 TO aDimension[6],aDimension[5] PIXEL
	oLayer:init(oDlg,.T.)
	oLayer:addLine("LN_CAB",100,.F.)
	oLayer:addCollumn("COL_CAB",100,.f.,"LN_CAB")
	oLayer:addWindow("COL_CAB","WIN_CAB","",100,.t.,.F.,{||},"LN_CAB")
	oPnlLayer := oLayer:GetWinPanel("COL_CAB","WIN_CAB","LN_CAB")
	//oPnlLayer:FreeChildren()

	DEFINE FWBROWSE oBrowse DATA TABLE ALIAS "AA1"  DOUBLECLICK { || Visual() }  OF oDlg
	
		ADD LEGEND DATA 'Empty(AA1_PAGER)'		COLOR "RED"		TITLE "Agente não vinculado" OF oBrowse		                                                                                            
		ADD LEGEND DATA '!Empty(AA1_PAGER)'		COLOR "GREEN"	TITLE "Agente vinculado" OF oBrowse		
	
		ADD COLUMN oColumn DATA { || AA1_CODTEC	} TITLE "Cod. Tecnico"			SIZE 6 OF oBrowse		
		ADD COLUMN oColumn DATA { || AA1_NOMTEC	} TITLE "Nome"					SIZE 30 OF oBrowse
		ADD COLUMN oColumn DATA { || AA1_XFILAT	} TITLE "Fil. Atend."			SIZE 02 OF oBrowse
		ADD COLUMN oColumn DATA { || AA1_PAGER	} TITLE "Agente"		   		SIZE 6 OF oBrowse
		ADD COLUMN oColumn DATA { || AA1_LOCAL	} TITLE "Rota"					SIZE 6 OF oBrowse  
		ADD COLUMN oColumn DATA { || AA1_EMAIL	} TITLE "E-mail"				SIZE 25 OF oBrowse  
		ADD COLUMN oColumn DATA { || AA1_XGEREN	} TITLE "Cod. Gerente"			SIZE 10 OF oBrowse  
		ADD COLUMN oColumn DATA { || AA1_XSUPER	} TITLE "Cod. Supervisor"		SIZE 10 OF oBrowse
		
		oBrowse:SetUseFilter()		
	ACTIVATE FWBROWSE oBrowse
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1, Visual() },{|| nOpca := 2,oDlg:End()},,aButton)
                                                            
Return

     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTECC01  ºAutor  ³Microsiga           º Data ³  02/26/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualiza o cadastro do tecnico                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Visual()
                        
AxVisual('AA1',Recno(),2)    

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTECC01  ºAutor  ³Microsiga           º Data ³  02/26/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui um novo tecnico                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Incluir()   

Local aCampos := {"AA1_CODTEC","AA1_NOMTEC","AA1_TURNO","AA1_FUNCAO","AA1_XFILAT","AA1_PAGER","AA1_LOCAL","AA1_EMAIL","AA1_XGEREN","AA1_XSUPER","AA1_XEMPRE"}
Local nOpcA := 0

nOpcA := AxInclui('AA1',Recno(),3,aCampos,,aCampos)   

// Gera o codigo de Agente no Equipe Remota - aguardar termino do metodo por parte da Keeple
If nOpcA == 1

EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTECC01  ºAutor  ³Microsiga           º Data ³  02/26/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui um novo tecnico                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Alterar()   

Local aCampos := {"AA1_CODTEC","AA1_NOMTEC","AA1_TURNO","AA1_FUNCAO","AA1_XFILAT","AA1_PAGER","AA1_LOCAL","AA1_EMAIL","AA1_XGEREN","AA1_XSUPER","AA1_XEMPRE"}
Local nOpcA := 0

nOpcA := AxAltera('AA1',Recno(),4,aCampos,,aCampos)   

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTECC01  ºAutor  ³Microsiga           º Data ³  02/26/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca o trajeto do dia selecionado                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RotaDia()

Local cResult := ""
Local aDados := {}
Local cData := "" 
Default dData := ddatabase

If dtoc(dData) == ""
	Return
EndIf 



ProcRegua(3)

IncProc("Obtendo dados do servidor..")

cData := DtoS(dData)
cData := SubStr(cData,1,4) +"-" +SubStr(cData,5,2) +"-" +SubStr(cData,7,2) +"T00:00:00"   

AADD(aDados, "095E1DE94F978434146B50F5AA88EEDA50C694C3" )
AADD(aDados, "42CB7AEE2B2FFA173B53" )
AADD(aDados, SZG->ZG_AGENTE )
AADD(aDados, cData )
cResult := U_WSKPC008(aDados)

If "negado" $ cResult
	Return
EndIf

cResult := U_WSKPF001(cResult)
IncProc("Analisando dados..")


Return