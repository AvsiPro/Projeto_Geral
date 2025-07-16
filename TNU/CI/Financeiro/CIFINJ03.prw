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
Programa..............: CIFINJ03
Desenvolvedor.........: 
Data Criao..........: 10/2022
Descricao / Objetivo..: API DOWNLOAD Nexxera
Solicitante/Modulo....: Clnicas Inteligentes / Todos 
Release / Data........: v12.33 
Obs...................: Rotina Schedulada
================================================================================================
*/

/*
+-------------------------------------------------------------------+
|                Historico de Alteraçoes                            |
|                                                                   |
| 07/01/2025 - Exclusão de download dos arquivos EXT                |
|                                                                   |
+-------------------------------------------------------------------+
*/

User Function CIFINJ03(aParam) //(cEmpCli, cFilCli)
 
Local cAPIUrl   := ""
Local cAPIList  := ""
Local cAPIDown  := ""
Local cTokNex   := ""
Local cDataFim  := PADL(cValtoChar(DaySub(Day(Date()),1)),2,"0")+'-'+PADL(cValtoChar(Month(Date())),2,"0")+'-'+cValtoChar(Year(Date()))
Local cDataIni  := PADL(cValtoChar(DaySub(Day(Date()-2),1)),2,"0")+'-'+PADL(cValtoChar(Month(Date()-1)),2,"0")+'-'+cValtoChar(Year(Date()-1)) 
Local cParList  := "?final_date="+cDataFim+"&initial_date="+cDataIni
Local cParDown  := '{"filename": '
Local cRetHTTP  := ""
Local cRetList  := ""
Local cFileUrl  := ""
Local cFileTemp := ""
Local cErrParse := ""
Local cSavePath := "\nexxera\CIFINJ03\"
Local cSaveFile := "recebido\"
Local cPathFina := ""
Local aHeader   := {}
Local aFilesPth := {}
Local nX        := 0
Local nCriad    := 0
Local aTables   := {"SM0","SX2","FIF","MDE","FVR","FV3","FVZ","SX6","SX3"}
Local cFilCli   := ""
Local cEmpCli   := ""


Private oJSonFile := Nil
Private oJSonDown := Nil

If ValType(aParam) == "A"
    cFilCli := aParam[2]
    cEmpCli := aParam[1]
Else
    cFilCli := "000101"
    cEmpCli := "01"
Endif    

CONOUT("[CIFINJ03] - Periodo: " + cDataIni+ " - "+cDataFim)
CONOUT("[CIFINJ03] - cParList: " + cParList)
//CONOUT("[CIFINJ03] - aParam[1] - " + cValtoChar(aParam[1]) +' - aParam[2] - ' + cValtoChar(aParam[2]))

If IsBlind() .OR. Select("SM0") == 0
    RpcSetType( 3 ) 
    RpcSetEnv( cEmpCli, cFilCli, , , "FIN", "FINA914", aTables, , ,.T. ) 
EndIf

cAPIUrl   := "https://api.nexxera.com/skyline"
cAPIList  := "/api/v1/files" 
cAPIDown  := "/api/v1/requests/download" 
cTokNex   := "SU5URUxJR0VOVEVTLklOVEVMSUdFTlRFUzoxNjU4ZTY4ZC1kZTQzLTQ3NDQtYTlmNS04Y2IwYjMxMWQ2YWM="
cPathFina := Alltrim(GetAdvFVal('MDE', 'MDE_ARQIMP', xFilial("MDE") + "SOFTWARE EXPRESS", 2)) 

aAdd(aHeader,"service-token: "+cTokNex)
aAdd(aHeader,"Content-Type: application/json") 

// GET LISTA DE ARQUIVOS
cRetList := HTTPGet(cAPIUrl+cAPIList+cParList, , , aHeader, @cRetHTTP)

CONOUT("CIFINJ03 - cRetList '" + cRetList + "'")

