#INCLUDE "PROTHEUS.CH"      
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณAlexandre Venancio  บ Data ณ  01/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de envio automatico de cartas de cobranca para o    บฑฑ
ฑฑบ          ณcliente conforme a data de vencimento.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                           

User Function AMCFIN11(cCodEmp,cCodFil)

Local aArea		:=	GetArea()
Local cQuery                 
Local cRemete   := "contasareceber@toktake.com.br"
Local cBody                                   
Local cSubject	:=	"Aviso de Vencimento"
Local aArquivos := {}           
Local cDestino	:=	""	//"avenanc@yahoo.com.br" 
Local cDestFin	:=	GetMV("MV_XMAILCB")
Local cCliente	:=	'' 
Local nCont		:=	1
Local dDtOne  := ''
Local dDtTwo  := ''
Local dDtTree := ''
Local dDtFour := ''

                        
Private aAvisFi	:= {}                        
Private aTitCli	:= {}

Default cCodEmp := "10"
//Default cCodFil := "01"

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
                    
                      
PREPARE ENVIRONMENT EMPRESA "10" FILIAL "01" TABLES "SE1"

Aadd(aArquivos,{"\system\logo_amc.png",'Content-ID: <ID_logo_amc.png>'})

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

cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_NATUREZ,ED_DESCRIC,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_PARCELA,A1_CGC"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
cQuery += " WHERE E1_VENCREA = '"+DTOS(datavalida(dDtFour))+"' AND E1_BAIXA='' AND E1_PREFIXO <> 'CTR' "
cQuery += " AND E1.D_E_L_E_T_=''"
cQuery += " ORDER BY E1_CLIENTE"                        

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")
                
While !EOF()
    cBody := Aviso_1()                                                
 
	cDestino := Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
	//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
    U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
    Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL})
    U_TTGENC01(xFilial("SE1"),FUNDESC(),"AVISO DE VENCIMENTO",TRB->E1_PREFIXO,TRB->E1_NUM,TRB->E1_PARCELA,cusername,dtos(dDataBase),cvaltochar(time()),TRB->E1_VALOR,"Enviado aviso de vencimento do titulo",TRB->E1_CLIENTE,TRB->E1_LOJA,"SE1")
	DbSkip()
EndDo

If len(aAvisFi) > 0 
	cBody := AvisFin(cSubject)
	//cDestino := 'vzukurov@toktake.com.br;rjesus@toktake.com.br;fin.amc@toktake.com.br'
	//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
	U_TTMAILN(cRemete,cDestFin,cSubject+" "+cvaltochar(ddatabase),cBody,{},.T.)
EndIf

//Valida็ใo para 03 dias

IF DOW(dDataBase) == 2                    
	dDtOne := datavalida(dDataBase-3,.F.)-2 //Condi็ใo para Segunda
ELSEIF DOW(dDataBase) == 3
	dDtOne := datavalida(dDataBase-3,.F.)-1 //Condi็ใo para Ter็a
ELSE
	dDtOne := datavalida(dDataBase-3,.F.)
ENDIF

cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_VALJUR,ZL_TIPOMOV,ZL_DATA"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SZL")+" ZL ON ZL_PREFIXO=E1_PREFIXO AND ZL_DOCTO=E1_NUM AND ZL_SERIE=E1_PARCELA AND ZL_CLIENTE=E1_CLIENTE AND ZL_LOJA=E1_LOJA AND ZL.D_E_L_E_T_=''"
cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtOne,.F.))+"' AND E1_BAIXA='' AND E1_PREFIXO <> 'CTR' "
cQuery += " AND E1_TIPO='NF'"
cQuery += " AND E1.D_E_L_E_T_=''" 
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

While !EOF() 
    
	//If Substr(TRB->ZL_TIPOMOV,1,7) != "1 AVISO"
		If cCliente != TRB->E1_CLIENTE+TRB->E1_LOJA
			cCliente := TRB->E1_CLIENTE+TRB->E1_LOJA
			If Len(aTitCli) > 0
				cBody := Cobranca1()
				U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
				aTitCli := {}		                                     
				cDestino	:=	Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
				//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
//					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
//									DDATABASE-STOD(E1_VENCREA),Alltrim(TRB->A1_NOME),TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})	
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
							DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
							Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
							TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})	

				EndIf
				cDestino	:=	Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
				//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
