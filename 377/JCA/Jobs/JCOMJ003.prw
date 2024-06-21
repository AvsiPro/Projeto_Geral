#INCLUDE 'PROTHEUS.CH'
/*
    Job que faz Processamento rotina pre-requisição de forma automática
    MIT 44_ESTOQUE_EST012 - Processamento rotina gerar pre-requisição de forma automática

    Doc Mit
    https://docs.google.com/document/d/1rAM0C2yu5RCbSzqiOUx3xwuG2ibxqY4N/edit
    Doc Entrega
    https://docs.google.com/document/d/19XIaOCoeiybBXtKkBhLhoUcnOW83mxPr/edit
    
*/

User Function JCOMJ003

Local aSolicit              := {}
Local aItens                := {}
Local n1Cnt
Local lMarkB, lDtNec
Local BFiltro               := {|| .T.}
Local lConsSPed, lGeraSC1, lAmzSA
Local cSldAmzIni, cSldAmzFim
Local lLtEco, lConsEmp
Local nAglutSC
Local lAuto, lEstSeg
Local aRecSCP
Local lRateio
Local nFind
Local cMail, cBody
Local nPos                  := 1
Local cArqHTML
Local cPathHTML

Private oHtml

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

cArqHTML    := "\workflow\Aviso_Requisicao_Pecas.html"
cPathHTML   := GetMV("MV_WFDIR") 

// preenche os parÃ¢metros MV_PARnn com as respostas das perguntas da rotina MATA106
Pergunte("MTA106",.F.)

lMarkB     := .F.
lDtNec     := (MV_PAR01 == 1)
BFiltro    := {||U_xJCom3j(SCP->CP_PRODUTO,SCP->CP_LOCAL,SCP->CP_QUANT,SCP->CP_NUM,SCP->CP_ITEM,SCP->CP_XTIPO)}
lConsSPed  := (MV_PAR02 == 1)
lGeraSC1   := .F. //(MV_PAR03 == 1)   // nao gerar solicitacao de compra
lAmzSA     := (MV_PAR04 == 1)
cSldAmzIni := MV_PAR05
cSldAmzFim := MV_PAR06
lLtEco     := (MV_PAR07 == 1)
lConsEmp   := (MV_PAR08 == 1)
nAglutSC   := MV_PAR09
lAuto      := .T.
lEstSeg    := (MV_PAR10 == 1)
aRecSCP    := {}
lRateio    := .F.

//MaSAPreReq(lMarkB,lDtNec,BFiltro,lConsSPed,lGeraSC1,lAmzSA,cSldAmzIni,cSldAmzFim,lLtEco,lConsEmp,nAglutSC,lAuto,lEstSeg,@aRecSCP,lRateio)
A106PreReq(lMarkB,lDtNec,BFiltro,lConsSPed,lGeraSC1,lAmzSA,cSldAmzIni,cSldAmzFim,lLtEco,lConsEmp,nAglutSC,lAuto,lEstSeg,@aRecSCP,lRateio)
// monta o array com as solicitaÃ§Ãµes e seus itens
For n1Cnt := 1 to Len(aRecSCP)
    SCP->(dbGoTo(aRecSCP[n1Cnt]))
    aItens := {}
    aAdd(aItens,allTrim(SCP->CP_PRODUTO))
    aAdd(aItens,allTrim(SCP->CP_DESCRI))
    aAdd(aItens,SCP->CP_QUANT)

    nFind := aScan(aSolicit,{|x| x[1] == SCP->CP_NUM })
    If nFind == 0
        aAdd(aSolicit,{})
        aAdd(aSolicit[nPos],allTrim(SCP->CP_NUM))
        aAdd(aSolicit[nPos],allTrim(SCP->CP_SOLICIT))
        aAdd(aSolicit[nPos],UsrRetMail(allTrim(SCP->CP_CODSOLI)))
        aAdd(aSolicit[nPos],SCP->CP_EMISSAO)
        aAdd(aSolicit[nPos],{})
        aAdd(aSolicit[nPos][5],aItens)
        nPos++
    Else
        aAdd(aSolicit[nFind][5],aItens)
    EndIf
Next n1Cnt

// envia o email
/*
For n1Cnt := 1 to Len(aSolicit)
    oHtml := TWFHtml():New( cArqHTML )

    oHTML:ValByName("CP_EMISSAO",aSolicit[n1Cnt,4])
    oHTML:ValByName("CP_NUM",aSolicit[n1Cnt,1])
    oHTML:ValByName("CP_SOLICIT",aSolicit[n1Cnt,2])

    cItens := xGermail(aSolicit[n1Cnt])
    oHTML:ValByName("linhasPedido",cItens)
    cMail := 'alexandre.venancio@avsipro.com.br' // pode ser obtido de um parÃ¢metro
    
    cFileName    := CriaTrab(NIL,.F.) + ".htm"
    cFileName    := cPathHTML + "\" + cFileName 
    oHtml:SaveFile(cFileName)

    cRet         := WFLoadFile(cFileName)
    cMensagem    := StrTran(cRet,chr(13),"")
    cMensagem    := StrTran(cRet,chr(10),"")
    cMensagem    := OemtoAnsi(cMensagem)

    cEmailTst := SUPERGETMV( "TI_EMAILTS", .F., "alexandre.venancio@avsipro.com.br" )

    U_JGENX002(cEmailTst,'SolicitaÃ§Ã£o de peÃ§as disponÃ­veis',cMensagem,'',.F.)

Next n1Cnt
*/

Return