If HTTPGetStatus(@cRetHTTP) == 200 // SUCESSO
    cRetHTTP  := ""
    oJSonFile := JsonObject():New()
    cErrParse := oJSonFile:FromJson(cRetList)
    If ValType(cErrParse) == "U" // SUCESSO
        For nX := 1 To Len(oJSonFile["result"])
            CONOUT("[CIFINJ03] - Processando Arquivo: '" +oJSonFile["result"][nX]["filename"])
            /*
            IF UPPER(SubStr(oJSonFile["result"][nX]["filename"],1,3)) == 'EXT'     .OR.;
               UPPER(SubStr(oJSonFile["result"][nX]["filename"],1,7)) == 'AVENCER' .OR.;
               UPPER(SubStr(oJSonFile["result"][nX]["filename"],1,5)) == 'INTRA'   .OR.;
               UPPER(SubStr(oJSonFile["result"][nX]["filename"],1,3)) == 'VAR'     .OR.;
               UPPER(SubStr(oJSonFile["result"][nX]["filename"],1,3)) == 'VEN' 
               LOOP
            ENDIF 
            */
            cRetHTTP  := ""
            cErrParse := ""
            // verifica se o arquivo est na caixa
            If oJSonFile["result"][nX]["in_mailbox"] == .F.
                CONOUT("CIFINJ03 - ATENCAO - ARQUIVO '" +oJSonFile["result"][nX]["filename"]+ "' NAO ESTA NA CAIXA POSTAL")
                Loop
            EndIf
            CONOUT("[CIFINJ03] - Arquivo: '" +oJSonFile["result"][nX]["filename"]+ "' ESTA NA CAIXA POSTAL")
            //RECEBE URL PARA BAIXAR OS ARQUIVOS
            cFileUrl := HTTPPost(cAPIUrl+cAPIDown,,cParDown+'"'+oJSonFile["result"][nX]["filename"]+'"}',,aHeader,@cRetHTTP)
            If HTTPGetStatus(@cRetHTTP) == 200 // SUCESSO
                oJSonDown := JsonObject():New()
                cErrParse := oJSonDown:FromJson(cFileUrl)
                If ValType(cErrParse) == "U" // SUCESSO    
                    cRetHTTP := ""                
                    //RECEBER ARQUIVO ATRAVES DA URL GERADA ANTERIORMENTE
                    cFileTemp := HTTPGet(oJSonDown["url"],,,,@cRetHTTP)
                    If HTTPGetStatus(@cRetHTTP) == 200 // SUCESSO
                        //ARMAZENA ARQUIVO RECEBIDO
                        ChkDirA01(cSavePath+cSaveFile)                        
                        If MemoWrite( cSavePath+cSaveFile+oJSonFile["result"][nX]["filename"], cFileTemp )
                            Aadd(aFilesPth, cSavePath+cSaveFile+oJSonFile["result"][nX]["filename"])
                        Else
                            CONOUT("[CIFINJ03] - ERRO NA GRAVACAO DO ARQUIVO NO LOCAL: " + cSavePath+cSaveFile+oJSonFile["result"][nX]["filename"])
                        EndIf
                    Else
                        CONOUT("[CIFINJ03] - ERRO NO RECEBIMENTO DA API DE DOWNLOAD DE ARQUIVO. ERRO: " + cRetHTTP )
                    EndIf
                Else
                    CONOUT("[CIFINJ03] - FALHA NA DESSERIALIZAO DO CONTEUDO JSON DE DOWNLOAD ! ERRO: " + cErrParse )
                EndIf                
            Else
                CONOUT("[CIFINJ03] - ERRO NO RECEBIMENTO DA API DE URL DE DOWNLOAD. ERRO: " + cRetHTTP )
            EndIf
        Next nX

    Else
        CONOUT("[CIFINJ03] - FALHA NA DESSERIALIZAO DO CONTEUDO JSON DE ARQUIVOS ! ERRO: " + cErrParse )
    EndIf
    
Else
    CONOUT("[CIFINJ03] - ERRO NO RECEBIMENTO DA API DE ARQUIVOS. ERRO: " + cRetHTTP )
EndIf

CONOUT("[CIFINJ03] - FIM DO SCHEDULE CIFINJ03 - ARQUIVOS BAIXADOS = " + cValToChar(Len(aFilesPth)))
CONOUT("[CIFINJ03] - FIM DO SCHEDULE CIFINJ03 - ARQUIVOS CRIADOS = " + cValToChar(nCriad))
CONOUT("[CIFINJ03] - CONSULTE OS RESULTADOS DO PROCESSO NA TABELA 'FVR' ")

