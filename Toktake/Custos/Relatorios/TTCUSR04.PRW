#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function RESPROD()


cString  := "SD3"
cTitulo  := "Resumo de Producao"
cDesc1   := "Demonstra Custo Resumido da Producao "
cDesc2   := "Podendo ou nao Considerar a Mao de Obra."
cDesc3   := " "
tamanho  := "G"
aReturn  := { "Zebrado", 1,"Administracao", 1, 1, 1, "",1 }
nomeprog := "RESPROD"
cPerg    := "RESPRD"
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


If cEmpAnt <> "01"
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

//AADD(_aStru,{"GRUPO","C",1,0})
AADD(_aStru,{"SECAO","C",3,0})
AADD(_aStru,{"PRODUTO","C",15,0})
AADD(_aStru,{"QTDTOT","N",14,2})
AADD(_aStru,{"VLRTOT","N",16,4})
AADD(_aStru,{"VLRSMOD","N",16,4})
AADD(_aStru,{"QTDINS","N",14,2})
AADD(_aStru,{"VLRINS","N",16,4})
AADD(_aStru,{"QTDEMB","N",14,2})
AADD(_aStru,{"VLREMB","N",16,4})
AADD(_aStru,{"QTDMP","N",14,2})
AADD(_aStru,{"VLRMP","N",16,4})
AADD(_aStru,{"QTDMOD","N",14,2})
AADD(_aStru,{"VLRMOD","N",16,4})
AADD(_aStru,{"QTDGGF","N",14,2})
AADD(_aStru,{"VLRGGF","N",16,4})
_cArqTrab	:= Criatrab(_aStru,.T.)
_cArqInd	:= CriaTrab(,.F.)
If Select("TRB")>0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

Use &_cArqTrab Shared New Alias TRB
IndRegua("TRB",_cArqInd,"SECAO+PRODUTO",,,"Selecionando Registros")

//USE CUSTO SHARED NEW ALIAS TRA

// MONTAGEM DA QUERY
cQuery := "SELECT D3_COD,B1_XSECAO,D3_OP"
cQuery += " FROM " + RetSqlName("SD3")+" SD3, "  + RetSqlName("SB1")+" SB1 "
cQuery += " WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"'  AND "
cQuery += " SB1.B1_FILIAL='"+xFilial("SB1")+"'  AND "
cQuery += " SD3.D3_COD =SB1.B1_COD  AND "
cQuery += " SD3.D3_OP <> '"+Space(Len(SD3->D3_OP))+"'  AND "
cQuery += " SUBSTRING(SD3.D3_CF,1,2) = 'PR'  AND "
cQuery += " SD3.D3_COD >= '"+MV_PAR01+"' AND "
cQuery += " SD3.D3_COD<= '"+MV_PAR02+"' AND "
cQuery += " SB1.B1_XSECAO >= '"+MV_PAR03+"' AND "
cQuery += " SB1.B1_XSECAO <= '"+MV_PAR04+"' AND "
cQuery += " SD3.D3_OP >= '"+MV_PAR05+"' AND "
cQuery += " SD3.D3_OP <= '"+MV_PAR06+"' AND "
cQuery += " SD3.D3_EMISSAO >= '" + DTOS(mv_par07) + "'  AND "
cQuery += " SD3.D3_EMISSAO <= '" + DTOS(mv_par08) + "'  AND "
cQuery += " SD3.D3_ESTORNO <> 'S'  AND "
cQuery += " SD3.D_E_L_E_T_=' '  AND SB1.D_E_L_E_T_=' '  GROUP BY D3_COD,B1_XSECAO,D3_OP"


cQuery := ChangeQuery(cQuery)

If Select("QRP")>0
	DbSelectArea("QRP")
	DbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRP",.T.,.T.)