//				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
//								DDATABASE-STOD(E1_VENCREA),Alltrim(TRB->A1_NOME),TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})	
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
							DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
							Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
							TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})	
			EndIf
			cDestino	:=	Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
			//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
		EndIf

	    Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL})
	    U_TTGENC01(xFilial("SE1"),FUNDESC(),"1 AVISO COBRANCA",TRB->E1_PREFIXO,TRB->E1_NUM,TRB->E1_PARCELA,cusername,dtos(dDataBase),cvaltochar(time()),TRB->E1_VALOR,"Enviado 1 aviso de cobranca do titulo",TRB->E1_CLIENTE,TRB->E1_LOJA,"SE1")

	//EndIf
			
	Dbskip()
Enddo
                         
If len(aTitCli) > 0
	cBody := Cobranca1()  
	U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
	aTitCli := {}		
EndIf

If len(aAvisFi) > 0 
	cBody := AvisFin(cSubject)
	//cDestino := 'vzukurov@toktake.com.br;avenanc@yahoo.com.br;rjesus@toktake.com.br;fin.amc@toktake.com.br'
	//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
	U_TTMAILN(cRemete,cDestFin,cSubject+" "+cvaltochar(ddatabase),cBody,{},.T.)
EndIf

// Valida็ใo para 05 dias 

IF DOW(dDataBase) == 2         
	dDtTwo := datavalida(dDataBase-5,.F.)-2 //Condi็ใo para Segunda                         
ELSEIF DOW(dDataBase) == 3
	dDtTwo := datavalida(dDataBase-5,.F.)-2 //Condi็ใo para Ter็a
ELSEIF DOW(dDataBase) == 4
	dDtTwo := datavalida(dDataBase-5,.F.)-2 //Condi็ใo para Quarta
ELSEIF DOW(dDataBase) == 5
	dDtTwo := datavalida(dDataBase-5,.F.)-1 //Condi็ใo para Quinta	
ELSE
	dDtTwo := datavalida(dDataBase-5,.F.)
ENDIF


cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_VALJUR,ZL_TIPOMOV,ZL_DATA"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SZL")+" ZL ON ZL_PREFIXO=E1_PREFIXO AND ZL_DOCTO=E1_NUM AND ZL_SERIE=E1_PARCELA AND ZL_CLIENTE=E1_CLIENTE AND ZL_LOJA=E1_LOJA AND ZL.D_E_L_E_T_='' AND ZL_TIPOMOV LIKE '1 AVISO COBRANCA%'"
cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtTwo,.F.))+"' AND E1_BAIXA='' AND E1_PREFIXO <> 'CTR' "// AND E1_EMISSAO>'20120101'" 
cQuery += " AND E1_TIPO='NF'"
cQuery += " AND E1.D_E_L_E_T_='' AND E1_NUMBCO<>''"
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

While !EOF() 

	//If Substr(TRB->ZL_TIPOMOV,1,7) == "1 AVISO" .AND. STOD(TRB->ZL_DATA) != DDATABASE 
		If cCliente != TRB->E1_CLIENTE
			cCliente := TRB->E1_CLIENTE+TRB->E1_LOJA
			If Len(aTitCli) > 0
				cBody := Cobranca2()
				U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
				aTitCli := {}		                                     
				cDestino	:=	Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
				//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
							DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
							Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
							TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})	
				EndIf
				cDestino	:=	Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
				//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
								DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
								Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
								TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})	
			EndIf
			cDestino	:=	Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
			//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
		EndIf

	    Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL})
	    U_TTGENC01(xFilial("SE1"),FUNDESC(),"2 AVISO COBRANCA",TRB->E1_PREFIXO,TRB->E1_NUM,TRB->E1_PARCELA,cusername,dtos(dDataBase),cvaltochar(time()),TRB->E1_VALOR,"Enviado 2 aviso de cobranca do titulo",TRB->E1_CLIENTE,TRB->E1_LOJA,"SE1")

	//EndIf

		
	Dbskip()
Enddo
                         
If len(aTitCli) > 0
	cBody := Cobranca2()
	U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
	aTitCli := {}		
EndIf  

If len(aAvisFi) > 0 
	cBody := AvisFin(cSubject)
	//cDestino	:=	'vzukurov@toktake.com.br;avenanc@yahoo.com.br;rjesus@toktake.com.br;fin.amc@toktake.com.br'
	//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
	U_TTMAILN(cRemete,cDestFin,cSubject+" "+cvaltochar(ddatabase),cBody,{},.T.)
EndIf

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


cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_VALJUR,ZL_TIPOMOV,ZL_DATA"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SZL")+" ZL ON ZL_PREFIXO=E1_PREFIXO AND ZL_DOCTO=E1_NUM AND ZL_SERIE=E1_PARCELA AND ZL_CLIENTE=E1_CLIENTE AND ZL_LOJA=E1_LOJA AND ZL.D_E_L_E_T_='' AND ZL_TIPOMOV LIKE '2 AVISO COBRANCA%'"
cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtTree,.F.))+"' AND E1_BAIXA='' AND E1_PREFIXO <> 'CTR' "// AND E1_EMISSAO>'20120101'"   
cQuery += " AND E1_TIPO='NF'"
cQuery += " AND E1.D_E_L_E_T_='' AND E1_NUMBCO<>''"
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

While !EOF() 

	//If Substr(TRB->ZL_TIPOMOV,1,7) == "2 AVISO" .AND. STOD(TRB->ZL_DATA) != DDATABASE 
		If cCliente != TRB->E1_CLIENTE
			cCliente := TRB->E1_CLIENTE+TRB->E1_LOJA
			If Len(aTitCli) > 0
				cBody := Cobranca3()
				U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
				aTitCli := {}		                                     
				cDestino := Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
				//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
					Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
							DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
							Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
							TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})	
				EndIf
				cDestino := Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
				//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRB->E1_NUM}) == 0
				Aadd(aTitCli,{TRB->E1_NUM,stod(TRB->E1_EMISSAO),stod(TRB->E1_VENCREA),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;
							DDATABASE-STOD(E1_VENCREA),Transform(TRB->E1_VALJUR,"@E 999,999,999.99"),TRB->ED_DESCRIC,TRB->A1_NOME,;
							Transform(TRB->E1_VALOR+(TRB->E1_VALJUR*(DDATABASE-STOD(TRB->E1_VENCREA))),"@E 999,999,999.99"),;
							TRB->E1_PREFIXO,TRB->E1_CLIENTE+TRB->E1_LOJA})	
			EndIf
			cDestino := Alltrim(TRB->A1_EMAIL)+";fin.amc@toktake.com.br"
			//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
		EndIf
	
		Aadd(aAvisFi,{TRB->E1_CLIENTE,TRB->E1_LOJA,TRB->A1_NOME,TRB->E1_PREFIXO+TRB->E1_NUM,CVALTOCHAR(STOD(TRB->E1_VENCREA)),Transform(TRB->E1_VALOR,"@E 999,999,999.99"),TRB->A1_EMAIL})
	    U_TTGENC01(xFilial("SE1"),FUNDESC(),"3 AVISO COBRANCA",TRB->E1_PREFIXO,TRB->E1_NUM,TRB->E1_PARCELA,cusername,dtos(dDataBase),cvaltochar(time()),TRB->E1_VALOR,"Enviado 3 aviso de cobranca do titulo",TRB->E1_CLIENTE,TRB->E1_LOJA,"SE1")
	
	//EndIf

			
	Dbskip()
Enddo
                         
If len(aTitCli) > 0
	cBody := Cobranca3()
	U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
	aTitCli := {}		
EndIf
                  

If len(aAvisFi) > 0 
	cBody := AvisFin(cSubject)
	//cDestino	:=	'vzukurov@toktake.com.br;avenanc@yahoo.com.br;rjesus@toktake.com.br;fin.amc@toktake.com.br'
	//cDestino	:=	"rjesus@toktake.com.br"//;fin.amc@toktake.com.br;vzukurov@toktake.com.br" 
	U_TTMAILN(cRemete,cDestFin,cSubject+" "+cvaltochar(ddatabase),cBody,{},.T.)
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

Static Function Aviso_1()

Local aArea	:=	GetArea()

cHtml := "<html>"
cHtml += "<body>"
cHtml += "<style type='text/css'>"
cHtml += " body,td,th {"
cHtml += "	font-family: Verdana, Geneva, sans-serif;"
cHtml += "	color: #000;"
cHtml += "	}"
cHtml += " </style>"


cHtml += "<table width='1078' border='0'>"
cHtml += "  <tr bgcolor='#33FFFF'>"
cHtml += "    <td align='center'><b>Aviso de vencimento / NOTA  Nบ "+TRB->E1_NUM+" Prefixo "+TRB->E1_PREFIXO+" "+cvaltochar(STOD(TRB->E1_VENCREA))+"</b></td>"
cHtml += "  </tr>"
cHtml += "</table><br><br><br>"

