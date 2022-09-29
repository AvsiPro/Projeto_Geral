#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
��Programa  � MTA410   � Autor � Artur Nucci Ferrari     � Data � 12/04/10 ��
��������������������������������������������������������������������������Ĵ�
��Descricao � Ponto de Entrada para Controles do pedido de venda           ��
��������������������������������������������������������������������������Ĵ�
��Uso       � Pedido de Venda                                              ��
��������������������������������������������������������������������������Ĵ�
��Empresa   � Tok Take                                                     ��
��������������������������������������������������������������������������Ĵ�
��Revisado  � Por            � Motivo                                      ��
��������������������������������������������������������������������������Ĵ�
��06/03/10  � Ricardo        � - Validar C.Custo no cab. pedido           -��
��          �                � - Validar Mes Referencia cab.pedido         ��
��������������������������������������������������������������������������Ĵ�
*/

User Function MTA410()

Local a_AreaATU := GetArea()
Local a_AreaSF4 := SF4->(GetArea())
Local a_AreaSB1 := SB1->(GetArea())
Local a_AreaSA1 := SA1->(GetArea())
Local l_OPERPV  := ""	//SuperGetMv("MV_XOPERPV")
Local dDtBloq   := stod("")	//SuperGetMV("MV_XBLQPED")
Local dDtBloqL  := stod("")	//SuperGetMV("MV_XBLQLIB")
Local nTimePV   := 0	//SuperGetMV("MV_XTIMEPV")
Local nValBPV   := 0	//SuperGetMV("MV_XVALBPV")
Local cEstado   := SuperGetMV("MV_ESTADO")
Local _cFinal   := ""	//AllTrim(SuperGetMv("MV_XFBLQPV"))
Local _cUserPV  := Upper(AllTrim(cusername))
Local _cUserNF  := ""	//AllTrim(SuperGetMv("MV_XUSRNFS"))
Local _cTESPC   := ""	//AllTrim(SuperGetMv("MV_XNFSNPC"))
Local _cHora    := Time()
Local _XGPV     := ""	//M->C5_XGPV
Local _CLIENTE  := M->C5_CLIENTE
Local _CLIPV    := M->C5_CLIENT
Local _LOJAENT  := M->C5_LOJAENT
Local _TPCLI    := M->C5_TIPOCLI
Local _TIPO     := M->C5_TIPO
Local _DEMISS   := M->C5_EMISSAO
Local _DENTRE   := dDatabase	//M->C5_XDTENTR
Local _cPrePed  := ""	//M->C5_XPREPED
Local _NFABAS   := ""	//M->C5_XNFABAS
Local _TPLIB    := M->C5_TIPLIB
Local _XFINAL   := ""	//M->C5_XFINAL
Local _NUMLIN   := 0	//M->C5_XQTDITM
Local _CODPA    := ""	//M->C5_XCODPA
Local _FATPA    := ""	//M->C5_XFATPA
Local _ITEMCC   := ""	//M->C5_XITEMCC
Local _cLocal   := ""	//AllTrim(M->C5_XLOCAL)
Local _C6NUM    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_NUM"})
Local _C6PRO    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_PRODUTO"})
Local _C6QTD    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_QTDVEN"})
Local _C6VAL    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_PRCVEN"})
Local _C6TOT    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_VALOR"})
Local _C6TES    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_TES"})
Local _C6CFO    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_CF"})
Local _C6OPE    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_OPER"})
Local _C6CST    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_CLASFIS"})
Local _C6LIB    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_QTDLIB"})
Local _C6LOC    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_LOCAL"})
Local _C6DEN    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_ENTREG"})
Local _C6GPV    := ""	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XGPV"})
Local _C6PDO    := ""	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XPRDORI"})
Local _C6QTO    := 0	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XQTDORI"})
Local _C6DTO    := stod("")	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XDTEORI"})
Local _C6_CC	:= Ascan(aHeader,{|x|AllTrim(x[2])=="C6_CCUSTO"})
Local _C6_IC	:= Ascan(aHeader,{|x|AllTrim(x[2])=="C6_ITEMCC"})
Local n_PosCC	:= Ascan(aHeader,{|x|AllTrim(x[2])=="C6_CCUSTO"})
Local n_PosIC	:= Ascan(aHeader,{|x|AllTrim(x[2])=="C6_ITEMCC"})
Local _C6USI    := ""	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XUSRINC"})
Local _C6DTI    := stod("")	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XDATINC"})
Local _C6HRI    := ""	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XHRINC"})
Local _C6USA    := ""	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XUSRALT"})
Local _C6DTA    := stod("")	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XDATALT"})
Local _C6HRA    := ""	//Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XHRALT"})
Local nTotPV    := 0
Local _CAT      := ""
Local _CNPJ     := ""
Local _cArm     := ""
Local _cSTrib   := ""
Local _cStLib   := 0
Local _lLibEst  := .T.
Local l_Ret     := .T.
Local _nDias    := 1
Local _nItens   := 1
Local cEPP      := "N"
Local _OPERA    := Space(2)
Local nDiaDDE1  := 3
Local nDiaDDE2  := 4
Local _FINAL    := Space(1)
Local _DUPLI    := Space(1)
Local _ESTQ     := Space(1)
Local _APROV    := Space(1)
Local _AFIXO    := Space(1)
Local _LIMITE   := 0
Local _RISCO    := Space(1)
Local _TOTPV    := ""
Local _CTRLPA   := ""
Local _VALATR   := 0
Local lEdi1	 := .F.
Local nCont	 := 0


