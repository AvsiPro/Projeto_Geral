  
/*--------------------------|
|Bibliotecas de fun��es		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      // 
 #INCLUDE "TOPCONN.CH"     //
/*-------------------------*/
                                            		
/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �COMPRAS() � Autor � Fabio Sales		    � Data �17.06.2010���
��+----------+------------------------------------------------------------���
���Descri��o � Relat�rio de Compras							              ���
���			 � 															  ���
��+----------+------------------------------------------------------------���
���Uso       � Compras                                              	  ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMPRAS()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	EndIf
Return

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �REPORTDEF() � Autor � Fabio Sales		    � Data �17.06.2010���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��o principal de impress�o   							  ���
���			 � 															  ���
��+----------+------------------------------------------------------------���
���Uso       � Compras                                          	  ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "COMPRAS"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("COMPRAS","RELATORIO DE COMPRAS","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR AS NOTAS DE COMPRAS")
	
	/*------------------------| 		    			           
	| se��o das notas fiscais | 
	|------------------------*/                                    
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Nota de Entrada"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  t�tulo       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
                                                                                    
	TRCell():New(oSection1,"TIPO"		,"TRB"	,"TIPO	"		,"@!"			,15)
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
	TRCell():New(oSection1,"GRUPTRIB"	,"TRB"	,"GRUPO_TRIBUTA��O"	,"@!"		,6)
	TRCell():New(oSection1,"DESCGRTRI"	,"TRB"	,"DESC_GRUP_TRIB","@!"			,30) 	
	TRCell():New(oSection1,"TES"		,"TRB"	,"TES		"	,"@!"			,03)
	TRCell():New(oSection1,"CFOP "		,"TRB"	,"CFOP	"		,"@!"			,05)
	TRCell():New(oSection1,"TEXTO"		,"TRB"	,"TEXT_TES"		,"@!",30)
	TRCell():New(oSection1,"FINALID"	,"TRB"	,"FINALID_TES"	,"@!",30)
	TRCell():New(oSection1,"QT_UNID_UN"	,"TRB","QTDE_UNID_UNICA"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"SEGUNID"	,"TRB","SEGUNDA UNIDADE"	,"@!"			,4)
	TRCell():New(oSection1,"FATCONV"	,"TRB","FATOR_CONVE��O" 	,"@E 999,999.99",18)
	TRCell():New(oSection1,"TIPCONV"	,"TRB","TIPO_CONVEN��O"		,"@!"			,15)	
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
	TRCell():New(oSection1,"ICMSTRIB"	,"TRB"	,"ICMS_TRIBUTADO","@E 999,999.99",18)
	TRCell():New(oSection1,"ICMSISEN"	,"TRB"	,"ICMS_ISENTO	","@E 999,999.99",18)
	TRCell():New(oSection1,"ICMSOUTR"	,"TRB"	,"ICMS_OUTROS	","@E 999,999.99",18)
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
	TRCell():New(oSection1,"DESCCONT"	,"TRB"	,"DESC_CONTAB"	,"@!",30)
	TRCell():New(oSection1,"CENTCUST"	,"TRB"	,"CENTRO_CUSTO"	,"@!",30)
	TRCell():New(oSection1,"PACELAS"	,"TRB"	,"PACELAS"	,"@!",20)
	TRCell():New(oSection1,"REGISTRO"	,"TRB"	,"REGISTRO"	,"9999999999999999999",20)  
	
	//SOLICITACAO GUSTAVO 26/07/12
	TRCell():New(oSection1,"USERCOM"	,"TRB"	,"USERCOM"	,"@!",20)
	TRCell():New(oSection1,"USERSCC"	,"TRB"	,"USERSCC"	,"@!",20)
	TRCell():New(oSection1,"DESCCC"		,"TRB"	,"DESCCC"	,"@!",50)
	
	
			
