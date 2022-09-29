#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMPVEN   ºAutor  ³Fabio Sales         º Data ³  01/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de vendas e devoluções que geram financeiros      º±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fabio Sales   ³01/07/11³01.01 |Criacao                                 ³±±
±±³Jackson Ezidio³06/05/14³01.02 |Adicionado coluna CNPJ/CPF			  ³±±  
±±³Jackson Ezidio³12/05/14³01.03 |Alterado o local da coluna CNPJ/CPF	  ³±±  
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function COMPVEN()
Local oReport
If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
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
oReport := TReport():New("COMPVEN","Custo das Vendas x Custo Medio",cPerg,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir precos das vendas x custo medio dos produtos")

/*------------------------|
| seção das notas fiscais |
|------------------------*/

oSection1 := TRSection():New(oReport,OemToAnsi("Custo Unitario"),{"TRB"})

/*----------------------------------------------------------------------------------|
|                       campo        alias  título       	 pic           tamanho  |
|----------------------------------------------------------------------------------*/

TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"			,"@!"			,20)
TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"		,"@!"			,02)
TRCell():New(oSection1,"DESCFIL"	,"TRB","DESC_FILIAL"	,"@!"			,35)
TRCell():New(oSection1,"PEDIDO"		,"TRB","PEDIDO	"		,"@!"			,06)
TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"		,"@!"			,09)
TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"		,"@!"			,03)
TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO	"		,				,08)
TRCell():New(oSection1,"CODVEND"	,"TRB","CODVEND "		,"@!"			,06)
TRCell():New(oSection1,"VENDED"		,"TRB","VENDEDOR"		,"@!"			,40)
TRCell():New(oSection1,"SUPERV"		,"TRB","COD.SUPERVISOR"	,"@!"			,06)
TRCell():New(oSection1,"DESCSUPER"	,"TRB","DESC.SUPERVISOR","@!"			,35)
TRCell():New(oSection1,"GERENT"		,"TRB","COD.GERENTE"	,"@!"			,06)
TRCell():New(oSection1,"DESCGEREN"	,"TRB","DESC.GERENTE"	,"@!"			,35)
TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLI	"		,"@!"			,06)
TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE	"		,"@!"			,40)
TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"		,"@!"			,04)
TRCell():New(oSection1,"ESTADO"		,"TRB","ESTADO"			,"@!"			,02)
TRCell():New(oSection1,"CIDADE"		,"TRB","CIDADE"			,"@!"			,35)
TRCell():New(oSection1,"ITEM"		,"TRB","ITEM_NOTA"		,"@!"			,04)
TRCell():New(oSection1,"PRODUTO"	,"TRB","COD_PROD"		,"@!"			,15)
TRCell():New(oSection1,"DESCPRO"	,"TRB","DESC_PROD"		,"@!"			,30)
TRCell():New(oSection1,"UNI_MED"	,"TRB","UNI_MED"		,"@!"			,02)
TRCell():New(oSection1,"SUBGRUP"	,"TRB","SUB_GRUPO"		,"@!"			,04)
TRCell():New(oSection1,"DESCSUBG"	,"TRB","DESC_SUBGRUP"	,"@!"			,30)
TRCell():New(oSection1,"GRUPO"		,"TRB","CATEGORIA"		,"@!"			,04)
TRCell():New(oSection1,"DESCGRUP"	,"TRB","DESC_CATEGORIA"	,"@!"			,30)
TRCell():New(oSection1,"SECAO"		,"TRB","SECAO"			,"@!"			,04)
TRCell():New(oSection1,"DESCSEC"	,"TRB","DESC_SECAO"		,"@!"			,30)
TRCell():New(oSection1,"LINHA"		,"TRB","LINHA    "		,"@!"			,03)
TRCell():New(oSection1,"DESCLIN"	,"TRB","DESC_LINHA"		,"@!"			,30)
TRCell():New(oSection1,"LOCALPD"	,"TRB","LOCAL	"		,"@!"			,06)
TRCell():New(oSection1,"DESCARM"	,"TRB","DESC_ARMAZEM"	,"@!"			,30)
TRCell():New(oSection1,"TES"		,"TRB","TES		"		,"@!"			,03)
TRCell():New(oSection1,"CFOP"		,"TRB","CFOP	"		,"@!"			,05)
TRCell():New(oSection1,"NCM"		,"TRB","NCM		"		,"@!"			,10)
TRCell():New(oSection1,"ROMAN"		,"TRB","NRO_ROMANEIO"	,"@!"			,10)
TRCell():New(oSection1,"TRANSP"		,"TRB","COD_TRANSP"		,"@!"			,16)
TRCell():New(oSection1,"PLACA"		,"TRB","PLACA_CARRO"	,"@E XXX-9999"	,08)
TRCell():New(oSection1,"MOTOR"  	,"TRB","MOTORISTA"		,"@!"			,40)
TRCell():New(oSection1,"CHVNFE"		,"TRB","NF_ELETRONICA"	,"@!"			,12)
TRCell():New(oSection1,"QTDE"		,"TRB","QTDE	"		,"@E 999,999.99",16)
TRCell():New(oSection1,"PR_UNIT"	,"TRB","PR_UNIT	"		,"@E 999,999.99",16)
TRCell():New(oSection1,"PRCVEN"		,"TRB","PR_VENDA"		,"@E 999,999.99",16)
TRCell():New(oSection1,"TOTAL"		,"TRB","VLR.MERC_LIQUIDO","@E 999,999.99",16)
TRCell():New(oSection1,"TOTSDESC"	,"TRB","VLR.MERC_BRUTO"	,"@E 999,999.99",16)
TRCell():New(oSection1,"FATCONV"	,"TRB","FATOR_CONVEÇÃO" ,"@E 999,999.99",16)
TRCell():New(oSection1,"TIPCONV"	,"TRB","TIPO_CONVENÇÃO"	,"@!"			,15)
TRCell():New(oSection1,"SEGUNID"	,"TRB","SEGUNDA UNIDADE","@!"			,4)
TRCell():New(oSection1,"QT_UNID_UN"	,"TRB","QTDE_UNID_UNICA","@E 999,999.99",16)
TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO"		,"@E 999,999.99",16)
TRCell():New(oSection1,"FRETE"		,"TRB","FRETE	"		,"@E 999,999.99",16)
TRCell():New(oSection1,"SEGURO"		,"TRB","SEGURO	"		,"@E 999,999.99",16)
TRCell():New(oSection1,"DESPESAS"	,"TRB","DESPESAS"		,"@E 999,999.99",16)
TRCell():New(oSection1,"VALTOT"		,"TRB","VRL.TOTAL_NOTA"	,"@E 999,999.99",16)
If MV_PAR07==1
	TRCell():New(oSection1,"CM_STD"	,"TRB","CM_STD	"		,"@E 999,999.999999",16)
ElseIf MV_PAR07==2
	TRCell():New(oSection1,"CM_ATUAL","TRB","CM_ATUAL"		,"@E 999,999.999999",16)
Else
	TRCell():New(oSection1,"CM_FECH","TRB","CM_FECH	"		,"@E 999,999.999999",16)
EndIf
TRCell():New(oSection1,"GRUPTRIB"	,"TRB","GRUPO_TRIBUTAÇÃO","@!"			 ,6)
TRCell():New(oSection1,"DESCGRTRI"	,"TRB","DESC_GRUP_TRIB"	 ,"@!"			 ,30)
TRCell():New(oSection1,"ICMS"		,"TRB","ICMS_DESTAQUE"	 ,"@E 999,999.99",16)
TRCell():New(oSection1,"ICMSTRIB"	,"TRB","ICMS_TRIBUTADO	","@E 999,999.99",16)
TRCell():New(oSection1,"ICMSISEN"	,"TRB","ICMS_ISENTO	"	 ,"@E 999,999.99",16)
TRCell():New(oSection1,"ICMSOUTR"	,"TRB","ICMS_OUTROS	"	 ,"@E 999,999.99",16)
TRCell():New(oSection1,"DESCZFR"	,"TRB","DESC_VEND_Z.FRANCA","@E 999,999.99",16)
TRCell():New(oSection1,"ICMS_ST"	,"TRB","ICMS_ST	"		 ,"@E 999,999.99",16)
TRCell():New(oSection1,"PISCOFINS"	,"TRB","PIS/CONFINS	"	 ,"@!",05)
TRCell():New(oSection1,"PIS"   		,"TRB","CONFINS		"	 ,"@E 999,999.99" ,16)
TRCell():New(oSection1,"CONFINS"	,"TRB","PIS	"			 ,"@E 999,999.99" ,16)
TRCell():New(oSection1,"VALISS"		,"TRB","VALISS	"		 ,"@E 999,999.99" ,16)
TRCell():New(oSection1,"XCANAL"  	,"TRB","CANAL DO CLIENTE","@!"			 ,30)
TRCell():New(oSection1,"DESCCAN"	,"TRB","DESC_CANAL"		 ,"@!"			 ,30)
TRCell():New(oSection1,"CCUSTO"  	,"TRB","CENT_CUSTO"		 ,"@!"			 ,30)
TRCell():New(oSection1,"DESCCUSTO"  ,"TRB","DESC_CENT_CUSTO" ,"@!"		     ,30)
TRCell():New(oSection1,"FINALID"	,"TRB","FINALID_TES"	 ,"@!"			 ,30)
TRCell():New(oSection1,"FINALIDA"	,"TRB","FINALID_DA_VENDA","@!"			 ,20)
TRCell():New(oSection1,"CM_STD_UN"  ,"TRB","CM_STD_UNITÁRIO	","@E 999,999.99",16)
TRCell():New(oSection1,"ITEMC"  	,"TRB","ITEM_CONTÁBIL	","@!"			 ,21)
TRCell():New(oSection1,"DCITEMC"  	,"TRB","DESC_ITEM_CONTÁBIL	" ,"@!"		,21)
TRCell():New(oSection1,"RECLIQ"	 	,"TRB","REC. LIQUIDA"	 ,"@E 999,999,999.99",16)
TRCell():New(oSection1,"MARGEM"	 	,"TRB","MARGEM"			 ,"@E 999,999,999.99",16)
TRCell():New(oSection1,"MARGEMP" 	,"TRB","MARGEM(%)"		 ,"@E 999,999,999.99",16)
TRCell():New(oSection1,"STDGERUNI"	,"TRB","STD_GERENCIA_UNIT","@E 999,999,999.99",16)
TRCell():New(oSection1,"STDGERTOT" 	,"TRB","STD_GERENCIA_TOT","@E 999,999,999.99",16)

TRCell():New(oSection1,"MESREF"  	,"TRB","MES REFERENCIA","@!",21) // Incluído em 25/04/2012 por Fabio Sales para trazer o Mes referencia do pedido de venda.
TRCell():New(oSection1,"CTAREC"  	,"TRB","CTA CONT RECEITA","@!",10)
TRCell():New(oSection1,"DESCCTREC"	,"TRB","DESC CTA RECEITA","@!",25)
TRCell():New(oSection1,"CNPJ_CPF"	,"TRB","CNPJ_CPF"		,"@!"			,14)

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
Local clTabSec2	:="Z4"
Local clTabSec3	:="21"
Local clTabSec4	:="Z7"
Local clFilial  :="01"
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
Local clCodSup	:=""
Local clCodger	:=""
Local cDescCta	:= ""

/*-------------------------------|
| criação do arquivo de trabalho |
|-------------------------------*/

_aStru	:= {}

AADD(_aStru,{"TIPO"		,"C",20,0})
AADD(_aStru,{"NOTA"		,"C",09,0})
AADD(_aStru,{"SERIE"	,"C",03,0})
AADD(_aStru,{"CNPJ_CPF"	,"C",14,0})
AADD(_aStru,{"COD_CLI"	,"C",06,0})
AADD(_aStru,{"CODVEND"	,"C",06,0})
AADD(_aStru,{"VENDED"	,"C",40,0})
AADD(_aStru,{"CLIENTE"	,"C",40,0})
AADD(_aStru,{"ITEM"		,"C",04,0})
AADD(_aStru,{"PRODUTO"	,"C",15,0})
AADD(_aStru,{"DESCPRO"	,"C",30,0})
AADD(_aStru,{"UNI_MED"	,"C",02,0})
AADD(_aStru,{"SUBGRUP"	,"C",04,0})
AADD(_aStru,{"LOCALPD"	,"C",06,0})
AADD(_aStru,{"DESCARM"	,"C",30,0})
AADD(_aStru,{"TES"		,"C",03,0})
AADD(_aStru,{"CFOP"		,"C",05,0})
AADD(_aStru,{"NCM"		,"C",10,0})
AADD(_aStru,{"QTDE"		,"N",14,4})
AADD(_aStru,{"PRCVEN"	,"N",14,4})
AADD(_aStru,{"TOTAL"	,"N",14,4})
AADD(_aStru,{"GUPTRIB"	,"C",06,0})
AADD(_aStru,{"ICMS"		,"N",14,4})
AADD(_aStru,{"DESCZFR"	,"N",14,4})
AADD(_aStru,{"ICMS_ST"	,"N",14,4})
AADD(_aStru,{"PISCOFINS","C",5,0})
AADD(_aStru,{"PIS"		,"N",14,4})
AADD(_aStru,{"CONFINS"	,"N",14,4})
AADD(_aStru,{"CM_STD"	,"N",16,6})
AADD(_aStru,{"CM_ATUAL"	,"N",16,6})
AADD(_aStru,{"CM_FECH"	,"N",16,6})
AADD(_aStru,{"CCUSTO"	,"C",09,0})
AADD(_aStru,{"DESCCUSTO","C",30,0})
AADD(_aStru,{"FINALID"	,"C",254,0})
AADD(_aStru,{"PR_UNIT"	,"N",14,4})
AADD(_aStru,{"DESCONTO"	,"N",14,4})
AADD(_aStru,{"FRETE"	,"N",14,4})
AADD(_aStru,{"SEGURO"	,"N",14,4})
AADD(_aStru,{"DESPESAS"	,"N",14,4})
AADD(_aStru,{"VALTOT"	,"N",14,4})
AADD(_aStru,{"FILIAL"	,"C",02,0})
AADD(_aStru,{"DESCFIL"	,"C",35,0})
AADD(_aStru,{"ESTADO"	,"C",02,0})
AADD(_aStru,{"CIDADE"	,"C",35,0})
AADD(_aStru,{"EMISSAO"	,"D",08,0})
AADD(_aStru,{"LOJA"		,"C",04,0})
AADD(_aStru,{"ROMAN"	,"C",10,0})
AADD(_aStru,{"TRANSP"	,"C",06,0})
AADD(_aStru,{"PLACA"	,"C",08,0})
AADD(_aStru,{"MOTOR"	,"C",40,2})
AADD(_aStru,{"CHVNFE"	,"C",12,0})
AADD(_aStru,{"GRUPO"	,"C",04,0})
AADD(_aStru,{"SECAO"	,"C",04,0})
AADD(_aStru,{"LINHA"	,"C",03,0})
AADD(_aStru,{"GRUPTRIB"	,"C",06,0})
AADD(_aStru,{"DESCGRTRI","C",30,0})
AADD(_aStru,{"DESCSUBG"	,"C",30,0})
AADD(_aStru,{"DESCSEC"	,"C",30,0})
AADD(_aStru,{"DESCGRUP"	,"C",30,0})
AADD(_aStru,{"DESCLIN"	,"C",30,0})
AADD(_aStru,{"PEDIDO"	,"C",06,0})
AADD(_aStru,{"VALISS"	,"N",14,4})
AADD(_aStru,{"ICMSTRIB"	,"N",14,4})
AADD(_aStru,{"ICMSISEN"	,"N",14,4})
AADD(_aStru,{"ICMSOUTR"	,"N",14,4})
AADD(_aStru, {"FATCONV"	,"N",14,4})
AADD(_aStru, {"TIPCONV"	,"C",2,0})
AADD(_aStru, {"SEGUNID"	,"C",6,0})
AADD(_aStru, {"QT_UNID_UN","N",14,4})
AADD(_aStru, {"CM_STD_UN","N",14,4})
AADD(_aStru, {"TOTSDESC","N",14,4})
AADD(_aStru, {"XCANAL"	,"C",05,0})
AADD(_aStru, {"DESCCAN"	,"C",30,0})
AADD(_aStru, {"FINALIDA","C",20,0})
AADD(_aStru, {"ITEMC"	,"C",21,0})
AADD(_aStru, {"DCITEMC"	,"C",35,0})
AADD(_aStru, {"SUPERV"	,"C",06,0})
AADD(_aStru, {"GERENT"	,"C",06,0})
AADD(_aStru, {"DESCSUPER","C",35,0})
AADD(_aStru, {"DESCGEREN","C",35,0})
AADD(_aStru, {"RECLIQ"	,"N",14,4})
AADD(_aStru, {"MARGEM"	,"N",14,4})
AADD(_aStru, {"MARGEMP"	,"N",14,4}) 
AADD(_aStru, {"STDGERUNI","N",14,4})
AADD(_aStru, {"STDGERTOT","N",14,4})
AADD(_aStru, {"MESREF","C",06,0})  // Incluído em 25/04/2012 para trazer o Mês de referencia do pedido de venda
AADD(_aStru, {"CTAREC","C",10,0})
AADD(_aStru, {"DESCCTREC","C",25,0}) 

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
	_cQuery += " CASE WHEN SF2.F2_XFINAL='@' THEN SF2.F2_XFINAL ELSE SD2.D2_TIPO END AS TIPO , 
	_cQuery += " SA1.A1_CGC CGC, SD2.D2_CLIENTE, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CF, SD2.D2_TES, SD2.D2_CCUSTO,SF2.F2_VEND1,SF2.F2_XFINAL AS FINALIDADE, SA3.A3_NOME,A3_SUPER AS SUPER,A3_GEREN AS GERENT, "
	_cQuery += " SF4.F4_TEXTO, SF4.F4_FINALID, SD2.D2_GRUPO, SD2.D2_ITEM,SD2.D2_COD, SD2.D2_PRCVEN, SB1.B1_CUSTD,SB1.B1_XPISCOF AS XPISCOF,SF2.F2_XCARGA AS ROMAN,SF2.F2_CHVNFE AS CHAVENFE, "
	_cQuery += " SB1.B1_TIPCONV,SB1.B1_CONV,SB1.B1_SEGUM,'QUNICPROD'=CASE WHEN SB1.B1_TIPCONV='M' THEN (SD2.D2_QUANT * SB1.B1_CONV) ELSE 0 END,	  "
	_cQuery += " SF2.F2_TRANSP AS TRANSP,SF2.F2_XPLACA AS PLACA,SF2.F2_XMOTOR AS MOTORISTA,SB1.B1_GRUPO,SB1.B1_XSECAO AS XSECAO,SB1.B1_XFAMILI AS XFAMILI,SB1.B1_LOCPAD, "
	_cQuery += " SD2.D2_LOCAL, SB1.B1_DESC,SB1.B1_UM,SB1.B1_XSUBGRU AS XSUBGRU,SB1.B1_GRTRIB,SB1.B1_POSIPI, SD2.D2_TOTAL AS TOTAL, SD2.D2_QUANT, SD2.D2_VALICM,SD2.D2_ICMSRET,SD2.D2_DESCZFR,SD2.D2_VALIMP5, "
	_cQuery += " SD2.D2_VALIMP6, SD2.D2_PRUNIT, SD2.D2_DESCON, SD2.D2_EST, SD2.D2_VALFRE, SD2.D2_SEGURO,TOTALSDES=CASE WHEN SD2.D2_DESCON<>0 THEN (D2_QUANT * (D2_PRCVEN + (D2_DESCON/D2_QUANT))) ELSE D2_TOTAL END, "
	_cQuery += " SD2.D2_DESPESA,SD2.D2_EMISSAO, SD2.D2_FILIAL, SA1.A1_NOME, SA1.A1_LOJA,SA1.A1_MUN,SA1.A1_XCANAL AS XCANAL,SD2.D2_ITEMCC, "
	_cQuery += " (SD2.D2_TOTAL + SD2.D2_SEGURO + SD2.D2_VALFRE + SD2.D2_DESPESA) AS VALTOT,SD2.D2_PEDIDO AS PEDIDO,SD2.D2_VALISS AS VALISS, "
	_cQuery += " SFT.FT_VALICM AS VALICMTRIB ,SFT.FT_ISENICM AS ISENICM ,SFT.FT_OUTRICM AS OUTRICM,'' AS NFORI,'' AS SERIORI,SB1.B1_XREC AS CONTAREC "
	_cQuery += " FROM "
	_cQuery += " "+RetSQLName("SD2")+" AS SD2 INNER JOIN "
	
	If cEmpAnt=='02'
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD2.D2_FILIAL = SA1.A1_FILIAL AND SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA "
	Else
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA "
	EndIf
	
	_cQuery += "  INNER JOIN "
	_cQuery += " "+RetSQLName("SB1")+" AS SB1 ON SD2.D2_COD = SB1.B1_COD "
	_cQuery += "  INNER JOIN "
	_cQuery += " "+RetSQLName("SF4")+" AS SF4 ON SD2.D2_TES = SF4.F4_CODIGO  "
	_cQuery += " AND SD2.D2_FILIAL = SF4.F4_FILIAL INNER JOIN "
	_cQuery += " "+RetSQLName("SF2")+" AS SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE 		"
	_cQuery += " AND SD2.D_E_L_E_T_ = SF2.D_E_L_E_T_ "
	_cQuery	+= " AND SD2.D2_CLIENTE	=SF2.F2_CLIENTE															"
	_cQuery	+= " AND SD2.D2_LOJA	=SF2.F2_LOJA															"
	_cQuery	+= " AND SD2.D2_EMISSAO	=SF2.F2_EMISSAO															"
	_cQuery += " AND SD2.D2_FILIAL 	= SF2.F2_FILIAL LEFT JOIN "
	_cQuery += " "+RetSQLName("SA3")+" AS SA3 ON SF2.F2_VEND1 = SA3.A3_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSQLName("SFT")+" AS SFT ON SD2.D2_FILIAL=SFT.FT_FILIAL AND SD2.D2_DOC = SFT.FT_NFISCAL "
	_cQuery += " AND SD2.D2_SERIE=SFT.FT_SERIE AND SD2.D2_EMISSAO=SFT.FT_EMISSAO "
	_cQuery += " AND SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA "
	_cQuery += " AND SD2.D2_COD=SFT.FT_PRODUTO AND SD2.D2_ITEM=SFT.FT_ITEM AND SFT.FT_TIPOMOV = 'S' AND FT_CODISS='' "
	_cQuery += " AND SFT.D_E_L_E_T_<>'*' "
	
	_cQuery += " WHERE "
	_cQuery += " (SD2.D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"') AND (SD2.D2_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	_cQuery += " (SD2.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND (SD2.D2_DOC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND (SD2.D2_CCUSTO BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
	_cQuery += " (SD2.D2_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND (SD2.D2_TIPO IN( 'N','C')) 
	_cQuery += " AND (SF4.F4_DUPLIC = 'S' OR SF2.F2_XFINAL='@') " 
	//novos parametros de cliente de ate
	_cQuery += " AND SD2.D2_CLIENTE BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR16+"'"
	_cQuery += " AND SD2.D2_LOJA BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR17+"'"
	
	_cQuery += " AND SD2.D_E_L_E_T_<>'*' "
	_cQuery += " AND SF2.D_E_L_E_T_<>'*' "
	_cQuery += " AND SA1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SF4.D_E_L_E_T_<>'*' "
	_cQuery += " AND SB1.D_E_L_E_T_<>'*' "
	
	_cQuery += " UNION ALL " // Sintaxe ultilizada para unir um ou mais Selects desde que eles tenha a mesma estrutura de campos
	
	_cQuery += " SELECT "
	_cQuery += " SD1.D1_TIPO AS TIPO , SA1.A1_CGC CGC, SD1.D1_FORNECE, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_CF, SD1.D1_TES, SD1.D1_CC AS CCUSTO, '' AS VEND1,'' AS FINALIDADE,''AS A3_NOME,'' AS SUPER,'' AS GERENT, "
	_cQuery += " SF4.F4_TEXTO, SF4.F4_FINALID, SD1.D1_GRUPO, SD1.D1_ITEM,SD1.D1_COD, -SD1.D1_VUNIT, -SB1.B1_CUSTD,SB1.B1_XPISCOF AS XPISCOF,'' AS ROMAN,'' AS CHAVENFE, "
	_cQuery += " SB1.B1_TIPCONV,SB1.B1_CONV,SB1.B1_SEGUM,'QUNICPROD'=CASE WHEN SB1.B1_TIPCONV='M' THEN (SD1.D1_QUANT * SB1.B1_CONV) ELSE 0 END,		"
	_cQuery += " '' AS TRANSP,'' AS PLACA,'' AS MOTORISTA,SB1.B1_GRUPO,SB1.B1_XSECAO AS XSECAO,SB1.B1_XFAMILI AS XFAMILI,SB1.B1_LOCPAD, "
	
	_cQuery += " SD1.D1_LOCAL, SB1.B1_DESC,SB1.B1_UM,SB1.B1_XSUBGRU AS XSUBGRU,SB1.B1_GRTRIB,SB1.B1_POSIPI, -(SD1.D1_TOTAL - SD1.D1_VALDESC) AS TOTAL, -SD1.D1_QUANT, -SD1.D1_VALICM,-D1_ICMSRET,' 'DESCZFR, -SD1.D1_VALIMP5, "
	_cQuery += " -SD1.D1_VALIMP6, -SD1.D1_VUNIT, -SD1.D1_VALDESC, SA1.A1_EST, -SD1.D1_VALFRE, -SD1.D1_SEGURO,-SD1.D1_TOTAL AS  TOTALSDES, "
	_cQuery += " -SD1.D1_DESPESA, SD1.D1_DTDIGIT, SD1.D1_FILIAL, SA1.A1_NOME, SA1.A1_LOJA,SA1.A1_MUN,SA1.A1_XCANAL AS XCANAL,SD1.D1_ITEMCTA, "
	
	_cQuery += " -((SD1.D1_TOTAL + SD1.D1_SEGURO + SD1.D1_VALFRE + SD1.D1_DESPESA)- D1_VALDESC) AS VALTOT,SD1.D1_PEDIDO AS PEDIDO,-SD1.D1_VALISS AS VALISS, "
	_cQuery += " -SFT.FT_VALICM AS VALICMTRIB,-SFT.FT_ISENICM AS ISENICM,-SFT.FT_OUTRICM AS OUTRICM,SD1.D1_NFORI AS NFORI,SD1.D1_SERIORI AS SERIORI,SB1.B1_XDEV AS CONTAREC "
	_cQuery += " FROM "
	_cQuery += " "+RetSQLName("SD1")+" AS SD1 INNER JOIN "
	_cQuery += " "+RetSQLName("SB1")+" AS SB1 ON SD1.D1_COD = SB1.B1_COD INNER JOIN "
	
	If cEmpAnt =='02'
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD1.D1_FILIAL = SA1.A1_FILIAL AND SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA "
	Else
		_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA "
	EndIf
	
	_cQuery += " INNER JOIN "
	_cQuery += " "+RetSQLName("SF4")+" AS SF4 ON SD1.D1_TES = SF4.F4_CODIGO  "
	_cQuery += " AND SD1.D1_FILIAL = SF4.F4_FILIAL INNER JOIN "
	_cQuery += " "+RetSQLName("SF1")+" AS SF1 ON SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE "
	_cQuery += " AND SD1.D_E_L_E_T_ = SF1.D_E_L_E_T_ AND SD1.D1_FILIAL = SF1.F1_FILIAL "
	_cQuery += " AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND SD1.D1_EMISSAO=SF1.F1_EMISSAO  "
	_cQuery += " LEFT JOIN "+RetSQLName("SFT")+" AS SFT ON SD1.D1_FILIAL=SFT.FT_FILIAL AND SD1.D1_DOC = SFT.FT_NFISCAL "
	_cQuery += " AND SD1.D1_SERIE=SFT.FT_SERIE AND SD1.D1_DTDIGIT=SFT.FT_ENTRADA "
	_cQuery += " AND SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA "
	_cQuery += " AND SD1.D1_COD=SFT.FT_PRODUTO AND SD1.D1_ITEM=SFT.FT_ITEM AND SFT.FT_TIPOMOV = 'E' AND FT_CODISS='' "
	_cQuery += " AND SFT.D_E_L_E_T_<>'*' "
	
	_cQuery += " WHERE "
	_cQuery += " (SD1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"') AND (SD1.D1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	_cQuery += " (SD1.D1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND (SD1.D1_DOC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND (SD1.D1_CC BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
	_cQuery += " (SD1.D1_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND (SD1.D1_TIPO IN('C','D')) AND (SF4.F4_DUPLIC = 'S' ) AND D1_TES NOT IN('258','230','229') "
	_cQuery += " AND SD1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SF1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SB1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SA1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SF4.D_E_L_E_T_<>'*' "

// tratamento AMC
ElseIf cEmpAnt == "10"
	_cQuery := " SELECT "
	_cQuery += " SD2.D2_TIPO AS TIPO , 
	_cQuery += " SA1.A1_CGC CGC, SD2.D2_CLIENTE, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CF, SD2.D2_TES, SD2.D2_CCUSTO,SF2.F2_VEND1,'' AS FINALIDADE, SA3.A3_NOME,A3_SUPER AS SUPER,A3_GEREN AS GERENT, "
	_cQuery += " SF4.F4_TEXTO, SF4.F4_FINALID, SD2.D2_GRUPO, SD2.D2_ITEM,SD2.D2_COD, SD2.D2_PRCVEN, SB1.B1_CUSTD,'' AS XPISCOF,'' AS ROMAN,SF2.F2_CHVNFE AS CHAVENFE, "
	_cQuery += " SB1.B1_TIPCONV,SB1.B1_CONV,SB1.B1_SEGUM,'QUNICPROD'=CASE WHEN SB1.B1_TIPCONV='M' THEN (SD2.D2_QUANT * SB1.B1_CONV) ELSE 0 END,	  "
	_cQuery += " SF2.F2_TRANSP AS TRANSP,'' AS PLACA,'' AS MOTORISTA,SB1.B1_GRUPO,'' AS XSECAO,'' AS XFAMILI,SB1.B1_LOCPAD, "
	_cQuery += " SD2.D2_LOCAL, SB1.B1_DESC,SB1.B1_UM,'' AS XSUBGRU,SB1.B1_GRTRIB,SB1.B1_POSIPI, SD2.D2_TOTAL AS TOTAL, SD2.D2_QUANT, SD2.D2_VALICM,SD2.D2_ICMSRET,SD2.D2_DESCZFR,SD2.D2_VALIMP5, "
	_cQuery += " SD2.D2_VALIMP6, SD2.D2_PRUNIT, SD2.D2_DESCON, SD2.D2_EST, SD2.D2_VALFRE, SD2.D2_SEGURO,TOTALSDES=CASE WHEN SD2.D2_DESCON<>0 THEN (D2_QUANT * (D2_PRCVEN + (D2_DESCON/D2_QUANT))) ELSE D2_TOTAL END, "
	_cQuery += " SD2.D2_DESPESA,SD2.D2_EMISSAO, SD2.D2_FILIAL, SA1.A1_NOME, SA1.A1_LOJA,SA1.A1_MUN,'' AS XCANAL,SD2.D2_ITEMCC, "
	_cQuery += " (SD2.D2_TOTAL + SD2.D2_SEGURO + SD2.D2_VALFRE + SD2.D2_DESPESA) AS VALTOT,SD2.D2_PEDIDO AS PEDIDO,SD2.D2_VALISS AS VALISS, "
	_cQuery += " SFT.FT_VALICM AS VALICMTRIB ,SFT.FT_ISENICM AS ISENICM ,SFT.FT_OUTRICM AS OUTRICM,'' AS NFORI,'' AS SERIORI,'' AS CONTAREC "
	_cQuery += " FROM "
	_cQuery += " "+RetSQLName("SD2")+" AS SD2 INNER JOIN "
	
	
	_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA "
	
	_cQuery += "  INNER JOIN "
	_cQuery += " "+RetSQLName("SB1")+" AS SB1 ON SD2.D2_COD = SB1.B1_COD "
	_cQuery += "  INNER JOIN "
	_cQuery += " "+RetSQLName("SF4")+" AS SF4 ON SD2.D2_TES = SF4.F4_CODIGO  "
	_cQuery += "  INNER JOIN "
	_cQuery += " "+RetSQLName("SF2")+" AS SF2 ON SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE 		"
	_cQuery += " AND SD2.D_E_L_E_T_ = SF2.D_E_L_E_T_ "
	_cQuery	+= " AND SD2.D2_CLIENTE	=SF2.F2_CLIENTE															"
	_cQuery	+= " AND SD2.D2_LOJA	=SF2.F2_LOJA															"
	_cQuery	+= " AND SD2.D2_EMISSAO	=SF2.F2_EMISSAO															"
	_cQuery += " AND SD2.D2_FILIAL 	= SF2.F2_FILIAL LEFT JOIN "
	_cQuery += " "+RetSQLName("SA3")+" AS SA3 ON SF2.F2_VEND1 = SA3.A3_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSQLName("SFT")+" AS SFT ON SD2.D2_FILIAL=SFT.FT_FILIAL AND SD2.D2_DOC = SFT.FT_NFISCAL "
	_cQuery += " AND SD2.D2_SERIE=SFT.FT_SERIE AND SD2.D2_EMISSAO=SFT.FT_EMISSAO "
	_cQuery += " AND SD2.D2_CLIENTE=SFT.FT_CLIEFOR AND SD2.D2_LOJA=SFT.FT_LOJA "
	_cQuery += " AND SD2.D2_COD=SFT.FT_PRODUTO AND SD2.D2_ITEM=SFT.FT_ITEM AND SFT.FT_TIPOMOV = 'S' AND FT_CODISS='' "
	_cQuery += " AND SFT.D_E_L_E_T_<>'*' "
	
	_cQuery += " WHERE "
	_cQuery += " (SD2.D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"') AND (SD2.D2_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	_cQuery += " (SD2.D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND (SD2.D2_DOC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND (SD2.D2_CCUSTO BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
	_cQuery += " (SD2.D2_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND (SD2.D2_TIPO IN( 'N','C')) 
	_cQuery += " AND SF4.F4_DUPLIC = 'S'  "   
		//novos parametros de cliente de ate
	_cQuery += " AND SD2.D2_CLIENTE BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR16+"'"
	_cQuery += " AND SD2.D2_LOJA BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR17+"'"

	_cQuery += " AND SD2.D_E_L_E_T_<>'*' "
	_cQuery += " AND SF2.D_E_L_E_T_<>'*' "
	_cQuery += " AND SA1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SF4.D_E_L_E_T_<>'*' "
	_cQuery += " AND SB1.D_E_L_E_T_<>'*' "
	
	_cQuery += " UNION ALL " // Sintaxe ultilizada para unir um ou mais Selects desde que eles tenha a mesma estrutura de campos
	
	_cQuery += " SELECT "
	_cQuery += " SD1.D1_TIPO AS TIPO , SA1.A1_CGC CGC, SD1.D1_FORNECE, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_CF, SD1.D1_TES, SD1.D1_CC AS CCUSTO, '' AS VEND1,'' AS FINALIDADE,''AS A3_NOME,'' AS SUPER,'' AS GERENT, "
	_cQuery += " SF4.F4_TEXTO, SF4.F4_FINALID, SD1.D1_GRUPO, SD1.D1_ITEM,SD1.D1_COD, -SD1.D1_VUNIT, -SB1.B1_CUSTD,'' AS XPISCOF,'' AS ROMAN,'' AS CHAVENFE, "
	_cQuery += " SB1.B1_TIPCONV,SB1.B1_CONV,SB1.B1_SEGUM,'QUNICPROD'=CASE WHEN SB1.B1_TIPCONV='M' THEN (SD1.D1_QUANT * SB1.B1_CONV) ELSE 0 END,		"
	_cQuery += " '' AS TRANSP,'' AS PLACA,'' AS MOTORISTA,SB1.B1_GRUPO,'' AS XSECAO,'' AS XFAMILI,SB1.B1_LOCPAD, "
	
	_cQuery += " SD1.D1_LOCAL, SB1.B1_DESC,SB1.B1_UM,'' AS XSUBGRU,SB1.B1_GRTRIB,SB1.B1_POSIPI, -(SD1.D1_TOTAL - SD1.D1_VALDESC) AS TOTAL, -SD1.D1_QUANT, -SD1.D1_VALICM,-D1_ICMSRET,' 'DESCZFR, -SD1.D1_VALIMP5, "
	_cQuery += " -SD1.D1_VALIMP6, -SD1.D1_VUNIT, -SD1.D1_VALDESC, SA1.A1_EST, -SD1.D1_VALFRE, -SD1.D1_SEGURO,-SD1.D1_TOTAL AS  TOTALSDES, "
	_cQuery += " -SD1.D1_DESPESA, SD1.D1_DTDIGIT, SD1.D1_FILIAL, SA1.A1_NOME, SA1.A1_LOJA,SA1.A1_MUN,'' AS XCANAL,SD1.D1_ITEMCTA, "
	
	_cQuery += " -((SD1.D1_TOTAL + SD1.D1_SEGURO + SD1.D1_VALFRE + SD1.D1_DESPESA)- D1_VALDESC) AS VALTOT,SD1.D1_PEDIDO AS PEDIDO,-SD1.D1_VALISS AS VALISS, "
	_cQuery += " -SFT.FT_VALICM AS VALICMTRIB,-SFT.FT_ISENICM AS ISENICM,-SFT.FT_OUTRICM AS OUTRICM,SD1.D1_NFORI AS NFORI,SD1.D1_SERIORI AS SERIORI,'' AS CONTAREC "
	_cQuery += " FROM "
	_cQuery += " "+RetSQLName("SD1")+" AS SD1 INNER JOIN "
	_cQuery += " "+RetSQLName("SB1")+" AS SB1 ON SD1.D1_COD = SB1.B1_COD INNER JOIN "
	

	_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA "
	
	_cQuery += " INNER JOIN "
	_cQuery += " "+RetSQLName("SF4")+" AS SF4 ON SD1.D1_TES = SF4.F4_CODIGO  "
	_cQuery += " INNER JOIN "
	_cQuery += " "+RetSQLName("SF1")+" AS SF1 ON SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE "
	_cQuery += " AND SD1.D_E_L_E_T_ = SF1.D_E_L_E_T_ AND SD1.D1_FILIAL = SF1.F1_FILIAL "
	_cQuery += " AND SD1.D1_FORNECE = SF1.F1_FORNECE AND SD1.D1_LOJA = SF1.F1_LOJA AND SD1.D1_EMISSAO=SF1.F1_EMISSAO  "
	_cQuery += " LEFT JOIN "+RetSQLName("SFT")+" AS SFT ON SD1.D1_FILIAL=SFT.FT_FILIAL AND SD1.D1_DOC = SFT.FT_NFISCAL "
	_cQuery += " AND SD1.D1_SERIE=SFT.FT_SERIE AND SD1.D1_DTDIGIT=SFT.FT_ENTRADA "
	_cQuery += " AND SD1.D1_FORNECE=SFT.FT_CLIEFOR AND SD1.D1_LOJA=SFT.FT_LOJA "
	_cQuery += " AND SD1.D1_COD=SFT.FT_PRODUTO AND SD1.D1_ITEM=SFT.FT_ITEM AND SFT.FT_TIPOMOV = 'E' AND FT_CODISS='' "
	_cQuery += " AND SFT.D_E_L_E_T_<>'*' "
	
	_cQuery += " WHERE "
	_cQuery += " (SD1.D1_DTDIGIT BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"') AND (SD1.D1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	_cQuery += " (SD1.D1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND (SD1.D1_DOC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND (SD1.D1_CC BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND "
	_cQuery += " (SD1.D1_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"') AND (SD1.D1_TIPO IN('C','D')) AND (SF4.F4_DUPLIC = 'S' )  "
	_cQuery += " AND SD1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SF1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SB1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SA1.D_E_L_E_T_<>'*' "
	_cQuery += " AND SF4.D_E_L_E_T_<>'*' "

EndIf


If Select("TSQL1") > 0
	dbSelectArea("TSQL1")
	DbCloseArea()
EndIf

/*-----------------------------|
|cria a query e dar um apelido |
|-----------------------------*/

MemoWrite("COMPVEN.SQL",_cQuery) //Salva a Query na pasta sistem para consultas futuras
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
	
	DbSelectArea("ZZ1")
	DbSetOrder(1)
	If DbSeek(TSQL1->D2_FILIAL + TSQL1->D2_LOCAL)
		clDescPa:= ZZ1->ZZ1_DESCRI
	EndIf
	
	DbSelectArea("SX5")
	DbSetOrder(1)
	If DbSeek(XFILIAL("SX5")+clTabSec1+TSQL1->XSECAO)
		clDescSec1:=X5_DESCRI
	EndIf
	If DbSeek(XFILIAL("SX5")+clTabSec2+TSQL1->XSUBGRU)
		clDescSec2:=X5_DESCRI
	EndIf
	If DbSeek(XFILIAL("SX5")+clTabSec3+TSQL1->B1_GRTRIB)
		clDescSec3:=X5_DESCRI
	EndIf
	If DbSeek(XFILIAL("SX5")+clTabSec4+TSQL1->XCANAL)
		clDescSec4:=X5_DESCRI
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
	TRB->CNPJ_CPF	:= TSQL1->CGC
	TRB->COD_CLI	:= TSQL1->D2_CLIENTE
	TRB->LOJA		:= TSQL1->A1_LOJA
	TRB->CLIENTE	:= TSQL1->A1_NOME
	TRB->NOTA		:= TSQL1->D2_DOC
	TRB->ITEM		:= TSQL1->D2_ITEM
	TRB->PRODUTO	:= TSQL1->D2_COD
	TRB->DESCPRO	:= TSQL1->B1_DESC
	TRB->UNI_MED	:= TSQL1->B1_UM
	TRB->SUBGRUP	:= TSQL1->XSUBGRU
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
	TRB->DESCSUBG	:= clDescSec2
	TRB->DESCSEC	:= clDescSec1
	TRB->DESCGRUP	:= clDescg
	TRB->DESCLIN	:= clDescLin
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
	
	clCstduni:=TSQL1->B1_CUSTD
	
	clCstdTot:= TSQL1->D2_QUANT * clCstduni
	TRB->STDGERUNI := clCstduni
	TRB->STDGERTOT := clCstdTot 
	
	If cEmpAnt $ "01#02"
		TRB->MESREF	   := Posicione("SC5",3,TSQL1->D2_FILIAL+TSQL1->D2_CLIENTE+TSQL1->A1_LOJA+TSQL1->PEDIDO,"C5_XMESREF") // Incluído em 25/04/2012 para trazer o mês dereferência do pedido de venda
	EndIf
	
	TRB->CTAREC		:= TSQL1->CONTAREC
	TRB->DESCCTREC	:= Posicione("CT1",1,xFilial("CT1")+TSQL1->CONTAREC,"CT1_DESC01")
	
	
	MsUnlock()
	clNome:=""
	clDescCcd 	:=Space(30)
	clDescPa	:=Space(30)
	clDescSec1 	:=Space(30)
	clDescSec2	:=Space(30)
	clDescLin	:=Space(30)
	clDescg		:=Space(30)
	clDescSec3  :=Space(30)
	clDescSec4  :=Space(30)
	clFinalid   :=""
	clItemc		:=""
	clCodvend 	:= "" 
	clCodSup	:=""
	clCodger	:=""
	clCstduni   :=0
	clCstdTot   :=0
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
_cQuery += " WHERE B9_FILIAL    ='"+_cFilial +"' "
_cQuery += " AND B9_COD   ='"+_cCodPro +"' "
_cQuery += " AND B9_LOCAL ='"+_cLocal +"'  "
_cQuery += " AND LEFT(B9_DATA,6)  ='"+ ldData +"'  "
_cQuery += " AND D_E_L_E_T_=' '  "

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
	PutSx1(cPerg,'14','Cliente de            ?','','','mv_che','C',06,0,0,'G','','SA1','','','mv_par14',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'15','Loja de	             ?','','','mv_chf','C',04,0,0,'G','','','','','mv_par15',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'16','Cliente Ate           ?','','','mv_chg','C',06,0,0,'G','','SA1','','','mv_par16',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'17','Loja Ate	             ?','','','mv_chh','C',04,0,0,'G','','','','','mv_par17',,,'','','','','','','','','','','','','','') 
		
Return
