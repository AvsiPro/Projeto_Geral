#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function TTCMVR01()

cString  := "SD3"
cTitulo  := "Resumo Custo de Producao"
cDesc1   := "Demonstra Custo Resumido da Producao "
cDesc2   := ""
cDesc3   := " "
tamanho  := "G"
aReturn  := { "Zebrado", 1,"Administracao", 1, 1, 1, "",1 }
nomeprog := "TTCMVR01"
cPerg    := "CMVR01"
nLastKey := 0
cCabec1  := " "
cCabec2  := " "
cCancel  := "***** CANCELADO PELO OPERADOR *****"
limite   := 220
lErro    := .f.
Private _aCod := {}
Private _aQtd := {}
Private m_pag  := 1
Private li     := 61


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cEmpAnt <> "01"
	Return
EndIf

ValPerg()
Pergunte(cPerg,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := nomeprog

wnrel := SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,"",.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString,.F.)

If nLastKey == 27
	Return
Endif

MsAguarde({|| fMontaTrb()},"Selecionando Registros")

RptStatus({|| fImprime()})

Return

//*********************************

Static Function FMontaTrb()

// Montagem Arquivo de Trabalho

_aStru	:= {}

AADD(_aStru,{"GRUPO","C",2,0})
AADD(_aStru,{"PRODUTO","C",15,0})
AADD(_aStru,{"QTDTOT","N",14,2})  // QTDE TOTAL DE CAIXAS PRODUZIDAS
AADD(_aStru,{"VLRTOT","N",16,4})  // VALOR TOTAL DE CAIXAS PRODUZIDAS
AADD(_aStru,{"QTDEMB","N",14,2})  // QTDE EMBALAGEM
AADD(_aStru,{"VLREMB","N",16,4})  // CUSTO EMBALAGEM
AADD(_aStru,{"QTDMP","N",14,2})   // QTDE MATERIA PRIMA
AADD(_aStru,{"VLRMP","N",16,4})   // VALOR MATERIA PRIMA
AADD(_aStru,{"QTDPX","N",14,2})   // QTDE MATERIA PRIMA
AADD(_aStru,{"VLRPX","N",16,4})   // VALOR MATERIA PRIMA
AADD(_aStru,{"VLRMOD","N",16,4})  // VALOR DA MAO DE OBRA DIRETA
AADD(_aStru,{"VLRGGD","N",16,4})  // 
AADD(_aStru,{"VLRGGT","N",16,4})  
AADD(_aStru,{"VLRMOI","N",16,4})  
AADD(_aStru,{"VLRGGI","N",16,4})  

_cArqTrab	:= Criatrab(_aStru,.T.)
_cArqInd	:= CriaTrab(,.F.)
If Select("TRB")>0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

Use &_cArqTrab Shared New Alias TRB
IndRegua("TRB",_cArqInd,"GRUPO+PRODUTO",,,"Selecionando Registros")



// MONTAGEM DA QUERY
cQuery := " SELECT D3_COD,D3_SEGUM,B1_GRUPO,D3_OP,SUM(D3_QUANT) AS QUANT,SUM(D3_CUSTO1)AS CUSTOPR"
cQuery += " FROM " + RetSqlName("SD3")+" SD3, "  + RetSqlName("SB1")+" SB1 "
cQuery += " WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"'  AND "
cQuery += " SB1.B1_FILIAL='"+xFilial("SB1")+"'  AND "
cQuery += " SD3.D3_COD =SB1.B1_COD  AND "
cQuery += " SD3.D3_OP <> '"+Space(Len(SD3->D3_OP))+"'  AND "
cQuery += " SUBSTRING(SD3.D3_CF,1,2) = 'PR'  AND "
cQuery += " SD3.D3_COD >= '"+MV_PAR01+"' AND "
cQuery += " SD3.D3_COD<= '"+MV_PAR02+"' AND "
cQuery += " SB1.B1_GRUPO >= '"+MV_PAR03+"' AND "
cQuery += " SB1.B1_GRUPO<= '"+MV_PAR04+"' AND "
cQuery += " SD3.D3_OP >= '"+MV_PAR05+"' AND "
cQuery += " SD3.D3_OP <= '"+MV_PAR06+"' AND "
cQuery += " SD3.D3_EMISSAO >= '" + DTOS(mv_par07) + "'  AND "
cQuery += " SD3.D3_EMISSAO <= '" + DTOS(mv_par08) + "'  AND "
cQuery += " SD3.D3_ESTORNO <> 'S'  AND "
// Filtro Para Considerar ou nao Conjunto
If MV_PAR11	== 2 // Apenas Conjuntos
	cQuery += " SD3.D3_SEGUM='CJ' AND "
