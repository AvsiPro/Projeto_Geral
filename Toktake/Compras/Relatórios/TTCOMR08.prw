  
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
¦¦¦Funçào    ¦COMPRAS() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦13.04.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RELATORIO DE COMPRAS E TRANSFERENCIAS		              ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                              	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTCOMR08()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	Endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦13.04.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS		                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "COMTRAN"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("COMPRAS_TRANSFERENCIA","RELATORIO DE COMPRAS E ENTRADAS DE TRANSFERENCIAS","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR AS NOTAS DE COMPRAS E ENTRADAS DE TRANSFERENCIAS")
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/                                    
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Nota de Entradas e Transferencias"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
    
	TRCell():New(oSection1,"TPENTRE"	,"TRB"	,"T. ENTRADA	"	,"@!"			,20)
	TRCell():New(oSection1,"FILIAL"		,"TRB"	,"FILIAL	"	,"@!"			,02)
	TRCell():New(oSection1,"DESCFIL"	,"TRB"	,"DESC_FILIAL"	,"@!"			,02)
	TRCell():New(oSection1,"NUMPED"		,"TRB"	,"NUM_PEDIDO"	,"@!"			,06)
	TRCell():New(oSection1,"DATEMP"		,"TRB"	,"DAT_EMI_PED"	,    			,08)
	TRCell():New(oSection1,"DATPENTP"	,"TRB"	,"DAT_P/ ENT_PED",    			,08)	
	TRCell():New(oSection1,"NOTA"		,"TRB"	,"NOTA	"		,"@!"			,09)
	TRCell():New(oSection1,"SERIE"		,"TRB"	,"SERIE	"		,"@!"			,03)
	TRCell():New(oSection1,"EMISSAO"	,"TRB"	,"EMISSAO	"	,    			,08)	
	TRCell():New(oSection1,"CONTROLE"	,"TRB"	,"CTRL DE ETIQUETA	","@!"		,10)	
	TRCell():New(oSection1,"DAT_PN"		,"TRB"	,"DAT_PRE_NOT"	,    			,08)
	TRCell():New(oSection1,"DAT_DIGIT"	,"TRB"	,"DATA_DIGIT"	,    			,08)	
	TRCell():New(oSection1,"COD_FOR"	,"TRB"	,"COD_FORN"		,"@!"			,06)
	TRCell():New(oSection1,"FORNECE"	,"TRB"	,"FORNECEDOR"	,"@!"			,40)	
	TRCell():New(oSection1,"LOJA"		,"TRB"	,"LOJA	"		,"@!"			,04)	
	TRCell():New(oSection1,"CNPJ"		,"TRB"	,"CNPJ/CPF "	,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"ESTADO"		,"TRB"	,"ESTADO	"	,"@!"			,02) 
	TRCell():New(oSection1,"NATUREZA"	,"TRB"	,"NATUREZA"		,"@!"			,10)		
	TRCell():New(oSection1,"ITEM"		,"TRB"	,"ITEM_NOTA"	,"@!"			,04) 
	TRCell():New(oSection1,"PRODUTO"	,"TRB"	,"COD_PROD"		,"@!"			,15)
	TRCell():New(oSection1,"DESCPRO"	,"TRB"	,"DESC_PROD"	,"@!"			,30)	
	TRCell():New(oSection1,"UNI_MED"	,"TRB"	,"UNI_MED"		,"@!"			,02)	
	TRCell():New(oSection1,"SUBGRUP"	,"TRB"	,"SUB_GRUPO"	,"@!"			,04)
	TRCell():New(oSection1,"DESCSUBG"	,"TRB"	,"DESC_SUBGRUP"	,"@!"			,30)	
	TRCell():New(oSection1,"GRUPO"		,"TRB"	,"CATEGORIA"	,"@!"			,04)
	TRCell():New(oSection1,"DESCGRUP"	,"TRB"	,"DESC_CATEGORIA","@!"			,30)			
	TRCell():New(oSection1,"SECAO"		,"TRB"	,"SECAO"		,"@!"			,04)
	TRCell():New(oSection1,"DESCSEC"	,"TRB"	,"DESC_SECAO"	,"@!"			,30)	
	TRCell():New(oSection1,"LINHA"		,"TRB"	,"LINHA    "	,"@!"			,03)
	TRCell():New(oSection1,"DESCLIN"	,"TRB"	,"DESC_LINHA"	,"@!"			,30)		
	TRCell():New(oSection1,"LOCALPD"	,"TRB"	,"ARMAZEM	"	,"@!"			,06)
	TRCell():New(oSection1,"NCM"		,"TRB"	,"NCM		"	,"@!",10)
	TRCell():New(oSection1,"GRUPTRIB"	,"TRB"	,"GRUPO_TRIBUTAÇÃO"	,"@!"		,6)
	TRCell():New(oSection1,"DESCGRTRI"	,"TRB"	,"DESC_GRUP_TRIB","@!"			,30) 	
	TRCell():New(oSection1,"TES"		,"TRB"	,"TES		"	,"@!"			,03)
	TRCell():New(oSection1,"CFOP "		,"TRB"	,"CFOP	"		,"@!"			,05)
	TRCell():New(oSection1,"TEXTO"		,"TRB"	,"TEXT_TES"		,"@!",30)
	TRCell():New(oSection1,"FINALID"	,"TRB"	,"FINALID_TES"	,"@!",30)
	TRCell():New(oSection1,"QT_UNID_UN"	,"TRB","QTDE_UNID_UNICA"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"SEGUNID"	,"TRB","SEGUNDA UNIDADE"	,"@!"			,4)
	TRCell():New(oSection1,"FATCONV"	,"TRB","FATOR_CONVEÇÃO" 	,"@E 999,999.99",18)
	TRCell():New(oSection1,"TIPCONV"	,"TRB","TIPO_CONVENÇÃO"		,"@!"			,15)	
	TRCell():New(oSection1,"QTDE"		,"TRB"	,"QTDE	"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"PR_UNIT"	,"TRB"	,"PR_UNIT	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"TOTAL"		,"TRB"	,"VLR.TOTAL PRODUTOS","@E 999,999.99",18)
	TRCell():New(oSection1,"DESCONTO"	,"TRB"	,"DESCONTO"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"FRETE"		,"TRB"	,"FRETE	"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"SEGURO"		,"TRB"	,"SEGURO	"	,"@E 999,999.99",18) 	
	TRCell():New(oSection1,"DESPESAS"	,"TRB"	,"DESPESAS"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"ICMS_ST"	,"TRB"	,"VLR.ICMS_ST	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"VALIPI"		,"TRB"	,"VLR.IPI	"	,"@E 999,999.99",18)		
	TRCell():New(oSection1,"VALTOT"		,"TRB"	,"VLR.TOTAL_NOTA"	,"@E 999,999.99",18)	
	TRCell():New(oSection1,"BASEICM"	,"TRB"	,"BASE.CALC_ICMS "	,"@E 999,999.99",18)
	TRCell():New(oSection1,"ALIQICM"	,"TRB"	,"ALIQ_ICM "	,"@E 999,999.99",18)			
	TRCell():New(oSection1,"ICMS"		,"TRB"	,"ICMS.DESTACADO_NOTA","@E 999,999.99",18) 
&&	TRCell():New(oSection1,"BASEICMST"	,"TRB"	,"BASE.CALC_ICMS.ST ","@E 999,999.99",16)&&NOVA COLUNA
	TRCell():New(oSection1,"IMP_IMP"	,"TRB"	,"IMP.IMPOTACAO","@E 999,999.99",18)			
	TRCell():New(oSection1,"VALIRRF"	,"TRB"	,"VALIRRF	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"VALISS"		,"TRB"	,"VALISS "		,"@E 999,999.99",18)			
	TRCell():New(oSection1,"VALINS"		,"TRB"	,"VALISNS	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"PISCOFINS"	,"TRB"	,"PIS/CONFINS	"	,"@!",05)			
	TRCell():New(oSection1,"CONFINS"	,"TRB"	,"PIS	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"PIS"   		,"TRB"	,"CONFINS	"	,"@E 999,999.99",18)	
	TRCell():New(oSection1,"VENCREAL"	,"TRB"	,"VENCIMENTO REAL	"	,,08)
	TRCell():New(oSection1,"BAIXA"		,"TRB"	,"BAIXA_TITULO"	,    ,08)
	TRCell():New(oSection1,"BAIXADO" 	,"TRB"	,"VAL_BAIXADO"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"SALDO"		,"TRB"	,"SALDO "		,"@E 999,999.99",18)
&&	TRCell():New(oSection1,"TECNCMQ"	,"TRB"	,"TEC/NCM/QUAL"	,"@!",16)	
	TRCell():New(oSection1,"ITEMCONT"	,"TRB"	,"ITEM_CONTAB"	,"@!",20)
	TRCell():New(oSection1,"CONTACON"	,"TRB"	,"CONTA_CONTAB"	,"@!",15)
	TRCell():New(oSection1,"CENTCUST"	,"TRB"	,"CENTRO_CUSTO"	,"@!",30)
&&	TRCell():New(oSection1,"PACELAS"	,"TRB"	,"PACELAS"	,"@!",20)
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦13.04.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
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

     Local dtBaix
     Local clTabSec1	:="Z5"
     Local clTabSec2	:="Z4"
     Local clTabSec3	:="21"
     Local clDescSec3   :=SPACE(30)
     Local clDescSec1 	:=SPACE(30)
     Local clDescSec2	:=SPACE(30)
     Local clDescLin	:=SPACE(30)
     Local clDescg		:=SPACE(30)
     Local clFilial     :="01"
	 Local clDescFil    :=""
     Local cCampo 
	 Local cUserLG 
	 Local cUsuarioI
	 Local cDataI
	 Local nlVal
	 Local nlSald
	 Local alParc :={}
	 Local clParc :=""      
	      
	/*-------------------------------|
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
	
	AADD(_aStru,{"TPENTRE","C",20,0})
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"COD_FOR","C",06,0})
	AADD(_aStru,{"FORNECE","C",40,0})	
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"CNPJ","C",14,0})
	AADD(_aStru,{"NATUREZA","C",10,0})
	AADD(_aStru,{"ITEM","C",04,0})	
	AADD(_aStru,{"PRODUTO","C",15,0})
	AADD(_aStru,{"DESCPRO","C",30,0})
	AADD(_aStru,{"UNI_MED","C",02,0})
	AADD(_aStru,{"SUBGRUP","C",04,0})
	AADD(_aStru,{"LOCALPD","C",06,0})
	AADD(_aStru,{"TES","C",03,0})
	AADD(_aStru,{"CFOP","C",05,0})
	AADD(_aStru,{"QTDE","N",14,4})
	AADD(_aStru,{"PRCCOM","N",14,2})
	AADD(_aStru,{"ALIQICM","N",05,2})
	AADD(_aStru,{"PISCOFINS","C",5,0})
	AADD(_aStru,{"IMP_IMP","N",14,4})
	AADD(_aStru,{"VALIRRF","N",14,4})
	AADD(_aStru,{"VALIPI","N",14,4})
	AADD(_aStru,{"VALISS","N",14,4})
	AADD(_aStru,{"VALINS","N",14,4})
	AADD(_aStru,{"TECNCMQ","C",16,0})
	AADD(_aStru,{"ITEMCONT","C",20,0})
	AADD(_aStru,{"GRUPTRIB","C",06,0})
	AADD(_aStru,{"DESCGRTRI","C",30,0})
	AADD(_aStru,{"CONTACON","C",20,0})
	AADD(_aStru,{"CENTCUST","C",9,0})
	AADD(_aStru,{"TOTAL","N",14,4})
	AADD(_aStru,{"ICMS","N",14,4})
	AADD(_aStru,{"ICMS_ST","N",14,4})
	AADD(_aStru,{"PIS","N",14,4})
	AADD(_aStru,{"CONFINS","N",14,4})
	AADD(_aStru,{"TEXTO","C",20,0})
	AADD(_aStru,{"FINALID","C",254,0})                                 
	AADD(_aStru,{"PR_UNIT","N",14,4})
	AADD(_aStru,{"DESCONTO","N",14,4})
	AADD(_aStru,{"FRETE","N",14,4})
	AADD(_aStru,{"SEGURO","N",14,4})
	AADD(_aStru,{"DESPESAS","N",14,4})
	AADD(_aStru,{"VALTOT","N",14,4})
	AADD(_aStru,{"BAIXADO","N",14,4})
	AADD(_aStru,{"SALDO","N",14,4})	
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"DESCFIL","C",35,0})
	AADD(_aStru,{"ESTADO","C",02,0})
	AADD(_aStru,{"EMISSAO","D",08,0})
	AADD(_aStru,{"DAT_DIGIT","D",08,0})	
	AADD(_aStru,{"DATPENTP","D",08,0})
	AADD(_aStru,{"DATEMP","D",08,0})
	AADD(_aStru,{"DAT_PN","D",08,0})
	AADD(_aStru,{"VENCREAL","D",08,0})
	AADD(_aStru,{"BAIXA","D",08,0})
	AADD(_aStru,{"NCM","C",10,0}) 
	AADD(_aStru,{"GRUPO","C",04,0})
	AADD(_aStru,{"SECAO","C",04,0})
	AADD(_aStru,{"LINHA","C",03,0})	
	AADD(_aStru,{"DESCSUBG","C",30,0})
	AADD(_aStru,{"DESCSEC","C",30,0}) 	
	AADD(_aStru,{"DESCGRUP","C",30,0})
	AADD(_aStru,{"DESCLIN","C",30,0})
	AADD(_aStru,{"NUMPED","C",06,0}) 
	AADD(_aStru,{"CONTROLE","C",10,0})
	AADD(_aStru,{"ICMSTRIB","N",14,4})
	AADD(_aStru,{"ICMSISEN","N",14,4})
	AADD(_aStru,{"ICMSOUTR","N",14,4})
	AADD(_aStru, {"FATCONV","N",14,4})
	AADD(_aStru, {"TIPCONV","C",2,0})
	AADD(_aStru, {"SEGUNID","C",6,0})
	AADD(_aStru, {"QT_UNID_UN","N",14,4})	
	AADD(_aStru, {"TOTALSDES","N",14,4})
	AADD(_aStru, {"BASEICM","N",14,4})	
   //	AADD(_aStru, {"PACELAS","C",20,0})	
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"FORNECE",,,"Selecionando Registros...")
	
	/*------------------------------------------------------------------|
	| Montagem da query para os dados das notas fiscais de entrada      |
	|------------------------------------------------------------------*/
	
	clSql:= " SELECT "
	clSql+= "	'Compras' 		AS TIP,D1_FILIAL 	   	AS FILIAL  		"
	clSql+= "	,D1_DOC 	 	AS DOC,D1_SERIE 	   	AS SERIE        "
	clSql+= "	,D1_EMISSAO 	AS EMISSAO,D1_DTDIGIT  	AS DIGITACAO    "
	clSql+= "	,D1_FORNECE 	AS FORNECE,D1_LOJA 		AS LOJA         "
	clSql+= "	,A2_NOME 		AS NOME,A2_EST 	    	AS ESTADO       "
	clSql+= "	,A2_CGC 	 	AS CGC,A2_NATUREZ 		AS NATUREZA     "
	clSql+= "	,D1_ITEM 		AS ITEM,D1_COD 		   	AS COD          "
	clSql+= "	,B1_DESC 		AS DESCP,B1_UM 	    	AS UM           "
	clSql+= "	,B1_XSUBGRU 	AS XSUBGRU,B1_GRTRIB 	AS GRTRIB       "
	clSql+= "	,B1_POSIPI 		AS POSIPI,D1_LOCAL 	   	AS LOCALP       "
	clSql+= "	,D1_TES 	 	AS TES,D1_CONTA	    	AS CONTA        "
	clSql+= "	,D1_ITEMCTA  	AS ITEMCTA,D1_CC 		AS CC           "
	clSql+= "	,D1_CF 			AS CF,D1_QUANT 		   	AS QUANT        "
	clSql+= "	,D1_VUNIT 	 	AS VUNIT,D1_TOTAL 	    AS TOTAL        "
	clSql+= "	,D1_VALDESC  	AS VALDESC,D1_VALFRE 	AS VALFRE       "
	clSql+= "	,D1_SEGURO 		AS SEGURO,D1_DESPESA   	AS DESPESA     "
	clSql+= "	,D1_PICM 	 	AS PICM,D1_VALICM 	    AS VALICM       "
	clSql+= "	,D1_ICMSRET 	AS ICMSRET,D1_VALIMP5 	AS VALIMP5      "
	clSql+= "	,B1_TIPCONV 	AS  TIPCONV, B1_CONV  	AS CONVE        "
	clSql+= "	,B1_SEGUM 	    AS SEGUM,'QUNICPROD'=CASE WHEN B1_TIPCONV='M' "
	clSql+= "	THEN (D1_QUANT * B1_CONV) ELSE D1_QUANT END             "
	clSql+= "	,F1_VALMERC 	AS VALMERC,D1_BASEICM  	AS BASEICM      "
	clSql+= "	,D1_VALIMP6 	AS VALIMP6,D1_VALIPI   	AS VALIPI       "
	clSql+= "	,D1_II 			AS II,D1_VALIRR 	   	AS VALIRR       "
	clSql+= "	,D1_VALISS 	 	AS VALISS,D1_VALINS    	AS VALINS       "
	clSql+= "	,D1_TEC 	  	AS TEC,F4_TEXTO 		AS TEXTO        "
	clSql+= "	,B1_GRUPO 		AS GRUPO,B1_XSECAO 	   	AS XSECAO       "
	clSql+= "	,B1_XFAMILI  	AS XFAMILI, B1_XPISCOF 	AS XPISCOF      "
	clSql+= "	,F4_FINALID 	AS FINALID                              "
	clSql+= "	,((D1_TOTAL + D1_SEGURO + D1_VALFRE + D1_DESPESA + D1_VALIPI + D1_ICMSRET )- D1_VALDESC) AS VALBRUT "
	clSql+= "	,F1_USERLGI 	AS USERLGI,	F1_CONTROL 	AS CONTROL      "
	clSql+= "	,C7_EMISSAO 	AS DATEMP,C7_DATPRF 	AS DATPRF       "
	clSql+= "	,C7_NUM 	  	AS NUM,C7_COND  		AS COND         "
	clSql+= "	,( D1_QUANT * D1_VUNIT) 			   	AS VALSDECONT   "
		                                                                
	clSql+= " FROM "+RetSQLName("SD1")+" AS SD1		"
	clSql+= " INNER JOIN "+RetSQLName("SB1")+" AS SB1 "
	clSql+= "	ON	D1_COD = B1_COD                 "
	clSql+= "	AND SD1.D_E_L_E_T_ = SB1.D_E_L_E_T_ " 
	clSql+= " LEFT OUTER JOIN "+RetSQLName("SA2")+" AS SA2 "
	clSql+= "	ON D1_FORNECE = A2_COD              "
	clSql+= "	AND  D1_LOJA = A2_LOJA              "
	clSql+= "	AND SD1.D_E_L_E_T_ = SA2.D_E_L_E_T_ " 
	clSql+= " INNER JOIN "+RetSQLName("SF4")+" AS SF4 "
	clSql+= "	ON  D1_TES =F4_CODIGO               "
	clSql+= "	AND D1_FILIAL=F4_FILIAL             "
	clSql+= "	AND SD1.D_E_L_E_T_ = SF4.D_E_L_E_T_ "
	clSql+= " LEFT OUTER JOIN "+RetSQLName("SF1")+" AS SF1 "
	clSql+= "	ON D1_DOC=F1_DOC                    "
	clSql+= "	AND D1_SERIE=F1_SERIE               "
	clSql+= "	AND D1_FILIAL=F1_FILIAL             "
	clSql+= "	AND  D1_FORNECE=F1_FORNECE          "
	clSql+= "	AND D1_LOJA=F1_LOJA                 "
	clSql+= "	AND D1_DTDIGIT=F1_DTDIGIT           "
	clSql+= "	AND  SD1.D_E_L_E_T_=SF1.D_E_L_E_T_  "  
	clSql+= " LEFT OUTER JOIN "+RetSQLName("SC7")+" AS SC7 "
	clSql+= "	ON D1_FORNECE=C7_FORNECE            "
	clSql+= "	AND D1_PEDIDO=C7_NUM                "
	clSql+= "	AND D1_ITEMPC=C7_ITEM               "
	clSql+= "	AND D1_FILIAL=C7_FILIAL             "
	clSql+= "	AND SC7.D_E_L_E_T_=''               "
	clSql+= " WHERE (D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	clSql+= " 	AND (D1_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')  "
	clSql+= " 	AND(D1_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') "
	clSql+= " 	AND(D1_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "
	clSql+= " 	AND(D1_COD BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "	
	clSql+= " 	AND D1_TIPO ='N' AND (F4_DUPLIC = 'S')   "
	 
	clSql+= " UNION ALL                                 "
	
	clSql+= " SELECT                                    "
	clSql+= "	'Transferencias' AS TIP,D1_FILIAL 	   	AS FILIAL "
	clSql+= "	,D1_DOC 	 	AS DOC,D1_SERIE 	   	AS SERIE          "
	clSql+= "	,D1_EMISSAO 	AS EMISSAO,D1_DTDIGIT  	AS DIGITACAO      "
	clSql+= "	,D1_FORNECE 	AS FORNECE,D1_LOJA 		AS LOJA           "
	clSql+= "	,A1_NOME 		AS NOME,A1_EST 	    	AS ESTADO         "
	clSql+= "	,A1_CGC 	 	AS CGC,A1_NATUREZ 		AS NATUREZA       "
	clSql+= "	,D1_ITEM 		AS ITEM,D1_COD 		   	AS COD			  " 
	clSql+= "	,B1_DESC 		AS DESCP,B1_UM 	    	AS UM             "
	clSql+= "	,B1_XSUBGRU 	AS XSUBGRU,B1_GRTRIB 	AS GRTRIB         "
	clSql+= "	,B1_POSIPI 		AS POSIPI,D1_LOCAL 	   	AS LOCALP         "
	clSql+= "	,D1_TES 	 	AS TES,D1_CONTA	    	AS CONTA          "
	clSql+= "	,D1_ITEMCTA  	AS ITEMCTA,D1_CC 		AS CC             "
	clSql+= "	,D1_CF 			AS CF,D1_QUANT 		   	AS QUANT          "
	clSql+= "	,D1_VUNIT 	 	AS VUNIT,D1_TOTAL 	    AS TOTAL          "
	clSql+= "	,D1_VALDESC  	AS VALDESC,D1_VALFRE 	AS VALFRE         "
	clSql+= "	,D1_SEGURO 		AS SEGURO,D1_DESPESA   	AS DESPESA       "
	clSql+= "	,D1_PICM 	 	AS PICM,D1_VALICM 	    AS VALICM         "
	clSql+= "	,D1_ICMSRET 	AS ICMSRET,D1_VALIMP5 	AS VALIMP5        "
	clSql+= "	,B1_TIPCONV 	AS  TIPCONV, B1_CONV  	AS CONVE          "
	clSql+= "	,B1_SEGUM 	    AS SEGUM,'QUNICPROD'=CASE WHEN B1_TIPCONV='M' "
	clSql+= "	THEN (D1_QUANT * B1_CONV) ELSE D1_QUANT END               "
	clSql+= "	,F1_VALMERC 	AS VALMERC,D1_BASEICM  	AS BASEICM        "
	clSql+= "	,D1_VALIMP6 	AS VALIMP6,D1_VALIPI   	AS VALIPI         "
	clSql+= "	,D1_II 			AS II,D1_VALIRR 	   	AS VALIRR         "
	clSql+= "	,D1_VALISS 	 	AS VALISS,D1_VALINS    	AS VALINS         "
	clSql+= "	,D1_TEC 	  	AS TEC,F4_TEXTO 		AS TEXTO          "
	clSql+= "	,B1_GRUPO 		AS GRUPO,B1_XSECAO 	   	AS XSECAO         "
	clSql+= "	,B1_XFAMILI  	AS XFAMILI, B1_XPISCOF 	AS XPISCOF        "
	clSql+= "	,F4_FINALID 	AS FINALID                                "
	clSql+= "	,((D1_TOTAL + D1_SEGURO + D1_VALFRE + D1_DESPESA + D1_VALIPI + D1_ICMSRET )- D1_VALDESC) AS VALBRUT "
	clSql+= "	,F1_USERLGI 	AS USERLGI,	F1_CONTROL 	AS CONTROL        "
	clSql+= "	,'' 			AS DATEMP,'' 			AS DATPRF         "
	clSql+= "	,'' 	  		AS NUM,''  				AS COND           "
	clSql+= "	,( D1_QUANT * D1_VUNIT) 			   	AS VALSDECONT     "
			                                                              "
	clSql+= " FROM "+RetSQLName("SF2")+" AS SF2 INNER JOIN "+RetSQLName("SD2")+" AS SD2  "
	clSql+= " ON F2_FILIAL=D2_FILIAL         "
	clSql+= "	AND  F2_DOC=D2_DOC           "
	clSql+= "	AND F2_SERIE=D2_SERIE        "
	clSql+= "	AND F2_CLIENTE=D2_CLIENTE    "
	clSql+= "	AND F2_LOJA=D2_LOJA          "
	clSql+= "	AND F2_EMISSAO=D2_EMISSAO    "
	clSql+= "	AND SD2.D_E_L_E_T_=''     "
	clSql+= "	INNER JOIN "+RetSQLName("SF1")+" AS SF1            "
	clSql+= " ON F2_XTRANSF=F1_FILIAL        "
	clSql+= "	AND F2_DOC=F1_DOC            "
	clSql+= "	AND F2_SERIE=F1_SERIE        "
	clSql+= "	AND SF1.D_E_L_E_T_=''     "
	clSql+= "	INNER JOIN "+RetSQLName("SD1")+" AS SD1            "
	clSql+= " ON F1_FILIAL=D1_FILIAL         "
	clSql+= "	AND D2_DOC=D1_DOC            "
	clSql+= "	AND D2_SERIE=D1_SERIE        "
	clSql+= "	AND D2_COD=D1_COD            "
	clSql+= "	AND D2_ITEM=D1_ITEM          "
	clSql+= "	AND F1_FORNECE=D1_FORNECE    "
	clSql+= "	AND F1_LOJA=D1_LOJA          "
	clSql+= "	AND F1_DTDIGIT =D1_DTDIGIT   "
	clSql+= "	AND SD1.D_E_L_E_T_=''     "
	clSql+= "	INNER JOIN "+RetSQLName("SF4")+" AS SF4            "
	clSql+= " ON D1_FILIAL=F4_FILIAL         "
	clSql+= "	AND D1_TES=F4_CODIGO         "
	clSql+= "	AND SF4.D_E_L_E_T_=''     "
	clSql+= "	INNER JOIN "+RetSQLName("SB1")+" AS SB1            "
	clSql+= " ON D1_COD=B1_COD               "
	clSql+= "	AND SB1.D_E_L_E_T_=''     "
	clSql+= "	INNER JOIN "+RetSQLName("SA1")+" AS SA1            "
	clSql+= " ON D1_FORNECE=A1_COD           "
	clSql+= "	AND D1_LOJA=A1_LOJA          "
	clSql+= "	AND SA1.D_E_L_E_T_=''     "
	clSql+= " WHERE F2_XFINAL='3'            "
	clSql+= "	AND F2_CLIENTE='000001'      "
	clSql+= "	AND F2_XTRANSF<>''           "
	clSql+= "	AND F2_XTRANSF <> F2_FILIAL  "		
	clSql+= " 	AND (D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	clSql+= " 	AND (D1_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')  "
	clSql+= " 	AND(D1_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') "
	clSql+= " 	AND(D1_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "
	clSql+= " 	AND(D1_COD BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "	
	clSql+= " 	AND D1_TIPO ='N' AND (F4_DUPLIC = 'N')   "
	clSql+= " ORDER BY D1_DOC,D1_COD "
		
	IF SELECT("CTRA") > 0
		dbSelectArea("CTRA")
		DbCloseArea()
	ENDIF 
	
	MemoWrite("CTRARAS.SQL",clSql) 
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clSql),"CTRA",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	
	TcSetField("CTRA","TOTAL"	,"N",14,4)
	TcSetField("CTRA","QUANT"	,"N",14,4)
	TcSetField("CTRA","VALDESC"	,"N",14,4)
	TcSetField("CTRA","VALFRE"	,"N",14,4)
	TcSetField("CTRA","SEGURO"	,"N",14,4)
	TcSetField("CTRA","DESPESA"	,"N",14,4)
	TcSetField("CTRA","VALICM"	,"N",14,4)
	TcSetField("CTRA","ICMSRET"	,"N",14,4)
	TcSetField("CTRA","VALICM"	,"N",14,4)
	TcSetField("CTRA","PICM"	,"N",05,4)
	TcSetField("CTRA","II"		,"N",14,4)
	TcSetField("CTRA","VALIRR"	,"N",14,4)
	TcSetField("CTRA","VALISS"	,"N",14,4)
	TcSetField("CTRA","VALINS"	,"N",14,4)
	TcSetField("CTRA","VALIMP5"	,"N",14,4)
	TcSetField("CTRA","VALIMP6"	,"N",14,4)
	TcSetField("CTRA","VALIPI"	,"N",14,4)                                        
	TcSetField("CTRA","EMISSAO"	,"D",08,0)
	TcSetField("CTRA","DATEMP"	,"D",08,0)
	TcSetField("CTRA","DIGITACAO","D",08,0)
	TcSetField("CTRA","DATPRF"	,"D",08,0)	
	TcSetField("CTRA","VALSDECONT"	,"N",14,4)
			
	dbSelectArea("CTRA")
	dbGotop()
	
	Do While CTRA->(!Eof())
	
		DBSELECTAREA("SE2")
		DBSETORDER(6)
	    IF DBSEEK(XFILIAL("SE2")+CTRA->FORNECE+CTRA->LOJA+CTRA->SERIE+CTRA->DOC)		    	    
			dtBaix:= SE2->E2_BAIXA 
			dtVencTit:= SE2->E2_VENCREA   
			nlVal 	 := (SE2->E2_VALOR-SE2->E2_SALDO)
			nlSald	 := SE2->E2_SALDO			     
	    ENDIF
	     MsProcTxt("Processando Item "+CTRA->COD)
	     	     
	     DBSELECTAREA("SX5")
	     DBSETORDER(1)
	     IF DBSEEK(XFILIAL("SX5")+clTabSec1+CTRA->XSECAO)
	     	clDescSec1:=X5_DESCRI
	     ENDIF
	     IF DBSEEK(XFILIAL("SX5")+clTabSec2+CTRA->XSUBGRU)
	     	clDescSec2:=X5_DESCRI
	     ENDIF
	      IF DBSEEK(XFILIAL("SX5")+clTabSec3+CTRA->GRTRIB)
	     	clDescSec3:=X5_DESCRI
	     ENDIF
	     
	     DBSELECTAREA("SBM")
	     DBSETORDER(1)
	     IF DBSEEK(clFilial + CTRA->GRUPO)
	     	clDescg:=SBM->BM_DESC
	     ENDIF
	          
	     DBSELECTAREA("ZZ2")
	     DBSETORDER(1)
	     IF DBSEEK(XFILIAL("ZZ2")+CTRA->XFAMILI)
	     	clDescLin:=ZZ2_DESCRI
	     ENDIF
		If CTRA->USERLGI <> ''	
			cCampo :="CTRA->USERLGI"
			cUserLG :=Embaralha(&cCampo,1)
			cUsuarioI:= If(!Empty(cUserLg),Subs(cUserLg,1,15),"")
			cDataI   := IIF(!Empty(cUserLg),CTOD("01/01/96") + Load2in4(Substr(cUserLg,16)),Ctod(Space(8)))
		Endif
		
		// Psiciona para trazer a descrição da filial.
		
		DbSelectArea("SM0")
		_aAreaSM0:= GetArea()
		DBSETORDER(1)
		IF DBSEEK(cEmpAnt + CTRA->FILIAL)
			clDescFil:=SM0->M0_FILIAL
		ENDIF
		RestArea(_aAreaSM0)
		
	  	/*
	  	alParc := CONDICAO(CTRA->VALMERC,CTRA->COND,,CTRA->DIGITACAO)
		IF LEN(alParc)>1
			clParc:=str(LEN(alParc))+"  Parcelas"
		ELSE
			clParc:=str(LEN(alParc))+"  Parcelas"
		ENDIF
		*/
	           
	     DbSelectArea("TRB")
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/ 
	
	     RecLock("TRB",.T.)  
	     	                     
	     	TRB->TPENTRE	:= CTRA->TIP	        
	     	TRB->COD_FOR	:= CTRA->FORNECE
	      	TRB->FORNECE	:= CTRA->NOME	      	
	      	TRB->LOJA		:= CTRA->LOJA
	      	TRB->NATUREZA	:= CTRA->NATUREZA
		    TRB->CNPJ		:= CTRA->CGC		    	      	
		    TRB->NOTA		:= CTRA->DOC
	    	TRB->ITEM 		:= CTRA->ITEM
	    	TRB->PRODUTO	:= CTRA->COD
	        TRB->DESCPRO	:= CTRA->DESCP
	        TRB->UNI_MED	:= CTRA->UM
	        TRB->SUBGRUP	:= CTRA->XSUBGRU
	        TRB->QTDE		:= CTRA->QUANT
	        TRB->PRCCOM		:= CTRA->VUNIT
	        TRB->TOTAL		:= CTRA->TOTAL
	        TRB->TOTALSDES	:= CTRA->VALSDECONT
	        TRB->ICMS_ST	:= CTRA->ICMSRET
	        TRB->PISCOFINS	:= CTRA->XPISCOF
	        TRB->ICMS		:= CTRA->VALICM
	        TRB->PIS		:= CTRA->VALIMP5
	        TRB->CONFINS	:= CTRA->VALIMP6	        
	        TRB->LOCALPD	:= CTRA->LOCALP
	        TRB->SERIE		:= CTRA->SERIE
	        TRB->CFOP		:= CTRA->CF 
	        TRB->TES		:= CTRA->TES
	        TRB->TEXTO		:= CTRA->TEXTO
	        TRB->FINALID   	:= CTRA->FINALID 
	        TRB->PR_UNIT	:= CTRA->VUNIT
	        TRB->DESCONTO	:= CTRA->VALDESC
	        TRB->FRETE		:= CTRA->VALFRE 
	        TRB->SEGURO		:= CTRA->SEGURO
	        TRB->DESPESAS	:= CTRA->DESPESA
	        TRB->VALTOT		:= CTRA->VALBRUT
	        TRB->FILIAL   	:= CTRA->FILIAL
	        TRB->DESCFIL   	:= clDescFil
	        TRB->ESTADO		:= CTRA->ESTADO 
	        TRB->DAT_PN		:= cDataI
	        TRB->DAT_DIGIT	:= CTRA->DIGITACAO	        
	        TRB->EMISSAO	:= CTRA->EMISSAO	        
	        TRB->DATPENTP	:= CTRA->DATPRF	        
	        TRB->DATEMP		:= CTRA->DATEMP	        	        	        
	        TRB->ALIQICM   	:= CTRA->PICM
	        TRB->ITEMCONT	:= CTRA->ITEMCTA
	        TRB->CONTACON	:= CTRA->CONTA
	        TRB->CENTCUST	:= CTRA->CC 
	        TRB->IMP_IMP	:= CTRA->II
	        TRB->VALIRRF	:= CTRA->VALIRR
	        TRB->VALISS		:= CTRA->VALISS
	        TRB->VALINS   	:= CTRA->VALINS
	        TRB->VALIPI   	:= CTRA->VALIPI
	        TRB->GRUPTRIB  	:= CTRA->GRTRIB
	        TRB->BASEICM  	:= CTRA->BASEICM
	        TRB->DESCGRTRI	:= clDescSec3 
	        TRB->TECNCMQ	:= CTRA->TEC
	        TRB->NCM		:= CTRA->POSIPI
	        TRB->VENCREAL	:= dtVencTit
	        TRB->BAIXA		:= dtBaix
	        TRB->GRUPO		:= CTRA->GRUPO
	        TRB->SECAO		:= CTRA->XSECAO
	        TRB->LINHA		:= CTRA->XFAMILI
	        TRB->NUMPED		:= CTRA->NUM    
	        TRB->CONTROLE	:= CTRA->CONTROL 
	        TRB->DESCSUBG	:= clDescSec2
	        TRB->DESCSEC	:= clDescSec1
	        TRB->DESCGRUP	:= clDescg
	        TRB->DESCLIN	:= clDescLin    
	        TRB->BAIXADO	:= nlVal
	        TRB->SALDO		:= nlSald 
	        TRB->FATCONV	:= CTRA->CONVE 
			TRB->TIPCONV	:= CTRA->TIPCONV 
			TRB->SEGUNID	:= CTRA->SEGUM 
			TRB->QT_UNID_UN	:= CTRA->QUNICPROD
			//TRB->PACELAS	:= clParc       
	        	        	         	        	     	        
	    MsUnlock()
	      
		clDescSec1 	:=SPACE(30)
		clDescSec2	:=SPACE(30)
		clDescLin	:=SPACE(30)
		clDescg		:=SPACE(30)	
		clDescSec3  :=SPACE(30)
		cDataI 		:= Ctod(Space(8))
		cCampo     	:=""
	 	cUserLG  	:=""
	 	cUsuarioI	:=""
		nlVal   	:=0
		nlSald  	:=0 
		//clParc		:=""
		alParc :={}   
	
      	dbSelectArea("CTRA")
     	DbSkip()
	Enddo
	dtVenc:=""
	
	If Select("CTRA") > 0
		dbSelectArea("CTRA")
		DbCloseArea()                                      						
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','DTDIGIT de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','DTDIGIT Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Nota de               ?','','','mv_ch3','C',09,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Nota Ate              ?','','','mv_ch4','C',09,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Serie de              ?','','','mv_ch5','C',03,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Serie Ate             ?','','','mv_ch6','C',03,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'07','Filial de             ?','','','mv_ch7','C',02,0,0,'G','','SM0','','','mv_par07',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'08','Filial Ate            ?','','','mv_ch8','C',02,0,0,'G','','SM0','','','mv_par08',,,'','','','','','','','','','','','','','') 			
	PutSx1(cPerg,'09','Produto de             ?','','','mv_ch9','C',15,0,0,'G','','SB1','','','mv_par09',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'10','Produto Ate            ?','','','mv_chA','C',15,0,0,'G','','SB1','','','mv_par10',,,'','','','','','','','','','','','','','') 		

Return

