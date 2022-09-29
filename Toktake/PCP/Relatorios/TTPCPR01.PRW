#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TTPCPR01³ Autor ³ Artur Nucci Ferrari    ³ Data ³ 07/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ SALDO ESTOQUE						   ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Hist.     ³ Alt.	³ Autor ³ Jackson E. de Deus    ³ Data ³ 19/02/13 ³±±
±±	     ³ Novas colunas adicionadas				  ³±±
±±	     ³ Solitação de Jorge/Compras				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESTOQUE                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TTPCPR01()
Local oReport

If cEmpAnt <> "01"
	Return
EndIf

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTDEF³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 07/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Principal de Impressao                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PCP                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local oReport
Local oSection
Private cPerg    := "TTPCP01"
ValPerg(cPerg)
Pergunte(cPerg,.T.)
oReport := TReport():New("TTPCPR01","RELATORIO DE ETIQUETAS DE PRODUÇÃO","",{|oReport| PrintReport(oReport)},"Este relatório imprime a relação das etiquetas Pallet da Produção.")

// Seção  Dados da Nota Fiscal
oSection1 := TRSection():New(oReport,OemToAnsi("ETIQUETAS PALLET"),{"TRB"})
//                      CAMPO   	 ALIAS  TITULO   		PIC TAMANHO

