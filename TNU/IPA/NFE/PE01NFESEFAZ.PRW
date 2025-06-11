#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor  ³Alexandre Venancio  Data ³  06/05/2025 º±±
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
	//				1		2		3		4	5		6		7		8		9		10			11		12		  13		14		15		16		17		18		19	  20	21		
	//aParam := {aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aNfVincRur,aEspVol,aNfVinc,aDetPag,aObsCont,aProcRef,aMed,aLote,cTipo}
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
	//Local cClixProd := SuperGetMV("TI_IPANFE",.F.,"J59104422/J06020318")
    Local cBkpDesc  := ""
    Local cCliA7    := ""
    Local cPedCl    := ""
    Local nCont 
    
    //If SD2->D2_CLIENTE $ cClixProd
	If PARAMIXB[21] == '1'
        For nCont := 1 to len(aProd)
            cBkpDesc := aProd[nCont,4]

            DbSelectArea("SC6")
            DbSetOrder(1)
            If Dbseek(SD2->D2_FILIAL+SD2->D2_PEDIDO+aProd[nCont,39])
                //While !EOF() .And. SC6->C6_FILIAL == SD2->D2_FILIAL .And. SC6->C6_NUM == SD2->D2_PEDIDO 
                    cPedCl := SC6->C6_NUMPCOM

                    DbSelectArea("SA7")
                    DbSetOrder(1)
                    If Dbseek(xFilial("SA7")+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO)
                        cCliA7    := Alltrim(SA7->A7_CODCLI)
                    EndIf 
                    DbSelectArea("SC6")

					If !empty(cCliA7)
                    	aProd[nCont,4] := cCliA7+" - "+cBkpDesc+" - PED.CLIENTE: "+cPedCl
					elseIf !Empty(cPedCl)
						aProd[nCont,4] := cBkpDesc+" - PED.CLIENTE: "+cPedCl
					endif 
                    //Dbskip()
                //EndDo
            EndIf

            
        Next nCont 

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



