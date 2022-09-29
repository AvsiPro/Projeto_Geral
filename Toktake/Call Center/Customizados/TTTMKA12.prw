#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA12  บAutor  ณJackson E. de Deus  บ Data ณ  24/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta especifica de patrimonios.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA12()

Local aArea := GetArea()
Local cQuery := ""
Local cTitulo := "Patrimonios"
Local cChapa := ""  
Local cCodCli := ""
Local cLjCli := ""
Local cCliente := ""
Private _aPatri := {}
Private oDlg2     
Private oLbx

If cEmpAnt <> "01"
	Return
EndIf


// Se foi chamado da rotina de Atualizacao de OMM
If IsInCallStack("U_TTTMKA04")
	cCliente := cNomCli
// Caso tenha sido inclusao ou alteracao..       
Else               
	// Na inclusao
	If INCLUI
		If !Empty(M->UC_CHAVE)
			cCodCli := SubStr(M->UC_CHAVE,1,TamSx3("A1_COD")[1])	
			cLjCli := SubStr(M->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1])
		EndIf
    // Na alteracao
	Else
		If !Empty(SUC->UC_CHAVE)
			cCodCli := SubStr(SUC->UC_CHAVE,1,TamSx3("A1_COD")[1])	
			cLjCli := SubStr(SUC->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1])
		EndIf		
	EndIf
	cCliente := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_NOME") 
EndIf
         
// busca os patrimonios
fRetSN1()
                       
DEFINE MSDIALOG oDlg2 TITLE cTitulo FROM 0,0 TO 250,500 PIXEL		
	@ 005,002  Say "Cliente: "+cCliente	Pixel Of oDlg2
	@ 015,002 LISTBOX oLbx FIELDS HEADER "Numero", "Patrimonio" SIZE 249,090 OF oDlg2 PIXEL
	
	oLbx:SetArray(_aPatri)
	oLbx:bLine := {|| { _aPatri[oLbx:nAt,1],;		//Plaqueta
						_aPatri[oLbx:nAt,2]	}}		//Descricao
			
 	oLbx:bChange := {|| cChapa := _aPatri[oLbx:nAt,1] }
  	oLbx:blDblClick := { || oDlg2:End() }
        
	oButton2 := tButton():New(110,220,'Confirmar',oDlg2,{ || oDlg2:End()   },30,12,,,,.T.)
	//oButton := tButton():New(110,185,'Fechar',oDlg2,{ || oDlg2:End()},30,12,,,,.T.)
		
ACTIVATE MSDIALOG oDlg2 CENTER


RestArea(aArea)
Return(cChapa)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetSN1  บAutor  ณJackson E. de Deus   บ Data ณ  30/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ
                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetSN1()

Local cQuery := ""
Local cCodCli := ""
Local cLojaCli := ""
Local cOcorr := ""    
Local cNumAtend := ""
Local cOcorrIns := SuperGetMv("MV_XTMK003",.T.,"")
Local cOcorrRem := SuperGetMv("MV_XTMK004",.T.,"")
Local cOcorrTnf := SuperGetMV("MV_XTMK012",.T.,"")
Local aAux := {}
Local nPosItem := 0
Local nPosProd := 0
Local cItem := ""
Local cProd := ""

nPosProd := Ascan(aHeader,{|x|AllTrim(x[2])=="UD_PRODUTO"}) 

If IsIncallStack("U_TTTMKA04")
	cProd := oMsGD:Acols[oMsGD:nAt,nPosProd]	
	cNumAtend := SUD->UD_CODIGO
Else                                        
	cProd := aCols[n][nPosProd]  
	cNumAtend := SUC->UC_CODIGO
EndIf                 

               
cOcorr := Posicione("SUD",1,xFilial("SUD")+cNumAtend,"UD_OCORREN")

dbSelectArea("SUC")
cCodCli := SubStr(SUC->UC_CHAVE,1,6)
cLojaCli := SubStr(SUC->UC_CHAVE,7,4)

// Monta query
cQuery += "SELECT N1_CHAPA, N1_DESCRIC, N1_XSTATTT " +CRLF
cQuery += "FROM " +RetSqlName("SN1") +" SN1 " +CRLF
cQuery += "WHERE " +CRLF
//cQuery += "N1_FILIAL = '"+xFilial("SN1")+"' " +CRLF
cQuery += "N1_PRODUTO = '"+cProd+"' " +CRLF
cQuery += "AND D_E_L_E_T_ = '' " +CRLF

// Se for instalacao, considera somente maquinas disponiveis
If cOcorr == cOcorrIns .Or. cOcorr == cOcorrTnf
	cQuery += "AND N1_XCLIENT = '' " +CRLF
	cQuery += "AND N1_XLOJA = '' " +CRLF
	cQuery += "AND N1_XSTATTT = '1' "
// Se for remocao, considera somente maquinas que estao nesse cliente
ElseIf cOcorr == cOcorrRem
	cQuery += "AND N1_XCLIENT = '"+cCodCli+"' " +CRLF
	cQuery += "AND N1_XLOJA = '"+cLojaCli+"' " +CRLF
	cQuery += "AND N1_XSTATTT = '3' "
EndIf                             

cQuery += "ORDER BY N1_CHAPA " +CRLF

If Select("PATRIM") > 0
	PATRIM->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "PATRIM"

dbSelectArea("PATRIM")
dbGoTop()
While !EOF()
	AADD(aAux, {PATRIM->N1_CHAPA,;
					PATRIM->N1_DESCRIC,;
					PATRIM->N1_XSTATTT})
	dbSkip()					
End
dbCloseArea()

If Len(aAux) > 0
	For nI := 1 To Len(aAux)
		AADD(_aPatri, {aAux[nI][1],aAux[nI][2]})
		If aAux[nI][3] == "1"
			AADD(_aPatri[nI],"Disponivel")
		ElseIf aAux[nI][3] == "2"
			AADD(_aPatri[nI],"Em transito")
		ElseIf aAux[nI][3] == "3"
			AADD(_aPatri[nI],"Em cliente")
		ElseIf aAux[nI][3] == "4"
			AADD(_aPatri[nI],"Manutencao")
		ElseIf aAux[nI][3] == "5"
			AADD(_aPatri[nI],"Empenhado")
		ElseIf aAux[nI][3] == "6"
			AADD(_aPatri[nI],"Em remocao")
		ElseIf aAux[nI][3] == "7"
			AADD(_aPatri[nI],"Em Transferencia")
		EndIf
	Next nI
Else
	AADD(_aPatri, {"","",""})	
EndIf


Return