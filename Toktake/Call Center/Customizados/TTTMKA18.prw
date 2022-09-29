#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA18  บAutor  ณJackson E. de Deus  บ Data ณ  07/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta especifica de produtos da tabela de preco.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA18()

Local aArea := GetArea()
Local cTitulo := "Produtos da tabela de pre็o"
Local cProduto := ""  
Local cCodCli := ""
Local cLjCli := ""
Local cCliente := ""
Local oDlg2     
Local oLbx
Private aProds := {}

If cEmpAnt <> "01"
	Return
EndIf
         
// busca os produtos da tabela de preco do cliente - informada anteriormente UD_XTABPRC
fRetDA1()
                       
DEFINE MSDIALOG oDlg2 TITLE cTitulo FROM 0,0 TO 250,500 PIXEL		
	@ 005,002 LISTBOX oLbx FIELDS HEADER "Produto", "Descri็ใo" SIZE 249,090 OF oDlg2 PIXEL
	
	oLbx:SetArray(aProds)
	oLbx:bLine := {|| { aProds[oLbx:nAt,1],;		//Produto
						aProds[oLbx:nAt,2]	}}		//Descricao
			
 	oLbx:bChange := {|| cProduto := aProds[oLbx:nAt,1] }
  	oLbx:blDblClick := { || oDlg2:End() }
        
	oButton2 := tButton():New(110,220,'Confirmar',oDlg2,{ || oDlg2:End()   },30,12,,,,.T.)
		
ACTIVATE MSDIALOG oDlg2 CENTER


RestArea(aArea)
Return(cProduto)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetDA1  บAutor  ณJackson E. de Deus   บ Data ณ  07/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca os produtos da tabela de pre็o cadastrada.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetDA1()

Local cQuery := ""
Local aAux := {}
Local cNumAtend := SUC->UC_CODIGO
Local cCodTab := Posicione("SUD",1,xFilial("SUD")+cNumAtend,"UD_XTABPRC")

// Monta query
cQuery += "SELECT DA1.DA1_CODPRO PRODUTO, SB1.B1_DESC DESCRI "
cQuery += "FROM " +RetSqlName("DA1") + " DA1 "

cQuery += "INNER JOIN " +RetSqlName("DA0") + " DA0 ON "
cQuery += "DA0.DA0_FILIAL = DA1.DA1_FILIAL "
cQuery += "AND DA0.DA0_CODTAB = DA1.DA1_CODTAB "
cQuery += "AND DA0.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SB1") + " SB1 ON "
cQuery += "SB1.B1_COD = DA1.DA1_CODPRO "
cQuery += "AND SB1.D_E_L_E_T_ = '' "

cQuery += "WHERE DA1.DA1_CODTAB = '"+cCodTab+"'"
cQuery += "AND DA1.D_E_L_E_T_ = '' " 
                           
cQuery += "ORDER BY DA1.DA1_CODPRO " +CRLF

If Select("TRBDA1") > 0
	TRBDA1->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "TRBDA1"

dbSelectArea("TRBDA1")
dbGoTop()
While !EOF()
	AADD(aAux, {TRBDA1->PRODUTO,;
				TRBDA1->DESCRI})
	dbSkip()					
End
dbCloseArea()

If Len(aAux) > 0
	For nI := 1 To Len(aAux)
		AADD(aProds, {aAux[nI][1],;
						aAux[nI][2]})
	Next nI
Else
	AADD(aProds, {"",""})	
EndIf


Return