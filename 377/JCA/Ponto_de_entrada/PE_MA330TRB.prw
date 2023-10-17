#Include 'Totvs.ch'

/*/{Protheus.doc} MA330TRB
   @description: 
   @type: User Function
   @author: Felipe Mayer
   @since: 27/09/2023
/*/

User Function MA330TRB()

Local aArea     := GetArea()
Local cQuery    := ""
Local aDados    := {}

Public __oTmpCT2 := Nil

    If a330ParamZX[10] <> 3 // gera/apaga lancamentos contabeis
        
        Begin Transaction
        
            cQuery := " SELECT CT2.R_E_C_N_O_ AS CT2REC, CT2.*
            cQuery += " FROM "+RetSqlName("TQN")+" TQN
            cQuery += " INNER JOIN "+RetSqlName("ST9")+" ST9
            cQuery += "  	ON T9_ZFILORI = '"+cFilAnt+"'
            cQuery += "  	AND T9_CODBEM = TQN_FROTA
            cQuery += " 	AND T9_ZFILORI != ''
            cQuery += " 	AND ST9.D_E_L_E_T_ = ''
            cQuery += " INNER JOIN "+RetSqlName("SD3")+" SD3
            cQuery += " 	ON D3_FILIAL = TQN_FILIAL
            cQuery += " 	AND D3_XABAST = TQN_NABAST
            cQuery += " 	AND D3_XDTCTFL != ''
            cQuery += " 	AND SD3.D_E_L_E_T_ = ''
            cQuery += " INNER JOIN "+RetSqlName("CT2")+" CT2
            cQuery += " 	ON CT2_FILIAL = TQN_FILIAL
            cQuery += " 	AND CT2_XABAST = TQN_NABAST
            cQuery += " 	AND CT2.D_E_L_E_T_ = ''
            cQuery += " WHERE TQN.D_E_L_E_T_ = ''
            cQuery += " 	AND T9_ZFILORI != TQN_FILIAL

            cAliasTMP := GetNextAlias()
            MPSysOpenQuery(cQuery, cAliasTMP)

            While !(cAliasTMP)->(EoF())

                aAdd(aDados,{;
                    {'CT2_FILIAL' , (cAliasTMP)->CT2_FILIAL , Nil},;
                    {'CT2_LINHA'  , (cAliasTMP)->CT2_LINHA  , Nil},;
                    {'CT2_MOEDLC' , (cAliasTMP)->CT2_MOEDLC , Nil},;
                    {'CT2_DC'     , (cAliasTMP)->CT2_DC     , Nil},;
                    {'CT2_DEBITO' , (cAliasTMP)->CT2_DEBITO , Nil},;
                    {'CT2_CREDIT' , (cAliasTMP)->CT2_CREDIT , Nil},;
                    {'CT2_VALOR'  , (cAliasTMP)->CT2_VALOR  , Nil},;
                    {'CT2_ORIGEM' , (cAliasTMP)->CT2_ORIGEM , Nil},;
                    {'CT2_ROTINA' , FunName()               , Nil},;
                    {'CT2_HP'     , (cAliasTMP)->CT2_HP     , Nil},;
                    {'CT2_XABAST' , (cAliasTMP)->CT2_XABAST , Nil},;
                    {'CT2_HIST'   , (cAliasTMP)->CT2_HIST   , Nil} ;
                })

                DbSelectArea('CT2')
                CT2->(DbGoTo((cAliasTMP)->CT2REC))
                RecLock('CT2', .F.)
                    CT2->(DbDelete())
                CT2->(MsUnlock())

                (cAliasTMP)->(DbSkip())
            EndDo

            (cAliasTMP)->(DbCloseArea())


            If Len(aDados) > 0
                fCreateTemporary(aDados)
            Else
                DisarmTransaction()
            EndIf

        End Transaction
    EndIf

    RestArea(aArea)
    
Return


/*/{Protheus.doc} fCreateTemporary
   @description: 
   @type: Static Function
   @author: Felipe Mayer
   @since: 05/10/2023
/*/

Static Function fCreateTemporary(aDados)

local cAlias as char
local aIndex as array
local nX, nY := 0

    cIndex := StrTran( CT2->(IndexKey(1)), 'DTOS(CT2_DATA)', 'CT2_DATA' )
    aIndex := StrToKArr( cIndex, '+')

    __oTmpCT2 := FWTemporaryTable():New( /*cAlias*/, /*aFields*/)
    __oTmpCT2:SetFields(CT2->(DbStruct()))
    __oTmpCT2:AddIndex("01", aIndex )
    __oTmpCT2:Create()

    cAlias := __oTmpCT2:GetAlias()

    For nX := 1 To Len(aDados)
        (cAlias)->(DBAppend())
            For nY := 1 To Len(aDados[nX])
                &('(cAlias)->'+aDados[nX,nY,1]) := aDados[nX,nY,2]
            Next nY
        (cAlias)->(DBCommit())
    Next nX

Return
