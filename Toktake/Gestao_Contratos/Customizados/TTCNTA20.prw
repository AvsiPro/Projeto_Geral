#include "fwmvcdef.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA20 ºAutor  ³Jackson E. de Deus   º Data ³  02/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta especifica de contratos - CN9                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTCNTA20(cCodCli)

Local aArea := GetArea()
Local cQuery := ""
Local cTitulo := "Contratos"
Local cCont := ""
Local aStru := {}
Local aContr := {} 
Default cCodCli := ""
         
If cEmpAnt == "01"
	         
	If Empty(cCodCli) .And. IsInCallStack("U_TTTMKA04")
		dbSelectArea("SUC")
		cCodCli := SubStr(SUC->UC_CHAVE,1,6)            
	Else
		Return
	EndIf
	
	cQuery := "SELECT CN9_NUMERO, CN9_CLIENT, CN9_LOJACL, A1_NREDUZ FROM " +RetSqlName("CN9") + " CN9 "
	cQuery += "INNER JOIN "+RetSqlName("SA1") +" SA1 ON "
	cQuery += "SA1.A1_COD = CN9.CN9_CLIENT AND SA1.A1_LOJA = CN9.CN9_LOJACL AND SA1.D_E_L_E_T_ = CN9.D_E_L_E_T_ "
	cQuery += " WHERE CN9.D_E_L_E_T_ = '' AND CN9_FILIAL = '01' AND CN9_CLIENT = '"+cCodCli+"' ORDER BY CN9_NUMERO, CN9_CLIENT, CN9_LOJACL "
	                                                                                       
	If Select("TRBH") > 0
		TRBH->( dbCloseArea() )
	EndIf                      
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TRBH")  
	
	While !EOF()     
	   	AADD(aContr, {TRBH->CN9_NUMERO, TRBH->CN9_CLIENT, TRBH->CN9_LOJACL, TRBH->A1_NREDUZ})
		dbSkip()
	End
	
	If Len(aContr) == 0
		Aviso("TTCNTA20","Não existe contrato para o cliente informado.",{"Ok"})
		Return
	EndIf
	                                                                                      
	
	DEFINE MSDIALOG oDlg2 TITLE cTitulo FROM 0,0 TO 250,500 PIXEL
		@ 005,002  Say "Escolha o contrato do cliente"	Pixel Of oDlg2
		@ 015,002 LISTBOX oLbx FIELDS HEADER "Contrato", "Cliente", "Loja", "Nome fantasia" SIZE 249,090 OF oDlg2 PIXEL
		
		oLbx:SetArray(aContr)
		oLbx:bLine := {|| { aContr[oLbx:nAt,1],;
							aContr[oLbx:nAt,2],;
							aContr[oLbx:nAt,3],;
							aContr[oLbx:nAt,4]}}
				
	 	oLbx:bChange := {|| cCont := aContr[oLbx:nAt,1] }
	  	oLbx:blDblClick := { || oDlg2:End() }
		
		oPanel2:= tPanel():New(0,0,"",oDlg2,,,,,,100,020)
		oPanel2:align:= CONTROL_ALIGN_BOTTOM
		
		oBtnok := tButton():New(0,0,'Confirmar',oPanel2,{ || oDlg2:End()   },30,12,,,,.T.)
		oBtnok:Align := CONTROL_ALIGN_RIGHT
	ACTIVATE MSDIALOG oDlg2 CENTER
EndIF

RestArea(aArea)

Return(cCont)