Endif
If MV_PAR11	== 3 // Apenas Produtos que nao sao conjuntos
	cQuery += " SD3.D3_SEGUM<>'CJ' AND "
Endif
cQuery += " SD3.D_E_L_E_T_=' '  AND SB1.D_E_L_E_T_=' '  GROUP BY D3_COD,D3_SEGUM,B1_GRUPO,D3_OP"
cQuery := ChangeQuery(cQuery)
If Select("QRP")>0
	DbSelectArea("QRP")
	DbCloseArea()
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRP",.T.,.T.)
TCSETFIELD("QRP","QUANT","N",14,2)
TCSETFIELD("QRP","CUSTOPR","N",14,2)
DbSelectArea("QRP")
DbGoTop()
_cDataB9	:=DTOS(MV_PAR08)
//_cLocPr		:=	"01"
While ! Eof()
	// Qrp deve estar agrupado por produto + OP
	// Trazer Inicial do Grupo do Produto na Query
	MsprocTxt("Produto "+QRP->D3_COD+"OP "+QRP->D3_OP)
	DbSelectArea("TRB")
	_cGrupo	:=  Left(QRP->B1_GRUPO,2)
	_cSegUm	:= QRP->D3_SEGUM  // Tratamento especial para Conjunto
	If ! DbSeek(_cGrupo+QRP->D3_COD,.F.)
		RecLock("TRB",.T.)
		TRB->GRUPO		:=	_cGrupo
		TRB->PRODUTO   :=	QRP->D3_COD
		MsUnlock()
	Endif                            	
	// MONTAGEM DA QUERY PARA PEGAR AS REQUISICOES UTILIZADAS
	cQuery := "SELECT D3_COD,B1_GRUPO,B1_TIPO,B1_CUSTD,D3_OP,D3_CF,D3_TM,SUM(D3_QUANT) AS QUANT,SUM(D3_CUSTO1) AS CUSTO"
	cQuery += " FROM " + RetSqlName("SD3")+" SD3, "  + RetSqlName("SB1")+" SB1 "
	cQuery += " WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"'  AND "
	cQuery += " SB1.B1_FILIAL='"+xFilial("SB1")+"'  AND "
	cQuery += " SD3.D3_COD =SB1.B1_COD  AND "
	cQuery += " SD3.D3_OP <> '"+Space(Len(SD3->D3_OP))+"'  AND "
	//cQuery += " SUBSTRING(SD3.D3_CF,1,2) <> 'PR'  AND "
	cQuery += " SD3.D3_OP >= '"+QRP->D3_OP+"' AND "
	cQuery += " SD3.D3_OP <= '"+QRP->D3_OP+"' AND "
	cQuery += " SD3.D3_EMISSAO >= '" + DTOS(mv_par07) + "'  AND "
	cQuery += " SD3.D3_EMISSAO <= '" + DTOS(mv_par08) + "'  AND "
	cQuery += " SD3.D3_ESTORNO <> 'S'  AND "
	cQuery += " SD3.D_E_L_E_T_=' '  AND SB1.D_E_L_E_T_=' '  GROUP BY D3_COD,B1_GRUPO,B1_TIPO,D3_OP,D3_CF,D3_TM,B1_CUSTD"
	cQuery := ChangeQuery(cQuery)
	If Select("QRPD3")>0
		DbSelectArea("QRPD3")
		DbCloseArea()
	Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRPD3",.T.,.T.)
	TcSetField("QRP","QUANT","N",14,2)
	TcSetField("QRP","CUSTO","N",14,2)
	DbSelectArea("QRPD3")
	DbGoTop()
	While !Eof() 
		_cGrupo		:= Left(QRPD3->B1_GRUPO,2)
		_cCf		:= Left(QRPD3->D3_CF,1)
		_nQuant		:= QRPD3->QUANT
		_nCusto		:= QRPD3->CUSTO
		/// Tratamento de Custo Especial Para o Conjunto///
		If _cSegUm == "CJ" .AND. _cCF $ "R/D" .AND. QRPD3->B1_TIPO=='PA' .AND. MV_PAR12 ==2 // Tratamento especial Para Conjunto
			_cCodReCj	:= QRPD3->D3_COD
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+_cCodReCj,.F.)
			_cLocPr	:=	SB1->B1_LOCPAD
			_dDataFim:= MV_PAR08

			DbSelectarea("SB9")
			DbSetOrder(1)                
			If dbSeek(xFilial("SB9")+_cCodReCj+_cLocPR+DTOS(_dDataFim),.F.)
			   //_nCmCj	:= SB9->B9_XMODMES/SB9->B9_XPRDMES
			   _nCmCj	:= SB9->B9_XMODATU/SB9->B9_XQTDATU
			   _nCusto	:= _nQuant*_nCmCj
			Endif
		    DbSelectArea("QRPD3")
		Endif

		
		If MV_PAR09 == 2  // Custo Standard
			_nCusto	:= _nQuant* QRPD3->B1_CUSTD 
		Endif
		If _cCf == "D"   // Devolucao
			_nQuant	:=	_nQuant * (-1)
			_nCusto	:=	_nCusto * (-1)
		Endif
		DbSelectArea("TRB")
		RecLock("TRB",.F.)
		If _cCf	== "P"  // Producao
			TRB->QTDTOT	:= TRB->QTDTOT+_nQuant
		Endif
		If _cCF $ "R/D" // Requisicao / Devolucao
			TRB->VLRTOT	:= TRB->VLRTOT	+ _nCusto
			Do Case
				Case Left(QRPD3->B1_GRUPO,1) $ "1/2/6"  // MATERIA PRIMA
					TRB->VLRMP := TRB->VLRMP + _nCusto
				Case Left(QRPD3->B1_GRUPO,1) == "5"  // PEIXE
					TRB->VLRPX := TRB->VLRPX + _nCusto
				Case Left(QRPD3->B1_GRUPO,1) =="7"  // EMBALAGEM
					TRB->VLREMB := TRB->VLREMB + _nCusto
			EndCase
		EndIf
		MsUnlock()
		DbSelectArea("QRPD3")
		DbSkip()
	Enddo
	// Gravacao dos Valores de mao de obra ( diretas / idiretas / Gastos de fabricacao
