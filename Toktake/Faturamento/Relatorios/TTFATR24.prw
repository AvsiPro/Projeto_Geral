
/*--------------------------|
|BIBLIOTECAS DE FUNÇÕES		|
|--------------------------*/
 #INCLUDE "RWMAKE.CH"      //
 #INCLUDE "TOPCONN.CH"     //
/*-------------------------*/

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTFATR24() ¦ Autor ¦ Fabio Sales		¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Abastecimento e Transferencia     	 	          ¦¦¦
¦¦¦			 ¦ 						  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦																  ¦¦¦
¦¦¦Historico ¦ Alterações¦ Autor 				¦Data	  ¦¦¦
¦¦+----------+--------------------------+-----------------------+---------¦¦¦
¦¦¦	     ¦ Adicionadas novas colunas¦ Jackson E. de Deus	¦19/02/13 ¦¦¦
¦¦¦	     ¦ Solicitado por Jorge					  ¦¦¦	
¦¦¦	     ¦ Compras							  ¦¦¦
¦¦+----------+--------------------------+-----------------------+---------¦¦¦
¦¦¦Uso       ¦ Faturamento                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                        

User Function TTFATR24()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//Verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()
		EndIf
	endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ Fabio Sales		¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função principal de impressão				  ¦¦¦
