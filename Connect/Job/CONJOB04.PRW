#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CONJOB04 บAutor  ณ Alexandre Venancio  บ Data ณ  08/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de envio automatico de cartas de cobranca para o    บฑฑ
ฑฑบ          ณcliente conforme a data de vencimento.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function CONJOB4a(cCodEmp,cCodFil)

	Local cQuery
	Local cBody
	Local cSubject	:=	"Avisos de Vencimento"
	Local aArquivos := {}
	Local cDestino	:=	"alexandre.venancio@avsipro.com.br'
	Local dDtFour 	:= ''
	Local cNomeArq	:= ''
	Local aTitE1	:= {}
	
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


	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0101")
	EndIf

	cNomeArq := 'c:\temp\_avisos\'+dtos(ddatabase)+'.txt'

	Aadd(aArquivos,{"\system\LGRL01.png",'Content-ID: <ID_LGRL01,png>'})

	// Valida็ใo para 03 dias 22/02/2023 alterado para 1
/*
	IF DOW(dDataBase) == 2
		dDtFour := datavalida(dDataBase+1,.T.) //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtFour := datavalida(dDataBase+1,.T.)//+1 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtFour := datavalida(dDataBase+1,.T.)//+2 //Condi็ใo para Quarta
	ELSEIF DOW(dDataBase) == 5
		dDtFour := datavalida(dDataBase+1,.T.)//+2 //Condi็ใo para Quinta
	ELSE
		dDtFour := datavalida(dDataBase+1,.T.)//+2
	ENDIF
*/
	dDtFour := datavalida(dDataBase+3,.T.)

	cQuery := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_TIPO,E1_NATUREZ,ED_DESCRIC,E1_FILORIG,"
	cQuery += " E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_PARCELA,A1_CGC,"
	cQuery += " E1_PORTADO,E1.R_E_C_N_O_ AS REGE1,E1_NUMBCO,E1_CODBAR,E1_CODDIG,A1_XBOL"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
	cQuery += " WHERE E1_VENCREA = '"+DTOS(datavalida(dDtFour))+"' AND E1_BAIXA=' ' AND E1_PREFIXO <> 'CTR' "
	cQuery += " AND E1.D_E_L_E_T_='' AND E1_PORTADO BETWEEN '001' AND '999'"
	cQuery += " AND E1_FILIAL='"+xFilial('SE1')+"'"
	cQuery += " AND E1_TIPO NOT IN('RA','NCC')"
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
		//cDestino 	:=	"alexandre.venancio@avsipro.com.br;gustavo@connectvending.com.br" 
		MV_PAR01	:=	TRB->E1_PREFIXO
		MV_PAR02	:=	TRB->E1_NUM
		MV_PAR03	:=	TRB->E1_PARCELA
		MV_PAR04	:=	TRB->E1_PARCELA

		/*If File(cPasta+Alltrim(TRB->A1_CGC)+"\boleto_"+Alltrim(TRB->E1_NUM)+"_"+Alltrim(TRB->E1_PARCELA)+".PDF")
			cBoleto := cPasta+Alltrim(TRB->A1_CGC)+"\boleto_"+Alltrim(TRB->E1_NUM)+"_"+Alltrim(TRB->E1_PARCELA)+".PDF"
		else
			aArBkp := GetArea()
			U_ROBBOL(.T.,cPasta+alltrim(TRB->A1_CGC)+'\',TRB->E1_FILORIG,TRB->E1_PARCELA)
			RestArea(aArBkp)
			If File(cPasta+Alltrim(TRB->A1_CGC)+"\boleto_"+Alltrim(TRB->E1_NUM)+"_"+Alltrim(TRB->E1_PARCELA)+".PDF")
				cBoleto := cPasta+Alltrim(TRB->A1_CGC)+"\boleto_"+Alltrim(TRB->E1_NUM)+"_"+Alltrim(TRB->E1_PARCELA)+".PDF"
			else
				cBoleto := ""
			EndIf
		ENDIF*/

		cBody 		:=	Aviso_1(TRB->E1_CODDIG,TRB->A1_XBOL)

		aArquivos 	:=  {}

		//Aadd(aArquivos,{lower(cBoleto),''})

		//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
		U_EnviarEmail(cDestino,cSubject,cBody,'',.f.)

		cCorpo := TRB->E1_CLIENTE+'#'+TRB->E1_LOJA+'#'+TRB->A1_NOME+'#'+TRB->E1_PREFIXO+'#'+TRB->E1_NUM+'#'+CVALTOCHAR(STOD(TRB->E1_VENCREA))+'#'+Transform(TRB->E1_VALOR,"@E 999,999,999.99")+'#'+TRB->A1_EMAIL

		FWrite(nArq,cCorpo+CRLF)
		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL})
		Aadd(aTitE1,TRB->REGE1)
		dbSelectArea("TRB")
		DbSkip()
	EndDo

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+CRLF)
	fClose(nArq)

	cBody := AvisFin(cSubject,{})

	cDestino := "alexandre.venancio@avsipro.com.br;gustavo@connectvending.com.br;cobrancas@connectvending.com.br;financeiro@connectvending.com.br"

	//U_robmail(cRemete,cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,{},.T.)
	U_EnviarEmail(cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,'',.f.)

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