/*
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+TRB->PRODUTO,.F.)
	_cLocPr	:=	SB1->B1_LOCPAD
	DbSelectarea("SB9")
	DbSetOrder(1)                
	If dbSeek(xFilial("SB9")+TRB->PRODUTO+_cLocPR+_cDataB9,.F.)
	   DbSelectarea("TRB")
	   RecLock("TRB",.F.)
	  		TRB->VLRMOD :=	SB9->B9_XMOD
			TRB->VLRGGD :=	SB9->B9_XGGD	 
			TRB->VLRMOI := 	SB9->B9_XMOI
			TRB->VLRGGI := 	SB9->B9_XGGI
	      msUnlock()
	Endif
*/	
	DbSelectArea("QRP")
	DbSkip()
Enddo


Return

Static Function fImprime()

Local _cPicture	:=	"@E 99,999,999"
Local _cPictCX	:=	"@E 999.99"


DbSelectArea("TRB")
DbGoTop()
SetRegua(LASTREC())
_cGrupo	:= TRB->GRUPO

_nSubQTDTOT	:= 0
_nSubVLRTOT	:= 0
_nSubQTDEMB := 0
_nSubVLREMB	:= 0
_nSubQTDMP	:= 0
_nSubVLRMP	:= 0
_nSubQTDPX	:= 0
_nSubVLRPX	:= 0
_nSubVLRMOD := 0
_nSubVLGGD := 0
_nSubVLGGT := 0
_nSubVLRMI := 0
_nSubVLGGI := 0
_nSubTotMod := 0                
_nSubTotDir := 0                
_nSubTotVar := 0                
_nSubTotGer := 0                
_nSubDireto	:= 0


_nTotQTDTOT	:= 0
_nTotVLRTOT	:= 0
_nTotQTDEMB := 0
_nTotVLREMB	:= 0
_nTotQTDMP	:= 0
_nTotVLRMP	:= 0
_nTotQTDPX	:= 0
_nTotVLRPX	:= 0
_nTotVLRMOD := 0
_nTotVLGGD := 0
_nTotVLGGT := 0
_nTotVLRMI := 0
_nTotVLGGI := 0
_nTotTotMod := 0                
_nTotTotDir := 0                
_nTotTotVar := 0                
_nTotTotGer := 0                
_nTotDireto	:= 0


                                                                                                                                                                  	
nLin		:= 80