DbSelectArea("QRP")
DbGoTop()
While ! Eof()
	// Qrp deve estar agrupado por produto + OP
	// Trazer Inicial do Secao do Produto na Query
	MsprocTxt("Produto "+QRP->D3_COD+"OP "+QRP->D3_OP)
	DbSelectArea("TRB")
//	_cGrupo	:=  Left(QRP->B1_GRUPO,1)
	_cSecao	:=  ALLTRIM(QRP->B1_XSECAO)	
	If ! DbSeek(_cSecao+QRP->D3_COD,.F.)
		RecLock("TRB",.T.)
		TRB->SECAO		:=	_cSecao		
		TRB->PRODUTO   :=	QRP->D3_COD
		MsUnlock()
	Endif
	DbSelectArea("SD3")
	DbSetOrder(1)
	DbSeek(xFilial("SD3")+QRP->D3_OP,.F.)
	While !Eof() .AND. SD3->(D3_FILIAL+D3_OP)==xFilial("SD3")+QRP->D3_OP
		If SD3->D3_ESTORNO =="S"
			DbSkip()
			Loop
		Endif
		If SD3->D3_EMISSAO < MV_PAR07 .OR. SD3->D3_EMISSAO>MV_PAR08
			DbSkip()
			Loop
		Endif
		DbSelectArea("SB1")
		DbSeek(xFilial("SB1")+SD3->D3_COD,.F.)
		_cSecao		:= (SB1->B1_XSECAO)
		_cCf		:= Left(SD3->D3_CF,1)
		_nQuant		:= SD3->D3_QUANT
		_nCusto		:= SD3->D3_CUSTO1
		// TRATAMENTO ESPECIAL PARA REQUISICOES DE PA 
		If ALLTRIM(SB1->B1_TIPO)=='AC' .AND. _nQuant > 0
		   _nPos	:= Ascan(_aCod,_cSecao+SD3->D3_COD)
		   If _nPos == 0 
		      AADD(_aCod,_cSecao+SD3->D3_COD)
		      AADD(_aQtd,_nQuant)
		   Else
		      _aQtd[_nPos] := _aQtd[_nPos]+_nQuant
		   Endif
		endif
		If MV_PAR09 == 2  // Custo Standard
			_nCusto	:= SD3->D3_QUANT * SB1->B1_STD
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
				Case ALLTRIM(SB1->B1_TIPO) $ "ME/IN/MC"  // INSUMO
					TRB->QTDINS := TRB->QTDINS + _nQuant
					TRB->VLRINS := TRB->VLRINS + _nCusto
					TRB->VLRSMOD	:= TRB->VLRSMOD	+ _nCusto
					
				Case ALLTRIM(SB1->B1_TIPO) $ "EB/EM"  // EMBALAGEM
					TRB->QTDEMB := TRB->QTDEMB + _nQuant
					TRB->VLREMB := TRB->VLREMB + _nCusto
					TRB->VLRSMOD	:= TRB->VLRSMOD	+ _nCusto
					
				Case ALLTRIM(SB1->B1_TIPO) $ "MP/PI"  // Materia Prima
					TRB->QTDMP  := TRB->QTDMP  + _nQuant
					TRB->VLRMP  := TRB->VLRMP  + _nCusto
					TRB->VLRSMOD	:= TRB->VLRSMOD	+ _nCusto
					
				Case ALLTRIM(SB1->B1_TIPO) =="MO" .AND. ALLTRIM(SB1->B1_GRUPO) $ "MOD/GGD" // Mao de Obra
					TRB->VLRMOD := TRB->VLRMOD + _nCusto
					
				Case ALLTRIM(SB1->B1_TIPO) $ "GG/GF/MO" .AND. ALLTRIM(SB1->B1_GRUPO) $ "MOI/GGI"  // Gastos Indiretos de Fabricacao
					TRB->VLRGGF := TRB->VLRGGF + _nCusto
			EndCase
		EndIf
		MsUnlock()
		DbSelectArea("SD3")
		DbSkip()
	Enddo
	DbSelectArea("QRP")
	DbSkip()
