#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC37  ºAutor  ³Jackson E. de Deus  º Data ³  06/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conferencia nota de saida                                  º±±
±±º				Controle de Entregas									  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³06/11/14³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTPROC37(cNumNf,cSerie,cCliente,cLoja,aDados)

Local cSql		:= ""
Local lRet		:= .T.
Local nI,nY
Local cTxtObs	:= ""
Local nRecnoSF2	:= 0         
Local dData		:= Stod("")
Local cHora		:= ""
Local cEntregue	:= ""
Local cAssinado	:= ""
Local cNome		:= ""
Local cRG		:= ""
Local nKm		:= 0
Local axItens	:= {}
Local nTotal	:= 0
Local cRemete	:= "microsiga"
Local cDestino	:=  SuperGetMV("MV_XLOG001",.T.,"")
Local cAssunto	:= "Divergência de quantidade entregue"
Local cHtml		:= ""
Local aAttach	:= {}
Local lAtvOSPA	:= SuperGetMV("MV_XWSK020",.T.,.F.)
Local cMotor	:= ""
Local cDescPA	:= ""
Local lDiver	:= .F.
Local cTpConf	:= ""
Local cNumOS	:= ""
Local lEntrOk	:= .F.
Local cConfs	:= ""
Local cCnfEsc	:= ""
Local aArea		:= GetArea()

If cEmpAnt <> "01"
	return
EndIF

// itens divergencia conferencia
axItens := U_TTPROC40(cNumNf,cSerie,cCliente,cLoja,aDados)

For nI := 1 To Len(aDados)
	If aDados[nI][1] == "DATA"
		dData := aDados[nI][2]
	ElseIf aDados[nI][1] == "HORA"
		cHora := aDAdos[nI][2]
	EndIf
Next nI

If Len(axItens) == 0
	cTxtObs := "ENTREGA OK"
	cTpConf := "1"
Else
	cTxtObs := "NF DEVOLUCAO"
	cTpConf := "2"
	lDiver := .T.
EndIf	


// verifica finalizacao da OS de entrega - baixar canhoto
cSql := "SELECT R_E_C_N_O_ REC FROM " +RetSqlName("SZG")
cSql += " WHERE ZG_TPFORM = '13' AND ZG_DOC = '"+cNumNF+"' AND ZG_SERIE = '"+cSerie+"' "
//cSql += " AND ZG_TPDOC = '2' "
cSql += " AND D_E_L_E_T_ = '' "

If Select("TSZG") > 0
	TSZG->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TSZG"
dbSelectArea("TSZG")
If !EOF()	
	If TSZG->REC > 0
		dbSelectArea("SZG")
		dbGoTo(TSZG->REC)
		If Recno() == TSZG->REC
			cNumOS := SZG->ZG_NUMOS
			If AllTrim(SZG->ZG_STATUS) == "FIOK"			
				lEntrOk := .T.
			EndIf
		EndIf           
	EndIf
EndIf
	
