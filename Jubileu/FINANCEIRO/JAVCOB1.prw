#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFIN บAutor  ณAlexandre Venancio 	 บ Data ณ  08/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de envio automatico de cartas de cobranca para o    บฑฑ
ฑฑบ          ณcliente conforme a data de vencimento.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function JAVCOB1(cCodEmp,cCodFil)

	//Local aArea		:=	GetArea()
	Local cQuery
	//
	Local cRemete   := "cobranca@jubileudistribuidora.com"//"testemovidesk@clinicasinteligentes.com.br"
	Local cBody
	Local cSubject	:=	"Avisos de Vencimento"
	Local aArquivos := {}
	Local cDestino	:=	""//"rodrigo.barreto@avsipro.com.br"//"cobranca@jubileudistribuidora.com"
	Local cCliente	:=	''
	Local nCont		:=	1
	Local dDtOne  	:= ''
	Local dDtTwo  	:= ''
	Local dDtTree 	:= ''
	Local dDtFour 	:= ''
	Local cNomeArq	:= ''
	Local aTitE1	:= {}
	Local nX		:= 0

	Private aAvisFi	:= {}
	Private aTitCli	:= {}
	Private aCumula	:= {}

	Default cCodEmp := "01"
	Default cCodFil := "01"
	Default cPastaS  := "\temp\" //GetTempPath()

	//Utilizando a nova classe de email para poder anexar corretamente o email ao corpo da mensagem.
	// ************************************************************ //
	// 		Parametros da rotina de envio de email  			  	//
	//																//
	//	01 - Remetente da mensagem                                  //
	//	02 - Destinatario do email                                  //
	//	03 - Assunto do email                                       //
	//	04 - Corpo da mensagem                                      //
	//	05 - Array com arquivos a serem atachados                   //
	//			Posicao 1 - \Caminho\NomeArquivo.extensao           //
	//			Posicao 2 - Content-ID "Apelido" da imagem          //
	//	06 - Confirmacao de leitura (logico)						//
	// ************************************************************ //


	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0201" TABLES "SE1"

	cNomeArq := 'c:\temp\_avisos\'+dtos(ddatabase)+'.txt'

	Aadd(aArquivos,{"\system\logo_004.bmp",'Content-ID: <ID_logo_004.bmp>'})

	// Valida็ใo para 05 dias

	IF DOW(dDataBase) == 2
		dDtFour := datavalida(dDataBase+5,.T.) //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtFour := datavalida(dDataBase+5,.T.)+1 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtFour := datavalida(dDataBase+5,.T.)+2 //Condi็ใo para Quarta
	ELSEIF DOW(dDataBase) == 5
		dDtFour := datavalida(dDataBase+5,.T.)+2 //Condi็ใo para Quinta
	ELSE
		dDtFour := datavalida(dDataBase+5,.T.)+2
	ENDIF

	cQuery := "SELECT  DISTINCT E1_FILORIG,E1_PREFIXO,E1_NUM,E1_TIPO,E1_NATUREZ,ED_DESCRIC,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_PARCELA,A1_CGC,E1_PORTADO,E1.R_E_C_N_O_ AS REGE1"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_='' AND A1_XBEMA=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
	cQuery += " WHERE E1_VENCREA = '"+DTOS(datavalida(dDtFour))+"' AND E1_PREFIXO <> 'CTR' AND E1_BAIXA=''"
	cQuery += " AND E1.D_E_L_E_T_='' AND E1_PORTADO BETWEEN '' AND '999'"
	cQuery += " AND E1_FILORIG BETWEEN '0101' AND '9999'"
	cQuery += " AND E1_TIPO NOT IN('RA','NCC')"
	cQuery += " AND E1_XENVNOT IN('','0')"

	cQuery += " ORDER BY E1_CLIENTE"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")

	nArq:= fCreate(cNomeArq)

	FWrite(nArq, 'Inicio '+DTOC(dDataBase) + ' ' + Time()+CRLF)
	FWrite(nArq, '*************************************************************************************************************'+CRLF)
	Fwrite(nArq, '|                       Avisos de Vencimentos transmitidos em '+cvaltochar(dDatabase)+'                      |'+CRLF)
	FWrite(nArq, '*************************************************************************************************************'+CRLF)

	While !EOF()
		cDestino 	:=	Alltrim(TRB->A1_EMAIL)
		MV_PAR01	:=	TRB->E1_PREFIXO
		MV_PAR02	:=	TRB->E1_NUM
		MV_PAR03	:=	TRB->E1_PARCELA
		MV_PAR04	:=	TRB->E1_PARCELA
		cChvNfe		:=	Posicione("SF2",1,xFilial("SF2")+TRB->E1_NUM+TRB->E1_PREFIXO,"F2_CHVNFE")
		cBody 		:=	Aviso_1(cChvNfe)

		aArquivos 	:=  {}
		cPasta := 'c:\temp\'
		cMail  := ''
		cArquivo := zGerDanfe(TRB->E1_NUM, TRB->E1_PREFIXO, cPasta, cMail)
		cAnexos := 'C:\TEMP\'+cArquivo+'.PDF'
		CPYT2S(cAnexos,GetSrvProfString("Startpath", "")+'temp\',.T.)
		cAnexos:=GetSrvProfString("Startpath", "")+'temp\'+SubStr(AllTrim(cAnexos),RAT('\',AllTrim(cAnexos))+1)
		cAnexos := StrTran( cAnexos, "/", "\" )
		
		U_emailjub(cRemete,cDestino,cSubject,cBody,cAnexos,.T.)     //email para vencimento 5 dias
		cCorpo := TRB->E1_CLIENTE+'#'+TRB->E1_LOJA+'#'+TRB->A1_NOME+'#'+TRB->E1_PREFIXO+'#'+TRB->E1_NUM+'#'+CVALTOCHAR(STOD(TRB->E1_VENCREA))+'#'+Transform(TRB->E1_VALOR,"@E 999,999,999.99")+'#'+TRB->A1_EMAIL
		FWrite(nArq,cCorpo+CRLF)
		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL,''})
		Aadd(aTitE1,TRB->REGE1)
		dbSelectArea("TRB")
		DbSkip()
	EndDo

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+CRLF)
	fClose(nArq)

	cBody := AvisFin(cSubject,{},'')

	//Destino email do resumo para o financeiro
	//cDestino := Alltrim(SuperGetmv('PI_MAILFN',.F.,'contasareceber@pilaoprofessional.com.br;thiago.ebert@pilaoprofessional.com.br;alexandre.venancio@avsipro.com.br'))
	cDestino := "cobranca@jubileudistribuidora.com" //"rodrigo.barreto@avsipro.com.br"//
	U_emailjub(cRemete,cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,"",.T.)//{},.T.)

	DbSelectArea("SE1")
	For nX := 1 to len(aTitE1)
		Dbgoto(aTitE1[nX])
		Reclock("SE1",.F.)
		SE1->E1_XENVNOT := "0"
		SE1->(Msunlock())
	Next nX

	//RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFIN01 บAutor  ณMicrosiga           บ Data ณ  03/19/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AVSIFIN2(cCodEmp,cCodFil)

	Local aArea		:=	GetArea()
	Local cQuery
	Local cRemete   := "cobranca@jubileudistribuidora.com"//"testemovidesk@clinicasinteligentes.com.br"
	Local cBody
	Local cSubject	:=	"Aviso de Cobran็a"
	Local aArquivos := {}
	Local cDestino	:= ""//"rodrigohcimoveis@gmail.com"//	"cobranca@jubileudistribuidora.com"//
	Local cCliente	:=	''
	Local nCont		:=	1
	Local dDtOne  	:= ''
	Local dDtTwo  	:= ''
	Local dDtTree 	:= ''
	Local dDtFour 	:= ''
	Local aTitE1	:= {}
	Local nX 		:= 0

	Private aAvisFi	:= {}
	Private aTitCli	:= {}
	Private aCumula	:= {}

	Default cCodEmp := "01"
	Default cCodFil := "01"

	//Utilizando a nova classe de email para poder anexar corretamente o email ao corpo da mensagem.
	// ************************************************************ //
	// 		Parametros da rotina de envio de email  			  	//
	//																//
	//	01 - Remetente da mensagem                                  //
	//	02 - Destinatario do email                                  //
	//	03 - Assunto do email                                       //
	//	04 - Corpo da mensagem                                      //
	//	05 - Array com arquivos a serem atachados                   //
	//			Posicao 1 - \Caminho\NomeArquivo.extensao           //
	//			Posicao 2 - Content-ID "Apelido" da imagem          //
	//	06 - Confirmacao de leitura (logico)						//
	// ************************************************************ //



	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "SE1"

	cNomeArq := 'c:\temp\_cobrancas\'+dtos(ddatabase)+'.txt'

	//Aadd(aArquivos,{"\system\logo_004.bmp",'Content-ID: <ID_logo_004.bmp>'}) //Aadd(aArquivos,{"\system\lgrl02.bmp",'Content-ID: <ID_lgrl02.bmp>'})

	// Valida็ใo para titulos vencidos a 01 dia

	IF DOW(dDataBase) == 2
		dDtOne := datavalida(dDataBase-1,.F.)-2 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtOne := datavalida(dDataBase-1,.F.)-1 //Condi็ใo para Ter็a
	ELSE
		dDtOne := datavalida(dDataBase-1,.F.)
	ENDIF

	cQuery := "SELECT DISTINCT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_VALJUR,E1.R_E_C_N_O_ AS REGE1"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_='' AND A1_XBEMA=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtOne,.F.))+"' AND E1_BAIXA=''"// AND E1_PREFIXO <> 'CTR' "
	//cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_TIPO NOT IN('RA','NCC')"
	cQuery += " AND E1_FILORIG BETWEEN '0101' AND '9999' "
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '' AND '999'"
	cQuery += " AND E1_XENVNOT IN('','0')"
	cQuery += " ORDER BY E1_CLIENTE,E1_LOJA,E1_VENCREA"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	cSubject := "Aviso de Cobran็a"

	aTitCli := {}
	aAvisFi := {}

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")

	cCliente := TRB->E1_CLIENTE+TRB->E1_LOJA

	nArq:= fCreate(cNomeArq)

	fWrite(nArq, 'Inicio '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))

	While !EOF()

		If cCliente != TRB->E1_CLIENTE+TRB->E1_LOJA
			cCliente := TRB->E1_CLIENTE+TRB->E1_LOJA
			If Len(aTitCli) > 0

				cChvNfe		:=	Posicione("SF2",1,xFilial("SF2")+TRB->E1_NUM+TRB->E1_PREFIXO,"F2_CHVNFE")

				cBody := Cobranca(cChvNfe,'1')

				cPasta := 'c:\temp\'
				cMail  := ''
				cArquivo := zGerDanfe(TRB->E1_NUM, TRB->E1_PREFIXO, cPasta, cMail)
				cAnexos := 'C:\TEMP\'+cArquivo+'.PDF'
				CPYT2S(cAnexos,GetSrvProfString("Startpath", "")+'temp\',.T.)
				cAnexos:=GetSrvProfString("Startpath", "")+'temp\'+SubStr(AllTrim(cAnexos),RAT('\',AllTrim(cAnexos))+1)
				cAnexos := StrTran( cAnexos, "/", "\" )

				U_emailjub(cRemete,cDestino,cSubject,cBody,cAnexos,.T.)
				aTitCli := {}

				cDestino := Alltrim(TRB->A1_EMAIL)

				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
						Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
						TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})

				EndIf
				cDestino := Alltrim(TRB->A1_EMAIL)

			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
					Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
					TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})
			EndIf

			cDestino := Alltrim(TRB->A1_EMAIL)

		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRB->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRB->A1_NOME,TRB->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRB->E1_VALOR
		EndIf

		cCorpo := TRB->E1_CLIENTE+'/'+TRB->E1_LOJA+'/'+TRB->A1_NOME+'/'+TRB->E1_PREFIXO+'/'+TRB->E1_NUM+'/'+CVALTOCHAR(STOD(TRB->E1_VENCREA))+'/'+Transform(TRB->E1_VALOR,"@E 999,999,999.99")+'/'+TRB->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL,''})
		Aadd(aTitE1,TRB->REGE1)

		cChvNfe		:=	Posicione("SF2",1,xFilial("SF2")+TRB->E1_NUM+TRB->E1_PREFIXO,"F2_CHVNFE")

		Dbskip()
	Enddo

	If len(aTitCli) > 0
		cBody := Cobranca(cChvNfe,'1')

		cPasta := 'c:\temp\'
		cMail  := ''
		cArquivo := zGerDanfe(TRB->E1_NUM, TRB->E1_PREFIXO, cPasta, cMail)
		cAnexos := 'C:\TEMP\'+cArquivo+'.PDF'
		CPYT2S(cAnexos,GetSrvProfString("Startpath", "")+'temp\',.T.)
		cAnexos:=GetSrvProfString("Startpath", "")+'temp\'+SubStr(AllTrim(cAnexos),RAT('\',AllTrim(cAnexos))+1)
		cAnexos := StrTran( cAnexos, "/", "\" )

		U_emailjub(cRemete,cDestino,cSubject,cBody,cAnexos,.T.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		cCompl := " (Titulos vencidos a 1 dia)"
		cBody := AvisFin(cSubject+cCompl,aCumula,'')
		//cDestino Financeiro
		//cDestino := "contasareceber@pilaoprofessional.com.br;thiago.ebert@pilaoprofessional.com.br;alexandre.venancio@avsipro.com.br"
		//cDestino := Alltrim(SuperGetmv('PI_MAILFN',.F.,'contasareceber@pilaoprofessional.com.br;thiago.ebert@pilaoprofessional.com.br;alexandre.venancio@avsipro.com.br'))
		//cDestino := Alltrim(SuperGetmv('PI_MAILFN',.F.,'rodrigohcimoveis@gmail.com'))
		cDestino := Alltrim(SuperGetmv('PI_MAILFN',.F.,'cobranca@jubileudistribuidora.com'))
		U_emailjub(cRemete,cDestino,cSubject+cCompl+" "+cvaltochar(ddatabase),cBody,"",.T.)
	EndIf


	DbSelectArea("SE1")
	For nX := 1 to len(aTitE1)
		DbGoto(aTitE1[nX])
		Reclock("SE1",.F.)
		SE1->E1_XENVNOT := "1"
		SE1->(Msunlock())
	Next nX


	// Valida็ใo para 03 dias

	IF DOW(dDataBase) == 2
		dDtTwo := datavalida(dDataBase-3,.F.)-2 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtTwo := datavalida(dDataBase-3,.F.)-2 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtTwo := datavalida(dDataBase-3,.F.)-2 //Condi็ใo para Quarta
	ELSEIF DOW(dDataBase) == 5
		dDtTwo := datavalida(dDataBase-3,.F.)-1 //Condi็ใo para Quinta
	ELSE
		dDtTwo := datavalida(dDataBase-3,.F.)
	ENDIF


	cQuery := "SELECT DISTINCT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_VALJUR,E1.R_E_C_N_O_ AS REGE1,A1_SATIV1,A1_EST"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_='' AND A1_XBEMA=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtTwo,.F.))+"' AND E1_BAIXA='' AND E1_PREFIXO <> 'CTR' "
	//cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_TIPO NOT IN('RA','NCC')"
	cQuery += " AND E1_FILORIG BETWEEN '0101' AND '9999' "
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '' AND '999'"
	cQuery += " AND E1_XENVNOT IN('','0','1') "
	cQuery += " ORDER BY E1_CLIENTE,E1_LOJA,E1_VENCREA"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	cSubject := "Aviso de Cobran็a"
	aTitCli := {}
	aAvisFi := {}
	aTitE1  := {}

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")

	cCliente := TRB->E1_CLIENTE+TRB->E1_LOJA

	nArq:= fCreate(cNomeArq)

	fWrite(nArq, 'Inicio '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))

	While !EOF()

		If cCliente != TRB->E1_CLIENTE+TRB->E1_LOJA
			cCliente := TRB->E1_CLIENTE+TRB->E1_LOJA
			If Len(aTitCli) > 0

				cChvNfe		:=	Posicione("SF2",1,xFilial("SF2")+TRB->E1_NUM+TRB->E1_PREFIXO,"F2_CHVNFE")

				cBody := Cobranca(cChvNfe,'2')

				cPasta := 'c:\temp\'
				cMail  := ''
				cArquivo := zGerDanfe(TRB->E1_NUM, TRB->E1_PREFIXO, cPasta, cMail)
				cAnexos := 'C:\TEMP\'+cArquivo+'.PDF'
				CPYT2S(cAnexos,GetSrvProfString("Startpath", "")+'temp\',.T.)
				cAnexos:=GetSrvProfString("Startpath", "")+'temp\'+SubStr(AllTrim(cAnexos),RAT('\',AllTrim(cAnexos))+1)
				cAnexos := StrTran( cAnexos, "/", "\" )

				U_emailjub(cRemete,cDestino,cSubject,cBody,cAnexos,.T.)
				aTitCli := {}

				cDestino := Alltrim(TRB->A1_EMAIL)

				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
						Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
						TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})

				EndIf

				cDestino := Alltrim(TRB->A1_EMAIL)

			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
					Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
					TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})
			EndIf

			cDestino := Alltrim(TRB->A1_EMAIL)

		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRB->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRB->A1_NOME,TRB->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRB->E1_VALOR
		EndIf

		cCorpo := TRB->E1_CLIENTE+'/'+TRB->E1_LOJA+'/'+TRB->A1_NOME+'/'+TRB->E1_PREFIXO+'/'+TRB->E1_NUM+'/'+CVALTOCHAR(STOD(TRB->E1_VENCREA))+'/'+Transform(TRB->E1_VALOR,"@E 999,999,999.99")+'/'+TRB->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL,If(TRB->A1_EST=="RJ",TRB->A1_EST,TRB->A1_SATIV1)})
		Aadd(aTitE1,TRB->REGE1)

		cChvNfe		:=	Posicione("SF2",1,xFilial("SF2")+TRB->E1_NUM+TRB->E1_PREFIXO,"F2_CHVNFE")

		Dbskip()
	EndDo

	If len(aTitCli) > 0
		cBody := Cobranca(cChvNfe,'2')
		cPasta := 'c:\temp\'
		cMail  := ''
		cArquivo := zGerDanfe(TRB->E1_NUM, TRB->E1_PREFIXO, cPasta, cMail)
		cAnexos := 'C:\TEMP\'+cArquivo+'.PDF'
		CPYT2S(cAnexos,GetSrvProfString("Startpath", "")+'temp\',.T.)
		cAnexos:=GetSrvProfString("Startpath", "")+'temp\'+SubStr(AllTrim(cAnexos),RAT('\',AllTrim(cAnexos))+1)
		cAnexos := StrTran( cAnexos, "/", "\" )

		U_emailjub(cRemete,cDestino,cSubject,cBody,cAnexos,.T.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		cCompl := " (Titulos vencidos a 3 dias)"

		cBody := AvisFin(cSubject+cCompl,aCumula,'')

		//destino financeiro
		//cDestino := "contasareceber@pilaoprofessional.com.br;thiago.ebert@pilaoprofessional.com.br;alexandre.venancio@avsipro.com.br;"
		//cDestino := Alltrim(SuperGetmv('PI_MAILFN',.F.,'rodrigohcimoveis@gmail.com'))
		cDestino := Alltrim(SuperGetmv('PI_MAILFN',.F.,'cobranca@jubileudistribuidora.com'))

		U_emailjub(cRemete,cDestino,cSubject+cCompl+" "+cvaltochar(ddatabase),cBody,"",.T.)
		/*
	//depois envia para o responsavel pela conta
	cDono := ""

	For nDonoCnt := 1 to len(aAvisFi)
		If !Alltrim(aAvisFi[nDonoCnt,08]) $ cDono
			cDono := Alltrim(aAvisFi[nDonoCnt,08])+"/"

			cCompl := " (Titulos vencidos a 3 dias)"

			cBody := AvisFin(cSubject+cCompl,{},cDono)

			cDestino := ''
			If Alltrim(aAvisFi[nDonoCnt,08]) $ '000099'
				//hotelaria 000099 tamara
				cDestino += Alltrim(SuperGetmv('PI_MAIL71',.F.,'rodrigohcimoveis@gmail.com'))
			ElseIf Alltrim(aAvisFi[nDonoCnt,08]) $ '000106'
				//vendfoods 000106 ingrid
				cDestino += Alltrim(SuperGetmv('PI_MAIL72',.F.,'rodrigohcimoveis@gmail.com'))
			ElseIf Alltrim(aAvisFi[nDonoCnt,08]) $ '000113'
				//franqueados 000113 vanessa, priscila
				cDestino += Alltrim(SuperGetmv('PI_MAIL73',.F.,'vanessa.roque@pilaoprofessional.com.br;priscila.mattos@pilaoprofessional.com.br'))
			ElseIf Alltrim(aAvisFi[nDonoCnt,08]) $ '000102/000104/000105/000110'
				//automacao conveniencia vending A e B 000102 000104 000105 000110 thais mats
				cDestino += Alltrim(SuperGetmv('PI_MAIL74',.F.,'thais.mattos@pilaoprofessional.com.br'))
			ElseIf Alltrim(aAvisFi[nDonoCnt,08]) $ 'RJ'
				//UF - rj marcio
				cDestino += Alltrim(SuperGetmv('PI_MAIL75',.F.,'marcio.silva@pilaoprofessional.com.br'))
			EndIF

			U_avsimail(cRemete,cDestino,cSubject+cCompl+" "+cvaltochar(ddatabase),cBody,{},.T.)
		EndIf
		Next nDonoCnt*/

	EndIf


	DbSelectArea("SE1")
	For nX := 1 to len(aTitE1)
		Dbgoto(aTitE1[nX])
		Reclock("SE1",.F.)
		SE1->E1_XENVNOT := "2"
		SE1->(Msunlock())
	Next nX


	// Valida็ใo para 07 dias

	IF DOW(dDataBase) == 2
		dDtTree := datavalida(dDataBase-7,.F.)-4 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtTree := datavalida(dDataBase-7,.F.)-3 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Quarta
	ELSEIF DOW(dDataBase) == 5
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Quinta
	ELSE //DOW(dDataBase) == 6
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Sexta
	ENDIF

	cQuery := "SELECT DISTINCT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_VALJUR,E1.R_E_C_N_O_ AS REGE1,A1_SATIV1,A1_EST"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_='' AND A1_XBEMA=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtTree,.F.))+"' AND E1_BAIXA='' AND E1_PREFIXO <> 'CTR' "
	//cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_TIPO NOT IN('RA','NCC')"
	cQuery += " AND E1_FILORIG BETWEEN '0101' AND '9999' "
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '' AND '999'"
	cQuery += " AND E1_XENVNOT IN('','0','2') "
	cQuery += " ORDER BY E1_CLIENTE,E1_LOJA,E1_VENCREA"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	cSubject := "Aviso de Cobran็a"
	aTitCli := {}
	aAvisFi := {}
	aTitE1  := {}

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")

	While !EOF()

		If cCliente != TRB->E1_CLIENTE+TRB->E1_LOJA
			cCliente := TRB->E1_CLIENTE+TRB->E1_LOJA
			If Len(aTitCli) > 0
				cChvNfe		:=	Posicione("SF2",1,xFilial("SF2")+TRB->E1_NUM+TRB->E1_PREFIXO,"F2_CHVNFE")

				cBody := Cobranca(cChvNfe,'3')

				cPasta := 'c:\temp\'
				cMail  := ''
				cArquivo := zGerDanfe(TRB->E1_NUM, TRB->E1_PREFIXO, cPasta, cMail)
				cAnexos := 'C:\TEMP\'+cArquivo+'.PDF'
				CPYT2S(cAnexos,GetSrvProfString("Startpath", "")+'temp\',.T.)
				cAnexos:=GetSrvProfString("Startpath", "")+'temp\'+SubStr(AllTrim(cAnexos),RAT('\',AllTrim(cAnexos))+1)
				cAnexos := StrTran( cAnexos, "/", "\" )

				U_emailjub(cRemete,cDestino,cSubject,cBody,cAnexos,.T.)
				aTitCli := {}

				cDestino := Alltrim(TRB->A1_EMAIL)

				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
						Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
						TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})

				EndIf

				cDestino := Alltrim(TRB->A1_EMAIL)

			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
					Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
					TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})
			EndIf

			cDestino := Alltrim(TRB->A1_EMAIL)

		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRB->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRB->A1_NOME,TRB->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRB->E1_VALOR
		EndIf

		cCorpo := TRB->E1_CLIENTE+'/'+TRB->E1_LOJA+'/'+TRB->A1_NOME+'/'+TRB->E1_PREFIXO+'/'+TRB->E1_NUM+'/'+CVALTOCHAR(STOD(TRB->E1_VENCREA))+'/'+Transform(TRB->E1_VALOR,"@E 999,999,999.99")+'/'+TRB->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL,If(TRB->A1_EST=="RJ",TRB->A1_EST,TRB->A1_SATIV1)})
		Aadd(aTitE1,TRB->REGE1)

		cChvNfe		:=	Posicione("SF2",1,xFilial("SF2")+TRB->E1_NUM+TRB->E1_PREFIXO,"F2_CHVNFE")

		Dbskip()
	Enddo

	If len(aTitCli) > 0
		cBody := Cobranca(cChvNfe,'3')

		cPasta := 'c:\temp\'
		cMail  := ''
		cArquivo := zGerDanfe(TRB->E1_NUM, TRB->E1_PREFIXO, cPasta, cMail)
		cAnexos := 'C:\TEMP\'+cArquivo+'.PDF'
		CPYT2S(cAnexos,GetSrvProfString("Startpath", "")+'temp\',.T.)
		cAnexos:=GetSrvProfString("Startpath", "")+'temp\'+SubStr(AllTrim(cAnexos),RAT('\',AllTrim(cAnexos))+1)
		cAnexos := StrTran( cAnexos, "/", "\" )

		U_emailjub(cRemete,cDestino,cSubject,cBody,cAnexos,.T.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		//Primeiro envia para os destinatarios do financeiro
		cCompl := " (Titulos vencidos a 7 dias)"

		cBody := AvisFin(cSubject+cCompl,aCumula,'')

		//cDestino :=  destino financeiro
		//cDestino := "contasareceber@pilaoprofessional.com.br;thiago.ebert@pilaoprofessional.com.br;fabiana.leite@pilaoprofessional.com.br;robinson.leite@pilaoprofessional.com.br;jaqueline.zani@pilaoprofessional.com.br;alexandre.venancio@avsipro.com.br"
		//cDestino := Alltrim(SuperGetmv('PI_MAILFN',.F.,"rodrigo.silva1126@etec.sp.gov.br"))//+";fabiana.leite@pilaoprofessional.com.br;robinson.leite@pilaoprofessional.com.br"
		cDestino := Alltrim(SuperGetmv('PI_MAILFN',.F.,"cobranca@jubileudistribuidora.com"))
		U_emailjub(cRemete,cDestino,cSubject+cCompl+" "+cvaltochar(ddatabase),cBody,"",.T.)
		/*
	//depois envia para o responsavel pela conta
	cDono := ""

	For nDonoCnt := 1 to len(aAvisFi)
		If !Alltrim(aAvisFi[nDonoCnt,08]) $ cDono
			cDono := Alltrim(aAvisFi[nDonoCnt,08])+"/"

			cCompl := " (Titulos vencidos a 7 dias)"

			cBody := AvisFin(cSubject+cCompl,{},cDono)

			cDestino := ''
			If Alltrim(aAvisFi[nDonoCnt,08]) $ '000099'
				//hotelaria 000099 tamara
				cDestino += Alltrim(SuperGetmv('PI_MAIL71',.F.,'tamara.vendramini@pilaoprofessional.com.br'))
			ElseIf Alltrim(aAvisFi[nDonoCnt,08]) $ '000106'
				//vendfoods 000106 ingrid
				cDestino += Alltrim(SuperGetmv('PI_MAIL72',.F.,'ingrid@vendfoods.com.br'))
			ElseIf Alltrim(aAvisFi[nDonoCnt,08]) $ '000113'
				//franqueados 000113 vanessa, priscila
				cDestino += Alltrim(SuperGetmv('PI_MAIL73',.F.,'vanessa.roque@pilaoprofessional.com.br;priscila.mattos@pilaoprofessional.com.br'))
			ElseIf Alltrim(aAvisFi[nDonoCnt,08]) $ '000102/000104/000105/000110'
				//automacao conveniencia vending A e B 000102 000104 000105 000110 thais mats
				cDestino += Alltrim(SuperGetmv('PI_MAIL74',.F.,'thais.mattos@pilaoprofessional.com.br'))
			ElseIf Alltrim(aAvisFi[nDonoCnt,08]) $ 'RJ'
				//UF - rj marcio
				cDestino += Alltrim(SuperGetmv('PI_MAIL75',.F.,'marcio.silva@pilaoprofessional.com.br'))
			EndIF

			U_avsimail(cRemete,cDestino,cSubject+cCompl+" "+cvaltochar(ddatabase),cBody,{},.T.)
		EndIf
	Next nDonoCnt
		*/
	EndIf

	DbSelectArea("SE1")
	For nX := 1 to len(aTitE1)
		Dbgoto(aTitE1[nX])
		Reclock("SE1",.F.)
		SE1->E1_XENVNOT := "3"
		SE1->(Msunlock())
	Next nX

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณMicrosiga           บ Data ณ  01/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aviso de Cobranca, enviado xx dias antes de vencer o tituloบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Aviso_1(cChvNfe)

	Local aArea	:=	GetArea()

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1078' border='0'>"
	cHtml += " <tr>"
	//cHtml += "   <td align='left'><img alt='Logo PILAO' width=65 align='left' height=65 title='PILAO' style='margin-left:5%; float:left'  src='https://pilaoprofessional.com.br/images/logo-pilao-professional.jpg'></img></td>"
	cHtml += "  </tr>"
	cHtml += "</table>"
	cHtml += "<br><br><br>"

	cHtml += "<table width='1078' border='0'>"
	cHtml += "  <tr bgcolor='#FE2E2E'>"
	cHtml += "    <td align='center'><b><span style='color: #ffffff'>Aviso de vencimento / TITULO  Nบ "+TRB->E1_NUM+" - "+cvaltochar(STOD(TRB->E1_VENCREA))+"</span></b></td>"
	cHtml += "  </tr>"
	cHtml += "</table><br><br><br>"

	//cFilant := SUBSTR(TRB->E1_PREFIXO,1,2)
	cFilNf := Posicione("SF2",1,xFilial("SF2")+TRB->E1_NUM+TRB->E1_PREFIXO,"F2_FILIAL")

	If !Empty(cFilNf)
		Opensm0(cempant+cFilNf) //TRB->E1_FILORIG)
		Openfile(cempant+cFilNf) //TRB->E1_FILORIG)
	EndIf

	cHtml += "<table width='1078' border='0'>"
	cHtml += "  <tr bgcolor='#D8D8D8'>"
	cHtml += "    <td >Cedente:</td><td><b>JUBILEU DISTRIBUIDORA "+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")+"</b></td></tr>"

	IF LEN(Alltrim(TRB->A1_CGC)) > 12
		CNPJCPF := "CNPJ "+Transform(TRB->A1_CGC,"@R 99.999.999/9999-99")
	ELSE
		CNPJCPF := "CPF "+Transform(TRB->A1_CGC,"@R 999.999.999-99")
	ENDIF

	cHtml += "    <tr bgcolor='#848484'><td>Sacado:</td><td><b><span style='color: #ffffff'>"+Alltrim(TRB->A1_NOME)+"</b> "+CNPJCPF+"</span></td></tr>"
	cHtml += "    <tr bgcolor='#D8D8D8'><td>Valor:</td><td><b>R$ "+cvaltochar(Transform(TRB->E1_VALOR,"@E 999,999,999.99"))+"</b></td></tr>"
	cHtml += "    <tr bgcolor='#D8D8D8'><td>Vencimento:</td><td><b>"+cvaltochar(Stod(TRB->E1_VENCREA))+"</b></td></tr>"
	cHtml += "    <tr bgcolor='#D8D8D8'><td>Refer๊ncia:</td><td><b>"+Alltrim(TRB->ED_DESCRIC)+"</b></td></tr>"
	cHtml += "</table><br><br><br>"



	cHtml += "<table width='1086' border='0'>"
	cHtml += "  <tr>"
	//cHtml += "    <td>Lembramos  que o boleto poderแ ser pago em qualquer ag๊ncia, lot้rica ou local credenciado  เ rede bancแria at้ a data do vencimento.</td>"
	cHtml += " <td>Para consultar sua nota fiscal referente a este titulo, utilize o hiperlink abaixo e copie e cole a chave de acesso no site.</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td><a href='http://www.nfe.fazenda.gov.br/portal/consultaRecaptcha.aspx?tipoConsulta=completa&tipoConteudo=XbSeqxE8pl8='>Clique Aqui</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += " <td><b>"+cChvnfe+"</b></td>"

	cHtml += "  </tr><br><br><br>"

	cHtml += "    <td><p><strong><h3>Cobran็a Jubileu</strong></h3><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "  <strong>T</strong>el 55 (11) 2176-2080 / (11) 96635-4669 <br />"

	cHtml += "  <strong>E-mail</strong><strong> </strong><a href='mailto:cobranca@jubileudistribuidora.com'>cobranca@jubileudistribuidora.com</a><u> </u></p></td>"
	cHtml += "  </tr>"

	cHtml += "</table>"

	cHtml += "</body>"
	cHtml += "</html>"

	RestArea(aArea)

Return(cHtml)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณMicrosiga           บ Data ณ  01/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 1 Aviso, enviado xx dias apos o vencimento do titulo       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cobranca(cChvnfe,nCobr)

	Local aArea	:= GetArea()
	Local cHtml
	Local nX 	:= 0

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1078' border='0'>"
	cHtml += " <tr>"
	//cHtml += "   <td align='left'><img alt='Logo PILAO' width=65 align='left' height=65 title='PILAO' style='margin-left:5%; float:left'  src='https://pilaoprofessional.com.br/images/logo-pilao-professional.jpg'></img></td>"
	cHtml += "  </tr>"
	cHtml += "</table>"
	cHtml += "<br><br><br>"


	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr bgcolor='#FE2E2E'>"
	cHtml += " <td align='center' bgcolor='#FE2E2E'><b><span style='color: #ffffff'>Aviso de Cobran็a</span></b></td>"
	cHtml += " </tr>"
	cHtml += " <tr><br><br><br>"
	cHtml += "    <td align='right'><b>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</b></td>"
	cHtml += "</tr></table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td><p>Prezado Cliente,</p></td>"
	cHtml += "  </tr><br><br>"
	cHtml += "  <tr>"
	cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do(s) tํtulo(s)  abaixo relacionado(s). Solicitamos seu contato atrav้s do telefone 11 2176-2080 ou 11 96635-4669,  para regulariza็ใo da pend๊ncia.</td>"
	cHtml += "  </tr>"
	cHtml += "</table>
	cHtml += "<br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td align='center' bgcolor='#848484'><b>N๚mero NF</b></td><td align='center' bgcolor='#848484'><b>Emissใo</b></td><td align='center' bgcolor='#848484'><b>Vencimento</b></td><td align='center' bgcolor='#848484'><b>Valor</b></td><td align='center' bgcolor='#848484'><b>Natureza</b></td>"
	cHtml += "  </tr>"

	For nX := 1 to len(aTitCli)
		cHtml += "  <tr>"
		cHtml += "<td align='center'>"+aTitCli[nX,10]+aTitCli[nX,01]+"</td><td align='center'>"+cvaltochar(aTitCli[nX,02])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,03])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,04])+"</td><td align='center'>"+Alltrim(aTitCli[nX,07])+"</td>
		cHtml += "  </tr>"
	Next nX

	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1086' border='0'>"

	cHtml += "  <tr>"
	//cHtml += "    <td><p>Caso o  pagamento jแ tenha ocorrido, solicitamos que desconsidere este aviso e nos  encaminhe o(s) comprovante(s) de pagamento, atrav้s do e-mail <a href='mailto:cobranca@pilaoprofessional.com.br'>cobranca@pilaoprofessional.com.br</a> </p></td>"
	cHtml += "    <td><p>Caso o  pagamento jแ tenha ocorrido, solicitamos que desconsidere este aviso e nos  encaminhe o(s) comprovante(s) de pagamento, atrav้s do e-mail <a href='mailto:cobranca@jubileudistribuidora.com'>cobranca@jubileudistribuidora.com</a> </p></td>"
	cHtml += "  </tr><br><br><br>"

	If nCobr == "3"
		cHtml += "  <tr><br>"
		cHtml += "    <td>O nใo pronunciamento ensejarแ no encaminhamento do(s) tํtulo(s) para cart๓rio.</td>"
		cHtml += "  </tr>"
	EndIf

	cHtml += "  <tr>"

	If !Empty(cChvnfe)
		cHtml += " <td>Para consultar sua nota fiscal referente a este titulo, utilize o hiperlink abaixo e copie e cole a chave de acesso no site.</td>"
		cHtml += "  </tr>"
		cHtml += "  <tr>"
		cHtml += "    <td><a href='http://www.nfe.fazenda.gov.br/portal/consultaRecaptcha.aspx?tipoConsulta=completa&tipoConteudo=XbSeqxE8pl8='>Clique Aqui</td>"
		cHtml += "  </tr>"
		cHtml += "  <tr>"
		cHtml += " <td><b>"+cChvnfe+"</b></td>"
	EndIF

	cHtml += "  </tr><br><br><br>"

	cHtml += "    <td><p><strong><h3>Cobran็a Jubileu</strong></h3><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "  <strong>T</strong>el 55 (11) 2176-2080 / (11) 96635-4669 <br />"

	cHtml += "  <strong>E-mail</strong><strong> </strong><a href='mailto:cobranca@jubileudistribuidora.com'>cobranca@jubileudistribuidora.com</a><u> </u></p></td>"
	cHtml += "  </tr>"

	cHtml += "</table>"


	cHtml += "</body>"
	cHtml += "</html>"

	RestArea(aArea)

