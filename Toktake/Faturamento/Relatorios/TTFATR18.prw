/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ TTFATR18 ¦ Autor ¦ Artur Nucci Ferrari ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Relatorio de Faturamento						              ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Tok Take                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User Function TTFATR18()
Local oReport
If cEmpAnt == "01"
	If TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
endif
Return

/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ReportDef ¦ Autor ¦ Artur Nucci Ferrari ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função Principal de Impressão				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokTake                                                    ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

Local oReport
Local oSection
Private cPerg    := "TTFATR18"
ValPerg(cPerg)
Pergunte(cPerg,.T.)
oReport := TReport():New("TTFATR18","Vendas por canal",cPerg,{|oReport| PrintReport(oReport)},"Este relatório imprimirá as vendas da TokTake de acordo com os parametros definidos pelo usuário")

/*------------------------|
| seção das notas fiscais |
|------------------------*/

oSection1 := TRSection():New(oReport,OemToAnsi("Faturamento TokeTake"),{"TRB"})

/*----------------------------------------------------------------------------------|
|                       campo        alias  título       	 pic           tamanho  |
|----------------------------------------------------------------------------------*/
 

	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"			,"@!"			,20)
	TRCell():New(oSection1,"MES"		,"TRB","MÊS/ANO	"		,"@!"			,08)	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"		,"@!"			,02)
	TRCell():New(oSection1,"DESCFIL"	,"TRB","DESC_FILIAL"	,"@!"			,35)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"		,"@!"			,09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"		,"@!"			,04)
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO	"		,				,08)
	TRCell():New(oSection1,"CODVEND"	,"TRB","COD. VENDEDOR"	,"@!"			,06)
	TRCell():New(oSection1,"VENDEDOR"	,"TRB","NOM. VENDEDOR"	,"@!"			,35)
	TRCell():New(oSection1,"CODSUPER"	,"TRB","COD. SUPERVISOR","@!"			,06)
	TRCell():New(oSection1,"SUPERVIS"	,"TRB","NOM. SUPERVISOR","@!"			,35)
	TRCell():New(oSection1,"CODGEREN"	,"TRB","COD. GERENTE"	,"@!"			,06)
	TRCell():New(oSection1,"GERENT"		,"TRB","NOM. GERENTE"	,"@!"			,35)
	TRCell():New(oSection1,"CODCLI"		,"TRB","COD. CLIENTE"	,"@!"			,06)
	TRCell():New(oSection1,"LOJACLI"	,"TRB","LOJA"			,"@!"			,04)
	TRCell():New(oSection1,"NOMCLI"		,"TRB","NOM. CLIENTE"	,"@!"			,35)
	TRCell():New(oSection1,"TIPOCLI"	,"TRB","TIP. CLIENTE"	,"@!"			,15)
	TRCell():New(oSection1,"CNPJ"		,"TRB"  ,"CNPJ/CPF "	,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"ENDERECO"	,"TRB","ENDEREÇO"		,"@!"			,35)
	TRCell():New(oSection1,"BAIRRO"		,"TRB","BAIRRO"			,"@!"			,35)
	TRCell():New(oSection1,"CIDADE"		,"TRB","CIDADE"			,"@!"			,15)	
	TRCell():New(oSection1,"CEP"		,"TRB","CEP"			,"@!"			,09)
	TRCell():New(oSection1,"UFCLI"		,"TRB","UF"				,"@!"			,02)
	TRCell():New(oSection1,"CODTRAN"	,"TRB","COD. TRANSP"	,"@!"			,06)
	TRCell():New(oSection1,"TRANSP"		,"TRB","TRANSPORTADORA"	,"@!"			,35)	
	TRCell():New(oSection1,"ROMANEIO"	,"TRB","ROMANEIO"		,"@!"			,15)
	TRCell():New(oSection1,"PLACA"		,"TRB","PLACA"			,"@!"			,10)	
	TRCell():New(oSection1,"MOTORISTA"	,"TRB","MOTORISTA"		,"@!"			,15)
	TRCell():New(oSection1,"STATUS"		,"TRB","STATUS"			,"@!"			,06)
	TRCell():New(oSection1,"ITEM"		,"TRB","ITEM"			,"@!"			,04)
	TRCell():New(oSection1,"COD_PROD"	,"TRB","PRODUTO"		,"@!"			,15)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","DESCRI_PRODUTO"	,"@!"			,35)
	TRCell():New(oSection1,"QTD"		,"TRB","QTDE	"		,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VUNIT"		,"TRB","V_UNIT	"		,"@E 999,999.99",16)		
	TRCell():New(oSection1,"TOTAL"		,"TRB","V.MERC / DESCONTO","@E 999,999.99",16)		
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO"		,"@E 999,999.99",16)	
	TRCell():New(oSection1,"FRETE"		,"TRB","FRETE"			,"@E 999,999.99",16)		
	TRCell():New(oSection1,"SEGURO"		,"TRB","SEGURO"			,"@E 999,999.99",16)	
	TRCell():New(oSection1,"DESPESAS"	,"TRB","DESPESAS"		,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VALTOTNF"	,"TRB","VAL_TOTAL_NOTA"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VOLUME"		,"TRB","VOLUME"			,"@E 999,999.99",16)
	TRCell():New(oSection1,"PESOLIG"	,"TRB","PESO LIQUIDO"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"PESOBRUT"	,"TRB","PESO BRUTO"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"FINAL"		,"TRB","FINAL.VENDA"	,"@!"			,03)
	TRCell():New(oSection1,"DESCFIN"	,"TRB","DESC. FINAL"	,"@!"			,20)
	TRCell():New(oSection1,"CANAL"		,"TRB","CANAL"			,"@!"			,03)
	TRCell():New(oSection1,"DESCCAN"	,"TRB","DESC.CANAL"		,"@!"			,20)
	TRCell():New(oSection1,"CCUSTO"		,"TRB","C. CUSTO"		,"@!"			,10)
	TRCell():New(oSection1,"CUSTO"		,"TRB","DESC.C.CUSTO"	,"@!"			,35)
	TRCell():New(oSection1,"BANCO"		,"TRB","BANCO"			,"@!"			,03)
	TRCell():New(oSection1,"CNAB"		,"TRB","CNAB"			,"@!"			,03)
	TRCell():New(oSection1,"BAIXA"		,"TRB","BAIXA"			,"@!"			,12)
	TRCell():New(oSection1,"TIPDEV"		,"TRB","TIP. DEV"		,"@!"			,10)
	TRCell():New(oSection1,"NFORIGEM"	,"TRB","NOT. ORIGEM"	,"@!"				,09)	
	TRCell():New(oSection1,"SERIEORI"	,"TRB","SERIE ORIGEM"	,"@!"			,04)
	TRCell():New(oSection1,"EMISSAD"	,"TRB","EMISSAO ORIGEM"	,				,08)

Return oReport


/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport¦ Autor ¦ Artur Nucci Ferrari ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressão do Relatório        				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TTFATR00                                                    ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                                                                                                                           
Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)