/*/{Protheus.doc} xJCom3j
    (long_description)
    @type  Static Function
    @author user
    @since 16/04/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function xJCom3j(cCodigo,cLocal,nQtd,cNum,cItem,cTipo)

Local aArea := GetArea()
Local lRet  := .T.

If Empty(cTipo)

    DbSelectArea("SB2")
    DbSetOrder(1)
    If Dbseek(xfilial("SB2")+cCodigo+cLocal)
        nSaldo := SaldoSB2()

        If nQtd > nSaldo 
            lRet := .F.
        EndIf 
    Else 
        lRet := .F.
    endIf 

    If !lRet 
        DbSelectArea("SCP")
        DbSetOrder(2)
        If Dbseek(xFilial("SCP")+cCodigo+cNum+cItem)
            Reclock("SCP",.F.)
            SCP->CP_XTIPO := '.'
            SCP->(Msunlock())
            lRet := .T.
        EndIf 
    EndIf 
EndIf 


RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} xGermail
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xGermail(aArray)

Local aArea := GetArea()
Local nCont1 := 0
Local cRet   := ''
Local cConteudo := ''
Local cLinha := ''
Local aArray2 := {'CP_PRODUTO','CP_DESCRI','CP_QUANT'}
Local nX 

cRet := '<tr>'     
cRet += '    <td width=150><strong>!CP_PRODUTO!</strong></td>'
cRet += '    <td width=450><strong>!CP_DESCRI!</strong></td>'
cRet += '    <td width=100 align=right><strong>!CP_QUANT!</strong></td>'
cRet += '</tr>'

For nCont1 := 1 to len(aArray[5])
    cLinha += cRet
    For nX := 1 to len(aArray2)
        aAuxCmp := FWSX3Util():GetFieldStruct( FwCutOff(aArray2[nX]) )
        cConteudo := ''
        If aAuxCmp[2] == "N"
            cConteudo := Transform(aArray[5,nCont1,nX],"@R 999,999,999.99")
        ElseIf aAuxCmp[2] == "D"
            cConteudo := cvaltochar(stod(aArray[5,nCont1,nX]))
        Else 
            cConteudo := FwCutOff(aArray[5,nCont1,nX],.t.)
        EndIf
        cLinha := strtran(cLinha,"!"+aArray2[nX]+"!",cConteudo)
    Next nX
Next nCont1

RestArea(aArea)

Return(cLinha)
/*
MaSAPreReq(lMarkB,lDtNec,BFiltro,lConsSPed,lGeraSC1,lAmzSA,cSldAmzIni,cSldAmzFim,lLtEco,lConsEmp,nAglutSC,lAuto,lEstSeg,aRecSCP,lRateio)

Parametros:
lMarkB     : Avaliar a selecao da Markbrowse ? (default = .F.)
lDtNec     : Avalia por data de necessidade ou por data de emissao ? (.T. = necessidade, .F.=emissao, default = .F.)
BFiltro    : Expressao de filtro a ser avaliada para cada registro do SCP.
lConsSPed : Considera ou nao Prev.Entrada (SC) ? (default = .F.)
lGeraSC1   : Rotina devera gerar Solicitacao de Compras no SC1 ? (default = .T.)
lAmzSA     : Considera Armazem da SA ?
cSldAmzIni : Armazem inicial para considerar o saldo/necessidade
cSldAmzFim : Armazem final paraa considerar o saldo/necessidade
lLtEco     : Considerar o Lote Economico na geracacao da SC ? (default = .T.)
lConsEmp   : Considerar o saldo ja empenhado qdo baixa de OP ? (default = .F.)
nAglutSC   : Indica se aglutina ou nao as SCâ€˜s (default = 1 Aglutina)
lAuto      : Rotina automÃ¡tica ? (default = .F.)
lEstSeg    : Subtrai o estoque de seguranca ? (default = .F.)
aRecSCP    : Array com os nÃºmeros dos registros manipulados na SCP (passar por referÃªncia)
lRateio    : Efetua rateio na solicitacao ao armazem ? (default = .F.)


Para executar "automaticamente", vocÃª pode utilizar as respostas do grupo de perguntas MTA106.

Grupo de perguntas MTA106:
mv_par01 - Considera Data     ? Necessidade/Emissao
mv_par02 - Cons. Sld Prev Entr? Sim / Nao
mv_par03 - Gera Solic. Compras? Sim / Nao
mv_par04 - Cons. Armazem do SA?
mv_par05 - Saldo do Armazem   ?
mv_par06 - Saldo Ate o Armazem?
mv_par07 - Cons lote economico? Sim / Nao
mv_par08 - Avalia empenho p/OP? Sim / Nao
mv_par09 - Aglut docs gerados ? Sim / Nao
mv_par10 - Subtrai estoque seg? Sim / Nao

*/


static Function A106PreReq(lMarkB,lDtNec,BFiltro,lConsSPed,lGeraDoc,lAmzSA,cSldAmzIni,cSldAmzFim,lLtEco,lConsEmp,nAglutDoc,lAuto,lEstSeg,aRecSCP,lRateio)

Local aArea      := GetArea()
Local aLotes     := {}
Local aCampos	 := {}
Local aDocs		 := {}
Local aDocsCp	 := {}
Local aRateio	 := {}
Local aMT106SCQ  := {}
local aCPAgl	 := {}
Local aResultado := {}
Local aFornecedor:= {}
Local aPosDhn	 := {}
Local aSalPedi   := {}
Local aCTBEntArr := CTBEntArr()

Local cEntidades := ""
Local cCursor    := "SCP"
Local cQuery     := ""
Local cSeq       := "01"	
Local cMsgSC     := ""
Local cSeekSCP   := ""
Local cSeekSCQ   := ""
Local cMsg		 := ""
Local cUndRequi	 := SuperGetMv("MV_CCUNREQ")
Local cFilAux    := cFilAnt
Local cChaveSGS  := ""