¦¦¦	     ¦								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private _cQuebra := ' '
	Private cPerg    := "TTFIN"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFATR24","Abastecimento e Transferencia","",{|oReport| PrintReport(oReport)},"Este relatório irá imprimir as notas de abastecimento e transferência")
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Abastecimento e Transferencia"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
	
	TRCell():New(oSection1,"TIPO"			,"TRB"	,"TIPO"					,"@!"					,30)
	TRCell():New(oSection1,"FILIALSAI"		,"TRB"	,"FILIAL_SAIDA"			,"@!"					,02)
	TRCell():New(oSection1,"FILIALDEST"		,"TRB"	,"FILIAL_DESTINO"		,"@!"					,02)	
	TRCell():New(oSection1,"NOTA"			,"TRB"	,"NOTA"					,"@!"					,09)
	TRCell():New(oSection1,"SERIE"			,"TRB"	,"SERIE"				,"@!"					,03)
	TRCell():New(oSection1,"EMISSAO"		,"TRB"	,"EMISSAO"				,	 					,08)	 
	TRCell():New(oSection1,"PROD"			,"TRB"	,"PRODUTO"				,"@!"					,15)	
	TRCell():New(oSection1,"DESCPROD"		,"TRB"	,"DESC_PROD"			,"@!"					,30)
	TRCell():New(oSection1,"PUNID"			,"TRB"	,"1_UNIDAD_MED"			,"@!"					,05)
	TRCell():New(oSection1,"SUNID"			,"TRB"	,"2_UNIDAD_MED"			,"@!"					,05)   
	TRCell():New(oSection1,"PESOU"			,"TRB"	,"PESO_UNI"				,"@E 999,999.9999"		,16)
	TRCell():New(oSection1,"PESOT"			,"TRB"	,"PESO_TOTAL"			,"@E 999,999.9999"		,16)
	TRCell():New(oSection1,"CUBAGEM"		,"TRB"	,"CUBAGEM"				,"@E 999,999,999,999,999.99999",18)									
	TRCell():New(oSection1,"QUANT"			,"TRB"	,"QTDE"					,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"RPRVEN"			,"TRB"	,"PÇO_VENDA"			,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"PR_UNIT"		,"TRB"	,"PÇO_UNIT"				,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"TOTAL"			,"TRB"	,"TOT_MERC"				,"@E 999,999.99"		,16)	
	TRCell():New(oSection1,"LOC_ENT"		,"TRB"	,"ARMAZEM_ENTRADA"		,"@!"					,06)
	TRCell():New(oSection1,"DESC_ENT"		,"TRB"	,"DESC_ARMAZ_ENTRADA"	,"@!"					,30)	                                                                    
	TRCell():New(oSection1,"ARMAZEM"		,"TRB"	,"ARMAZEM_SAIDA"		,"@!"		   			,06)
	TRCell():New(oSection1,"DESCARMS"		,"TRB"	,"DESC_ARMAZ_SAI"		,"@!"					,30)		
	TRCell():New(oSection1,"COD_CLI"		,"TRB"	,"COD_CLI"				,"@!"					,06)
	TRCell():New(oSection1,"CLIENTE"		,"TRB"	,"CLIENTE"				,"@!"					,40)
	TRCell():New(oSection1,"LOJA"			,"TRB"	,"LOJA"					,"@!"					,04)
	TRCell():New(oSection1,"CNPJ"			,"TRB"	,"CNPJ/CPF"				,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"NATUREZA"		,"TRB"	,"NATUREZA"				,"@!"					,10)
	TRCell():New(oSection1,"ESTADO"			,"TRB"	,"ESTADO"		  		,"@!"					,02)
	TRCell():New(oSection1,"ARM_ENT"		,"TRB"	,"ARMAZEM_ENTREGA"		,"@!"					,06)
	TRCell():New(oSection1,"DESCARME"		,"TRB"	,"DESC_ARMAZ_ENT"		,"@!"					,30)		
	TRCell():New(oSection1,"TES"			,"TRB"	,"TES"					,"@!"					,03)
	TRCell():New(oSection1,"CFOP"			,"TRB"	,"CFOP"					,"@!"					,05)
	TRCell():New(oSection1,"FRETE"			,"TRB"	,"FRETE"				,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"SEGURO"			,"TRB"	,"SEGURO"				,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"BASEICM"		,"TRB"	,"BASE ICMS"			,"@E 99,99"				,05)
	TRCell():New(oSection1,"ALIQICM"		,"TRB"	,"ALÍQUOTA ICMS"		,"@E 999,999.99"		,16)	
   	TRCell():New(oSection1,"ICMS"			,"TRB"	,"ICMS"					,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"PIS"   			,"TRB"	,"PIS"					,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"CONFINS"		,"TRB"	,"CONFINS"				,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"ICMS_ST"		,"TRB"	,"ICMS_ST"				,"@E 999,999.99"		,16)	
	TRCell():New(oSection1,"CCUSTO"  		,"TRB"	,"CENT_CUSTO"			,"@!"					,30) 
	TRCell():New(oSection1,"ROMAN"   		,"TRB"	,"NR_ROMANEIO"			,"@!"					,10)
	TRCell():New(oSection1,"TRANSP"			,"TRB"	,"COD_TRANSP"			,"@!"					,16)
	TRCell():New(oSection1,"PLACA"			,"TRB"	,"PLACA_CARRO"			,"@E XXX-9999"			,08)	
	TRCell():New(oSection1,"MOTOR"  		,"TRB"	,"MOTORISTA"			,"@!"					,40)
	TRCell():New(oSection1,"NOTAORI"		,"TRB"	,"NOTA_ORIGEM"			,"@!"					,09)
	TRCell():New(oSection1,"SERIORI"		,"TRB"	,"SERIE_ORIGEM"			,"@!"					,03)
	TRCell():New(oSection1,"FINALID"		,"TRB"	,"FINALID_TES"			,"@!"					,30)	
	TRCell():New(oSection1,"FATCONV"		,"TRB"	,"FATOR_CONVEÇÃO" 		,"@E 999,999.99"		,16)
	TRCell():New(oSection1,"TIPCONV"		,"TRB"	,"TIPO_CONVENÇÃO"		,"@!"					,15)
	TRCell():New(oSection1,"QT_UNID_UN"		,"TRB"	,"QTDE_UNID_UNICA"		,"@E 999,999.99"		,16)
	
	TRCell():New(oSection1,"STATUS"		,"TRB","STATUS"			,"@!"			,13)
	TRCell():New(oSection1,"DT_CLAS"	,"TRB","DATA_CLAS"		,	 			,08)	 
	// Solicitação Jorge/Compras - novas colunas ao final do relatório
	// Mostra mesmo campos ja existentes - mostrar campos do relatorio de cadastro de produtos
	TRCell():New(oSection1,"PROD"			,"TRB"	,"COD_PROD"				,"@!"		   			,15)		// ja existentes
	TRCell():New(oSection1,"DESCPROD"		,"TRB"	,"DESC_PROD"			,"@!"		  			,30)	    // ja existentes                                                                                      
	TRCell():New(oSection1,"COD_SECAO"		,"TRB"	,"SECAO"				,"@!"					,04)		// Cód. da Seção
	TRCell():New(oSection1,"DESC_SECAO"		,"TRB"	,"DESC_SECAO"			,"@!"					,30)		// Desc. Seção
	TRCell():New(oSection1,"COD_LINHA"		,"TRB"	,"LINHA"				,"@!"					,03)		// ja existentes
	TRCell():New(oSection1,"DESC_LINHA"		,"TRB"	,"DESC_LINHA"			,"@!"					,20)	 	// NOME LINHA
	TRCell():New(oSection1,"COD_CATEG"		,"TRB"	,"CATEGORIA"			,"@!"					,40)		// NOME DA CATEGORIA
	TRCell():New(oSection1,"CATEGORIA"		,"TRB"	,"DESC_CATEGORIA"		,"@!"					,30)		// ja existentes	
	TRCell():New(oSection1,"COD_SUBGRP"		,"TRB"	,"SUB_GRUPO"			,"@!"					,04)		// Cod. SubGrupo
	TRCell():New(oSection1,"SUBGRUPO"		,"TRB"	,"DESC_SUBGRUP"			,"@!"					,30)		// ja existentes	
	TRCell():New(oSection1,"NCM"			,"TRB"	,"NCM" 					,"@!"					,10)		// ja existentes
	TRCell():New(oSection1,"COD_CLUSTE" 	,"TRB"	,"COD CLUSTER"			,"@!"					,02)		// COD CLUSTER
	TRCell():New(oSection1,"CLUSTER"		,"TRB"	,"CLUSTER"				,"@!"  					,20) 
	TRCell():New(oSection1,"COD_AMPLI"		,"TRB"	,"COD AMPLI"			,"@!"  					,04) 	
	TRCell():New(oSection1,"AMPLITUDE"		,"TRB"	,"AMPLITUDE"			,"@!"  					,25) 
	TRCell():New(oSection1,"COD_TPNEG"		,"TRB"	,"COD TP NEG"			,"@!"  					,04) 
	TRCell():New(oSection1,"TPNEGOCIO"		,"TRB"	,"TP NEGOCIO"			,"@!"  					,25) 	
	TRCell():New(oSection1,"COD_CONSER"		,"TRB"	,"COD CONSERV"			,"@!"  					,04)
	TRCell():New(oSection1,"CONSERV"		,"TRB"	,"CONSERVACAO"			,"@!"  					,25)
	TRCell():New(oSection1,"COD_PREP"		,"TRB"	,"COD PREP"				,"@!"  					,04)
	TRCell():New(oSection1,"PREPARO"		,"TRB"	,"PREPARO"				,"@!"  					,25)	
	TRCell():New(oSection1,"COD_TPMAQ"		,"TRB"	,"COD TP MAQ"			,"@!"  					,04)
	TRCell():New(oSection1,"TPMAQUINA"		,"TRB"	,"TIPO MAQ"				,"@!"  					,25)			
	TRCell():New(oSection1,"COD_MOLA"		,"TRB"	,"COD MOLA"				,"@!"  					,04)	                                                            
	TRCell():New(oSection1,"MOLA"			,"TRB"	,"MOLA"			  		,"@!"  					,25)	 
	TRCell():New(oSection1,"BLQ_GERAL"		,"TRB"	,"BLQ. GERAL"	  		,"@!"					,03)		// BLOQUEIO GERAL DO PRODUTO		
	TRCell():New(oSection1,"BLQ_COMPRA"		,"TRB"	,"BLQ. COMPRA"			,"@!"					,03)		// BLOQUEIO DO COMPRAS		
	TRCell():New(oSection1,"UM"				,"TRB"	,"UNI_MED"				,"@!"					,02)	
	TRCell():New(oSection1,"FATCONV"		,"TRB"	,"FATOR_CONV."	 		,"@E 999,999.99"		,18)		// ja existentes
	TRCell():New(oSection1,"SEGUNID"		,"TRB"	,"SEG. UNI."			,"@!"					,04)		// ja existentes
	TRCell():New(oSection1,"CUBAGEM_2"		,"TRB"	,"CUBAGEM"				,"@!"	   				,03)		// Cubagem 
	TRCell():New(oSection1,"COMPRIMENT"		,"TRB"	,"COMPRIMENTO"			,"@E 999,999.99"  		,10)  		// Comprimento 	
	TRCell():New(oSection1,"ESPESSURA"		,"TRB"	,"ESPESSURA"			,"@E 999,999.99"  		,10)		// Espessura 
	TRCell():New(oSection1,"LARGURA"		,"TRB"	,"LARGURA"				,"@E 999,999.99"  		,10)		// Largura 
	TRCell():New(oSection1,"EAN"			,"TRB"	,"EAN"					,"@!"		   			,15)		// Codigo de Barras			
	TRCell():New(oSection1,"DT_DIA"	   		,"TRB"	,"DIA"					,"@!" 	   				,02)		// Dia
	TRCell():New(oSection1,"DT_MESANO"		,"TRB"	,"MES/ANO"				,"@!" 		 			,08)		// Mes/Ano
	TRCell():New(oSection1,"DT_ANO"			,"TRB"	,"ANO"					,"@!" 	   				,04)		// Ano
	TRCell():New(oSection1,"DT_TRIM"		,"TRB"	,"TRIMESTRE"			,"@!" 	 				,06)		// Trimestre

	
	
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------?------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ Fabio Sales	    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função responsável pela impressão do relatório			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento                                          	  ¦¦¦
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
	Local LocalEnt
	Local clFinalid
	Local nlCub :=0
	Local cStatus	:=	""
	Local cDataC	:=	ctod("  /  /  ")
	Local cArmzE	:=	""
	Local cDesca	:=	""
	Local dDtEmiss
	Local aRetData	:= {}        

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho | 
	|-------------------------------*/ 	
	_aStru	:= {}
	
	AADD(_aStru,{"TIPO"			,"C"	,30	,0})		
	AADD(_aStru,{"PUNID"		,"C"	,05	,0})	// Primeira unidade de medida	
	AADD(_aStru,{"SUNID"		,"C"	,05	,0})		
	AADD(_aStru,{"NOTA"	   		,"C"	,09	,0})
	AADD(_aStru,{"SERIE"		,"C"	,03	,0})
	AADD(_aStru,{"NOTAORI"		,"C"	,09	,0})
	AADD(_aStru,{"SERIORI"		,"C"	,03	,0})
	AADD(_aStru,{"COD_CLI"		,"C"	,06	,0})
	AADD(_aStru,{"CLIENTE"		,"C"	,40	,0})
	AADD(_aStru,{"LOJA"	   		,"C"	,04	,0})
	AADD(_aStru,{"NATUREZA"		,"C"	,10	,0})
	AADD(_aStru,{"CNPJ"			,"C"	,14	,0})
	AADD(_aStru,{"TES"			,"C"	,03	,0})
	AADD(_aStru,{"CFOP"			,"C"	,05	,0})
	AADD(_aStru,{"TOTAL"		,"N"	,14	,2})
	AADD(_aStru,{"ALIQICM"		,"N"	,14	,2})
	AADD(_aStru,{"BASEICM"		,"N"	,14	,2})
	AADD(_aStru,{"ICMS"			,"N"	,14	,2})
	AADD(_aStru,{"PIS"			,"N"	,14	,2})
	AADD(_aStru,{"CONFINS"		,"N"	,14	,2})
	AADD(_aStru,{"CCUSTO"		,"C"	,09	,0})
	AADD(_aStru,{"ARMAZEM"		,"C"	,06	,0})
	AADD(_aStru,{"DESCARMS"		,"C"	,30	,0})
	AADD(_aStru,{"ARM_ENT"		,"C "	,06	,0})
	AADD(_aStru,{"DESCARME"		,"C"	,30	,0})	                                                                  
	AADD(_aStru,{"DESCONTO"		,"N"	,14	,2})
	AADD(_aStru,{"FRETE"		,"N"	,14	,2})
	AADD(_aStru,{"SEGURO"		,"N"	,14	,2})
	AADD(_aStru,{"FILIALSAI"	,"C"	,02	,0})
	AADD(_aStru,{"FILIALDEST"	,"C"	,02	,0})
	AADD(_aStru,{"ESTADO"		,"C"	,02	,0})
	AADD(_aStru,{"EMISSAO"		,"D"	,08	,0})
	AADD(_aStru,{"ICMS_ST"		,"N"	,14	,2})	
	AADD(_aStru,{"ROMAN"		,"C"	,10	,0})
	AADD(_aStru,{"TRANSP"		,"C"	,06	,0})
	AADD(_aStru,{"PLACA"		,"C"	,08	,0})
	AADD(_aStru,{"MOTOR"		,"C"	,40	,2})
	AADD(_aStru,{"PROD"	   		,"C"	,15	,0})
	AADD(_aStru,{"DESCPROD"		,"C"	,30	,0})
	AADD(_aStru,{"QUANT"		,"N"	,14	,2})
	AADD(_aStru,{"RPRVEN"		,"N"	,14	,2})
	AADD(_aStru,{"PR_UNIT"		,"N"	,14	,2})
	                                       	
	AADD(_aStru,{"PESOT"		,"N"	,14	,4})
	AADD(_aStru,{"PESOU"		,"N"	,14	,4})
	AADD(_aStru,{"CUBAGEM"		,"N"	,18	,4})
	                                       	
	AADD(_aStru,{"FINALID"		,"C"	,254,0}) 	
	AADD(_aStru,{"LOC_ENT"		,"C"	,06	,0})
	AADD(_aStru,{"DESC_ENT"		,"C"	,30	,0})
	
	AADD(_aStru,{"FATCONV"		,"N"	,14	,4})
	AADD(_aStru,{"TIPCONV"		,"C"	,02	,0})
	AADD(_aStru,{"SEGUNID"		,"C"	,06	,0})	//??
	AADD(_aStru,{"QT_UNID_UN"	,"N"	,14	,4})
	
	AADD(_aStru,{"STATUS","C",6,0})
	AADD(_aStru,{"DT_CLAS","D",08,0})
	/*------------------------------------------+ 
	| Novos campos - Jorge/Compras				|
	| Jackson E. de Deus	-	19/02/2013		|
	+-------------------------------------------*/  
	AADD(_aStru,{"COD_SECAO"	,"C"	,04	,0})		// Cod. Seção
	AADD(_aStru,{"DESC_SECAO"  	,"C"	,20	,0})		// Desc Seção
	AADD(_aStru,{"COD_LINHA"	,"C"	,04	,0})	    // Cod. Linha
	AADD(_aStru,{"DESC_LINHA"	,"C"	,20	,0}) 		// NOME LINHA 
	AADD(_aStru,{"COD_CATEG"	,"C"	,04	,0})		// Cod. da categoria  SB1->B1_GRUPO
	AADD(_aStru,{"CATEGORIA"	,"C"	,40	,0})		// NOME DA CATEGORIA
	AADD(_aStru,{"COD_SUBGRP"	,"C"	,04	,0})		// Cod. Subgrupo	
	AADD(_aStru,{"SUBGRUPO"		,"C"	,20	,0})		// NOME DO SUBGRUPO
	AADD(_aStru,{"COD_CLUSTE"	,"C"	,02	,0})		// COD CLUSTER
	AADD(_aStru,{"CLUSTER"		,"C"	,20	,0})
	AADD(_aStru,{"COD_AMPLI"	,"C"	,04	,0})		// COD AMPLITUDE 
	AADD(_aStru,{"AMPLITUDE"	,"C"	,25	,0})		// DESC AMPLITUDE
	AADD(_aStru,{"COD_TPNEG"	,"C"	,04	,0})		// COD TIPO NEGOCIO
	AADD(_aStru,{"TPNEGOCIO"	,"C"	,25	,0})		// DESC TIPO NEGOCIO
	AADD(_aStru,{"COD_CONSER"	,"C"	,04	,0})		// COD CONSERVACAO
	AADD(_aStru,{"CONSERV"		,"C"	,25	,0})		// DESC CONSERVACAO
	AADD(_aStru,{"COD_PREP"		,"C"	,04	,0})		// COD PREPARO
	AADD(_aStru,{"PREPARO"		,"C"	,25	,0})		// DESC PREPARO
	AADD(_aStru,{"COD_TPMAQ"	,"C"	,04	,0})		// COD TP MAQUINA
	AADD(_aStru,{"TPMAQUINA"	,"C"	,25	,0})		// DESC TP MAQUINA
	AADD(_aStru,{"COD_MOLA"		,"C"	,04	,0})		// COD MOLA
	AADD(_aStru,{"MOLA"			,"C"	,25	,0})		// DESC MOLA
	AADD(_aStru,{"BLQ_GERAL"	,"C"	,03	,0})		// BLOQUEIO GERAL DO PRODUTO - Converte de 1 - 2 para Sim - Nao		
	AADD(_aStru,{"BLQ_COMPRA"	,"C"	,03	,0})		// BLOQUEIO DO COMPRAS - Converte de T - F para Sim - Nao		
	AADD(_aStru,{"UM"			,"C"	,02	,0})		// UN. MEDIDA
	AADD(_aStru,{"CUBAGEM_2"	,"C"	,03	,0})		// CUBAGEM DO PRODUTO 
	AADD(_aStru,{"COMPRIMENT"	,"N"	,09	,3})		// COMPRIMENTO 
	AADD(_aStru,{"ESPESSURA"	,"N"	,09	,3})		// ESPESSURA
	AADD(_aStru,{"LARGURA"		,"N"	,09	,3})		// LARGURA 
	AADD(_aStru,{"EAN"			,"C"	,15	,0})		// CODIGO DE BARRAS
	AADD(_aStru,{"DT_DIA"		,"C"	,02	,0})		// DATA DIA	
	AADD(_aStru,{"DT_MESANO"	,"C"	,08	,0})		// DATA MES/ANO	
   	AADD(_aStru,{"DT_ANO"		,"C"	,04	,0})		// DATA ANO	
	AADD(_aStru,{"DT_TRIM"		,"C"	,06	,0})		// DATA TRIMESTRE	
	
	
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)        
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"CLIENTE",,,"Selecionando Registros...")
	
	/*----------------------------------------------------------------------------------| 		    			           
	| Montagem da query com os dados da notas de abastecimento e notas de transferência |
	|----------------------------------------------------------------------------------*/
		
	clQuery := " SELECT "
	clQuery += " ZZC.ZZC_FINAL AS TIPO, "
	clQuery += " SD2.D2_CCUSTO, "
	clQuery += " SD2.D2_CLIENTE, "
	clQuery += " SD2.D2_PRUNIT, "
	clQuery += " SD2.D2_DOC, "
	clQuery += " SD2.D2_SERIE, "
	clQuery += " SD2.D2_CF, "
	clQuery += " SD2.D2_TES, "
	clQuery += " SF4.F4_FINALID, "
	clQuery += " SF2.F2_XCARGA, "
	clQuery += " SF2.F2_TRANSP, "
	clQuery += " SF2.F2_XPLACA, "
	clQuery += " SF2.F2_XMOTOR, "
	clQuery += " SD2.D2_GRUPO, "
	clQuery += " SD2.D2_COD, "
	clQuery += " SD2.D2_PRCVEN, "
	clQuery += " SD2.D2_LOCAL, "
	clQuery += " '' AS D1_LOCAL, "
	clQuery += " SB1.B1_DESC, "								// Desc. do Produto
	clQuery += " SB1.B1_UM, "
	clQuery += " SB1.B1_XSUBGRU AS COD_SUBGRP, "			// Cod. SubGrupo
	clQuery += " SD2.D2_TOTAL, "
	clQuery += " SC5.C5_XCODPA, "
	clQuery += " '' AS D1_NFORI, "
	clQuery += " '' AS D1_SERIORI, "
	clQuery += " SD2.D2_QUANT, "
	clQuery += " SD2.D2_BASEICM, "
	clQuery += " SD2.D2_PICM, "
	clQuery += " SD2.D2_VALICM, "
	clQuery += " SD2.D2_ICMSRET, "
	clQuery += " SD2.D2_DESCZFR, "
	clQuery += " SD2.D2_VALIMP5, "
	clQuery += " SD2.D2_VALIMP6, "
	clQuery += " SD2.D2_PRUNIT, "
	clQuery += " SD2.D2_DESCON, "
	clQuery += " SD2.D2_EST, "
	clQuery += " SD2.D2_VALFRE, "
	clQuery += " SD2.D2_SEGURO, "
	clQuery += " SD2.D2_DESPESA, "
	clQuery += " SD2.D2_EMISSAO, "
	clQuery += " SD2.D2_FILIAL, "
	clQuery += " SA1.A1_NOME, "
	clQuery += " SA1.A1_LOJA, "
	clQuery += " SF2.F2_XTRANSF, "
	clQuery += " SA1.A1_CGC, "
	clQuery += " SA1.A1_NATUREZ, "
	clQuery += " SF4.F4_FINALID, "
	clQuery += " (SD2.D2_TOTAL + SD2.D2_SEGURO + SD2.D2_VALFRE + SD2.D2_DESPESA)AS VALTOT, "
	clQuery += " (SB1.B1_PESO * SD2.D2_QUANT) AS PESOT, "
	clQuery += " SB1.B1_PESO AS PESOU, "
	clQuery += " SD2.D2_UM AS PUNID, "
	clQuery += " SD2.D2_SEGUM AS SUNID, "
	clQuery += " SB1.B1_CONV AS CONV, "
	clQuery += " SB1.B1_TIPCONV AS TIPCONV, "
	clQuery += " SD2.D2_QTSEGUM AS QTDS, "         
	
	/*------------------------------------------+ 
	| Novos campos - Jorge/Compras				|
	| Jackson E. de Deus	-	19/02/2013		|
	+-------------------------------------------*/
	clQuery += " SB1.B1_XSECAO AS COD_SECAO, " 								//	-- COD SECAO
	clQuery += " SB1.B1_XSECAOT AS SECAO, " 								//	-- DESC SECAO
	clQuery += " SB1.B1_XFAMILI AS COD_LINHA, " 							//	-- COD LINHA
	clQuery += " SB1.B1_XFAMLIT AS LINHA, " 								//	-- DESC LINHA
	clQuery += " SB1.B1_GRUPO AS COD_CATEG, "				   				//	-- COD CATEGORIA
	clQuery += " SB1.B1_XGRUPOT AS CATEGORIA, "								//	-- DESC CATEGORIA
	clQuery += " SB1.B1_XSUBGRT AS SUBGRUPO, " 								//	-- DESC SUBGRUPO
	clQuery += " SB1.B1_POSIPI AS NCM, " 		   							//	-- NCM
	clQuery += " SB1.B1_XCLUST AS COD_CLUSTE, " 							//	-- COD CLUSTER
	clQuery += " SB1.B1_XCLUSTD AS CLUSTER, " 								//	-- CLUSTER
	clQuery += " SB1.B1_XAMPLI AS COD_AMPLI, "								//	-- COD AMPLITUDE 
	clQuery += " SB1.B1_XDSAMPL AS AMPLITUDE, "								//	-- DESC AMPLITUDE
	clQuery += " SB1.B1_XTNEGO AS COD_TPNEG, "								//	-- COD TIPO NEGOCIO
	clQuery += " SB1.B1_XTNEGOT AS TPNEGOCIO, "								//	-- DESC TIPO NEGOCIO
	clQuery += " SB1.B1_XCONSER AS COD_CONSER, "							//	-- COD CONSERVACAO
	clQuery += " SB1.B1_XDSCONS AS CONSERV, "								//	-- DESC CONSERVACAO
	clQuery += " SB1.B1_XPREPAR AS COD_PREP, "								//	-- COD PREPARO
	clQuery += " SB1.B1_XDSPREP AS PREPARO, "								//	-- DESC PREPARO
	clQuery += " SB1.B1_XTPMAQ AS COD_TPMAQ, "								//	-- COD TP MAQUINA
	clQuery += " SB1.B1_XDSTPMA AS TPMAQUINA, "								//	-- DESC TP MAQUINA
	clQuery += " SB1.B1_XMOLA AS COD_MOLA, "								//	-- COD MOLA
	clQuery += " SB1.B1_XDSMOLA AS MOLA, "									//	-- DESC MOLA

	clQuery += " CASE SB1.B1_MSBLQL "										//	-- BLOQUEIO GERAL
	clQuery += " 	WHEN '1' "					 
	clQuery += " 		THEN 'SIM' "			 
	clQuery += "	ELSE 'NAO' "				 
	clQuery += " END AS BLQ_GERAL, "			

	clQuery += " CASE SB1.B1_XBLQCOM "										//	-- BLOQUEIO COMPRAS 
	clQuery += "	WHEN 'T' "					 
	clQuery += "		THEN 'SIM' "			 
	clQuery += "	ELSE 'NAO' "				 
	clQuery += " END AS BLQ_COMPRA, "			


	clQuery += " SB1.B1_SEGUM AS SEGUM, " 									//	-- SEGUNDA UNIDADE DE MEDIDA

	clQuery += " CASE SB1.B1_XCBGEM "										//	-- CUBAGEM  
	clQuery += "	WHEN 'T' "					 
	clQuery += "		THEN 'SIM' "			 
	clQuery += "	ELSE 'NAO' "				 
	clQuery += " END AS CUBAGEM, "				

	clQuery += " SB1.B1_CODBAR AS EAN, " 									//	-- EAN - B1_VEREAN?
	clQuery += " SB5.B5_COMPR AS COMPRIMENT, "								//	-- COMPRIMENTO
	clQuery += " SB5.B5_ESPESS AS ESPESSURA, "								//	-- ESPESSURA
	clQuery += " SB5.B5_LARG AS LARGURA " 									//	-- LARGURA
	// Fim dos novos campos
	
	clQuery += " FROM "+RetSQLName("SD2")+" AS SD2 "

	clQuery += " LEFT OUTER JOIN "+RetSQLName("SF2")+" AS SF2 ON "
	clQuery += " SD2.D2_FILIAL = SF2.F2_FILIAL AND "
	clQuery += " SD2.D2_LOJA = SF2.F2_LOJA AND "
	clQuery += " SD2.D2_CLIENTE = SF2.F2_CLIENTE AND "
	clQuery += " SD2.D2_EMISSAO = SF2.F2_EMISSAO AND "
	clQuery += " SD2.D2_DOC = SF2.F2_DOC AND "
	clQuery += " SD2.D2_SERIE = SF2.F2_SERIE AND "
	clQuery += " SD2.D_E_L_E_T_ = SF2.D_E_L_E_T_  "
	
	clQuery += " LEFT OUTER JOIN "+RetSQLName("SC5")+" AS SC5 ON "
	clQuery += " SC5.C5_FILIAL = SD2.D2_FILIAL AND "
	clQuery += " SD2.D2_PEDIDO = SC5.C5_NUM AND "
	clQuery += " SD2.D2_CLIENTE = SC5.C5_CLIENTE AND "
	clQuery += " SD2.D2_LOJA = SC5.C5_LOJACLI AND "
	clQuery += " SD2.D_E_L_E_T_ = SC5.D_E_L_E_T_  "

	clQuery += " LEFT OUTER JOIN "+RetSQLName("SA1")+" AS SA1 ON "
	clQuery += " SD2.D2_CLIENTE = SA1.A1_COD AND "
	clQuery += " SD2.D2_LOJA = SA1.A1_LOJA AND "
	clQuery += " SD2.D_E_L_E_T_ = SA1.D_E_L_E_T_ "

	clQuery += " LEFT OUTER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
	clQuery += " SD2.D2_FILIAL = SF4.F4_FILIAL AND "
	clQuery += " SD2.D2_TES = SF4.F4_CODIGO AND "
	clQuery += " SD2.D_E_L_E_T_ = SF4.D_E_L_E_T_ "
	
	clQuery += " LEFT OUTER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	clQuery += " SD2.D2_COD = SB1.B1_COD AND "
	clQuery += " SD2.D_E_L_E_T_ = SB1.D_E_L_E_T_ "
	
	/*------------------------------------------+ 
	| Junção com tabela de complementos - SB5	|
	| Jackson 19/02/2013						|
	+-------------------------------------------*/
	clQuery += "LEFT JOIN "+RetSQLName("SB5")+" AS SB5  "
	clQuery += "ON SD2.D2_COD = SB5.B5_COD AND "
	clQuery += "SD2.D_E_L_E_T_ = SB5.D_E_L_E_T_ "
	
	
	clQuery += " INNER JOIN "+RetSqlName("ZZC")+" AS ZZC ON SF2.F2_XFINAL=ZZC.ZZC_CODIGO "
	
	clQuery += " WHERE  "
	clQuery += " (SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND  "
	clQuery += " (SD2.D2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')  AND "
	clQuery += " (SD2.D2_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND " 
	clQuery += " (SD2.D2_LOCAL BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND " 
	clQuery += " (SC5.C5_XCODPA BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND "
	clQuery += " (D2_COD BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"')AND " 
	clQuery += " (D2_FILIAL BETWEEN '"+ MV_PAR16 +"' AND '"+ MV_PAR17 +"') AND " 
	clQuery += " SD2.D2_TIPO = 'N' AND " 	 
	
	If MV_PAR07==1
		clQuery += " SF4.F4_DUPLIC = 'S' AND "           // Gera financeiro
	ElseIf MV_PAR07==2    
		clQuery += " SF4.F4_DUPLIC = 'N' AND "           // Não Gera financeiro
	ElseIf MV_PAR07==3                             
		clQuery += " SF4.F4_DUPLIC IN ('S','N') AND "  	 // Ambos
	EndIf
	
	If MV_PAR08==1
		clQuery += " SF4.F4_ESTOQUE = 'S' AND "          // Movimenta Estoque
	ElseIf MV_PAR08==2    
		clQuery += " SF4.F4_ESTOQUE = 'N' AND "          // Não Movimenta Estoque
	ElseIf MV_PAR08==3
		clQuery += " SF4.F4_ESTOQUE IN ('S','N') AND " // Ambos
	EndIf                                            
	
	If MV_PAR09==1
		clQuery += " F2_XFINAL IN ('3','4') " // Transferênca/Abastecimento	
	ElseIf MV_PAR09==2    
		clQuery += " F2_XFINAL IN ('3') " // Transferência
		clQuery += " (F2_XTRANSF BETWEEN '"+ MV_PAR18 +"' AND '"+ MV_PAR19 +"') "
		//SOLICITACAO DA JULIANE DA CONTROLADORIA
		/*clQuery += " UNION ALL SELECT 'TRANSFERENCIA ENTRADA' AS TIPO,D1_CC AS D2_CCUSTO,D1_FORNECE AS D2_CLIENTE, "
		clQuery += " -D1_VUNIT AS D2_PRUNIT,D1_DOC AS D2_DOC,D1_SERIE AS D2_SERIE,D1_CF AS D2_CF, "
		clQuery += " D1_TES AS D2_TES,F4_FINALID,'' AS F2_XCARGA,'' AS F2_TRANSP,'' AS F2_XPLACA, "
		clQuery += " '' AS F2_XMOTOR,D1_GRUPO AS D2_GRUPO,D1_COD AS D2_COD,'' AS D2_PRCVEN,'' AS D2_LOCAL,D1_LOCAL, "
		clQuery += " B1_DESC,B1_UM,B1_XSUBGRU,-D1_TOTAL AS D2_TOTAL,'' AS C5_XCODPA,D1_NFORI,D1_SERIORI,  "
		clQuery += " -D1_QUANT AS D2_QUANT,-D1_BASEICM AS D2_BASEICM,-D1_PICM AS D2_PICM,-D1_VALICM AS D2_VALICM, "
		clQuery += " -D1_ICMSRET AS D2_ICMSRET,'' AS D2_DESCZFR,-D1_VALIMP5 AS D2_VALIMP5,-D1_VALIMP6 AS D2_VALIMP6, "
		clQuery += " '' AS D2_PRUNIT,'' AS D2_DESCON,A2_EST AS D2_EST,-D1_VALFRE AS D2_VALFRE,-D1_SEGURO AS D2_SEGURO, "
		clQuery += " -D1_DESPESA AS D2_DESPESA,D1_DTDIGIT AS D2_EMISSAO,D1_FILIAL AS D2_FILIAL,A2_NOME AS A1_NOME,A2_LOJA AS A1_LOJA,SUBSTRING(D1_LOJA,3,2) AS F2_XTRANSF,  "
		clQuery += " A2_CGC AS A1_CGC,A2_NATUREZ AS A1_NATUREZ,F4_FINALID,-(D1_TOTAL + D1_SEGURO + D1_VALFRE + D1_DESPESA)AS VALTOT, "
		clQuery += "-(B1_PESO * D1_QUANT) AS PESOT,-B1_PESO AS PESOU,D1_UM AS PUNID,D1_SEGUM AS SUNID,B1_CONV AS CONV,B1_TIPCONV AS TIPCONV,-D1_QTSEGUM AS QTDS "

		clQuery += " FROM "+RetSQLName("SD1")+" AS SD1 INNER JOIN  " 
		clQuery += " "+RetSQLName("SA2")+" AS SA2 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND  "
		clQuery += " SA2.D_E_L_E_T_=''  LEFT OUTER JOIN  "
		clQuery += " "+RetSQLName("SF4")+" AS SF4 ON D1_FILIAL=F4_FILIAL AND D1_TES = F4_CODIGO AND SF4.D_E_L_E_T_='' INNER JOIN  "
		clQuery += " "+RetSQLName("SB1")+" AS SB1 ON D1_COD = B1_COD AND SB1.D_E_L_E_T_=''" 
		
		clQuery += " WHERE  (D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND  "
		clQuery += " (D1_NFORI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')  AND "
		clQuery += " (D1_SERIORI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"')AND "
		clQuery += " (D1_COD BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"')AND "
		clQuery += " (D1_FILIAL BETWEEN '"+ MV_PAR16 +"' AND '"+ MV_PAR17 +"') "
		clQuery += " AND D1_FORNECE='000001' AND SUBSTRING(D1_LOJA,3,2)<>D1_FILIAL"
		clQuery += " AND SD1.D_E_L_E_T_=''"   */
		//FINAL
	ElseIf MV_PAR09==3
		clQuery += " F2_XFINAL IN ('4') "  // Abastecimento
		
		clQuery += " UNION ALL "
		
		clQuery += " SELECT 'RET. DE ABAST.' AS TIPO, "
		clQuery += " D1_CC AS D2_CCUSTO, "
		clQuery += " D1_FORNECE AS D2_CLIENTE, "
		clQuery += " -D1_VUNIT AS D2_PRUNIT, "
		clQuery += " D1_DOC AS D2_DOC, "
		clQuery += " D1_SERIE AS D2_SERIE, "
		clQuery += " D1_CF AS D2_CF, "
		clQuery += " D1_TES AS D2_TES, "
		clQuery += " F4_FINALID, "
		clQuery += " '' AS F2_XCARGA, "
		clQuery += " '' AS F2_TRANSP, "
		clQuery += " '' AS F2_XPLACA, "
		clQuery += " '' AS F2_XMOTOR, "
		clQuery += " D1_GRUPO AS D2_GRUPO, "
		clQuery += " D1_COD AS D2_COD, "
		clQuery += " '' AS D2_PRCVEN, "
		clQuery += " D2_LOCAL, "
		clQuery += " D1_LOCAL, "
		clQuery += " B1_DESC, "
		clQuery += " B1_UM, "
		clQuery += " B1_XSUBGRU AS COD_SUBGRP, "
		clQuery += " -D1_TOTAL AS D2_TOTAL, "
		clQuery += " C5_XCODPA, "
		clQuery += " D1_NFORI, "
		clQuery += " D1_SERIORI, "
		clQuery += " -D1_QUANT AS D2_QUANT, "
		clQuery += " -D1_BASEICM AS D2_BASEICM, "
		clQuery += " -D1_PICM AS D2_PICM, "
		clQuery += " -D1_VALICM AS D2_VALICM, "
		clQuery += " -D1_ICMSRET AS D2_ICMSRET, "
		clQuery += " '' AS D2_DESCZFR, "
		clQuery += " -D1_VALIMP5 AS D2_VALIMP5, "
		clQuery += " -D1_VALIMP6 AS D2_VALIMP6, "
		clQuery += " '' AS D2_PRUNIT, "
		clQuery += " '' AS D2_DESCON, "
		clQuery += " A2_EST AS D2_EST, "
		clQuery += " -D1_VALFRE AS D2_VALFRE, "
		clQuery += " -D1_SEGURO AS D2_SEGURO, "
		clQuery += " -D1_DESPESA AS D2_DESPESA, "
		clQuery += " D1_DTDIGIT AS D2_EMISSAO, "
		clQuery += " D1_FILIAL AS D2_FILIAL, "
		clQuery += " A2_NOME AS A1_NOME, "
		clQuery += " A2_LOJA AS A1_LOJA, "
		clQuery += " '' AS F2_XTRANSF, "
		clQuery += " A2_CGC AS A1_CGC, "
		clQuery += " A2_NATUREZ AS A1_NATUREZ, "
		clQuery += " F4_FINALID, "
		clQuery += " -(D1_TOTAL + D1_SEGURO + D1_VALFRE + D1_DESPESA)AS VALTOT, "
		clQuery += "-(B1_PESO * D1_QUANT) AS PESOT, "
		clQuery += " -B1_PESO AS PESOU, "
		clQuery += " D1_UM AS PUNID, "
		clQuery += " D1_SEGUM AS SUNID, "
		clQuery += " B1_CONV AS CONV, "
		clQuery += " B1_TIPCONV AS TIPCONV, "
		clQuery += " -D1_QTSEGUM AS QTDS, " 
		
		/*------------------------------------------+ 
		| Novos campos - Jorge/Compras				|
		| Jackson E. de Deus	-	19/02/2013		|
		+-------------------------------------------*/
		clQuery += " SB1.B1_XSECAO AS COD_SECAO, " 								//	-- COD SECAO
		clQuery += " SB1.B1_XSECAOT AS SECAO, " 								//	-- DESC SECAO
		clQuery += " SB1.B1_XFAMILI AS COD_LINHA, " 							//	-- COD LINHA
		clQuery += " SB1.B1_XFAMLIT AS LINHA, " 								//	-- DESC LINHA
		clQuery += " SB1.B1_GRUPO AS COD_CATEG, "				   				//	-- COD CATEGORIA
		clQuery += " SB1.B1_XGRUPOT AS CATEGORIA, "								//	-- DESC CATEGORIA
		clQuery += " SB1.B1_XSUBGRT AS SUBGRUPO, " 								//	-- DESC SUBGRUPO
		clQuery += " SB1.B1_POSIPI AS NCM, " 		   							//	-- NCM
		clQuery += " SB1.B1_XCLUST AS COD_CLUSTE, " 							//	-- COD CLUSTER
		clQuery += " SB1.B1_XCLUSTD AS CLUSTER, " 								//	-- CLUSTER
		clQuery += " SB1.B1_XAMPLI AS COD_AMPLI, "								//	-- COD AMPLITUDE 
		clQuery += " SB1.B1_XDSAMPL AS AMPLITUDE, "								//	-- DESC AMPLITUDE
		clQuery += " SB1.B1_XTNEGO AS COD_TPNEG, "								//	-- COD TIPO NEGOCIO
		clQuery += " SB1.B1_XTNEGOT AS TPNEGOCIO, "								//	-- DESC TIPO NEGOCIO
		clQuery += " SB1.B1_XCONSER AS COD_CONSER, "							//	-- COD CONSERVACAO
		clQuery += " SB1.B1_XDSCONS AS CONSERV, "								//	-- DESC CONSERVACAO
		clQuery += " SB1.B1_XPREPAR AS COD_PREP, "								//	-- COD PREPARO
		clQuery += " SB1.B1_XDSPREP AS PREPARO, "								//	-- DESC PREPARO
		clQuery += " SB1.B1_XTPMAQ AS COD_TPMAQ, "								//	-- COD TP MAQUINA
		clQuery += " SB1.B1_XDSTPMA AS TPMAQUINA, "								//	-- DESC TP MAQUINA
		clQuery += " SB1.B1_XMOLA AS COD_MOLA, "								//	-- COD MOLA
		clQuery += " SB1.B1_XDSMOLA AS MOLA, "									//	-- DESC MOLA

		clQuery += " CASE SB1.B1_MSBLQL "										//	-- BLOQUEIO GERAL
		clQuery += " 	WHEN '1' "					 
		clQuery += " 		THEN 'SIM' "			 
		clQuery += "	ELSE 'NAO' "				 
		clQuery += " END AS BLQ_GERAL, "			

		clQuery += " CASE SB1.B1_XBLQCOM "										//	-- BLOQUEIO COMPRAS 
		clQuery += "	WHEN 'T' "					 
		clQuery += "		THEN 'SIM' "			 
		clQuery += "	ELSE 'NAO' "				 
		clQuery += " END AS BLQ_COMPRA, "			


		clQuery += " SB1.B1_SEGUM AS SEGUM, " 									//	-- SEGUNDA UNIDADE DE MEDIDA
	
		clQuery += " CASE SB1.B1_XCBGEM "										//	-- CUBAGEM  
		clQuery += "	WHEN 'T' "					 
		clQuery += "		THEN 'SIM' "			 
		clQuery += "	ELSE 'NAO' "				 
		clQuery += " END AS CUBAGEM, "				

		clQuery += " SB1.B1_CODBAR AS EAN, " 									//	-- EAN - B1_VEREAN?
		clQuery += " SB5.B5_COMPR AS COMPRIMENT, "								//	-- COMPRIMENTO
		clQuery += " SB5.B5_ESPESS AS ESPESSURA, "								//	-- ESPESSURA
		clQuery += " SB5.B5_LARG AS LARGURA " 									//	-- LARGURA
		// Fim dos novos campos
	
		clQuery += " FROM "+RetSQLName("SD1")+" AS SD1 "

		clQuery += " INNER JOIN "+RetSQLName("SF2")+" AS SF2 ON "
		clQuery += " D1_FILIAL = F2_FILIAL AND "
		clQuery += " D1_LOJA = F2_LOJA AND "
		clQuery += " D1_FORNECE = F2_CLIENTE AND "
		clQuery += " D1_NFORI = F2_DOC AND "
		clQuery += " D1_SERIORI = F2_SERIE "
		
		clQuery += " LEFT OUTER JOIN "+RetSQLName("SA2")+" AS SA2 ON "
		clQuery += " D1_FORNECE = A2_COD AND "
		clQuery += " D1_LOJA = A2_LOJA AND  "
		clQuery += " SA2.D_E_L_E_T_ = '' "

		clQuery += " LEFT OUTER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
		clQuery += " D1_FILIAL = F4_FILIAL AND "
		clQuery += " D1_TES = F4_CODIGO AND "
		clQuery += " SF4.D_E_L_E_T_ = '' "
		
		clQuery += " INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
		clQuery += " D1_COD = B1_COD AND "
		clQuery += " SB1.D_E_L_E_T_ = '' "
		
		/*------------------------------------------+ 
		| Junção com tabela de complementos - SB5	|
		| Jackson 19/02/2013						|
		+-------------------------------------------*/
		clQuery += "LEFT JOIN "+RetSQLName("SB5")+" AS SB5  "
		clQuery += "ON SD1.D1_COD = SB5.B5_COD AND "
		clQuery += "SD1.D_E_L_E_T_ = SB5.D_E_L_E_T_ "         
		
		clQuery += " INNER JOIN "+RetSQLName("SD2")+" AS SD2 ON "
		clQuery += " D1_FILIAL = D2_FILIAL AND "
		clQuery += " D1_LOJA = D2_LOJA AND "
		clQuery += " D1_FORNECE = D2_CLIENTE  AND  "
		clQuery += " D1_NFORI = D2_DOC AND "
		clQuery += " D1_SERIORI = D2_SERIE AND "
		clQuery += " D1_ITEMORI = D2_ITEM AND "
		clQuery += " SD2.D_E_L_E_T_ = '' "

		clQuery += " INNER JOIN "+RetSQLName("SC5")+" AS SC5 ON "
		clQuery += " D2_FILIAL = C5_FILIAL AND "
		clQuery += " D2_PEDIDO = C5_NUM AND "
		clQuery += " D2_CLIENTE = C5_CLIENTE AND "
		clQuery += " D2_LOJA = C5_LOJACLI AND "
		clQuery += " SC5.D_E_L_E_T_ = '' "

		clQuery += " INNER JOIN "+RetSQLName("ZZC")+" AS ZZC ON "
		clQuery += " F2_XFINAL = ZZC_CODIGO AND "
		clQuery += " ZZC.D_E_L_E_T_ = '' "
		
		clQuery += " WHERE  "
		clQuery += " (D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND  "
		clQuery += " (D1_NFORI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')  AND "
		clQuery += " (D1_SERIORI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
		clQuery += " (D2_LOCAL BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
		clQuery += " (C5_XCODPA BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND "
		clQuery += " (D1_COD BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"') AND "
		clQuery += " (D1_FILIAL BETWEEN '"+ MV_PAR16 +"' AND '"+ MV_PAR17 +"') AND"
		clQuery += " D1_TIPO = 'D' AND "
		clQuery += " F2_XFINAL = '4' "
	EndIf
	
	/*-----------------------------------------| 		    			           
	| Verifica se a query existe se sim fecha |
	|-----------------------------------------*/	    			           

	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
	/*------------------------------| 		    			           
	| cria a query e dar um apelido |
	|------------------------------*/
	MemoWrite("TTFATR24.SQL",clQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TSQL1",.F.,.T.)
	
	/*------------------------------------------| 		    			           
	| ajusta casas decimais no retorno da query | 
	|------------------------------------------*/
	
	TcSetField("TSQL1","D2_EMISSAO"	,"D",08,0)
	TcSetField("TSQL1","D2_TOTAL"	,"N",14,2)
	TcSetField("TSQL1","D2_VALICM"	,"N",14,2)
	TcSetField("TSQL1","D2_VALIMP5"	,"N",14,2)
	TcSetField("TSQL1","D2_VALIMP6"	,"N",14,2)
	TcSetField("TSQL1","D2_DESCON"	,"N",14,2)
	TcSetField("TSQL1","D2_QUANT"	,"N",14,2)
	TcSetField("TSQL1","D2_PRVEN"	,"N",14,2)
	TcSetField("TSQL1","PESOT"		,"N",14,4)
	TcSetField("TSQL1","PESOU"		,"N",14,4)
	TcSetField("TSQL1","QTDS"		,"N",14,4)
	
	dbSelectArea("TSQL1")
	dbGotop()
	Do While TSQL1->(!Eof())	
		DbSelectArea("ZZ1")
		DbSetOrder(1)
		If DbSeek(TSQL1->D2_FILIAL + TSQL1->D2_LOCAL)
			clDescSai:=ZZ1_DESCRI
		EndIf		
		If DbSeek( TSQL1->D2_FILIAL + TSQL1->C5_XCODPA)
			clDescEnt:=ZZ1_DESCRI
		EndIf		
		If DbSeek( TSQL1->D2_FILIAL + TSQL1->D1_LOCAL)
			LocalEnt:=ZZ1_DESCRI
		EndIf				 
	    DbSelectArea("ZZ9")
	    DbSetOrder(1)
	    If DbSeek(Xfilial("ZZ9") + TSQL1->D2_COD)
	     	nlCub :=(ZZ9->ZZ9_COMPRI * ZZ9->ZZ9_ALTURA * ZZ9->ZZ9_LARGUR)
	    EndIf     
	    //Solicitacao da Juliane chatinha da controladoria - Alexandre 18/03/13
	    If MV_PAR09 == 2  
	    	DbSelectArea("SD1")
	    	DbSetOrder(1)
	    	If DbSeek(TSQL1->F2_XTRANSF+TSQL1->D2_DOC+TSQL1->D2_SERIE+'000001'+Strzero(val(TSQL1->D2_FILIAL),4)+TSQL1->D2_COD+TSQL1->D2_ITEM)
	    		cStatus := If(!EMPTY(SD1->D1_TES),'Classificada','Nao Classificada')
	    		cDataC	:= If(!EMPTY(SD1->D1_TES),SD1->D1_DTDIGIT,CTOD("  / /  "))
	    		cArmzE	:= SD1->D1_LOCAL
	    		cDescA	:= If(!empty(cArmzE),Posicione("ZZ1",1,TSQL1->F2_XTRANSF+cArmzE,"ZZ1_DESCRI"),"")
	    	EndIf
	    EndIf
		DbSelectArea("TRB")		
	/*--------------------------| 		    			           
	| adciona registro em banco | 
	|--------------------------*/
		     
		RecLock("TRB",.T.)
			TRB->TIPO		:= TSQL1->TIPO
			TRB->PUNID		:= TSQL1->PUNID
			TRB->SUNID		:= TSQL1->SUNID
			TRB->PESOT		:= TSQL1->PESOT
			TRB->PESOU		:= TSQL1->PESOU
			TRB->CUBAGEM	:= (nlCub * TSQL1->QTDS)  
			TRB->PROD		:= TSQL1->D2_COD			// Cod do produto
			TRB->DESCPROD	:= TSQL1->B1_DESC			// Desc. do produto
			TRB->QUANT		:= TSQL1->D2_QUANT
			TRB->RPRVEN		:= TSQL1->D2_PRCVEN				     	     		     
	     	TRB->COD_CLI	:= TSQL1->D2_CLIENTE
	     	TRB->LOJA		:= TSQL1->A1_LOJA
	      	TRB->CLIENTE	:= TSQL1->A1_NOME
	      	TRB->NATUREZA   := TSQL1->A1_NATUREZ
	      	TRB->CNPJ		:= TSQL1->A1_CGC
		    TRB->NOTA		:= TSQL1->D2_DOC
	    	TRB->SERIE		:= TSQL1->D2_SERIE
	    	TRB->NOTAORI	:= TSQL1->D1_NFORI
	    	TRB->SERIORI	:= TSQL1->D1_SERIORI                          
	        TRB->TOTAL		:= TSQL1->D2_TOTAL
	        TRB->ALIQICM	:= TSQL1->D2_PICM
	        TRB->BASEICM	:= TSQL1->D2_BASEICM		
	        TRB->ICMS		:= TSQL1->D2_VALICM
	        TRB->PIS		:= TSQL1->D2_VALIMP5
	        TRB->CONFINS	:= TSQL1->D2_VALIMP6
	        TRB->ICMS_ST	:= TSQL1->D2_ICMSRET       
	        TRB->CFOP		:= TSQL1->D2_CF
	        TRB->CCUSTO		:= TSQL1->D2_CCUSTO
	        TRB->TES		:= TSQL1->D2_TES
	        TRB->DESCONTO	:= TSQL1->D2_DESCON
	        TRB->FRETE		:= TSQL1->D2_VALFRE 
	        TRB->SEGURO		:= TSQL1->D2_SEGURO
	        TRB->FILIALSAI 	:= TSQL1->D2_FILIAL   
	        TRB->FILIALDEST	:= TSQL1->F2_XTRANSF
	        TRB->ESTADO		:= TSQL1->D2_EST
	        TRB->EMISSAO	:= TSQL1->D2_EMISSAO
	        TRB->ARMAZEM	:= TSQL1->D2_LOCAL	
	        TRB->ROMAN   	:= TSQL1->F2_XCARGA
	        TRB->TRANSP		:= TSQL1->F2_TRANSP
	        TRB->PLACA		:= TSQL1->F2_XPLACA
	        TRB->MOTOR		:= TSQL1->F2_XMOTOR
	        TRB->ARM_ENT	:= TSQL1->C5_XCODPA  		// Armazem de entrega
	        TRB->DESCARME	:= clDescEnt         		// Descrição do armazém de entrega
	        TRB->DESCARMS	:= clDescSai         		// Descrição do armazém de saída
	        TRB->PR_UNIT	:= TSQL1->D2_PRUNIT
	        TRB->FINALID   	:= TSQL1->F4_FINALID  
	        TRB->LOC_ENT	:= If(!empty(cArmzE),cArmzE,TSQL1->D1_LOCAL)
	        TRB->DESC_ENT   := If(!empty(cDescA),cDescA,LocalEnt)
	        TRB->FATCONV	:= TSQL1->CONV
			TRB->TIPCONV	:= TSQL1->TIPCONV		
			TRB->QT_UNID_UN	:= Iif(TSQL1->TIPCONV="M",(TSQL1->D2_QUANT * TSQL1->CONV),TSQL1->D2_QUANT)		            	        	           	        	           	        
			TRB->STATUS		:= cStatus
			TRB->DT_CLAS	:= cDataC	            	        	           	        	           	        
			/*------------------------------------------+ 
			| Solicitação do Jorge/Compras 				|
			| Jackson 19/02/2013						|
			+-------------------------------------------*/
			TRB->COD_SECAO	:= TSQL1->COD_SECAO			// COD SECAO			
			TRB->DESC_SECAO	:= TSQL1->SECAO				// DESC SECAO
			TRB->COD_LINHA	:= TSQL1->COD_LINHA			// COD SECAO						
			TRB->DESC_LINHA	:= TSQL1->LINHA				// NOME LINHA
			TRB->COD_CATEG	:= TSQL1->COD_CATEG 		// NOME DA CATEGORIA			
			TRB->CATEGORIA	:= TSQL1->CATEGORIA 		// NOME DA CATEGORIA
			TRB->COD_SUBGRP := TSQL1->COD_SUBGRP		// COD DO SUBGRUPO
			TRB->SUBGRUPO	:= TSQL1->SUBGRUPO			// NOME DO SUBGRUPO
			TRB->COD_CLUSTE	:= TSQL1->COD_CLUSTE		// COD CLUSTER
			TRB->CLUSTER	:= TSQL1->CLUSTER			// DESC CLUSTER
			TRB->COD_AMPLI	:= TSQL1->COD_AMPLI			// COD AMPLITUDE 
			TRB->AMPLITUDE	:= TSQL1->AMPLITUDE			// DESC AMPLITUDE
			TRB->COD_TPNEG	:= TSQL1->COD_TPNEG			// COD TIPO NEGOCIO
			TRB->TPNEGOCIO	:= TSQL1->TPNEGOCIO			// DESC TIPO NEGOCIO
			TRB->COD_CONSER	:= TSQL1->COD_CONSER		// COD CONSERVACAO
			TRB->CONSERV	:= TSQL1->CONSERV			// DESC CONSERVACAO
			TRB->COD_PREP	:= TSQL1->COD_PREP			// COD PREPARO
			TRB->PREPARO	:= TSQL1->PREPARO			// DESC PREPARO
			TRB->COD_TPMAQ	:= TSQL1->COD_TPMAQ			// COD TP MAQUINA
			TRB->TPMAQUINA	:= TSQL1->TPMAQUINA			// DESC TP MAQUINA
			TRB->COD_MOLA	:= TSQL1->COD_MOLA			// COD MOLA
			TRB->MOLA		:= TSQL1->MOLA				// DESC MOLA				
			TRB->BLQ_GERAL	:= TSQL1->BLQ_GERAL			// BLOQUEIO GERAL DO PRODUTO - Converte de 1 - 2 para Sim - Nao		
			TRB->BLQ_COMPRA	:= TSQL1->BLQ_GERAL			// BLOQUEIO DO COMPRAS - Converte de T - F para Sim - Nao		
            TRB->UM			:= TSQL1->PUNID				// UNIDADE DE MEDIDA
			TRB->SEGUNID	:= TSQL1->SEGUM				// SEG. UNID. MEDIDA 
			TRB->CUBAGEM_2	:= TSQL1->CUBAGEM			// CUBAGEM DO PRODUTO 
			TRB->COMPRIMENT	:= TSQL1->COMPRIMENT		// COMPRIMENTO
			TRB->ESPESSURA	:= TSQL1->ESPESSURA			// ESPESSURA
			TRB->LARGURA	:= TSQL1->LARGURA			// LARGURA
			TRB->EAN		:= TSQL1->EAN				// EAN

			// Armazena a Data de Emissão da Nota Fiscal
			dDtEmiss		:= TSQL1->D2_EMISSAO        
	
			// Busca Datas Formatadas
			aRetData		:= ConvData(dDtEmiss)
		                                                  
			TRB->DT_DIA		:= aRetData[1][1]											// Data Dia
			TRB->DT_MESANO	:= Substr(aRetData[2][2],1,3) + "/" + aRetData[3][1]		// Data Mes/Ano - Ex: Jan/2013	
			TRB->DT_ANO		:= aRetData[3][1]								   			// Data Ano - Ex: 2013
			TRB->DT_TRIM	:= aRetData[2][3] + aRetData[3][1]							// Data Trimestre/Ano - Ex: 1T2013     
	
		
		
		MsUnlock() 
		
		nlCub		:= 0
		clDescEnt	:= ""
        clDescSai	:= ""
        LocalEnt 	:= ""
        clFinalid	:= ""	
	    
	    dbSelectArea("TSQL1")
	    DbSkip()
	    
	Enddo
	
If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConvData   ºAutor  ³Jackson E. de Deus º Data ³  15/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna Array com data quebrada em Dia, Mês, Ano           º±±
±±º          ³ e Trimestre                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConvData(dDtDigit)
                
Local aRetData := {{0},{0,"",""},{""}}

If ValType(dDtDigit) <> "D"
	MsgAlert("Tipo incorreto de Data!")
EndIf         
                               
/*----------------------------------------------------------------------+
|																  		|
| Array de retorno														|
| Estrutura																|
| aRetData[x][x]														|
|																		|
| aRetData[1][1] 	-> Dia												|
| aRetData[2][1]	-> Dia do Mes										|
| aRetData[2][2]	-> Nome do Mes										|
| aRetData[2][3]	-> Trimestre										|
| aRetData[3][1]	-> Ano  											|
|																		|
|																		|
+-----------------------------------------------------------------------*/

// Dia
aRetData[1][1] := Day(dDtDigit)
aRetData[1][1] := Str(aRetData[1][1])
aRetData[1][1] := Alltrim(aRetData[1][1])

// Mes
aRetData[2][1]	:= Month(dDtDigit)
aRetData[2][3] := Alltrim(aRetData[2][3])		// Trimestre

// Ano
aRetData[3][1] := Year(dDtDigit) 
aRetData[3][1] := Str(aRetData[3][1]) 
aRetData[3][1] := Alltrim(aRetData[3][1])



		    


// Busca o nome do mês
Do Case 
	Case aRetData[2][1] == 1
		aRetData[2][2]	:= "Janeiro"
		
	Case aRetData[2][1] == 2
		aRetData[2][2]	:= "Fevereiro"
	
	Case aRetData[2][1] == 3
		aRetData[2][2]	:= "Março"
	
	Case aRetData[2][1] == 4
		aRetData[2][2]	:= "Abril"
	
	Case aRetData[2][1] == 5
		aRetData[2][2]	:= "Maio"
	
	Case aRetData[2][1] == 6
		aRetData[2][2]	:= "Junho"
	
	Case aRetData[2][1] == 7
		aRetData[2][2]	:= "Julho"
	
	Case aRetData[2][1] == 8
		aRetData[2][2]	:= "Agosto"
	
	Case aRetData[2][1] == 9
		aRetData[2][2]	:= "Setembro"
	
	Case aRetData[2][1] == 10
		aRetData[2][2]	:= "Outubro"
	
	Case aRetData[2][1] == 11
		aRetData[2][2]	:= "Novembro"
	
	Case aRetData[2][1] == 12
		aRetData[2][2]	:= "Dezembro"
			
End Case	

// Busca o Trimestre
Do Case
	Case aRetData[2][1] <= 3
   		aRetData[2][3]	:= "1T"
   		
   	Case aRetData[2][1] >= 4 .And. aRetData[2][1] <= 6
		aRetData[2][3]	:= "2T"
   	
   	Case aRetData[2][1] >= 7 .And. aRetData[2][1] <= 9
		aRetData[2][3]	:= "3T"
   	
   	Case aRetData[2][1] >= 10 .And. aRetData[2][1] <= 12
		aRetData[2][3]	:= "4T"
   		

End Case


Return (aRetData)



Static Function ValPerg(cPerg)
	PutSx1(cPerg,'01','Emissao de       ?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate     	?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Nota de          ?','','','mv_ch3','C',09,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Nota Ate         ?','','','mv_ch4','C',09,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Serie de         ?','','','mv_ch5','C',03,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Serie Ate 		?','','','mv_ch6','C',03,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'07','Gera financeiro	?','','','mv_ch7','N',1,0,1,'C','','','','','mv_par07',"SIM","","","","NAO","","","AMBOS","","","","","","","","")
	PutSx1(cPerg,'08','Movi. Estoque	?','','','mv_ch8','N',1,0,1,'C','','','','','mv_par08',"SIM","","","","NAO","","","AMBOS","","","","","","","","")
	PutSx1(cPerg,'09','Tipo de Saida	?','','','mv_ch9','N',1,0,1,'C','','','','','mv_par09',"Trans/Abast","","","","Transferencia","","","Abastecimento","","","","","","","","")	
	PutSx1(cPerg,'10','Armaz_Saida de	?','','','mv_chA','C',06,0,0,'G','','ZZ1','','','mv_par10',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'11','Armaz_Saida ate 	?','','','mv_chB','C',06,0,0,'G','','ZZ1','','','mv_par11',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'12','Armaz_Entre de   ?','','','mv_chC','C',06,0,0,'G','','ZZ1','','','mv_par12',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'13','Armaz_Entre ate  ?','','','mv_chD','C',06,0,0,'G','','ZZ1','','','mv_par13',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'14','Produto  de   	?','','','mv_chE','C',15,0,0,'G','','SB1','','','mv_par14',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'15','Produto ate   	?','','','mv_chF','C',15,0,0,'G','','SB1','','','mv_par15',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'16','Filial  de   	?','','','mv_chG','C',02,0,0,'G','','SM0','','','mv_par16',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'17','Filial ate   	?','','','mv_chH','C',02,0,0,'G','','SM0','','','mv_par17',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,"18","Filial Dest De   ?","","","mv_chi","C",02,00,00,"G","","SM0","","","mv_Par18","","","","","","","","","","","","","","","","",{"Somente no caso de transferência"},{},{},"")
	PutSx1(cPerg,"19","Filial Dest Ate  ?","","","mv_chj","C",02,00,00,"G","","SM0","","","mv_Par19","","","","","","","","","","","","","","","","",{"Somente no caso de transferência"},{},{},"")				  
Return