/*-----------------------------------------------------------------|
| seleção dos dados a serem impressos/carrega o arquivo temporário |
|-----------------------------------------------------------------*/

MsAguarde({|| fSelDados()},"Selecionando Notas")

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

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦fSelDados ¦ Autor ¦ Artur Nucci Ferrari ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦Criação da tabela temporária e Alimentação da mesma por 	  ¦¦¦
¦¦¦			 ¦meio de Vews cridas previamentes							  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Tok Take                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function fSelDados()
Local clparam
Local clEmpVend 
Local clEmpDevo
Local clhr13:=chr(13)

/*-------------------------------|
| criação do arquivo de trabalho |
|-------------------------------*/

_aStru	:= {}

AADD(_aStru,{"TIPO"		 ,"C",20,0})
AADD(_aStru,{"MES"		 ,"C",08,0})
AADD(_aStru,{"FILIAL"	 ,"C",02,0})
AADD(_aStru,{"DESCFIL"	 ,"C",35,0})
AADD(_aStru,{"NOTA"		 ,"C",09,0})
AADD(_aStru,{"SERIE"	 ,"C",04,0})
AADD(_aStru,{"EMISSAO"	 ,"D",08,0})
AADD(_aStru,{"CODVEND"	 ,"C",06,0})
AADD(_aStru,{"VENDEDOR"	 ,"C",35,0})
AADD(_aStru,{"CODSUPER"	 ,"C",06,0})
AADD(_aStru,{"SUPERVIS"	 ,"C",35,0})
AADD(_aStru,{"CODGEREN"	 ,"C",06,0})
AADD(_aStru,{"GERENT"	 ,"C",35,0})
AADD(_aStru,{"CODCLI"	 ,"C",06,0})
AADD(_aStru,{"LOJACLI"	 ,"C",04,0})
AADD(_aStru,{"NOMCLI"	 ,"C",35,0})
AADD(_aStru,{"TIPOCLI"	 ,"C",15,0}) 
AADD(_aStru,{"CNPJ"	 	 ,"C",15,0})
AADD(_aStru,{"ENDERECO"	 ,"C",35,0})
AADD(_aStru,{"BAIRRO"	 ,"C",35,0})
AADD(_aStru,{"CIDADE"	 ,"C",20,0})
AADD(_aStru,{"CEP"	 	 ,"C",09,0})
AADD(_aStru,{"UFCLI"	 ,"C",02,0})
AADD(_aStru,{"CODTRAN"	 ,"C",06,0})
AADD(_aStru,{"TRANSP"	 ,"C",35,0})
AADD(_aStru,{"ROMANEIO"	 ,"C",15,0})
AADD(_aStru,{"PLACA"	 ,"C",10,0})
AADD(_aStru,{"MOTORISTA" ,"C",15,0})
AADD(_aStru,{"STATUS"	 ,"C",06,0})
AADD(_aStru,{"ITEM"	 	 ,"C",04,0})
AADD(_aStru,{"COD_PROD"	 ,"C",15,0})
AADD(_aStru,{"PRODUTO"	 ,"C",35,0})
AADD(_aStru,{"QTD"	 	 ,"N",14,2})
AADD(_aStru,{"VUNIT"	 ,"N",14,2})
AADD(_aStru,{"TOTAL"	 ,"N",14,2})
AADD(_aStru,{"DESCONTO"	 ,"N",16,4})
AADD(_aStru,{"FRETE"	 ,"N",16,4})
AADD(_aStru,{"SEGURO"	 ,"N",16,4})
AADD(_aStru,{"DESPESAS"	 ,"N",16,4})
AADD(_aStru,{"VALTOTNF"	 ,"N",16,4})
AADD(_aStru,{"VOLUME"	 ,"N",14,2})
AADD(_aStru,{"PESOLIG"	 ,"N",16,4})
AADD(_aStru,{"PESOBRUT"	 ,"N",16,4})
AADD(_aStru,{"FINAL"	 ,"C",03,0})
AADD(_aStru,{"DESCFIN"	 ,"C",20,0})
AADD(_aStru,{"CANAL"	 ,"C",03,0})
AADD(_aStru,{"DESCCAN"	 ,"C",20,0})
AADD(_aStru,{"CCUSTO"	 ,"C",10,0})
AADD(_aStru,{"CUSTO"	 ,"C",35,0})
AADD(_aStru,{"BANCO"	 ,"C",03,0})
AADD(_aStru,{"CNAB"	 	 ,"C",03,0})
AADD(_aStru,{"BAIXA"	 ,"C",10,0})
AADD(_aStru,{"TIPDEV"	 ,"C",10,0})
AADD(_aStru,{"NFORIGEM"	 ,"C",10,0})
AADD(_aStru,{"SERIEORI"	 ,"C",10,0})
AADD(_aStru,{"EMISSAD"	 ,"D",08,0})