Local nPrc		 := 0
Local nX         := 0
Local nY         := 0
Local nQtde      := 0
Local nQtdPre    := 0
Local nEstoque   := 0
Local nLoteSC    := 0
Local nEstSeg	 := 0 
Local nRegSemSC  := 0
Local nSaldo	 := 0
Local nLoop		 := 0
Local nSalPedAnt := 0

Local lIncluiReg := .T.
Local lContinua	 := .F.
Local lErrAutSC	 := .F.
Local lVldPE	 := .T.
Local lMT106SCA  := ExistBlock("MT106SCA")
Local lMASAVLSC  := ExistBlock("MASAVLSC")
Local lMT106GRV  := ExistBlock('MT106GRV')
Local lMT106VGR  := ExistBlock('MT106VGR')
Local lMA106SCQ  := ExistBlock('MA106SCQ')
Local lMASAVLOP  := ExistBlock('MASAVLOP')
Local lEstNeg 	 := SuperGetMv("MV_ESTNEG",.F.,"N") == "S"
Local lExclusivo := FWModeAccess("SCP") == "E"

Local uLoteSC    := Nil

Private lxCont   := .F.                 // FSW - Controle de numeração SC

DEFAULT lMarkb   := .F.
DEFAULT lDtNec   := .F.
DEFAULT bFiltro  := {|| .T.}
DEFAULT lLtEco   := .T.
DEFAULT lConsEmp := .F.
DEFAULT nAglutDoc:=  2      
DEFAULT lAuto	 := .F.
DEFAULT lEstSeg	 := .F.
DEFAULT aRecSCP	 := {}
DEFAULT lRateio	 := .F.
DEFAULT lGeraDoc := .T.

lConsSPed:=If(Valtype(lConsSPed) # "L",.F.,lConsSPed)

If lGeraDoc
	PcoIniLan("000051")
EndIf

dbSelectArea("SCP")
If lDtNec
	dbSetOrder(3)
Else
	dbSetOrder(4)
EndIf

//preparação para quebra por CP_DESCRI
SCP->(dbCommit())
cCursor := GetNextAlias()
cQuery  := "SELECT CP_FILIAL,R_E_C_N_O_ SCPRECNO "
cQuery  += "FROM "+RetSqlName("SCP")+" SCP "
cQuery  += "WHERE "
cQuery  += "CP_PREREQU<>'S' AND "
cQuery  += "D_E_L_E_T_=' ' "
If ( lMarkb )
	If ( ThisInv() )
		cQuery += "AND CP_OK<>'"+ThisMark()+"' "
	Else
		cQuery += "AND CP_OK='"+ThisMark()+"' "
	EndIf
EndIf

If ExistBlock("MT106QRY")
   c106Qry := ExecBlock("MT106QRY",.F.,.F.,{lAuto})
   If ValType(c106Qry) == "C"
	   cQuery += c106Qry
   EndIf	   
EndIf

cQuery += "ORDER BY "+SqlOrder(SCP->(IndexKey()))
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cCursor, .F., .T. ) 		
	