User Function CONJOB4b(cCodEmp,cCodFil)

	Local aArea		:=	GetArea()
	Local cQuery
	Local cBody
	Local cSubject	:=	"Aviso de Cobran็a"
	Local aArquivos := {}
	Local cDestino	:=	"alexandre.venancio@avsipro.com.br"
	Local cCliente	:=	''
	Local nCont		:=	1
	Local dDtOne  	:= ''
	Local dDtTwo  	:= ''
	Local dDtTree 	:= ''
	Local aTitE1	:= {}

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

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0101")
	EndIf

	cNomeArq := 'c:\temp\_cobrancas\'+dtos(ddatabase)+'.txt'

	Aadd(aArquivos,{"\system\LGRL01.PNG",'Content-ID: <ID_LGRL01.PNG>'})

	// Valida็ใo para 03 dias

	IF DOW(dDataBase) == 2
		dDtOne := datavalida(dDataBase-3,.F.)-2 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtOne := datavalida(dDataBase-3,.F.)-2//-1 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtOne := datavalida(dDataBase-3,.T.)-2//+2 //Condi็ใo para Quarta
	ELSE
		dDtOne := datavalida(dDataBase-3,.F.)
	ENDIF

	cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,"
	cQuery += " E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,"
	cQuery += " E1_VALJUR,E1.R_E_C_N_O_ AS REGE1"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtOne,.F.))+"' AND E1_BAIXA=' ' AND E1_PREFIXO <> 'CTR' "
	cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_FILIAL='"+xFilial('SE1')+"'"
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '001' AND '999'"
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
				cBody := Cobranca1()
				//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
				U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.BMP",.f.)
				aTitCli := {}
				cDestino := Alltrim(TRB->A1_EMAIL)
				cDestino := "hayewok628@jontra.com"
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
						Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
						TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})

				EndIf
				cDestino := Alltrim(TRB->A1_EMAIL)
				cDestino := "hayewok628@jontra.com"
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
					Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
					TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})
			EndIf
			cDestino := Alltrim(TRB->A1_EMAIL)
			cDestino := "hayewok628@jontra.com"
		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRB->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRB->A1_NOME,TRB->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRB->E1_VALOR
		EndIf

		cCorpo := TRB->E1_CLIENTE+'/'+TRB->E1_LOJA+'/'+TRB->A1_NOME+'/'+TRB->E1_PREFIXO+'/'+TRB->E1_NUM+'/'+CVALTOCHAR(STOD(TRB->E1_VENCREA))+'/'+Transform(TRB->E1_VALOR,"@E 999,999,999.99")+'/'+TRB->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL})
		Aadd(aTitE1,TRB->REGE1)
		Dbskip()
	Enddo

	If len(aTitCli) > 0
		cBody := Cobranca1()
		//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
		U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		cBody := AvisFin(cSubject,aCumula)
		cDestino := "alexandre.venancio@avsipro.com.br"
		//U_robmail(cRemete,cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,{},.T.)
		U_EnviarEmail(cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,"",.f.)
	EndIf

	// Valida็ใo para 05 dias 22/02/2023 alterado para 7

	IF DOW(dDataBase) == 2
		dDtTwo := datavalida(dDataBase-7,.F.)//-1 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtTwo := datavalida(dDataBase-7,.F.)//-2 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtTwo := datavalida(dDataBase-7,.F.)//-2 //Condi็ใo para Quarta
	ELSEIF DOW(dDataBase) == 5
		dDtTwo := datavalida(dDataBase-7,.F.)//-1 //Condi็ใo para Quinta
	ELSE
		dDtTwo := datavalida(dDataBase-7,.F.)
	ENDIF


	cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,"
	cQuery += " E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,"
	cQuery += " E1_VALJUR,E1.R_E_C_N_O_ AS REGE1"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=' '"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtTwo,.F.))+"' AND E1_BAIXA=' ' AND E1_PREFIXO <> 'CTR' "
	cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_FILIAL='"+xFilial('SE1')+"'"
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '001' AND '999'"
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
				cBody := Cobranca2()
				//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
				U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
				aTitCli := {}

				cDestino := Alltrim(TRB->A1_EMAIL)
				cDestino := "hayewok628@jontra.com"
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
						Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
						TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})

				EndIf
				
				cDestino := Alltrim(TRB->A1_EMAIL)
				cDestino := "hayewok628@jontra.com"
				
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
					Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
					TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})
			EndIf
			
			cDestino := Alltrim(TRB->A1_EMAIL)
			cDestino := "hayewok628@jontra.com"
			
		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRB->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRB->A1_NOME,TRB->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRB->E1_VALOR
		EndIf

		cCorpo := TRB->E1_CLIENTE+'/'+TRB->E1_LOJA+'/'+TRB->A1_NOME+'/'+TRB->E1_PREFIXO+'/'+TRB->E1_NUM+'/'+CVALTOCHAR(STOD(TRB->E1_VENCREA))+'/'+Transform(TRB->E1_VALOR,"@E 999,999,999.99")+'/'+TRB->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL})
		Aadd(aTitE1,TRB->REGE1)
		Dbskip()
	EndDo

	If len(aTitCli) > 0
		cBody := Cobranca2()
		//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
		U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		cBody := AvisFin(cSubject,aCumula)
		cDestino := "alexandre.venancio@avsipro.com.br"
		//U_robmail(cRemete,cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,{},.T.)
		U_EnviarEmail(cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,"",.f.)
	EndIf

	// Valida็ใo para 07 dias   22/02/2023  alterado para 9

	IF DOW(dDataBase) == 2
		dDtTree := datavalida(dDataBase-7,.F.)-4 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtTree := datavalida(dDataBase-7,.F.)-4 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Quarta
	ELSEIF DOW(dDataBase) == 5
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Quinta
	ELSE //DOW(dDataBase) == 6
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Sexta
	ENDIF

	cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,"
	cQuery += " E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,"
	cQuery += " E1_VALJUR,E1.R_E_C_N_O_ AS REGE1"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=' '"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtTree,.F.))+"' AND E1_BAIXA='' AND E1_PREFIXO <> 'CTR' "
	cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_FILIAL='"+xFilial('SE1')+"'"
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '001' AND '999'"
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
				cBody := Cobranca3()
				//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
				U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
				aTitCli := {}
				cDestino := Alltrim(TRB->A1_EMAIL) //
				cDestino := "hayewok628@jontra.com"
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
						Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
						TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})

				EndIf
				cDestino := Alltrim(TRB->A1_EMAIL) 
				cDestino := "hayewok628@jontra.com"
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
					Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
					TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})
			EndIf

			cDestino := Alltrim(TRB->A1_EMAIL) //
			cDestino := "hayewok628@jontra.com"
		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRB->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRB->A1_NOME,TRB->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRB->E1_VALOR
		EndIf

		cCorpo := TRB->E1_CLIENTE+'/'+TRB->E1_LOJA+'/'+TRB->A1_NOME+'/'+TRB->E1_PREFIXO+'/'+TRB->E1_NUM+'/'+CVALTOCHAR(STOD(TRB->E1_VENCREA))+'/'+Transform(TRB->E1_VALOR,"@E 999,999,999.99")+'/'+TRB->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL})
		Aadd(aTitE1,TRB->REGE1)
		Dbskip()
	Enddo

	If len(aTitCli) > 0
		cBody := Cobranca3()
		//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
		U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		cBody := AvisFin(cSubject,aCumula)

		cDestino := "alexandre.venancio@avsipro.com.br"
		//U_robmail(cRemete,cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,{},.T.)
		U_EnviarEmail(cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,"",.f.)
	EndIf

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