// Tratamento para AMC
If cEmpAnt == "10"
	// calculo do peso liquido e peso bruto
	U_TTFAT04C()
	Return .T.
EndIf


l_OPERPV  := SuperGetMv("MV_XOPERPV")
dDtBloq   := SuperGetMV("MV_XBLQPED")
dDtBloqL  := SuperGetMV("MV_XBLQLIB")
nTimePV   := SuperGetMV("MV_XTIMEPV")
nValBPV   := SuperGetMV("MV_XVALBPV")
_cFinal   := AllTrim(SuperGetMv("MV_XFBLQPV"))
_cUserNF  := AllTrim(SuperGetMv("MV_XUSRNFS"))
_cTESPC   := AllTrim(SuperGetMv("MV_XNFSNPC"))
_XGPV     := M->C5_XGPV
_DENTRE   := M->C5_XDTENTR
_cPrePed  := M->C5_XPREPED
_NFABAS   := M->C5_XNFABAS
_XFINAL   := M->C5_XFINAL
_NUMLIN   := M->C5_XQTDITM
_CODPA    := M->C5_XCODPA
_FATPA    := M->C5_XFATPA
_ITEMCC   := M->C5_XITEMCC
_cLocal   := AllTrim(M->C5_XLOCAL)
_C6GPV    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XGPV"})
_C6PDO    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XPRDORI"})
_C6QTO    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XQTDORI"})
_C6DTO    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XDTEORI"})
_C6USI    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XUSRINC"})
_C6DTI    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XDATINC"})
_C6HRI    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XHRINC"})
_C6USA    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XUSRALT"})
_C6DTA    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XDATALT"})
_C6HRA    := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_XHRALT"})



//����������������������������������������������������������������������������Ŀ
//� CONTROLE DA DATA DE ENTREGA MINIMA                                         �
//������������������������������������������������������������������������������
// Domingo
If Dow(ddatabase)==1
	nDiaDDE1  := ddatabase+3
	nDiaDDE2  := ddatabase+4
	// Segunda
ElseIf Dow(ddatabase)==2
	nDiaDDE1  := ddatabase+3
	nDiaDDE2  := ddatabase+4
	// Ter�a
ElseIf Dow(ddatabase)==3
	nDiaDDE1  := ddatabase+3
	nDiaDDE2  := ddatabase+4
	// Quarta
ElseIf Dow(ddatabase)==4
	nDiaDDE1  := ddatabase+3
	nDiaDDE2  := ddatabase+5
	// Quinta
ElseIf Dow(ddatabase)==5
	nDiaDDE1  := ddatabase+4
	nDiaDDE2  := ddatabase+5
	// Sexta
ElseIf Dow(ddatabase)==6
	nDiaDDE1  := ddatabase+4
	nDiaDDE2  := ddatabase+5
	// S�bado
ElseIf Dow(ddatabase)==7
	nDiaDDE1  := ddatabase+4
	nDiaDDE2  := ddatabase+5
End

While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTEDI101/U_TTEDI110/CNTA120/U_TTFAT11C/U_TTEDI200/U_TTTMKA03/U_TTPROC22/U_TTPROC25/U_TTFAT21C/U_TTCNTLOC/U_TTFAT39C/U_TTPROC57" 
		lEdi1 := .T.
		Exit
	EndIf 
	nCont++
EndDo
     
//����������������������������������������������������������������������������Ŀ
//� CONTROLES DE CLIENTES                                                      �
//������������������������������������������������������������������������������
If _CLIENTE <> _CLIPV
	Aviso("Gerenciamento de Pedido de Venda","C�digo do cliente n�o deve ser diferente do cl�digo de cliente de entrega. Altere ara continuar.",{"Ok"},,"Aten��o:")
	Return .F.
eNDif
//����������������������������������������������������������������������������Ŀ
//� POSICIONA CLIENTE (SA1) / FORNECEDOR (SA2)                                 �
//������������������������������������������������������������������������������
If _TIPO$('D#B')
	_CNPJ  := Posicione("SA2",1,xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJAENT,"A2_CGC")
	_CEST  := Posicione("SA2",1,xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJAENT,"A2_EST")
	cEPP := 'N'
