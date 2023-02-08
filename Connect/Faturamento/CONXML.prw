//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} ROBXML
Função que gera o arquivo xml da nota (normal ou cancelada) através do documento e da série disponibilizados
@author Alexandre Venancio
@since 25/11/2019
@version 1.0
@param cDocumento, characters, Código do documento (F2_DOC)
@param cSerie, characters, Série do documento (F2_SERIE)
@param cArqXML, characters, Caminho do arquivo que será gerado (por exemplo, C:\TOTVS\arquivo.xml)
@param lMostra, logical, Se será mostrado mensagens com os dados (erros ou a mensagem com o xml na tela)
@type function
@example Segue exemplo abaixo
    u_ROBXML("000000001", "1", "C:\TOTVS\arquivo1.xml", .F.) //Não mostra mensagem com o XML
     
    u_ROBXML("000000001", "1", "C:\TOTVS\arquivo2.xml", .T.) //Mostra mensagem com o XML
/*/
 
User Function CONXML(cDocumento, cSerie, cArqXML, lMostra)
    Local aArea        := GetArea()
    Local cURLTss      := PadR(GetNewPar("MV_SPEDURL","http://"),250)  
    Local oWebServ
    Local cIdEnt       := GetIdEnt()
    Local cTextoXML    := ""
    Default cDocumento := ""
    Default cSerie     := ""
    Default cArqXML    := GetTempPath()+"arquivo_"+cSerie+cDocumento+".xml"
    Default lMostra    := .F.
    conout(cfilant) 
    //Se tiver documento
    If !Empty(cDocumento)
        cDocumento := PadR(cDocumento, TamSX3('F2_DOC')[1])
        cSerie     := PadR(cSerie,     TamSX3('F2_SERIE')[1])
         
        //Instancia a conexão com o WebService do TSS    
        oWebServ:= WSNFeSBRA():New()
        oWebServ:cUSERTOKEN        := "TOTVS"
        oWebServ:cID_ENT           := cIdEnt
        oWebServ:oWSNFEID          := NFESBRA_NFES2():New()
        oWebServ:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
        aAdd(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
        aTail(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2):cID := (cSerie+cDocumento)
        oWebServ:nDIASPARAEXCLUSAO := 0
        oWebServ:_URL              := AllTrim(cURLTss)+"/NFeSBRA.apw"   
         
        //Se tiver notas
        If oWebServ:RetornaNotas()
         
            //Se tiver dados
            If Len(oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
             
                //Se tiver sido cancelada
                If oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA != Nil
                    cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
                     
                //Senão, pega o xml normal
                Else
                    cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
                EndIf
                 
                //Gera o arquivo
                MemoWrite(cArqXML, cTextoXML)
                 
                //Se for para mostrar, será mostrado um aviso com o conteúdo
                If lMostra
                    Aviso("ROBXML", cTextoXML, {"Ok"}, 3)
                EndIf
                 
            //Caso não encontre as notas, mostra mensagem
            Else
                ConOut("ROBXML > Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...")
                 
                If lMostra
                    Aviso("ROBXML", "Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...", {"Ok"}, 3)
                EndIf
            EndIf
         
        //Senão, houve erros na classe
        Else
            ConOut("ROBXML > "+IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3))+"...")
             
            If lMostra
                Aviso("ROBXML", IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"Ok"}, 3)
            EndIf
        EndIf
    EndIf
    RestArea(aArea)
Return


Static Function GetIdEnt(lUsaColab)

local cIdEnt := ""
local cError := ""

Default lUsaColab := .F.

If !lUsaColab

	cIdEnt := getCfgEntidade(@cError)

	if(empty(cIdEnt))
		Aviso("SPED", cError, {"ok"}, 3)

	endif

else
	if !( ColCheckUpd() )
		Aviso("SPED", "UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0",{"ok"},3)
	else
		cIdEnt := "000000"
	endif
endIf

Return(cIdEnt)
