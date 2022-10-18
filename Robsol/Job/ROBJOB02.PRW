#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
/*
    Geracao dos boletos, danfes e xml na pasta para que o portal acesse
    via ws não estava funcionando
*/
User function ROBJOB02()

Local cPasta  	:= 'C:\TOTVS33\protheus_data\clientes\cnpj\'
//Local ccnpj     := ''
Local cQuery
Local aAux      :=  {}
Local nX        :=  1

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

cQuery := "SELECT F2_FILIAL,F2_DOC,F2_SERIE,A1_CGC"
cQuery += " FROM "+RetSQLName("SF2")+" F2"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='01' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE F2_FILIAL BETWEEN '  ' AND 'ZZZ'"
cQuery += " AND F2_EMISSAO BETWEEN '"+dtos(firstday(ddatabase-120))+"' AND '"+dtos(ddatabase)+"'"
cQuery += " AND F2.D_E_L_E_T_=' '"
cQuery += " AND F2_CHVNFE<>' '"
//cQuery += " AND F2_DUPL<>' '"

If Select('QUERY') > 0
    dbSelectArea('QUERY')
    dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

DbSelectArea("QUERY")

While !EOF()
    If !File(cPasta+Alltrim(QUERY->A1_CGC)+"\"+Alltrim(QUERY->F2_DOC)+".PDF")
        Aadd(aAux,{QUERY->F2_DOC,QUERY->F2_SERIE,QUERY->A1_CGC,QUERY->F2_FILIAL})
    ENDIF
    
    DbSkip()
Enddo

For nX := 1 to len(aAux)

    cfilant := aAux[nX,04]

    u_ROBDANFE(aAux[nX,01], aAux[nX,02], cPasta, aAux[nX,03])

    MV_PAR01 := aAux[nX,02]
    MV_PAR02 := aAux[nX,01]

    cfilorig := aAux[nX,04]

    DbSelectArea("SE1")
    DbSetOrder(1)
    If DbSeek(xFilial("SE1")+Avkey(MV_PAR01,"E1_PREFIXO")+Avkey(MV_PAR02,"E1_NUM"))
        

        Do While !EOF() .and. E1_PREFIXO+E1_NUM == Avkey(MV_PAR01,"E1_PREFIXO")+Avkey(MV_PAR02,"E1_NUM")
            If SE1->E1_SALDO > 0
                If !File(cPasta+alltrim(aAux[nX,03])+'\boleto_'+MV_PAR02+"_"+Alltrim(SE1->E1_PARCELA)+".pdf")
                    U_ROBBOL(.T.,cPasta+alltrim(aAux[nX,03])+'\',cfilorig,SE1->E1_PARCELA)
                EndIF
            ENDIF
            DBSkip()
        ENDDO
    EndIf

    //cfilant := cBkpFil
Next nX

return