TRCell():New(oSection1,"FILIAL"	 ,"TRB","FILIAL		"	 ,"@!",02)
TRCell():New(oSection1,"XETQPRD" ,"TRB","ETIQUETA 	"	 ,"@!",06)
TRCell():New(oSection1,"OP"	     ,"TRB","ORD.PRODUCAO"	 ,"@!",13)
TRCell():New(oSection1,"EMISSAO" ,"TRB","EMISSAO	"    ,"@!",08)
TRCell():New(oSection1,"DOC"	 ,"TRB","DOCUMENTO	"	 ,"@!",09)
TRCell():New(oSection1,"TM"		 ,"TRB","TM"        	 ,"@!",02)
TRCell():New(oSection1,"CF"		 ,"TRB","CF     	"	 ,"@!",03)
TRCell():New(oSection1,"COD"	 ,"TRB","PRODUTO	"	 ,"@!",15)
TRCell():New(oSection1,"DESC"	 ,"TRB","DESCRICAO 	"	 ,"@!",25)
TRCell():New(oSection1,"UM"		 ,"TRB","UM"             ,"@!",02)
TRCell():New(oSection1,"TIPO"	 ,"TRB","TP"             ,"@!",02)
TRCell():New(oSection1,"QUANT"	 ,"TRB","Quant.     	","@E 999999.99",16)
TRCell():New(oSection1,"LOCAL"	 ,"TRB","ARMAZEM"        ,"@!",06)
TRCell():New(oSection1,"USUARIO" ,"TRB","USUARIO"        ,"@!",25)

	// Solicitação Jorge/Compras - novas colunas ao final do relatório
	// Mostra mesmo campos ja existentes - mostrar campos do relatorio de cadastro de produtos
	TRCell():New(oSection1,"COD"	 ,"TRB","PRODUTO	"	 ,"@!",15)						// Ja existente acima
	TRCell():New(oSection1,"PRODUTO"		,"TRB"	,"PRODUTO"			,"@!"	,30)	
	TRCell():New(oSection1,"COD_SECAO"		,"TRB"	,"CÓD. SEÇÃO"			,"@!"	,04)
	TRCell():New(oSection1,"SECAO"			,"TRB"	,"SEÇÃO"			,"@!"	,20)
	TRCell():New(oSection1,"COD_LINHA"		,"TRB"	,"CÓD. LINHA"			,"@!"	,03)
	TRCell():New(oSection1,"LINHA"			,"TRB"	,"LINHA"			,"@!"  	,20)
	TRCell():New(oSection1,"COD_CATEG"		,"TRB"	,"CÓD. CATEGORIA"		,"@!" 	,04)
	TRCell():New(oSection1,"CATEGORIA"		,"TRB"	,"CATEGORIA"			,"@!"  	,40)
	TRCell():New(oSection1,"COD_SGRUPO"		,"TRB"	,"CÓD. SUBGRUPO"		,"@!"  	,04)
	TRCell():New(oSection1,"SUBGRUPO"		,"TRB"	,"SUBGRUPO"			,"@!"  	,20)
	TRCell():New(oSection1,"NCM"			,"TRB"	,"NCM"				,"@R 9999.99.99"  	,10)
	TRCell():New(oSection1,"COD_CLUSTE"		,"TRB"	,"CÓD. CLUSTER"			,"@!"  	,02)
	TRCell():New(oSection1,"CLUSTER"		,"TRB"	,"CLUSTER"			,"@!"  	,20) 
	TRCell():New(oSection1,"COD_AMPLI"		,"TRB"	,"COD AMPLI"			,"@!"  	,04) 	
	TRCell():New(oSection1,"AMPLITUDE"		,"TRB"	,"AMPLITUDE"			,"@!"  	,25) 
	TRCell():New(oSection1,"COD_TPNEG"		,"TRB"	,"COD TP NEG"			,"@!"  	,04) 
	TRCell():New(oSection1,"TPNEGOCIO"		,"TRB"	,"TP NEGOCIO"			,"@!"  	,25) 	
	TRCell():New(oSection1,"COD_CONSER"		,"TRB"	,"COD CONSERV"			,"@!"  	,04)
	TRCell():New(oSection1,"CONSERV"		,"TRB"	,"CONSERVACAO"			,"@!"  	,25)
	TRCell():New(oSection1,"COD_PREP"		,"TRB"	,"COD PREP"			,"@!"  	,04)
	TRCell():New(oSection1,"PREPARO"		,"TRB"	,"PREPARO"			,"@!"  	,25)	
	TRCell():New(oSection1,"COD_TPMAQ"		,"TRB"	,"COD TP MAQ"			,"@!"  	,04)
	TRCell():New(oSection1,"TPMAQUINA"		,"TRB"	,"TIPO MAQ"			,"@!"  	,25)			
	TRCell():New(oSection1,"COD_MOLA"		,"TRB"	,"COD MOLA"			,"@!"  	,04)	                                                            
	TRCell():New(oSection1,"MOLA"			,"TRB"	,"MOLA"			  	,"@!"  	,25)	                                
	TRCell():New(oSection1,"BLQ_GERAL"		,"TRB"	,"BLQ GERAL"			,"@!"  	,03)		
	TRCell():New(oSection1,"BLQ_COMPRA"		,"TRB"	,"BLQ COMPRAS"			,"@!"  	,03)
	TRCell():New(oSection1,"UM"				,"TRB"	,"UNID. MEDIDA"		,"@!"  	,02)
	TRCell():New(oSection1,"FATCONV"		,"TRB"	,"FAT CONV"			,"@E 9999.999"  	,08)
	TRCell():New(oSection1,"SEGUM"			,"TRB"	,"SEG UM"			,"@!"  	,02)
	TRCell():New(oSection1,"CUBAGEM"		,"TRB"	,"CUBAGEM"			,"@!"  	,03) 
	TRCell():New(oSection1,"COMPRIMENT"		,"TRB"	,"COMPRIMENTO"			,"@E 999,999.99"  	,10) 	
	TRCell():New(oSection1,"ESPESSURA"		,"TRB"	,"ESPESSURA"			,"@E 999,999.99"  	,10) 
	TRCell():New(oSection1,"LARGURA"		,"TRB"	,"LARGURA"			,"@E 999,999.99"  	,10) 
	TRCell():New(oSection1,"EAN"			,"TRB"	,"EAN"				,"@!"  	,15)
   	TRCell():New(oSection1,"DT_DIA"	   		,"TRB"	,"DIA"					,"@!" 	   				,02)		// Dia
	TRCell():New(oSection1,"DT_MESANO"		,"TRB"	,"MES/ANO"				,"@!" 		 			,08)		// Mes/Ano
	TRCell():New(oSection1,"DT_ANO"			,"TRB"	,"ANO"					,"@!" 	   				,04)		// Ano
	TRCell():New(oSection1,"DT_TRIM"		,"TRB"	,"TRIMESTRE"			,"@!" 	 				,06)		// Trimestre


Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PrintReport³ Autor ³ Artur Nucci Ferrari ³ Data ³ 07/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Responsável pela impessão do relatório               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PCP                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PrintReport(oReport)


