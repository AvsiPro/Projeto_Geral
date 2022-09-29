#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC29  บAutor  ณJackson E. de Deus  บ Data ณ  06/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa retorno da OS de entrega.                         บฑฑ
ฑฑบ          ณ Controle de Entregas                                       บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ06/04/15ณ01.00 |Criacao                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTPROC29(aDados,cMsgErro)

Local aArea		:= GetArea() 
Local cNumOS	:= ""
Local nTpCnfC	:= 1
Local cNumOSCnf	:= ""
Local nAgente	:= 0
Local cNome		:= ""
Local cRG		:= ""
Local cEntregue	:= ""
Local cAssinado	:= ""
Local nKM		:= 0
Local nRecnoSF2	:= 0
Local oXml  
Local dData		:= stod("")
Local cHora		:= ""
Local nI
Local cTxtObs	:= ""
Local lEntregou	:= .F.
Local aAx		:= {}      
Local cCliFor	:= ""
Local cLj		:= "" 
Local cCliente	:= ""
Local cLoja		:= ""
Local lGeraLog	:= .F.
Local cPa		:= ""
Local cDescPA	:= ""
Local lPa		:= .F.     
Local cDadosCnt	:= ""
Local cNumNF	:= ""
Local cSerie	:= ""
Local cHoraAgen	:= ""
Local cConfs	:= ""
Local cCnfEsc	:= ""
Local aCnf		:= {}
Local cCnfrnte	:= ""
Local nRcZCnf	:= 0
Local lCanc		:= .F.
Local nPosCol	:= 0
Local cNumber	:= ""
Local cCliExec	:= SuperGetMV("MV_XLOG007",.T.,"")	// clientes PA excecoes - sem conferencia cega
Local lNfSaida	:= .T.

If cEmpAnt <> "01"
	return
EndIF

If FindFunction("U_TTGENC01")
	lGeraLog := .T.
EndIf

        
InfoEntr(aDados,@cNumOS,@dData,@cHora,@cEntregue,@cNome,@cRG,@nKM,@cConfs,@cCnfEsc)

// KM 
cTxtObs := "NOME: " +cNome +" - RG: " +cRG +" - " +cEntregue

dbSelectArea("SZG")
dbSetOrder(1)
If dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	cNumNF := SZG->ZG_DOC
	cSerie := SZG->ZG_SERIE
	
	If AllTrim(SZG->ZG_TPDOC) == "1"
		lNfSaida := .F.
	EndIf
	
	If "ENTIDADE NF" $ SZG->ZG_OBS
		aAx := StrToKarr(SZG->ZG_OBS,"|")
		If Len(aAx) > 0
			cCliFor := AllTrim(aAx[2])
			cLj := AllTrim(aAx[3])
		EndIf
	Else
		cCliFor := AllTrim(SZG->ZG_CLIFOR)
		cLj := AllTrim(SZG->ZG_LOJA)
	EndIf
EndIf	

If cEntregue == "ENTREGADO SIM"
	lEntregou := .T.
EndIf

// grava no Log
If lGeraLog
	U_TTGENC01( xFilial("SZG"),"ENTREGA","OS ENTREGA","",cNumNF,cSerie,"WS",dtos(date()),time(),,cTxtObs,,,"SZG" )
EndIf   

