#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor  ³Alexandre Venancio  Data ³  14/02/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para manipulacao dos dados da NFE - nfesefaz	          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION PE01NFESEFAZ()
	//aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aNfVincRur,aEspVol,aNfVinc,aDetPag,aObsCont
	Local aProd		:= PARAMIXB[1]
	Local cMensCli	:= PARAMIXB[2]
	Local cMensFis	:= PARAMIXB[3]
	Local aDest		:= PARAMIXB[4]
	Local aNota   	:= PARAMIXB[5]
	Local aInfoItem	:= PARAMIXB[6]
	Local aDupl		:= PARAMIXB[7]
	Local aTransp	:= PARAMIXB[8]
	Local aEntrega	:= PARAMIXB[9]
	Local aRetirada	:= PARAMIXB[10]
	Local aVeiculo	:= PARAMIXB[11]
	Local aReboque	:= PARAMIXB[12]
	Local aNfVincRur:= PARAMIXB[13]
	Local aEspVol	:= PARAMIXB[14]
	Local aNfVinc	:= PARAMIXB[15]
	Local aDetPag	:= PARAMIXB[16]
	Local aObsCont	:= PARAMIXB[17]
	Local aArea		:= GetArea()
	Local aRetorno	:= {}
	//Local cEndEnt	:= ""
	Local cCodPA	:= Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_XCODPA")
	//Local cOurPed	:= ""

    If !Empty(cCodPA)
        DbSelectArea("NNR")
        DbSetOrder(1)
        If DbSeek(xfilial("NNR")+cCodPA)
			If !Empty(NNR->NNR_XEND)
				cMensCli += CRLF + 'Local de Entrega '
				cMensCli += Alltrim(NNR->NNR_DESCRI)+' '
				cMensCli += Alltrim(NNR->NNR_XEND)+' '
				cMensCli += Alltrim(NNR->NNR_XBAIRR)+' '
				cMensCli += Alltrim(NNR->NNR_XMUN)+' '
			Else
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+NNR->NNR_CODCLI+NNR->NNR_LOJCLI)
				cMensCli += CRLF + 'Local de Entrega '
				cMensCli += Alltrim(SA1->A1_NOME)+' '
				cMensCli += Alltrim(SA1->A1_NREDUZ)+' '
				cMensCli += Alltrim(SA1->A1_END)+' '
				cMensCli += Alltrim(SA1->A1_BAIRRO)+' '
				cMensCli += Alltrim(SA1->A1_MUN)
			EndIf 
        EndIF 
    EndIf 

	DbSelectArea("SC6")
	DbSetOrder(1)
	If Dbseek(SD2->D2_FILIAL+SD2->D2_PEDIDO)
		While !EOF() .And. SC6->C6_FILIAL == SD2->D2_FILIAL .And. SC6->C6_NUM == SD2->D2_PEDIDO 
			If !EMPTY(SC6->C6_XKRDCLI)
				cMensCli += "Codigo "+SC6->C6_PRODUTO+" Kardex - "+SC6->C6_XKRDCLI+" "
			EndIf
			Dbskip()
		EndDo
	EndIf

	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNFVinc)
	aadd(aRetorno,aDetPag)
	aadd(aRetorno,aObsCont)

	RestArea(aArea)

RETURN aRetorno

Static Function MyGetEnd(cEndereco,cAlias)

	Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
	Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
	Local aRet		:= {"",0,"",""}

	//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
	//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
	If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
		aRet[1] := cEndereco
		aRet[3] := "SN"
	Else
		aRet := FisGetEnd(cEndereco, (&(cAlias+"->"+cCmpEst)))
	EndIf

Return aRet

Static Function ConvType(xValor,nTam,nDec)

	Local cNovo := ""
	DEFAULT nDec := 0
	Do Case
		Case ValType(xValor)=="N"
			If xValor <> 0
				cNovo := AllTrim(Str(xValor,nTam,nDec))
			Else
				cNovo := "0"
			EndIf
		Case ValType(xValor)=="D"
			cNovo := FsDateConv(xValor,"YYYYMMDD")
			cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
		Case ValType(xValor)=="C"
			If nTam==Nil
				xValor := AllTrim(xValor)
			EndIf
			DEFAULT nTam := 60
			cNovo := AllTrim(NoAcento(SubStr(xValor,1,nTam)))
	EndCase
Return(cNovo)

static function FormatTel(cTel)
	local cRet := ""
	default cTel := SM0->M0_TEL
	cRet := strtran(strtran(strtran(strtran(strtran(cTel, "(", ""), ")", ""), "+", ""), "-", ""), " ", "")
return cRet
