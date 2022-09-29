
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK272HTM  �Autor  �Jackson E. de Deus  � Data �  07/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este ponto de entrada permite ao usu�rio complementar as   ���
���          � informa��es que ser�o enviadas por e-mail, ao confirmar um ���
���          � atendimento na rotina de atendimento do Telemarketing	  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TK272HTM()

Local chtml  := ""
Local _aParScript := ParamIxb[3]
Local aArea := GetArea()
Local cCliFor := ""
Local cLoja := ""
Local cNome := ""

If cEmpAnt == "01"

	If Valtype(llOMM) == "U"
		llOMM := .F.
	EndIf
	
	// Tratamento para alteracao de OMM    
	If llOMM
		If llAlterou .And. Len(aAltProd) > 0              
	 		chtml += "<table border='1'  width='100%'>"
			chtml += '<th colspan=1><font face="Verdana" size=2>Produtos Alterados</font></th>'
			For nI := 1 To Len(aAltProd)
				chtml += "<tr>"
				chtml += "<td>"
				chtml += "<font color='#FF0000' font face='Verdana' >Produto Anterior: </font>" +aAltProd[nI][1]  +Posicione("SB1",1,xFilial("SB1")+aAltProd[nI][1],"B1_DESC") +"<br>" 
				chtml += "<font color='##0000FF' font face='Verdana' >Produto Atual: </font>" +aAltProd[nI][1]  +Posicione("SB1",1,xFilial("SB1")+aAltProd[nI][2],"B1_DESC") +"<br>" 		
				chtml += "Data: "+DtoC(Date()) +"<br>" 
				chtml += "Hora: "+Time() +"<br>"
				chtml += "Usu�rio: " +cUserName"
				chtml += "</td>"
				chtml += "</tr>"
			Next nI
			chtml += '</table>'
		EndIf
		
		If llExcluiu .And. Len(aExcProd) > 0
			chtml += "<table border='1'  width='100%'>"
			chtml += '<th colspan=1><font face="Verdana" size=2>Produtos Exclu�dos</font></th>'
			For nI := 1 To Len(aExcProd)
				chtml += "<tr>"
				chtml += "<td>"
				chtml += "<font color='#FF0000' font face='Verdana'>Produto Exclu�do: </font>" +aExcProd[nI] +" - " +Posicione("SB1",1,xFilial("SB1")+aExcProd[nI],"B1_DESC") +"<br>" 
				chtml += "Data: "+DtoC(Date()) +"<br>" 
				chtml += "Hora: "+Time() +"<br>"
				chtml += "Usu�rio: " +cUserName"
				chtml += "</td>"
				chtml += "</tr>"
			Next nI
			chtml += '</table>'
		EndIf
	// Tratamento SAC
	Else
		chtml += "<table border='1'  width='100%'>"
		chtml += '<th colspan=2><font face="Verdana" size=2>Informa��es adicionais</font></th>'
		chtml += "<tr>"
		chtml += 	"<td><font face='Verdana'>Nome Fantasia</font></td>"
		chtml += 	"<td>"
	
		//Cliente
		If SUC->UC_ENTIDAD == "SA1"
			cCliFor := SubStr(SUC->UC_CHAVE,1,TamSx3("A1_COD")[1])
			cLoja	:= SubStr(SUC->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1])
			cNome	:= Posicione("SA1",1,xFilial("SA1")+cCliFor+cLoja,"A1_NREDUZ")
		// Fornecedor
		ElseIf SUC->UC_ENTIDAD == "SA2"
			cCliFor	:= SubStr(SUC->UC_CHAVE,1,TamSx3("A2_COD")[1])
			cLoja	:= SubStr(SUC->UC_CHAVE,TamSx3("A2_COD")[1]+1,TamSx3("A2_LOJA")[1])
			cNome	:= Posicione("SA2",1,xFilial("SA1")+cCliFor+cLoja,"A2_NREDUZ")	
		EndIf
		chtml += cNome
		chtml += "	</td>"
		
		chtml += "</tr>"
		chtml += '</table>'		
	EndIf
EndIf	

RestArea(aArea)

Return chtml