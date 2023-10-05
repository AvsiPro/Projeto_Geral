#Include "PROTHEUS.CH"
#Include "topconn.ch"
#Include "rwmake.ch"
#Include 'TOTVS.ch'


/*/{Protheus.doc} MA330FIM
   @description: Customizações no final do custo medio / recriar a CT2 anteriormente apagada
   @type: User Function
   @author: Felipe Mayer
   @since: 05/10/2023
   @see: https://tdn.totvs.com/pages/releaseview.action?pageId=6087635
/*/
User Function MA330FIM()

local cAreaQuery as char
local cQuerySQL as char

    If a330ParamZX[10] <> 3 .And. ValType(__oTmpCT2) != 'U' // gera/apaga lancamentos contabeis
        cAreaQuery := GetNextAlias()
        cQuerySQL := "SELECT * FROM " + __oTmpCT2:GetRealName()

        DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuerySQL), cAreaQuery, .T., .T.)

        while !(cAreaQuery)->(Eof())

            aCab   := {}
            aItens := {}

            cFilBkp := cFilAnt
            cFilAnt := (cAreaQuery)->CT2_FILIAL

            aAdd(aCab, {'DDATALANC'  ,  dDataBase  ,Nil} )
            aAdd(aCab, {'CLOTE'      ,  '008840'   ,Nil} )
            aAdd(aCab, {'CSUBLOTE'   ,  '001'      ,Nil} )
            aAdd(aCab, {'CPADRAO'    ,  ''         ,Nil} )
            aAdd(aCab, {'NTOTINF'    ,  0          ,Nil} )
            aAdd(aCab, {'NTOTINFLOT' ,  0          ,Nil} )

            aAdd(aItens,{;
                {'CT2_FILIAL' , (cAreaQuery)->CT2_FILIAL , Nil},;
                {'CT2_LINHA'  , (cAreaQuery)->CT2_LINHA  , Nil},;
                {'CT2_MOEDLC' , (cAreaQuery)->CT2_MOEDLC , Nil},;
                {'CT2_DC'     , (cAreaQuery)->CT2_DC     , Nil},;
                {'CT2_DEBITO' , (cAreaQuery)->CT2_DEBITO , Nil},;
                {'CT2_CREDIT' , (cAreaQuery)->CT2_CREDIT , Nil},;
                {'CT2_VALOR'  , (cAreaQuery)->CT2_VALOR  , Nil},;
                {'CT2_ORIGEM' , (cAreaQuery)->CT2_ORIGEM , Nil},;
                {'CT2_ROTINA' , (cAreaQuery)->CT2_ROTINA , Nil},;
                {'CT2_HP'     , (cAreaQuery)->CT2_HP     , Nil},;
                {'CT2_XABAST' , (cAreaQuery)->CT2_XABAST , Nil},;
                {'CT2_HIST'   , (cAreaQuery)->CT2_HIST   , Nil} ;
            }) 

            lMsErroAuto := .F.
            lMsHelpAuto := .T.

            MsExecAuto({|x, y,z| CTBA102(x,y,z)}, aCab ,aItens, 3)

            If lMsErroAuto
                MostraErro('\system\','MA330FIM_'+DToS(dDataBase)+StrTran(cValToChar(Time()),":"))
            Endif

            (cAreaQuery)->(DBSkip())
        enddo

        (cAreaQuery)->(DBCloseArea())

        __oTmpCT2:Delete()
        __oTmpCT2 := Nil

        cFilAnt := cFilBkp
    EndIf
        
Return