Else
	_CNPJ   := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT,"A1_CGC")
	_CEST   := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT,"A1_EST")
	_CAT    := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT,"A1_XNUMCAT")
	_RISCO  := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT,"A1_RISCO")
	_LIMITE := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT,"A1_LC")
	_CTRLPA := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT,"A1_XPA")
	_VALATR := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT,"A1_ATR")
	_INSCR  := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT,"A1_INSCR")
	If 'EPP'$SA1->A1_NOME
		cEPP := 'S'
	End
End
//����������������������������������������������������������������������������Ŀ
//� VERIFICA INCONSISTENCIA DE CFOP                                            �
//������������������������������������������������������������������������������
For n_Linha := 1 To Len(aCols)
	cF4CFO    := GetAdvFval("SF4","F4_CF",xFilial("SF4")+aCols[n_Linha,_C6TES],1)
	If SubStr(aCols[n_linha,  _C6CFO],2,3)<>SubStr(cF4CFO,2,3)
	    If UPPER(AllTrim(_INSCR))<>'ISENTO'
		MsgBox ("Numera��o do CFOP inconsistente. Verifique a TES digitada ou entre em contato com o Depto. Fiscal.","Erro!!!","STOP")
		Return .F.                         
		End
	End
	If SubStr(aCols[n_linha,  _C6CFO],1,1)=='5' .AND. cEstado#_CEST
		MsgBox ("CFOP inconsistente para opera��es fora do Estado. Verifique a TES digitada ou entre em contato com o Depto. Fiscal.","Erro!!!","STOP")
		Return .F.
	End
	If SubStr(aCols[n_linha,  _C6CFO],1,1)=='6' .AND. cEstado==_CEST
		MsgBox ("CFOP inconsistente para opera��es dentro do Estado. Verifique a TES digitada ou entre em contato com o Depto. Fiscal.","Erro!!!","STOP")
		Return .F.
	End
Next n_Linha
//����������������������������������������������������������������������������Ŀ
//� CONTROLA DEVOLU��O                                                         �
//������������������������������������������������������������������������������
If _TIPO=='D' .AND. _XFINAL<>'9'
	MsgBox ("Este pedido � de Devolu��o, a Finalidade de Venda tamb�m deve ser [9-Devolu��o].","Erro!!!","STOP")
	Return .F.
