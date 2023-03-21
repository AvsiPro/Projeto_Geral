#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 16/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CONFSC07()

Local aArea     :=  GetArea()
Local cMsg 

If Alltrim(AAM->AAM_XPRDCM) == 'FRANQUIA' .AND. AAM->AAM_XFRANQ <> '1'
    cMsg := 'Será cobrada uma franquia inicial para este contrato no valor de R$ '+Transform(AAM->AAM_XQTVLM,"@E 999,999.99")

    If MsgYesNo(cMsg)
        Processa({|| Gerapv()},"Aguarde, gerando pedido")
    EndIF 
else
    MsgAlert("Contrato não tem franquia ou já foi faturada.")
EndIf 

RestArea(aArea)

Return


/*/{Protheus.doc} Gerapv
    (long_description)
    @type  Static Function
    @author user
    @since 16/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Gerapv()

Local cFilFat	:=	If(Posicione("SA1",1,XFILIAL("SA1")+AAM->AAM_CODCLI+AAM->AAM_LOJA,"A1_EST")=="RJ","0102","0101")
Local aCabec := {}
Local aItC6  := {}

Private lMsErroAuto := .F.

aAdd( aCabec , { "C5_FILIAL"    , cFilFat		        , Nil } ) 
aAdd( aCabec , { "C5_XTPPED"    , 'Q'                   , Nil } )
aAdd( aCabec , { "C5_TIPO"      , 'N'                   , Nil } )
aAdd( aCabec , { "C5_CLIENTE"   , AAM->AAM_CODCLI       , Nil } )
aAdd( aCabec , { "C5_LOJACLI"   , AAM->AAM_LOJA         , Nil } )
Aadd( aCabec , { "C5_MENNOTA"   , 'Faturamento Franquia Inicial', Nil } )
aAdd( aCabec , { "C5_CONDPAG"   , AAM->AAM_CPAGPV       , Nil } )    
aAdd( aCabec , { "C5_NATUREZ"   , "31101001  "          , Nil } )    
aAdd( aCabec , { "C5_XCONTRT"	, AAM->AAM_CONTRT   	, Nil })
    
aLinha := {}
aAdd( aLinha , { "C6_FILIAL"     , cFilFat		                          , Nil })
aAdd( aLinha , { "C6_ITEM"       , '01'  							      , Nil })
aAdd( aLinha , { "C6_PRODUTO"    , AAM->AAM_XPRDCM                        , Nil })
aAdd( aLinha , { "C6_QTDVEN"     , 1                                      , Nil })

If AAM->AAM_XTIPMI == "2"
	aAdd( aLinha , { "C6_PRCVEN"     , AAM->AAM_XQTVLM                        , Nil })
ELSE
	DbSelectArea("DA1")
	DbSetOrder(1)
	If Dbseek(xFilial("DA1")+AAM->AAM_XCODTA+AAM->AAM_XPRDCM)
		nPreco := DA1->DA1_PRCVEN
		aAdd( aLinha , { "C6_PRCVEN"     , AAM->AAM_XQTVLM*nPreco             , Nil })
	Else 
		MsgAlert("Produto franquia não encontrado na tabela de preço "+AAM->AAM_XCODTA)
		Return
	EndIf 
EndIf 
//aAdd( aLinha , { "C6_OPER"       , "08"                                   , Nil })
aAdd( aLinha , { "C6_TES"        , Posicione("SB1",1,xFilial("SB1")+AAM->AAM_XPRDCM,"B1_TS")  , Nil })  
aAdd( aLinha , { "C6_QTDLIB"     , 1            	                  , Nil })
aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

aAdd( aItC6 , aLinha ) 

lMsErroAuto := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
    
IF lMsErroAuto  
    MostraErro()
ELSE
    Processa({|| Geranf(cFilFat,SC5->C5_NUM,AAM->AAM_CPAGPV)},"Gerando NF")
    MSGALERT('Pedido gerado '+SC5->C5_NUM)
    Reclock("AAM",.F.)
    AAM->AAM_XFRANQ := '1'
    AAM->(MSUNLOCK())
EndIf 

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gera o faturamento dos pedidos do mes corrente            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function GeraNF(cFilFat,cPedido,cCond)

Local aArea	:=	GetArea()
Local cNota	:=	''
Private _aPVlNFs	:=	{}
Private _cCondPag	:=	cCond
Private _cSerie		:=	If(cFilFat=="0101","LOC","LRJ")
             

dbSelectArea("SC9")
if !dbSeek(xFilial("SC9")+cPedido)
	nQtdLib := SC6->C6_QTDVEN
	nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,.F.,.F.,.F.,.F.,.F.,.F.)
Endif

      
DbSelectArea("SC9")
DbSetOrder(1)
If DbSeek(xFilial("SC9")+cPedido)
	While SC9->(!EOF()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial("SC9")+cPedido .AND. EMPTY(SC9->C9_NFISCAL)
		//If Alltrim(SC9->C9_BLCRED) == "" .And. Alltrim(SC9->C9_BLEST) == ""
		    cTES := Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO,"C6_TES")
		    
			Aadd(_aPVlNFs,{ SC9->C9_PEDIDO,;
							SC9->C9_ITEM,;
							SC9->C9_SEQUEN,;
							SC9->C9_QTDLIB,;
							SC9->C9_PRCVEN,;
							SC9->C9_PRODUTO,;
							.F.,;
							SC9->(RecNo()),;
							SC5->(Recno(Posicione("SC5",1,xFilial("SC5")+SC9->C9_PEDIDO,""))),;
							SC6->(Recno(Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,""))),;
							SE4->(Recno(Posicione("SE4",1,xFilial("SE4")+_cCondPag,""))),;
							SB1->(Recno(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,""))),;
							SB2->(Recno(Posicione("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO,""))),;
							SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+cTES,""))) })
							//SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+_cTESPV,""))) })
		//EndIf
		
		DbSelectArea("SC9")
		DbSkip()
	End
EndIf 

If Len(_aPVlNFs) > 0
	/*/

		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Funcao    ³MaPvlNfs  ³ Autor ³Microsiga              ³ Data ³28.08.1999³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³Inclusao de Nota fiscal de Saida atraves do PV liberado     ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Retorno   ³                                                            ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ExpA1: Array com os itens a serem gerados                   ³±±
		±±³          ³ExpC2: Serie da Nota Fiscal                                 ³±±
		±±³          ³ExpL3: Mostra Lct.Contabil                                  ³±±
		±±³          ³ExpL4: Aglutina Lct.Contabil                                ³±±
		±±³          ³ExpL5: Contabiliza On-Line                                  ³±±
		±±³          ³ExpL6: Contabiliza Custo On-Line                            ³±±
		±±³          ³ExpL7: Reajuste de preco na nota fiscal                     ³±±
		±±³          ³ExpN8: Tipo de Acrescimo Financeiro                         ³±±
		±±³          ³ExpN9: Tipo de Arredondamento                               ³±±
		±±³          ³ExpLA: Atualiza Amarracao Cliente x Produto                 ³±±
		±±³          ³ExplB: Cupom Fiscal                                         ³±±
		±±³          ³ExpCC: Numero do Embarque de Exportacao                     ³±±
		±±³          ³ExpBD: Code block para complemento de atualizacao dos titu- ³±±
		±±³          ³ los financeiros.                                           ³±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		
		/*/	
		// -> Gera a NF
   		cNota := MAPVLNFS(_aPVlNFs,_cSerie,.F.,.F.,.F.,.F.,.F.,0,0,.F., .F.)
  		
EndIf

RestArea(aArea)

Return(cNota)