cHtml += "<table width='1078' border='0'>"
cHtml += "  <tr>"
cHtml += "    <td>Cedente:</td><td><b>"+Alltrim(SM0->M0_NOMECOM)+"</b></td></tr>"
cHtml += "    <tr><td>Sacado:</td><td><b>"+Alltrim(TRB->A1_NOME)+"</b> CำDIGO "+TRB->E1_CLIENTE+TRB->E1_LOJA+" CNPJ "+Transform(TRB->A1_CGC,"@R 99.999.999/9999-99")+"</td></tr>"
cHtml += "    <tr><td>Valor:</td><td><b>R$ "+cvaltochar(Transform(TRB->E1_VALOR,"@E 999,999,999.99"))+"</b></td></tr>"
cHtml += "    <tr><td>Vencimento:</td><td><b>"+cvaltochar(Stod(TRB->E1_VENCREA))+"</b></td></tr>"
cHtml += "    <tr><td>Refer๊ncia:</td><td><b>"+Alltrim(TRB->ED_DESCRIC)+"</b></td></tr>"
cHtml += "</table><br><br><br>"
cHtml += " <br><br><b>Esta mensagem nใo cont้m anexos</b><br><br>

cFilant := SUBSTR(TRB->E1_PREFIXO,1,2)
Opensm0(cempant+cFilant)
Openfile(cempant+cFilant)

cHtml += "<table width='1078' border='0'>"
cHtml += "  <tr>"
cHtml += "    <td>Lembramos  que o boleto poderแ ser pago em qualquer ag๊ncia, lot้rica ou local credenciado  เ rede bancแria at้ a data do vencimento.</td>"
cHtml += "  </tr><br>"
cHtml += "  <tr>"
cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
cHtml += "      Departamento Financeiro<br />"
cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
cHtml += "  <strong>T</strong>el 55 "+SM0->M0_TEL+" <br />"
cHtml += "  <strong>Fax</strong> 55 "+SM0->M0_FAX+"<br />"
cHtml += "  <strong>E-mail</strong><strong> </strong><a href='mailto:contasareceber@toktake.com.br'>contasareceber@toktake.com.br</a><u> </u></p></td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "	<td><img src='cid:logo_amc.png'></td>"
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

cHtml := "<html>"
cHtml += "<body>"
cHtml += "<style type='text/css'>"
cHtml += " body,td,th {"
cHtml += "	font-family: Verdana, Geneva, sans-serif;"
cHtml += "	color: #000;"
cHtml += "	}"
cHtml += " </style>"

cHtml += "<table width='1081' border='0'>" 
cHtml += "  <tr>"
cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
cHtml += " </tr>"
cHtml += " <tr><br><br><br>"
cHtml += "    <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"   
cHtml += "</tr></table><br><br><br>"   

cHtml += "<table width='1081' border='0'>"
cHtml += "  <tr>"
cHtml += "  <td><p>Prezado Cliente,</p></td>"
cHtml += "  </tr><br><br>"
cHtml += "  <tr>"
cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do(s) tํtulo(s)  abaixo relacionado(s). Solicitamos seu contato atrav้s do telefone 11 3622-2400 Op็ใo 7,  para regulariza็ใo da pend๊ncia.</td>"
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
cHtml += "    <td><p>Caso o  pagamento jแ tenha ocorrido, solicitamos que desconsidere este aviso e nos  encaminhe o(s) comprovante(s) de pagamento, atrav้s do e-mail <a href='mailto:contasareceber@toktake.com.br'>contasareceber@toktake.com.br</a> ou pelo Telefone (11) 3622-2400 Op็ใo 7.</p></td>"
cHtml += "  </tr><br><br><br>"
cHtml += "  <tr>"
cHtml += "    <td><p>Certos de  vossa aten็ใo, permanecemos no aguardo.</p></td>"
cHtml += "  </tr><br><br><br>"
cHtml += "  <tr>"
cHtml += "    <td><p><strong>"+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_NOMECOM")+"</strong><br />"
cHtml += "      Departamento Financeiro<br />"
cHtml += "      "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_ENDENT")+" "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_CIDENT")+" - "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_ESTENT")+"<br />"
cHtml += "  <strong>Tel:</strong> 55 11 3622-2400 <br />"
cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:contasareceber@toktake.com.br'>contasareceber@toktake.com.br</a></p></td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "	<td><img src='cid:logo_amc.png'></td>"
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

cHtml := "<html>"
cHtml += "<body>"

cHtml += "<style type='text/css'>"
cHtml += " body,td,th {"
cHtml += "	font-family: Verdana, Geneva, sans-serif;"
cHtml += "	color: #000;"
cHtml += "	}"
cHtml += " </style>"

cHtml += "<table width='1081' border='0'>"
cHtml += "  <tr>"
cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
cHtml += "</tr>"
cHtml += "  <tr>"
cHtml += " <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"   
cHtml += "</tr></table><br><br><br>"

