#INCLUDE 'PROTHEUS.CH'
#include "tbiconn.ch"
#include "fileio.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 20/07/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function JUBDA1()



If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0801")
EndIf

Processa({|| gerar()},"Aguarde")

Return 
/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @ty
    @author user
    @since 04/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerar()

Local aAux   := {}
Local nCont  := 0
Local nX     := 0

cArqAux := cGetFile( 'Arquivo *.csv',; //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         'C:\',;                            //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)   
                                                           //[ lArvore] 
FT_FUSE(cArqAux)

FT_FGOTOP()

While !FT_FEOF()
		
	cLinha := FT_FREADLN()
	AADD(aAux,Separa(cLinha,";",.T.))
    
	FT_FSKIP()

EndDo 

nPosTab := Ascan(aAux[1],{|x| Alltrim(x) == "DA1_CODTAB"})
nPospro := Ascan(aAux[1],{|x| Alltrim(x) == "DA1_CODPRO"})
nPositm := Ascan(aAux[1],{|x| Alltrim(x) == "DA1_ITEM"})

FT_FUSE()

DbSelectArea("DA1")
DbSetOrder(2)

For nCont := 2 to len(aAux)
    
    If !Dbseek(xFilial("DA1")+Avkey(aAux[nCont,nPospro],"DA1_CODPRO")+Avkey(aAux[nCont,nPosTab],"DA1_CODTAB")+Avkey(aAux[nCont,nPositm],"DA1_ITEM"))
        Reclock("DA1",.T.)
    Else
        Reclock("DA1",.F.)
    EndIf 

    DA1->DA1_FILIAL := xFilial("DA1")

    For nX := 1 to len(aAux[nCont])

        lNumer := Alltrim(aAux[1,nX]) $ 'DA1_PRCVEN/DA1_XPRCV2/DA1_XPRCV3/DA1_XQTRG1/DA1_XQTRG2/DA1_XQTRG3/DA1_MOEDA/DA1_QTDLOT'
        &("DA1->"+aAux[1,nX]) := If(lNumer,val(aAux[nCont,nX]),aAux[nCont,nX])
      
    Next nX 
    
    DA1->(Msunlock())

Next nCont

Return
