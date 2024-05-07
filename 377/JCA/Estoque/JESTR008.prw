#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*/

*********************************************************************************************************************
*********************************************************************************************************************
// Função: JESTR008() - Impressão da Etiqueta de prateleira e produto
*********************************************************************************************************************
*********************************************************************************************************************
/*/
USER Function JESTR008(cCodigo,cDescri,cMarca,cEnder,cLocImp,nQuant,cTipo,cCodF,cNF,cDtEnt,cUM)
    
    Local nPrint    := 1
    Default cCodigo := ''
    Default cDescri := ''
    Default cMarca  := ''
    Default cEnder  := ''
    Default cLocImp := 'ZEBRA'
    Default nQuant  := 1
    Default cTipo   := '2'
    Default cCodF   := ''
    Default cNF     := ''
    Default cDtEnt  := ''
    Default cUM     := ''

    If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01","00020087")
	EndIf

    CB5->(dbSetOrder(1))
    if !CB5->(DbSeek( xFilial("CB5") + padR(cLocImp, GetSX3Cache("CB5_CODIGO", "X3_TAMANHO")) )) .or. !CB5SetImp(cLocImp)
        msgalert("local de impressão não encontrado, Informe um local de impressão cadastrado., Acesse a rotina 'Locais de Impressão'.")
        return
    endif

    /*
        final para prateleira
    ^XA 
    ^FWR 
    ^FO260,80^A0,70,60^FD141200020001^FS 
    ^FO200,80^A0,60,60^FDCHICOTE ELETRICO ADAPTADOR P/FAROL  17206630^FS 
    ^FO110,95^A0,70,45^FDMARCA DO PRODUTO^FS 
    ^FO030,95^A0,70,45^FDENDERECO DO PRODUTO^FS 
    ^BY4,3,110
    ^FO070,690^BC^FD141200020001^FS
    ^XZ

    */
    
    If cTipo == '1'
        For nPrint := 1 to nQuant
            MSCBBEGIN(1,6,150) 

            MSCBWrite("^XA")					
            MSCBWrite("^FWR")
            MSCBWrite("^FO050,20^A0N,30,40^FD"+cCodigo+"^FS")
            MSCBWrite("^FO050,50^A0N,30,20^FD"+cDescri+"^FS")
            MSCBWrite("^FO050,080^A0N,30,20^FD"+cCodF+"^FS")
            MSCBWrite("^FO050,110^A0N,30,20^FD"+cEnder+"^FS")
            MSCBWrite("^FO050,140^A0N,30,20^FD"+cMarca+"^FS")
            MSCBWrite("^FO050,170^A0N,20,20^FD"+cNF+"^FS")
            MSCBWrite("^FO250,170^A0N,20,20^FD UM:"+cUM+"^FS")
            MSCBWrite("^FO050,190^A0N,20,20^FD Data: "+cvaltochar(cDtEnt)+"^FS")
            MSCBWrite("^BY1.4,1,045")
            MSCBWrite("^FO310,110^BCN^FD"+cCodigo+"^FS")
            MSCBWrite("^XZ")
        

            MSCBEND() 
        Next nPrint

        MSCBCLOSEPRINTER()
    Else 
            
        For nPrint := 1 to nQuant
            MSCBBEGIN(1,6,150) 

            MSCBWrite("^XA")					
            MSCBWrite("^FWR")
            MSCBWrite("^FO050,20^A0N,40,40^FD"+cCodigo+"^FS")
            MSCBWrite("^FO050,60^A0N,40,20^FD"+cDescri+"^FS")
            MSCBWrite("^FO050,100^A0N,40,20^FD"+cMarca+"^FS")
            MSCBWrite("^FO050,140^A0N,40,20^FD"+cEnder+"^FS")		
            MSCBWrite("^BY1.5,1,045")
            MSCBWrite("^FO270,115^BCN^FD"+cCodigo+"^FS")
            MSCBWrite("^XZ")
        

            MSCBEND() 
        Next nPrint

        MSCBCLOSEPRINTER()
    EndIf 

    
Return