Local oSection1 := oReport:Section(1)

// Selecao dos dados a Serem Impressos // Carrega o Arquivo Temporario de Trabalho

MsAguarde({|| fSelDados()},"Selecionando Itens")

// Impressao da Primeira secao
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

// Selecao dos dados a serem impressos // criacao do temporario

Static Function fSelDados()  

Local c_EOL	     := CHR(13)+CHR(10)
Local aRetData	 := {}
Local dDtEmiss

// Criacao arquivo de Trabalho
_aStru	:= {}

AADD(_aStru,{"FILIAL"	,"C",02,0})
AADD(_aStru,{"XETQPRD"	,"C",06,0})
AADD(_aStru,{"OP"		,"C",13,0})
AADD(_aStru,{"EMISSAO"	,"D",08,0})
AADD(_aStru,{"DOC"		,"C",09,0})
AADD(_aStru,{"TM"	    ,"C",03,0})
AADD(_aStru,{"CF"		,"C",03,0})
AADD(_aStru,{"COD"		,"C",15,0})		// Cod. Produto
AADD(_aStru,{"DESC"	    ,"C",25,0})
AADD(_aStru,{"UM"		,"C",02,2})
AADD(_aStru,{"TIPO"		,"C",02,2})
AADD(_aStru,{"QUANT"	,"N",12,0})
AADD(_aStru,{"LOCAL"	,"C",06,2})
AADD(_aStru,{"USUARIO"	,"C",25,0})

/*------------------------------------------+ 
| Novos campos - Jorge/Compras				|
| Jackson E. de Deus	-	19/02/2013		|
+-------------------------------------------*/
AADD(_aStru,{"PRODUTO"		,"C"	,30	,0})  		// Desc. Produto
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
//AADD(_aStru,{"UM"			,"C"	,02	,0})		// UN. MEDIDA
AADD(_aStru,{"FATCONV"		,"N"	,14	,4})		// FATOR DE CONVERSAO
AADD(_aStru,{"SEGUM"		,"C"	,06	,0})		// Seg. Unidade Medida
AADD(_aStru,{"CUBAGEM"		,"C"	,03	,0})		// CUBAGEM DO PRODUTO 
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
IndRegua("TRB",_cIndice,"XETQPRD+OP",,,"Selecionando Registros...")

// Montagem da Query com dados dos pedido de compras em aberto
// Seleciona os pedidos de compras e aberto

cQuery := "SELECT "			   			+ c_EOL 
cQuery += "D3_FILIAL, " 				+ c_EOL 
cQuery += "D3_XETQPRD, " 				+ c_EOL
cQuery += "D3_OP, " 					+ c_EOL
cQuery += "D3_EMISSAO, "	 			+ c_EOL
cQuery += "D3_DOC, " 					+ c_EOL
cQuery += "D3_TM, "		 				+ c_EOL
cQuery += "D3_CF, "		 				+ c_EOL
cQuery += "D3_COD, "					+ c_EOL
cQuery += "B1_DESC, "	 				+ c_EOL