While  !Eof() 
	dbSelectArea(cCursor)
	SCP->(MsGoto((cCursor)->SCPRECNO))

	If lExclusivo
		cFilAux := (cCursor)->CP_FILIAL
	EndIf

	SB1->(dbSetOrder(1))
	If SB1->(MsSeek(xFilial("SB1", cFilAux) + SCP->CP_PRODUTO))
		lContinua := .T.
	EndIf

	dbSelectArea("SCP")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a Necessidade de uma Solicitacao de Compra/Autorizacao de Entrega  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SCP->CP_PREREQU<>"S" .And. lContinua
		If lMarkb
			 IsMark("CP_OK",ThisMark(),ThisInv())
		EndIf
		If SB1->B1_MSBLQL == "1" // Verifica tambem se o produto nao esta bloqueado
			If !lAuto
				Aviso("B1_MSBLQL",OemtoAnsi("A pre-requisicao nao sera gerada para o Produto ")+Alltrim(SB1->B1_COD)+OemtoAnsi(" este produto encontra-se bloqueado para uso."),{"Ok"}) //  /  / 
			EndIf
		Else
			If ( Eval(bFiltro) )
				lIncluiReg	:=.T.
				cMsg		:= ""
				Begin Transaction
					dbSelectArea("SB2")
					dbSetOrder(1)
					If lAmzSA
						cSeekSCP := xFilial("SB2", cFilAux)+SCP->CP_PRODUTO+SCP->CP_LOCAL
					Else
						cSeekSCP := xFilial("SB2", cFilAux)+SCP->CP_PRODUTO
					EndIf
					nSaldo := 0
					If MsSeek(cSeekSCP)
						RecLock("SB2")
						If lAmzSA
				   			nSaldo  := SaldoSB2(.F.,lConsEmp)+If(lConsSPed,A106SalPed(SCP->CP_PRODUTO,SCP->CP_LOCAL),0)
						Else
							While !Eof() .And. cSeekSCP == SB2->B2_FILIAL+SB2->B2_COD
								If SB2->B2_LOCAL < cSldAmzIni .Or. SB2->B2_LOCAL > cSldAmzFim
									SB2->(dbSkip())
									Loop
								EndIf
								nSaldo += SaldoSB2(.F.,lConsEmp)+If(lConsSPed,A106SalPed(SB2->B2_COD,SB2->B2_LOCAL),0)
								SB2->(dbSkip())
							EndDo
						EndIf
					EndIf
					If lMT106GRV
						ExecBlock("MT106GRV",.F.,.F.)
					EndIf

					If Len(aSalPedi) > 0 .And. (nY := aScan(aSalPedi, {|x| x[1] == SCP->CP_PRODUTO})) > 0
						nSaldo += aSalPedi[nY][2]
					EndIf

                   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calcula se possui estoque de segurança ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
					If lEstSeg
				   		nEstSeg   := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR","SB1") )
	                    If nEstSeg > 0
	                    	nSaldo:= nSaldo - nEstSeg 
	                    EndIf 
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada que permite validar se deve ou nao ser  ³
					//³ gerada a pre-requisicao de solicitacao ao armazem.       ³				
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lMT106VGR
						If (Valtype(lContinua := ExecBlock("MT106VGR",.F.,.F.,{lAmzSA,nSaldo,lConsEmp,lConsSPed}))=='L') .And. !lContinua
						    //Quando executado o break o mesmo pulara para o final da funcao
						    //executando la o DbSkip() sem a necessesidade de se colocar um dbSkip loop aqui.
							DisarmTransaction()
						    break
						EndIf				
					EndIf						
					nQtde	:= SCP->CP_QUANT
					nEstoque:= 0
					cSeq    := "01"
					nQtdPre := nQtde
					uLoteSC := Nil
					While nQtde > 0
						nSaldo  := Max(0,nSaldo)
						nEstoque:= Min(nSaldo,nQtde)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se pode gerar pre-requisicao com saldo negativo ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lEstNeg .And. !lGeraDoc .And. !(Rastro(SCP->CP_PRODUTO) .Or. Localiza(SCP->CP_PRODUTO))
							nEstoque := nQtde
						EndIf
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava Pre-Requisicao         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nRegSemSC:=0
						dbSelectArea("SCQ")
						dbSetOrder(1)
						cSeekSCQ:=xFilial("SCQ", cFilAux)+SCP->CP_NUM+SCP->CP_ITEM
						dbSeek(cSeekSCQ)
						While !Eof() .And. cSeekSCQ == CQ_FILIAL+CQ_NUM+CQ_ITEM
							aPosDhn := COMPosDHN({2,{SCQ->CQ_FILIAL,SCQ->CQ_NUM,SCQ->CQ_ITEM}})
							If !aPosDhn[1] .Or. !((aPosDhn[2])->DHN_TIPO $ "1|2")
								nRegSemSC := SCQ->(Recno())
								nQtdPre   -= SCQ->CQ_QTDISP
								nQtde     -= SCQ->CQ_QTDISP
								If aPosDhn[1]
									(aPosDhn[2])->(DbCloseArea())
								EndIf
								Exit
							EndIf						
							SCQ->(dbSkip())
						End
				
						If !lGeraDoc .And. nRegSemSC > 0
							msGoto(nRegSemSC)
							RecLock("SCQ",.F.)
							SCQ->CQ_QTDISP := SCQ->CQ_QTDISP+nEstoque
							MsUnlock()
							lIncluiReg:=.F.
							A106AvalRA("SCQ",3,nEstoque,cFilAux)
						Else
							RecLock("SCQ",.T.)					
							SCQ->CQ_FILIAL	:= xFilial("SCQ", cFilAux)
							SCQ->CQ_NUM		:= SCP->CP_NUM
							SCQ->CQ_ITEM	:= SCP->CP_ITEM
							SCQ->CQ_PRODUTO	:= SCP->CP_PRODUTO
							SCQ->CQ_LOCAL	:= SCP->CP_LOCAL
							SCQ->CQ_UM		:= SCP->CP_UM
							SCQ->CQ_QUANT	:= nQtdPre
							SCQ->CQ_QTSEGUM	:= SCP->CP_QTSEGUM
							SCQ->CQ_SEGUM	:= SCP->CP_SEGUM
							SCQ->CQ_QTDISP	:= nEstoque
							SCQ->CQ_NUMSQ	:= cSeq
							SCQ->CQ_DATPRF	:= SCP->CP_DATPRF
							SCQ->CQ_DESCRI	:= SCP->CP_DESCRI
							SCQ->CQ_CC		:= SCP->CP_CC
							SCQ->CQ_CONTA	:= SCP->CP_CONTA
							SCQ->CQ_ITEMCTA	:= SCP->CP_ITEMCTA
							SCQ->CQ_CLVL	:= SCP->CP_CLVL
							SCQ->CQ_OP		:= SCP->CP_OP
							SCQ->CQ_OBS		:= SCP->CP_OBS	
							
							For nX := 1 To Len(aCTBEntArr)
								SCQ->&("CQ_EC"+aCTBEntArr[nX]+"CR") := SCP->&("CP_EC"+aCTBEntArr[nX]+"CR")
								SCQ->&("CQ_EC"+aCTBEntArr[nX]+"DB") := SCP->&("CP_EC"+aCTBEntArr[nX]+"DB")
							Next nX
							
							//aMT106SCQ utilizada no P.E. MT106PRE
							aAdd(aMT106SCQ,{SCQ->CQ_FILIAL,SCQ->CQ_NUM,SCQ->CQ_ITEM,SCQ->CQ_NUMSQ,SCQ->CQ_PRODUTO,SCQ->CQ_LOCAL,SCQ->CQ_QUANT})
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Ponto de Entrada MA106SCQ     |
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lMA106SCQ
							   uLoteSC := ExecBlock("MA106SCQ",.F.,.F.)
							   If Valtype(uLoteSC) == "N" .And. uLoteSC > 0
							   		nLoteSC := uLoteSC
							   	EndIf	
							Endif
							A106AvalRA("SCQ",1,,cFilAux)
						EndIf

						nLoteSC := IIf(uLoteSC <> Nil,nLoteSC,(SCQ->CQ_QUANT-SCQ->CQ_QTDISP))
						nLot2SC := ConvUm(SCP->CP_PRODUTO,nLoteSC,0,2)
						cMsgSC  := OemToAnsi("SC gerada por SA")+IIF(!Empty(SCP->CP_OBS)," - "+Left(SCP->CP_OBS,(Len(SC1->C1_OBS))-(Len("SC gerada por SA")+3)),"") // 
	
						// Avalia empenho ja existente a fim de nao gerar SCS/AES caso ja tenha saldo empenhado
						If lConsEmp .And. A106EmpSCP(SCP->CP_PRODUTO,SCP->CP_LOCAL,SCP->CP_OP,nQtdPre) 
							Reclock("SCP",.F.)
							SCP->CP_PREREQU := "S"
							MsUnlock()
							Exit
						// Qdo nao gera Documento
						ElseIf !lGeraDoc
							If QtdComp(nLoteSC) > QtdComp(0)
								cMsg := "Sera gerada pre-requisicao com QUANTIDADE em aberto, por falta de saldo em estoque. SA / Item -> " +" "+SCP->CP_NUM+" / "+SCP->CP_ITEM // 
							EndIf
							Reclock("SCP",.F.)
							SCP->CP_PREREQU := "S"
							MsUnlock()
							Exit
						EndIf	
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Ponto de Entrada - Geração de Solicitação de Compras					   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lMASAVLSC
							lVldPE := ExecBlock("MASAVLSC",.F.,.F.,{SB1->B1_COD,SB1->B1_LOCPAD,SB1->B1_CONTRAT}) 
							If Valtype(lVldPE) <> "L"
								lVldPE := .T.
							ElseIf !lVldPE  
								Reclock("SCP",.F.)
								SCP->CP_PREREQU := "S"
								MsUnlock() 
							EndIf
						EndIf

						If lGeraDoc .And. lVldPE
							//-- Calcula a quantidade conforme o Lote Economico, conforme parametro 8
							If lLtEco
								If ( nLoteSC > 0 )
									aLotes := CalcLote(SCQ->CQ_PRODUTO,nLoteSC,"C")
									nSalPedAnt := nLoteSC
									nLoteSC:= 0
									For nX := 1 To Len(aLotes)
										nLoteSC += aLotes[nX]
									Next nX
								Else
									nLoteSC := 0
								EndIf

								// Tratamento referente a Lote Economico para considerar o saldo total previsto de entrada para o produto, caso seja selecionado mais de um item de SA do mesmo produto
								// para gerar a solicitacao de compra somente com a quantidade necessaria
								// A quantidade de entrada prevista (nLoteSC) gerada para o produto e somada no array aSalPedi (posteriormente ao gerar a SC esta quantidade sera gravada no B2_SALPEDI)
								If lConsSPed .And. nSalPedAnt <> nLoteSC	// (lConsSPed = MV_PAR02) e se nSalPedAnt <> nLoteSC sei que esta usando lote economico (B1_LE <> 0), caso contrario nao utiliza este tratamento
									If (nY := aScan(aSalPedi, {|x| x[1] == SCP->CP_PRODUTO})) == 0
										aAdd(aSalPedi,{SCP->CP_PRODUTO, nLoteSC})
									Else
										aSalPedi[nY][2] += nLoteSC
									EndIf
								EndIf
								nSalPedAnt := 0

							EndIf
							
							aFornecedor:= COMPESQFOR(SCQ->CQ_PRODUTO) //-- Retorna codigo e loja do fornecedor
							nPrc:= COMPESQPRECO(SCQ->CQ_PRODUTO,(cCursor)->CP_FILIAL,aFornecedor[1],aFornecedor[2])
							aRateio:={}
							If SGS->(MsSeek(xFilial("SGS", cFilAux)+SCP->CP_NUM+SCP->CP_ITEM)) //Existe Rateio
								cChaveSGS := SGS->(GS_FILIAL+GS_SOLICIT+GS_ITEMSOL)
								While !SGS->(EOF()) .AND. SGS->(GS_FILIAL+GS_SOLICIT+GS_ITEMSOL) == cChaveSGS
									cEntidades:= SGS->GS_CC 		+ "|" 
									cEntidades+= SGS->GS_CONTA		+ "|"
									cEntidades+= SGS->GS_ITEMCTA 	+ "|"
									cEntidades+= SGS->GS_CLVL 		+ "|"
									For nX := 1 To Len(aCTBEntArr)
										cEntidades+= SGS->&("GS_EC"+aCTBEntArr[nX]+"CR")	+ "|"
										cEntidades+= SGS->&("GS_EC"+aCTBEntArr[nX]+"DB")	+ "|"
									Next nX
									aAdd(aRateio,{SGS->GS_PERC, cEntidades})
									
									SGS->(DbSkip())
								EndDo
							Else //-- Caso não existe rateio assume 100%
								cEntidades:= SCP->CP_CC 		+ "|" 
								cEntidades+= SCP->CP_CONTA		+ "|"
								cEntidades+= SCP->CP_ITEMCTA 	+ "|"
								cEntidades+= SCP->CP_CLVL 		+ "|"
								For nX := 1 To Len(aCTBEntArr)
									cEntidades+= SCP->&("CP_EC"+aCTBEntArr[nX]+"CR")		+ "|"
									cEntidades+= SCP->&("CP_EC"+aCTBEntArr[nX]+"DB")		+ "|"
								Next nX								
							EndIf
							
							If !Empty(SCP->CP_VUNIT)
								nPrc:= SCP->CP_VUNIT
							EndIf
							If !Empty(aRateio)
								aAdd(aCampos,{"RATEIO"		, "1"})
							ELSE 
								aAdd(aCampos,{"RATEIO"		, " "})	
							EndIf
							aAdd(aCampos,{"OBS"		, cMsgSC})	
							aAdd(aCampos,{"DATPRF"	, SCQ->CQ_DATPRF})	
							aAdd(aCampos,{"LOCAL"	, SCQ->CQ_LOCAL})	
							aAdd(aCampos,{"CC"		, SCQ->CQ_CC})	
							aAdd(aCampos,{"CONTA"	, SCQ->CQ_CONTA})	
							aAdd(aCampos,{"ITEMCTA"	, SCQ->CQ_ITEMCTA})	
							aAdd(aCampos,{"CLVL"	, SCQ->CQ_CLVL})	
							aAdd(aCampos,{"DESCRI"	, SCQ->CQ_DESCRI})	
							aAdd(aCampos,{"EMISSAO"	, dDataBase})						
							aAdd(aCampos,{"FILENT"	, xFilEnt(cFilAux,"SC1")})
							aAdd(aCampos,{"COTACAO"	, If(SB1->B1_IMPORT=="S","IMPORT","")})	
							aAdd(aCampos,{"FORNECE"	, SB1->B1_PROC})	
							aAdd(aCampos,{"LOJA"	, SB1->B1_LOJPROC})								
							aAdd(aCampos,{"SOLICIT"	, SCP->CP_SOLICIT})
							aAdd(aCampos,{"VUNIT"	, SCP->CP_VUNIT})
							aAdd(aCampos,{"OS"		, If(empty(SCP->CP_NUMOS),SubStr(SCP->CP_OP,1,At("OS",SCP->CP_OP)-1),SCP->CP_NUMOS)})
							If lMT106SCA
					  			aCPAgl := Execblock("MT106SCA",.f.,.f.)
		                        If Valtype(aCPAgl) == "A"
		                        	aAdd(aCampos,{"MT106SCA",{aCPAgl[1], aCPAgl[2]}})
		                        Else
		                        	aAdd(aCampos,{"MT106SCA",{" ", " "}})
								EndIf
							Else
	                        	aAdd(aCampos,{"MT106SCA",{" ", " "}})
							EndIf
							
							aadd(aDocs,;
									{SCP->CP_PRODUTO,;			//aPequena[x,1] : Produto
									 nLoteSC 		,;			//aPequena[x,2] : Quantidade da necessidade total
									 cFilAux        ,;			//aPequena[x,3] : Filial que será gerada o documento (grava no C1_FILIAL)
									 cFilAux		,;			//aPequena[x,4] : Filial que será feita entrega do produto (grava no C1_FILENT)
									 "1"     		,;			//aPequena[x,5] : Documento que será gerado sendo 1=Solicitação de Compras e 2=Pedido de Compra
									 aFornecedor[1]	,; 			//aPequena[x,6] : Fornecedor do produto
									 aFornecedor[2]	,; 			//aPequena[x,7] : Loja do fornecedor do produto
									 "001" 			,;			//aPequena[x,8] : Condição de pagamento
									 nPrc			,;		 	//aPequena[x,9] : Preço do Produto
									 aClone(aRateio),;		 	//aPequena[x,10] : Array de Rateio
									 SCP->CP_NUM	,;		 	//aPequena[x,11] : Código Documento
									 SCP->CP_ITEM	,;			//aPequena[x,12] : Item do Documento 
									 aClone(aCampos),;		 	//aPequena[x,13] : Dados de campos adicionais
									 (cCursor)->CP_FILIAL})	 	//aPequena[x,14] : Filial de Origem (grava no DHN_FILORI)
							Reclock("SCP",.F.)
							SCP->CP_PREREQU := "S"
							MsUnlock()
							//limpa o array para o Loop
							aCampos	:= {}
						EndIf

						nQtde -= nQtdPre
						nSaldo-= nEstoque
						cSeq  := Soma1(cSeq,Len(SCQ->CQ_NUMSQ))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Ponto de Entrada para permitir a geração de Ordem de Produção pela Pré-Requisição³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lMASAVLOP
							 ExecBlock("MASAVLOP",.F.,.F.)
						EndIf	
						// Se houve erro na geracao da rotina automatica da solicitacao de compra desfaz alteracoes
						If lErrAutSC .And. !IsBlind()
							AVISO("MATA110","Ocorreu um erro na geração da rotina automática de Solicitação de Compra",{"Ok"}) //  -  - 
							DisarmTransaction()
							Exit
						EndIf
					EndDo
					
				End Transaction
				If !Empty(cMsg) .And. !lAuto
					Aviso("Atenção",cMsg,{"Confirma"},1)
				EndIf
				If	Empty(cMsg)
					AAdd(aRecSCP,SCP->(Recno()))
				EndIf
			EndIf
		EndIf
	EndIf
	dbSelectArea(cCursor)
	dbSkip()