//cCabec1:="            P  R  O  D  U T O         CAIXAS | CUSTO MATERIA PRIMA | CUSTO EMBALAGEM   | CUSTO MAO DE OBRA |                       |      CUSTO DIRETO     |                                   |     T O T A L  G E R A L    |  "
//cCabec2:="CODIGO  DESCRICAO                    PRODUCAO|     TOTAL   P/CAIXA |   TOTAL   P/CAIXA |    TOTAL   P/CAIXA|      GGD  |      GGT  |      TOTAL    P/CAIXA |      MOI  |        GGI |   DEPREC.|           TOTAL |  P/CAIXA  |  "

cCabec1:="            P  R  O  D  U T O         CAIXAS |     CUSTO PEIXE |CUSTO MAT. PRIMA| CUSTO  EMBALAGEM| CUSTO MAO DE OBRA |      CUSTO   DIRETO|            |   CUSTO   VARIAVEL|                      | T O T A L  G E R A L    |  " 
cCabec2:="CODIGO  DESCRICAO                    PRODUCAO|     TOTAL  CAIXA|    TOTAL  CAIXA|     TOTAL  CAIXA|     TOTAL   CAIXA |      TOTAL    CAIXA|        GGD |       TOTAL  CAIXA|       MOI  |   GGI   |     TOTAL    CAIXA      |"

cTitulo	:=	Alltrim(cTitulo) + " ( De: "+DTOC(MV_PAR07)+" Ate: "+DTOC(MV_PAR08)+" )" 

