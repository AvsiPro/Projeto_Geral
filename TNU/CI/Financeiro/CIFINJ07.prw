#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWBROWSE.CH"
#include "tbiconn.ch" 
 
/*
===============================================================================================
Programa..............: CIFINJ07
Desenvolvedor.........: 
Data Criação..........: 11/2022
Descricao / Objetivo..: API conexão Nexxera
Solicitante/Modulo....: Clínicas Inteligentes / Todos 
Release / Data........: v12.33 
Obs...................: Rotina Schedulada
================================================================================================
*/

/*
+----------------------------------------------------------------------------------------------------+
|                     Historico de Atualizacoes                                                      |
|                                                                                                    |
| 02/07/2025 - Alteracao no Select - correcao ZPQ_VLTOT                                              |
+----------------------------------------------------------------------------------------------------+

*/

User Function CIFINJ07(aParam) //(cEmpCli, cFilDe, cFilAte)

Local cAPIUrl   := ""
Local cAPIUpld  := ""
Local cTokNex   := ""
Local cAPICxPt  := ""
Local cParURL   := ""

Local cParUpld  := ""
Local cRetHTTP  := ""
Local cFileUrl  := ""
Local cFileUpld := ""
Local cErrParse := "" 

Local cSavePath := "\nexxera\CIFINJ07\"
Local cSaveFile := "enviar\"
Local cMoveFile := "enviado\" 

Local aHeader   := {}
Local nX        := 0
//Local nY        := 0

Local nCriad    := 0
Local cAliasZPO := ""
Local cDateQRY  := ""
Local cTpTitulo := ""
Local cLine     := ""
Local nSequen   := 0
Local cKeyZPQ   := ""
Local aTables   := {"SM0","SX2","ZPQ","SX6","SX3"}
Local aRecZPQ   := {}
Local aFileZPQ  := {}
Local cNumCar   := ""
Local cFilDeQRY := "" //"% '" + cFilDe + "' %"
Local cFilAtQRY := "" //"% '" + cFilAte + "' %"
Local cCNPJEst  := ""
Local cNSUTEF   := ""
Local cDateTr   := ""
Local cHourTr   := ""
Local cTipo     := ""
Local cFilDe := ""
Local cFilAte := ""
Local cEmpCli := ""
Local cFilDo := ""
Local aAtuZPQ   :=  {}
Local cUpdate   :=  ''

Private oJSonUpld := Nil
Private oJSonDown := Nil

If ValType(aParam) == "A"
    cFilDe := aParam[2]
    cFilAte := aParam[3]
    cEmpCli := aParam[1]
Else
    //cFilDe := "000101"
    //cFilAte := "000101"
    cFilDe := "000101"
    cFilAte := "999901"
    cEmpCli := "01"
Endif    

cFilDeQRY := "% '" + cFilDe + "' %"
cFilAtQRY := "% '" + cFilAte + "' %"

If IsBlind() .OR. Select("SM0") == 0
    RpcSetType( 3 ) 
    RpcSetEnv( cEmpCli, cFilDe, , , "FIN", "FINA914", aTables, , ,.T. ) 
EndIf

cDateQRY  	:= "% '" + DToS(DaySub(dDataBase,1)) + "' %"
cTpTitulo   := "% " + SuperGetMV("MV_XNEXTIP",.F.,"'CC','CD'") + " %"
cAPIUrl     := SuperGetMV("MV_XNEXURL",.F.,"https://api-sandbox.nexxera.com/skyline")
cAPIUpld    := SuperGetMV("MV_XNEXUPL",.F.,"/api/v1/requests/upload") 
cTokNex     := SuperGetMV("MV_XNEXTOK",.F.,"SU5URUxJR0VOVEVTLklOVEVMSUdFTlRFUzo0NWU4YzRiOS03YzlhLTQzOWYtYmRlZS0wZjA0MDRjNmYwNmM=")
cAPICxPt    := SuperGetMV("MV_XNEXCXP",.F.,"INTELIGENTES.INTELIGENTES") 
cOperNex    := SuperGetMV("MV_XNEXOPE",.F.,"060") 
cParURL     := '{"receiver": "'+AllTrim(cAPICxPt)+'"}'
cAliasZPO   := GetNextAlias()

