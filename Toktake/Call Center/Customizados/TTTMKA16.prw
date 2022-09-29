#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA16  บAutor  ณJackson E. de Deus  บ Data ณ  28/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta espeficica de Planilhas.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA16()

Local aArea := GetArea()
Local cQuery := ""
Local cTitulo := "Planilhas"
Local cPlanilha := ""  
Private cCliente := ""
Private cCodCli := ""
Private cLojaCli := ""
Private aDados := {}
Private oDlg2     
Private oLbx

If cEmpAnt <> "01"
	Return
EndIf

// Se foi chamado da rotina de Atualizacao de OMM
If IsInCallStack("U_TTTMKA04")
	dbSelectArea("SUC")
	cCodCli := SubStr(SUC->UC_CHAVE,1,6)
	cLojaCli := SubStr(SUC->UC_CHAVE,7,4)
	cCliente := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaCli,"A1_NOME") 
// Caso tenha sido inclusao ou alteracao..       
Else               
	// Na inclusao
	If INCLUI
		If !Empty(M->UC_CHAVE)
			cCodCli := SubStr(M->UC_CHAVE,1,TamSx3("A1_COD")[1])	
			cLojaCli := SubStr(M->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1])
		EndIf
    // Na alteracao
	Else
		If !Empty(SUC->UC_CHAVE)
			cCodCli := SubStr(SUC->UC_CHAVE,1,TamSx3("A1_COD")[1])	
			cLojaCli := SubStr(SUC->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1])
		EndIf		
	EndIf
	cCliente := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaCli,"A1_NOME") 
EndIf
         
// busca os patrimonios
fRetCNA(cCodCli,cLojaCli,@aDados)


                       
DEFINE MSDIALOG oDlg2 TITLE cTitulo FROM 0,0 TO 250,500 PIXEL		
	@ 005,002  Say "Cliente: "+cCliente	Pixel Of oDlg2
	@ 015,002 LISTBOX oLbx FIELDS HEADER "Planilha" SIZE 249,090 OF oDlg2 PIXEL
	
	oLbx:SetArray(aDados)
	oLbx:bLine := {|| { aDados[oLbx:nAt,1]	}} // Planilha
			
 	oLbx:bChange := {|| cPlanilha := aDados[oLbx:nAt,1] }
  	oLbx:blDblClick := { || oDlg2:End() }
        
	oButton2 := tButton():New(110,220,'Confirmar',oDlg2,{ || oDlg2:End()   },30,12,,,,.T.)
		
ACTIVATE MSDIALOG oDlg2 CENTER


RestArea(aArea)
Return(cPlanilha)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA16  บAutor  ณMicrosiga           บ Data ณ  07/25/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetCNA(cCodCli,cLojaCli,aDados)

Local cQuery := ""
Local nPosCont := 0
Local cContra := ""

nPosCont := Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XCONTRA"}) 

//If Empty(cContra)
	If IsIncallStack("U_TTTMKA04")
		cContra := oMsGD:Acols[oMsGD:nAt,nPosCont]	
	Else                                        
		cContra := aCols[n][nPosCont]  
	EndIf
//EndIf                 
             

// Monta query
cQuery += "SELECT CNA_NUMERO, CN9_XTPCNT " +CRLF
cQuery += "FROM " +RetSqlName("CNA") +" CNA " +CRLF

cQuery += "INNER JOIN " +RetSqlName("CN9") +" CN9 ON " +CRLF
cQuery += "CNA_FILIAL = CN9_FILIAL " +CRLF
cQuery += "AND CNA_CONTRA = CN9_NUMERO " +CRLF

cQuery += "WHERE " +CRLF
cQuery += "CNA.CNA_FILIAL = '"+xFilial("CNA")+"' " +CRLF
cQuery += "AND CNA.CNA_CONTRA = '"+cContra+"' " +CRLF
cQuery += "AND CNA.CNA_CLIENT = '"+cCodCli+"' " +CRLF
cQuery += "AND CNA.CNA_LOJACL = '"+cLojaCli+"' " +CRLF
//cQuery += "AND CN9.CN9_XTPCNT = '3' " +CRLF
cQuery += "AND CNA.D_E_L_E_T_ = '' " +CRLF                             

cQuery += "ORDER BY CNA_NUMERO " +CRLF

If Select("PLAN") > 0
	PLAN->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "PLAN"

dbSelectArea("PLAN")
dbGoTop()
While !EOF()
	AADD(aDados, {PLAN->CNA_NUMERO})
	dbSkip()					
End
dbCloseArea()


If Len(aDados) == 0
	AADD(aDados, {""})	
EndIf


Return