EndDo

If !Empty(aDocs)
	aDocsCp := aClone(aDocs) 
	aResultado:= ComGeraDoc(aDocs,.T.,.F.,.F.,.T.,30,"MATA106",/*lEnviaEmail*/,nAglutDoc  )
	If ExistBlock("MT106SC1")
		For nLoop := 1 To Len( aResultado )
			If Len(aResultado[nLoop]) > 0
				dbSelectArea("SCP")
				dbSetOrder(1)
				dbSeek(aDocsCp[nLoop][14]+aDocsCp[nLoop][11]+aDocsCp[nLoop][12])
				Do Case
					//--Tipo de documento gerado pela biblioteca de compras
					Case aResultado[nLoop,1,3] == "1" //-- Solicitação de Compras
						SC1->(dbSetOrder(1)) //-- C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD
						If SC1->(dbSeek(aResultado[nLoop,1,1]+aResultado[nLoop,1,2]))
							Execblock("MT106SC1",.F.,.F.,{"SC1",SC1->C1_NUM,SC1->C1_ITEM,SC1->(Recno())})
						EndIf
					Case aResultado[nLoop,1,3] == "2" //-- Pedido de Compras
						SC7->(dbSetOrder(1))  //-- C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
						If SC7->(dbSeek(aResultado[nLoop,1,1]+aResultado[nLoop,1,2]))
							Execblock("MT106SC1",.F.,.F.,{"SC7",SC7->C7_NUM,SC7->C7_ITEM,SC7->(Recno())})
						EndIf
					Case aResultado[nLoop,1,3] == "3" //-- Autorização de Entrega
						SC7->(dbSetOrder(1))  //-- C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
						If SC7->(dbSeek(aResultado[nLoop,1,1]+aResultado[nLoop,1,2]))
							Execblock("MT106SC1",.F.,.F.,{"SC7",SC7->C7_NUM,SC7->C7_ITEM,SC7->(Recno())})
						EndIf
					Case aResultado[nLoop,1,3] == "5" //-- Medição de Contrato
						CND->(dbSetOrder(4))  //--CND_FILIAL+CND_NUMMED
						If CND->(dbSeek(aResultado[nLoop,1,1]+aResultado[nLoop,1,2]))
							Execblock("MT106SC1",.F.,.F.,{"CND",CND->CND_NUMMED,,CND->(Recno())})
						EndIf
					Case aResultado[nLoop,1,3] == "6" //-- Solicitação de Importação
						SW1->(dbSetOrder(1)) //-- W1_FILIAL+W1_CC+W1_SI_NUM+W1_COD_I 
						If SW1->(MsSeek(aResultado[nLoop,1,1]+PadR(cUndRequi,Len(SW1->W1_CC))+aResultado[nLoop,1,2]))
							Execblock("MT106SC1",.F.,.F.,{"SW1",SW1->W1_SI_NUM,SW1->W1_COD_I,SW1->(Recno())})
						EndIf
				EndCase
			Endif
		Next nLoop
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³P.E. Apos a geracao completa da Pre-Requisicao	   ³
//³PARAMIXB[1] := CQ_FILIAL   PARAMIXB[2] := CQ_NUM    ³
//³PARAMIXB[3] := CQ_ITEM     PARAMIXB[4] := CQ_NUMSQ  ³ 
//³PARAMIXB[5] := CQ_PRODUTO  PARAMIXB[6] := CQ_LOCAL  ³
//³PARAMIXB[7] := CQ_QUANT                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MT106PRE")
	ExecBlock("MT106PRE",.F.,.F.,aMT106SCQ)
