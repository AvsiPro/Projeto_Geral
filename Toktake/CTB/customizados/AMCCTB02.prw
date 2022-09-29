#INCLUDE "RWMAKE.CH"

/********************************************************************************
* Retorna a conta contábil a ser utilizada pelo Estoque das Filiais AMC      *
* Controle para ICMS - lançamento padrão passado no parâmetro          *
********************************************************************************/

User Function AMCCTB02(cLanPad)

Local   cCtb   := ""
Local 	cRet   := ""
Local aArea := GetArea()

If cEmpAnt <> "10"
	Return(cRet)
EndIf

If cLanPad $ "650"     // Entrada

	dbSelectArea("SD1")
	dbSetOrder(1)
	If MsSeek( xFilial("SD1")+AvKey(SD1->D1_DOC,"D1_DOC")+AvKey(SD1->D1_SERIE,"D1_SERIE")+AvKey(SD1->D1_FORNECE,"D1_FORNECE")+AvKey(SD1->D1_LOJA,"D1_LOJA")+AvKey(SD1->D1_COD,"D1_COD")+AvKey(SD1->D1_ITEM,"D1_ITEM"))
	 
//		If SD1->D1_CONTA  == "11401003"
			Do Case
				//Inclusão  - contabilização AMC - Ronaldo Gomes - 22/03/2017				
				Case SD1->D1_FILIAL == "02" 
					cCtb := "11308002"
			
				Case SD1->D1_FILIAL == "03" 
					cCtb := "11308003"

		   		Case SD1->D1_FILIAL == "04" 
					cCtb := "11308004"
		
		   		OtherWise

					cCtb := "11308001"
		
			EndCase

		   		cRet := cCtb
	
	EndIf

EndIf


If cLanPad $ "610"     //Saida 

	dbSelectArea("SD2")
	dbSetOrder(3)
	If MsSeek(xFilial("SD2")+AvKey(SD2->D2_DOC,"D2_DOC")+AvKey(SD2->D2_SERIE,"D2_SERIE")+AvKey(SD2->D2_CLIENTE,"D2_CLIENTE")+AvKey(SD2->D2_LOJA,"D2_LOJA")+AvKey(SD2->D2_COD,"D2_COD")+AvKey(SD2->D2_ITEM,"D2_ITEM"))
	 
//		If SD1->D1_CONTA  == "11401003"
			Do Case
				//Inclusão  - contabilização AMC - Ronaldo Gomes - 22/03/2017
				Case SD2->D2_FILIAL == "02" 
					cCtb := "21402002"
			
				Case SD2->D2_FILIAL == "03" 
					cCtb := "21402003"

		   		Case SD2->D2_FILIAL == "04" 
					cCtb := "21402004"
		
		   		OtherWise

					cCtb := "21402001"
		
			EndCase

		   		cRet := cCtb
	
	EndIf

Endif

RestARea(aArea)

Return cRet  