_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")

/*---------------------------------------------------------------|
|     definição dos parâmetro de vendas, devoluções e ambos 	 |
|---------------------------------------------------------------*/

clparam := "WHERE FILIAL 	  BETWEEN '"+MV_PAR01+"' 	   AND  '"+MV_PAR02+"' 		 " + clhr13
clparam += "  AND EMISSAO 	  BETWEEN '"+Dtos(MV_PAR03)+"' AND  '"+Dtos(MV_PAR04)+"' " + clhr13
clparam += "  AND NOTA 		  BETWEEN '"+MV_PAR05+"' 	   AND  '"+MV_PAR06+"' 		 " + clhr13
clparam += "  AND SERIE 	  BETWEEN '"+MV_PAR07+"'       AND  '"+MV_PAR08+"' 		 " + clhr13
clparam += "  AND COD_CLIENTE BETWEEN '"+MV_PAR09+"'       AND  '"+MV_PAR10+"' 		 " + clhr13
clparam += "  AND LOJA 		  BETWEEN '"+MV_PAR11+"'       AND  '"+MV_PAR12+"' 		 " + clhr13
clparam += "  AND COD_CCUSTO  BETWEEN '"+MV_PAR13+"'       AND  '"+MV_PAR14+"' 		 " + clhr13
clparam += "  AND CANAL		  BETWEEN '"+MV_PAR15+"'       AND  '"+MV_PAR16+"' 		 " + clhr13
 