While ! Eof()
	IncRegua()
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+TRB->PRODUTO,.F.)
	DbSelectArea("TRB")
	If nLin  > 60
		cabec(cTitulo,cCabec1,cCabec2,nomeprog,tamanho,18)
		nLin  := 9
	Endif
    _nDeprec	:= 0  // Depreciacao /// Definir Regra
    _nDireto	:= TRB->(VLRPX+VLRMP+VLREMB+VLRMOD)
    _nVariavel	:= _nDireto + TRB->VLRGGD	
    _nTotGer	:= _nVariavel + TRB->(VLRMOI+VLRGGI)
	If MV_PAR10 == 1  // Analitico
		@ nLin,000 PSAY Left(TRB->PRODUTO,6)
		@ nLin,008 PSAY LEFT(SB1->B1_DESC,25)
		@ nLin,035 PSAY Transform(TRB->QTDTOT,_cPicture)
		@ nLin,046 PSAY Transform(TRB->VLRPX,_cPicture)
		@ nLin,057 PSAY Transform(TRB->(VLRPX/QTDTOT),_cPictCX)
		@ nLin,064 PSAY Transform(TRB->VLRMP,_cPicture)
		@ nLin,074 PSAY Transform(TRB->(VLRMP/QTDTOT),_cPictCX)
		@ nLin,081 PSAY Transform(TRB->VLREMB,_cPicture)
		@ nLin,092 PSAY Transform(TRB->(VLREMB/QTDTOT),_cPictCX)
		@ nLin,099 PSAY Transform(TRB->VLRMOD,_cPicture)
		@ nLin,110 PSAY Transform(TRB->(VLRMOD/QTDTOT),_cPictCX)
		@ nLin,121 PSAY Transform(_nDireto,_cPicture)
		@ nLin,133 PSAY Transform(_nDireto/TRB->QTDTOT,_cPictcx)
		@ nLin,141 PSAY Transform(TRB->VLRGGD,_cPicture)
		@ nLin,155 PSAY Transform(_nVariavel,_cPicture)
		@ nLin,166 PSAY Transform(_nVariavel/TRB->QTDTOT,_cPictcx)
    	@ nLin,174 PSAY Transform(TRB->VLRMOI,_cPicture)
		@ nLin,185 PSAY Transform(TRB->VLRGGI,_cPicture)
		@ nLin,197 PSAY Transform(_nTotGer,_cPicture)
		@ nLin,209 PSAY Transform(_nTotGer / TRB->QTDTOT ,_cPictCX)
		nLin++
	Endif                              			

	_nSubQTDTOT	:= _nSubQTDTOT + TRB->QTDTOT
	_nSubVLRTOT	:= _nSubVLRTOT + TRB->VLRTOT
	_nSubVLREMB	:= _nSubVLREMB + TRB->VLREMB
	_nSubVLRMP	:= _nSubVLRMP  + TRB->VLRMP
	_nSubVLRPX	:= _nSubVLRPX  + TRB->VLRPX
	_nSubVLRMOD := _nSubVLRMOD + TRB->VLRMOD
	_nSubVLGGD := _nSubVLGGD + TRB->VLRGGD
	_nSubVLGGT := _nSubVLGGT + TRB->VLRGGT
	_nSubVLRMI := _nSubVLRMI + TRB->VLRMOI
	_nSubVLGGI := _nSubVLGGI + TRB->VLRGGI
	_nSubTotDir := _nSubTotDir + _nDireto                
	_nSubTotVar := _nSubTotVar + _nVariavel                
	_nSubTotGer := _nSubTotGer + _nTotGer
	_nSubDepre	:=	0   // depreciacao
	_nTotDepre	:=	0   // depreciacao
	
	
	_nTotQTDTOT	:= _nTotQTDTOT + TRB->QTDTOT
	_nTotVLRTOT	:= _nTotVLRTOT + TRB->VLRTOT
	_nTotVLREMB	:= _nTotVLREMB + TRB->VLREMB
	_nTotVLRMP	:= _nTotVLRMP  + TRB->VLRMP
	_nTotVLRPX	:= _nTotVLRPX  + TRB->VLRPX
	_nTotVLRMOD := _nTotVLRMOD + TRB->VLRMOD
	_nTotVLGGD := _nTotVLGGD + TRB->VLRGGD
	_nTotVLGGT := _nTotVLGGT + TRB->VLRGGT
	_nTotVLRMI := _nTotVLRMI + TRB->VLRMOI
	_nTotVLGGI := _nTotVLGGI + TRB->VLRGGI
	_nTotTotDir := _nTotTotDir + _nDireto                
	_nTotTotVar := _nTotTotVar + _nVariavel                
	_nTotTotGer := _nTotTotGer + _nTotGer
	
	DbSelectArea("TRB")
	DbSkip()
	If TRB->GRUPO <> _cGrupo .OR. EOF()
		nLin++
		_cGrupo	:= _cGrupo+"00"
		_cNomeGru:= Posicione("SBM",1,xFilial("SBM")+_cGrupo,"BM_DESC")
		@ nLin,000 PSAY "Tot Categoria:"
		@ nLin,014 PSAY _cGrupo+'-'+Left(_cNomeGru,13)
		@ nLin,035 PSAY Transform(_nSubQTDTOT,_cPicture)
		@ nLin,046 PSAY Transform(_nSubVLRPX,_cPicture)
		@ nLin,057 PSAY Transform(_nSubVLRPX/_nSubQTDTOT,_cPictCX)
		@ nLin,064 PSAY Transform(_nSubVLRMP,_cPicture)
		@ nLin,074 PSAY Transform(_nSubVLRMP/_nSubQTDTOT,_cPictCX)
		@ nLin,081 PSAY Transform(_nSubVLREMB,_cPicture)
		@ nLin,092 PSAY Transform(_nSubVLREMB/_nSubQTDTOT,_cPictCX)
		@ nLin,099 PSAY Transform(_nSubVLRMOD,_cPicture)
		@ nLin,110 PSAY Transform(_nSubVLRMOD/_nSubQTDTOT,_cPictCX)
		@ nLin,121 PSAY Transform(_nSubTotDir,_cPicture)
		@ nLin,133 PSAY Transform(_nSubTotDir/_nSubQTDTOT,_cPictcx)
		@ nLin,141 PSAY Transform(_nSubVLGGD,_cPicture)
		@ nLin,155 PSAY Transform(_nSubTotVar,_cPicture)
		@ nLin,166 PSAY Transform(_nSubTotVar/_nSubQTDTOT,_cPictcx)
		@ nLin,174 PSAY Transform(_nSubVLRMI,_cPicture)
		@ nLin,185 PSAY Transform(_nSubVLGGI,_cPicture)
		@ nLin,197 PSAY Transform(_nSubTotGer,_cPicture)
		@ nLin,209 PSAY Transform(_nSubTotGer / _nSubQTDTOT ,_cPictCX)
		nLin++
		@ nLin,000 PSAY Replicate("-",219)
		nLin:=nLin + 2
		_nSubQTDTOT	:= 0
		_nSubVLRTOT	:= 0
		_nSubQTDEMB := 0
		_nSubVLREMB	:= 0
		_nSubQTDMP	:= 0
		_nSubVLRMP	:= 0
		_nSubQTDPX	:= 0
		_nSubVLRPX	:= 0
		_nSubVLRMOD := 0
		_nSubVLGGD := 0
		_nSubVLGGT := 0
		_nSubVLRMI := 0
		_nSubVLGGI := 0
		_nSubTotMod := 0                
		_nSubTotDir := 0                
		_nSubTotVar := 0                
		_nSubTotGer := 0                
		_nSubDireto	:= 0
		//If Eof()
		If LEFT(TRB->GRUPO,1) <> Left(_cGrupo,1) .OR. EOF()
			_cGrp	:= Left(_cGrupo,1)+"000"
			_cNomeGrp:= Posicione("SBM",1,xFilial("SBM")+_cGrp,"BM_DESC")
			@ nLin,000 PSAY "Tot Grupo:"
			@ nLin,014 PSAY _cGrp+'-'+Left(_cNomeGrp,13)
			@ nLin,035 PSAY Transform(_nTotQTDTOT,_cPicture)
			@ nLin,046 PSAY Transform(_nTotVLRPX,_cPicture)
			@ nLin,057 PSAY Transform(_ntotVLRPX/_ntotQTDTOT,_cPictCX)
			@ nLin,064 PSAY Transform(_ntotVLRMP,_cPicture)
			@ nLin,074 PSAY Transform(_ntotVLRMP/_ntotQTDTOT,_cPictCX)
			@ nLin,081 PSAY Transform(_ntotVLREMB,_cPicture)
			@ nLin,092 PSAY Transform(_ntotVLREMB/_ntotQTDTOT,_cPictCX)
			@ nLin,099 PSAY Transform(_ntotVLRMOD,_cPicture)
			@ nLin,110 PSAY Transform(_ntotVLRMOD/_ntotQTDTOT,_cPictCX)
			@ nLin,121 PSAY Transform(_ntotTotDir,_cPicture)
			@ nLin,133 PSAY Transform(_ntotTotDir/_ntotQTDTOT,_cPictcx)
			@ nLin,141 PSAY Transform(_ntotVLGGD,_cPicture)
			@ nLin,155 PSAY Transform(_ntotTotVar,_cPicture)
			@ nLin,166 PSAY Transform(_ntotTotVar/_ntotQTDTOT,_cPictcx)
			@ nLin,174 PSAY Transform(_ntotVLRMI,_cPicture)
			@ nLin,185 PSAY Transform(_ntotVLGGI,_cPicture)
			@ nLin,197 PSAY Transform(_ntotTotGer,_cPicture)
			@ nLin,209 PSAY Transform(_ntotTotGer / _ntotQTDTOT ,_cPictCX)
			nLin++ 
			@ nLin,000 PSAY Replicate("=",219)
			nlin++
			nlin++
			_nTotQTDTOT	:= 0
			_nTotVLRTOT	:= 0
			_nTotQTDEMB := 0
			_nTotVLREMB	:= 0
			_nTotQTDMP	:= 0
			_nTotVLRMP	:= 0
			_nTotQTDPX	:= 0
			_nTotVLRPX	:= 0
			_nTotVLRMOD := 0
			_nTotVLGGD := 0
			_nTotVLGGT := 0
			_nTotVLRMI := 0
			_nTotVLGGI := 0
			_nTotTotMod := 0                
			_nTotTotDir := 0                
			_nTotTotVar := 0                
			_nTotTotGer := 0                
			_nTotDireto	:= 0
		Endif
		_cGrupo	:= TRB->GRUPO
	Endif
Enddo
TRB->(DbCloseArea())

Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

Return

Static Function ValPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Produto de      ? ","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"02","Produto ate     ? ","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"03","Grupo de        ? ","","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
aAdd(aRegs,{cPerg,"04","Grupo Ate       ? ","","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
aAdd(aRegs,{cPerg,"05","OP      de      ? ","","","mv_ch5","C",13,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
aAdd(aRegs,{cPerg,"06","OP      ate     ? ","","","mv_ch6","C",13,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
aAdd(aRegs,{cPerg,"07","Emissao de      ? ","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Emissao Ate     ? ","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Considera Custo ? ","","","mv_ch9","C",01,0,0,"C","","mv_par09","Real","1","","","","Standard","2","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Tipo Relatorio  ? ","","","mv_chA","N",01,0,0,"C","","mv_par10","Analitico","1","","","","Sintetico","2","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Tipo Filtro     ? ","","","mv_chb","N",01,0,0,"C","","mv_par11","Nao Considera","1","","","","Conjunto","2","","","","Normais","3","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Tipo Custo      ? ","","","mv_chc","N",01,0,0,"C","","mv_par12","Medio","1","","","","Variavel","2","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return
