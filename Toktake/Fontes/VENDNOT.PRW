
/*--------------------------&
&BIBLIOTECAS DE FUNÇÕES		&
&--------------------------*/  
 #INCLUDE "RWMAKE.CH"      && 
 #INCLUDE "TOPCONN.CH"     &&
&&-------------------------&&

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦VENDNOT() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RELATORIO DE VENDAS POR NOTAS				              ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                        

User Function VENDNOT()
	Local oReport
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()	
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private _cQuebra := ' '
	Private cPerg    := "NOTVEN"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("VENDNOT","NOTAS DE SAIDA","",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir precos das vendas por nota")
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("NOTAS DE SAIDA"),{"TRB"})
	//                      CAMPO        ALIAS  TITULO       PIC TAMANHO
	                                                                    
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"		,"@!",20)	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"	,"@!",02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"	,"@!",09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"	,"@!",03)
	TRCell():New(oSection1,"ROMAN"	    ,"TRB","ROMANEIO"	,"@!",10)
	TRCell():New(oSection1,"PEDIDO"		,"TRB","PEDIDO	"	,"@!",09)	
	TRCell():New(oSection1,"MESREF"		,"TRB","MES_REF_PED","@!",05)
	TRCell():New(oSection1,"NOMUSER"	,"TRB","USUARIO"	,"@!",40)	
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO	"	,	 ,08)
	TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLI	"	,"@!",06)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE	"	,"@!",40)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"	,"@!",04)
	TRCell():New(oSection1,"ARMAZEM"	,"TRB","ARMAZEM_SAIDA"	,"@!",06)
	TRCell():New(oSection1,"DESCARMS"	,"TRB","DESC_ARMAZ_SAI","@!",30)
	TRCell():New(oSection1,"CNPJ"		,"TRB","CNPJ/CPF "	,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"NATUREZA"	,"TRB","NATUREZA"	,"@!",10)  
	TRCell():New(oSection1,"ARM_ENT"	,"TRB","ARMAZEM_ENTREGA","@!",06)
	TRCell():New(oSection1,"DESCARME"	,"TRB","DESC_ARMAZ_ENT","@!",30)
	TRCell():New(oSection1,"ESTADO"		,"TRB","ESTADO	"	,"@!",02)
	TRCell():New(oSection1,"TES"		,"TRB","TES		"	,"@!",03)
	TRCell():New(oSection1,"CFOP"		,"TRB","CFOP	"	,"@!",05)
	TRCell():New(oSection1,"TOTAL"		,"TRB","TOT_MERC"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"FRETE"		,"TRB","FRETE	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"SEGURO"		,"TRB","SEGURO	"	,"@E 999,999.99",16)
   	TRCell():New(oSection1,"ICMS"		,"TRB","ICMS	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"PIS"   		,"TRB","PIS		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"CONFINS"	,"TRB","CONFINS	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"ICMS_ST"	,"TRB","ICMS_ST	"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"CCUSTO"  	,"TRB","CENT_CUSTO"	,"@!",30) 
	TRCell():New(oSection1,"MENNOTA"  	,"TRB","MSG_NOTA"	,"@!",250)
	
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)
	
	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando notas")
	
	/*-------------------------| 		    			           
	| imprime a primeira seção | 
	|-------------------------*/
	
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

	/*-----------------------------------------------------------| 		    			           
	| seleciona os dados a serem impressos/criacao do temporário | 
	|-----------------------------------------------------------*/ 

Static Function fSelDados() 

	Local clDescEnt
	Local clDescSai

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {} 
	
	AADD(_aStru,{"TIPO","C",20,0})	
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"MESREF","C",05,0})
	AADD(_aStru,{"NOMUSER","C",40,0})	
	AADD(_aStru,{"PEDIDO","C",06,0})	
	AADD(_aStru,{"COD_CLI","C",06,0})
	AADD(_aStru,{"CLIENTE","C",40,0})
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"NATUREZA","C",10,0})
	AADD(_aStru,{"CNPJ","C",14,0})
	AADD(_aStru,{"TES","C",03,0})
	AADD(_aStru,{"CFOP","C",05,0})
	AADD(_aStru,{"TOTAL","N",14,2})
	AADD(_aStru,{"ICMS","N",14,2})
	AADD(_aStru,{"PIS","N",14,2})
	AADD(_aStru,{"CONFINS","N",14,2})
	AADD(_aStru,{"CCUSTO","C",09,0})
	AADD(_aStru,{"DESCONTO","N",14,2})
	AADD(_aStru,{"FRETE","N",14,2})
	AADD(_aStru,{"SEGURO","N",14,2})
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"ESTADO","C",02,0})
	AADD(_aStru,{"EMISSAO","D",08,0})
	AADD(_aStru,{"ICMS_ST","N",14,2})
	AADD(_aStru,{"MENNOTA","C",250,0})
	AADD(_aStru,{"ARMAZEM","C",06,0})
	AADD(_aStru,{"DESCARMS"	,"C",30,0})
	AADD(_aStru,{"ARM_ENT","C ",06,0})
	AADD(_aStru,{"DESCARME"	,"C",30,0})
	AADD(_aStru,{"ROMAN","C",10,0})	 	
	
	
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"CLIENTE",,,"Selecionando Registros...")
	
	/*-------------------------------------------------------------------------| 		    			           
	| Montagem da query com os dados das notas fiiscais de saidas e devoluções |
	|-------------------------------------------------------------------------*/
		
	_cQuery := " SELECT F2_DOC,F2_SERIE,D2_TIPO AS TIPO,F2_CLIENTE,C5_XMESREF AS MESREF,C5_XCODPA,C5_XNOMUSR AS NOMUSE,C5_MENNOTA AS MSGNOT,D2_PEDIDO AS PEDIDO, "
	_cQuery += " MAX(D2_TES) AS TES ,MAX(D2_CF) AS CF,D2_CCUSTO,D2_LOCAL,A1_EST,F2_EMISSAO,F2_FILIAL,F2_XCARGA AS ROMAN, A1_NOME,A1_LOJA,A1_CGC,A1_NATUREZ, "
	_cQuery += " SUM(D2_DESCON) AS DESCONTO,SUM(D2_VALFRE) AS FRETE ,SUM(D2_SEGURO) AS SEGURO,D2_ICMSRET, "
	_cQuery += " SUM(D2_TOTAL) AS TOTAL,SUM(D2_VALICM) AS ICMS,SUM(D2_VALIMP5) AS PIS,SUM(D2_VALIMP6) AS CONFINS  "
	_cQuery += " FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SF4")+" SF4,"+RetSQLName("SC5")+" SC5  "
	_cQuery += " WHERE
	_cQuery += " D2_DOC = F2_DOC "
	_cQuery += " AND D2_SERIE = F2_SERIE "
	_cQuery += " AND D2_CLIENTE= F2_CLIENTE "
	_cQuery += " AND D2_LOJA = F2_LOJA "
	_cQuery += " AND D2_EMISSAO = F2_EMISSAO "
	_cQuery += " AND D2_FILIAL = F2_FILIAL "
	_cQuery += " AND A1_COD = F2_CLIENTE " 
	_cQuery += " AND A1_LOJA= F2_LOJA "
	_cQuery += " AND D2_FILIAL =F4_FILIAL "
	_cQuery += " AND D2_TES =F4_CODIGO "
	_cQuery += " AND D2_FILIAL 	=C5_FILIAL "
	_cQuery += " AND D2_PEDIDO 	=C5_NUM "
	_cQuery += " AND D2_CLIENTE =C5_CLIENTE "
	_cQuery += " AND D2_LOJA 	=C5_LOJACLI " 
	_cQuery += " AND F2_FILIAL BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
	_cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " AND F2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " AND F2_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

	IF mv_par07==1
		_cQuery += " AND F4_DUPLIC ='S' "
	ELSEIF mv_par07==2
		_cQuery += " AND F4_DUPLIC ='N' "
	ELSEIF mv_par07==3
		_cQuery += " AND F4_DUPLIC IN ('S','N') " 
	ENDIF
	_cQuery += " AND D2_TIPO IN ('N','C') "
	_cQuery += " AND SF2.D_E_L_E_T_=' ' "
	_cQuery += " AND SD2.D_E_L_E_T_=' ' "
	_cQuery += " AND SA1.D_E_L_E_T_=' ' "
	_cQuery += " AND SF4.D_E_L_E_T_=' ' "
	_cQuery += " GROUP BY F2_DOC,F2_SERIE,D2_TIPO,F2_CLIENTE,C5_XMESREF,C5_XCODPA,C5_XNOMUSR,C5_MENNOTA,D2_PEDIDO,D2_CCUSTO,D2_LOCAL,A1_EST, "
	_cQuery += " D2_EST,F2_EMISSAO,F2_FILIAL,F2_XCARGA,A1_NOME,A1_LOJA,A1_CGC,A1_NATUREZ,D2_ICMSRET "
    
	_cQuery += " UNION ALL
	
	_cQuery += " SELECT F1_DOC,F1_SERIE,D1_TIPO AS TIPO,F1_FORNECE,'' AS MESREF,'' AS CODUSE,'' AS NOMUSE,'' AS MSGNOT,D1_PEDIDO AS PEDIDO, "
	_cQuery += " MAX(D1_TES) AS TES ,MAX(D1_CF) AS CF,D1_CC,D1_LOCAL,A1_EST,F1_DTDIGIT,F1_FILIAL,'' AS ROMAN,A1_NOME,A1_LOJA,A1_CGC,A1_NATUREZ, "
	_cQuery += " -(SUM(D1_VALDESC)) AS DESCONTO,-(SUM(D1_VALFRE)) AS FRETE ,-(SUM(D1_SEGURO)) AS SEGURO,-D1_ICMSRET, "
	_cQuery += " -(SUM(D1_TOTAL)) AS TOTAL,-(SUM(D1_VALICM)) AS ICMS,-(SUM(D1_VALIMP5)) AS PIS,-(SUM(D1_VALIMP6)) AS CONFINS  "
	_cQuery += " FROM "+RetSQLName("SF1")+" SF1, "+RetSQLName("SD1")+" SD1, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SF4")+" SF4 "
	_cQuery += " WHERE

	_cQuery += " D1_DOC = F1_DOC "
	_cQuery += " AND D1_SERIE = F1_SERIE "
	_cQuery += " AND D1_FORNECE= F1_FORNECE "
	_cQuery += " AND D1_LOJA = F1_LOJA "
	_cQuery += " AND D1_EMISSAO = F1_EMISSAO "
	_cQuery += " AND D1_FILIAL = F1_FILIAL "
	_cQuery += " AND A1_COD = F1_FORNECE " 
	_cQuery += " AND A1_LOJA= F1_LOJA "
	_cQuery += " AND D1_FILIAL =F4_FILIAL "
	_cQuery += " AND D1_TES =F4_CODIGO "
	_cQuery += " AND F1_FILIAL BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
	_cQuery += " AND F1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " AND F1_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " AND F1_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	IF mv_par07==1
		_cQuery += " AND F4_DUPLIC ='S' "
	ELSEIF mv_par07==2
		_cQuery += " AND F4_DUPLIC ='N' "
	ELSEIF mv_par07==3
		_cQuery += " AND F4_DUPLIC IN ('S','N') " 
	ENDIF
	_cQuery += " AND D1_TIPO IN ('D','C') "
	_cQuery += " AND SF1.D_E_L_E_T_=' ' "
	_cQuery += " AND SD1.D_E_L_E_T_=' ' "
	_cQuery += " AND SA1.D_E_L_E_T_=' ' "
	_cQuery += " AND SF4.D_E_L_E_T_=' ' "
	_cQuery += " GROUP BY F1_DOC,F1_SERIE,D1_TIPO,F1_FORNECE,D1_PEDIDO,D1_CC,D1_LOCAL,A1_EST,F1_DTDIGIT, "
	_cQuery += " F1_FILIAL,A1_NOME,A1_LOJA,A1_CGC,A1_NATUREZ,D1_ICMSRET "

	/*---------------------------------------------| 		    			           
	| verifica se a query existe, se existir fecha |
	|---------------------------------------------*/

	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	 
	/*-------------------------------| 		    			           
	| cria a query e dar um apelido  |
	|-------------------------------*/
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL1",.F.,.T.)
	
	/*-----------------------------------------------------| 		    			           
	| ajusta as casas decimais e datas no retorno da query |
	|-----------------------------------------------------*/

	TcSetField("TSQL1","F2_EMISSAO","D",08,0)
	TcSetField("TSQL1","TOTAL","N",14,2)
	TcSetField("TSQL1","ICMS","N",14,2)
	TcSetField("TSQL1","PIS","N",14,2)
	TcSetField("TSQL1","CONFINS","N",14,2)
	TcSetField("TSQL1","DESCONTO","N",14,2)
		
	dbSelectArea("TSQL1")
	dbGotop()
	Do While TSQL1->(!Eof())
		
		IF TSQL1->TIPO=="N"
	     	clTipo:="VENDA"
	     ELSEIF TSQL1->TIPO=="C"
			clTipo:="COMP.VENDA"
		 ELSE
		 	clTipo:="DEVOLUCAO"
		 ENDIF
		    
		DBSELECTAREA("ZZ1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("ZZ1")+ TSQL1->D2_LOCAL)
			clDescSai:=ZZ1_DESCRI
		ENDIF
		IF DBSEEK(XFILIAL("ZZ1")+ TSQL1->C5_XCODPA)
			clDescEnt:=ZZ1_DESCRI
		ENDIF
		
	 	DbSelectArea("TRB")
	 	 
	/*---------------------------| 		    			           
	| adciona registrro em banco |
	|---------------------------*/
	      
		RecLock("TRB",.T.)
	
			TRB->TIPO		:= clTipo	     
			TRB->MESREF		:= TSQL1->MESREF
	     	TRB->NOMUSER	:= TSQL1->NOMUSE
	     	TRB->MENNOTA	:= TSQL1->MSGNOT    		     	     		     
	     	TRB->COD_CLI	:= TSQL1->F2_CLIENTE
	     	TRB->LOJA		:= TSQL1->A1_LOJA
	      	TRB->CLIENTE	:= TSQL1->A1_NOME
	      	TRB->NATUREZA   := TSQL1->A1_NATUREZ
	      	TRB->CNPJ		:= TSQL1->A1_CGC
		    TRB->NOTA		:= TSQL1->F2_DOC
	    	TRB->SERIE		:= TSQL1->F2_SERIE
	    	TRB->ROMAN		:= TSQL1->ROMAN
	        TRB->TOTAL		:= TSQL1->TOTAL	
	        TRB->PEDIDO		:= TSQL1->PEDIDO
	        TRB->ICMS		:= TSQL1->ICMS
	        TRB->PIS		:= TSQL1->PIS
	        TRB->CONFINS	:= TSQL1->CONFINS
	        TRB->ICMS_ST	:= TSQL1->D2_ICMSRET       
	        TRB->CFOP		:= TSQL1->CF
	        TRB->CCUSTO		:= TSQL1->D2_CCUSTO
	        TRB->TES		:= TSQL1->TES
	        TRB->DESCONTO	:= TSQL1->DESCONTO
	        TRB->FRETE		:= TSQL1->FRETE 
	        TRB->SEGURO		:= TSQL1->SEGURO
	        TRB->FILIAL   	:= TSQL1->F2_FILIAL
	        TRB->ESTADO		:= TSQL1->A1_EST
	        TRB->EMISSAO	:= TSQL1->F2_EMISSAO
	        TRB->ARMAZEM	:= TSQL1->D2_LOCAL
	        TRB->ARM_ENT	:= TSQL1->C5_XCODPA    //ARMAZEM DE ENTREGA
	        TRB->DESCARME	:= clDescEnt           //DESCRIÇÃO DO ARMAZEM DE ENTREGA
	        TRB->DESCARMS	:= clDescSai	       //DESCRICAO DO ARMAZEM DE SAIDA 	        
		MsUnlock()
		clDescEnt:=""
        clDescSai:=""	
	      dbSelectArea("TSQL1")
	     DbSkip()
	Enddo
	
	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissao de           ?','','','mv_ch1','D',8,0,0,'G','','','','', 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate          ?','','','mv_ch2','D',8,0,0,'G','','','','', 'mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Nota de              ?','','','mv_ch3','C',09,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Nota Ate             ?','','','mv_ch4','C',09,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Serie de            	?','','','mv_ch5','C',03,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Serie Ate           	?','','','mv_ch6','C',03,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'07','Gera Finaceiro      	?','','','mv_ch7','N',1 ,0,1,'C','','','','','mv_par07',"Sim"," "," ","","Não","","","Ambos","","","","","","","","")
	PutSx1(cPerg,'08','Filial de            ?','','','mv_ch8','C',02,0,0,'G','','SM0','','','mv_par08',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'09','Filial Ate           ?','','','mv_ch9','C',02,0,0,'G','','SM0','','','mv_par09',,,'','','','','','','','','','','','','','') 
	   
	
Return