#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"

/*/{Protheus.doc} TINCGEN01
Rotina generica de conferencias do incorporador.
@type 
@author user
@since 04/10/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function TINCGEN01(cFilInc)

Local oExcel     := FwMsExcelXlsx():New()
Local cDir 		 := ""
Local aHeader    := {}
Local nX,nY 
Local cCabecalho := 'Consistencia'
Local nCont 
Local aContratos := {}
Local aProdutos  := {}
Local aItens     := {}
Local nItem 
Local nSubItm   
Local aHeader    := {} 

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("00","00001000100")
EndIf

cArqXls 	 := "Consistencia_"+dtos(ddatabase)+strtran(time(),":")+".xlsx" 


cArqAux := cGetFile( '*.txt|*.txt',; //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         'C:\',;                            //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)   
                                                           //[ lArvore] 
oFile := FwFileReader():New(cArqAux)

If (oFile:Open())
    aAux := oFile:GetAllLines()
    DbSelectArea("SA1")
    DbSetOrder(3)
    For nCont := 1 to len(aAux)
        Dbseek(xFilial("SA1")+aAux[nCont])
        Aadd(aContratos,{aAux[nCont],'CON'+SA1->A1_COD})
    Next nCont 

EndIf 

For nCont := 1 to len(aContratos)
    cQuery := "SELECT / *PARALLEL(16)* / JSON_VALUE(P98_BODY, '$.fields.CNB_PRODUT') AS PRODUTO,"  
    cQuery += " JSON_VALUE(P98_BODY, '$.fields.CNB_QUANT') AS QUANT,"
    cQuery += " JSON_VALUE(P98_BODY, '$.fields.CNB_VLUNIT') AS VALOR" 
    cQuery += " FROM "+RetSQLName("P98")                                                              
    cQuery += " WHERE P98_FILIAL='"+xFilial("P98")+"'"             
    cQuery += " and P98_TABELA='CNB' and JSON_VALUE(P98_BODY, '$.fields.CNB_CONTRA') IN('"+aContratos[nCont,01]+"') "
    
    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    aProdutos := {}
    While !EOF()
        Aadd(aProdutos,{Alltrim(TRB->PRODUTO),val(TRB->QUANT),val(TRB->VALOR),'P98'})
        DbSkip()
    EndDo 

    Asort(aProdutos,,,{|x,y| x[1] < y[1]})

    For nItem := 1 to len(aProdutos)
        Aadd(aContratos[nCont],aProdutos[nItem])
    Next nItem

Next nCont 


For nCont := 1 to len(aContratos)
    aItens := {}
    For nItem := 3 to len(aContratos[nCont])
        cQuery := "SELECT / *PARALLEL(16)* / CNB_PRODUT, CNB_QUANT, CNB_VLUNIT,CNB_ITEM"
        cQuery += " FROM   "+RetSQLName("CNB")+" CNB , "+RetSQLName("CN9")+" CN9" 
        cQuery += " WHERE  CNB_FILIAL=' ' AND "
        cQuery += "     CN9_FILIAL = ' '"
        cQuery += "     and CNB_PRODUT = '"+aContratos[nCont,nItem,1]+"'"           
        cQuery += "     AND CNB.D_E_L_E_T_ = ' '"
        cQuery += "             AND CN9_NUMERO = CNB_CONTRA"         
        cQuery += "             AND CN9_REVISA = CNB.CNB_REVISA"
        cQuery += "             AND CN9_REVATU = ' '"              
        cQuery += "             AND CN9_ESPCTR = '2'"         
        cQuery += "             AND CN9.D_E_L_E_T_ = ' '"
        cQuery += " AND CNB_CONTRA IN (SELECT 'CON'||A1_COD FROM "+RetSQLName("SA1")+" WHERE A1_FILIAL=' ' AND A1_CGC IN('"+aContratos[nCont,01]+"'))"
        cQuery += " AND CNB_UNINEG='00202001000'"          
        cQuery += " ORDER BY CNB_CONTRA,CNB_ITEM"

        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        EndIf

        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        DbSelectArea("TRB")
        
        
        While !EOF()
            
            If TRB->CNB_QUANT == aContratos[nCont,nItem,2] .and. TRB->CNB_VLUNIT == aContratos[nCont,nItem,3]
                Aadd(aContratos[nCont,nItem],Alltrim(TRB->CNB_PRODUT))
                Aadd(aContratos[nCont,nItem],TRB->CNB_QUANT)
                Aadd(aContratos[nCont,nItem],TRB->CNB_VLUNIT)
                Aadd(aContratos[nCont,nItem],'CNB')
                Aadd(aContratos[nCont,nItem],Alltrim(TRB->CNB_ITEM))
            EndIf 
            DbSkip()
        EndDo 

        
        
    Next nItem 

Next nCont 

aHeader := {'CNPJ',;
            'Contrato',;
            'P98',;
            '',;
            'Produto',;
            'Quantidade',;
            'Valor',;
            'CNB',;
            '',;
            'Produto',;
            'Quantidade',;
            'Valor'}

cCabeca := 'Conferencia'
cSheet  := 'Contratos'

oExcel:AddworkSheet(cCabeca) 
oExcel:AddTable (cCabeca,cSheet)

For nY := 1 to len(aHeader)
    oExcel:AddColumn(cCabeca,cSheet,aHeader[nY],1,1)
Next nY

cContrato := ""
For nCont := 1 to len(aContratos)
    aAux := {}
    If aContratos[nCont,01] <> cContrato 
        cContrato := aContratos[nCont,01] 
        Aadd(aAux,aContratos[nCont,01])
        Aadd(aAux,aContratos[nCont,02])
        Aadd(aAux,"")
        Aadd(aAux,"")
    Else 
        Aadd(aAux,"")
        Aadd(aAux,"")
        Aadd(aAux,"")
        Aadd(aAux,"")
    EndIf 
    
    aAux2 := {}
    aAux3 := {}

    For nY := 3 to len(aContratos[nCont])
        aAux2 := {}
        nPosP := 0

        If aContratos[nCont,nY,4] == "CNB"
            nPosP := Ascan(aAux3,{|x| x[1]+x[4] == aContratos[nCont,nY,01]+"P98" }) 
        EndIf 

        For nX := 1 to len(aContratos[nCont,nY])
            Aadd(aAux2,aContratos[nCont,nY,nX])
        Next nX 
        
        If nPosP > 0
            For nX := 1 to len(aAux2)
                Aadd(aAux3[nPosP],aAux2[nX])
            Next nX 
        Else 
            Aadd(aAux3,aAux2)
        EndIf 

    Next nY

    For nY := 1 to len(aAux3)
        If len(aAux) < 1
            Aadd(aAux,"")
            Aadd(aAux,"")
            Aadd(aAux,"")
            Aadd(aAux,"")
        EndIf 

        Aadd(aAux,aAux3[nY,01])
        Aadd(aAux,aAux3[nY,02])
        Aadd(aAux,aAux3[nY,03])
        Aadd(aAux,"")
        Aadd(aAux,"")

        If len(aAux3[nY]) > 4
            Aadd(aAux,aAux3[nY,05])
            Aadd(aAux,aAux3[nY,06])
            Aadd(aAux,aAux3[nY,07])
        Else    
            Aadd(aAux,"")
            Aadd(aAux,"")
            Aadd(aAux,"")
        EndIf 

        If len(aAux) == 12
            oExcel:AddRow(cCabeca,cSheet,aAux)
            aAux := {}
        Else 
            For nX := len(aAux)+1 to 12   
                Aadd(aAux,"")
            Next nX 

            oExcel:AddRow(cCabeca,cSheet,aAux)
            aAux := {}
        EndIf

    Next nY 
    
    

Next nCont 


//cDir := cGetFile( , OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
cDir := 'c:\temp'
oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If !ApOleClient( 'MsExcel' )
    MsgAlert("Excel não instalado, procure o arquivo na pasta selecionada")
Else
    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
    oExcelApp:SetVisible(.T.)        
    oExcelApp:Destroy()
Endif

Return

User Function TINCGEN2(cParam)

Local lOk  := .T.
Local cRet := ''
Local cCodigo := ''
Default cParam := ''

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("00","00001000100")
EndIf

If ValType(cParEmp) == "C"
	cCodigo := cParam
endIf 

//u_tj11int('TFDUK1',@lOk,@cRet)
u_tj11int(cCodigo,@lOk,@cRet)

RETURN