// ALTERAR QUERY GERACAO DE ARQUIVO
BeginSql Alias cAliasZPO
    SELECT ZPQ_FILIAL, ZPQ_CONTRO, ZPQ_DATA, ZPQ_HORA, ZPQ_CARTAO, ZPQ_NSU, COUNT(ZPQ_PARC) AS ZPQ_PARCELAS, ZPQ_CODAUT, ZPQ_VLTOT AS ZPQ_VLTOT, ZPQ_TIPO, ZPQ_CBANDE, ZPQ_IDPIX
        FROM %TABLE:ZPQ% ZPQ
    WHERE   ZPQ_FILIAL >= %Exp:cFilDeQRY%
        AND ZPQ_FILIAL <= %Exp:cFilAtQRY%
        AND ZPQ_TIPO IN (%Exp:cTpTitulo%)
        AND ZPQ_ENVNEX =  ""
        AND ZPQ_CBANDE <> ""
        AND ZPQ.%NOTDEL%
	GROUP BY ZPQ_FILIAL,ZPQ_CONTRO, ZPQ_DATA, ZPQ_HORA, ZPQ_CARTAO, ZPQ_NSU, ZPQ_CODAUT, ZPQ_TIPO, ZPQ_CBANDE, ZPQ_IDPIX, ZPQ_VLTOT
    ORDER BY ZPQ_FILIAL, ZPQ_DATA 
EndSQl

If !(cAliasZPO)->(Eof())
    ChkDirA01(cSavePath+cSaveFile)
    While !(cAliasZPO)->(Eof())
         CONOUT("CIFINJ07 - FILIAL '"+cFilDo+"'")
        //header
        cFilDo  := (cAliasZPO)->ZPQ_FILIAL 
        cCNPJEst := AllTrim(GetCNPJEst(cEmpCli, AllTrim(cFilDo)))
        cDateTr  := DToS(Date())
        cHourTr  := StrTran(Time(),":","")
        nSequen := 0
        nCriad  := 0
        aRecZPQ := {}
                
        //cFile   := cSavePath + cSaveFile + AllTrim(cFilDo) + "_" + DToS(Date()) + "_" + StrTran(Time(),":","") + ".txt"
        cFile   := cSavePath + cSaveFile + cCNPJEst + "_" + cDateTr + "_" + cHourTr + ".txt"
        nHandle := FCreate(cFile,,,.F.)
        If nHandle == -1
            While !(cAliasZPO)->(Eof()) .AND. (cAliasZPO)->ZPQ_FILIAL == cFilDo
                (cAliasZPO)->(DBSkip())
            EndDo
            CONOUT("CIFINJ07 - ERRO NA CRIAÇÃO DO ARQUIVO DA FILIAL '"+cFilDo+"'")
            Loop
        EndIf

        DO CASE
            Case Alltrim((cAliasZPO)->ZPQ_TIPO) == 'CC'
                ctipo := '1'
            Case Alltrim((cAliasZPO)->ZPQ_TIPO) == 'CD'
                ctipo := '2'
            Case Alltrim((cAliasZPO)->ZPQ_TIPO) == 'PXC'
                ctipo := 'F'
            OTHERWISE
                cTipo := '0'          
        END CASE

        cLine := "SITEF     "          				// 01
        cLine += cDateTr               				// 02
        cLine += cHourTr		               		// 03
        cLine += Right(StrZero(0,14)+cCNPJEst,14)   // 04
        cLine += Space(362)                 		// 05
        FWrite(nHandle,cLine+CRLF)
        nCriad++
        // nada altera ate aqui

        //body             ZPQ_FILIAL, ZPQ_CONTRO   ZPQ_NSU ZPQ_CBANDE
        While (cAliasZPO)->ZPQ_FILIAL == cFilDo
            //Array para atualizar a ZPQ no final
            If Ascan(aAtuZPQ,(cAliasZPO)->ZPQ_FILIAL) == 0
                Aadd(aAtuZPQ,(cAliasZPO)->ZPQ_FILIAL)
            EndIf 

            nSequen++   
            cKeyZPQ := (cAliasZPO)->ZPQ_CONTRO
            cNumCar := AllTrim((cAliasZPO)->ZPQ_CARTAO)
            cNSUTEF := Alltrim((cAliasZPO)->ZPQ_NSU)
                                    
            cLine := StrZero(nSequen,7)        													// 01
            cLine += (cAliasZPO)->ZPQ_DATA   													// 02
            cLine += Right(StrZero(0,6)+AllTrim(StrTran((cAliasZPO)->ZPQ_HORA,":","")),06)  	// 03
            cLine += StrTran(StrZero((cAliasZPO)->ZPQ_VLTOT,16,2),".","")						// 04
            cLine += StrZero(0,15)                 												// 05
            cLine += Right(StrZero(0,19)+cNumCar,19)											// 06
            cLine += Right(StrZero(0,13)+cNSUTEF,13)		    								// 07
            cLine += StrZero(0,12)				                								// 08
            cLine += Space(13)                													// 09
            cLine += StrZero(0,13)                 												// 10
            cLine += StrZero((cAliasZPO)->ZPQ_PARCELAS,2)										// 11
            cLine += Right(Space(6)+Alltrim((cAliasZPO)->ZPQ_CODAUT),6)   						// 12
            cLine += "00"                      													// 13
            cLine += cOperNex                  													// 14
            cLine += Right(StrZero(0,14)+cCNPJEst,14)											// 15
            cLine += Space(1)                  													// 16
            cLine += cTipo                                                     					// 17
            cLine += StrZero(0,2)                  												// 18
            cLine += "1"                       													// 19
            cLine += "0000000"                 													// 20
            cLine += Space(20)                 													// 21
            cLine += Space(20)                 													// 22
            cLine += "000"                     													// 23
            cLine += "3"                       													// 24
            cLine += Right(Space(35)+cKeyZPQ,35)												// 25
            cLine += Right(StrZero(0,15)+cNSUTEF,15)											// 26
            cLine += Right(StrZero(0,3)+Alltrim((cAliasZPO)->ZPQ_CBANDE),3)						// 27
            cLine += StrTran(StrZero((cAliasZPO)->ZPQ_VLTOT,16,2),".","") 						// 28
            cLine += StrTran(StrZero((cAliasZPO)->ZPQ_VLTOT,16,2),".","")  						// 29
            cLine += StrTran(StrZero((cAliasZPO)->ZPQ_VLTOT,16,2),".","")  						// 30
            cLine += Right(Space(50)+Alltrim((cAliasZPO)->ZPQ_IDPIX),50)						// 31
            cLine += Space(48)                      											// 32
            FWrite(nHandle,cLine+CRLF)
            Aadd(aRecZPQ, cKeyZPQ)
            (cAliasZPO)->(DBSkip())
            nCriad++
        EndDo
        //trailer        
        nCriad++
        cLine := "SITEF     "          // 01
        cLine += cDateTr               // 02
        cLine += cHourTr               // 03
        cLine += StrZero(nCriad,7)     // 04
        cLine += Space(369)            // 05
        FWrite(nHandle,cLine)
        FClose(nHandle)  
        Aadd(aFileZPQ,cFile)
        Aadd(aFileZPQ,aRecZPQ)        
    EndDo
