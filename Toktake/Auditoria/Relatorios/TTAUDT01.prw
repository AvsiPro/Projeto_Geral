#INCLUDE "TOPCONN.CH"   
#INCLUDE "TBICONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTAUDT01  �Autor  �Alexandre Venancio  � Data �  16/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relatorios de auditoria de patrimonios (VALORES)			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������͹��
���Versao    � 01.01.20140423 - Criacao                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTAUDT01()                                                                                                                                                                                                                                                                 //VALLIQ E O CONTEUDO DE E1_VALOR - E1 SALDO                                                                                            "E1_CCC",
	Local oReport       //    1			  2			3           4           5            6             7           
                                                                                //"'' AS E2_SITUACA"
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()
	Else
		Alert("Esta op��o ainda n�o est� dispon�vel")
	EndIf
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTAUDT01  �Autor  �Microsiga           � Data �  12/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clDesc	:="Consolida��o dos titulos a pagar e receber"
	Local clTitulo	:="Indicadores"
	Local clProg	:="TTAUDT01"
	Local aAux		:=	{}
	Private cPerg	:="TTAUDT01"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,cPerg,{|oReport| PrintReport(oReport)},clDesc)
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Consolidacao"),{"TRB"})
  
	/*------------------------------------------------------------------\
	|                       Campo   |   Alias|  T�tulo   |   Pic|Tam	|
	\------------------------------------------------------------------*/				
	//ZN_PATRIMO,ZN_DATA","ZN_TIPINCL","N1_XLIMTRO","ZN_TROCO","ZN_MOEDA1R","ZN_NOTA01
	
	TRCell():New(oSection1,"PATRIMONIO"		,"TRB","PATRIMONIO"	,"@!",06)	
	TRCell():New(oSection1,"DIA" 			,"TRB","DIA" 		,"@!",10)
	TRCell():New(oSection1,"TIPO"			,"TRB","TIPO"  		,"@!",10)	
	TRCell():New(oSection1,"LIM_TROCO"		,"TRB","LIM_TROCO" 	,"@E 999,999.99",16)
	TRCell():New(oSection1,"TROCO"	  		,"TRB","TROCO"		,"@E 999,999.99",16) 
	TRCell():New(oSection1,"VENDA_CASH"		,"TRB","VENDA_CASH"	,"@E 999,999.99",16) 
	TRCell():New(oSection1,"MEB" 			,"TRB","MEB" 		,"@E 999,999.99",16)   
	TRCell():New(oSection1,"CONT_CSAT"		,"TRB","CASH_ATUAL"	,"@!",10)	
	TRCell():New(oSection1,"CONT_CSAN"		,"TRB","CASH_ANTER"	,"@!",10)	
	TRCell():New(oSection1,"CONT_SALET"		,"TRB","SALE_ATUAL"	,"@!",10)	
	TRCell():New(oSection1,"CONT_SALEN"		,"TRB","SALE_ANTER"	,"@!",10)	


Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROR01  �Autor  �Microsiga           � Data �  12/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*----------------------------------------------------------------------------| 		    			           
	|sele�ao dos dados a serem impressos/carrega o arquivo temporario de trabalho | 
	|----------------------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-----------------------------|
	| impressao da primeira se�ao  | 
	|-----------------------------*/
	
	DbSelectArea("TRB")
	DbGoTop()
	oReport:SetMeter(RecCount())
	oSection1:Init()         
	While  !Eof()
		If oReport:Cancel()
			Exit
		EndIf
		oSection1:PrintLine()
		DbSelectArea("TRB")
		DbSkip()            
		oReport:IncMeter()
	EndDo
	oSection1:Finish()		
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROR01  �Autor  �Microsiga           � Data �  12/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fSelDados()
	
Local aRet		:=	{}
Local aAux		:=	{}
Local aAux2		:=	{}           
Local nPas		:=	1
Local aDados	:=	{}
	
_aStru	:= {} 
	
	AADD(_aStru, {"PATRIMONIO"	,"C",06,0})
	AADD(_aStru, {"DIA"     	,"D",10,0})
	AADD(_aStru, {"TIPO"		,"C",10,0})
	AADD(_aStru, {"LIM_TROCO"	,"N",16,2})
	AADD(_aStru, {"TROCO"		,"N",16,2})
	AADD(_aStru, {"VENDA_CASH"	,"N",16,2})
	AADD(_aStru, {"MEB" 		,"N",16,2})
	AADD(_aStru, {"CONT_CSAT"	,"C",10,0})
	AADD(_aStru, {"CONT_CSAN"	,"C",10,0})
	AADD(_aStru, {"CONT_SALET"	,"C",10,0})
	AADD(_aStru, {"CONT_SALEN"	,"C",10,0})
	
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)

