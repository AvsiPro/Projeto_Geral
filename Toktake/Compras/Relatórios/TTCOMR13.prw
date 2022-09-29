/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ TTCOMR13 ¦ Autor ¦ Fabio Sales		 ¦  Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Relatório de vendas e devoluções que geram financeiros     ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Historico ¦ Alterações				¦ Autor 				¦Data	  ¦¦¦
¦¦+----------+--------------------------+-----------------------+---------¦¦¦
¦¦¦			 ¦ Adicionadas novas colunas¦ Jackson E. de Deus	¦19/02/13 ¦¦¦
¦¦¦			 ¦ Solicitado por Jorge		¦						¦		  ¦¦¦	
¦¦¦			 ¦ Compras					¦						¦		  ¦¦¦
¦¦+----------+--------------------------+-----------------------+---------¦¦¦
¦¦¦Uso       ¦ Faturamento/Tok Take                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


User Function TTCOMR13()
Local oReport

If cEmpAnt == "01"

	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
EndIF

Return

/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ReportDef ¦ Autor ¦ Fabio Sales		   ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função Principal de Impressão				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokeTake                                        ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

Local oReport
Local oSection
Private cPerg    := "COMPV"

ValPerg(cPerg)
Pergunte(cPerg,.T.)

oReport := TReport():New("TTCOMR13","Custo das Vendas x Custo Medio",cPerg,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir precos das vendas x custo medio dos produtos")

/*------------------------|
| seção das notas fiscais |
|------------------------*/

oSection1 := TRSection():New(oReport,OemToAnsi("Custo Unitario"),{"TRB"})

/*----------------------------------------------------------------------------------|
|                       campo        alias  título       	 pic           tamanho  |
|----------------------------------------------------------------------------------*/

TRCell():New(oSection1,"TIPO"			,"TRB"	,"TIPO"					,"@!"					,20)
TRCell():New(oSection1,"FILIAL"			,"TRB"	,"FILIAL"				,"@!"					,02)
TRCell():New(oSection1,"DESCFIL"		,"TRB"	,"DESC_FILIAL"			,"@!"					,35)
TRCell():New(oSection1,"PEDIDO"			,"TRB"	,"PEDIDO"				,"@!"					,06)
TRCell():New(oSection1,"NOTA"			,"TRB"	,"NOTA"					,"@!"					,09)
TRCell():New(oSection1,"SERIE"			,"TRB"	,"SERIE"				,"@!"					,03)
TRCell():New(oSection1,"EMISSAO"		,"TRB"	,"EMISSAO"				,						,08)
TRCell():New(oSection1,"CODVEND"		,"TRB"	,"CODVEND"				,"@!"					,06)
TRCell():New(oSection1,"VENDED"			,"TRB"	,"VENDEDOR"				,"@!"					,40)
TRCell():New(oSection1,"SUPERV"			,"TRB"	,"COD.SUPERVISOR" 		,"@!"					,06)
TRCell():New(oSection1,"DESCSUPER"		,"TRB"	,"DESC.SUPERVISOR"		,"@!"					,35)
TRCell():New(oSection1,"GERENT"			,"TRB"	,"COD.GERENTE"			,"@!"					,06)
TRCell():New(oSection1,"DESCGEREN"		,"TRB"	,"DESC.GERENTE"			,"@!"					,35)
TRCell():New(oSection1,"COD_CLI"		,"TRB"	,"COD_CLI"				,"@!"					,06)
TRCell():New(oSection1,"CLIENTE"		,"TRB"	,"CLIENTE"				,"@!"					,40)
TRCell():New(oSection1,"LOJA"			,"TRB"	,"LOJA"					,"@!"					,04)
TRCell():New(oSection1,"ESTADO"			,"TRB"	,"ESTADO"				,"@!"					,02)
TRCell():New(oSection1,"CIDADE"			,"TRB"	,"CIDADE"				,"@!"					,35)
TRCell():New(oSection1,"ITEM"			,"TRB"	,"ITEM_NOTA"			,"@!"					,04)
TRCell():New(oSection1,"PRODUTO"		,"TRB"	,"COD_PROD"				,"@!"					,15)
TRCell():New(oSection1,"DESCPRO"		,"TRB"	,"DESC_PROD"			,"@!"					,30)
TRCell():New(oSection1,"UNI_MED"		,"TRB"	,"UNI_MED"				,"@!"					,02)
TRCell():New(oSection1,"SUBGRUP"		,"TRB"	,"SUB_GRUPO"			,"@!"					,04)
TRCell():New(oSection1,"DESCSUBG"		,"TRB"	,"DESC_SUBGRUP"			,"@!"					,30)
TRCell():New(oSection1,"GRUPO"			,"TRB"	,"CATEGORIA"			,"@!"					,04)
TRCell():New(oSection1,"DESCGRUP"		,"TRB"	,"DESC_CATEGORIA"		,"@!"					,30)
TRCell():New(oSection1,"SECAO"			,"TRB"	,"SECAO"				,"@!"					,04)
TRCell():New(oSection1,"DESCSEC"		,"TRB"	,"DESC_SECAO"			,"@!"					,30)
TRCell():New(oSection1,"LINHA"			,"TRB"	,"LINHA"				,"@!"					,03)
TRCell():New(oSection1,"DESCLIN"		,"TRB"	,"DESC_LINHA"			,"@!"					,30)
TRCell():New(oSection1,"LOCALPD"		,"TRB"	,"LOCAL"				,"@!"					,06)
TRCell():New(oSection1,"DESCARM"		,"TRB"	,"DESC_ARMAZEM"			,"@!"					,30)
TRCell():New(oSection1,"TES"			,"TRB"	,"TES"					,"@!"					,03)
TRCell():New(oSection1,"CFOP"			,"TRB"	,"CFOP"					,"@!"					,05)
TRCell():New(oSection1,"NCM"			,"TRB"	,"NCM"					,"@!"					,10)
TRCell():New(oSection1,"ROMAN" 			,"TRB"	,"NRO_ROMANEIO"			,"@!"					,10)
TRCell():New(oSection1,"TRANSP"			,"TRB"	,"COD_TRANSP"			,"@!"					,16)
TRCell():New(oSection1,"PLACA"			,"TRB"	,"PLACA_CARRO"			,"@E XXX-9999"			,08)
TRCell():New(oSection1,"MOTOR"  		,"TRB"	,"MOTORISTA"			,"@!"					,40)
TRCell():New(oSection1,"CHVNFE"			,"TRB"	,"NF_ELETRONICA"		,"@!"					,12)
TRCell():New(oSection1,"QTDE"			,"TRB"	,"QTDE"					,"@E 999,999.99"		,16)
TRCell():New(oSection1,"PR_UNIT"		,"TRB"	,"PR_UNIT"				,"@E 999,999.99"		,16)
TRCell():New(oSection1,"PRCVEN"			,"TRB"	,"PR_VENDA"				,"@E 999,999.99"		,16)
TRCell():New(oSection1,"TOTAL"			,"TRB"	,"VLR.MERC_LIQUIDO"		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"TOTSDESC"		,"TRB"	,"VLR.MERC_BRUTO"		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"FATCONV"		,"TRB"	,"FATOR_CONVEÇÃO" 		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"TIPCONV"		,"TRB"	,"TIPO_CONVENÇÃO"		,"@!"					,15)
TRCell():New(oSection1,"SEGUNID"		,"TRB"	,"SEGUNDA UNIDADE"		,"@!"					,04)
TRCell():New(oSection1,"QT_UNID_UN"		,"TRB"	,"QTDE_UNID_UNICA"		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"DESCONTO"		,"TRB"	,"DESCONTO"				,"@E 999,999.99"		,16)
TRCell():New(oSection1,"FRETE"			,"TRB"	,"FRETE"				,"@E 999,999.99"		,16)
TRCell():New(oSection1,"SEGURO"			,"TRB"	,"SEGURO"				,"@E 999,999.99"		,16)
TRCell():New(oSection1,"DESPESAS"		,"TRB"	,"DESPESAS"				,"@E 999,999.99"		,16)
TRCell():New(oSection1,"VALTOT"	   		,"TRB"	,"VRL.TOTAL_NOTA"		,"@E 999,999.99"		,16)

If MV_PAR07==1
	TRCell():New(oSection1,"CM_STD"		,"TRB"	,"CM_STD"				,"@E 999,999.999999"	,16)
ElseIf MV_PAR07==2
	TRCell():New(oSection1,"CM_ATUAL"	,"TRB"	,"CM_ATUAL"				,"@E 999,999.999999"	,16)
Else
	TRCell():New(oSection1,"CM_FECH"	,"TRB"	,"CM_FECH"				,"@E 999,999.999999"	,16)
EndIf

TRCell():New(oSection1,"GRUPTRIB"		,"TRB"	,"GRUPO_TRIBUTAÇÃO"		,"@!"			 		,06)
TRCell():New(oSection1,"DESCGRTRI"		,"TRB"	,"DESC_GRUP_TRIB"	 	,"@!"			 		,30)
TRCell():New(oSection1,"ICMS"			,"TRB"	,"ICMS_DESTAQUE"	 	,"@E 999,999.99"		,16)
TRCell():New(oSection1,"ICMSTRIB"		,"TRB"	,"ICMS_TRIBUTADO"		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"ICMSISEN"		,"TRB"	,"ICMS_ISENTO"	 		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"ICMSOUTR"		,"TRB"	,"ICMS_OUTROS"	 		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"DESCZFR"		,"TRB"	,"DESC_VEND_Z.FRANCA"	,"@E 999,999.99"		,16)
TRCell():New(oSection1,"ICMS_ST"		,"TRB"	,"ICMS_ST"		 		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"PISCOFINS"		,"TRB"	,"PIS/CONFINS"	 		,"@!"					,05)
TRCell():New(oSection1,"PIS"   			,"TRB"	,"CONFINS"	 			,"@E 999,999.99" 		,16)
TRCell():New(oSection1,"CONFINS"		,"TRB"	,"PIS"			 		,"@E 999,999.99" 		,16)
TRCell():New(oSection1,"VALISS"			,"TRB"	,"VALISS"		 		,"@E 999,999.99" 		,16)
TRCell():New(oSection1,"XCANAL"  		,"TRB"	,"CANAL DO CLIENTE"		,"@!"			 		,30)
TRCell():New(oSection1,"DESCCAN"		,"TRB"	,"DESC_CANAL"		 	,"@!"			 		,30)
TRCell():New(oSection1,"CCUSTO"  		,"TRB"	,"CENT_CUSTO"		 	,"@!"			 		,30)
TRCell():New(oSection1,"DESCCUSTO"  	,"TRB"	,"DESC_CENT_CUSTO" 		,"@!"		     		,30)
TRCell():New(oSection1,"FINALID" 		,"TRB"	,"FINALID_TES"	 		,"@!"			 		,30)
TRCell():New(oSection1,"FINALIDA"		,"TRB"	,"FINALID_DA_VENDA"		,"@!"			 		,20)
TRCell():New(oSection1,"CM_STD_UN"		,"TRB"	,"CM_STD_UNITÁRIO"		,"@E 999,999.99"		,16)
TRCell():New(oSection1,"ITEMC"  		,"TRB"	,"ITEM_CONTÁBIL"		,"@!"			 		,21)
TRCell():New(oSection1,"DCITEMC"  		,"TRB"	,"DESC_ITEM_CONTÁBIL" 	,"@!"			   		,21)
TRCell():New(oSection1,"RECLIQ"	 		,"TRB"	,"REC. LIQUIDA"	 		,"@E 999,999,999.99"	,16)
TRCell():New(oSection1,"MARGEM"	 		,"TRB"	,"MARGEM"			 	,"@E 999,999,999.99"	,16)
TRCell():New(oSection1,"MARGEMP" 		,"TRB"	,"MARGEM(%)"		 	,"@E 999,999,999.99"	,16)
TRCell():New(oSection1,"STDGERUNI"		,"TRB"	,"STD_GERENCIA_UNIT"	,"@E 999,999,999.99"	,16)
TRCell():New(oSection1,"STDGERTOT" 		,"TRB"	,"STD_GERENCIA_TOT"		,"@E 999,999,999.99"	,16)

TRCell():New(oSection1,"MESREF"  		,"TRB"	,"MES REFERENCIA"		,"@!"					,21) // Incluído em 25/04/2012 por Fabio Sales para trazer o Mes referencia do pedido de venda.
TRCell():New(oSection1,"CTAREC"  		,"TRB"	,"CTA CONT RECEITA"		,"@!"					,10)
TRCell():New(oSection1,"DESCCTREC"		,"TRB"	,"DESC CTA RECEITA"		,"@!"					,25)


// Solicitação Jorge/Compras - novas colunas ao final do relatório
// Mostra mesmo campos ja existentes - mostrar campos do relatorio de cadastro de produtos
TRCell():New(oSection1,"PRODUTO"		,"TRB"	,"COD_PROD"				,"@!"		   			,15)		// ja existentes
TRCell():New(oSection1,"DESCPRO"		,"TRB"	,"DESC_PROD"			,"@!"		  			,30)	    // ja existentes                                                                                      
TRCell():New(oSection1,"SECAO"			,"TRB"	,"SECAO"				,"@!"					,04)		// ja existentes
TRCell():New(oSection1,"DESCSEC"		,"TRB"	,"DESC_SECAO"			,"@!"					,30)		// ja existentes	
TRCell():New(oSection1,"LINHA"			,"TRB"	,"LINHA"				,"@!"					,03)		// ja existentes
TRCell():New(oSection1,"DESC_LINHA"		,"TRB"	,"DESC_LINHA"			,"@!"					,20)	 	// NOME LINHA
TRCell():New(oSection1,"CATEGORIA"		,"TRB"	,"CATEGORIA"			,"@!"					,40)		// NOME DA CATEGORIA
TRCell():New(oSection1,"DESCGRUP"		,"TRB"	,"DESC_CATEGORIA"		,"@!"					,30)		// ja existentes	
TRCell():New(oSection1,"SUBGRUP"		,"TRB"	,"SUB_GRUPO"			,"@!"					,04)		// ja existentes
TRCell():New(oSection1,"DESCSUBG"		,"TRB"	,"DESC_SUBGRUP"			,"@!"					,30)		// ja existentes	
TRCell():New(oSection1,"GRUPO"			,"TRB"	,"CATEGORIA"			,"@!"					,04)		// ja existentes 
TRCell():New(oSection1,"SUBGRUPO"		,"TRB"	,"SUBGRUPO"				,"@!"					,20)		// NOME DO SUBGRUPO
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
TRCell():New(oSection1,"UNI_MED"		,"TRB"	,"UNI_MED"				,"@!"					,02)	
TRCell():New(oSection1,"FATCONV"		,"TRB"	,"FATOR_CONVEÇÃO" 		,"@E 999,999.99"		,18)		// ja existentes
TRCell():New(oSection1,"SEGUNID"		,"TRB"	,"SEGUNDA UNIDADE."		,"@!"					,04)		// ja existentes
TRCell():New(oSection1,"CUBAGEM"		,"TRB"	,"CUBAGEM"				,"@!"	   				,03)		// Cubagem 
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
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport¦ Autor ¦ Fabio Sales    	   ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressão do Relatório        				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokeTake                                        ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                                                                                                                           

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

/*-----------------------------------------------------------------|
| seleção dos dados a serem impressos/carrega o arquivo temporário |
|-----------------------------------------------------------------*/

MsAguarde({|| fSelDados()},"Selecionando Itens")

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

Local clTipo
Local clNome
Local clFinalid
Local clItemc
Local clTabSec1	:= "Z5"
Local clTabSec2	:= "Z4"
Local clTabSec3	:= "21"
Local clTabSec4	:= "Z7"
Local clFilial  := "01"
Local clDescSec1:= Space(30)
Local clDescSec2:= Space(30)
Local clDescLin	:= Space(30)
Local clDescg	:= Space(30)
Local clDescSec3:= Space(30)
Local clDescSec4:= Space(30)
Local clDescCcd := Space(30)
Local clDescPa	:= Space(30)
Local clCstduni := 0
Local clCstdTot := 0
Local nlRecLiq	:= 0
Local clCodvend := "" 
Local clCodSup	:= ""
Local clCodger	:= ""
Local cDescCta	:= ""
Local dDtDigit
Local aRetData	:= {}


/*-------------------------------|
| criação do arquivo de trabalho |
|-------------------------------*/

_aStru	:= {}

AADD(_aStru,{"TIPO"			,"C"	,20	,0})
AADD(_aStru,{"NOTA"			,"C"	,09	,0})
AADD(_aStru,{"SERIE"		,"C"	,03	,0})
AADD(_aStru,{"COD_CLI"		,"C"	,06	,0})
AADD(_aStru,{"CODVEND"		,"C"	,06	,0})
AADD(_aStru,{"VENDED"		,"C"	,40	,0})
AADD(_aStru,{"CLIENTE"		,"C"	,40	,0})
AADD(_aStru,{"ITEM"			,"C"	,04	,0})
AADD(_aStru,{"PRODUTO"		,"C"	,15	,0})		// Cod. Produto
AADD(_aStru,{"DESCPRO"		,"C"	,30	,0})
AADD(_aStru,{"UNI_MED"		,"C"	,02	,0})
AADD(_aStru,{"SUBGRUP"		,"C"	,04	,0})		// Cod. SubGrupo
AADD(_aStru,{"LOCALPD"		,"C"	,06	,0})
AADD(_aStru,{"DESCARM"		,"C"	,30	,0})
AADD(_aStru,{"TES"			,"C"	,03	,0})
AADD(_aStru,{"CFOP"			,"C"	,05	,0})
AADD(_aStru,{"NCM"			,"C"	,10	,0}) 	// Ncm
AADD(_aStru,{"QTDE"			,"N"	,14	,4})
AADD(_aStru,{"PRCVEN"		,"N"	,14	,4})
AADD(_aStru,{"TOTAL"		,"N"	,14	,4})
AADD(_aStru,{"GUPTRIB"		,"C"	,06	,0})
AADD(_aStru,{"ICMS"			,"N"	,14	,4})
AADD(_aStru,{"DESCZFR"		,"N"	,14	,4})
AADD(_aStru,{"ICMS_ST"		,"N"	,14	,4})
AADD(_aStru,{"PISCOFINS"	,"C"	,05	,0})
AADD(_aStru,{"PIS"			,"N"	,14	,4})
AADD(_aStru,{"CONFINS"		,"N"	,14	,4})
AADD(_aStru,{"CM_STD"		,"N"	,16	,6})
AADD(_aStru,{"CM_ATUAL"		,"N"	,16	,6})
AADD(_aStru,{"CM_FECH"		,"N"	,16	,6})
AADD(_aStru,{"CCUSTO"		,"C"	,09	,0})
AADD(_aStru,{"DESCCUSTO"	,"C"	,30	,0})
AADD(_aStru,{"FINALID"		,"C"	,254,0})
AADD(_aStru,{"PR_UNIT"		,"N"	,14	,4})
AADD(_aStru,{"DESCONTO"		,"N"	,14	,4})
AADD(_aStru,{"FRETE"		,"N"	,14	,4})
AADD(_aStru,{"SEGURO"		,"N"	,14	,4})
AADD(_aStru,{"DESPESAS"		,"N"	,14	,4})
AADD(_aStru,{"VALTOT"		,"N"	,14	,4})
AADD(_aStru,{"FILIAL"		,"C"	,02	,0})
AADD(_aStru,{"DESCFIL"		,"C"	,35	,0})
AADD(_aStru,{"ESTADO"		,"C"	,02	,0})
AADD(_aStru,{"CIDADE"		,"C"	,35	,0})
AADD(_aStru,{"EMISSAO"		,"D"	,08	,0})
AADD(_aStru,{"LOJA"			,"C"	,04	,0})
AADD(_aStru,{"ROMAN"		,"C"	,10	,0})
AADD(_aStru,{"TRANSP"		,"C"	,06	,0})
AADD(_aStru,{"PLACA"		,"C"	,08	,0})
AADD(_aStru,{"MOTOR"		,"C"	,40	,2})
AADD(_aStru,{"CHVNFE"		,"C"	,12	,0})
AADD(_aStru,{"GRUPO"		,"C"	,04	,0})		// Cod. da categoria
AADD(_aStru,{"SECAO"		,"C"	,04	,0})		// Seção
AADD(_aStru,{"LINHA"		,"C"	,03	,0})		// Desc. Linha
AADD(_aStru,{"GRUPTRIB"		,"C"	,06	,0})
AADD(_aStru,{"DESCGRTRI"	,"C"	,30	,0})
AADD(_aStru,{"DESCSUBG"		,"C"	,30	,0})
AADD(_aStru,{"DESCSEC"		,"C"	,30	,0})		// Desc. Seção
AADD(_aStru,{"DESCGRUP"		,"C"	,30	,0})
AADD(_aStru,{"DESCLIN"		,"C"	,30	,0})
AADD(_aStru,{"PEDIDO"		,"C"	,06	,0})
AADD(_aStru,{"VALISS"		,"N"	,14	,4})
AADD(_aStru,{"ICMSTRIB"		,"N"	,14	,4})
AADD(_aStru,{"ICMSISEN"		,"N"	,14	,4})
AADD(_aStru,{"ICMSOUTR"		,"N"	,14	,4})
AADD(_aStru, {"FATCONV"		,"N"	,14	,4})
AADD(_aStru, {"TIPCONV"		,"C"	,02	,0})
AADD(_aStru, {"SEGUNID"		,"C"	,06	,0})		// Seg. Unidade Medida
AADD(_aStru, {"QT_UNID_UN"	,"N"	,14	,4})
AADD(_aStru, {"CM_STD_UN"	,"N"	,14	,4})
AADD(_aStru, {"TOTSDESC"	,"N"	,14	,4})
AADD(_aStru, {"XCANAL"		,"C"	,05	,0})
AADD(_aStru, {"DESCCAN"		,"C"	,30	,0})
AADD(_aStru, {"FINALIDA"	,"C"	,20	,0})
AADD(_aStru, {"ITEMC"		,"C"	,21	,0})
AADD(_aStru, {"DCITEMC"		,"C"	,35	,0})
AADD(_aStru, {"SUPERV"		,"C"	,06	,0})
AADD(_aStru, {"GERENT"		,"C"	,06	,0})
AADD(_aStru, {"DESCSUPER"	,"C"	,35	,0})
AADD(_aStru, {"DESCGEREN"	,"C"	,35	,0})
AADD(_aStru, {"RECLIQ"		,"N"	,14	,4})
AADD(_aStru, {"MARGEM" 		,"N"	,14	,4})
AADD(_aStru, {"MARGEMP"		,"N"	,14	,4}) 
AADD(_aStru, {"STDGERUNI"	,"N"	,14	,4})
AADD(_aStru, {"STDGERTOT"	,"N"	,14	,4})
AADD(_aStru, {"MESREF"		,"C"	,06	,0})  		// Incluído em 25/04/2012 para trazer o Mês de referencia do pedido de venda
AADD(_aStru, {"CTAREC"		,"C"	,10	,0})
AADD(_aStru, {"DESCCTREC"	,"C"	,25	,0}) 

// Solicitação Jorge/Compras
AADD(_aStru, {"DESC_SECAO"	,"C"	,20	,0})		// Desc Seção
AADD(_aStru, {"DESC_LINHA"	,"C"	,20	,0}) 		// NOME LINHA
AADD(_aStru, {"CATEGORIA"	,"C"	,40	,0})		// NOME DA CATEGORIA
AADD(_aStru, {"SUBGRUPO"	,"C"	,20	,0})		// NOME DO SUBGRUPO
AADD(_aStru, {"COD_CLUSTE"	,"C"	,02	,0})		// COD CLUSTER
AADD(_aStru, {"CLUSTER"		,"C"	,20	,0})
AADD(_aStru, {"COD_AMPLI"	,"C"	,04	,0})		// COD AMPLITUDE 
AADD(_aStru, {"AMPLITUDE"	,"C"	,25	,0})		// DESC AMPLITUDE
AADD(_aStru, {"COD_TPNEG"	,"C"	,04	,0})		// COD TIPO NEGOCIO
AADD(_aStru, {"TPNEGOCIO"	,"C"	,25	,0})		// DESC TIPO NEGOCIO
AADD(_aStru, {"COD_CONSER"	,"C"	,04	,0})		// COD CONSERVACAO
AADD(_aStru, {"CONSERV"		,"C"	,25	,0})		// DESC CONSERVACAO
AADD(_aStru, {"COD_PREP"	,"C"	,04	,0})		// COD PREPARO
AADD(_aStru, {"PREPARO"		,"C"	,25	,0})		// DESC PREPARO
AADD(_aStru, {"COD_TPMAQ"	,"C"	,04	,0})		// COD TP MAQUINA
AADD(_aStru, {"TPMAQUINA"	,"C"	,25	,0})		// DESC TP MAQUINA
AADD(_aStru, {"COD_MOLA"	,"C"	,04	,0})		// COD MOLA
AADD(_aStru, {"MOLA"		,"C"	,25	,0})		// DESC MOLA
AADD(_aStru, {"BLQ_GERAL"	,"C"	,03	,0})		// BLOQUEIO GERAL DO PRODUTO - Converte de 1 - 2 para Sim - Nao		
AADD(_aStru, {"BLQ_COMPRA"	,"C"	,03	,0})		// BLOQUEIO DO COMPRAS - Converte de T - F para Sim - Nao		
AADD(_aStru, {"CUBAGEM"		,"C"	,03	,0})		// CUBAGEM DO PRODUTO 
AADD(_aStru, {"COMPRIMENT"	,"N"	,09	,3})		// COMPRIMENTO 
AADD(_aStru, {"ESPESSURA"	,"N"	,09	,3})		// ESPESSURA
AADD(_aStru, {"LARGURA"		,"N"	,09	,3})		// LARGURA 
AADD(_aStru, {"EAN"			,"C"	,15	,0})		// CODIGO DE BARRAS
AADD(_aStru, {"DT_DIA"		,"C"	,02	,0})		// DATA DIA	
AADD(_aStru, {"DT_MESANO"	,"C"	,08	,0})		// DATA MES/ANO	
AADD(_aStru, {"DT_ANO"		,"C"	,04	,0})		// DATA ANO	
AADD(_aStru, {"DT_TRIM"		,"C"	,06	,0})		// DATA TRIMESTRE
	


_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,"CLIENTE",,,"Selecionando Registros...")