End
//����������������������������������������������������������������������������Ŀ
//� REGRAS DE NEGICIO POR EMPRESA                                              �
//������������������������������������������������������������������������������
If SM0->M0_CODIGO=="01" //.OR. SM0->M0_CODIGO=="11"
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLE DE FINALIDADE DE VENDA                                            �
	//������������������������������������������������������������������������������
	_FINAL  := Posicione("ZZC",1,xFilial("ZZC")+_XFINAL,"ZZC_FINAL")
	_DUPLI  := Posicione("ZZC",1,xFilial("ZZC")+_XFINAL,"ZZC_DUPLI")
	_ESTQ   := Posicione("ZZC",1,xFilial("ZZC")+_XFINAL,"ZZC_ESTQ")
	_APROV  := Posicione("ZZC",1,xFilial("ZZC")+_XFINAL,"ZZC_APROV")
	_AFIXO  := Posicione("ZZC",1,xFilial("ZZC")+_XFINAL,"ZZC_ATIVO")
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLE DE TES INTELIGENTE                                                �
	//������������������������������������������������������������������������������
	If l_OPERPV .AND. !lEdi1 .And. Alltrim(M->C5_XGPV) <> "PRO-A"
		_OPERA := U_TTOPERA(_XGPV,_TPCLI,_XFINAL,cEPP)
		If !Empty(_OPERA)
			For n_Linha := 1 To Len(aCols)
				_PRODUTO := aCols[n_Linha,_C6PRO]
				_QUANT   := aCols[n_Linha,_C6QTD]
				_VALOR   := aCols[n_Linha,_C6VAL]
				_TOTAL   := aCols[n_Linha,_C6TOT]
				_OPER    := aCols[n_Linha,_C6OPE]
				_TES     := ''
				_TES     := MaTesInt(2,_OPERA,_CLIENTE,_LOJAENT,If(_TIPO$'DB',"F","C"),_PRODUTO,"C6_TES")
			
				If !aCols[n_Linha, Len(aCols[n_Linha])]
					aCols[n_linha, n_PosCC] := If(empty(aCols[n_linha, n_PosCC]),M->C5_XCCUSTO,aCols[n_linha, n_PosCC])
					aCols[n_linha,  _C6OPE] := _OPERA
					aCols[n_linha,  _C6TES] := _TES
					RunTrigger(2,n_Linha,nil,,'C6_TES')
				Endif
				If !l_Ret
					Exit
				Endif
			Next n_Linha
		Else
			If U_TTVERTI(_XGPV,_XFINAL)
				MsgInfo("O pedido est� sem a configura��o da TES Inteligente.","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
		End
	Endif
	//����������������������������������������������������������������������������Ŀ-+
	//� CONTROLES PARA DUPLICADAS/ESTOQUE/ATF E CREDITO DE PIS/COFINS              �
	//������������������������������������������������������������������������������
	For n_Linha := 1 To Len(aCols)
		cB1PIS    := GetAdvFval("SB1","B1_XPISCOF",xFilial("SB1")+aCols[n_Linha,_C6PRO],1)
		cB1TIP    := GetAdvFval("SB1","B1_TIPO"   ,xFilial("SB1")+aCols[n_Linha,_C6PRO],1)
		cB1NCM    := GetAdvFval("SB1","B1_POSIPI" ,xFilial("SB1")+aCols[n_Linha,_C6PRO],1)
		cF4PIS    := GetAdvFval("SF4","F4_PISCOF" ,xFilial("SF4")+aCols[n_Linha,_C6TES],1)
		cF4DUP    := GetAdvFval("SF4","F4_DUPLIC" ,xFilial("SF4")+aCols[n_Linha,_C6TES],1)
		cF4EST    := GetAdvFval("SF4","F4_ESTOQUE",xFilial("SF4")+aCols[n_Linha,_C6TES],1)
		cF4ATF    := GetAdvFval("SF4","F4_ATUATF" ,xFilial("SF4")+aCols[n_Linha,_C6TES],1)
		//����������������������������������������������������������������������������Ŀ
		//� VENDA ATIFO FIXO                                                                 �
		//������������������������������������������������������������������������������
		If cF4ATF=='S' .AND. cF4DUP=='S'
			If _AFIXO<>'S'
				MsgInfo("A TES ["+AllTrim(aCols[n_Linha,_C6TES])+"] atualiza o Controle de Ativo Fixo com gera��o de duplicata, e n�o pode ser utilizada com a Finalidade de Venda ["+AllTrim(_FINAL)+"].","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
			If  AllTrim(cB1TIP)<>'AI'
				MsgInfo("O tipo do produto ["+AllTrim(aCols[n_Linha,_C6PRO])+"] n�o � [AI], e a TES ["+AllTrim(aCols[n_Linha,_C6TES])+"] est� configurada para saida de Ativo Fixo. Altere para uma TES.","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
		Else
			If _AFIXO=='S'
				MsgInfo("A TES ["+AllTrim(aCols[n_Linha,_C6TES])+"] n�o atualiza o Controle de Ativo Fixo ou n�o gera duplicata, e n�o pode ser utilizada com a Finalidade de Venda ["+AllTrim(_FINAL)+"].","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
		End
	
		//����������������������������������������������������������������������������Ŀ
		//� DUPLICATA                                                                  �
		//������������������������������������������������������������������������������
		/*If cF4DUP=='S'
			If Empty(aCols[n_Linha,_C6_CC])
				MsgInfo("A TES ["+AllTrim(aCols[n_Linha,_C6TES])+"] exige o preenchimento do Centro de Custos.","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
		End*/
		//����������������������������������������������������������������������������Ŀ
		//� CONTROLES DE NCM                                                           �
		//������������������������������������������������������������������������������
		If Empty(cB1NCM)
			MsgInfo("O produto ["+AllTrim(aCols[n_Linha,_C6PRO])+"] n�o tem o NCM cadastrato, favor entrar em contantato com o Depto. Fiscal.","ATEN��O!!!")
			lRet := .F.
			Return(lRet)
			
		End
		//����������������������������������������������������������������������������Ŀ
		//� CONTROLES PARA CREDITO DE PIS/COFINS                                       �
		//������������������������������������������������������������������������������
		/*If !(aCols[n_Linha,_C6TES]$(_cTESPC))
			If cF4DUP=='S'
				If Empty(aCols[n_Linha,_C6_CC])
					MsgInfo("A TES ["+AllTrim(aCols[n_Linha,_C6TES])+"] exige o preenchimento do Centro de Custos.","ATEN��O!!!")
					lRet := .F.
					Return(lRet)
				End
			End
		End*/
	
		//����������������������������������������������������������������������������Ŀ
		//� CONTA CONTABIL E CENTRO DE CUSTOS                                          �
		//������������������������������������������������������������������������������
		/*If SubStr(_CODPA,1,1)=='P' .AND. Empty(_ITEMCC)
			MsgInfo("A PA ["+AllTrim(_CODPA)+"] exige o preencimento do Item Cont�bil.","ATEN��O!!!")
			lRet := .F.
			Return(lRet)
		End
		If SubStr(aCols[n_Linha,_C6_CC],1,2)='03' .AND. Empty(aCols[n_Linha,_C6_IC])
			MsgInfo("O Centro de Custo ["+AllTrim(aCols[n_Linha,_C6_CC])+"] exige o preencimento do Item Cont�bil.","ATEN��O!!!")
			lRet := .F.
			Return(lRet)
		End*/
	Next n_Linha
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLE GPV                                                               �
	//������������������������������������������������������������������������������
	If Empty(_XGPV)
		_XGPV := U_TTUSRGPV()
	End
	//����������������������������������������������������������������������������Ŀ
	//� Controle de altara��es                                                     �
	//������������������������������������������������������������������������������
	If INCLUI
		For n_Linha := 1 To Len(aCols)
			aCols[n_linha, _C6PDO] := aCols[n_linha, _C6PRO]
			aCols[n_linha, _C6QTO] := aCols[n_linha, _C6QTD]
			aCols[n_linha, _C6DTO] := aCols[n_linha, _C6DEN]
		Next n_Linha
	End
	//����������������������������������������������������������������������������Ŀ
	//� ATUALIZA SC5 E SC6                                                         �
	//������������������������������������������������������������������������������
	M->C5_XGPV    := _XGPV
	//If AllTrim(_XGPV)$('KIT')
		//M->C5_TIPLIB := '2'
	//End
	For n_Linha := 1 To Len(aCols)
		aCols[n_linha, _C6DEN] := _DENTRE
		aCols[n_linha, _C6GPV] := _XGPV
		If !(Alltrim(aCols[n_linha,  _C6LOC])$_cLocal)
			_cLocal :=	_cLocal + AllTrim(aCols[n_linha,  _C6LOC])
		End
	Next n_Linha
	M->C5_XLOCAL  := _cLocal
	M->C5_XQTDITM := Len(aCols)
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLE DE APROVA��O                                                      �
	//������������������������������������������������������������������������������
	If _APROV=='S'
		M->C5_XSTLIB := 1
		_cStLib := 1
	Else
		M->C5_XSTLIB := 0
	End
	If _cStLib <> 0 .AND. !lEdi1 
		For n_Linha := 1 To Len(aCols)
			aCols[n_linha, _C6LIB] := 0
		Next n_Linha
		MsgInfo("Os pedidos com a Finalidade de Venda ["+AllTrim(_FINAL)+"] dever�o passar por aprova��o. Libera��o de Estoque Bloqueada","ATEN��O!!!")
	End
	//����������������������������������������������������������������������������Ŀ                     -+
	//� Ajuste da Situa��o Tributaria                                              �
	//������������������������������������������������������������������������������
	For n_Linha := 1 To Len(aCols)
		cB1ORI  := GetAdvFval("SB1","B1_ORIGEM",xFilial("SB1")+aCols[n_Linha,_C6PRO],1)
		_cSTrib := Posicione("SF4",1,xFilial("SF4")+aCols[n_Linha,_C6TES],"F4_SITTRIB")
		aCols[n_linha,_C6CST] := cB1ORI+SF4->F4_SITTRIB
	Next n_Linha
	
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLES TOK-TAKE FILIAL 01                                               �
	//������������������������������������������������������������������������������
	If SM0->M0_CODFIL=='01'
		//����������������������������������������������������������������������������Ŀ
		//� Controle de Linhas do Pedido                                               �
		//������������������������������������������������������������������������������
		If ALTERA
			If !(_cUserPV$(_cUserNF))
				If !(AllTrim(_XGPV)$'PRO-A#PRO-C#QLD#TEC')
					For n_Linha := 1 To Len(aCols)
						If SubStr(aCols[n_linha,  _C6PRO],1,1)=="2" .AND. SubStr(aCols[n_linha,  _C6LOC],1,1)=="D"
							If Val(SubStr(TIME(),1,2))<nTimePV
								If Len(aCols)<>_NUMLIN .AND. _DENTRE<nDiaDDE1
									MsgBox ("N�o � permitido a altera��o na quantidade dos itens.","Erro!!!","STOP")
									Return .F.
								End
							Else
								If Len(aCols)<>_NUMLIN .AND. _DENTRE<nDiaDDE2
									MsgBox ("N�o � permitido a altera��o na quantidade dos itens.","Erro!!!","STOP")
									Return .F.
								End
							End
						End
					Next
				End
			End
		End
		//����������������������������������������������������������������������������Ŀ
		//� Controle de Data de Entrega                                                �
		//������������������������������������������������������������������������������
		If !(_cUserPV$(_cUserNF))
			For n_Linha := 1 To Len(aCols)
				If aCols[n_linha,  _C6LOC]<>"R"
					If aCols[n_linha,  _C6LOC]=="D00026"
						If Val(SubStr(TIME(),1,2))<nTimePV
							If _DENTRE<nDiaDDE1
								Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(_DENTRE)+"] a data minima � ["+DTOC(nDiaDDE1)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
								l_Ret := .F.
								Exit
							End
						Else
							If _DENTRE<nDiaDDE2
								Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(_DENTRE)+"] a data minima � ["+DTOC(nDiaDDE2)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
								l_Ret := .F.
								Exit
							End
						End
					End
					If aCols[n_linha,  _C6LOC]=="D00015" .AND. SubStr(aCols[n_linha,  _C6PRO],1,2)="21"
						If Val(SubStr(TIME(),1,2))<nTimePV
							If _DENTRE<nDiaDDE1
								Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(_DENTRE)+"] a data minima � ["+DTOC(nDiaDDE1)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
								l_Ret := .F.
								Exit
							End
						Else
							If _DENTRE<nDiaDDE2
								Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(_DENTRE)+"] a data minima � ["+DTOC(nDiaDDE2)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
								l_Ret := .F.
								Exit
							End
						End
					End
					If aCols[n_linha,  _C6LOC]=="D00006"
						If Val(SubStr(TIME(),1,2))<nTimePV
							If _DENTRE<nDiaDDE1
								Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima � ["+DTOC(nDiaDDE1)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
								l_Ret := .F.
								Exit
							End
						Else
							If _DENTRE<nDiaDDE2
								Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima � ["+DTOC(nDiaDDE2)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
								l_Ret := .F.
								Exit
							End
						End
					End
				End
			Next n_Linha
		End
		//����������������������������������������������������������������������������Ŀ
		//� CONTROLE DE ARMAZENS NO PEDIDO                                             �
		//������������������������������������������������������������������������������
		For n_Linha := 1 To Len(aCols)
			_cArm := aCols[n_linha,  _C6LOC]
		Next n_Linha

		//����������������������������������������������������������������������������Ŀ
		//� CONTROLE P/ ABASTECIMENTO                                                  �
		//������������������������������������������������������������������������������
		If !_CLIENTE $ '006337/007590'
			If _NFABAS=='1'
				If SubStr(SM0->M0_CGC,1,8)<> SubStr(_CNPJ,1,8)
					AVISO("MESSAGEM","S� � permitido realizar pedidos de abastecimento para "+ AllTrim(SM0->M0_NOMECOM),{"OK"},1)
					l_Ret := .F.
				End
				//			If _TPCLI <> 'R'
				//				AVISO("MESSAGEM","Para pedido de abastecimento o tipo de cliente deve ser [Revendedor].",{"OK"},1)
				//				l_Ret := .F.
				//			End
				If !l_Ret
					RestArea(a_AreaSB1)
					RestArea(a_AreaSA1)
					RestArea(a_AreaSF4)
					RestArea(a_AreaATU)
					Return (l_Ret)
				End
			End
		End
		//����������������������������������������������������������������������������Ŀ
		//� CONTROLA DE LIBERACAO DE ESTOQUE                                           �
		//������������������������������������������������������������������������������
		If Altera
			_lLibEst  := .F.
			For n_Linha := 1 To Len(aCols)
				_QUANT   := aCols[n_Linha,_C6QTD]
				If AllTrim(_XGPV)$("PCA")
					If aCols[n_Linha,len(aHeader)+1] = .T.
						AVISO("MESSAGEM","N�o � permitido excluir itens do pedido de venda, utilize a Elimina��o de Resisuos.",{"OK"},1)
						l_Ret := .F.
					End
				End
				If !l_Ret
					Exit
				Endif
			Next n_Linha
		End

		If !lEdi1
			For n_Linha := 1 To Len(aCols)
				aCols[n_linha, _C6LIB] := 0
			Next n_Linha
		EndIf
	End
	//����������������������������������������������������������������������������Ŀ
	//� Controle de Abastecimento                                                  �
	//������������������������������������������������������������������������������
	If M->C5_XNFABAS=='1'
		If Empty(M->C5_XCODPA)
			MsgBox ("Este pedido � de Abastecimento, o local de estoque deve estar preenchido.","Erro!!!","STOP")
			Return .F.
		End
		If M->C5_XFINAL<>'4'
			MsgBox ("Este pedido � de Abastecimento, a Finalidade de Venda deve ser [4-Abastecimento].","Erro!!!","STOP")
			Return .F.
		End
	Else
		//If !Empty(M->C5_XCODPA) .AND. _CTRLPA<>"S"
		//	MsgBox ("Este cliente n�o tem o controle de PA habilitado e o pedido n�o � de Abastecimento, o local de estoque deve estar em branco.","Erro!!!","STOP")
		//	Return .F.
		//End
		If M->C5_XFINAL=='4'
			MsgBox ("Este pedido n�o � de Abastecimento, altere a a Finalidade de Venda.","Erro!!!","STOP")
			Return .F.
		End
	End
	//����������������������������������������������������������������������������Ŀ
	//� Controle de Transferencia                                                  �
	//������������������������������������������������������������������������������
	If M->C5_XFINAL=='3'
		If Empty(M->C5_XFLDEST)
			MsgBox ("Este pedido � de Transferencia, a filial destino deve estar selecionada.","Erro!!!","STOP")
			Return .F.
		End
	Else
		If !Empty(M->C5_XFLDEST)
			MsgBox ("Este pedido n�o � de Transferencia, a filial destino deve em branco.","Erro!!!","STOP")
			Return .F.
		End
	End
	//����������������������������������������������������������������������������Ŀ
	//� Verifica Finalidade do pedido (Considerar somente Venda Direta e venda PA) �
	//������������������������������������������������������������������������������
	If M->C5_XFINAL $ "1#2"
		If VAZIO(M->C5_XCCUSTO)
			AVISO("MESSAGEM","O campo Centro Custo deve ser preenchido!",{"OK"},1)
			l_Ret := .F.
		Elseif Vazio(M->C5_XMESREF) .and. M->C5_XFINAL $ "2/J"
			AVISO("MESSAGEM","O campo M�s Refer�ncia da aba Comercial deve ser preenchido!",{"OK"},1)
			l_Ret := .F.
		Endif
		If l_Ret .AND. SubStr(M->C5_XCCUSTO,1,1)<>'7'
			AVISO("MESSAGEM","O Centro Custo deve ser do grupo 7!",{"OK"},1)
			l_Ret := .F.
		End
	Endif
	If INCLUI
		For n_Linha := 1 To Len(aCols)
			If !Empty(_FATPA)
				aCols[n_linha,  _C6LOC] :=  _FATPA
			End
		Next n_Linha
	Else
		For n_Linha := 1 To Len(aCols)
			If !Empty(_FATPA)
				aCols[n_linha,  _C6LOC] :=  _FATPA
			End
		Next n_Linha
	End
	
	
	
	// validacao para nao permitir gerar o pedido de dose para o armazem padrao - JACKSON 17/11/2015
	If AllTrim(M->C5_XFINAL) == "J"
		For n_Linha := 1 To Len(aCols)
			_cArm := aCols[n_linha,  _C6LOC]
	
			If SubStr(_cArm,1,1) == "D"
				Aviso( "MTA410","O faturamento de doses deve ser feito no armaz�m PA do cliente!",{"Ok"} )
				l_Ret := .F.
				Exit
			EndIf
	
		Next n_Linha
	EndIf

	
ElseIf SM0->M0_CODIGO=="02"
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLES LUXOR                                                            �
	//������������������������������������������������������������������������������
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLE DE APROVA��O                                                      �
	//������������������������������������������������������������������������������
	For n_Linha := 1 To Len(aCols)
		nTotPV := nTotPV+(RecMoeda(ddatabase,M->C5_MOEDA)*aCols[n_linha,_C6TOT])
	Next n_Linha
	If nTotPV>nValBPV
		M->C5_XSTLIB := 2
		_cStLib := 2
	Else
		M->C5_XSTLIB := 1
		_cStLib := 1
	End
	For n_Linha := 1 To Len(aCols)
		If aCols[n_linha,  _C6TES]=='950'
			//			M->C5_MOEDA := 1
			Exit
		End
	Next n_Linha         
	//M->C5_XSTLIB := 2
	//_cStLib 	 := 2
	
	If _cStLib == 1
		For n_Linha := 1 To Len(aCols)
			aCols[n_linha, _C6LIB] := 0
		Next n_Linha
		AVISO("MESSAGEM","Este pedido dever� passar pela aprova��o para ser liberado.",{"OK"},1)
	ElseIf _cStLib == 2
		For n_Linha := 1 To Len(aCols)
			aCols[n_linha, _C6LIB] := 0
		Next n_Linha
		AVISO("MESSAGEM","Este pedido dever� passar por dois niveis de aprova��o para ser liberado.",{"OK"},1)
	End
End
//����������������������������������������������������������������������������Ŀ
//� CONTROLA SITUACAO TRIBUTARIA                                               �
//������������������������������������������������������������������������������
For n_Linha := 1 To Len(aCols)
	cB1ORI  := GetAdvFval("SB1","B1_ORIGEM",xFilial("SB1")+aCols[n_Linha,_C6PRO],1)
	If	aCols[n_linha,_C6CST]<>cB1ORI+Posicione("SF4",1,xFilial("SF4")+aCols[n_Linha,_C6TES],"F4_SITTRIB")
		MsgBox ("Existe uma diferen�a na classifica��o Fiscal deste pedido e a TES. Entre em contato com o Setor Fiscal."  +CHR(13)+CHR(10) +;
		"Detalhes: Produto-["+AllTrim(aCols[n_linha,_C6CST])+"]" +CHR(13)+CHR(10) +;
		"          Clas. Fiscal-["+aCols[n_linha,_C6CST]+"]" +CHR(13)+CHR(10) +;
		"          Sit. Tribut�ria-["+cB1ORI+Posicione("SF4",1,xFilial("SF4")+aCols[n_Linha,_C6TES],"F4_SITTRIB")+"]" ,"Erro!!!","STOP")
		Return .F.
	End
Next n_Linha
//����������������������������������������������������������������������������Ŀ
//� Controle de Inclusao/Alteracao por usuario
//������������������������������������������������������������������������������
If INCLUI
	For n_Linha := 1 To Len(aCols)
		aCols[n_linha, _C6DEN] := _DENTRE
		aCols[n_linha, n_PosCC] := If(empty(aCols[n_linha, n_PosCC]),M->C5_XCCUSTO,aCols[n_linha, n_PosCC])  
		If empty(M->C5_XCCUSTO) .And. !empty(aCols[n_linha, n_PosCC])
			M->C5_XCCUSTO := aCols[n_linha, n_PosCC]
		endIf
		aCols[n_linha, n_PosIC] := M->C5_XITEMCC
		aCols[n_linha, _C6USI]  := _cUserPV
		aCols[n_linha, _C6DTI]  := DATE()
		aCols[n_linha, _C6HRI]  := TIME()
	Next n_Linha
Else
	For n_Linha := 1 To Len(aCols)
		aCols[n_linha, _C6DEN] := _DENTRE
		aCols[n_linha, n_PosCC] := If(empty(aCols[n_linha, n_PosCC]),M->C5_XCCUSTO,aCols[n_linha, n_PosCC])
		If empty(M->C5_XCCUSTO) .And. !empty(aCols[n_linha, n_PosCC])
			M->C5_XCCUSTO := aCols[n_linha, n_PosCC]
		endIf
		
		aCols[n_linha, n_PosIC] := M->C5_XITEMCC
		aCols[n_linha, _C6USA]  := _cUserPV
		aCols[n_linha, _C6DTA]  := DATE()
		aCols[n_linha, _C6HRA]  := TIME()
	Next n_Linha
End
//����������������������������������������������������������������������������Ŀ
//� Controle de Volume no Pedido de Vendas
//������������������������������������������������������������������������������
//Alterado por Alexandre para que o usuario possa ter a possibilidade de digitar a quantidade correta de volumes na impressao da nota fiscal. 01/03/2012
IF M->C5_VOLUME1 == 0
	//M->C5_VOLUME1 := 0
	For n_Linha := 1 To Len(aCols)
		M->C5_VOLUME1 := M->C5_VOLUME1 + aCols[n_linha, _C6QTD]
	Next n_Linha
ENDIF
//����������������������������������������������������������������������������Ŀ
//� Controle de Credito
//������������������������������������������������������������������������������
_TOTPV := 0
For n_Linha := 1 To Len(aCols)
	_TOTPV := _TOTPV + aCols[n_linha, _C6TOT]
Next n_Linha
If _RISCO$("B#C#D")
	If _VALATR>0 .And. !lEdi1
	//	AVISO("MESSAGEM","Este cliente tem pagamento em aberto, portanto ser� bloqueado por cr�dito.",{"OK"},1)
	Else
		If _TOTPV>_LIMITE .And. !lEdi1
	  //		AVISO("MESSAGEM","Este pedido excedeu o limite de cr�dito estipulado, portanto ser� bloqueado por cr�dito.",{"OK"},1)
		End
	End
ElseIf _RISCO=="E" .And. !lEdi1
	AVISO("MESSAGEM","Os pedidos deste cliente ficar�o bloqueados por cr�dito.",{"OK"},1)
End
/*------------------------------------------+
|	Atualiza Peso Liquido e Peso Bruto		|
|	Jackson E. de Deus 08/03/13				|
+------------------------------------------*/
If !lEdi1
	U_TTFAT04C()
EndIf 

//Validacao solicitada pelo Octavio / Claudete para nao permitir a inclusao de pedidos de clientes inadimplentes pela DDC "a principio"
If !ValidPag()
	M->C5_XSTLIB := 1
EndIf


//����������������������������������������������������������������������������Ŀ
//� Retorna Area Inicial                                                       �
//������������������������������������������������������������������������������
RestArea(a_AreaSB1)
RestArea(a_AreaSA1)
RestArea(a_AreaSF4)
RestArea(a_AreaATU)
Return (l_Ret)
                                     
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA410    �Autor  �Alexandre Venancio  � Data �  07/16/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Nao permitir finalizar pedidos para clientes que estejam  ���
���          �com pagamentos em aberto (ddc)                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidPag

Local aArea	:=	GetArea()
Local lRet 	:= .T.    
Local cQuery
Local cEmpV	:=	GetMV("MV_XEMPLF")

If cEmpAnt $ cEmpV 
	IF M->C5_CLIENTE <> '000001'  .AND. EMPTY(M->C5_XLIB01)
	
		cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName("SE1")
		cQuery += " WHERE "         
		cQuery += " E1_CLIENTE='"+M->C5_CLIENTE+"' AND E1_LOJA='"+M->C5_LOJACLI+"' 
		cQuery += " AND E1_VENCREA < '"+dtos(dDataBase-2)+"' AND E1_BAIXA=''"
		cQuery += " AND D_E_L_E_T_=''" 
		
		If Select('QUERY') > 0
			dbSelectArea('QUERY')
			dbCloseArea()
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)
		
		DbSelectArea("QUERY")
		
		nQtd := QUERY->QTD
	    
	    If nQtd > 0
	    	MsgAlert("N�o ser� permitido a inclus�o deste pedido, devido ao cliente estar com pagamentos em atraso.","MTA410 - ValidPag")
	    	U_HIT0200(M->C5_CLIENTE,M->C5_LOJACLI)
	    	lRet := .F.
	    EndIf  
	 ENDIF
            
EndIf

RestArea(aArea)

Return(lRet)