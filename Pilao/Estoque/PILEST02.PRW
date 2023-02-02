#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} GeraPre
    (long_description)
    @type  Static Function
    @author user
    @since 01/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function PILEST02()

local aSolicit := {}
local aItens    := {}
local n1Cnt
local lMarkB, lDtNec
local BFiltro   := {|| .T.}
local lConsSPed, lGeraSC1, lAmzSA
local cSldAmzIni, cSldAmzFim
local lLtEco, lConsEmp
local nAglutSC
local lAuto, lEstSeg
local aRecSCP
local lRateio
local nFind
Local nPos := 1
//local cMail, cBody

// preenche os parâmetros MV_PARnn com as respostas das perguntas da rotina MATA106
Pergunte("MTA106",.F.)

lMarkB     := .F.
lDtNec     := (MV_PAR01 == 1)
BFiltro    :=  {|| .T.}
lConsSPed  := (MV_PAR02 == 1)
lGeraSC1   := .F. //(MV_PAR03 == 1)
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
/*

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

*/
MaSAPreReq(lMarkB,lDtNec,BFiltro,lConsSPed,lGeraSC1,lAmzSA,cSldAmzIni,cSldAmzFim,lLtEco,lConsEmp,nAglutSC,lAuto,lEstSeg,@aRecSCP,lRateio)

// monta o array com as solicitações e seus itens
For n1Cnt := 1 to Len(aRecSCP)
    SCP->(dbGoTo(aRecSCP[n1Cnt]))
    aItens := {}
    aAdd(aItens,allTrim(SCP->CP_ITEM))
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

Return