/*------------------------------------------+ 
| Novos campos - Jorge/Compras				|
| Jackson E. de Deus	-	19/02/2013		|
+-------------------------------------------*/
cQuery += "B1_DESC AS PRODUTO," 			+ c_EOL						//	-- DESCRICAO
cQuery += "B1_XSECAO AS COD_SECAO," 		+ c_EOL						//	-- COD SECAO
cQuery += "B1_XSECAOT AS SECAO," 			+ c_EOL						//	-- DESC SECAO
cQuery += "B1_XFAMILI AS COD_LINHA," 		+ c_EOL						//	-- COD LINHA
cQuery += "B1_XFAMLIT AS LINHA," 			+ c_EOL						//	-- DESC LINHA
cQuery += "B1_GRUPO AS COD_CATEG,"			+ c_EOL	   					//	-- COD CATEGORIA
cQuery += "B1_XGRUPOT AS CATEGORIA,"		+ c_EOL						//	-- DESC CATEGORIA
cQuery += "B1_XSUBGRU AS COD_SUBGRP," 		+ c_EOL						//	-- COD SUGRUPO
cQuery += "B1_XSUBGRT AS SUBGRUPO," 		+ c_EOL						//	-- DESC SUBGRUPO
cQuery += "B1_POSIPI AS NCM," 		   		+ c_EOL						//	-- NCM
cQuery += "B1_XCLUST AS COD_CLUSTE," 		+ c_EOL						//	-- COD CLUSTER
cQuery += "B1_XCLUSTD AS CLUSTER," 			+ c_EOL						//	-- CLUSTER
cQuery += "B1_XAMPLI AS COD_AMPLI,"			+ c_EOL						//	-- COD AMPLITUDE 
cQuery += "B1_XDSAMPL AS AMPLITUDE,"		+ c_EOL						//	-- DESC AMPLITUDE
cQuery += "B1_XTNEGO AS COD_TPNEG,"			+ c_EOL						//	-- COD TIPO NEGOCIO
cQuery += "B1_XTNEGOT AS TPNEGOCIO,"		+ c_EOL						//	-- DESC TIPO NEGOCIO
cQuery += "B1_XCONSER AS COD_CONSER,"		+ c_EOL						//	-- COD CONSERVACAO
cQuery += "B1_XDSCONS AS CONSERV,"			+ c_EOL						//	-- DESC CONSERVACAO
cQuery += "B1_XPREPAR AS COD_PREP,"			+ c_EOL						//	-- COD PREPARO
cQuery += "B1_XDSPREP AS PREPARO,"			+ c_EOL						//	-- DESC PREPARO
cQuery += "B1_XTPMAQ AS COD_TPMAQ,"			+ c_EOL						//	-- COD TP MAQUINA
cQuery += "B1_XDSTPMA AS TPMAQUINA,"		+ c_EOL						//	-- DESC TP MAQUINA
cQuery += "B1_XMOLA AS COD_MOLA,"			+ c_EOL						//	-- COD MOLA
cQuery += "B1_XDSMOLA AS MOLA,"				+ c_EOL						//	-- DESC MOLA

cQuery += "CASE B1_MSBLQL "			  		+ c_EOL						//	-- BLOQUEIO GERAL
cQuery += "		WHEN '1' "					+ c_EOL 
cQuery += "			THEN 'SIM' "			+ c_EOL 
cQuery += "		ELSE 'NAO' "				+ c_EOL 
cQuery += "END AS BLQ_GERAL, "				+ c_EOL

cQuery += "CASE B1_XBLQCOM "				+ c_EOL						//	-- BLOQUEIO COMPRAS 
cQuery += "		WHEN 'T' "					+ c_EOL 
cQuery += "			THEN 'SIM' "			+ c_EOL 
cQuery += "		ELSE 'NAO' "				+ c_EOL 
cQuery += "END AS BLQ_COMPRA, "		   		+ c_EOL

