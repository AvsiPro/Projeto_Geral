#include "protheus.ch"
#include "topconn.ch"
#include "fwmvcdef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA12  บAutor  ณJackson E. de Deus  บ Data ณ  09/24/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta especifica de funcionarios.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTECC02()

Local aArea := GetArea()
Local cQuery := ""
Local cTitulo := "Cadastro de funcionแrios"
Local cMat := ""
Local aStru := {}  
         
If cEmpAnt <> "01"
	Return
EndIf
         
// busca os funcionarios
Processa( { || U_TTTECC03()}, "Verificando cadastro de funcionแrios" )  

Aadd( aStru,{ "RA_MAT"      ,"C",TamSX3("RA_MAT")[1]   ,0})
Aadd( aStru,{ "RA_NOME"      ,"C",TamSX3("RA_NOME")[1] ,0})

cArqTrab := CriaTrab(aStru)       
cArqTrab1 := Subs(cArqTrab,1,7)+"A"
cArqTrab2 := Subs(cArqTrab,2,7)+"B"
copy to &cArqTrab
DbCloseArea("TRBSRA")

DbUseArea(.T.,,cArqTrab,"TRBSRA",.F.,.F.)

If Select("TRBSRA") <> 0
	dbSelectArea("TRBSRA")                             
	dbCloseArea()
EndIf

dbUseArea( .T., __cRDDNTTS, cArqTrab,"TRBSRA", if(.F. .Or. .F., !.F., NIL), .F. )
IndRegua("TRBSRA",cArqTrab2,"RA_NOME",,,"Selecionando Registros...") //"Selecionando Registros..."
IndRegua("TRBSRA",cArqTrab1,"RA_MAT",,,"Selecionando Registros...") //"Selecionando Registros..."
                                 
dbSetIndex(cArqTrab2+OrdBagExt())
dbSetIndex(cArqTrab1+OrdBagExt())
DbSetOrder(1)   

                       
// Monta janela
DEFINE MSDIALOG oDlg FROM 0,0 TO 500,700 PIXEL
	DEFINE FWBROWSE oBrowse DATA TABLE ALIAS "TRBSRA" OF oDlg              
		oBrowse:DisableConfig ()                           
		oBrowse:bLDblClick := { |oBrowse| cMat := TRBSRA->RA_MAT, oDlg:End() }               
        ADD COLUMN oColumn DATA { || TRBSRA->RA_MAT  }		TITLE "Matricula"	SIZE 10 OF oBrowse
        ADD COLUMN oColumn DATA { || TRBSRA->RA_NOME }		TITLE "Nome"		SIZE 30 OF oBrowse
        ADD COLUMN oColumn DATA { || TRBSRA->RA_CODFUNC }	TITLE "Cod. Funcao"	SIZE 06 OF oBrowse
        ADD COLUMN oColumn DATA { || TRBSRA->RJ_DESC }		TITLE "Funcao"		SIZE 30 OF oBrowse
	ACTIVATE FWBROWSE oBrowse
	
	oPanel := tPanel():New(0,0,"",oDlg,,,,,,100,020)
	oPanel:align := CONTROL_ALIGN_BOTTOM
	
	oButton		:= tButton():New(0,0,'Confirmar'	,oPanel,{ || cMat := TRBSRA->RA_MAT,  oDlg:End()   },40,10,,,,.T.)
	oButton2	:= tButton():New(0,0,'Sair'		,oPanel,{ || oDlg:End()   },40,10,,,,.T.)
	oButton2:Align := CONTROL_ALIGN_RIGHT
	oButton:Align := CONTROL_ALIGN_RIGHT
ACTIVATE MSDIALOG oDlg CENTERED     

dbSelectArea("TRBSRA")

RestArea(aArea)

Return(cMat)