Return oReport

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �PrintReport() � Autor � Fabio Sales	    � Data �17.06.2010���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��o respons�vel pela imopress�o do relat�rio			  ���
���			 � 															  ���
��+----------+------------------------------------------------------------���
���Uso       � Compras                                               	  ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------| 		    			           
	| sele��o dos dados a serem impressos/carrega o arquivo tempor�rio | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-------------------------| 		    			           
	| imprime a primeira se��o | 
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
	| seleciona os dados a serem impressos/criacao do tempor�rio |
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
	 Local dtVencTit     
	/*-------------------------------|
	| cria��o do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
                                  
	AADD(_aStru,{"TIPO","C",15,0})
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
//	AADD(_aStru,{"CONTACON","C",20,0})   
	AADD(_aStru,{"DESCCONT","C",30,0})   
	
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
	AADD(_aStru,{"FATCONV","N",14,4})
	AADD(_aStru,{"TIPCONV","C",2,0})
	AADD(_aStru,{"SEGUNID","C",6,0})
	AADD(_aStru,{"QT_UNID_UN","N",14,4})	
	AADD(_aStru,{"TOTALSDES","N",14,4})
	AADD(_aStru,{"BASEICM","N",14,4})	
	AADD(_aStru,{"PACELAS","C",20,0})	
	AADD(_aStru,{"REGISTRO","N",30,0})	

	//SOLICITACAO GUSTAVO 26/07/2012
	AADD(_aStru,{"USERCOM","C",25,0})	
	AADD(_aStru,{"USERSCC","C",25,0})	
	AADD(_aStru,{"DESCCC","C",50,0})	

		
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
	
	clQuery := " SELECT D1_TIPO, D1_FILIAL,D1_DOC,D1_SERIE,D1_EMISSAO,D1_DTDIGIT,D1_FORNECE,D1_LOJA,A2_NOME,A2_EST,A2_CGC,A2_NATUREZ,D1_ITEM, "
	clQuery += " D1_COD,B1_DESC,B1_UM,B1_XSUBGRU,B1_GRTRIB,B1_POSIPI,D1_LOCAL,D1_TES,D1_CONTA,D1_ITEMCTA,D1_CC,D1_CF,D1_QUANT, "
	clQuery += " D1_VUNIT,D1_TOTAL,D1_VALDESC,D1_VALFRE,D1_SEGURO,D1_DESPESA,D1_PICM,D1_VALICM,D1_ICMSRET,D1_VALIMP5,B1_TIPCONV, "
	clQuery += " B1_CONV,B1_SEGUM,'QUNICPROD'=CASE WHEN B1_TIPCONV='M' THEN (D1_QUANT * B1_CONV) ELSE D1_QUANT END,F1_VALMERC, "
	clQuery += " D1_BASEICM,D1_VALIMP6,D1_VALIPI,D1_II,D1_VALIRR,D1_VALISS,D1_VALINS,D1_TEC,F4_TEXTO,B1_GRUPO,B1_XSECAO,B1_XFAMILI,"
	clQuery += " B1_XPISCOF,F4_FINALID,((D1_TOTAL + D1_SEGURO + D1_VALFRE + D1_DESPESA + D1_VALIPI + D1_ICMSRET )- D1_VALDESC) AS VALBRUT, "
	clQuery += " F1_USERLGI,F1_CONTROL,C7_EMISSAO,C7_DATPRF,C7_NUM,C7_COND,( D1_QUANT * D1_VUNIT) AS VALSDECONT, "	
	clQuery += " SFT.FT_VALICM AS VALICMTRIB ,SFT.FT_ISENICM AS ISENICM ,SFT.FT_OUTRICM AS OUTRICM,SFT.FT_CODISS AS CODISS,SD1.R_E_C_N_O_  AS REGISTRO"
	
	//SOLICITACAO DO GUSTAVO 26/07/2012
	clQuery += " ,C7_ITEM,C7_USER,C7_NUMSC"
	
	clQuery += " FROM "+RetSQLName("SD1")+" AS SD1 INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	clQuery += " D1_COD = B1_COD AND SD1.D_E_L_E_T_ = SB1.D_E_L_E_T_ "
	
	If cEmpAnt =='02'
		clQuery += " LEFT OUTER JOIN "+RetSQLName("SA2")+" AS SA2 ON D1_FILIAL=A2_FILIAL AND D1_FORNECE = A2_COD AND " 
		clQuery += " D1_LOJA = A2_LOJA AND SD1.D_E_L_E_T_ = SA2.D_E_L_E_T_ "
	Else
		clQuery += " LEFT OUTER JOIN "+RetSQLName("SA2")+" AS SA2 ON D1_FORNECE = A2_COD AND " 
		clQuery += " D1_LOJA = A2_LOJA AND SD1.D_E_L_E_T_ = SA2.D_E_L_E_T_ "
	EndIf
	
	clQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
	clQuery += " D1_TES =F4_CODIGO  AND D1_FILIAL=F4_FILIAL AND SD1.D_E_L_E_T_ = SF4.D_E_L_E_T_ LEFT OUTER JOIN  "
	clQuery += " "+RetSQLName("SF1")+" AS SF1 ON D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FILIAL=F1_FILIAL AND "
	clQuery += " D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND D1_DTDIGIT=F1_DTDIGIT AND  SD1.D_E_L_E_T_=SF1.D_E_L_E_T_   "
	clQuery += " LEFT OUTER JOIN "+RetSQLName("SC7")+" AS SC7 ON D1_FORNECE=C7_FORNECE    "
	clQuery += " AND D1_PEDIDO=C7_NUM  AND D1_ITEMPC=C7_ITEM AND D1_FILIAL=C7_FILIAL AND SC7.D_E_L_E_T_=''  "	
	clQuery += " LEFT OUTER JOIN "+RetSQLName("SFT")+" AS SFT ON D1_FILIAL=FT_FILIAL AND D1_DOC = FT_NFISCAL " 
	clQuery += " AND D1_SERIE=FT_SERIE AND D1_FORNECE=FT_CLIEFOR AND D1_LOJA=FT_LOJA AND D1_COD=FT_PRODUTO "
	clQuery += " AND D1_ITEM=FT_ITEM AND FT_TIPOMOV = 'E'  AND SFT.D_E_L_E_T_<>'*' "		
	clQuery += " WHERE (D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	clQuery += " AND (D1_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	clQuery += " (D1_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
	clQuery += " (D1_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"')AND "
	clQuery += " (D1_COD BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "	
	clQuery += " AND D1_TIPO ='N'  AND (F4_DUPLIC = 'S') AND SD1.D_E_L_E_T_='' " 
	
	clQuery += " UNION ALL"
	
	clQuery += " SELECT D2_TIPO, D2_FILIAL,D2_DOC,D2_SERIE,D2_EMISSAO,D2_EMISSAO AS D1_DTDIGIT,D2_CLIENTE,D2_LOJA,A2_NOME,A2_EST,A2_CGC,A2_NATUREZ,D2_ITEM, "
	clQuery += " D2_COD,B1_DESC,B1_UM,B1_XSUBGRU,B1_GRTRIB,B1_POSIPI,D2_LOCAL,D2_TES,D2_CONTA,D2_ITEMCC,D2_CCUSTO,D2_CF,-D2_QUANT, "
	clQuery += " -D2_PRUNIT,-(D2_TOTAL+D2_DESCON),-D2_DESCON,-D2_VALFRE,-D2_SEGURO,-D2_DESPESA,D2_PICM,-D2_VALICM,-D2_ICMSRET,-D2_VALIMP5,B1_TIPCONV, "
	clQuery += " B1_CONV,B1_SEGUM,'QUNICPROD'=CASE WHEN B1_TIPCONV='M' THEN -(D2_QUANT * B1_CONV) ELSE -D2_QUANT END,-F2_VALMERC, "
	clQuery += " -D2_BASEICM,-D2_VALIMP6,-D2_VALIPI,'' AS D1_II,'' AS D1_VALIRR,-D2_VALISS,-D2_VALINS,'' AS D1_TEC,F4_TEXTO,B1_GRUPO,B1_XSECAO,B1_XFAMILI,"
	clQuery += " B1_XPISCOF,F4_FINALID,-(D2_TOTAL + D2_SEGURO + D2_VALFRE + D2_DESPESA + D2_VALIPI + D2_ICMSRET) AS VALBRUT, "
	clQuery += " F2_USERLGI,'' AS F2_CONTROL,'' AS C7_EMISSAO,'' AS C7_DATPRF,'' AS C7_NUM,'' AS C7_COND,-( D2_QUANT * D2_PRUNIT) AS VALSDECONT, "	
	clQuery += " -SFT.FT_VALICM AS VALICMTRIB ,-SFT.FT_ISENICM AS ISENICM ,-SFT.FT_OUTRICM AS OUTRICM,SFT.FT_CODISS AS CODISS,SD2.R_E_C_N_O_  AS REGISTRO"	
	
	//SOLICITACAO DO GUSTAVO 26/07/2012
	clQuery += " ,'' AS C7_ITEM,'' AS C7_USER,'' AS C7_NUMSC"
	
	clQuery += " FROM "+RetSQLName("SD2")+" AS SD2 INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	clQuery += " D2_COD = B1_COD AND SD2.D_E_L_E_T_ = SB1.D_E_L_E_T_ "
		
	If cEmpAnt =='02'                                                 	
		clQuery += " LEFT OUTER JOIN "+RetSQLName("SA2")+" AS SA2 ON D2_FILIAL=A2_FILIAL AND D2_CLIENTE = A2_COD AND "                                                                            
		clQuery += " D2_LOJA = A2_LOJA AND SD2.D_E_L_E_T_ = SA2.D_E_L_E_T_ "
	Else
		clQuery += " LEFT OUTER JOIN "+RetSQLName("SA2")+" AS SA2 ON D2_CLIENTE = A2_COD AND "                                                                            
		clQuery += " D2_LOJA = A2_LOJA AND SD2.D_E_L_E_T_ = SA2.D_E_L_E_T_ "
	EndIf
	
	clQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
	clQuery += " D2_TES =F4_CODIGO  AND D2_FILIAL=F4_FILIAL AND SD2.D_E_L_E_T_ = SF4.D_E_L_E_T_ LEFT OUTER JOIN  "
	clQuery += " "+RetSQLName("SF2")+" AS SF2 ON D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_FILIAL=F2_FILIAL AND "
	clQuery += " D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2_EMISSAO=F2_EMISSAO AND  SD2.D_E_L_E_T_=SF2.D_E_L_E_T_   "		
	clQuery += " LEFT OUTER JOIN "+RetSQLName("SFT")+" AS SFT ON D2_FILIAL=FT_FILIAL AND D2_DOC = FT_NFISCAL " 
	clQuery += " AND D2_SERIE=FT_SERIE AND D2_CLIENTE=FT_CLIEFOR AND D2_LOJA=FT_LOJA AND D2_COD=FT_PRODUTO "
	clQuery += " AND D2_ITEM=FT_ITEM AND FT_TIPOMOV = 'S'  AND SFT.D_E_L_E_T_<>'*' "		
	clQuery += " WHERE (D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	clQuery += " AND (D2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	clQuery += " (D2_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
	clQuery += " (D2_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"')AND "
	clQuery += " (D2_COD BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "	
	clQuery += " AND D2_TIPO ='D'  AND (F4_DUPLIC = 'S') AND SD2.D_E_L_E_T_='' "
		
	IF SELECT("COMP") > 0
		dbSelectArea("COMP")
		DbCloseArea()
	ENDIF 
	
	MemoWrite("COMPRAS.SQL",clQuery) 
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"COMP",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	
	TcSetField("COMP","D1_TOTAL"	,"N",14,4)
	TcSetField("COMP","D1_QUANT"	,"N",14,4)
	TcSetField("COMP","D1_VALDESC"	,"N",14,4)
	TcSetField("COMP","D1_VALFRE"	,"N",14,4)
	TcSetField("COMP","D1_SEGURO"	,"N",14,4)
	TcSetField("COMP","D1_DESPESA"	,"N",14,4)
	TcSetField("COMP","D1_VALICM"	,"N",14,4)
	TcSetField("COMP","D1_ICMSRET"	,"N",14,4)
	TcSetField("COMP","D1_VALICM"	,"N",14,4)
	TcSetField("COMP","D1_PICM"		,"N",05,4)
	TcSetField("COMP","D1_II"		,"N",14,4)
	TcSetField("COMP","D1_VALIRR"	,"N",14,4)
	TcSetField("COMP","D1_VALISS"	,"N",14,4)
	TcSetField("COMP","D1_VALINS"	,"N",14,4)
	TcSetField("COMP","D1_VALIMP5"	,"N",14,4)
	TcSetField("COMP","D1_VALIMP6"	,"N",14,4)
	TcSetField("COMP","D1_VALIPI"	,"N",14,4)                                        
	TcSetField("COMP","D1_EMISSAO"	,"D",08,0)
	TcSetField("COMP","D1_DTDIGIT"	,"D",08,0)
	TcSetField("COMP","C7_EMISSAO"	,"D",08,0)
	TcSetField("COMP","C7_DATPRF"	,"D",08,0)	
	TcSetField("COMP","VALSDECONT"	,"N",14,4)
//	TcSetField("COMP","REGISTRO"	,"N",30,0)


	//SOLICITACAO GUSTAVO 26/07/12
	TcSetField("COMP","USERCOM"	,"C",25,0)
	TcSetField("COMP","USERSCC"	,"C",25,0)
	TcSetField("COMP","DESCCC"	,"C",50,0)

	
	//VALSDECONT
		
	dbSelectArea("COMP")
	dbGotop()
	
	Do While COMP->(!Eof())
	
		DbSelectArea("SE2")
		DbSetOrder(6)
	    If DbSeek(XFILIAL("SE2")+COMP->D1_FORNECE+COMP->D1_LOJA+COMP->D1_SERIE+COMP->D1_DOC)
	    	IF SE2->E2_TIPO="NF"		    	    
				dtBaix:= SE2->E2_BAIXA 
				dtVencTit:= SE2->E2_VENCREA   
				nlVal 	 := (SE2->E2_VALOR-SE2->E2_SALDO)
				nlSald	 := SE2->E2_SALDO			     
		    EndIf
	    EndIf
	     MsProcTxt("Processando Item "+COMP->D1_COD)
	     	     
	     DBSELECTAREA("SX5")
	     DBSETORDER(1)
	     IF DBSEEK(XFILIAL("SX5")+clTabSec1+COMP->B1_XSECAO)
	     	clDescSec1:=X5_DESCRI
	     ENDIF
	     IF DBSEEK(XFILIAL("SX5")+clTabSec2+COMP->B1_XSUBGRU)
	     	clDescSec2:=X5_DESCRI
	     ENDIF
	      IF DBSEEK(XFILIAL("SX5")+clTabSec3+COMP->B1_GRTRIB)
	     	clDescSec3:=X5_DESCRI
	     ENDIF
	     
	     DBSELECTAREA("SBM")
	     DBSETORDER(1)
	     IF DBSEEK(clFilial + COMP->B1_GRUPO)
	     	clDescg:=SBM->BM_DESC
	     ENDIF
	          
	     DBSELECTAREA("ZZ2")
	     DBSETORDER(1)
	     IF DBSEEK(XFILIAL("ZZ2")+COMP->B1_XFAMILI)
	     	clDescLin:=ZZ2_DESCRI
	     ENDIF
		If COMP->F1_USERLGI <> ''	
			cCampo :="COMP->F1_USERLGI"
			cUserLG :=Embaralha(&cCampo,1)
			cUsuarioI:= If(!Empty(cUserLg),Subs(cUserLg,1,15),"")
			cDataI   := IIF(!Empty(cUserLg),CTOD("01/01/96") + Load2in4(Substr(cUserLg,16)),Ctod(Space(8)))
		Endif
		
		// Psiciona para trazer a descri��o da filial.
		
		DbSelectArea("SM0")
		_aAreaSM0:= GetArea()
		DBSETORDER(1)
		IF DBSEEK(cEmpAnt + COMP->D1_FILIAL)
			clDescFil:=SM0->M0_FILIAL
		ENDIF
		RestArea(_aAreaSM0)
		
		alParc := CONDICAO(COMP->F1_VALMERC,COMP->C7_COND,,COMP->D1_DTDIGIT)
		IF LEN(alParc)>1
			clParc:=str(LEN(alParc))+"  Parcelas"
		ELSE
			clParc:=str(LEN(alParc))+"  Parcelas"
		ENDIF
	           
	     DbSelectArea("TRB")
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/ 
	
	     RecLock("TRB",.T.)                  
	        If COMP->D1_TIPO=="N" 
	        	TRB->TIPO		:= "COMPRAS"
	        Else
		        TRB->TIPO		:= "DEVOLUC�O"
		    EndIf
	     	TRB->COD_FOR	:= COMP->D1_FORNECE
	      	TRB->FORNECE	:= COMP->A2_NOME	      	
	      	TRB->LOJA		:= COMP->D1_LOJA
	      	TRB->NATUREZA	:= COMP->A2_NATUREZ
		    TRB->CNPJ		:= COMP->A2_CGC		    	      	
		    TRB->NOTA		:= COMP->D1_DOC
	    	TRB->ITEM 		:= COMP->D1_ITEM
	    	TRB->PRODUTO	:= COMP->D1_COD
	        TRB->DESCPRO	:= COMP->B1_DESC
	        TRB->UNI_MED	:= COMP->B1_UM
	        TRB->SUBGRUP	:= COMP->B1_XSUBGRU
	        TRB->QTDE		:= COMP->D1_QUANT
	        TRB->PRCCOM		:= COMP->D1_VUNIT
	        TRB->TOTAL		:= COMP->D1_TOTAL
	        TRB->TOTALSDES	:= COMP->VALSDECONT
	        TRB->ICMS_ST	:= COMP->D1_ICMSRET
	        TRB->PISCOFINS	:= COMP->B1_XPISCOF
	        TRB->ICMS		:= COMP->D1_VALICM
	        IF Empty(COMP->CODISS) 
	        	TRB->ICMSTRIB	:= COMP->VALICMTRIB
	        ELSE
	        	TRB->ICMSTRIB	:=0
	        ENDIF
	        TRB->ICMSISEN	:= COMP->ISENICM
	        TRB->ICMSOUTR	:= COMP->OUTRICM
	        TRB->PIS		:= COMP->D1_VALIMP5
	        TRB->CONFINS	:= COMP->D1_VALIMP6	        
	        TRB->LOCALPD	:= COMP->D1_LOCAL
	        TRB->SERIE		:= COMP->D1_SERIE
	        TRB->CFOP		:= COMP->D1_CF 
	        TRB->TES		:= COMP->D1_TES
	        TRB->TEXTO		:= COMP->F4_TEXTO
	        TRB->FINALID   	:= COMP->F4_FINALID 
	        TRB->PR_UNIT	:= COMP->D1_VUNIT
	        TRB->DESCONTO	:= COMP->D1_VALDESC
	        TRB->FRETE		:= COMP->D1_VALFRE 
	        TRB->SEGURO		:= COMP->D1_SEGURO
	        TRB->DESPESAS	:= COMP->D1_DESPESA
	        TRB->VALTOT		:= COMP->VALBRUT
	        TRB->FILIAL   	:= COMP->D1_FILIAL
	        TRB->DESCFIL   	:= clDescFil
	        TRB->ESTADO		:= COMP->A2_EST 
	        TRB->DAT_PN		:= cDataI
	        TRB->DAT_DIGIT	:= COMP->D1_DTDIGIT	        
	        TRB->EMISSAO	:= COMP->D1_EMISSAO	        
	        TRB->DATPENTP	:= COMP->C7_DATPRF	        
	        TRB->DATEMP		:= COMP->C7_EMISSAO	        	        	        
	        TRB->ALIQICM   	:= COMP->D1_PICM
	        TRB->ITEMCONT	:= COMP->D1_ITEMCTA
	        TRB->CONTACON	:= COMP->D1_CONTA
	         
	        TRB->DESCCONT	:= Posicione("CT1",1,xFilial("CT1")+COMP->D1_CONTA,"CT1_DESC01")
	        
	        TRB->CENTCUST	:= COMP->D1_CC 
	        TRB->IMP_IMP	:= COMP->D1_II
	        TRB->VALIRRF	:= COMP->D1_VALIRR
	        TRB->VALISS		:= COMP->D1_VALISS
	        TRB->VALINS   	:= COMP->D1_VALINS
	        TRB->VALIPI   	:= COMP->D1_VALIPI
	        TRB->GRUPTRIB  	:= COMP->B1_GRTRIB
	        TRB->BASEICM  	:= COMP->D1_BASEICM
	        TRB->DESCGRTRI	:= clDescSec3 
	        TRB->TECNCMQ	:= COMP->D1_TEC
	        TRB->NCM		:= COMP->B1_POSIPI
	        TRB->VENCREAL	:= dtVencTit
	        TRB->BAIXA		:= dtBaix
	        TRB->GRUPO		:= COMP->B1_GRUPO
	        TRB->SECAO		:= COMP->B1_XSECAO
	        TRB->LINHA		:= COMP->B1_XFAMILI
	        TRB->NUMPED		:= COMP->C7_NUM    
	        TRB->CONTROLE	:= COMP->F1_CONTROL 
	        TRB->DESCSUBG	:= clDescSec2
	        TRB->DESCSEC	:= clDescSec1
	        TRB->DESCGRUP	:= clDescg
	        TRB->DESCLIN	:= clDescLin    
	        TRB->BAIXADO	:= 	nlVal
	        TRB->SALDO		:= nlSald 
	        TRB->FATCONV	:= COMP->B1_CONV 
			TRB->TIPCONV	:= COMP->B1_TIPCONV 
			TRB->SEGUNID	:= COMP->B1_SEGUM 
			TRB->QT_UNID_UN	:= COMP->QUNICPROD
			TRB->PACELAS	:= clParc        
			TRB->REGISTRO   := COMP->REGISTRO   
			
			//SOLICITACAO DO GUSTAVO 26/07/2012
			TRB->USERCOM	:=  Posicione("SY1",3,xFilial("SY1")+COMP->C7_USER,"Y1_NOME")
			If !EMPTY(COMP->C7_NUMSC)
				TRB->USERSCC	:=  Posicione("SY1",3,xFilial("SY1")+POSICIONE("SC1",1,xFilial("SC1")+COMP->C7_NUMSC,"C1_USER"),"Y1_NOME")
			else
				TRB->USERSCC	:=	""
			EndIf                   
			TRB->DESCCC		:=	Posicione("CTT",1,xFilial("CTT")+COMP->D1_CC,"CTT_DESC01")
		
    	        	         	        	     	        
	    MsUnlock()
	      
		clDescSec1 	:=SPACE(30)
		clDescSec2	:=SPACE(30)
		clDescLin	:=SPACE(30)
		clDescg		:=SPACE(30)	
		clDescSec3  :=SPACE(30)
		cDataI 		:=Ctod(Space(8))
		cCampo     	:=""
	 	cUserLG  	:=""
	 	cUsuarioI	:=""
		nlVal   	:=0
		nlSald  	:=0 
		clParc		:=""
		alParc :={}   
	
      	dbSelectArea("COMP")
     	DbSkip()
	Enddo
	dtVenc:=""
	
	If Select("COMP") > 0
		dbSelectArea("COMP")
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