Static Function Aviso_1(cBoleto,cGerBol)

	Local aArea	:=	GetArea()

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1078' border='0'>"
	cHtml += "  <tr bgcolor='#33FFFF'>"
	cHtml += "    <td align='center'><b>Aviso de vencimento / NOTA  Nบ "+TRB->E1_NUM+" Prefixo "+TRB->E1_PREFIXO+" "+cvaltochar(STOD(TRB->E1_VENCREA))+"</b></td>"
	cHtml += "  </tr>"
	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1078' border='0'>"
	cHtml += "  <tr bgcolor='#d4e6f6'>"
	cHtml += "    <td >Cedente:</td><td><b>"+Alltrim(SM0->M0_NOMECOM)+"</b></td></tr>"
	cHtml += "    <tr bgcolor='#5592bb'><td>Sacado:</td><td><b>"+Alltrim(TRB->A1_NOME)+"</b> CำDIGO "+TRB->E1_CLIENTE+TRB->E1_LOJA+" CNPJ "+Transform(TRB->A1_CGC,"@R 99.999.999/9999-99")+"</td></tr>"
	cHtml += "    <tr bgcolor='#d4e6f6'><td>Valor:</td><td><b>R$ "+cvaltochar(Transform(TRB->E1_VALOR,"@E 999,999,999.99"))+"</b></td></tr>"
	cHtml += "    <tr bgcolor='#d4e6f6'><td>Vencimento:</td><td><b>"+cvaltochar(Stod(TRB->E1_VENCREA))+"</b></td></tr>"
	cHtml += "    <tr bgcolor='#d4e6f6'><td>Refer๊ncia:</td><td><b>"+Alltrim(TRB->ED_DESCRIC)+"</b></td></tr>"
	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1078' border='0'>"
	cHtml += "  <tr>"
	cHtml += "    <td>Prezado (a), Cliente<br>"
	cHtml += Alltrim(TRB->A1_NOME)+" Cnpj "+Transform(TRB->A1_CGC,'@R 99.999.999/9999-99')+"<br>"
	cHtml += "Lembramos do vencimento de sua nota fiscal para o dia ( "+cvaltochar(stod(TRB->E1_VENCREA))+" ) "+IF(!Empty(cBoleto),", se encontra em anexo.","")+"<br>"
	cHtml += "Essa ้ uma mensagem automแtica, caso jแ tenha efetuado o pagamento, por favor desconsiderar o e-mail</td>"
	cHtml += "  </tr><br>"

	If !Empty(cBoleto)

		cLinhaD := 	substr(cBoleto,1,5)+'.'+;
					substr(cBoleto,6,5)+' '+;
					substr(cBoleto,11,5)+'.'+;
					substr(cBoleto,16,6)+' '+;
					substr(cBoleto,22,5)+'.'+;
					substr(cBoleto,27,6)+'  '+;
					substr(cBoleto,33,1)+'  '+;
					substr(cBoleto,34);

		cHtml += " <tr>"
		cHtml += "    <td>Para agilizar o processo, estamos incluindo a linha digitแvel do boleto.</td>"
		cHtml += " </tr>"
		cHtml += " <tr>"
		cHtml += " <td><b>"+cLinhaD+"</b></td>"
		cHtml += " </tr>"

		cHtml += "<br><br>"
	else
		cHtml += " <tr>"
		cHtml += "  <td>Para agilizar o processo, estamos incluindo os dados bancแrios abaixo:</td>"
		cHtml += " </tr>"
		cHtml += " <tr>"
		cHtml += "  <td>Itau Unibanco</td>"
		cHtml += " </tr>"
		cHtml += " <tr>"
		cHtml += "  <td>Ag. 0048</td>"
		cHtml += " </tr>"
		cHtml += " <tr>"
		cHtml += "  <td>CC. 53663-5</td>"
		cHtml += " </tr>"
		cHtml += " <tr>"
		cHtml += "  <td>Razใo Social: CONNECT VENDING COMERCIO DE MAQUINAS AUTOMATIZADAS LTDA</td>"
		cHtml += " </tr>"
		cHtml += " <tr>"
		cHtml += "  <td>CNPJ: 24.575.331/0001-18</td>"	
		cHtml += " </tr>"
	EndIf

	cHtml += "  <tr>"
	cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
	cHtml += "  <strong>T</strong>el 55 (11) "+SM0->M0_TEL+" Celular / WhatsApp: (11) xxx  <br />" 
	cHtml += "  <strong>E-mail</strong><strong> </strong><a href='mailto:financeiro@.com.br'>financeiro@connectvending.com.br</a><u> </u></p></td>"
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