cQuery += "B1_UM AS UM," 		   			+ c_EOL						//	-- UNIDADE DE MEDIDA	
cQuery += "B1_SEGUM AS SEGUM," 		   		+ c_EOL						//	-- SEGUNDA UNIDADE DE MEDIDA
cQuery += "B1_CONV AS FATCONV," 			+ c_EOL						//	-- FATOR CONVERSAO

cQuery += "CASE B1_XCBGEM "			  		+ c_EOL						//	-- CUBAGEM  
cQuery += "		WHEN 'T' "					+ c_EOL 
cQuery += "			THEN 'SIM' "			+ c_EOL 
cQuery += "		ELSE 'NAO' "				+ c_EOL 
cQuery += "END AS CUBAGEM, "				+ c_EOL

cQuery += "B1_CODBAR AS EAN," 				+ c_EOL					//	-- EAN - B1_VEREAN?
cQuery += "B5_COMPR AS COMPRIMENT,"	 		+ c_EOL						//	-- COMPRIMENTO
cQuery += "B5_ESPESS AS ESPESSURA,"	   		+ c_EOL						//	-- ESPESSURA
cQuery += "B5_LARG AS LARGURA," 		  		+ c_EOL						//	-- LARGURA
// Fim dos novos campos

cQuery += "D3_UM, " 				 		+ c_EOL
cQuery += "D3_TIPO, "	 			  		+ c_EOL

cQuery += "'QUANT' = CASE "			   		+ c_EOL						&&-------------------------------------------------------------------------------&&	 					
cQuery += "		WHEN D3_TM = '999' "  		+ c_EOL						&& alreração feita por ---> Fabio Sales | Data da alteração   ---> 02/12/2010    && 																						
cQuery += " 		THEN -D3_QUANT "   		+ c_EOL						&& solicitante-->Katia Valle | obejetivo da alteração--->mostrar a Qtde negativa &&  	
cQuery += " 	ELSE D3_QUANT END, "   		+ c_EOL						&&__________________quando o o tipo de movimento for igual '999'_________________&& 	

cQuery += "D3_LOCAL, " 										+ c_EOL                                                                                    
cQuery += "D3_USUARIO " 									+ c_EOL
cQuery += "FROM " + RetSqlName("SD3")+ " AS SD3 " 			+ c_EOL

cQuery += "INNER JOIN " + RetSqlName("SB1")+" AS SB1 ON "	+ c_EOL
cQuery += "SB1.B1_COD = SD3.D3_COD AND" 					+ c_EOL
cQuery += "SB1.D_E_L_E_T_ = ' ' " 							+ c_EOL

/*------------------------------------------+ 
| Junção com tabela de complementos - SB5	|
| Jackson 19/02/2013						|
+-------------------------------------------*/
cQuery += "LEFT JOIN "+RetSQLName("SB5")+" AS SB5  "		+ c_EOL
cQuery += "ON SB1.B1_COD = SB5.B5_COD AND "					+ c_EOL
cQuery += "SB1.D_E_L_E_T_ = SB5.D_E_L_E_T_ " 				+ c_EOL



cQuery += "WHERE SD3.D_E_L_E_T_ = '' "														+ c_EOL
cQuery += "AND D3_XETQPRD BETWEEN '" + mv_par01 + "' AND '"  + mv_par02 + "' "				+ c_EOL
cQuery += "AND D3_EMISSAO BETWEEN '" + DTOS(mv_par03) + "' AND '"  + DTOS(mv_par04) + "' "	+ c_EOL
cQuery += "AND D3_COD     BETWEEN '" + mv_par05 + "' AND '"  + mv_par06 + "' "				+ c_EOL
cQuery += "AND D3_OP      BETWEEN '" + mv_par07 + "' AND '"  + mv_par08 + "' "				+ c_EOL
cQuery += "AND D3_XETQPRD <> '' "															+ c_EOL
cQuery += "AND D3_TIPO <> 'PI' "															+ c_EOL
cQuery += "ORDER BY 1,7	 "																	+ c_EOL   