Else
    CONOUT("CIFINJ07 - QUERY SEM RESULTADOS ! FIM DA ROTINA.")
EndIf

If Select(cAliasZPO) <> 0
    (cAliasZPO)->(DbCloseArea())
    Ferase(cAliasZPO+GetDBExtension())
Endif

If Len(aFileZPQ) > 0
    ChkDirA01(cSavePath+cMoveFile)
    For nX := 1 To Len(aFileZPQ) Step 2
        aHeader := {}        
        aAdd(aHeader,"service-token: "+cTokNex)
        aAdd(aHeader,"Content-Type: application/json") 
        //RECEBE URL PARA UPLOAD DOS ARQUIVOS
        cFileUrl := HTTPPost(cAPIUrl+cAPIUpld,,cParURL,,aHeader,@cRetHTTP)

        If HTTPGetStatus(@cRetHTTP) == 200 // SUCESSO
            cRetHTTP  := "" 
            oJSonUpld := JsonObject():New()
            cErrParse := oJSonUpld:FromJson(cFileUrl)
            If ValType(cErrParse) == "U" // SUCESSO
                cURL := oJSonUpld["url"]
                aHeader := {}
                aAdd(aHeader,"Content-Type: multipart/form-data") 
                cParUpld  := 'Content-Disposition: form-data; name="files"; filename="'+aFileZPQ[nX]+'"'
                cFileUpld := HTTPPost(cURL,,cParUpld,,aHeader,@cRetHTTP)
                If HTTPGetStatus(@cRetHTTP) == 200 // SUCESSO
                    CONOUT("CIFINJ07 - ARQUIVO '"+Subs(aFileZPQ[nX],RAt("\", aFileZPQ[nX])+1,Len(aFileZPQ[nX]))+"' ENVIADO COM SUCESSO !")
                    //copyfile envio -> enviado
                    If __CopyFile(aFileZPQ[nX],cSavePath+cMoveFile+Subs(aFileZPQ[nX],RAt("\", aFileZPQ[nX])+1,Len(aFileZPQ[nX])))
                        //apaga o original
                        FErase(aFileZPQ[nX])
                    EndIf
                    /*seta flag de controle
                    For nY := 1 To Len(aFileZPQ[nX+1])
						TCSqlExec("UPDATE "+RetSqlName("ZPQ")+" SET ZPQ_ENVNEX = 'S' WHERE D_E_L_E_T_ = '' AND TRIM(ZPQ.R_E_C_N_O_) = '"+aFileZPQ[nX+1,nY]+"'")   
                    Next nY */
                Else
                    CONOUT("CIFINJ07 - ERRO NO UPLOAD DO ARQUIVO '"+Subs(aFileZPQ[nX],RAt("\", aFileZPQ[nX])+1,Len(aFileZPQ[nX]))+"' - ERRO: " + cRetHTTP )
                EndIf            
            Else
                CONOUT("CIFINJ07 - FALHA NA DESSERIALIZAÇÃO DO CONTEUDO JSON DE ARQUIVOS ! ERRO: " + cErrParse )
            EndIf
        Else
            CONOUT("CIFINJ07 - ERRO NO RECEBIMENTO DA URL PARA UPLOAD DE ARQUIVOS. ERRO: " + cRetHTTP )
        EndIf
    Next nX

    CONOUT("CIFINJ07 - FIM DO ENVIO DE ARQUIVO")
EndIf

For nX := 1 to len(aAtuZPQ)
    //Aadd(aAtuZPQ,{(cAliasZPO)->ZPQ_FILIAL,(cAliasZPO)->ZPQ_CONTRO,(cAliasZPO)->ZPQ_NSU,(cAliasZPO)->ZPQ_CBANDE})
    cUpdate := "UPDATE "+RetSQLName("ZPQ")+" SET ZPQ_ENVNEX='S'"
    cUpdate += " WHERE ZPQ_FILIAL='"+aAtuZPQ[nX]+"' AND ZPQ_ENVNEX = ' '"
    cUpdate += " AND ZPQ_CBANDE <> ' ' AND D_E_L_E_T_=' '"
    
    If TCSqlExec(cUpdate) <> 0
        MsgAlert("Não foi possível executar o update para a query "+cUpdate,"CIFINJ07")
    EndIF 
Next nX 

If IsBlind() .OR. Select("SM0") == 0
    RpcClearEnv()
EndIf

Return

/*
Programa.: ChkDirA01
Data.....: 11/2022
Descricao: Check e cria diretorios.
Uso......: Clinicas Inteligentes
*/

Static Function ChkDirA01(cPath)

Local aPaths    := Separa(Right(cPath,Len(cPath)-1),"\",.T.)
Local nY        := 0
Local cPathChk  := ""

For nY := 1 To Len(aPaths)
    If Empty(aPaths[nY])
        Loop
    EndIf
    If !File(cPathChk+"\"+aPaths[nY])
        MakeDir(cPathChk+"\"+aPaths[nY])
        CONOUT("CIFINJ07 - DIRETORIO '"+cPathChk+"\"+aPaths[nY]+"' CRIADO - ChkDirA01")
    EndIf
    cPathChk += "\"+aPaths[nY]
Next nY

Return

/*
Programa.: GetCNPJEst
Data.....: 11/2022
Descricao: CNPJ da filial.
Uso......: Clinicas Inteligentes
*/

Static Function GetCNPJEst(cEmpJob, cFilJob)

Local aAreaSM0  := SM0->(GetArea())
Local aSM0CGC   := {}
Local cRet      := ""

aSM0CGC := FWSM0Util():GetSM0Data( cEmpJob , cFilJob , { "M0_CGC" } ) 

cRet := aSM0CGC[1,2]

RestArea(aAreaSM0)

Return cRet