clQuery := "SELECT ZN_PATRIMO,ZN_DATA,ZN_TIPINCL,N1_XLIMTRO,ZN_TROCO,ZN_MOEDA1R,ZN_NOTA01,ZN_NUMANT,ZN_NUMATU,ZN_COTCASH"
clQuery += " FROM "+RetSQLName("SZN")+" ZN"
clQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_FILIAL='' AND N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"
clQuery += " WHERE ZN_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
clQuery += " AND ZN_TIPINCL='SANGRIA'"
clQuery += " AND (ZN_MOEDA1R>0 OR ZN_NOTA01>0) AND ZN.D_E_L_E_T_='' AND ZN_COTCASH>0 ORDER BY ZN_PATRIMO,ZN_DATA DESC"

If Select("TRBROTA") > 0
	dbSelectArea("TRBROTA")
	DbCloseArea()
EndIf

MemoWrite("TTPROR01.SQL",clQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TRBROTA",.F.,.T.)

dbSelectArea("TRBROTA")
dbGotop()

Do While TRBROTA->(!Eof())					    				
	 
	If Ascan(ADados,{|x| Alltrim(x[1]) == Alltrim(TRBROTA->ZN_PATRIMO)	}) == 0
		Aadd(aDados,{TRBROTA->ZN_PATRIMO,STOD(TRBROTA->ZN_DATA),TRBROTA->ZN_TIPINCL,TRBROTA->N1_XLIMTRO,TRBROTA->ZN_TROCO,;
					TRBROTA->ZN_MOEDA1R + TRBROTA->ZN_NOTA01,TRBROTA->ZN_COTCASH,ctod(' / / '),;
					TRBROTA->ZN_NUMATU,TRBROTA->ZN_NUMANT,STRTRAN(cvaltochar(TRBROTA->ZN_COTCASH),"."),0})             
		nPas := 1		//	9 					10 					11 		   							12
	ELSE 
		If nPas == 1
			aDados[Ascan(ADados,{|x| Alltrim(x[1]) == Alltrim(TRBROTA->ZN_PATRIMO)	}),07] 	-= TRBROTA->ZN_COTCASH
			aDados[Ascan(ADados,{|x| Alltrim(x[1]) == Alltrim(TRBROTA->ZN_PATRIMO)	}),08]	:= STOD(TRBROTA->ZN_DATA)
			aDados[Ascan(ADados,{|x| Alltrim(x[1]) == Alltrim(TRBROTA->ZN_PATRIMO)	}),12] 	:= TRBROTA->ZN_COTCASH
			nPas++	
		EndIf
	ENDIF
	dbSelectArea("TRBROTA")
	DbSkip()
Enddo 

For nX := 1 to len(aDados)    
	If !Empty(aDados[nX,08])
		clQuery := "SELECT SUM(ZZE_VLRBRU) AS VALOR FROM "+RetSQLName("ZZE")
		clQuery += " WHERE ZZE_PATRIM='"+aDados[nX,01]+"'"
		clQuery += " AND ZZE_DATATR BETWEEN '"+DTOS(aDados[nX,02])+"' AND '"+DTOS(aDados[nX,08])+"' AND D_E_L_E_T_=''"

		If Select("TRBROTA") > 0
			dbSelectArea("TRBROTA")
			DbCloseArea()
		EndIf
		
		MemoWrite("TTPROR01.SQL",clQuery)
		
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TRBROTA",.F.,.T.)
		
		dbSelectArea("TRBROTA")
		dbGotop()
		
		Do While TRBROTA->(!Eof())
		    aDados[nX,06] += TRBROTA->VALOR
			DbSkip()
		EndDo
	EndIf
Next nX


For nX := 1 to len(aDados)
	DbSelectArea("TRB")
	
	RecLock("TRB",.T.)   
	TRB->PATRIMONIO	:= aDados[nX,01]
	TRB->DIA		:= aDados[nX,02]
	TRB->TIPO		:= aDados[nX,03]
	TRB->LIM_TROCO	:= aDados[nX,04]
	TRB->TROCO		:= aDados[nX,05]
	TRB->MEB		:= aDados[nX,06]
	TRB->VENDA_CASH	:= If(aDados[nX,07]<=99999,aDados[nX,07]/100,aDados[nX,07]/1000)
	TRB->CONT_CSAT	:= cvaltochar(aDados[nX,11])
	TRB->CONT_CSAN	:= cvaltochar(aDados[nX,12])
	TRB->CONT_SALET	:= cvaltochar(aDados[nX,09])
	TRB->CONT_SALEN	:= cvaltochar(aDados[nX,10])
	MsUnlock()	 
Next nX

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINR08  �Autor  �Microsiga           � Data �  12/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValPerg(cPerg)

PutSx1(cPerg,'01','Emiss�o De?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'02','Emiss�o At�?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'03','Patrimonio','','','mv_ch3','C',6, 0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')

Return                                        