EndIf

dbSelectArea(cCursor)
dbCloseArea()
dbSelectArea("SCP")

If lGeraDoc
	PcoFinLan("000051")
EndIf
RestArea(aArea)
Return(.T.)

/*/{Protheus.doc} A106AvalRA
	Rotina de avaliacao dos eventos de uma pre-requisicao ao almoxarifado
	(Esta funcao foi copiada e adaptada em substituicao a funcao MaAvalRA do programa COMXFUN)
	@type  Function
	@author Squad Entradas
	@since 13/01/2021
	@version 1.0
	@param cAliasSCQ, caracter, Alias da tabela de solicitacao de compra
	@param nEvento, numerico, Codigo do Evento
								[1] Implantacao de uma pre-requisicao ao almoxarifado
								[2] Estorno de uma pre-requisicao ao almoxarifado
	@param nQtdSoma, numerico, Quantidade da Soma
	@param cFilAux, caracter, Filial origem da SA
/*/
static Function A106AvalRA(cAliasSCQ,nEvento,nQtdSoma,cFilAux)

Local aArea 	:= GetArea()
DEFAULT cAliasSCQ := "SCQ"
DEFAULT nQtdSoma  := 0
DEFAULT cFilAux   := cFilAnt
Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Implantacao de uma pre-requisicao ao almoxarifado                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case nEvento == 1 .Or. nEvento == 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza as tabelas auxiliares                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	If ( !MsSeek(xFilial("SB2", cFilAux)+(cAliasSCQ)->CQ_PRODUTO+(cAliasSCQ)->CQ_LOCAL) )
		CriaSB2((cAliasSCQ)->CQ_PRODUTO,(cAliasSCQ)->CQ_LOCAL)
	EndIf
	RecLock("SB2")
	SB2->B2_QEMPSA += If(nEvento==1,(cAliasSCQ)->CQ_QTDISP,nQtdSoma)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cancelamento de uma pre-requisicao ao almoxarifado                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case nEvento == 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza as tabelas auxiliares                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	If ( !MsSeek(xFilial("SB2", cFilAux)+(cAliasSCQ)->CQ_PRODUTO+(cAliasSCQ)->CQ_LOCAL) )
		CriaSB2((cAliasSCQ)->CQ_PRODUTO,(cAliasSCQ)->CQ_LOCAL)
	EndIf
	RecLock("SB2")
	SB2->B2_QEMPSA -= (cAliasSCQ)->CQ_QTDISP