dbSelectArea("SF2")
dbSetOrder(2)	// CLIENTE LOJA NF SERIE
If dbSeek( xFilial("SF2") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
	nRecnoSF2 := Recno()
	If RecLock("SF2",.F.)
		SF2->F2_XCONF := cTpConf
		MsUnLock()
	EndIf
    
	If lDiver
		cMotor := AllTrim(SF2->F2_XMOTOR)
		If !Empty(SF2->F2_XCODPA)
			dbSelectArea("ZZ1")
			dbSetOrder(1)
			If dbSeek( xFilial("ZZ1") +AvKey(SF2->F2_XCODPA,"ZZ1_COD") )
				cDescPA := AllTrim(ZZ1->ZZ1_DESCRI)
			EndIf
		EndIf
	EndIf	
EndIf

If lEntrOk
	//If Empty(SF2->F2_XRECENT) .Or. Empty(SF2->F2_XDTENTR)
		StaticCall( TTPROC29,InfoEntr,,cNumOS,@dData,@cHora,@cEntregue,@cNome,@cRG,@nKm,@cConfs,@cCnfEsc )
		U_TTFAT15C( nRecnoSF2,dData,cHora,"S","S",cNome,cRG,nKm )
	//EndIf
EndIf
            
// divergencia - envia email
If lDiver	
	If !Empty(cDestino)
		cHtml := "<html>" +CRLF
		cHtml += "<head>"+CRLF
		cHtml += "<title>" +cAssunto +"</title>" +CRLF
		cHtml += "<style type='text/css'>"	+CRLF
		cHtml += "	table.bordasimples {border-collapse: collapse;}"	+CRLF
		cHtml += "	table.bordasimples tr td {border:1px solid #999999 ;}"	+CRLF
		cHtml += "	body { background-color: #FFFFFF;"	+CRLF
		cHtml += "	color: #5D665B; "	+CRLF
		cHtml += "	margin: 10px;"	+CRLF
		cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;"	+CRLF
		cHtml += "	font-size: small;"	+CRLF
		//	cArqMail += "	line-height: 180%;"
		cHtml += " 	}"	+CRLF
		cHtml += "</style>"	+CRLF
		cHtml += "</head>"	+CRLF
		cHtml += "<body>"	+CRLF
		cHtml += "<br>"
		cHtml += "<p>Notificação de divergência em quantidade entregue.</p>"
		cHtml += "<p>Motorista: " +cMotor +" </p>"
		cHtml += "<p>Nota fiscal: " +cNumNF +"/" +cSerie +"</p>"
		cHtml += "<p>PA: " +cDescPA +"</p>"	
		cHtml += "<br>"
		
		cHtml += "<table class='bordasimples'>"
		cHtml += "<caption>Produtos</caption>"
		cHtml += "<tr>"	
		cHtml += 	"<th>Item</th>"
		cHtml += 	"<th>Produto</th>"
		cHtml += 	"<th>Descrição</th>"
		cHtml += 	"<th>Qtd</th>"
		cHtml += 	"<th>Valor</th>"
		cHtml += "</tr>"
		
		// item diferenca produto descricao valor 
		For nI := 1 To Len(axItens)
			cHtml += "<tr>"							
			cHtml += 	"<td>" +axItens[nI][1] +"</td>"	
			cHtml += 	"<td>" +axItens[nI][3] +"</td>"	
			cHtml += 	"<td>" +axItens[nI][4] +"</td>"	
			cHtml += 	"<td>" +cvaltochar(axItens[nI][2]) +"</td>"	
			cHtml += 	"<td>" +Transform(axItens[nI][5],PesqPict("SD2","D2_PRCVEN")) +"</td>"	
			cHtml += "</tr>"
			
			// total em valor
			nTotal += axItens[nI][5]
		Next nI
		cHtml += "<tfoot>"
      	cHtml += 	"<tr><td colspan=5 align=right>" +"<strong>Total: </strong>" +"<strong><font size=4 color=red>"  +Transform(nTotal,PesqPict("SD2","D2_TOTAL")) +"</strong>"  +"</td></tr>"
   		cHtml += "</tfoot>"
   
		cHtml += "</table>"
		cHtml += "<br>"

		cHtml += "<p>___________________________________</p>"
		cHtml += "<p>E-mail automático enviado via protheus.</p>"
		cHtml += "<p>Favor não responder.</p>"
		cHtml += "</body>"
		cHtml += "</html>"
		
		U_TTMailN(cRemete,cDestino,cAssunto,cHtml,aAttach,.F.)
	EndIf	   
EndIf

// grava no Log
If FindFunction("U_TTGENC01")
	U_TTGENC01( xFilial("SZG"),"ENTREGA","OS CONFERENCIA","",cNumNf,cSerie,"WS",dtos(date()),time(),,cTxtObs,,,"SZG" )
EndIf

// movimenta estoque para PA
If lAtvOSPA
	If FindFunction("U_TTFAT18C")
		U_TTFAT18C( cNumNf,cSerie,cCliente,cLoja,axItens )
	Else
		Conout("# TTPROC37 " +"FUNCAO NAO DISPONIVEL: U_TTFAT18C")
	EndIf
EndIf                             

RestArea(aArea)  

Return lRet