MemoWrite("TTPCPR01.sql",cQuery)

IF SELECT("ETQ") > 0
	dbSelectArea("ETQ")
	DbCloseArea()
ENDIF

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"ETQ",.F.,.T.)

// AJUSTA CASAS DECIMAIS NO RETORNO DA QUERY

dbSelectArea("ETQ")
dbGotop()

While ETQ->(!Eof())
	
	DbSelectArea("TRB")
	// ADICIONA REGISTRO EM BRANCO
	RecLock("TRB",.T.)
	TRB->FILIAL		:= ETQ->D3_FILIAL
	TRB->XETQPRD	:= ETQ->D3_XETQPRD
	TRB->OP		    := ETQ->D3_OP
	TRB->EMISSAO	:= CTOD(SubStr(ETQ->D3_EMISSAO,7,2)+'/'+SubStr(ETQ->D3_EMISSAO,5,2)+'/'+SubStr(ETQ->D3_EMISSAO,3,2))
	TRB->DOC		:= ETQ->D3_DOC
	TRB->TM	        := ETQ->D3_TM
	TRB->CF			:= ETQ->D3_CF
	TRB->COD		:= ETQ->D3_COD
	TRB->DESC	    := ETQ->B1_DESC
	TRB->UM		    := ETQ->D3_UM
	TRB->TIPO		:= ETQ->D3_TIPO
	TRB->QUANT		:= ETQ->QUANT
	TRB->LOCAL		:= ETQ->D3_LOCAL
	TRB->USUARIO    := ETQ->D3_USUARIO  
	
	/*------------------------------------------+ 
	| Solicitação do Jorge/Compras 				|
	| Jackson 19/02/2013						|
	+-------------------------------------------*/

	TRB->PRODUTO	:= ETQ->PRODUTO
	TRB->COD_SECAO	:= ETQ->COD_SECAO			// COD SECAO			
	TRB->DESC_SECAO	:= ETQ->SECAO				// DESC SECAO
	TRB->COD_LINHA	:= ETQ->COD_LINHA			// COD SECAO						
	TRB->DESC_LINHA	:= ETQ->LINHA				// NOME LINHA
	TRB->COD_CATEG	:= ETQ->COD_CATEG 		// NOME DA CATEGORIA			
	TRB->CATEGORIA	:= ETQ->CATEGORIA 		// NOME DA CATEGORIA
	TRB->COD_SUBGRP := ETQ->COD_SUBGRP		// COD DO SUBGRUPO
	TRB->SUBGRUPO	:= ETQ->SUBGRUPO			// NOME DO SUBGRUPO
	TRB->COD_CLUSTE	:= ETQ->COD_CLUSTE		// COD CLUSTER
	TRB->CLUSTER	:= ETQ->CLUSTER			// DESC CLUSTER
	TRB->COD_AMPLI	:= ETQ->COD_AMPLI			// COD AMPLITUDE 
	TRB->AMPLITUDE	:= ETQ->AMPLITUDE			// DESC AMPLITUDE
	TRB->COD_TPNEG	:= ETQ->COD_TPNEG			// COD TIPO NEGOCIO
	TRB->TPNEGOCIO	:= ETQ->TPNEGOCIO			// DESC TIPO NEGOCIO
	TRB->COD_CONSER	:= ETQ->COD_CONSER		// COD CONSERVACAO
	TRB->CONSERV	:= ETQ->CONSERV			// DESC CONSERVACAO
	TRB->COD_PREP	:= ETQ->COD_PREP			// COD PREPARO
	TRB->PREPARO	:= ETQ->PREPARO			// DESC PREPARO
	TRB->COD_TPMAQ	:= ETQ->COD_TPMAQ			// COD TP MAQUINA
	TRB->TPMAQUINA	:= ETQ->TPMAQUINA			// DESC TP MAQUINA
	TRB->COD_MOLA	:= ETQ->COD_MOLA			// COD MOLA
	TRB->MOLA		:= ETQ->MOLA				// DESC MOLA				
	TRB->BLQ_GERAL	:= ETQ->BLQ_GERAL			// BLOQUEIO GERAL DO PRODUTO - Converte de 1 - 2 para Sim - Nao		
	TRB->BLQ_COMPRA	:= ETQ->BLQ_GERAL			// BLOQUEIO DO COMPRAS - Converte de T - F para Sim - Nao		
    TRB->UM			:= ETQ->UM				// UNIDADE DE MEDIDA
	TRB->FATCONV	:= ETQ->FATCONV
	TRB->SEGUM		:= ETQ->SEGUM				// SEG. UNID. MEDIDA 
	TRB->CUBAGEM	:= ETQ->CUBAGEM			// CUBAGEM DO PRODUTO 
	TRB->COMPRIMENT	:= ETQ->COMPRIMENT		// COMPRIMENTO
	TRB->ESPESSURA	:= ETQ->ESPESSURA			// ESPESSURA
	TRB->LARGURA	:= ETQ->LARGURA			// LARGURA
	TRB->EAN		:= ETQ->EAN				// EAN

	// Armazena a Data de Emissão da Nota Fiscal
	dDtEmiss		:= STOD(ETQ->D3_EMISSAO)
	
	// Busca Datas Formatadas
	aRetData		:= ConvData(dDtEmiss)
		                                                  
	TRB->DT_DIA		:= aRetData[1][1]											// Data Dia
	TRB->DT_MESANO	:= Substr(aRetData[2][2],1,3) + "/" + aRetData[3][1]		// Data Mes/Ano - Ex: Jan/2013	
	TRB->DT_ANO		:= aRetData[3][1]								   			// Data Ano - Ex: 2013
	TRB->DT_TRIM	:= aRetData[2][3] + aRetData[3][1]							// Data Trimestre/Ano - Ex: 1T2013     
	
	
	
	MsUnlock()
	
	dbSelectArea("ETQ")
	DBSKIP()