EndCase
RestArea(aArea)
Return(.T.)

/*/{Protheus.doc} A106SalPed
	Funcao utilizada para verificar Previsao de Entrada, campo B2_SALPEDI,
	verificando as SC's geradas por Solicitacao ao Armazem e SC's geradas pelo MRP
	(Esta funcao foi copiada e adaptada em substituicao a funcao AvalSalPed do programa COMXFUN)
	@type  Function
	@author Squad Entradas
	@since 13/01/2021
	@version 1.0
	@param cProd, caracter, Produto
	@param cLocal, caracter, Armazem
/*/
static Function A106SalPed(cProd,cLocal)

Local aAreaAnt  := GetArea()
Local aAreaSB2  := SB2->(GetArea())
Local nQtdPrev  := 0
Local lQuery    := .F.
Local cQuery    := ''
Local cAliasSC1 := 'SC1'
Local cAliasSC7 := ""
Local nLE       := RetFldProd(cProd,"B1_LE")

Default cProd   := ''
Default cLocal  := ''

dbSelectArea('SB2')
dbSetOrder(1)
If dbSeek(xFilial("SB2")+cProd+cLocal)
	nQtdPrev := SB2->B2_SALPEDI
	If nQtdPrev > 0 .And. nLE <= 0
		dbSelectArea('SC1')
		dbSetOrder(2)

		lQuery := .T.
		cAliasSC1:= GetNextAlias()
		cQuery += "SELECT C1_QUANT,C1_QUJE,C1_ORIGEM,C1_SEQMRP,C1_OP "
		cQuery +=   "FROM "+RetSqlName("SC1")+" "
		cQuery +=  "WHERE C1_FILIAL='"+xFilial("SC1")+"' "
		cQuery +=   " AND C1_PRODUTO='"+cProd+"' "
		cQuery +=   " AND C1_LOCAL='"+cLocal+"' "
		cQuery +=   " AND C1_QUJE < C1_QUANT "
		cQuery +=   " AND D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC1,.T.,.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisa quantidade prevista para entrada ja reservada para SA ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !(cAliasSC1)->(Eof()) .And. IIf(lQuery,.T.,cSeek==(cAliasSC1)->C1_FILIAL+(cAliasSC1)->C1_PRODUTO)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se nao deve considerar a solicitacao de compras      ³	
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lQuery
				If (cAliasSC1)->C1_LOCAL <> cLocal .Or. (cAliasSC1)->C1_QUJE >= (cAliasSC1)->C1_QUANT
					dbSkip()
					Loop
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Subtrai da quantidade prevista das reservas para SA e MRP.    ³	
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim((cAliasSC1)->C1_ORIGEM) == "MATA106" .Or. !Empty((cAliasSC1)->C1_SEQMRP) .Or. !Empty((cAliasSC1)->C1_OP)
				nQtdPrev -= (cAliasSC1)->C1_QUANT-(cAliasSC1)->C1_QUJE
			EndIf
			dbSkip()
		EndDo 
		If lQuery
			(cAliasSC1)->(dbCloseArea())
		EndIf

		// Verifica atendimento dos pedidos de compra vinculados a SC
		cAliasSC7 := GetNextAlias()
		cQuery := "SELECT SC1.C1_ORIGEM, SC1.C1_SEQMRP, SC1.C1_OP, SC7.C7_QUANT, SC7.C7_QUJE, SC7.C7_TES "
		cQuery += "FROM "+RetSqlName("SC1")+" SC1 "
		cQuery += "INNER JOIN "+RetSqlName("SC7")+" SC7 "
		cQuery += "  ON SC7.C7_FILIAL = '" + xFilial("SC7") + "' "
		cQuery += "  AND SC1.C1_NUM = SC7.C7_NUMSC "
		cQuery += "  AND SC1.C1_ITEM = SC7.C7_ITEMSC "
		cQuery += "  AND SC1.C1_PRODUTO = SC7.C7_PRODUTO "
		cQuery += "  AND SC7.D_E_L_E_T_ = ' ' "
		cQuery += "WHERE SC1.C1_FILIAL = '" + xFilial("SC1") + "' "
		cQuery += "AND SC1.C1_PRODUTO = '" + cProd + "' "
		cQuery += "AND SC1.C1_LOCAL = '" + cLocal + "' "
		cQuery += "AND SC7.C7_QUJE < SC7.C7_QUANT "
		cQuery += "AND SC1.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisa quantidade prevista para entrada ja reservada para SA ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !(cAliasSC7)->(Eof())
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Subtrai da quantidade prevista das reservas para SA e MRP.    ³	
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim((cAliasSC7)->C1_ORIGEM) == "MATA106" .Or. !Empty((cAliasSC7)->C1_SEQMRP) .Or. !Empty((cAliasSC7)->C1_OP)
				If Empty((cAliasSC7)->C7_TES) .Or.;
				   Posicione("SF4",1,xFilial("SF4")+(cAliasSC7)->C7_TES,"F4_ESTOQUE") == "S"
					nQtdPrev -= (cAliasSC7)->C7_QUANT - (cAliasSC7)->C7_QUJE
				EndIf
			EndIf
			(cAliasSC7)->(dbSkip())
		EndDo
		(cAliasSC7)->(dbCloseArea())

	EndIf
