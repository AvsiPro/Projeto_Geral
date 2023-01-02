#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function CONGEN02

Private aPerg        := {}
Private aLinha       := {}
Private cHandle      
Private nHandle
Private aAux         := {}
Private aItens       := {}
Private cItem        := ''
Private cPedidos      :=  ''
Private lMsErroAuto := .F.

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

Processa( { || gerar(),"Aguarde"})

Return 
/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 02/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerar(param_name)
    
nHandle := FT_FUSE(cHandle)

// Se houver erro de abertura abandona processamento
if nHandle = -1
    return
endif

FT_FGoTop()

// Retorna o número de linhas do arquivo
nLast := FT_FLastRec()

While !FT_FEOF()
    cLine := FT_FReadLn()
    
    aLinha  := Separa(cLine,';',.T.)
    If Alltrim(aLinha[1]) == 'CNPJ'
        Aadd(aAux,aLinha[2])
        Aadd(aAux,aLinha[4])
        Aadd(aAux,aLinha[6])

        cItem := "01"
    ElseIf Alltrim(aLinha[1]) == 'FIM'
        aCabec := {}
        DbSelectArea("SA1")
        DbSetOrder(3)
        DbSeek(xFilial("SA1")+aAux[1])

        aAdd( aCabec , { "C5_FILIAL"    , xFilial("SC5")      , Nil } ) 
        aAdd( aCabec , { "C5_XTPPED"    , 'F'                 , Nil } )
        aAdd( aCabec , { "C5_TIPO"      , 'N'                 , Nil } )
        aAdd( aCabec , { "C5_CLIENTE"   , SA1->A1_COD         , Nil } )
        aAdd( aCabec , { "C5_LOJACLI"   , SA1->A1_LOJA        , Nil } )
        Aadd( aCabec , { "C5_MENNOTA"   , aAux[3]             , Nil } )
        aAdd( aCabec , { "C5_CONDPAG"   , aAux[2]             , Nil } ) 

        lMsErroAuto := .F.
        MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItens,3)

        aCabec := {}
        aItens := {}
            
        IF lMsErroAuto  
            MostraErro()
        ELSE
            cPedidos += SC5->C5_NUM + CRLF 
        EndIf 
    Else 
        Aadd(aItens,{{"C6_ITEM",cItem,NIL},;
                    {"C6_PRODUTO",aLinha[1],NIL},;
                    {"C6_QTDVEN",val(aLinha[2]),NIL},;
                    {"C6_PRCVEN",val(strtran(aLinha[4],",",".")),NIL},;
                    {"C6_TES",aLinha[5],NIL}})

        cItem := soma1(cItem)
    EndIf 
    FT_FSKIP()

End

FT_FUSE()

MsgAlert("Pedidos Gerados "+CRLF+cPedidos, "CONGEN02")

Return
