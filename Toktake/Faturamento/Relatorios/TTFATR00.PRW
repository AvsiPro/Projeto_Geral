/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ TTFATR00 ¦ Autor ¦ Artur Nucci Ferrari ¦ Data ¦ 01/07/2011 ¦¦¦
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

User Function TTFATR00()
Local oReport
If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ReportDef ¦ Autor ¦ Artur Nucci Ferrari ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função Principal de Impressão				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TTFATR00                                                    ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

Local oReport
Local oSection
Private cPerg    := "FATCLIV"
ValPerg(cPerg)
Pergunte(cPerg,.T.)
oReport := TReport():New("TTFATR00","Notas Fiscais de Saída - Sintético",cPerg,{|oReport| PrintReport(oReport)},"Este relatório imprime as NF de saídas, juntamente com os dados correspondentes do Livro Fiscal, Ctas. a Receber e Contabilidade.")

/*------------------------|
| seção das notas fiscais |
|------------------------*/

oSection1 := TRSection():New(oReport,OemToAnsi("Custo Unitario"),{"TRB"})

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
TRCell():New(oSection1,"UFCLI"		,"TRB","UF"				,"@!"			,02)
TRCell():New(oSection1,"CIDADE"		,"TRB","CIDADE"			,"@!"			,15)
TRCell():New(oSection1,"CODTRAN"	,"TRB","COD. TRANSP"	,"@!"			,06)
TRCell():New(oSection1,"TRANSP"		,"TRB","TRANSPORTADORA"	,"@!"			,35)
TRCell():New(oSection1,"ROMANEIO"	,"TRB","ROMANEIO"		,"@!"			,15)
TRCell():New(oSection1,"PLACA"		,"TRB","PLACA"			,"@!"			,02)
TRCell():New(oSection1,"MOTORISTA"	,"TRB","MOTORISTA"		,"@!"			,15)
TRCell():New(oSection1,"STATUS"		,"TRB","STATUS"			,"@!"			,06)
TRCell():New(oSection1,"VOLUME"		,"TRB","VOLUME"			,"@E 999,999.99",16)
TRCell():New(oSection1,"PESOLIG"	,"TRB","PESO LIQUIDO"	,"@E 999,999.99",16)
TRCell():New(oSection1,"PESOBRUT"	,"TRB","PESO BRUTO"		,"@E 999,999.99",16)
TRCell():New(oSection1,"VALMERC"	,"TRB","VAL.MERCADORIA"	,"@E 999,999.99",16)
TRCell():New(oSection1,"VALBRUT"	,"TRB","VAL. BRUTO"		,"@E 999,999.99",16)
TRCell():New(oSection1,"FRETE"		,"TRB","VAL. FRETE"		,"@E 999,999.99",16)
TRCell():New(oSection1,"SEGURO"		,"TRB","VAL. SEGURO"	,"@E 999,999.99",16)
TRCell():New(oSection1,"DESPESA"	,"TRB","VAL. DESPESAS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"DESCONTO"	,"TRB","VAL. DESCONTO"	,"@E 999,999.99",16)
TRCell():New(oSection1,"VALTOTNF"	,"TRB","VAL. TOT. NOTA"	,"@E 999,999.99",16)
TRCell():New(oSection1,"BASEICMS"	,"TRB","BASE ICMS"		,"@E 999,999.99",16)
TRCell():New(oSection1,"VALICMS"	,"TRB","VAL. ICMS"		,"@E 999,999.99",16)
TRCell():New(oSection1,"BASEIPI"	,"TRB","BASE IPI"		,"@E 999,999.99",16)
TRCell():New(oSection1,"VALIPI"		,"TRB","VAL. IPI"		,"@E 999,999.99",16)
TRCell():New(oSection1,"BASEISS"	,"TRB","BASE ISS"		,"@E 999,999.99",16)
TRCell():New(oSection1,"VALISS"		,"TRB","VAL. ISS"		,"@E 999,999.99",16)
TRCell():New(oSection1,"VALST"		,"TRB","VAL. ST"		,"@E 999,999.99",16)
TRCell():New(oSection1,"CUSTST"		,"TRB","CUST.STANDAR"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CUSTMOV"	,"TRB","CUST.MOVIMENTO"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CUSTFECH"	,"TRB","CUST.FECHAMENTO","@E 999,999.99",16)
TRCell():New(oSection1,"BASECOF"	,"TRB","BASE CONFINS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"BASEPIS"	,"TRB","BASE PIS"		,"@E 999,999.99",16)
TRCell():New(oSection1,"CONFINS"	,"TRB","VAL. CONFINS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"PIS"		,"TRB","VAL. PIS"		,"@E 999,999.99",16)
TRCell():New(oSection1,"CLIVAL"		,"TRB","VAL. CLIENTE"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CONTACLI"	,"TRB","CONTA CLIENTE"	,"@!"			,20)
TRCell():New(oSection1,"RECVAL"		,"TRB","VAL. RECEITA"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CONTREC"	,"TRB","CONTA RECEITA"	,"@!"			,20)
TRCell():New(oSection1,"DESCVAL"	,"TRB","VAL. DESCONTO"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CONTDESC"	,"TRB","CONTA DESCONTO"	,"@!"			,20)
TRCell():New(oSection1,"DESPVAL"	,"TRB","VAL. DESPESA"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CONTDESP"	,"TRB","CONTA DESPESA"	,"@!"			,20)

TRCell():New(oSection1,"DBICMSVAL"	,"TRB","DED_VAL. ICMS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"DBCONTICMS"	,"TRB","DEB_CONTA ICMS"	,"@!"			,20) 
TRCell():New(oSection1,"CDICMSVAL"	,"TRB","CRD_VAL. ICMS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CDCONTICMS"	,"TRB","CRD_CONTA ICMS"	,"@!"			,20)

TRCell():New(oSection1,"DBSTVAL"	,"TRB","DEB_VAL. ST"	,"@E 999,999.99",16)
TRCell():New(oSection1,"DBCONTST"	,"TRB","DEB_CONTA ST"	,"@!"			,20)
TRCell():New(oSection1,"CDSTVAL"	,"TRB","CRD_VAL. ST"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CDCONTST"	,"TRB","CRD_CONTA ST"	,"@!"			,20)

TRCell():New(oSection1,"DBISSVAL"	,"TRB","DEB_VAL. ISS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"DBCONTISS"	,"TRB","DEB_CONTA ISS"	,"@!"			,20)
TRCell():New(oSection1,"CDISSVAL"	,"TRB","CRD_VAL. ISS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CDCONTISS"	,"TRB","CRD_CONTA ISS"	,"@!"			,20)

TRCell():New(oSection1,"DEBCOFVAL","TRB","DEB_VAL. CONFINS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"DBCONTCOF"	,"TRB","DEB_CONTA CONFINS"	,"@!"			,20)
TRCell():New(oSection1,"CRDCOFVAL","TRB","CRD_VAL. CONFINS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CDCONTCOF"	,"TRB","CRD_CONTA CONFINS"	,"@!"			,20)

TRCell():New(oSection1,"DBPISVAL"	,"TRB","DEB_VAL. PIS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"DBCONTPIS"	,"TRB","DEB_CONTA PIS"	,"@!"			,20)
TRCell():New(oSection1,"CDPISVAL"	,"TRB","CD_VAL. PIS"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CDCONTPIS"	,"TRB","CD_CONTA PIS"	,"@!"			,20)

TRCell():New(oSection1,"DATACTB"	,"TRB","DAT. CONTABIL"	,				,08)
TRCell():New(oSection1,"ICMTRILIV"	,"TRB","ICMS TRIB.LIVRO","@E 999,999.99",16)
TRCell():New(oSection1,"ICMISELIV"	,"TRB","ICMS ISEN.LIVRO","@E 999,999.99",16)
TRCell():New(oSection1,"ICMOUTLIV"	,"TRB","ICMS OUTR.LIVRO","@E 999,999.99",16)
TRCell():New(oSection1,"STLIV"		,"TRB","ST LIVRO"		,"@E 999,999.99",16)
TRCell():New(oSection1,"BASCOFLIV"	,"TRB","BAS.CONFIN LIV.","@E 999,999.99",16)
TRCell():New(oSection1,"BASPISLIV"	,"TRB","BAS.PIS LIV"	,"@E 999,999.99",16)
TRCell():New(oSection1,"CONFLIV"	,"TRB","CONFINS LIVRO"	,"@E 999,999.99",16)
TRCell():New(oSection1,"PISLI"		,"TRB","PIS LIVRO"		,"@E 999,999.99",16)
TRCell():New(oSection1,"BANCO"		,"TRB","BANCO"			,"@!"			,03)
TRCell():New(oSection1,"CNAB"		,"TRB","CNAB"			,"@!"			,03)
TRCell():New(oSection1,"BAIXA"		,"TRB","BAIXA"			,"@!"			,12)
TRCell():New(oSection1,"CANAL"		,"TRB","CANAL"			,"@!"			,03)
TRCell():New(oSection1,"DESCCAN"	,"TRB","DESC.CANAL"		,"@!"			,20)
TRCell():New(oSection1,"FINAL"		,"TRB","FINAL.VENDA"	,"@!"			,03)
TRCell():New(oSection1,"DESCFIN"	,"TRB","DESC. FINAL"	,"@!"			,20)
TRCell():New(oSection1,"TRANSF"		,"TRB","TRANSFERENCIA"	,"@!"			,10)
TRCell():New(oSection1,"PA"			,"TRB","COD. PA"		,"@!"			,06)
TRCell():New(oSection1,"DESCPA"		,"TRB","DESC.PA"		,"@!"			,35)
TRCell():New(oSection1,"ABAST"		,"TRB","ABASTECIMENTO"	,"@!"			,03)
TRCell():New(oSection1,"GPV"		,"TRB","GPV"			,"@!"			,08)
TRCell():New(oSection1,"NFE"		,"TRB","NFE"			,"@!"			,35)
TRCell():New(oSection1,"TIPDEV"		,"TRB","TIP. DEV"		,"@!"			,10)
TRCell():New(oSection1,"NFORI"		,"TRB","NOT. ORIGEM"	,"@!"			,09)
TRCell():New(oSection1,"SERIORI"	,"TRB","SERIE ORIGEM"	,"@!"			,04)
TRCell():New(oSection1,"EMISORI"	,"TRB","EMISSAO ORIGEM"	,				,08)
TRCell():New(oSection1,"REGISTRO"	,"TRB","REGISTRO"		,"@!"			,35)
TRCell():New(oSection1,"SEQUENCIA"	,"TRB","SEQUENCIA"		,"@!"			,35)

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
AADD(_aStru,{"UFCLI"	 ,"C",02,0})
AADD(_aStru,{"CIDADE"	 ,"C",15,0})
AADD(_aStru,{"CODTRAN"	 ,"C",06,0})
AADD(_aStru,{"TRANSP"	 ,"C",35,0})
AADD(_aStru,{"ROMANEIO"	 ,"C",15,0})
AADD(_aStru,{"PLACA"	 ,"C",02,0})
AADD(_aStru,{"MOTORISTA" ,"C",15,0})
AADD(_aStru,{"STATUS"	 ,"C",06,0})
AADD(_aStru,{"VOLUME"	 ,"N",14,2})
AADD(_aStru,{"PESOLIG"	 ,"N",16,4})
AADD(_aStru,{"PESOBRUT"	 ,"N",16,4})
AADD(_aStru,{"VALMERC"	 ,"N",16,4})
AADD(_aStru,{"VALBRUT"	 ,"N",16,4})
AADD(_aStru,{"FRETE"	 ,"N",16,4})
AADD(_aStru,{"SEGURO"	 ,"N",16,4})
AADD(_aStru,{"DESPESA"	 ,"N",16,4})
AADD(_aStru,{"DESCONTO"	 ,"N",16,4})
AADD(_aStru,{"VALTOTNF"	 ,"N",16,4})
AADD(_aStru,{"BASEICMS"	 ,"N",16,4})
AADD(_aStru,{"VALICMS"	 ,"N",16,4})
AADD(_aStru,{"BASEIPI"	 ,"N",16,4})
AADD(_aStru,{"VALIPI"	 ,"N",16,4})
AADD(_aStru,{"BASEISS"	 ,"N",16,4})
AADD(_aStru,{"VALISS"	 ,"N",16,4})
AADD(_aStru,{"VALST"	 ,"N",16,4})
AADD(_aStru,{"CUSTST"	 ,"N",16,4})
AADD(_aStru,{"CUSTMOV"	 ,"N",16,4})
AADD(_aStru,{"CUSTFECH"	 ,"N",16,4})
AADD(_aStru,{"BASECOF"	 ,"N",16,4})
AADD(_aStru,{"BASEPIS"	 ,"N",16,4})
AADD(_aStru,{"CONFINS"	 ,"N",16,4})
AADD(_aStru,{"PIS"		 ,"N",16,4})
AADD(_aStru,{"CLIVAL"	 ,"N",16,4})
AADD(_aStru,{"CONTACLI"	 ,"C",20,0})
AADD(_aStru,{"RECVAL"	 ,"N",16,4})
AADD(_aStru,{"CONTREC"	 ,"C",20,0})
AADD(_aStru,{"DESCVAL"	 ,"N",16,4})
AADD(_aStru,{"CONTDESC"	 ,"C",20,0})
AADD(_aStru,{"DESPVAL"	 ,"N",16,4})
AADD(_aStru,{"CONTDESP"	 ,"C",20,0})

AADD(_aStru,{"DBICMSVAL" ,"N",16,4})
AADD(_aStru,{"CDICMSVAL" ,"N",16,4})
AADD(_aStru,{"DBCONTICMS","C",20,0}) 
AADD(_aStru,{"CDCONTICMS","C",20,0}) 

AADD(_aStru,{"DBSTVAL"	,"N",16,4})
AADD(_aStru,{"DBCONTST"	,"C",20,0})
AADD(_aStru,{"CDSTVAL"	,"N",16,4})
AADD(_aStru,{"CDCONTST"	,"C",20,0})


AADD(_aStru,{"DBISSVAL"	,"N",16,4})
AADD(_aStru,{"DBCONTISS","C",20,0})
AADD(_aStru,{"CDISSVAL"	,"N",16,4})
AADD(_aStru,{"CDCONTISS","C",20,0})

AADD(_aStru,{"DEBCOFVAL","N",16,4})

AADD(_aStru,{"DBCONTCOF","C",20,0})

AADD(_aStru,{"CRDCOFVAL","N",16,4})
AADD(_aStru,{"CDCONTCOF","C",20,0})


AADD(_aStru,{"DBPISVAL"	,"N",16,4})
AADD(_aStru,{"DBCONTPIS","C",20,0})
AADD(_aStru,{"CDPISVAL"	,"N",16,4})
AADD(_aStru,{"CDCONTPIS","C",20,0})


AADD(_aStru,{"DATACTB"	 ,"D",08,0})
AADD(_aStru,{"ICMTRILIV" ,"N",16,4})
AADD(_aStru,{"ICMISELIV" ,"N",16,4})
AADD(_aStru,{"ICMOUTLIV" ,"N",16,4})
AADD(_aStru,{"STLIV"	 ,"N",16,4})
AADD(_aStru,{"BASCOFLIV" ,"N",16,4})
AADD(_aStru,{"BASPISLIV" ,"N",16,4})
AADD(_aStru,{"CONFLIV"	 ,"N",16,4})
AADD(_aStru,{"PISLI"	 ,"N",16,4})
AADD(_aStru,{"BANCO"	 ,"C",03,0})
AADD(_aStru,{"CNAB"		 ,"C",03,0})
AADD(_aStru,{"BAIXA"	 ,"C",12,0})
AADD(_aStru,{"CANAL"	 ,"C",03,0})
AADD(_aStru,{"DESCCAN"	 ,"C",20,0})
AADD(_aStru,{"FINAL"	 ,"C",03,0})
AADD(_aStru,{"DESCFIN"	 ,"C",20,0})
AADD(_aStru,{"TRANSF"	 ,"C",10,0})
AADD(_aStru,{"PA"		 ,"C",06,0})
AADD(_aStru,{"DESCPA"	 ,"C",35,0})
AADD(_aStru,{"ABAST"	 ,"C",03,0})
AADD(_aStru,{"GPV"		 ,"C",08,0})
AADD(_aStru,{"NFE"		 ,"C",35,0})
AADD(_aStru,{"TIPDEV"	 ,"C",10,0})
AADD(_aStru,{"NFORI"	 ,"C",09,0})
AADD(_aStru,{"SERIORI"	 ,"C",04,0})
AADD(_aStru,{"EMISORI"	 ,"D",08,0})
AADD(_aStru,{"REGISTRO"	 ,"N",16,0})
AADD(_aStru,{"SEQUENCIA" ,"C",35,0})

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
 
/*---------------------------------------------------------------|
|    Verifica qual a empresa e busca a vew referente a mesma 	 |
|---------------------------------------------------------------*/ 

Do Case
	Case cEmpAnt =="01"	
		clEmpVend :=" VENDA "
		clEmpDevo:=" VENDA_DEVOLUCAO "
	Case cEmpAnt == "02"
		clEmpVend:=" VENDA_LUXOR "
		clEmpDevo:=" VENDA_DEVOLUCAO_LUXOR "
EndCase

/*---------------------------------------------------------------|
| Montagem com os dados das notas fiscais de vendas e devoluções |
|---------------------------------------------------------------*/
 
Do Case
	Case MV_PAR13 == 1
		_cQuery := " SELECT * FROM "+ clEmpVend + clparam 
		_cQuery += " UNION " + clhr13 	
		_cQuery += " SELECT * FROM "+ clEmpDevo + clparam 
	Case MV_PAR13 == 2
		_cQuery := " SELECT * FROM "+ clEmpVend + clparam 
	Case MV_PAR13 == 3
		_cQuery := " SELECT * FROM "+ clEmpDevo + clparam 
EndCase

If Select("TSQL") > 0
	dbSelectArea("TSQL")
	DbCloseArea()
EndIf

/*-----------------------------|
|cria a query e dar um apelido |
|-----------------------------*/

MemoWrite("TTFATR00.sql",_cQuery) //Salva a Query na pasta sistem para consultas futuras
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL",.F.,.T.)

/*-----------------------------------------------------|
| ajusta as casas decimais e datas no retorno da query |
|-----------------------------------------------------*/ 

TcSetField("TSQL","EMISSAO"			,"D",08,0)
TcSetField("TSQL","VOLUME"	 		,"N",16,4)
TcSetField("TSQL","PESO_LIQ"	 	,"N",16,4)
TcSetField("TSQL","PESO_BRUTO"	 	,"N",16,4)
TcSetField("TSQL","VLR_MERCADORIA" 	,"N",16,4)
TcSetField("TSQL","VLR_BRUTO"	 	,"N",16,4)
TcSetField("TSQL","FRETE"	 		,"N",16,4)
TcSetField("TSQL","SEGURO"	 		,"N",16,4)
TcSetField("TSQL","DESPESAS"	 	,"N",16,4)
TcSetField("TSQL","DESCONTO"	 	,"N",16,4)
TcSetField("TSQL","VLR_TOTAL_NF"	,"N",16,4)
TcSetField("TSQL","BASEICMS"	 	,"N",16,4)
TcSetField("TSQL","ICMS"	 		,"N",16,4)
TcSetField("TSQL","BASEIPI"	 		,"N",16,4)
TcSetField("TSQL","IPI"	 			,"N",16,4)
TcSetField("TSQL","BASEISS"	 		,"N",16,4)
TcSetField("TSQL","ISS"	 			,"N",16,4)
TcSetField("TSQL","ST"	 			,"N",16,4)
TcSetField("TSQL","CUSTO_STANDAR" 	,"N",16,4)
TcSetField("TSQL","CUSTO_MOVIMENTO"	,"N",16,4)
TcSetField("TSQL","CUSTO_FECHAMENTO","N",16,4)
TcSetField("TSQL","BASE_COF"	 	,"N",16,4)
TcSetField("TSQL","BASE_PIS"	 	,"N",16,4)
TcSetField("TSQL","COFINS"	 		,"N",16,4)
TcSetField("TSQL","PIS"	 			,"N",16,4)
TcSetField("TSQL","CLIENTE_VALOR" 	,"N",16,4)
TcSetField("TSQL","RECEITA_VALOR" 	,"N",16,4)
TcSetField("TSQL","DESCONTO_VALOR" 	,"N",16,4)
TcSetField("TSQL","DESPESA_VALOR" 	,"N",16,4)
TcSetField("TSQL","DEB_ICMS_VALOR"	,"N",16,4)
TcSetField("TSQL","DEB_ST_VALOR"	,"N",16,4)
TcSetField("TSQL","DEB_ISS_VALOR"	,"N",16,4)

TcSetField("TSQL","D_COF_VAL"		,"N",16,4)

TcSetField("TSQL","DEB_PIS_VALOR"	,"N",16,4)
TcSetField("TSQL","CRD_ICMS_VALOR"	,"N",16,4)
TcSetField("TSQL","CRD_ST_VALOR"	,"N",16,4)
TcSetField("TSQL","CRD_ISS_VALOR"	,"N",16,4)  

TcSetField("TSQL","C_COF_VAL"		,"N",16,4)

TcSetField("TSQL","CRD_PIS_VALOR"	,"N",16,4)
TcSetField("TSQL","DATA_CTB"		,"D",08,0)
TcSetField("TSQL","ICMS_TRIBUTADO_LIVRO","N",16,4)
TcSetField("TSQL","ICMS_ISENTO_LIVRO" 	,"N",16,4)
TcSetField("TSQL","ICMS_OUTROS_LIVRO" 	,"N",16,4)
TcSetField("TSQL","ST_LIVRO"	 		,"N",16,4)
TcSetField("TSQL","BASE_COF_LIVRO"	 	,"N",16,4)
TcSetField("TSQL","BASE_PIS_LIVRO"	 	,"N",16,4)
TcSetField("TSQL","COFINS_LIVRO"	 	,"N",16,4)
TcSetField("TSQL","PIS_LIVRO"	 		,"N",16,4)
TcSetField("TSQL","EMISSAO_DEV_ORIGEM"	,"D",08,0)

dbSelectArea("TSQL")
dbGotop()

Do While TSQL->(!Eof())
	MsProcTxt("Processando Nota "+TSQL->NOTA)
		
	DbSelectArea("TRB")
		
	/*---------------------------|
	| adiciona registro em banco |
	|---------------------------*/
	
	RecLock("TRB",.T.)		
	TRB->TIPO		:= TSQL->TIPO
	TRB->MES		:= Substr(TSQL->MES,1,2) + "/" + Substr(TSQL->MES,3,4)
	TRB->FILIAL		:= TSQL->FILIAL
	TRB->DESCFIL	:= TSQL->DESC_FILIAL
	TRB->NOTA		:= TSQL->NOTA
	TRB->SERIE		:= TSQL->SERIE
	TRB->EMISSAO	:= TSQL->EMISSAO
	TRB->CODVEND	:= TSQL->COD_VEND
	TRB->VENDEDOR	:= TSQL->VENDEDOR
	TRB->CODSUPER	:= TSQL->COD_SUPER
	TRB->SUPERVIS	:= TSQL->SUPERVISOR
	TRB->CODGEREN	:= TSQL->COD_GER
	TRB->GERENT		:= TSQL->GERENTE
	TRB->CODCLI		:= TSQL->COD_CLIENTE
	TRB->LOJACLI	:= TSQL->LOJA
	TRB->NOMCLI		:= TSQL->CLIENTE
	TRB->TIPOCLI	:= TSQL->TIPO_CLIENTE
	TRB->UFCLI		:= TSQL->UF
	TRB->CIDADE		:= TSQL->CIDADE
	TRB->CODTRAN	:= TSQL->COD_TRANSP
	TRB->TRANSP		:= TSQL->TRANSPORTADORA
	TRB->ROMANEIO	:= TSQL->ROMANEIO
	TRB->PLACA		:= TSQL->PLACA
	TRB->MOTORISTA	:= TSQL->MOTORISTA
	TRB->STATUS		:= TSQL->STATUS
	TRB->VOLUME		:= TSQL->VOLUME
	TRB->PESOLIG	:= TSQL->PESO_LIQ
	TRB->PESOBRUT	:= TSQL->PESO_BRUTO
	TRB->VALMERC	:= TSQL->VLR_MERCADORIA
	TRB->VALBRUT	:= TSQL->VLR_BRUTO
	TRB->FRETE		:= TSQL->FRETE
	TRB->SEGURO		:= TSQL->SEGURO
	TRB->DESPESA	:= TSQL->DESPESAS
	TRB->DESCONTO	:= TSQL->DESCONTO
	TRB->VALTOTNF	:= TSQL->VLR_TOTAL_NF
	TRB->BASEICMS	:= TSQL->BASEICMS
	TRB->VALICMS	:= TSQL->ICMS
	TRB->BASEIPI	:= TSQL->BASEIPI
	TRB->VALIPI		:= TSQL->IPI
	TRB->BASEISS	:= TSQL->BASEISS
	TRB->VALISS		:= TSQL->ISS
	TRB->VALST		:= TSQL->ST
	TRB->CUSTST		:= TSQL->CUSTO_STANDAR
	TRB->CUSTMOV	:= TSQL->CUSTO_MOVIMENTO
	TRB->CUSTFECH	:= TSQL->CUSTO_FECHAMENTO
	TRB->BASECOF	:= TSQL->BASE_COF
	TRB->BASEPIS	:= TSQL->BASE_PIS
	TRB->CONFINS	:= TSQL->COFINS
	TRB->PIS		:= TSQL->PIS
	TRB->CLIVAL		:= TSQL->CLIENTE_VALOR
	TRB->CONTACLI	:= TSQL->CLIENTE_CONTA
	TRB->RECVAL		:= TSQL->RECEITA_VALOR
	TRB->CONTREC	:= TSQL->RECEITA_CONTA
	TRB->DESCVAL	:= TSQL->DESCONTO_VALOR
	TRB->CONTDESC	:= TSQL->DESCONTO_CONTA
	TRB->DESPVAL	:= TSQL->DESPESA_VALOR
	TRB->CONTDESP	:= TSQL->DESPESA_CONTA
	
	
	TRB->DBICMSVAL	:= TSQL->DEB_ICMS_VALOR //
	TRB->DBCONTICMS	:= TSQL->DEB_ICMS_CONTA //	
	TRB->CDICMSVAL	:= TSQL->CRD_ICMS_VALOR //
	TRB->CDCONTICMS	:= TSQL->CRD_ICMS_CONTA //
	
	TRB->DBSTVAL	:= TSQL->DEB_ST_VALOR
	TRB->DBCONTST	:= TSQL->DEB_ST_CONTA
	TRB->CDSTVAL	:= TSQL->CRD_ST_VALOR
	TRB->CDCONTST	:= TSQL->CRD_ST_CONTA
	
	TRB->DBISSVAL	:= TSQL->DEB_ISS_VALOR
	TRB->DBCONTISS	:= TSQL->DEB_ISS_CONTA	
	TRB->CDISSVAL	:= TSQL->CRD_ISS_VALOR
	TRB->CDCONTISS	:= TSQL->CRD_ISS_CONTA
		
	TRB->DEBCOFVAL	:= TSQL->D_COF_VAL
	TRB->DBCONTCOF	:= TSQL->D_COF_CONTA
	TRB->CRDCOFVAL	:= TSQL->C_COF_VAl
	TRB->CDCONTCOF	:= TSQL->C_COF_CONTA
	
	TRB->DBPISVAL	:= TSQL->DEB_PIS_VALOR
	TRB->DBCONTPIS	:= TSQL->DEB_PIS_CONTA
	TRB->CDPISVAL	:= TSQL->CRD_PIS_VALOR
	TRB->CDCONTPIS	:= TSQL->CRD_PIS_CONTA
	
	
	
	TRB->DATACTB	:= TSQL->DATA_CTB
	TRB->ICMTRILIV	:= TSQL->ICMS_TRIBUTADO_LIVRO
	TRB->ICMISELIV	:= TSQL->ICMS_ISENTO_LIVRO
	TRB->ICMOUTLIV	:= TSQL->ICMS_OUTROS_LIVRO
	TRB->STLIV		:= TSQL->ST_LIVRO
	TRB->BASCOFLIV	:= TSQL->BASE_COF_LIVRO
	TRB->BASPISLIV	:= TSQL->BASE_PIS_LIVRO
	TRB->CONFLIV	:= TSQL->COFINS_LIVRO
	TRB->PISLI		:= TSQL->PIS_LIVRO
	TRB->BANCO		:= TSQL->BANCO
	TRB->CNAB		:= TSQL->CNAB
	TRB->BAIXA		:= TSQL->BAIXA
	TRB->CANAL		:= TSQL->CANAL
	TRB->DESCCAN	:= TSQL->DESC_CANAL
	TRB->FINAL		:= TSQL->FINALIDADE
	TRB->DESCFIN	:= TSQL->DESC_FINAL
	TRB->TRANSF		:= TSQL->TRANSFERENCIA
	TRB->PA			:= TSQL->PA
	TRB->DESCPA		:= TSQL->DESC_PA
	TRB->ABAST		:= TSQL->ABAST
	TRB->GPV		:= TSQL->GPV
	TRB->NFE		:= TSQL->NFE
	TRB->TIPDEV		:= TSQL->TIP_DEV
	TRB->NFORI		:= TSQL->NF_DEV_ORIGEM
	TRB->SERIORI	:= TSQL->SERIE_DEV_ORIGEM
	TRB->EMISORI	:= TSQL->EMISSAO_DEV_ORIGEM
	TRB->REGISTRO	:= TSQL->REGISTRO_NF
	TRB->SEQUENCIA	:= TSQL->SEQUENCIA
	
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
	PutSx1(cPerg,'13','Tipo (Venda/Dev)    	 ?','','','mv_chd','N',1 ,0,1,'C','','','','','mv_par13',"Ambos"," "," ","","Vendas","","","Devolucoes","","","","","","","","")   	
		
	//PutSx1(cPerg,'14','Gera Finaceiro      ?','','','mv_che','N',01,0,1,'C','','','','','mv_par14',"Sim"," "," ","","Não","","","Ambos","","","","","","","","")
	//PutSx1(cPerg,'15','Gera Estoque      	 ?','','','mv_chf','N',01,0,1,'C','','','','','mv_par15',"Sim"," "," ","","Não","","","Ambos","","","","","","","","")
Return
