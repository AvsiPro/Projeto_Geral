#include "rwmake.ch"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦M460FIM()    ¦ Autor ¦ Ricardo Souza	¦ Data ¦20.05.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ ponto de entrada executado após a gravação da nota fiscal  ¦¦¦
¦¦¦			 ¦ ultilizado aquir para desbloquear título NDF.			  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 

User Function M460FIM()       

Local aArea		:= GetArea()
Local CRLF     	:= CHR(13) 
Local aAreage2 	:= SE2->(GetArea())
Local lFatOrc	:= .F.

// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf


Begin TRANSACTION			
	cQuery:="  UPDATE "+RetSqlName("SE2") +"		"+CRLF
	cQuery+="  SET   E2_DATALIB = '"+DTOS(DDATABASE)+"',E2_USUALIB='"+CUSERNAME+"' "+CRLF
	cQuery+="  WHERE E2_TIPO  <> 'NF'				 "+CRLF
	cQuery+="  AND   E2_DATALIB='' AND E2_USUALIB='' "+CRLF			
	cQuery+="  AND D_E_L_E_T_ <> '*' 				 "+CRLF				
	clsql:=	TcSqlExec(cQuery)				
End TRANSACTION	

//Tratamento para considerar os dias a mais para clientes DDE quando houver. - Alexandre 11/04/12 Item 152 lista de pendencias.
If SA1->A1_XDDE == "1"
	DbSelectArea("SE1")
	DbSetOrder(2)
	If DbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_FILIAL+Alltrim(SF2->F2_SERIE)+SF2->F2_DOC)
		While !EOF() .AND. SF2->F2_CLIENTE == SE1->E1_CLIENTE .AND. SF2->F2_LOJA == SE1->E1_LOJA .AND. SF2->F2_DOC == SE1->E1_NUM
			Reclock("SE1",.F.)
			SE1->E1_VENCREA	:= DataValida(SE1->E1_VENCTO + SA1->A1_XPRDDE)
			SE1->E1_VENCTO 	:= SE1->E1_VENCTO + SA1->A1_XPRDDE
			SE1->(Msunlock())
			DbSkip()
		EndDo       
	EndIf
EndIf
            
If SM0->M0_CODIGO=='01'
	//oM460FIM := SYSTAX():New()
	//oM460FIM:M460FIM()        
endif


RestArea(aAreage2)			
RestArea(aArea)         
	
Return