/*---------------------------------------------------------------|
| Montagem com os dados das notas fiscais de vendas e devoluções |
|---------------------------------------------------------------*/
If cEmpAnt $ "01#02"
	_cQuery := " SELECT "
	_cQuery += " CASE WHEN SF2.F2_XFINAL = '@' THEN SF2.F2_XFINAL ELSE SD2.D2_TIPO END AS TIPO , 
	_cQuery += " SD2.D2_CLIENTE, "
	_cQuery += " SD2.D2_DOC, "
	_cQuery += " SD2.D2_SERIE, "
	_cQuery += " SD2.D2_CF, "
	_cQuery += " SD2.D2_TES, "
	_cQuery += " SD2.D2_CCUSTO, "
	_cQuery += " SF2.F2_VEND1, "
	_cQuery += " SF2.F2_XFINAL AS FINALIDADE, "
	_cQuery += " SA3.A3_NOME, "
	_cQuery += " A3_SUPER AS SUPER, "
	_cQuery += " A3_GEREN AS GERENT, "
	_cQuery += " SF4.F4_TEXTO, "
	_cQuery += " SF4.F4_FINALID, "
	_cQuery += " SD2.D2_GRUPO, "
	_cQuery += " SD2.D2_ITEM, "
	_cQuery += " SD2.D2_COD, "
	_cQuery += " SD2.D2_PRCVEN, "
	_cQuery += " SB1.B1_CUSTD, "
	_cQuery += " SB1.B1_XPISCOF AS XPISCOF, "
	_cQuery += " SF2.F2_XCARGA AS ROMAN, "
	_cQuery += " SF2.F2_CHVNFE AS CHAVENFE, "
	_cQuery += " SB1.B1_TIPCONV, "
	_cQuery += " SB1.B1_CONV, "
	_cQuery += " SB1.B1_SEGUM, "
	_cQuery += " 'QUNICPROD' = CASE WHEN SB1.B1_TIPCONV = 'M' THEN (SD2.D2_QUANT * SB1.B1_CONV) ELSE 0 END, "
	_cQuery += " SF2.F2_TRANSP AS TRANSP, "
	_cQuery += " SF2.F2_XPLACA AS PLACA, "
	_cQuery += " SF2.F2_XMOTOR AS MOTORISTA, "
	_cQuery += " SB1.B1_GRUPO, "
	_cQuery += " SB1.B1_XSECAO AS XSECAO, "
	_cQuery += " SB1.B1_XFAMILI AS XFAMILI, "
	_cQuery += " SB1.B1_LOCPAD, "
	_cQuery += " SD2.D2_LOCAL, "
	_cQuery += " SB1.B1_DESC, "
	_cQuery += " SB1.B1_UM, "
	_cQuery += " SB1.B1_XSUBGRU AS XSBGRP, "
	_cQuery += " SB1.B1_GRTRIB, "
	_cQuery += " SB1.B1_POSIPI, "
	
	// Novos campos adicionados -- Solicitação de Jorge Compras
	_cQuery += " SB1.B1_XSECAOT AS DESC_SECAO, "		// DESC SECAO 			
	_cQuery += " SB1.B1_XFAMLIT AS DESC_LINHA, "		// DESC LINHA 			
	_cQuery += " SB1.B1_XGRUPOT AS CATEGORIA, "			// DESC CATEGORIA		
	_cQuery += " SB1.B1_XSUBGRT AS SUBGRUPO, "			// DESC SUBGRUPO 		
	_cQuery += " SB1.B1_XCLUST AS COD_CLUSTE, "			// COD CLUSTER 
	_cQuery += " SB1.B1_XCLUSTD AS CLUSTER, " 			// DESC CLUSTER		
	_cQuery += " SB1.B1_XAMPLI AS COD_AMPLI, "			// COD AMPLITUDE 
	_cQuery += " SB1.B1_XDSAMPL AS AMPLITUDE, "			// DESC AMPLITUDE
	_cQuery += " SB1.B1_XTNEGO AS COD_TPNEG, "			// COD TIPO NEGOCIO
	_cQuery += " SB1.B1_XTNEGOT AS TPNEGOCIO, "			// DESC TIPO NEGOCIO
	_cQuery += " SB1.B1_XCONSER AS COD_CONSER, "		// COD CONSERVACAO
	_cQuery += " SB1.B1_XDSCONS AS CONSERV, "			// DESC CONSERVACAO
	_cQuery += " SB1.B1_XPREPAR AS COD_PREP, "			// COD PREPARO
	_cQuery += " SB1.B1_XDSPREP AS PREPARO, "			// DESC PREPARO
	_cQuery += " SB1.B1_XTPMAQ AS COD_TPMAQ, "			// COD TP MAQUINA
	_cQuery += " SB1.B1_XDSTPMA AS TPMAQUINA, "			// DESC TP MAQUINA
	_cQuery += " SB1.B1_XMOLA AS COD_MOLA, "			// COD MOLA
	_cQuery += " SB1.B1_XDSMOLA AS MOLA, "				// DESC MOLA
	
	_cQuery += " CASE SB1.B1_MSBLQL "					// BLOQUEIO GERAL				
	_cQuery += "	WHEN '1' "					
	_cQuery += "		THEN 'SIM' "			
	_cQuery += "	ELSE 'NAO' "				
	_cQuery += " END AS BLQ_GERAL, "				
	
	_cQuery += " CASE SB1.B1_XBLQCOM "					// BLOQUEIO COMPRAS				
	_cQuery += "	WHEN 'T' "					
	_cQuery += "		THEN 'SIM' "			
	_cQuery += "	ELSE 'NAO' "				
	_cQuery += " END AS BLQ_COMPRA, "			
	
	_cQuery += " CASE SB1.B1_XCBGEM "					// CUBAGEM				
	_cQuery += "	WHEN 'T' "					
	_cQuery += "		THEN 'SIM' "			
	_cQuery += " 	ELSE 'NAO' "				
	_cQuery += " END AS CUBAGEM, "				
	
	_cQuery += " SB1.B1_CODBAR AS EAN, "
	_cQuery += " SB5.B5_COMPR AS COMPRIMENT, "	   		//	COMPRIMENTO
	_cQuery += " SB5.B5_ESPESS AS ESPESSURA, "	   		//	ESPESSURA
	_cQuery += " SB5.B5_LARG AS LARGURA, "		   		//	LARGURA 				
	// Fim dos campos adicionados
	
	
	_cQuery += " SD2.D2_TOTAL AS TOTAL, "
	_cQuery += " SD2.D2_QUANT, "
	_cQuery += " SD2.D2_VALICM, "
	_cQuery += " SD2.D2_ICMSRET, "
	_cQuery += " SD2.D2_DESCZFR, "
	_cQuery += " SD2.D2_VALIMP5, "
	_cQuery += " SD2.D2_VALIMP6, "
	_cQuery += " SD2.D2_PRUNIT, "
	_cQuery += " SD2.D2_DESCON, "
	_cQuery += " SD2.D2_EST, "
	_cQuery += " SD2.D2_VALFRE, "
	_cQuery += " SD2.D2_SEGURO, "
	_cQuery += " TOTALSDES = CASE WHEN SD2.D2_DESCON<>0 THEN (D2_QUANT * (D2_PRCVEN + (D2_DESCON/D2_QUANT))) ELSE D2_TOTAL END, "
	_cQuery += " SD2.D2_DESPESA, "
	_cQuery += " SD2.D2_EMISSAO, "
	_cQuery += " SD2.D2_FILIAL, "
	_cQuery += " SA1.A1_NOME, "
	_cQuery += " SA1.A1_LOJA, "
	_cQuery += " SA1.A1_MUN, "
	_cQuery += " SA1.A1_XCANAL AS XCANAL, "
	_cQuery += " SD2.D2_ITEMCC, "
	_cQuery += " (SD2.D2_TOTAL + SD2.D2_SEGURO + SD2.D2_VALFRE + SD2.D2_DESPESA) AS VALTOT, "
	_cQuery += " SD2.D2_PEDIDO AS PEDIDO, "
	_cQuery += " SD2.D2_VALISS AS VALISS, "
	_cQuery += " SFT.FT_VALICM AS VALICMTRIB, "
	_cQuery += " SFT.FT_ISENICM AS ISENICM, "
	_cQuery += " SFT.FT_OUTRICM AS OUTRICM, "
	_cQuery += " '' AS NFORI, "
	_cQuery += " '' AS SERIORI, "
	_cQuery += " SB1.B1_XREC AS CONTAREC "
	
	_cQuery += " FROM "+RetSQLName("SD2")+" AS SD2 "
	
	_cQuery += " INNER JOIN "
	If cEmpAnt=='02'
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON "
		_cQuery += " SD2.D2_FILIAL = SA1.A1_FILIAL AND "
		_cQuery += " SD2.D2_CLIENTE = SA1.A1_COD AND "
		_cQuery += " SD2.D2_LOJA = SA1.A1_LOJA "
	Else
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON "
		_cQuery += " SD2.D2_CLIENTE = SA1.A1_COD AND "
		_cQuery += " SD2.D2_LOJA = SA1.A1_LOJA "
	EndIf
	
	_cQuery += " INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	_cQuery += " SD2.D2_COD = SB1.B1_COD "
	
	/*------------------------------------------+ 
	|Junção com tabela de complementos - SB5	|
	+-------------------------------------------*/
	
	_cQuery += "LEFT JOIN "+RetSQLName("SB5")+" AS SB5  "
	_cQuery += "ON SD2.D2_COD = SB5.B5_COD AND "
	_cQuery += "SD2.D_E_L_E_T_ = SB5.D_E_L_E_T_ "	
	    
	
	_cQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
	_cQuery += " SD2.D2_TES = SF4.F4_CODIGO AND "
	_cQuery += " SD2.D2_FILIAL = SF4.F4_FILIAL "
	
	_cQuery += " INNER JOIN "+RetSQLName("SF2")+" AS SF2 ON "
	_cQuery += " SD2.D2_DOC = SF2.F2_DOC AND "
	_cQuery += " SD2.D2_SERIE = SF2.F2_SERIE AND "
	_cQuery += " SD2.D_E_L_E_T_ = SF2.D_E_L_E_T_  AND "
	_cQuery	+= " SD2.D2_CLIENTE	= SF2.F2_CLIENTE AND "
	_cQuery	+= " SD2.D2_LOJA = SF2.F2_LOJA AND "
	_cQuery	+= " SD2.D2_EMISSAO	= SF2.F2_EMISSAO AND"
	_cQuery += " SD2.D2_FILIAL 	= SF2.F2_FILIAL "
	
	_cQuery += " LEFT JOIN "+RetSQLName("SA3")+" AS SA3 ON "
	_cQuery += " SF2.F2_VEND1 = SA3.A3_COD "
	
	_cQuery += " LEFT OUTER JOIN "+RetSQLName("SFT")+" AS SFT ON "
	_cQuery += " SD2.D2_FILIAL = SFT.FT_FILIAL AND "
	_cQuery += " SD2.D2_DOC = SFT.FT_NFISCAL AND "
	_cQuery += " SD2.D2_SERIE = SFT.FT_SERIE AND "
	_cQuery += " SD2.D2_EMISSAO = SFT.FT_EMISSAO AND "
	_cQuery += " SD2.D2_CLIENTE = SFT.FT_CLIEFOR AND "
	_cQuery += " SD2.D2_LOJA = SFT.FT_LOJA AND"
	_cQuery += " SD2.D2_COD = SFT.FT_PRODUTO AND "
	_cQuery += " SD2.D2_ITEM = SFT.FT_ITEM AND "
	_cQuery += " SFT.FT_TIPOMOV = 'S' AND "
	_cQuery += " FT_CODISS = '' AND "
	_cQuery += " SFT.D_E_L_E_T_ <> '*' "
	
	_cQuery += " WHERE "
	_cQuery += " (SD2.D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"') AND "
	_cQuery += " (SD2.D2_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	_cQuery += " (SD2.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
	_cQuery += " (SD2.D2_DOC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND "
	_cQuery += " (SD2.D2_CCUSTO BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
	_cQuery += " (SD2.D2_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND "
	_cQuery += " (SD2.D2_TIPO IN( 'N','C')) AND " 
	_cQuery += " (SF4.F4_DUPLIC = 'S' ) AND "
	_cQuery += " SD2.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SF2.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SA1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SF4.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SB1.D_E_L_E_T_ <> '*' "
	
	_cQuery += " UNION ALL " // Sintaxe ultilizada para unir um ou mais Selects desde que eles tenha a mesma estrutura de campos
	
	_cQuery += " SELECT "
	_cQuery += " SD1.D1_TIPO AS TIPO, "
	_cQuery += " SD1.D1_FORNECE, "
	_cQuery += " SD1.D1_DOC, "
	_cQuery += " SD1.D1_SERIE, "
	_cQuery += " SD1.D1_CF, "
	_cQuery += " SD1.D1_TES, "
	_cQuery += " SD1.D1_CC AS CCUSTO, "
	_cQuery += " '' AS VEND1, "
	_cQuery += " '' AS FINALIDADE, "
	_cQuery += " ''AS A3_NOME, "
	_cQuery += " '' AS SUPER, "
	_cQuery += " '' AS GERENT, "
	_cQuery += " SF4.F4_TEXTO, "
	_cQuery += " SF4.F4_FINALID, "
	_cQuery += " SD1.D1_GRUPO, "
	_cQuery += " SD1.D1_ITEM, "
	_cQuery += " SD1.D1_COD, "
	_cQuery += "  -SD1.D1_VUNIT, "
	_cQuery += "  -SB1.B1_CUSTD, "
	_cQuery += " SB1.B1_XPISCOF AS XPISCOF, "
	_cQuery += " '' AS ROMAN, "
	_cQuery += " '' AS CHAVENFE, "
	_cQuery += " SB1.B1_TIPCONV, "
	_cQuery += " SB1.B1_CONV, "
	_cQuery += " SB1.B1_SEGUM, "
	_cQuery += " 'QUNICPROD' = CASE WHEN SB1.B1_TIPCONV = 'M' THEN (SD1.D1_QUANT * SB1.B1_CONV) ELSE 0 END, "
	_cQuery += " '' AS TRANSP, "
	_cQuery += " '' AS PLACA, "
	_cQuery += " '' AS MOTORISTA, "
	_cQuery += " SB1.B1_GRUPO, "
	_cQuery += " SB1.B1_XSECAO AS XSECAO, "
	_cQuery += " SB1.B1_XFAMILI AS XFAMILI, "
	_cQuery += " SB1.B1_LOCPAD, "
	_cQuery += " SD1.D1_LOCAL, "
	_cQuery += " SB1.B1_DESC, "
	_cQuery += " SB1.B1_UM, "
	_cQuery += " SB1.B1_XSUBGRU AS SBGRP, "
	_cQuery += " SB1.B1_GRTRIB, "
	_cQuery += " SB1.B1_POSIPI, "
	
	// Novos campos adicionados -- Solicitação de Jorge Compras
	_cQuery += " SB1.B1_XSECAOT AS DESC_SECAO, "		// DESC SECAO 			
	_cQuery += " SB1.B1_XFAMLIT AS DESC_LINHA, "		// DESC LINHA 			
	_cQuery += " SB1.B1_XGRUPOT AS CATEGORIA, "			// DESC CATEGORIA		
	_cQuery += " SB1.B1_XSUBGRT AS SUBGRUPO, "			// DESC SUBGRUPO 		
	_cQuery += " SB1.B1_XCLUST AS COD_CLUSTE, "			// COD CLUSTER 
	_cQuery += " SB1.B1_XCLUSTD AS CLUSTER, " 			// DESC CLUSTER		
	_cQuery += " SB1.B1_XAMPLI AS COD_AMPLI, "			// COD AMPLITUDE 
	_cQuery += " SB1.B1_XDSAMPL AS AMPLITUDE, "			// DESC AMPLITUDE
	_cQuery += " SB1.B1_XTNEGO AS COD_TPNEG, "			// COD TIPO NEGOCIO
	_cQuery += " SB1.B1_XTNEGOT AS TPNEGOCIO, "			// DESC TIPO NEGOCIO
	_cQuery += " SB1.B1_XCONSER AS COD_CONSER, "		// COD CONSERVACAO
	_cQuery += " SB1.B1_XDSCONS AS CONSERV, "			// DESC CONSERVACAO
	_cQuery += " SB1.B1_XPREPAR AS COD_PREP, "			// COD PREPARO
	_cQuery += " SB1.B1_XDSPREP AS PREPARO, "			// DESC PREPARO
	_cQuery += " SB1.B1_XTPMAQ AS COD_TPMAQ, "			// COD TP MAQUINA
	_cQuery += " SB1.B1_XDSTPMA AS TPMAQUINA, "			// DESC TP MAQUINA
	_cQuery += " SB1.B1_XMOLA AS COD_MOLA, "			// COD MOLA
	_cQuery += " SB1.B1_XDSMOLA AS MOLA, "				// DESC MOLA
	
	_cQuery += " CASE SB1.B1_MSBLQL "					// BLOQUEIO GERAL				
	_cQuery += "	WHEN '1' "					
	_cQuery += "		THEN 'SIM' "			
	_cQuery += "	ELSE 'NAO' "				
	_cQuery += " END AS BLQ_GERAL, "				
	
	_cQuery += " CASE SB1.B1_XBLQCOM "					// BLOQUEIO COMPRAS				
	_cQuery += "	WHEN 'T' "					
	_cQuery += "		THEN 'SIM' "			
	_cQuery += "	ELSE 'NAO' "				
	_cQuery += " END AS BLQ_COMPRA, "			
	
	_cQuery += " CASE SB1.B1_XCBGEM "					// CUBAGEM				
	_cQuery += "	WHEN 'T' "					
	_cQuery += "		THEN 'SIM' "			
	_cQuery += " 	ELSE 'NAO' "				
	_cQuery += " END AS CUBAGEM, "				
	
	_cQuery += " SB1.B1_CODBAR AS EAN, "
	_cQuery += " SB5.B5_COMPR AS COMPRIMENT, "	   		//	COMPRIMENTO
	_cQuery += " SB5.B5_ESPESS AS ESPESSURA, "	   		//	ESPESSURA
	_cQuery += " SB5.B5_LARG AS LARGURA, "		   		//	LARGURA 				
	// Fim dos campos adicionados
	
	
	_cQuery += " -(SD1.D1_TOTAL - SD1.D1_VALDESC) AS TOTAL, "
	_cQuery += "  -SD1.D1_QUANT, "
	_cQuery += " -SD1.D1_VALICM, "
	_cQuery += " -D1_ICMSRET, "
	_cQuery += " ' 'DESCZFR, "
	_cQuery += "  -SD1.D1_VALIMP5, "
	_cQuery += " -SD1.D1_VALIMP6, "
	_cQuery += " -SD1.D1_VUNIT, "
	_cQuery += " -SD1.D1_VALDESC, "
	_cQuery += " SA1.A1_EST, "
	_cQuery += " -SD1.D1_VALFRE, "
	_cQuery += " -SD1.D1_SEGURO, "
	_cQuery += " -SD1.D1_TOTAL AS  TOTALSDES, "
	_cQuery += " -SD1.D1_DESPESA, "
	_cQuery += " SD1.D1_DTDIGIT, "
	_cQuery += " SD1.D1_FILIAL, "
	_cQuery += " SA1.A1_NOME, "
	_cQuery += " SA1.A1_LOJA, "
	_cQuery += " SA1.A1_MUN, "
	_cQuery += " SA1.A1_XCANAL AS XCANAL, "
	_cQuery += " SD1.D1_ITEMCTA, "
	_cQuery += " -((SD1.D1_TOTAL + SD1.D1_SEGURO + SD1.D1_VALFRE + SD1.D1_DESPESA)- D1_VALDESC) AS VALTOT, "
	_cQuery += " SD1.D1_PEDIDO AS PEDIDO, "
	_cQuery += " -SD1.D1_VALISS AS VALISS, "
	_cQuery += " -SFT.FT_VALICM AS VALICMTRIB, "
	_cQuery += " -SFT.FT_ISENICM AS ISENICM, "
	_cQuery += " -SFT.FT_OUTRICM AS OUTRICM, "
	_cQuery += " SD1.D1_NFORI AS NFORI, "
	_cQuery += " SD1.D1_SERIORI AS SERIORI, "
	_cQuery += " SB1.B1_XDEV AS CONTAREC "
	
	_cQuery += " FROM "+RetSQLName("SD1")+" AS SD1 "
	
	_cQuery += " INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	_cQuery += " SD1.D1_COD = SB1.B1_COD "
	
	/*------------------------------------------+ 
	|Junção com tabela de complementos - SB5	|
	+-------------------------------------------*/
	_cQuery += "LEFT JOIN "+RetSQLName("SB5")+" AS SB5  "
	_cQuery += "ON SD1.D1_COD = SB5.B5_COD AND "
	_cQuery += "SD1.D_E_L_E_T_ = SB5.D_E_L_E_T_ "
	
	
	_cQuery += " INNER JOIN "
	If cEmpAnt =='02'
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON "
		_cQuery += " SD1.D1_FILIAL = SA1.A1_FILIAL AND "
		_cQuery += " SD1.D1_FORNECE = SA1.A1_COD AND "
		_cQuery += " SD1.D1_LOJA = SA1.A1_LOJA "
	Else
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON "
		_cQuery += " SD1.D1_FORNECE = SA1.A1_COD AND "
		_cQuery += " SD1.D1_LOJA = SA1.A1_LOJA "
	EndIf
	
	_cQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
	_cQuery += " SD1.D1_TES = SF4.F4_CODIGO AND "
	_cQuery += " SD1.D1_FILIAL = SF4.F4_FILIAL "
	
	_cQuery += " INNER JOIN "+RetSQLName("SF1")+" AS SF1 ON "
	_cQuery += " SD1.D1_DOC = SF1.F1_DOC AND "
	_cQuery += " SD1.D1_SERIE = SF1.F1_SERIE AND "
	_cQuery += " SD1.D_E_L_E_T_ = SF1.D_E_L_E_T_ AND "
	_cQuery += " SD1.D1_FILIAL = SF1.F1_FILIAL AND "
	_cQuery += " SD1.D1_FORNECE = SF1.F1_FORNECE AND "
	_cQuery += " SD1.D1_LOJA = SF1.F1_LOJA AND "
	_cQuery += " SD1.D1_EMISSAO = SF1.F1_EMISSAO  "
	
	_cQuery += " LEFT JOIN "+RetSQLName("SFT")+" AS SFT ON "
	_cQuery += " SD1.D1_FILIAL = SFT.FT_FILIAL AND "
	_cQuery += " SD1.D1_DOC = SFT.FT_NFISCAL AND "
	_cQuery += " SD1.D1_SERIE = SFT.FT_SERIE AND "
	_cQuery += " SD1.D1_DTDIGIT = SFT.FT_ENTRADA AND "
	_cQuery += " SD1.D1_FORNECE = SFT.FT_CLIEFOR AND "
	_cQuery += " SD1.D1_LOJA = SFT.FT_LOJA AND "
	_cQuery += " SD1.D1_COD = SFT.FT_PRODUTO AND "
	_cQuery += " SD1.D1_ITEM = SFT.FT_ITEM AND "
	_cQuery += " SFT.FT_TIPOMOV = 'E' AND "
	_cQuery += " FT_CODISS = '' AND "
	_cQuery += " SFT.D_E_L_E_T_ <> '*' "
	
	_cQuery += " WHERE "
	_cQuery += " (SD1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"') AND "
	_cQuery += " (SD1.D1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	_cQuery += " (SD1.D1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
	_cQuery += " (SD1.D1_DOC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND "
	_cQuery += " (SD1.D1_CC BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
	_cQuery += " (SD1.D1_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND "
	_cQuery += " (SD1.D1_TIPO IN('C','D')) AND "
	_cQuery += " (SF4.F4_DUPLIC = 'S' ) AND "
	_cQuery += " D1_TES NOT IN('258','230','229') AND "
	_cQuery += " SD1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SF1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SB1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SA1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SF4.D_E_L_E_T_ <> '*' "

// AMC
ElseIf cEmpAnt == "10"

	_cQuery := " SELECT "
	_cQuery += " SD2.D2_TIPO AS TIPO , 
	_cQuery += " SD2.D2_CLIENTE, "
	_cQuery += " SD2.D2_DOC, "
	_cQuery += " SD2.D2_SERIE, "
	_cQuery += " SD2.D2_CF, "
	_cQuery += " SD2.D2_TES, "
	_cQuery += " SD2.D2_CCUSTO, "
	_cQuery += " SF2.F2_VEND1, "
	_cQuery += " '' AS FINALIDADE, "
	_cQuery += " SA3.A3_NOME, "
	_cQuery += " A3_SUPER AS SUPER, "
	_cQuery += " A3_GEREN AS GERENT, "
	_cQuery += " SF4.F4_TEXTO, "
	_cQuery += " SF4.F4_FINALID, "
	_cQuery += " SD2.D2_GRUPO, "
	_cQuery += " SD2.D2_ITEM, "
	_cQuery += " SD2.D2_COD, "
	_cQuery += " SD2.D2_PRCVEN, "
	_cQuery += " SB1.B1_CUSTD, "
	_cQuery += " '' AS XPISCOF, "
	_cQuery += " '' AS ROMAN, "
	_cQuery += " SF2.F2_CHVNFE AS CHAVENFE, "
	_cQuery += " SB1.B1_TIPCONV, "
	_cQuery += " SB1.B1_CONV, "
	_cQuery += " SB1.B1_SEGUM, "
	_cQuery += " 'QUNICPROD' = CASE WHEN SB1.B1_TIPCONV = 'M' THEN (SD2.D2_QUANT * SB1.B1_CONV) ELSE 0 END, "
	_cQuery += " SF2.F2_TRANSP AS TRANSP, "
	_cQuery += " '' AS PLACA, "
	_cQuery += " '' AS MOTORISTA, "
	_cQuery += " SB1.B1_GRUPO, "
	_cQuery += " '' AS XSECAO, "
	_cQuery += " '' AS XFAMILI, "
	_cQuery += " SB1.B1_LOCPAD, "
	_cQuery += " SD2.D2_LOCAL, "
	_cQuery += " SB1.B1_DESC, "
	_cQuery += " SB1.B1_UM, "
	_cQuery += " '' AS XSBGRP, "
	_cQuery += " SB1.B1_GRTRIB, "
	_cQuery += " SB1.B1_POSIPI, "
	
	_cQuery += " '' AS DESC_SECAO, "		// DESC SECAO 			
	_cQuery += " '' AS DESC_LINHA, "		// DESC LINHA 			
	_cQuery += " '' AS CATEGORIA, "			// DESC CATEGORIA		
	_cQuery += " '' AS SUBGRUPO, "			// DESC SUBGRUPO 		
	_cQuery += " '' AS COD_CLUSTE, "			// COD CLUSTER 
	_cQuery += " '' AS CLUSTER, " 			// DESC CLUSTER		
	_cQuery += " '' AS COD_AMPLI, "			// COD AMPLITUDE 
	_cQuery += " '' AS AMPLITUDE, "			// DESC AMPLITUDE
	_cQuery += " '' AS COD_TPNEG, "			// COD TIPO NEGOCIO
	_cQuery += " '' AS TPNEGOCIO, "			// DESC TIPO NEGOCIO
	_cQuery += " '' AS COD_CONSER, "		// COD CONSERVACAO
	_cQuery += " '' AS CONSERV, "			// DESC CONSERVACAO
	_cQuery += " '' AS COD_PREP, "			// COD PREPARO
	_cQuery += " '' AS PREPARO, "			// DESC PREPARO
	_cQuery += " '' AS COD_TPMAQ, "			// COD TP MAQUINA
	_cQuery += " '' AS TPMAQUINA, "			// DESC TP MAQUINA
	_cQuery += " '' AS COD_MOLA, "			// COD MOLA
	_cQuery += " '' AS MOLA, "				// DESC MOLA
	
			
	_cQuery += " '' AS BLQ_GERAL, "				
	
	_cQuery += " '' AS BLQ_COMPRA, "			
				
	_cQuery += " '' AS CUBAGEM, "				
	
	_cQuery += " SB1.B1_CODBAR AS EAN, "
	_cQuery += " SB5.B5_COMPR AS COMPRIMENT, "	   		//	COMPRIMENTO
	_cQuery += " SB5.B5_ESPESS AS ESPESSURA, "	   		//	ESPESSURA
	_cQuery += " SB5.B5_LARG AS LARGURA, "		   		//	LARGURA 				
	// Fim dos campos adicionados
	
	
	_cQuery += " SD2.D2_TOTAL AS TOTAL, "
	_cQuery += " SD2.D2_QUANT, "
	_cQuery += " SD2.D2_VALICM, "
	_cQuery += " SD2.D2_ICMSRET, "
	_cQuery += " SD2.D2_DESCZFR, "
	_cQuery += " SD2.D2_VALIMP5, "
	_cQuery += " SD2.D2_VALIMP6, "
	_cQuery += " SD2.D2_PRUNIT, "
	_cQuery += " SD2.D2_DESCON, "
	_cQuery += " SD2.D2_EST, "
	_cQuery += " SD2.D2_VALFRE, "
	_cQuery += " SD2.D2_SEGURO, "
	_cQuery += " TOTALSDES = CASE WHEN SD2.D2_DESCON<>0 THEN (D2_QUANT * (D2_PRCVEN + (D2_DESCON/D2_QUANT))) ELSE D2_TOTAL END, "
	_cQuery += " SD2.D2_DESPESA, "
	_cQuery += " SD2.D2_EMISSAO, "
	_cQuery += " SD2.D2_FILIAL, "
	_cQuery += " SA1.A1_NOME, "
	_cQuery += " SA1.A1_LOJA, "
	_cQuery += " SA1.A1_MUN, "
	_cQuery += " '' AS XCANAL, "
	_cQuery += " SD2.D2_ITEMCC, "
	_cQuery += " (SD2.D2_TOTAL + SD2.D2_SEGURO + SD2.D2_VALFRE + SD2.D2_DESPESA) AS VALTOT, "
	_cQuery += " SD2.D2_PEDIDO AS PEDIDO, "
	_cQuery += " SD2.D2_VALISS AS VALISS, "
	_cQuery += " SFT.FT_VALICM AS VALICMTRIB, "
	_cQuery += " SFT.FT_ISENICM AS ISENICM, "
	_cQuery += " SFT.FT_OUTRICM AS OUTRICM, "
	_cQuery += " '' AS NFORI, "
	_cQuery += " '' AS SERIORI, "
	_cQuery += " '' AS CONTAREC "
	
	_cQuery += " FROM "+RetSQLName("SD2")+" AS SD2 "
	
	_cQuery += " INNER JOIN "
	If cEmpAnt=='02'
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON "
		_cQuery += " SD2.D2_FILIAL = SA1.A1_FILIAL AND "
		_cQuery += " SD2.D2_CLIENTE = SA1.A1_COD AND "
		_cQuery += " SD2.D2_LOJA = SA1.A1_LOJA "
	Else
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON "
		_cQuery += " SD2.D2_CLIENTE = SA1.A1_COD AND "
		_cQuery += " SD2.D2_LOJA = SA1.A1_LOJA "
	EndIf
	
	_cQuery += " INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	_cQuery += " SD2.D2_COD = SB1.B1_COD "
	
	/*------------------------------------------+ 
	|Junção com tabela de complementos - SB5	|
	+-------------------------------------------*/
	
	_cQuery += "LEFT JOIN "+RetSQLName("SB5")+" AS SB5  "
	_cQuery += "ON SD2.D2_COD = SB5.B5_COD AND "
	_cQuery += "SD2.D_E_L_E_T_ = SB5.D_E_L_E_T_ "	
	    
	
	_cQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
	_cQuery += " SD2.D2_TES = SF4.F4_CODIGO AND "
	_cQuery += " SD2.D2_FILIAL = SF4.F4_FILIAL "
	
	_cQuery += " INNER JOIN "+RetSQLName("SF2")+" AS SF2 ON "
	_cQuery += " SD2.D2_DOC = SF2.F2_DOC AND "
	_cQuery += " SD2.D2_SERIE = SF2.F2_SERIE AND "
	_cQuery += " SD2.D_E_L_E_T_ = SF2.D_E_L_E_T_  AND "
	_cQuery	+= " SD2.D2_CLIENTE	= SF2.F2_CLIENTE AND "
	_cQuery	+= " SD2.D2_LOJA = SF2.F2_LOJA AND "
	_cQuery	+= " SD2.D2_EMISSAO	= SF2.F2_EMISSAO AND"
	_cQuery += " SD2.D2_FILIAL 	= SF2.F2_FILIAL "
	
	_cQuery += " LEFT JOIN "+RetSQLName("SA3")+" AS SA3 ON "
	_cQuery += " SF2.F2_VEND1 = SA3.A3_COD "
	
	_cQuery += " LEFT OUTER JOIN "+RetSQLName("SFT")+" AS SFT ON "
	_cQuery += " SD2.D2_FILIAL = SFT.FT_FILIAL AND "
	_cQuery += " SD2.D2_DOC = SFT.FT_NFISCAL AND "
	_cQuery += " SD2.D2_SERIE = SFT.FT_SERIE AND "
	_cQuery += " SD2.D2_EMISSAO = SFT.FT_EMISSAO AND "
	_cQuery += " SD2.D2_CLIENTE = SFT.FT_CLIEFOR AND "
	_cQuery += " SD2.D2_LOJA = SFT.FT_LOJA AND"
	_cQuery += " SD2.D2_COD = SFT.FT_PRODUTO AND "
	_cQuery += " SD2.D2_ITEM = SFT.FT_ITEM AND "
	_cQuery += " SFT.FT_TIPOMOV = 'S' AND "
	_cQuery += " FT_CODISS = '' AND "
	_cQuery += " SFT.D_E_L_E_T_ <> '*' "
	
	_cQuery += " WHERE "
	_cQuery += " (SD2.D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"') AND "
	_cQuery += " (SD2.D2_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	_cQuery += " (SD2.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
	_cQuery += " (SD2.D2_DOC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND "
	_cQuery += " (SD2.D2_CCUSTO BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
	_cQuery += " (SD2.D2_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND "
	_cQuery += " (SD2.D2_TIPO IN( 'N','C')) AND " 
	_cQuery += " ( SF4.F4_DUPLIC = 'S' ) AND "
	_cQuery += " SD2.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SF2.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SA1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SF4.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SB1.D_E_L_E_T_ <> '*' "
	
	_cQuery += " UNION ALL " // Sintaxe ultilizada para unir um ou mais Selects desde que eles tenha a mesma estrutura de campos
	
	_cQuery += " SELECT "
	_cQuery += " SD1.D1_TIPO AS TIPO, "
	_cQuery += " SD1.D1_FORNECE, "
	_cQuery += " SD1.D1_DOC, "
	_cQuery += " SD1.D1_SERIE, "
	_cQuery += " SD1.D1_CF, "
	_cQuery += " SD1.D1_TES, "
	_cQuery += " SD1.D1_CC AS CCUSTO, "
	_cQuery += " '' AS VEND1, "
	_cQuery += " '' AS FINALIDADE, "
	_cQuery += " ''AS A3_NOME, "
	_cQuery += " '' AS SUPER, "
	_cQuery += " '' AS GERENT, "
	_cQuery += " SF4.F4_TEXTO, "
	_cQuery += " SF4.F4_FINALID, "
	_cQuery += " SD1.D1_GRUPO, "
	_cQuery += " SD1.D1_ITEM, "
	_cQuery += " SD1.D1_COD, "
	_cQuery += "  -SD1.D1_VUNIT, "
	_cQuery += "  -SB1.B1_CUSTD, "
	_cQuery += " '' AS XPISCOF, "
	_cQuery += " '' AS ROMAN, "
	_cQuery += " '' AS CHAVENFE, "
	_cQuery += " SB1.B1_TIPCONV, "
	_cQuery += " SB1.B1_CONV, "
	_cQuery += " SB1.B1_SEGUM, "
	_cQuery += " 'QUNICPROD' = CASE WHEN SB1.B1_TIPCONV = 'M' THEN (SD1.D1_QUANT * SB1.B1_CONV) ELSE 0 END, "
	_cQuery += " '' AS TRANSP, "
	_cQuery += " '' AS PLACA, "
	_cQuery += " '' AS MOTORISTA, "
	_cQuery += " SB1.B1_GRUPO, "
	_cQuery += " '' AS XSECAO, "
	_cQuery += " '' AS XFAMILI, "
	_cQuery += " SB1.B1_LOCPAD, "
	_cQuery += " SD1.D1_LOCAL, "
	_cQuery += " SB1.B1_DESC, "
	_cQuery += " SB1.B1_UM, "
	_cQuery += " '' AS XSBGRP, "
	_cQuery += " SB1.B1_GRTRIB, "
	_cQuery += " SB1.B1_POSIPI, "
	
	// Novos campos adicionados -- Solicitação de Jorge Compras
	_cQuery += " '' AS DESC_SECAO, "		// DESC SECAO 			
	_cQuery += " '' AS DESC_LINHA, "		// DESC LINHA 			
	_cQuery += " '' AS CATEGORIA, "			// DESC CATEGORIA		
	_cQuery += " '' AS SUBGRUPO, "			// DESC SUBGRUPO 		
	_cQuery += " '' AS COD_CLUSTE, "			// COD CLUSTER 
	_cQuery += " '' AS CLUSTER, " 			// DESC CLUSTER		
	_cQuery += " '' AS COD_AMPLI, "			// COD AMPLITUDE 
	_cQuery += " '' AS AMPLITUDE, "			// DESC AMPLITUDE
	_cQuery += " '' AS COD_TPNEG, "			// COD TIPO NEGOCIO
	_cQuery += " '' AS TPNEGOCIO, "			// DESC TIPO NEGOCIO
	_cQuery += " '' AS COD_CONSER, "		// COD CONSERVACAO
	_cQuery += " '' AS CONSERV, "			// DESC CONSERVACAO
	_cQuery += " '' AS COD_PREP, "			// COD PREPARO
	_cQuery += " '' AS PREPARO, "			// DESC PREPARO
	_cQuery += " '' AS COD_TPMAQ, "			// COD TP MAQUINA
	_cQuery += " '' AS TPMAQUINA, "			// DESC TP MAQUINA
	_cQuery += " '' AS COD_MOLA, "			// COD MOLA
	_cQuery += " '' AS MOLA, "				// DESC MOLA
	
	_cQuery += " '' AS BLQ_GERAL, "				
	
	_cQuery += " '' AS BLQ_COMPRA, "			
				
	_cQuery += " '' AS CUBAGEM, "				
	
	_cQuery += " SB1.B1_CODBAR AS EAN, "
	_cQuery += " SB5.B5_COMPR AS COMPRIMENT, "	   		//	COMPRIMENTO
	_cQuery += " SB5.B5_ESPESS AS ESPESSURA, "	   		//	ESPESSURA
	_cQuery += " SB5.B5_LARG AS LARGURA, "		   		//	LARGURA 				
	// Fim dos campos adicionados
	
	
	_cQuery += " -(SD1.D1_TOTAL - SD1.D1_VALDESC) AS TOTAL, "
	_cQuery += "  -SD1.D1_QUANT, "
	_cQuery += " -SD1.D1_VALICM, "
	_cQuery += " -D1_ICMSRET, "
	_cQuery += " ' 'DESCZFR, "
	_cQuery += "  -SD1.D1_VALIMP5, "
	_cQuery += " -SD1.D1_VALIMP6, "
	_cQuery += " -SD1.D1_VUNIT, "
	_cQuery += " -SD1.D1_VALDESC, "
	_cQuery += " SA1.A1_EST, "
	_cQuery += " -SD1.D1_VALFRE, "
	_cQuery += " -SD1.D1_SEGURO, "
	_cQuery += " -SD1.D1_TOTAL AS  TOTALSDES, "
	_cQuery += " -SD1.D1_DESPESA, "
	_cQuery += " SD1.D1_DTDIGIT, "
	_cQuery += " SD1.D1_FILIAL, "
	_cQuery += " SA1.A1_NOME, "
	_cQuery += " SA1.A1_LOJA, "
	_cQuery += " SA1.A1_MUN, "
	_cQuery += " '' AS XCANAL, "
	_cQuery += " SD1.D1_ITEMCTA, "
	_cQuery += " -((SD1.D1_TOTAL + SD1.D1_SEGURO + SD1.D1_VALFRE + SD1.D1_DESPESA)- D1_VALDESC) AS VALTOT, "
	_cQuery += " SD1.D1_PEDIDO AS PEDIDO, "
	_cQuery += " -SD1.D1_VALISS AS VALISS, "
	_cQuery += " -SFT.FT_VALICM AS VALICMTRIB, "
	_cQuery += " -SFT.FT_ISENICM AS ISENICM, "
	_cQuery += " -SFT.FT_OUTRICM AS OUTRICM, "
	_cQuery += " SD1.D1_NFORI AS NFORI, "
	_cQuery += " SD1.D1_SERIORI AS SERIORI, "
	_cQuery += " '' AS CONTAREC "
	
	_cQuery += " FROM "+RetSQLName("SD1")+" AS SD1 "
	
	_cQuery += " INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	_cQuery += " SD1.D1_COD = SB1.B1_COD "
	
	/*------------------------------------------+ 
	|Junção com tabela de complementos - SB5	|
	+-------------------------------------------*/
	_cQuery += "LEFT JOIN "+RetSQLName("SB5")+" AS SB5  "
	_cQuery += "ON SD1.D1_COD = SB5.B5_COD AND "
	_cQuery += "SD1.D_E_L_E_T_ = SB5.D_E_L_E_T_ "
	
	
	_cQuery += " INNER JOIN "
	If cEmpAnt =='02'
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON "
		_cQuery += " SD1.D1_FILIAL = SA1.A1_FILIAL AND "
		_cQuery += " SD1.D1_FORNECE = SA1.A1_COD AND "
		_cQuery += " SD1.D1_LOJA = SA1.A1_LOJA "
	Else
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON "
		_cQuery += " SD1.D1_FORNECE = SA1.A1_COD AND "
		_cQuery += " SD1.D1_LOJA = SA1.A1_LOJA "
	EndIf
	
	_cQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
	_cQuery += " SD1.D1_TES = SF4.F4_CODIGO "
	
	// TRATAMENTO PARA AMC - TES COMPARTILHADA ENTRE FILIAIS
	If cEmpAnt <> "10"
		_cQuery += " AND SD1.D1_FILIAL = SF4.F4_FILIAL "
	EndIf
	
	_cQuery += " INNER JOIN "+RetSQLName("SF1")+" AS SF1 ON "
	_cQuery += " SD1.D1_DOC = SF1.F1_DOC AND "
	_cQuery += " SD1.D1_SERIE = SF1.F1_SERIE AND "
	_cQuery += " SD1.D_E_L_E_T_ = SF1.D_E_L_E_T_ AND "
	_cQuery += " SD1.D1_FILIAL = SF1.F1_FILIAL AND "
	_cQuery += " SD1.D1_FORNECE = SF1.F1_FORNECE AND "
	_cQuery += " SD1.D1_LOJA = SF1.F1_LOJA AND "
	_cQuery += " SD1.D1_EMISSAO = SF1.F1_EMISSAO  "
	
	_cQuery += " LEFT JOIN "+RetSQLName("SFT")+" AS SFT ON "
	_cQuery += " SD1.D1_FILIAL = SFT.FT_FILIAL AND "
	_cQuery += " SD1.D1_DOC = SFT.FT_NFISCAL AND "
	_cQuery += " SD1.D1_SERIE = SFT.FT_SERIE AND "
	_cQuery += " SD1.D1_DTDIGIT = SFT.FT_ENTRADA AND "
	_cQuery += " SD1.D1_FORNECE = SFT.FT_CLIEFOR AND "
	_cQuery += " SD1.D1_LOJA = SFT.FT_LOJA AND "
	_cQuery += " SD1.D1_COD = SFT.FT_PRODUTO AND "
	_cQuery += " SD1.D1_ITEM = SFT.FT_ITEM AND "
	_cQuery += " SFT.FT_TIPOMOV = 'E' AND "
	_cQuery += " FT_CODISS = '' AND "
	_cQuery += " SFT.D_E_L_E_T_ <> '*' "
	
	_cQuery += " WHERE "
	_cQuery += " (SD1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"') AND "
	_cQuery += " (SD1.D1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	_cQuery += " (SD1.D1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
	_cQuery += " (SD1.D1_DOC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND "
	_cQuery += " (SD1.D1_CC BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
	_cQuery += " (SD1.D1_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND "
	_cQuery += " (SD1.D1_TIPO IN('C','D')) AND "
	_cQuery += " (SF4.F4_DUPLIC = 'S' ) AND "
	//_cQuery += " D1_TES NOT IN('258','230','229') AND "
	_cQuery += " SD1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SF1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SB1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SA1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SF4.D_E_L_E_T_ <> '*' "

EndIf



If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf

/*-----------------------------|
|cria a query e dar um apelido |
|-----------------------------*/

MemoWrite("TTCOMR13.SQL",_cQuery) //Salva a Query na pasta sistem para consultas futuras
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL1",.F.,.T.)

/*-----------------------------------------------------|
| ajusta as casas decimais e datas no retorno da query |
|-----------------------------------------------------*/

TcSetField("TSQL1","TOTAL","N",14,4)
TcSetField("TSQL1","D2_QUANT","N",14,4)
TcSetField("TSQL1","B1_CUSTD","N",14,4)
TcSetField("TSQL1","VALISS"  ,"N",14,4)
TcSetField("TSQL1","TOTALSDES","N",14,4)
TcSetField("TSQL1","D2_EMISSAO","D",08,0)

dbSelectArea("TSQL1")
dbGotop()

Do While TSQL1->(!Eof())
	MsProcTxt("Processando Item "+TSQL1->D2_COD)
	
	/*--------------------|
	| variaveis adcionais |
	|--------------------*/
	
	_nCusStd	:= TSQL1->B1_CUSTD
	_nCusMed	:= 0
	DbSelectArea("SB2")
	DbSetOrder(1)
	If DbSeek(xFilial("SB2")+TSQL1->(D2_COD+D2_LOCAL),.F.)
		_nCusMed := SB2->B2_CM1
		If _nCusmed == 0
			_nCusmed := _nCusStd
		Endif
	Endif
	If _nCusStd == 0
		_nCusStd	:= _nCusMed
	Endif
	
	If MV_PAR07 == 1 // Standar
		_nCusven := _nCusStd * TSQL1->D2_QUANT
	ElseIf MV_PAR07 == 2  // Atual
		_nCusven := _nCusMed * TSQL1->D2_QUANT
	ElseIf MV_PAR07 == 3  // Fechamento
		_nCusven := CustFech(TSQL1->D2_COD,TSQL1->B1_LOCPAD,TSQL1->D2_QUANT,TSQL1->D2_FILIAL,left(Dtos(TSQL1->D2_EMISSAO),6))
	Endif
	
	/*--------------------------------------------------|
	| condicao para trazer a descriação do tipo da nota |
	|--------------------------------------------------*/
	//COLOCAR CONDICAO COMO AUTO CREDITO -RECARGA  -ODAIR
	If TSQL1->TIPO=="N"
		If TSQL1->D2_COD = "AC00001"
			clTipo:="AUTO CRED"
		ElseIf TSQL1->D2_COD = "AC00002"
			clTipo:="RECARGA"
		Else
			clTipo:="VENDA"
		EndIf
	ElseIf TSQL1->TIPO=="C"
		clTipo:="COMP.VENDA" 
	ElseIf TSQL1->TIPO=="@"
		clTipo:="@"
	Else
		clTipo:="DEVOLUCAO"
		If _nCusven > 0
			_nCusven:=_nCusven * (-1)
		EndIf
	EndIf
	
	/*------------------------------------------------------------------------|
	| condicao para trazer o status da nota de saida com relacao as notas nfe |
	|------------------------------------------------------------------------*/
	
	If Empty(TSQL1->CHAVENFE)
		clChvNfe:=""
	Else
		clChvNfe:="EXISTE"
	EndIf
	
	/*
	DbSelectArea("ZZ1")
	DbSetOrder(1)
	If DbSeek(TSQL1->D2_FILIAL + TSQL1->D2_LOCAL)
		clDescPa:= ZZ1->ZZ1_DESCRI
	EndIf
	*/
	DbSelectArea("NNR")
	DbSetOrder(1)
	If DbSeek(TSQL1->D2_FILIAL + TSQL1->D2_LOCAL)
		clDescPa:= NNR->NNR_DESCRI
	EndIf
	
	
	DbSelectArea("SX5")
	DbSetOrder(1)
	/*
	If DbSeek(XFILIAL("SX5")+clTabSec1+TSQL1->B1_XSECAO)
		clDescSec1:=X5_DESCRI
	EndIf
	If DbSeek(XFILIAL("SX5")+clTabSec2+TSQL1->B1_XSUBGRU)
		clDescSec2:=X5_DESCRI
	EndIf
	*/
	If DbSeek(XFILIAL("SX5")+clTabSec3+TSQL1->B1_GRTRIB)
		clDescSec3:=X5_DESCRI
	EndIf
	
	If cEmpAnt $ "01#02"
		If DbSeek(XFILIAL("SX5")+clTabSec4+TSQL1->XCANAL)
			clDescSec4:=X5_DESCRI
		EndIf
	EndIf
	
	DbSelectArea("SBM")
	DbSetOrder(1)
	If DbSeek(clFilial + TSQL1->D2_GRUPO)
		clDescg:=SBM->BM_DESC
	EndIf
	
	If cEmpAnt $ "01#02"
		DbSelectArea("ZZ2")
		DbSetOrder(1)
		If DbSeek(XFILIAL("ZZ2")+TSQL1->XFAMILI)
			clDescLin:=ZZ2_DESCRI
		EndIf
		
		DbSelectArea("ZZC")
		DbSetOrder(1)
		If DbSeek(XFILIAL("ZZC") + TSQL1->FINALIDADE)
			clFinalid:=ZZC->ZZC_FINAL
		EndIf
	EndIf
	
	//Posiciona para extração da descrição do centro de custo
	
	DbSelectArea("CTT")
	DbSetOrder(1)
	If DbSeek(XFILIAL("CTT")+ TSQL1->D2_CCUSTO)
		clDescCcd:=CTT->CTT_DESC01
	EndIf 
	
	// Posiciona para trazer a descrição da filial.
	
	DbSelectArea("SM0")
	_aAreaSM0:= GetArea()
	DbSetOrder(1)
	If DbSeek(cEmpAnt + TSQL1->D2_FILIAL)
		clDescFil:=SM0->M0_FILIAL
	EndIf
	DbSelectArea("CTD")
	DbSetOrder(1)
	If DbSeek(XFILIAL("CTD") + TSQL1->D2_ITEMCC )
		clItemc:=CTD->CTD_DESC01
	EndIf
	RestArea(_aAreaSM0)
	
	DbSelectArea("TRB")
	
	/*---------------------------|
	| adiciona registro em banco |
	|---------------------------*/
	
	RecLock("TRB",.T.)
	
	TRB->TIPO		:= clTipo
	TRB->COD_CLI	:= TSQL1->D2_CLIENTE
	TRB->LOJA		:= TSQL1->A1_LOJA
	TRB->CLIENTE	:= TSQL1->A1_NOME
	TRB->NOTA		:= TSQL1->D2_DOC
	TRB->ITEM		:= TSQL1->D2_ITEM
	TRB->PRODUTO	:= TSQL1->D2_COD
	TRB->DESCPRO	:= TSQL1->B1_DESC
	TRB->UNI_MED	:= TSQL1->B1_UM
	TRB->SUBGRUP	:= TSQL1->XSBGRP
	TRB->NCM		:= TSQL1->B1_POSIPI
	TRB->QTDE		:= TSQL1->D2_QUANT
	TRB->PRCVEN		:= TSQL1->D2_PRCVEN
	TRB->TOTAL		:= TSQL1->TOTAL
	TRB->DESCZFR	:= TSQL1->D2_DESCZFR
	TRB->ICMS_ST	:= TSQL1->D2_ICMSRET
	
	/*---------------------------------------------------------------------------|
	|   condição criada devido campo D2_VALICM está trazendo o valor do D2_ISS   |
	|---------------------------------------------------------------------------*/
	If TSQL1->VALISS<>0
		TRB->ICMS 	:=0  
		TRB->ICMSTRIB	:= 0
	Else
		TRB->ICMSTRIB	:= TSQL1->VALICMTRIB
		TRB->ICMS	:= TSQL1->D2_VALICM
	EndIf 

	TRB->ICMSISEN	:= TSQL1->ISENICM
	TRB->ICMSOUTR	:= TSQL1->OUTRICM
	
	
	TRB->PISCOFINS	:= TSQL1->XPISCOF
	
	
	TRB->PIS		:= TSQL1->D2_VALIMP5
	TRB->CONFINS	:= TSQL1->D2_VALIMP6
	
	If MV_PAR07==1
		TRB->CM_STD	  :=_nCusven
	ElseIf MV_PAR07==2
		TRB->CM_ATUAL :=_nCusven
	Else
		TRB->CM_FECH  :=_nCusven
	EndIf
	
	TRB->LOCALPD	:= TSQL1->D2_LOCAL
	TRB->DESCARM	:= clDescPa
	TRB->SERIE		:= TSQL1->D2_SERIE
	TRB->CFOP		:= TSQL1->D2_CF
	TRB->CCUSTO		:= TSQL1->D2_CCUSTO
	TRB->DESCCUSTO	:=clDescCcd
	TRB->TES		:= TSQL1->D2_TES
	TRB->FINALID   	:= TSQL1->F4_FINALID
	TRB->PR_UNIT	:= TSQL1->D2_PRUNIT
	TRB->DESCONTO	:= TSQL1->D2_DESCON
	TRB->FRETE		:= TSQL1->D2_VALFRE
	TRB->SEGURO		:= TSQL1->D2_SEGURO
	TRB->DESPESAS	:= TSQL1->D2_DESPESA
	TRB->VALTOT		:= TSQL1->VALTOT
	TRB->FILIAL   	:= TSQL1->D2_FILIAL
	TRB->DESCFIL   	:= clDescFil
	TRB->ESTADO		:= TSQL1->D2_EST
	TRB->CIDADE		:= TSQL1->A1_MUN
	TRB->EMISSAO	:= TSQL1->D2_EMISSAO
	
	If clTipo == "DEVOLUCAO"			
		clCodvend 	:= Posicione("SF2",2,TSQL1->D2_FILIAL+TSQL1->D2_CLIENTE+TSQL1->A1_LOJA+TSQL1->NFORI+TSQL1->SERIORI,"F2_VEND1")
		clCodSup	:= Posicione("SA3",1,xFilial("SA3")+ clCodvend,"A3_SUPER")
		clCodger	:= Posicione("SA3",1,xFilial("SA3")+ clCodvend,"A3_GEREN")
		TRB->CODVEND 	:= clCodvend
		TRB->VENDED	 	:= Posicione("SA3",1,xFilial("SA3")+ clCodvend,"A3_NOME")
		TRB->SUPERV		:= clCodSup
		TRB->GERENT		:= clCodger
		TRB->DESCSUPER 	:= Posicione("SA3",1,xFilial("SA3")+ clCodSup,"A3_NOME")
		TRB->DESCGEREN	:= Posicione("SA3",1,xFilial("SA3")+ clCodger,"A3_NOME")		
	Else
		TRB->CODVEND	:= TSQL1->F2_VEND1
		TRB->VENDED		:= TSQL1->A3_NOME
		TRB->SUPERV		:= TSQL1->SUPER
		TRB->GERENT		:= TSQL1->GERENT
		TRB->DESCSUPER 	:= Posicione("SA3",1,xFilial("SA3")+ TSQL1->SUPER,"A3_NOME")
		TRB->DESCGEREN	:= Posicione("SA3",1,xFilial("SA3")+ TSQL1->GERENT,"A3_NOME")
	EndIf 
									
	TRB->ROMAN		:= TSQL1->ROMAN
	TRB->TRANSP		:= TSQL1->TRANSP
	TRB->PLACA		:= TSQL1->PLACA
	TRB->MOTOR		:= TSQL1->MOTORISTA
	TRB->CHVNFE		:= clChvNfe
	TRB->GRUPO		:= TSQL1->D2_GRUPO
	
	TRB->SECAO		:= TSQL1->XSECAO
	
	TRB->GRUPTRIB	:= TSQL1->B1_GRTRIB
	TRB->DESCGRTRI	:= clDescSec3
	
	TRB->LINHA		:= TSQL1->XFAMILI

	TRB->DESCSUBG	:= TSQL1->SUBGRUPO		//clDescSec2
	TRB->DESCSEC	:= TSQL1->DESC_SECAO	//clDescSec1
	TRB->DESCGRUP	:= clDescg
	TRB->DESCLIN	:= TSQL1->DESC_LINHA	//clDescLin
	TRB->PEDIDO		:= TSQL1->PEDIDO
	TRB->VALISS		:= TSQL1->VALISS
	TRB->FATCONV	:= TSQL1->B1_CONV
	TRB->TIPCONV	:= TSQL1->B1_TIPCONV
	TRB->SEGUNID	:= TSQL1->B1_SEGUM
	TRB->QT_UNID_UN	:= TSQL1->QUNICPROD
	
	TRB->XCANAL		:= TSQL1->XCANAL
	
	TRB->DESCCAN	:= clDescSec4
	TRB->FINALIDA	:= clFinalid
	TRB->TOTSDESC	:= TSQL1->TOTALSDES
	TRB->ITEMC		:= TSQL1->D2_ITEMCC
	TRB->DCITEMC	:= clItemc

	If MV_PAR07==1
		TRB->CM_STD_UN  :=(_nCusven / TSQL1->D2_QUANT)
	EndIf
	nlRecLiq := TSQL1->TOTALSDES - (TSQL1->VALICMTRIB + TSQL1->D2_VALIMP5 + TSQL1->D2_VALIMP6  + TSQL1->D2_DESCON  + TSQL1->D2_DESCZFR )
	TRB->RECLIQ		:= nlRecLiq
	TRB->MARGEM		:= nlRecLiq - _nCusven
	TRB->MARGEMP	:= ((nlRecLiq - _nCusven) / nlRecLiq) * 100
	
	//If  Left(Trim(TSQL1->D2_COD),2)=='21' .Or. Left(Trim(TSQL1->D2_COD),2)=='22'
	//	clCstduni:=Costdddc(TSQL1->D2_COD)
	//Else
		clCstduni:=TSQL1->B1_CUSTD
	//EndIf
	
	clCstdTot:= TSQL1->D2_QUANT * clCstduni
	TRB->STDGERUNI := clCstduni
	TRB->STDGERTOT := clCstdTot 
	
	If cEmpAnt == "01"
		TRB->MESREF	   := Posicione("SC5",3,TSQL1->D2_FILIAL+TSQL1->D2_CLIENTE+TSQL1->A1_LOJA+TSQL1->PEDIDO,"C5_XMESREF") // Incluído em 25/04/2012 para trazer o mês dereferência do pedido de venda
	EndIF
	
	TRB->CTAREC		:= TSQL1->CONTAREC
	TRB->DESCCTREC	:= Posicione("CT1",1,xFilial("CT1")+TSQL1->CONTAREC,"CT1_DESC01")
	
	// Solicitação do Jorge/Compras
	TRB->DESC_SECAO	:= TSQL1->DESC_SECAO		// DESC SECAO
	TRB->DESC_LINHA	:= TSQL1->DESC_LINHA		// NOME LINHA
	TRB->CATEGORIA	:= TSQL1->CATEGORIA 		// NOME DA CATEGORIA
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
	TRB->CUBAGEM	:= TSQL1->CUBAGEM			// CUBAGEM DO PRODUTO 
	
	TRB->COMPRIMENT	:= TSQL1->COMPRIMENT		// COMPRIMENTO
	TRB->ESPESSURA	:= TSQL1->ESPESSURA			// ESPESSURA
	TRB->LARGURA	:= TSQL1->LARGURA			// LARGURA
	TRB->EAN		:= TSQL1->EAN				// EAN
	
	
	// Armazena a Data de Emissão da Nota Fiscal
	dDtDigit		:= TSQL1->D2_EMISSAO        
	
	// Busca Datas Formatadas
	aRetData		:= ConvData(dDtDigit)
		                                                  
	TRB->DT_DIA		:= aRetData[1][1]											// Data Dia
	TRB->DT_MESANO	:= Substr(aRetData[2][2],1,3) + "/" + aRetData[3][1]		// Data Mes/Ano - Ex: Jan/2013	
	TRB->DT_ANO		:= aRetData[3][1]								   			// Data Ano - Ex: 2013
	TRB->DT_TRIM	:= aRetData[2][3] + aRetData[3][1]							// Data Trimestre/Ano - Ex: 1T2013     
		
	
	MsUnlock()
	
	clNome		:= ""
	clDescCcd 	:= Space(30)
	clDescPa	:= Space(30)
	clDescSec1 	:= Space(30)
	clDescSec2	:= Space(30)
	clDescLin	:= Space(30)
	clDescg		:= Space(30)
	clDescSec3  := Space(30)
	clDescSec4  := Space(30)
	clFinalid   := ""
	clItemc		:= ""
	clCodvend 	:= "" 
	clCodSup	:= ""
	clCodger	:= ""
	clCstduni   := 0
	clCstdTot   := 0    
	
	dbSelectArea("TSQL1")
	DbSkip()
Enddo

If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf
Return

/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦CustFech()¦ Autor ¦ Fabio Sales  ¦ 	  Data ¦    29/08/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Retorna o custo do fechamento dos produtos			   	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento / TokeTake                                      ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/    

Static Function CustFech(_cCodPro,_cLocal,_nQuant,_cFilial,ldData)

Local _aArea := GetArea() // Salva a Area Atual
Local _nCusto:= 0
Local _nRetorno
/*-----------------------------------------------------------|
| Montagem da query com os dados do ultimo fechamento do mes |
|-----------------------------------------------------------*/

_cQuery := " SELECT B9_CM1 "
_cQuery += " FROM "+RetSQLName("SB9")+" SB9      "
_cQuery += " WHERE B9_FILIAL    = '"+_cFilial +"' "
_cQuery += " AND B9_COD   = '"+_cCodPro +"' "
_cQuery += " AND B9_LOCAL = '"+_cLocal +"'  "
_cQuery += " AND LEFT(B9_DATA,6)  = '"+ ldData +"'  "
_cQuery += " AND D_E_L_E_T_ = ' '  "

/*-------------------------------------------|
|verifica se a query existe se existir fecha |
|-------------------------------------------*/

If Select("TSQL2") > 0
	dbSelectArea("TSQL2")
	DbCloseArea()
EndIf

/*---------------------------------------|
| cria a query e dar um apelido para ela |
|---------------------------------------*/

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL2",.F.,.T.)

/*--------------------------------------------------|
| ajusta casas decimais e datas no retorno da query |
|--------------------------------------------------*/

TcSetField("TSQL2","B9_CM1","N",14,2)

dbSelectArea("TSQL2")
If TSQL2->(!Eof())
	_nCusto := TSQL2->B9_CM1
Endif

_nRetorno := _nCusto * _nQuant

/*----------------------|
| restaura a area atual |
|----------------------*/

RestArea(_aArea)

Return(_nRetorno)

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


/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ValPerg¦ Autor ¦ Fabio Sales 		¦ Data ¦        29/08/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Criam as perguntas, caso as mesmas não existam na SX1   	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento / TokeTake                                      ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                                                                                                                           

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissao de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Grupo de              ?','','','mv_ch3','C',4,0,0,'G','','SBM','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Grupo Ate             ?','','','mv_ch4','C',4,0,0,'G','','SBM','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Produto de            ?','','','mv_ch5','C',15,0,0,'G','','SB1','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Produto Ate           ?','','','mv_ch6','C',15,0,0,'G','','SB1','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Tipo Custo            ?','','','mv_ch7','N',1 ,0,1,'C','','','','','mv_par07',"Standard"," "," ","","Atual","","","Fechamento","","","","","","","","")   
	PutSx1(cPerg,'08','Nota de               ?','','','mv_ch8','C',09,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'09','Nota Ate              ?','','','mv_ch9','C',09,0,0,'G','','','','','mv_par09',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'10','C.Custo de            ?','','','mv_cha','C',09,0,0,'G','','CTT','','','mv_par10',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'11','C.Custo ate           ?','','','mv_chb','C',09,0,0,'G','','CTT','','','mv_par11',,,'','','','','','','','','','','','','','') 	
	PutSx1(cPerg,'12','Filial  de            ?','','','mv_chc','C',02,0,0,'G','','SM0','','','mv_par12',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'13','Filial  ate           ?','','','mv_chd','C',02,0,0,'G','','SM0','','','mv_par13',,,'','','','','','','','','','','','','','') 
		
Return
