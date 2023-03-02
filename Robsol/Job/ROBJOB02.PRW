#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#include "fileio.ch"
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
    RPCSetEnv("01","0103")
EndIf

cQuery := "SELECT F2_FILIAL,F2_DOC,F2_SERIE,A1_CGC"
cQuery += " FROM "+RetSQLName("SF2")+" F2"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='01' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE F2_FILIAL BETWEEN '  ' AND 'ZZZ' AND F2_SERIE BETWEEN ' ' AND 'ZZZ'"
cQuery += " AND F2_EMISSAO BETWEEN '"+dtos(firstday(ddatabase-415))+"' AND '"+dtos(ddatabase-250)+"'"
cQuery += " AND F2.D_E_L_E_T_=' '"
cQuery += " AND F2_CHVNFE<>' '"
cQuery += " AND F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA NOT IN(SELECT Z56_FILIAL+Z56_DOC+Z56_SERIE+Z56_CLIENT+Z56_LOJA FROM "+RetSQLName("Z56")+" WHERE D_E_L_E_T_=' ' AND Z56_DANFE='S')"
cQuery += " ORDER BY F2_EMISSAO DESC"

If Select('QUERY') > 0
    dbSelectArea('QUERY')
    dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

DbSelectArea("QUERY")

While !EOF()
    If !File(cPasta+Alltrim(QUERY->A1_CGC)+"\"+Alltrim(QUERY->F2_DOC)+".PDF")
        Aadd(aAux,{ QUERY->F2_DOC,;
                    QUERY->F2_SERIE,;
                    Alltrim(QUERY->A1_CGC),;
                    QUERY->F2_FILIAL})
    Else
        If !ChkArq(cPasta+Alltrim(QUERY->A1_CGC)+"\"+Alltrim(QUERY->F2_DOC)+".PDF")
            FERASE(cPasta+Alltrim(QUERY->A1_CGC)+"\"+Alltrim(QUERY->F2_DOC)+".PDF")
            CONOUT("APAGOU "+cPasta+Alltrim(QUERY->A1_CGC)+"\"+Alltrim(QUERY->F2_DOC)+".PDF"+CRLF)
            Aadd(aAux,{ QUERY->F2_DOC,;
                    QUERY->F2_SERIE,;
                    Alltrim(QUERY->A1_CGC),;
                    QUERY->F2_FILIAL})
        EndIf 
    ENDIF
    
    DbSkip()
Enddo

For nX := 1 to len(aAux)

    cfilant := aAux[nX,04]

    u_ROBDANFE(aAux[nX,01], aAux[nX,02], cPasta, aAux[nX,03])

    If File(cPasta+Alltrim(aAux[nX,03])+"\"+Alltrim(aAux[nX,01])+".PDF")
        lArqOk := ChkArq(cPasta+Alltrim(aAux[nX,03])+"\"+Alltrim(aAux[nX,01])+".PDF")

        If lArqOk	      		
            DbSelectArea("Z56")
            DbSetOrder(1)
            If Dbseek(aAux[nX,04]+aAux[nX,01]+aAux[nX,02])
                Reclock("Z56",.F.)
                Z56->Z56_DANFE := 'S' 
                Z56->Z56_XML   := 'S'
                Z56->(Msunlock())
            EndIf
        EndIf
    EndIf 
/*
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
*/
Next nX

return

Static Function ChkArq(cArquivo)
      
Local nHdl := fopen(cArquivo, FO_READ + FO_SHARED)
Local nTamArq := 0
Local nTamMin := 20480 // 100KB tamanho minimo dos pdfs - 100*1024
Local lRet := .T.

If nHdl == -1
	fclose(nHdl)
	lRet := .F.
	Return lRet
EndIf	
   
nTamArq := FSeek(nHdl, 0, FS_END)
conout("Tamanho arquivo " +cArQuivo + " -> " +CVALTOCHAR(nTamArq) )   // retirar depois
If nTamArq < nTamMin
	lRet := .F.
EndIf
           
fclose(nHdl)

Return lRet
