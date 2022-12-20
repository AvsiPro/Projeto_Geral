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
	Local cEndEnt	:= ""
	Local cCodPA	:= ""
	Local cOurPed	:= ""


	// mensagem - dados adicionais
	If !Empty(SA1->A1_ENDENT) .AND. AllTrim(SA1->A1_INSCR) != "ISENTO"
		aEntrega := {}
		aadd(aEntrega,SA1->A1_CGC)
		aadd(aEntrega,MyGetEnd(SA1->A1_ENDENT,"SA1")[1])
		aadd(aEntrega,ConvType(IIF(MyGetEnd(SA1->A1_ENDENT,"SA1")[2]<>0,MyGetEnd(SA1->A1_ENDENT,"SA1")[2],"SN")))
		aadd(aEntrega,AllTrim(MyGetEnd(SA1->A1_COMPENT,"SA1")[1]))
		aadd(aEntrega,SA1->A1_BAIRROE)
		aadd(aEntrega,SA1->A1_COD_MUN)
		aadd(aEntrega,SA1->A1_MUN)
		aadd(aEntrega,Upper(SA1->A1_ESTE))
		aadd(aEntrega,Alltrim(SA1->A1_NOME))
		aadd(aEntrega,SA1->A1_INSCR)  //Iif(!Empty(SA1->A1_INSCR),VldIE(SA1->A1_INSCR,.T.,.F.),"")
		aadd(aEntrega,Alltrim(SA1->A1_CEPE))
		aadd(aEntrega,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
		aadd(aEntrega,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
		aadd(aEntrega,FormatTel(Alltrim(AllTrim(SA1->A1_DDD)+SA1->A1_TEL)))
		aadd(aEntrega,Alltrim(SA1->A1_EMAIL))
		//Rodrigo Barreto 19/12/2022
		/*cMensFis += "DI: "+SF1->F1_X_DI+" N/REF: "+SF1->F1_X_NRRE + " BL NR: "+SF1->F1_X_CNBR
		cMensFis += "Valor Cofins: "+CvalToChar(ROUND(SF1->F1_X_VLCOF,2))+" Valor PIS: "+CvalToChar(ROUND(SF1->F1_X_VLPIS,2))
		cMensFis += " Taxa Siscomex: "+CvalToChar(ROUND(SF1->F1_X_SISCO,2))*/
	ElseIf SF1->F1_EST == "EX"
		cMensFis += "DI: "+ALLTRIM(SF1->F1_X_DI)+" N/REF: "+ALLTRIM(SF1->F1_X_NRRE) + " BL NR: "+ALLTRIM(SF1->F1_X_CNBR)
		cMensFis += " Valor Cofins: "+CvalToChar(ROUND(SF1->F1_X_VLCOF,2))+" Valor PIS: "+CvalToChar(ROUND(SF1->F1_X_VLPIS,2))
		cMensFis += " Taxa Siscomex: "+CvalToChar(ROUND(SF1->F1_X_SISCO,2))
		cMensFis += " Observações: "+ alltrim(SF1->F1_X_OBS) + alltrim(SF1->F1_X_OBS1)
		
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