Enddo

// TRATAMENTO P.E.
// MONTAGEM DA QUERY

cQuery := "SELECT D3_COD,D3_NUMSEQ"
cQuery += " FROM " + RetSqlName("SD3")+" SD3, "  + RetSqlName("SB1")+" SB1 "
cQuery += " WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"'  AND "
cQuery += " SB1.B1_FILIAL='"+xFilial("SB1")+"'  AND "
cQuery += " SD3.D3_COD =SB1.B1_COD  AND "
cQuery += " SD3.D3_CF = 'DE4'  AND "  // ENTRADAS DE TRANSFERENCIAS
cQuery += " LEFT(SB1.B1_GRUPO,1)= 'Y' AND "
cQuery += " SD3.D3_EMISSAO >= '" + DTOS(mv_par07) + "'  AND "
cQuery += " SD3.D3_EMISSAO <= '" + DTOS(mv_par08) + "'  AND "
cQuery += " SD3.D3_ESTORNO <> 'S'  AND "
cQuery += " SD3.D_E_L_E_T_=' '  AND SB1.D_E_L_E_T_=' '  GROUP BY D3_COD,D3_NUMSEQ"

cQuery := ChangeQuery(cQuery)

If Select("QRP2")>0
	DbSelectArea("QRP2")
	DbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRP2",.T.,.T.)
DbSelectArea("QRP2")
DbGotop()
While ! Eof()
      DbSelectArea("SD3")
      DbSetOrder(4) // Numero Sequencial
      If !DbSeek(xFilial("SD3")+QRP2->D3_NUMSEQ,.F.)
         Alert("Numero Sequencial "+QRP2->D3_NUMSEQ+" Inexistente")
         DbSelectArea("QRP2")
         DbSkip()
      Endif
      DbSelectarea("SD3")
      While ! Eof() .AND. SD3->D3_FILIAL+SD3->D3_NUMSEQ == xFilial("SD3")+QRP2->D3_NUMSEQ
           If SD3->D3_COD == QRP2->D3_COD
               DbSkip()
               Loop
            Endif   
			DbSelectArea("SB1")
			DbSeek(xFilial("SB1")+SD3->D3_COD,.F.)
			_cSecao		:= (SB1->B1_XSECAO)
			_cCf		:= Left(SD3->D3_CF,1)
			_nQuant		:= SD3->D3_QUANT
			_nCusto		:= SD3->D3_CUSTO1
		    _nPos	:= Ascan(_aCod,_cSecao+SD3->D3_COD)
		    If _nPos == 0 
		      AADD(_aCod,_cSecao+SD3->D3_COD)
		      AADD(_aQtd,_nQuant)
		    Else
		      _aQtd[_nPos] := _aQtd[_nPos]+_nQuant
		    Endif
	        DbSelectArea("SD3")
	        DbSkip()
	  Enddo
	  DbSelectArea("QRP2")
	  DbSkip()
Enddo

/// FINAL TRATAMENTO P.E.


// Efetuar Abatimento das Requisicoes de PA e de PA Transferido P.E.
For _nElem := 1 to Len(_aCod)
    _cChave := _aCod[_nElem] 
    _nQuant	:= _aQtd[_nElem] 
    DbSelectArea("TRB")
    If DbSeek(_cChave) .AND. TRB->QTDTOT >= _nQuant 
       // Definicao Percentual de Abate
       _nPerc	:= ( TRB->QTDTOT - _nQuant) / TRB->QTDTOT
       RecLock("TRB",.F.)
			TRB->QTDTOT	 := TRB->QTDTOT - _nQuant
			TRB->VLRTOT	 := TRB->VLRTOT  * _nPerc
			TRB->QTDINS := TRB->QTDINS  * _nPerc
			TRB->VLRINS := TRB->VLRINS  * _nPerc
			TRB->VLRSMOD:= TRB->VLRSMOD * _nPerc
			TRB->QTDEMB := TRB->QTDEMB * _nPerc
			TRB->VLREMB := TRB->VLREMB * _nPerc
			TRB->QTDMP  := TRB->QTDMP  * _nPerc
			TRB->VLRMP  := TRB->VLRMP  * _nPerc
			TRB->VLRMOD := TRB->VLRMOD * _nPerc
			TRB->VLRGGF := TRB->VLRGGF * _nPerc
		msUnlock()
    Endif