cHtml += "<table width='1081' border='0'>"
cHtml += "  <tr>"
cHtml += "  <td><p>Prezado Cliente,</p></td>"
cHtml += "  </tr><br><br>"
cHtml += "  <tr>"
cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do(s) tํtulo(s)  abaixo relacionado(s). Solicitamos seu contato atrav้s do telefone 11 3622-2400 Op็ใo 7,  para regulariza็ใo da pend๊ncia.</td>"
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
cHtml += "    <td><p>Caso o pagamento jแ tenha ocorrido, pedimos que desconsidere este aviso e nos encaminhe o comprovante de pagamento atrav้s do e-mail contasareceber@toktake.com.br ou pelo Telefone  11 3622-2400 Op็ใo 7.</p></td>"
cHtml += "  </tr>"
cHtml += "  <tr><br>"
cHtml += "    <td><p><em>Certos  da vossa aten็ใo, permanecemos no aguardo.</em></p></td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "    <td>&nbsp;</td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "    <td><p><strong>"+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_NOMECOM")+"</strong><br />"
cHtml += "      Departamento Financeiro<br />"
cHtml += "      "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_ENDENT")+" "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_CIDENT")+" - "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_ESTENT")+"<br />"
cHtml += "  <strong>Tel:</strong> 55 11 3622-2400 <br />"
cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:contasareceber@toktake.com.br'>contasareceber@toktake.com.br</a><u> </u></p></td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "	<td><img src='cid:logo_amc.png'></td>"
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

cHtml := "<html>"
cHtml += "<body>"

cHtml += "<style type='text/css'>"
cHtml += " body,td,th {"
cHtml += "	font-family: Verdana, Geneva, sans-serif;"
cHtml += "	color: #000;"
cHtml += "	}"
cHtml += " </style>"

cHtml += "<table width='1081' border='0'>"
cHtml += "  <tr>"
cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
cHtml += "</tr>"
cHtml += "  <tr>"
cHtml += " <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"   
cHtml += "</tr></table><br><br><br>"

cHtml += "<table width='1081' border='0'>"
cHtml += "  <tr>"
cHtml += "  <td><p>Prezado Cliente,</p></td>"
cHtml += "  </tr><br><br>"
cHtml += "  <tr>"
cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do(s) tํtulo(s)  abaixo relacionado(s). Solicitamos seu contato atrav้s do telefone 11 3622-2400 Op็ใo 7,  para regulariza็ใo da pend๊ncia.</td>"
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
cHtml += "  <tr><br>"
cHtml += "    <td><p>Caso o pagamento jแ tenha ocorrido, pedimos que desconsidere este aviso e nos encaminhe o comprovante de pagamento atrav้s do e-mail contasareceber@toktake.com.br ou pelo Telefone  11 3622-2400 Op็ใo 7.</p></td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "    <td><p>Certos  de vossa aten็ใo, permanecemos no aguardo. </p></td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "    <td>&nbsp;</td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "    <td><p><strong>"+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_NOMECOM")+"</strong><br />"
cHtml += "      Departamento Financeiro<br />"
cHtml += "      "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_ENDENT")+" "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_CIDENT")+" - "+Posicione("SM0",1,"10"+SUBSTR(aTitCli[01,10],1,2),"M0_ESTENT")+"<br />"
cHtml += "  <strong>Tel:</strong> 55 11 3622-2400 <br />"
cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:contasareceber@toktake.com.br'>contasareceber@toktake.com.br</a><u> </u></p></td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "    <td>&nbsp;</td>"
cHtml += "  </tr>"
cHtml += "  <tr>"
cHtml += "	<td><img src='cid:logo_amc.png'></td>"
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

Static Function AvisFin(cSubject)

Local cHtml	:=	"<html>"
cHtml	+=	"	<head>		<title></title>	</head>"
cHtml	+=	" 	<body>		<p>"+cSubject+" transmitidos.</p>"
cHtml	+=	"	<table border='0' cellpadding='1' cellspacing='1' style='width: 1900px;'>
cHtml	+=	"	<tr><td>Codigo Cliente</td>"
cHtml	+=	"	<td>Loja</td>"
cHtml	+=	"	<td>Nome</td>"
cHtml	+=	"	<td>Titulo</td>"
cHtml	+=	"	<td>Vencto.</td>"
cHtml	+=	"	<td>Valor</td>"
cHtml	+=	"	<td>Email</td>"
cHtml	+=	"	</tr>"			

For nX := 1 to len(aAvisFi)
	cHtml 	+= 	"<tr>"
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
cHtml	+=	"	</body></html>"

                                
Return(cHtml)