EndIf	

RestArea(aAreaSB2)
RestArea(aAreaAnt)
Return(nQtdPrev)

/*/{Protheus.doc} A106EmpSCP
	Funcao para verificar o empenho relacionado ao SCP
	(Esta funcao foi copiada e adaptada em substituicao a funcao AvalEmpSCP do programa COMXFUN)
	@type  Function
	@author Squad Entradas
	@since 13/01/2021
	@version 1.0
	@param cProduto, caracter, Produto
	@param cLocal, caracter, Armazem
	@param cOP, caracter, Ordem de Producao
	@param nQuant, numerico, Quantidade
/*/
static Function A106EmpSCP(cProduto,cLocal,cOP,nQuant)

Local lRet:=.F.
Local aArea:=GetArea()
Local cSeek:=xFilial("SD4")+cProduto+cOP
Local cCompara:= "D4_FILIAL+D4_COD+D4_OP"
Local nQtdOri:=0  

If !Empty(cOP)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe empenho para o produto              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD4")
	dbSetOrder(1)
	dbSeek(cSeek)
	While !EOF() .And. cSeek == &(cCompara)
		If D4_LOCAL == cLocal
			nQtdOri+=D4_QUANT
		EndIf
		dbSkip()
	End
	RestArea(aArea)
	lRet:=QtdComp(nQtdOri)>=QtdComp(nQuant)
EndIf
Return(lRet)     
     