Return(cHtml)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณMicrosiga           บ Data ณ  03/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AvisFin(cSubject,aCumula,cDono)

	Local cHtml	:=	"<html>"
	Local nX 	:=	0

	cHtml	+=	"	<head>		<title></title>	</head>"
	cHtml	+=	" 	<body><b>		<p>"+cSubject+" transmitidos.</b></p>"
	cHtml	+=	"	<table border='0' cellpadding='1' cellspacing='1' style='width: 1900px;'>
	cHtml	+=	"	<tr bgcolor='#0000FF'><td>Codigo Cliente</td>"
	cHtml	+=	"	<td>Loja</td>"
	cHtml	+=	"	<td>Nome</td>"
	cHtml	+=	"	<td>Titulo</td>"
	cHtml	+=	"	<td>Vencto.</td>"
	cHtml	+=	"	<td>Valor</td>"
	cHtml	+=	"	<td>Email</td>"
	cHtml	+=	"	</tr>"

	If Empty(cDono)
		For nX := 1 to len(aAvisFi)
			cHtml 	+= 	"<tr bgcolor='"+If(Mod(nX,2)==0,"#d4e6f6","#5592bb")+"'>"
			cHtml	+=	"	<td>"+aAvisFi[nX,01]+"</td>"
			cHtml	+=	"	<td>"+aAvisFi[nX,02]+"</td>"
			cHtml	+=	"	<td>"+aAvisFi[nX,03]+"</td>"
			cHtml	+=	"	<td>"+aAvisFi[nX,04]+"</td>"
			cHtml	+=	"	<td>"+aAvisFi[nX,05]+"</td>"
			cHtml	+=	"	<td>"+aAvisFi[nX,06]+"</td>"
			cHtml	+=	"	<td>"+Alltrim(aAvisFi[nX,07])+"</td>"
			cHtml	+=	"	</tr>"
		Next nX
	Else
		For nX := 1 to len(aAvisFi)
			If Alltrim(aAvisFi[nX,08]) == cDono
				cHtml 	+= 	"<tr bgcolor='"+If(Mod(nX,2)==0,"#d4e6f6","#5592bb")+"'>"
				cHtml	+=	"	<td>"+aAvisFi[nX,01]+"</td>"
				cHtml	+=	"	<td>"+aAvisFi[nX,02]+"</td>"
				cHtml	+=	"	<td>"+aAvisFi[nX,03]+"</td>"
				cHtml	+=	"	<td>"+aAvisFi[nX,04]+"</td>"
				cHtml	+=	"	<td>"+aAvisFi[nX,05]+"</td>"
				cHtml	+=	"	<td>"+aAvisFi[nX,06]+"</td>"
				cHtml	+=	"	<td>"+Alltrim(aAvisFi[nX,07])+"</td>"
				cHtml	+=	"	</tr>"
			EndIf
		Next nX
	EndIf

	cHtml 	+=	" </table>"
	cHtml	+=	"	<p>&nbsp;</p>"

	If len(aCumula) > 0

		cHtml 	+=	" 	<table border='0' cellpadding='1' cellspacing='1' style='width: 900px;'>"
		cHtml	+=	"	<tr><td>Cliente</td>"
		cHtml	+=	"	<td>Acumulado</td>"
		cHtml	+=	"	</tr>"

		Asort(aCumula,,,{|x,y| x[2] > y[2]})
 
		For nX := 1 to len(aCumula)
			cHtml 	+= 	"<tr>"
			cHtml	+=	"	<td>"+aCumula[nX,01]+"</td>"
			cHtml	+=	"	<td>"+Transform(aCumula[nX,02],"@E 999,999,999.99")+"</td>"
			cHtml	+=	"</tr>"
		Next nX
		cHtml 	+=	" </table>"
		cHtml	+=	"	<p>&nbsp;</p>"
	EndIf

	cHtml	+=	"	</body></html>"


