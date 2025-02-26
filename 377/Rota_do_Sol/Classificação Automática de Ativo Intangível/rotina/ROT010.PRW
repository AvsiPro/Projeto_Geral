#INCLUDE 'PROTHEUS.CH'
/*

    Rotina para importação do arquivo de curva do ativo fixo.
    01/11/24
    Grupo 377

*/
User function ROT010

Local cArquivo := ''
Local cConta   := space(2)
Local aParam   := {}
Local nCont 
Local aLinhas  := {}
Local aFNI     := {}
Local nX 

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","010101")
EndIf

aAdd( aParam ,{1,"Indice"             ,cConta     ,""                 ,"","FNI"   ,"", 60,.T.})
aAdd( aParam ,{9,"Informe o caminho do Arquivo",200, 40,.T.})      
aAdd( aParam ,{6,"Aponte o arquivo:",Space(100),"","","",70,.T.,"Todos os arquivos (*.*) |*.*"})     
     
If ParamBox(aParam,"Informe o código do índice",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
    cConta      := MV_PAR01
    cArquivo    := MV_PAR03

    If Empty(cArquivo)
        MsgAlert("Arquivo não informado")
        Return 
    EndIf 

    DbSelectArea("FNI")
    DbSetOrder(1)
    DbSeek(xFilial("FNI")+cConta)
    Aadd(aFNI,{FNI->FNI_CODIND,FNI->FNI_REVIS,FNI->FNI_STATUS,FNI->FNI_MSBLQL})
ENDIF 

oFile := FWFileReader():New(cArquivo)

If !oFile:Open()
   MsgStop( "Problema em abrir o arquivo: " + cArquivo, 'Universo do Desenvolvedor' )
Endif

aFileLines := oFile:getAllLines()

For nCont := 1 to len(aFileLines)
    Aadd(aLinhas,separa(aFileLines[nCont],";"))
Next nCont 

Aeval(aLinhas,{|x| x[1] := ctod(x[1])})
Aeval(aLinhas,{|x| x[2] := ctod(x[2])})
AEVAL(aLinhas,{|x| x[3] := val(strtran(X[3],",","."))})
AEVAL(aLinhas,{|x| x[4] := val(strtran(strtran(X[4],"%"),",","."))})

//Aeval(aLinhas,{|x| x[1] := firstday(x[2])})

DbSelectArea("FNT")
DbSetOrder(1)

For nCont := 1 to len(aFNI)
    For nX := 2 to len(aLinhas) 
        If Dbseek(xFilial("FNT")+aFNI[nCont,01]+aFNI[nCont,02]+dtos(aLinhas[nX,01]))
            Reclock("FNT",.F.)  
            FNT->FNT_STATUS := '1'
        Else 
            Reclock("FNT",.T.)
            FNT->FNT_CODIND := aFNI[nCont,01]
            FNT->FNT_REVIS  := aFNI[nCont,02]
            FNT->FNT_STATUS := aFNI[nCont,03]
            FNT->FNT_MSBLQL := aFNI[nCont,04]
        EndIf 

        FNT->FNT_DATA   := aLinhas[nX,01]
        FNT->FNT_DTVLDF := aLinhas[nX,02]
        FNT->FNT_TAXA   := aLinhas[nX,03]
        FNT->FNT_CURVA  := aLinhas[nX,04]

        FNT->(Msunlock())
    Next nX 
Next nCont 

cFullRead := oFile:FullRead()

oFile:Close()

MsgAlert("Processo finalizado")

Return 