Next

Return


Static Function fImprime()

Local _cPicture	:=	"@E 999,999,999"
Local _cPictMed	:=	"@E 99.99"

DbSelectArea("TRB")
DbGoTop()
SetRegua(LASTREC())
_cSecao	:= TRB->SECAO

_nSubQTDTOT	:= 0
_nSubVLRTOT	:= 0
_nSubVLRSMOD:= 0
_nSubQTDINS	:= 0
_nSubVLRINS	:= 0
_nSubQTDEMB := 0
_nSubVLREMB	:= 0
_nSubQTDMP	:= 0
_nSubVLRMP	:= 0
_nSubQTDMOD := 0
_nSubVLRMOD := 0
_nSubQTDGGF := 0
_nSubVLRGGF := 0

_nTotQTDTOT	:= 0
_nTotVLRTOT	:= 0
_nTotVLRSMOD:= 0
_nTotQTDINS	:= 0
_nTotVLRINS	:= 0
_nTotQTDEMB := 0
_nTotVLREMB	:= 0
_nTotQTDMP	:= 0
_nTotVLRMP	:= 0
_nTotQTDMOD := 0
_nTotVLRMOD := 0
_nTotQTDGGF := 0
_nTotVLRGGF := 0
nLin					:= 80

cCabec1:="            P  R  O  D  U T O                |CUSTO PRODUCAO TOTAL |CUSTO PRODUCAO S/ MOD |            I N S U M O S          |        E M B A L A G E M          |     M A T E R I A  P R I M A      | M A O  D E  O B R A |  "
cCabec2:="CODIGO   DESCRICAO                     QTDE  |     VALOR     MEDIO |      VALOR     MEDIO |       QTDE        VALOR     MEDIO |       QTDE        VALOR     MEDIO |       QTDE        VALOR     MEDIO |  DIRETA |  GIF      |  "


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
	If MV_PAR10 == 1  // Analitico
		@ nLin,000 PSAY Left(TRB->PRODUTO,15)
		@ nLin,010 PSAY LEFT(SB1->B1_DESC,15)
		@ nLin,034 PSAY Transform(TRB->QTDTOT,_cPicture)
		@ nLin,047 PSAY Transform(TRB->VLRTOT,_cPicture)
		@ nLin,062 PSAY Transform(TRB->(VLRTOT/QTDTOT),_cPictMed)
		@ nLin,070 PSAY Transform(TRB->VLRSMOD,_cPicture)
		@ nLin,085 PSAY Transform(TRB->(VLRSMOD/QTDTOT),_cPictMed)
		@ nLin,093 PSAY Transform(TRB->QTDINS,_cPicture)
		@ nLin,106 PSAY Transform(TRB->VLRINS,_cPicture)
		@ nLin,121 PSAY Transform(TRB->(VLRINS/QTDINS),_cPictMed)
		@ nLin,129 PSAY Transform(TRB->QTDEMB,_cPicture)
		@ nLin,142 PSAY Transform(TRB->VLREMB,_cPicture)
		@ nLin,157 PSAY Transform(TRB->(VLREMB/QTDEMB),_cPictMed)
		@ nLin,165 PSAY Transform(TRB->QTDMP,_cPicture)
		@ nLin,178 PSAY Transform(TRB->VLRMP,_cPicture)
		@ nLin,192 PSAY Transform(TRB->(VLRMP/QTDMP),_cPictMed)
		@ nLin,199 PSAY Transform(TRB->VLRMOD,"@E 9,999,999")
		@ nLin,210 PSAY Transform(TRB->VLRGGF,"@E  9,999,999")
		nLin++
	Endif
	_nSubQTDTOT	:= _nSubQTDTOT + TRB->QTDTOT
	_nSubVLRTOT	:= _nSubVLRTOT + TRB->VLRTOT
	_nSubVLRSMOD:= _nSubVLRSMOD+ TRB->VLRSMOD
	_nSubQTDINS	:= _nSubQTDINS + TRB->QTDINS
	_nSubVLRINS	:= _nSubVLRINS + TRB->VLRINS
	_nSubQTDEMB := _nSubQTDEMB + TRB->QTDEMB
	_nSubVLREMB	:= _nSubVLREMB + TRB->VLREMB
	_nSubQTDMP	:= _nSubQTDMP  + TRB->QTDMP
	_nSubVLRMP	:= _nSubVLRMP  + TRB->VLRMP
	_nSubQTDMOD := _nSubQTDMOD + TRB->QTDMOD
	_nSubVLRMOD := _nSubVLRMOD + TRB->VLRMOD
	_nSubQTDGGF := _nSubQTDGGF + TRB->QTDGGF
	_nSubVLRGGF := _nSubVLRGGF + TRB->VLRGGF
	
	_nTotQTDTOT	:= _nTotQTDTOT + TRB->QTDTOT
	_nTotVLRTOT	:= _nTotVLRTOT + TRB->VLRTOT
	_nTotVLRSMOD:= _nTotVLRSMOD+ TRB->VLRSMOD
	_nTotQTDINS	:= _nTotQTDINS + TRB->QTDINS
	_nTotVLRINS	:= _nTotVLRINS + TRB->VLRINS
	_nTotQTDEMB := _nTotQTDEMB + TRB->QTDEMB
	_nTotVLREMB	:= _nTotVLREMB + TRB->VLREMB
	_nTotQTDMP	:= _nTotQTDMP  + TRB->QTDMP
	_nTotVLRMP	:= _nTotVLRMP  + TRB->VLRMP
	_nTotQTDMOD := _nTotQTDMOD + TRB->QTDMOD
	_nTotVLRMOD := _nTotVLRMOD + TRB->VLRMOD
	_nTotQTDGGF := _nTotQTDGGF + TRB->QTDGGF
	_nTotVLRGGF := _nTotVLRGGF + TRB->VLRGGF
	DbSelectArea("TRB")
	DbSkip()
	If TRB->SECAO <> _cSecao .OR. EOF()
		nLin++
		_cNomeGru:= Posicione("SX5",1,xFilial("SX5")+"Z5"+_cSecao,"X5_DESCRI")
		@ nLin,000 PSAY "Total Secao:"
		@ nLin,014 PSAY _cSecao+'-'+Left(_cNomeGru,13)
		@ nLin,034 PSAY Transform(_nSubQTDTOT,_cPicture)
		@ nLin,047 PSAY Transform(_nSubVLRTOT,_cPicture)
		@ nLin,062 PSAY Transform(_nSubVLRTOT/_nSubQTDTOT,_cPictMed)
		@ nLin,070 PSAY Transform(_nSubVLRSMOD,_cPicture)
		@ nLin,085 PSAY Transform(_nSubVLRSMOD/_nSubQTDTOT,_cPictMed)
		@ nLin,093 PSAY Transform(_nSubQTDINS,_cPicture)
		@ nLin,106 PSAY Transform(_nSubVLRINS,_cPicture)
		@ nLin,121 PSAY Transform(_nSubVLRINS/_nSubQTDINS,_cPictMed)
		@ nLin,129 PSAY Transform(_nSubQTDEMB,_cPicture)
		@ nLin,142 PSAY Transform(_nSubVLREMB,_cPicture)
		@ nLin,157 PSAY Transform(_nSubVLREMB/_nSubQTDEMB,_cPictMed)
		@ nLin,165 PSAY Transform(_nSubQTDMP,_cPicture)
		@ nLin,178 PSAY Transform(_nSubVLRMP,_cPicture)
		@ nLin,192 PSAY Transform(_nSubVLRMP/_nSubQTDMP,_cPictMed)
		@ nLin,199 PSAY Transform(_nSubVLRMOD,"@E 9,999,999")
		@ nLin,210 PSAY Transform(_nSubVLRGGF,"@E  9,999,999")
		nLin++
		@ nLin,000 PSAY Replicate("-",219)
		nLin:=nLin + 2
		_cSecao	:= TRB->SECAO
		_nSubQTDTOT	:= 0
		_nSubVLRTOT	:= 0
		_nSubVLRSMOD:= 0
		_nSubQTDINS	:= 0
		_nSubVLRINS	:= 0
		_nSubQTDEMB := 0
		_nSubVLREMB	:= 0
		_nSubQTDMP	:= 0
		_nSubVLRMP	:= 0
		_nSubQTDMOD := 0
		_nSubVLRMOD := 0
		_nSubQTDGGF := 0
		_nSubVLRGGF := 0
		If Eof()
			nLin := nLin + 1
			@ nLin,000 PSAY "Total Geral:"
			@ nLin,034 PSAY Transform(_nTotQTDTOT,_cPicture)
			@ nLin,047 PSAY Transform(_nTotVLRTOT,_cPicture)
			@ nLin,062 PSAY Transform(_nTotVLRTOT/_nTotQTDTOT,_cPictMed)
			@ nLin,070 PSAY Transform(_nTotVLRSMOD,_cPicture)
			@ nLin,085 PSAY Transform(_nTotVLRSMOD/_nTotQTDTOT,_cPictMed)
			@ nLin,093 PSAY Transform(_nTotQTDINS,_cPicture)
			@ nLin,106 PSAY Transform(_nTotVLRINS,_cPicture)
			@ nLin,121 PSAY Transform(_nTotVLRINS/_nTotQTDINS,_cPictMed)
			@ nLin,129 PSAY Transform(_nTotQTDEMB,_cPicture)
			@ nLin,142 PSAY Transform(_nTotVLREMB,_cPicture)
			@ nLin,157 PSAY Transform(_nTotVLREMB/_nTotQTDEMB,_cPictMed)
			@ nLin,165 PSAY Transform(_nTotQTDMP,_cPicture)
			@ nLin,178 PSAY Transform(_nTotVLRMP,_cPicture)
			@ nLin,192 PSAY Transform(_nTotVLRMP/_nTotQTDMP,_cPictMed)
			@ nLin,199 PSAY Transform(_nTotVLRMOD,"@E 9,999,999")
			@ nLin,210 PSAY Transform(_nTotVLRGGF,"@E  9,999,999")
			nLin++
		Endif
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

// Secao/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Produto de          ? ","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"02","Produto ate         ? ","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"03","Secao de             ? ","","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","Z5"})
aAdd(aRegs,{cPerg,"04","Secao Ate            ? ","","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","Z5"})
aAdd(aRegs,{cPerg,"05","OP      de               ? ","","","mv_ch5","C",13,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
aAdd(aRegs,{cPerg,"06","OP      ate               ? ","","","mv_ch6","C",13,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
aAdd(aRegs,{cPerg,"07","Emissao de             ? ","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Emissao Ate           ? ","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Considera Custo  ? ","","","mv_ch9","C",01,0,0,"C","","mv_par09","Real","1","","","","Standard","2","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Tipo Relatorio      ? ","","","mv_chA","N",01,0,0,"C","","mv_par10","Analitico","1","","","","Sintetico","2","","","","","","","","","","","","","","","","","",""})

U_PutX1TT(cPerg, aRegs)

Return