If lNfSaida
	dbSelectArea("SF2")
	dbSetOrder(2)	// CLIENTE LOJA NF SERIE
	If dbSeek( xFilial("SF2") +AvKey(cCliFor,"F2_CLIENTE") +AvKey(cLj,"F2_LOJA") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
		nRecnoSF2 := Recno()
		
		If nKM > 0
			RecLock("SF2",.F.)
			SF2->F2_XENTKM := nKM
			MsUnLock()
		EndIf
	
		cCliente := cCliFor
		cLoja := cLj
		If !Empty(SF2->F2_XCODPA) .And. AllTrim(SF2->F2_XFINAL) = "4" .And. AllTrim(SF2->F2_XNFABAS) == "1"
			If SubStr(SF2->F2_XCODPA,1,1) == "P"
				lPa := .T.
				cPa := SF2->F2_XCODPA
				
				dbSelectArea("ZZ1")
				dbSetOrder(1)
				If dbSeek( xFilial("ZZ1") +AvKey(SF2->F2_XCODPA,"ZZ1_COD") )
					cCliente := SubStr(ZZ1->ZZ1_ITCONT,1,6)
					cLoja := SubStr(ZZ1->ZZ1_ITCONT,7,4)
					cDescPA := AllTrim(ZZ1->ZZ1_DESCRI)
				EndIf
			EndIf
		EndIf
		
			
		// baixa canhoto
		If lEntregou .And. nRecnoSF2 > 0// .And. !lPa
			U_TTFAT15C(nRecnoSF2,dData,cHora,"S","S",cNome,cRG,nKm)
			
			// se for PA - entra mercadoria no estoque da PA
			If lPA
			    // entra SZ7 - novo processo PA
				U_TTFAT27C( SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,3 ) 
				U_TTFAT18C( SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA )
			EndIf
		EndIf			
	EndIf	
// nota devolucao
Else
	dbSelectArea("SF1")
	dbSetOrder(2)	// CLIENTE LOJA NF SERIE
	If dbSeek( xFilial("SF1") +AvKey(cCliFor,"F1_FORNECE") +AvKey(cLj,"F1_LOJA") +AvKey(cNumNF,"F1_DOC") +AvKey(cSerie,"F1_SERIE") )
	
		// baixa canhoto
		If lEntregou
			U_TTFAT15C( Recno(),dData,cHora,"S","S",cNome,cRG,nKm,lNfSaida )
		EndIf			
	EndIf	
EndIf
  
RestArea(aArea)

Return
      

                                                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInfoEntr  บAutor  ณJackson E. de Deus  บ Data ณ  06/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trata retorno da OS                                        บฑฑ
ฑฑบ          ณ Usado tambem pelo TTPROC37 via StaticCall                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function InfoEntr(aDados,cNumOS,dData,cHora,cEntregue,cNome,cRG,nKM,cConfs,cCnfEsc)
                    
Local cMsgErro := ""
Local nI            
Local cResWS := ""
Local lNovoFrm := .F.
Local aEntr := {}
Local nPos := 0
Default aDados := {}
Default cNumOS := ""
/*
If Empty(aDados)                                     
	If !Empty(cNumOs)
		dbSelectArea("SZG")
		dbSetOrder(1)
		If MSSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )	// OS de entrega
			If !SZG->ZG_NOVOFRM
				If AllTrim(SZG->ZG_STATUS) == "FIOK" .And. !Empty(SZG->ZG_RESPOST)
					aDados := U_WSKPF026( SZG->ZG_RESPOST,@cMsgErro )
				EndIf
			Else
				lNovoFrm := .T.
			EndIf	
		EndIf
	EndIf
EndIf
*/
                                 
nPos := AScan( aDados, { |x| x[1] == "NUMERO" } )
If nPOs > 0
	cNumOS := PadL( aDados[nPOs][2],TamSx3("ZG_NUMOS")[1],"0" )
EndIf

dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	lNovoFrm := SZG->ZG_NOVOFRM
	dData := SZG->ZG_DATAFIM
	cHora := SZG->ZG_HORAFIM
EndIf

// novo form
nPos := AScan( aDados, { |x| x[1] == "ENTREGA" } )
If nPOs > 0
	aEntr := Aclone( aDados[nPOs] )
EndIf
         
For nI := 2 To Len(aEntr)
	If aEntr[nI][1] == "NOME"
		cNome := aEntr[nI][2]
	ElseIf aEntr[nI][1] == "RG"
		cRG := aEntr[nI][2]
	ElseIf aEntr[nI][1] == "ENTREGA"
		If aEntr[nI][2] == "S"
			cEntregue := "ENTREGADO SIM"
		Else
			cEntregue := "ENTREGADO NAO"
		EndIf
	ElseIf aEntr[nI][1] == "KM"
		nKM := Val(aEntr[nI][2])
		If Len(cvaltochar(nKm)) > 6
			conout("#TTPROC29 -> ERRO: " +"OS: " +cNumOS +" KM: " +CVALTOCHAR(nKm))
			nKm := 0
		EndIf
	EndIf
Next nI


Return