MovPasta(aFilesPth)

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
        CONOUT("[CIFINJ03] - DIRETORIO '"+cPathChk+"\"+aPaths[nY]+"' CRIADO - ChkDirA01")
    EndIf
    cPathChk += "\"+aPaths[nY]
Next nY

Return

/*/{Protheus.doc} MovPasta
    Baixa de Contas a Pagar -> copiar os arquivos PAG*.* para 
        a pasta /Protheus_data/Nexxera/DOWNLOAD/BAIXA_PAGAR
    Baixa de Contas a Receber -> copiar os arquivos  
        relatorio_lpn_financeiro*.csv para a pasta 
        /Protheus_data/Nexxera/DOWNLOAD/BAIXA_CARTOES


    @type  Static Function
    @author user
    @since 11/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MovPasta(aArray)
    
    //Local cDirArq	:=  "\NEXXERA\CIFINJ03\RECEBIDO\"
	Local cDirdest	:=  "\Nexxera\DOWNLOAD\BAIXA_CARTOES\"
    Local cPathDest :=  "\Nexxera\DOWNLOAD\BAIXA_PAGAR\"
    Local nCont     :=  0
    Local aAux      :=  {}
    //Local aTables   := {"SM0","SX2","FIF","MDE","FVR","FV3","FVZ","SX6","SX3"}

    // RpcSetType( 3 ) 
    // RpcSetEnv( '01', '000101', , , "FIN", "FINA914", aTables, , ,.T. ) 

    // aArqui2 := Directory("\NEXXERA\CIFINJ03\RECEBIDO\*.*")

    If !ExistDir( cPathDest )
        MakeDir( cPathDest )
    EndIf

    If !ExistDir( cDirdest )
        MakeDir( cDirdest )
    EndIf

    For nCont := 1 to len(aArray)
        aAux := separa(aArray[nCont],"\")
        If substr(aAux[len(aAux)],1,3) == "PAG"
            If !__CopyFile(UPPER(aArray[nCont]), UPPER(cPathDest)+aAux[len(aAux)]) //copia o arquivo para o diretorio de backup
                ConOut( "[CIFINJ03] - Não foi possível copiar o arquivo " + aArray[nCont] + " para o diretório " + cDirDest)
            EndIf
        ElseIf ".CSV" $ upper(aAux[len(aAux)])
            If !__CopyFile(UPPER(aArray[nCont]), UPPER(cDirdest)+aAux[len(aAux)]) //copia o arquivo para o diretorio de backup
                ConOut( "[CIFINJ03] - Não foi possível copiar o arquivo " + aArray[nCont] + " para o diretório " + cDirDest)
            EndIf
        EndIf 
    Next nCont 

Return 

// Static Function Copia_Arq(cOpcao)
    

// 	Local cDirArq	:= "/NEXXERA/CIFINJ03/RECEBIDO/"
// 	Local cDirdest	:= "/NEXXERA/DOWNLOAD/PAGAMENTOS/"
// 	Local nA        := 0
//     Local cPathArq  := ""
//     Local cPathDest := ""
   
//     For nA := 1 to Len(aArq)
       
// 	    cArquivo := aArq[nA, 1]
     
//         IF SUBSTR(cArquivo,1,3) == 'PAG'

// 		    cPathArq  := cDirArq  + cArquivo
// 		    cPathDest := cDirDest + cArquivo

//             CONOUT("CPATHARQ: " + cPathArq)
//             CONOUT("CPATHDEST: " + cPathDest)
//             CONOUT("CARQUIVO: " + cArquivo)

// 		    If !_CopyFile(cPathArq, cPathDest) //copia o arquivo para o diretorio de backup
// 		        ConOut( "[CIFINJ03] - Não foi possível copiar o arquivo " + cPathArq + " para o diretório " + cDirDest)
// 		    EndIf
// 	    ENDIF
//     Next nA




//     //Inicia ambiente
// 	//If Select("SX2") == 0
// 	//		RpcClearEnv()
// 	//		//RpcSetEnv( cEmpJob, cFilJob )
// 	//		RpcSetEnv( "01" , "000101" )
// 	//EndIf

//     SM0->( DbGotop() )

// 	While !SM0->( Eof() )
//         If Deleted()
// 			SM0->( DbSkip() )
// 		EndIf
        
//         cFil := SM0->M0_CODFIL

//         CONOUT("cFil: " + cFil)
        
//         cQry := "SELECT EE_DIRPAG "
//         cQry += "FROM SEE010 WITH(NOLOCK)"
//         cQry += "WHERE EE_FILIAL = '" +cFil+ "'"
//         cQry += "AND EE_RETAUT IN ('2', '3') "  // 1.recebimento; 2.pagamento; 3.ambos
//         cQry += "AND EE_DIRPAG <> ' ' "         // Somente contas com diretório preenchido.
//         cQry += "AND D_E_L_E_T_ = ' ' "
        
// 		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),cAliasTrb,.T.,.F.)

// 		if !(cAliasTrb)->(Eof())
// 			cDirdest := ALLTRIM((cAliasTrb)->EE_DIRPAG)
//         ELSE
//             SM0->( DbSkip() )
//         Endif

//         (cAliasTrb)	->(dbCloseArea())

//         CONOUT("CDirdest: " + cFil + "Dir: " +cDirdest)
        
//         If !ExistDir( cDirdest )
// 		    MakeDir( cDirdest )
//         EndIf

//         aArq := Directory(cDirArq + "pag*.*")

//         CONOUT("aArq: "+cValToChar(aArq))

//         For nA := 1 to Len(aArq)
// 			cArquivo := aArq[nA, 1]
// 		    cPathArq  := cDirArq  + cArquivo
// 		    cPathDest := cDirDest + "\" + cArquivo

//             CONOUT("CPATHARQ: " + cPathArq)
//             CONOUT("CPATHDEST: " + cPathDest)
//             CONOUT("CARQUIVO: " + cArquivo)

// 		    If !_CopyFile(cPathArq, cPathDest) //copia o arquivo para o diretorio de backup
// 		    	ConOut( "[CIFINJ03] - Não foi possível copiar o arquivo " + cPathArq + " para o diretório " + cDirDest)
// 		    EndIf
// 		Next nA
//         SM0->( DbSkip() )
//     EndDo



// Return