/*---------------------------------------------------------------|
|   pega a query referente as ocorrências, devoluções e vendas	 |
|---------------------------------------------------------------*/ 


	clEmpVend :=" VENDA_CANAL  "
	clEmpDevo :=" VENDA_CANAL_DEVOLUCAO  "


/*---------------------------------------------------------------|
| Montagem com os dados das notas fiscais de vendas e devoluções |
|---------------------------------------------------------------*/
 
	_cQuery := " SELECT * FROM "+ clEmpVend + clparam 
	_cQuery += " UNION " + clhr13 	
	_cQuery += " SELECT * FROM "+ clEmpDevo + clparam 

If Select("TSQL") > 0
	dbSelectArea("TSQL")
	DbCloseArea()
EndIf

/*-----------------------------|
|cria a query e dar um apelido |
|-----------------------------*/

MemoWrite("TTFATR18.sql",_cQuery) //Salva a Query na pasta sistem para consultas futuras
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL",.F.,.T.)

/*-----------------------------------------------------|
| ajusta as casas decimais e datas no retorno da query |
|-----------------------------------------------------*/ 

TcSetField("TSQL","EMISSAO"			,"D",08,0)
TcSetField("TSQL","VOLUME"	 		,"N",16,4)
TcSetField("TSQL","QTD"	 			,"N",16,4)
TcSetField("TSQL","VALOR_TOTAL"		,"N",16,4)
TcSetField("TSQL","V_UNIT"			,"N",16,4)
TcSetField("TSQL","TOTAL" 			,"N",16,4)
TcSetField("TSQL","PESO_LIQ"	 	,"N",16,4)
TcSetField("TSQL","PESO_BRUTO"	 	,"N",16,4)
TcSetField("TSQL","FRETE"	 		,"N",16,4)
TcSetField("TSQL","SEGURO"	 		,"N",16,4)
TcSetField("TSQL","DESPESAS"	 	,"N",16,4)
TcSetField("TSQL","DESCONTO"	 	,"N",16,4)
TcSetField("TSQL","VLR_TOTAL_NF"	,"N",16,4)
TcSetField("TSQL","EMISSAO_DEV_ORIGEM","D",08,0)

dbSelectArea("TSQL")
dbGotop()

