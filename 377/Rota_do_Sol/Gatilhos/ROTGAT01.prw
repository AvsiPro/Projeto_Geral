#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} nomeFunction
(long_description)
@type user function
@author user
@since 12/07/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function Rotgat01

Local aArea  := GetArea()
Local cQuery 
Local cProx  := ""

If Funname() <> "ROT001"
    cQuery := "SELECT MAX(N1_CBASE)+1 AS NEWATF"
    cQuery += " FROM "+RetSQLName("SN1")
    cQuery += " WHERE N1_CBASE NOT LIKE 'N%' AND D_E_L_E_T_=' '"

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)

    If (cAliasTMP)->(!EoF())
        cProx := cvaltochar((cAliasTMP)->NEWATF)
    EndIF 
EndIf 

RestArea(aArea)

Return(cProx)

/*/{Protheus.doc} nomeFunction
(long_description)
@type user function
@author user
@since 12/07/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function Rotgat02

Local aArea     := GetArea()
Local cQuery    := ""
Local cHist     := ""
Local lRet      := .T.
Local oModel    := FWModelActive()
Local dDtAqs    := oModel:GetValue('SN1MASTER','N1_AQUISIC')
Local cGrupo    := oModel:GetValue('SN1MASTER','N1_GRUPO')
Local nTxDep1   := Posicione("SNG",1,xFilial("SNG")+cGrupo,"NG_TXDEPR1")

If Funname() <> "ROT001"

    cQuery := "SELECT CT2_CCC,CT2_CCD,CT2_HIST FROM "+RetSQLName("CT2")
    cQuery += " WHERE CT2_FILIAL='"+xFilial("CT2")+"'"
    cQuery += " AND CT2_HIST LIKE '%NFE "+SN1->N1_NFISCAL+"%'"
    cQuery += " AND CT2_DATA = '"+DTOS(SN1->N1_AQUISIC)+"'"
    cQuery += " AND D_E_L_E_T_=' '"

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)

    If (cAliasTMP)->(!EoF())
        cHist := cvaltochar((cAliasTMP)->CT2_HIST)
        cCusto := cvaltochar((cAliasTMP)->CT2_CCC)
        oModel:SetValue('SN3DETAIL','N3_HISTOR',cHist)
        oModel:SetValue('SN3DETAIL','N3_CCUSTO',cCusto)
    EndIF 

    oModel:SetValue('SN3DETAIL','N3_DINDEPR',dDtAqs)
    oModel:SetValue('SN3DETAIL','N3_TIPO',If(substr(cGrupo,1,1)=="2","10","01"))

    If nTxDep1 == 0
    //TUDO QUE A TAXA DE DEPRECIACAO DO GRUPO FOR ZERO NA txdepr1
    //N3_CODIND 02
    //SENAO VAZIO
        oModel:SetValue('SN3DETAIL','N3_CODIND','02')
    Else 
        oModel:SetValue('SN3DETAIL','N3_CODIND',' ')
    ENDIF 
EndIF 

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} nomeFunction
(long_description)
@type user function
@author user
@since 12/07/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function Rotgat03

Local aArea  := GetArea()
Local cQuery 
Local cProx  := M->N1_ITEM
Local cAtfxo := M->N1_CBASE

If Funname() <> "ROT001"

    If M->N1_CBASE <> SN1->N1_CBASE 
        cQuery := "SELECT MAX(N1_ITEM)+1 AS NEWITM"
        cQuery += " FROM "+RetSQLName("SN1")
        cQuery += " WHERE N1_CBASE = '"+cAtfxo+"' AND D_E_L_E_T_=' '"

        cAliasTMP := GetNextAlias()
        MPSysOpenQuery(cQuery, cAliasTMP)

        If (cAliasTMP)->(!EoF())
            cProx := strzero((cAliasTMP)->NEWITM,4)
        EndIF 
    EndIf 

    If val(cProx) < 1
        cProx := '0001'
    EndIf 
EndIf 

RestArea(aArea)

Return(cProx)
