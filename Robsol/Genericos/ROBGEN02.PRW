#include "protheus.ch"
 
#define C_GRUPO  "01"
#define C_FILIAL "0101"
 
//-------------------------------------------------------------------
/*{Protheus.doc} imgReposit
Exemplo de utilização da classe FWBmpRep, classe responsável pela
manipulação do repositório de imagens
 
@author Alexandre Venancio
@since 20/01/2022
@version 1.0
*/
//-------------------------------------------------------------------
user function ROBGEN02()

local oImgRepo as object
local lInluiu as logical
local cEntry as char
 
RpcSetEnv(C_GRUPO, C_FILIAL)
 
oImgRepo := FWBmpRep():New()
 
if oImgRepo:OpenRepository()
    lInluiu := .F.
 
    ConOut("Quantidade de registros: ", oImgRepo:RecordCount())
 
    if oImgRepo:ExistBmp("BCD")
        oImgRepo:DeleteBmp("BCD")
    endif
 
    cEntry := oImgRepo:InsertBmp("c:\tmp\001 c3.bmp" ,/*cEntry*/, @lInluiu)
 
    if lInluiu
        DBSELECTAREA("SB1")
        DBSETORDER(1)
        IF DBSEEK(XFILIAL("SB1")+'001 C3')
            Reclock("SB1",.F.)
            SB1->B1_BITMAP := '001 C3'
            SB1->(Msunlock())
        EndIf
        
        FErase("xisto.jpg")
        ConOut("Imagem " + cEntry + " inclusa")
 
        if oImgRepo:Extract(cEntry, "xisto.jpg")
            ConOut("Imagem " + cEntry + " recuperada")
        else
            ConErr("Erro ao recuperar a imagem " + cEntry)
        endif
    else
        ConErr("Erro ao incluir a imagem xisto.jpg")
    endif
 
    oImgRepo:CloseRepository()
endif
 
FreeObj(oImgRepo)
 
RpcClearEnv()
 
return