Do While TSQL->(!Eof())
	MsProcTxt("Processando Nota "+TSQL->NOTA)
		
	DbSelectArea("TRB")
	
	/*---------------------------|
	| adiciona registro em banco |
	|---------------------------*/
	
	RecLock("TRB",.T.)
			
		TRB->TIPO	:= TSQL->TIPO
		TRB->MES	:= Left(TSQL->MES,2)+"/"+ Right(TSQL->MES,4)
		TRB->FILIAL	:= TSQL->FILIAL
		TRB->DESCFIL:= TSQL->DESC_FILIAL
		TRB->NOTA	:= TSQL->NOTA
		TRB->SERIE	:= TSQL->SERIE
		TRB->EMISSAO:= TSQL->EMISSAO
		TRB->CODVEND:= TSQL->COD_VEND
		TRB->VENDEDOR:= TSQL->VENDEDOR
		TRB->CODSUPER:= TSQL->COD_SUPER
		TRB->SUPERVIS:= TSQL->SUPERVISOR
		TRB->CODGEREN:= TSQL->COD_GER
		TRB->GERENT	 := TSQL->GERENTE
		TRB->CODCLI	 := TSQL->COD_CLIENTE
		TRB->LOJACLI := TSQL->LOJA
		TRB->NOMCLI	 := TSQL->CLIENTE
		TRB->TIPOCLI := TSQL->TIPO_CLIENTE
		TRB->CNPJ	 := TSQL->CNPJ
   		TRB->ENDERECO:= TSQL->ENDERECO
		TRB->BAIRRO	 := TSQL->BAIRRO
		TRB->CIDADE	 := TSQL->CIDADE
		TRB->CEP	 := Left(TSQL->CEP,5) + "-"+ Right(TSQL->CEP,3)
		TRB->UFCLI	 := TSQL->UF
		TRB->CODTRAN := TSQL->COD_TRANSP
		TRB->TRANSP	 := TSQL->TRANSPORTADORA
		TRB->ROMANEIO:= TSQL->ROMANEIO
		TRB->PLACA	 := TSQL->PLACA
		TRB->MOTORISTA:= TSQL->MOTORISTA
		TRB->STATUS	 := TSQL->STATUS
		TRB->ITEM	 := TSQL->ITEM
		TRB->COD_PROD:= TSQL->COD_PRODUTO
		TRB->PRODUTO := TSQL->PRODUTO
		TRB->QTD	 := TSQL->QTD
	    TRB->VUNIT	 := TSQL->V_UNIT
		TRB->TOTAL	 := TSQL->TOTAL
		TRB->DESCONTO:= TSQL->DESCONTO
		TRB->FRETE	 := TSQL->FRETE
		TRB->SEGURO	 := TSQL->SEGURO
		TRB->DESPESAS:= TSQL->DESPESAS
		TRB->VALTOTNF:= TSQL->VALOR_TOTAL
		TRB->VOLUME	 := TSQL->VOLUME
		TRB->PESOLIG := TSQL->PESO_LIQ
		TRB->PESOBRUT:= TSQL->PESO_BRUTO
		TRB->FINAL	 := TSQL->FINALIDADE
		TRB->DESCFIN:= TSQL->DESC_FINAL
		TRB->CANAL	:= TSQL->CANAL
		TRB->DESCCAN:= TSQL->DESC_CANAL
		TRB->CCUSTO	:= TSQL->COD_CCUSTO
		TRB->CUSTO	:= TSQL->CCUSTO
		TRB->BANCO	:= TSQL->BANCO
		TRB->CNAB	:= TSQL->CNAB
		TRB->BAIXA	:= TSQL->BAIXA
		TRB->TIPDEV	:= TSQL->TIP_DEV
		TRB->NFORIGEM:= TSQL->NF_DEV_ORIGEM
		TRB->SERIEORI:= TSQL->SERIE_DEV_ORIGEM
		TRB->EMISSAD:= TSQL->EMISSAO_DEV_ORIGEM
	
	MsUnlock()
	
	dbSelectArea("TSQL")
	DbSkip()
Enddo

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ValPerg() ¦ Autor ¦ Artur Nucci Ferrari ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦Verifica na SX1 através da variável cPerg se existe os parâ-¦¦¦
¦¦¦			 ¦metros de perguntas,se não existir não será criado.		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Tok Take                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ValPerg(cPerg)
    
	PutSx1(cPerg,'01','Filial  de            ?','','','mv_ch1','C',02,0,0,'G','','SM0','','','mv_par01',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'02','Filial  ate           ?','','','mv_ch2','C',02,0,0,'G','','SM0','','','mv_par02',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'03','Emissao de            ?','','','mv_ch3','D',8,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Emissao Ate           ?','','','mv_ch4','D',8,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Nota de               ?','','','mv_ch5','C',09,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Nota Ate              ?','','','mv_ch6','C',09,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Serie de              ?','','','mv_ch7','C',03,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Serie Ate             ?','','','mv_ch8','C',03,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'09','Cliente de            ?','','','mv_ch9','C',06,0,0,'G','','SA1','','','mv_par09',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'10','Cliente Ate           ?','','','mv_cha','C',06,0,0,'G','','SA1','','','mv_par10',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'11','Loja de               ?','','','mv_chb','C',4,0,0,'G','','','','','mv_par11',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'12','Loja Ate              ?','','','mv_chc','C',4,0,0,'G','','','','','mv_par12',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'13','C.Custo de            ?','','','mv_chd','C',09,0,0,'G','','CTT','','','mv_par13',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'14','C.Custo ate           ?','','','mv_che','C',09,0,0,'G','','CTT','','','mv_par14',,,'','','','','','','','','','','','','','') 		
	PutSx1(cPerg,'15','Canal de              ?','','','mv_chf','C',03,0,0,'G','','','','','mv_par15',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'16','Canal Ate             ?','','','mv_chG','C',03,0,0,'G','','','','','mv_par16',,,'','','','','','','','','','','','','','')

Return
