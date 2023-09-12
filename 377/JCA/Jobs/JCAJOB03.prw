#INCLUDE 'PROTHEUS.CH'

User Function JCAJOB03

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

// preenche os parâmetros MV_PARnn com as respostas das perguntas da rotina MATA106
Pergunte("MTA106",.F.)

lMarkB     := .F.
lDtNec     := (MV_PAR01 == 1)
BFiltro    := {||.t.}
lConsSPed  := (MV_PAR02 == 1)
lGeraSC1   := (MV_PAR03 == 1)
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

MaSAPreReq(lMarkB,lDtNec,BFiltro,lConsSPed,lGeraSC1,lAmzSA,cSldAmzIni,cSldAmzFim,lLtEco,lConsEmp,nAglutSC,lAuto,lEstSeg,@aRecSCP,lRateio)

// monta o array com as solicitações e seus itens
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
For n1Cnt := 1 to Len(aSolicit)
    oHtml := TWFHtml():New( cArqHTML )

    oHTML:ValByName("CP_EMISSAO",aSolicit[n1Cnt,4])
    oHTML:ValByName("CP_NUM",aSolicit[n1Cnt,1])
    oHTML:ValByName("CP_SOLICIT",aSolicit[n1Cnt,2])

    cItens := xGermail(aSolicit[n1Cnt])
    oHTML:ValByName("linhasPedido",cItens)
    cMail := 'alexandre.venancio@avsipro.com.br' // pode ser obtido de um parâmetro
    
    cFileName    := CriaTrab(NIL,.F.) + ".htm"
    cFileName    := cPathHTML + "\" + cFileName 
    oHtml:SaveFile(cFileName)

    cRet         := WFLoadFile(cFileName)
    cMensagem    := StrTran(cRet,chr(13),"")
    cMensagem    := StrTran(cRet,chr(10),"")
    cMensagem    := OemtoAnsi(cMensagem)

    U_JCAMAIL2('alexandre.venancio@avsipro.com.br','Solicitação de peças disponíveis',cMensagem,'',.F.)

Next n1Cnt

Return
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
nAglutSC   : Indica se aglutina ou nao as SC‘s (default = 1 Aglutina)
lAuto      : Rotina automática ? (default = .F.)
lEstSeg    : Subtrai o estoque de seguranca ? (default = .F.)
aRecSCP    : Array com os números dos registros manipulados na SCP (passar por referência)
lRateio    : Efetua rateio na solicitacao ao armazem ? (default = .F.)


Para executar "automaticamente", você pode utilizar as respostas do grupo de perguntas MTA106.

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


     
     