Static Function Cobranca1()

	Local aArea	:= GetArea()
	Local cHtml
	Local nX 	:= 0

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
	cHtml += " </tr>"
	cHtml += " <tr><br><br><br>"
	cHtml += "    <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"
	cHtml += "</tr></table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td><p>Prezado Cliente,</p></td></tr><tr>"
	cHtml += "  <td><p>"+substr(aTitCli[1,11],1,6)+"-"+substr(aTitCli[1,11],7,2)+" / "+Alltrim(aTitCli[1,8])+"</p></td>"
	cHtml += "  </tr><br><br>"
	cHtml += "  <tr>"
	cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do tํtulo abaixo relacionado. Pedimos para efetuar o pagamento para evitar possํvel protestos/negativa็ใo. Para qualquer d๚vida, entrar em contato atrav้s do telefone (11) "+SM0->M0_TEL
	cHtml += "  Caso o pagamento jแ tenha ocorrido, anterior เ data de hoje, solicitamos que desconsidere este aviso e nos encaminhe o comprovante de pagamento atrav้s do e-mail: financeiro@connectvending.com.br , informando o numero do seu CNPJ."
	
	cHtml += "  </tr>"
	cHtml += "</table>
	cHtml += "<br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td align='center' bgcolor='#33FFFF'><b>N๚mero NF</b></td><td align='center' bgcolor='#33FFFF'><b>Emissใo</b></td><td align='center' bgcolor='#33FFFF'><b>Vencimento</b></td><td align='center' bgcolor='#33FFFF'><b>Valor</b></td><td align='center' bgcolor='#33FFFF'><b>Natureza</b></td>"
	cHtml += "  </tr>"

	For nX := 1 to len(aTitCli)
		cHtml += "  <tr>"
		cHtml += "<td align='center'>"+aTitCli[nX,10]+aTitCli[nX,01]+"</td><td align='center'>"+cvaltochar(aTitCli[nX,02])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,03])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,04])+"</td><td align='center'>"+Alltrim(aTitCli[nX,07])+"</td>
		cHtml += "  </tr>"
	Next nX

	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += " <br><br><b>Esta mensagem nใo cont้m anexos</b><br><br>
	cHtml += "</table><br><br>

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "    <td><p>Certos de  vossa aten็ใo, permanecemos no aguardo.</p></td>"
	cHtml += "  </tr><br><br><br>"
	cHtml += "  <tr>"
	cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
	cHtml += "  <strong>T</strong>el 55 (11) "+SM0->M0_TEL+" Celular / WhatsApp: (11) XXX  <br />"
	cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:financeiro@connectvending.com.br'>financeiro@connectvending.com.br</a></p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "	<td><img src='cid:LGRL01.PNG'></td>"
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
ฑฑบDesc.     ณ 2 Aviso, enviado xx dias apos o vencimento do titulo.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cobranca2()

	Local aArea	:=	GetArea()
	Local cHtml
	Local nX  	:=	0

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
	cHtml += "</tr>"
	cHtml += "  <tr>"
	cHtml += " <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"
	cHtml += "</tr></table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td><p>Prezado Cliente,</p></td></tr><tr>"
	cHtml += "  <td><p>"+substr(aTitCli[1,11],1,6)+"-"+substr(aTitCli[1,11],7,2)+" / "+Alltrim(aTitCli[1,8])+"</p></td>"
	cHtml += "  </tr><br><br>"
	cHtml += "  <tr>"
	cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do tํtulo abaixo relacionado. Pedimos para efetuar o pagamento para evitar possํvel protestos/negativa็ใo. Para qualquer d๚vida, entrar em contato atrav้s do telefone (11) "+SM0->M0_TEL
	cHtml += "  Caso o pagamento jแ tenha ocorrido, anterior เ data de hoje, solicitamos que desconsidere este aviso e nos encaminhe o comprovante de pagamento atrav้s do e-mail: financeiro@connectvending.com.br , informando o numero do seu CNPJ."
	
	cHtml += "  </tr>"
	cHtml += "</table>
	cHtml += "<br><br><br>"

	cHtml += "<table width='1081' border='0'>"

	cHtml += "  <tr>"
	cHtml += "  <td align='center' bgcolor='#33FFFF'><b>N๚mero NF</b></td><td align='center' bgcolor='#33FFFF'><b>Emissใo</b></td><td align='center' bgcolor='#33FFFF'><b>Vencimento</b></td><td align='center' bgcolor='#33FFFF'><b>Valor</b></td><td align='center' bgcolor='#33FFFF'><b>Natureza</b></td>"
	cHtml += "  </tr>"

	For nX := 1 to len(aTitCli)
		cHtml += "  <tr>"
		cHtml += "<td align='center'>"+aTitCli[nX,10]+aTitCli[nX,01]+"</td><td align='center'>"+cvaltochar(aTitCli[nX,02])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,03])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,04])+"</td><td align='center'>"+Alltrim(aTitCli[nX,07])+"</td>
		cHtml += "  </tr>"
	Next nX

	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += " <br><br><b>Esta mensagem nใo cont้m anexos</b><br><br>
	cHtml += "</table><br><br>

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  </tr>"
	cHtml += "  <tr><br>"
	cHtml += "    <td><p><em>Certos  da vossa aten็ใo, permanecemos no aguardo.</em></p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td>&nbsp;</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
	cHtml += "  <strong>T</strong>el 55 (11) "+SM0->M0_TEL+" Celular / WhatsApp: (11) XXX <br />" 
	cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:financeiro@connectvending.com.br'>financeiro@connectvending.com.br</a></p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "	<td><img src='cid:LGRL01.PNG'></td>"
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
ฑฑบDesc.     ณ  3 Aviso, enviado xx dias apos o vencimento do titulo.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cobranca3()

	Local aArea	:=	GetArea()
	Local cHtml
	Local nX 	:=	0

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
	cHtml += "</tr>"
	cHtml += "  <tr>"
	cHtml += " <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"
	cHtml += "</tr></table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td><p>Prezado Cliente,</p></td></tr><tr>"
	cHtml += "  <td><p>"+substr(aTitCli[1,11],1,6)+"-"+substr(aTitCli[1,11],7,2)+" / "+Alltrim(aTitCli[1,8])+"</p></td>"
	cHtml += "  </tr><br><br>"
	cHtml += "  <tr>"
	cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do tํtulo abaixo relacionado. Pedimos para efetuar o pagamento para evitar possํvel protestos/negativa็ใo. Para qualquer d๚vida, entrar em contato atrav้s do telefone (11) "+SM0->M0_TEL
	cHtml += "  Caso o pagamento jแ tenha ocorrido, anterior เ data de hoje, solicitamos que desconsidere este aviso e nos encaminhe o comprovante de pagamento atrav้s do e-mail: financeiro@connectvending.com.br , informando o numero do seu CNPJ."
	
	cHtml += "  </tr>"
	cHtml += "</table>
	cHtml += "<br><br><br>"
	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td align='center' bgcolor='#33FFFF'><b>N๚mero NF</b></td><td align='center' bgcolor='#33FFFF'><b>Emissใo</b></td><td align='center' bgcolor='#33FFFF'><b>Vencimento</b></td><td align='center' bgcolor='#33FFFF'><b>Valor</b></td><td align='center' bgcolor='#33FFFF'><b>Natureza</b></td>"
	cHtml += "  </tr>"

	For nX := 1 to len(aTitCli)
		cHtml += "  <tr>"
		cHtml += "<td align='center'>"+aTitCli[nX,10]+aTitCli[nX,01]+"</td><td align='center'>"+cvaltochar(aTitCli[nX,02])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,03])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,04])+"</td><td align='center'>"+Alltrim(aTitCli[nX,07])+"</td>
		cHtml += "  </tr>"
	Next nX

	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += " <br><br><b>Esta mensagem nใo cont้m anexos</b><br><br>
	cHtml += "</table><br><br>

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  </tr>"
	cHtml += "  <tr><br>"
	cHtml += "    <td>O nใo pronunciamento ensejarแ no encaminhamento do(s) tํtulo(s) para cart๓rio.</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td><p>Certos  de vossa aten็ใo, permanecemos no aguardo. </p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td>&nbsp;</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
	cHtml += "  <strong>T</strong>el 55 (11) "+SM0->M0_TEL+" Celular / WhatsApp: (11) XXX <br />"
	cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:financeiro@connectvending.com.br'>financeiro@connectvending.com.br</a></p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td>&nbsp;</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "	<td><img src='cid:LGRL01.png'></td>"
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

Static Function AvisFin(cSubject,aCumula)

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

