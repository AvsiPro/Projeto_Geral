#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
#include "fileio.ch"

/*/{Protheus.doc} User Function CONAA3
    @type  Function
    @author user
    @since 28/12/2022
    @version 1 
    /*/
User Function CONGEN05()

    LOCAL aPerg        := {}
    LOCAL aLinha       := {}
    LOCAL aAux         := {}
    LOCAL cHandle      := ""
    LOCAL cLine        := ""
    LOCAL nRecno       := 0
    LOCAL nHandle      := 0
    Local nX           := 1
    Local nLast        := 0

    Private cCod       := ""
    Private nHandlel	:=	fcreate('C:\000\baixas2311.txt', FO_READWRITE + FO_SHARED )


    If Empty(FunName())
        RpcSetType(3)
        RPCSetEnv("01","0101")
    EndIf

    aAdd(aPerg,{6,"Buscar arquivo",Space(50),"","","",50,.T.,"Arquivos compativeis (*.csv*) |*.csv*"})

    If ParamBox(aPerg, "Informe o arquivo desejado!")
        cHandle  := MV_PAR01
    else
        MsgAlert("Operacao abortada!", "Erro!")
        RETURN
    ENDIF

    nHandle := FT_FUSE(cHandle)

    // Se houver erro de abertura abandona processamento
    if nHandle = -1
        return
    endif

    // Posiciona na primeria linha
    FT_FGoTop()

    // Retorna o número de linhas do arquivo
    nLast := FT_FLastRec()

    While !FT_FEOF()

        cLine := FT_FReadLn()

        aLinha  := Separa(cLine,';',.T.)

        if len(aLinha) > 1 .AND. nRecno > 0
            aLinha[10] := ctod(aLinha[10])
            aLinha[11] := ctod(aLinha[11])
            aLinha[13] := 0
            aLinha[14] := val(strtran(aLinha[14],",","."))
            Aadd(aAux, aLinha)    
        endif

        nRecno++
        // Pula para próxima linha
        FT_FSKIP()

    End

    // Fecha o Arquivo
    FT_FUSE()

    for nX := 1 to len(aAux)
        cRet := Baixase1(aAux[nX])
        FWrite(nHandlel,aAux[nX,01]+'-'+aAux[nX,02]+'-'+aAux[nX,03]+CRLF,10000)
        FWrite(nHandlel,cRet+CRLF,10000)
    next

    Fclose(nHandlel)

Return

/*/{Protheus.doc} Baixase1
    (long_description)
    @type  Static Function
    @author user
    @since 16/11/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Baixase1(aItem)

Local cMensagem := ''
/*
If cFilant <> aItem[1]
    cFilant := aItem[1]
    RpcClearEnv()
    RpcSetType(3)
    RPCSetEnv(cEmpAnt,cFilant)
EndIf
*/

DbSelectArea("SA6")
DbSetOrder(1)
DbSeek(xFilial("SA6")+aItem[7]+Avkey(aItem[8],"A6_AGENCIA")+Avkey(aItem[9],"A6_CONTA"))

DbSelectArea("SE1")
DbSetOrder(1)
Dbseek(xFilial("SE1")+Avkey(aItem[2],"E1_PREFIXO")+Avkey(aItem[3],"E1_NUM")+Avkey(aItem[4],"E1_PARCELA")+Avkey(aItem[5],"E1_TIPO"))

lMsErroAuto := .F.
aBaixa := {}

aBaixa := { {"E1_PREFIXO"  ,Avkey(aItem[2],"E1_PREFIXO")     ,Nil    },;
            {"E1_NUM"      ,aItem[3]		        ,Nil    },;
            {"E1_TIPO"     ,Avkey(aItem[5],"E1_TIPO")              ,Nil    },;
            {"E1_PARCELA"  ,Avkey(aItem[4],"E1_PARCELA")  ,Nil    },;
            {"AUTMOTBX"    ,"NOR"                   ,Nil    },;
            {"AUTBANCO"    ,aItem[7]              ,Nil    },;
            {"AUTAGENCIA"  ,Avkey(aItem[8],"A6_AGENCIA")              ,Nil    },;
            {"AUTCONTA"    ,Avkey(aItem[9],"A6_NUMCON")              ,Nil    },;
            {"AUTDTBAIXA"  ,aItem[10]             ,Nil    },;
            {"AUTDTCREDITO",aItem[11]             ,Nil    },;
            {"AUTHIST"     ,aItem[12]             ,Nil    },;
            {"AUTJUROS"    ,aItem[13]             ,Nil,.T.},;
            {"AUTDESCONT"  ,0                       ,Nil,.T.},;
            {"AUTVALREC"   ,aItem[14]             ,Nil    }}

MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)                  



If lMsErroAuto
    cMensagem := U_GetErro()
else
    cMensagem := "Baixa realizada com sucesso"
EndIf 
   
Return(cMensagem)

User Function GetErro()
Local cPath	:= GetSrvProfString("Startpath","")
Local cArq	:= "Erro_Rot_Auto_"+Dtos(dDataBase)+"_"+StrTran(Time(),":","_")+Alltrim(Str(ThreadID()))+".txt"
Local cRet	:= ""

MostraErro( cPath , cArq )
cRet := StrTran(MemoRead(  cPath + '\' + cArq ),Chr(13) + Chr(10)," ")
cRet := StrTran(cRet, '"', "'")
fErase(cArq)
Return cRet
