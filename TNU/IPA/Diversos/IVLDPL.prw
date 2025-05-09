#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"

/*/{Protheus.doc} IVLDPL
Validar planilha com tabelas
@type user function
@author user
@since 08/05/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function IVLDPL()

Local cArqAux
Local nCont 
Local aAux   := {}
Local aCabec := {}
Local aItens := {}
Local aTitulos := {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","010102")
EndIf


cArqAux := cGetFile( '*.csv|*.csv',; //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         'C:\',;                            //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)   
                                                           //[ lArvore] 
oFile := FwFileReader():New(cArqAux)

If (oFile:Open())
    nHandlel := fcreate('C:\temp\Log_'+substr(cArqAux,-24)+'.txt', FO_READWRITE + FO_SHARED )

    aAux := oFile:GetAllLines()
    aCabec := separa(aAux[1],";")
    nPos1 := Ascan(aCabec,{|x| x == "E1_CLIENTE"})
    nPos2 := Ascan(aCabec,{|x| x == "E1_LOJA"})
    nPos3 := Ascan(aCabec,{|x| x == "E1_NUM"})
    nPos4 := Ascan(aCabec,{|x| x == "E1_PARCELA"})

    DbSelectArea("SA1")
    DbSetOrder(1)
    For nCont := 2 to len(aAux)
        
        aItens := separa(aAux[nCont],";")
        

        If !Dbseek(xFilial("SA1")+Avkey(aItens[nPos1],"A1_COD")+Avkey(aItens[nPos2],"A1_LOJA"))
            FWrite(nHandlel,'Linha '+cvaltochar(nCont)+' Cliente não encontrado '+aItens[nPos1]+' - '+aItens[nPos2] +CRLF,10000)
        EndIf 

    Next nCont 

    For nCont := 2 to len(aAux)
        aItens := separa(aAux[nCont],";")
        
        nPos5 := Ascan(aTitulos,{|x| x[nPos3]+x[nPos4]+x[nPos1] == aItens[nPos3]+aItens[nPos4]+aItens[nPos1]})
        If nPos5 > 0
            FWrite(nHandlel,'Titulo duplicado (Linhas '+cvaltochar(nPos5)+' e '+cvaltochar(nCont)+CRLF,10000)
        Else 
            Aadd(aTitulos,aItens)
        EndIf 
    Next nCont

EndIf 

Return