Return(cHtml)

return

/*/
	Enviar o PDF da danfe junto

/*/

Static Function zGerDanfe(cNota, cSerie, cPasta, cMail)
	Local aArea     := GetArea()
	Local cIdent    := ""
	Local cArquivo  := ""
	Local oDanfe    := Nil
	Local lEnd      := .F.
	Local nTamNota  := TamSX3('F2_DOC')[1]
	Local nTamSerie := TamSX3('F2_SERIE')[1]
	Private PixelX
	Private PixelY
	Private nConsNeg
	Private nConsTex
	Private oRetNF
	Private nColAux
	Default cNota   := ""
	Default cSerie  := ""
	Default cPasta  := GetTempPath()

	//Se existir nota
	If ! Empty(cNota)
		//Pega o IDENT da empresa
		cIdent := RetIdEnti()

		//Gera o XML da Nota
		cArquivo := cNota + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")

		//Define as perguntas da DANFE
		Pergunte("NFSIGW",.F.)
		MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
		MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
		MV_PAR03 := PadR(cSerie, nTamSerie)    //S้rie da Nota
		MV_PAR04 := 2                          //NF de Saida
		MV_PAR05 := 1                          //Frente e Verso = Sim
		MV_PAR06 := 2                          //DANFE simplificado = Nao

		//Cria a Danfe
		oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., cPasta, .T.)

		//Propriedades da DANFE
		oDanfe:SetResolution(78)
		oDanfe:SetPortrait()
		oDanfe:SetPaperSize(DMPAPER_A4)
		oDanfe:SetMargin(60, 60, 60, 60)

		//For็a a impressใo em PDF
		oDanfe:nDevice  := 6
		oDanfe:cPathPDF := cPasta //"C:\Temp\" //cPasta
		oDanfe:lServer  := .F.
		oDanfe:lViewPDF := .F.

		//Variแveis obrigat๓rias da DANFE (pode colocar outras abaixo)
		PixelX    := oDanfe:nLogPixelX()
		PixelY    := oDanfe:nLogPixelY()
		nConsNeg  := 0.4
		nConsTex  := 0.5
		oRetNF    := Nil
		nColAux   := 0

		//Chamando a impressใo da danfe no RDMAKE
		RptStatus({|lEnd| StaticCall(DANFEII, DanfeProc, @oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
		oDanfe:Print()

		aArquivos := {}
		//Necessแrio enviar a copia para o servidor, caso o arquivo seja gerado localmente
		CPYT2S("C:\temp\"+cArquivo+".pdf",'\temp\')



	EndIf

	RestArea(aArea)

Return(cArquivo)

// Verifica se o arquivo esta com tamanho compativel - maior que 100 KB
Static Function ChkArq(cArquivo)

	Local nHdl := fopen(cArquivo, FO_READ + FO_SHARED)
	Local nTamArq := 0
	Local nTamMin := 92160 // 100KB tamanho minimo dos pdfs - 100*1024
	Local lRet := .T.

	If nHdl == -1
		fclose(nHdl)
		lRet := .F.
		Return lRet
	EndIf

	nTamArq := FSeek(nHdl, 0, FS_END)
	conout("Tamanho arquivo " +cArQuivo + " -> " +CVALTOCHAR(nTamArq) )   // retirar depois
	If nTamArq < nTamMin
		lRet := .F.
	EndIf

	fclose(nHdl)

Return lRet