Enddo

If Select("ETQ") > 0
	dbSelectArea("ETQ")
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
Static Function ConvData(dDtEmiss)
                
Local aRetData := {{0},{0,"",""},{""}}

If ValType(dDtEmiss) <> "D"
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
aRetData[1][1] := Day(ddtemiss)
aRetData[1][1] := Str(aRetData[1][1])
aRetData[1][1] := Alltrim(aRetData[1][1])

// Mes
aRetData[2][1]	:= Month(ddtemiss)
aRetData[2][3] := Alltrim(aRetData[2][3])		// Trimestre

// Ano
aRetData[3][1] := Year(ddtemiss) 
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
PutSx1(cPerg, '01', 'Etiqieta de        ?','' ,'' , 'mv_ch1', 'C', 06, 0, 0, 'G', '', ''   ,'','','mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Etiqueta até       ?','' ,'' , 'mv_ch2', 'C', 06, 0, 0, 'G', '', ''   ,'','','mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Emissao de         ?','' ,'' , 'mv_ch3', 'D', 08, 0, 0, 'G', '', ''   ,'','','mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Emissao até        ?','' ,'' , 'mv_ch4', 'D', 08, 0, 0, 'G', '', ''   ,'','','mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Produto de         ?','' ,'' , 'mv_ch5', 'C', 15, 0, 0, 'G', '', 'SB1','','','mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Produto até        ?','' ,'' , 'mv_ch6', 'C', 15, 0, 0, 'G', '', 'SB1','','','mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '07', 'Ord. Produção de   ?','' ,'' , 'mv_ch7', 'C', 13, 0, 0, 'G', '', 'SC2','','','mv_par07',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '08', 'Ord. Produção até  ?','' ,'' , 'mv_ch8', 'C', 13, 0, 0, 'G', '', 'SC2','','','mv_par08',,,'','','','','','','','','','','','','','')
Return
