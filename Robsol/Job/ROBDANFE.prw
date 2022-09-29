//Bibliotecas
#Include "Protheus.ch"
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#include "fileio.ch"

 
/*/{Protheus.doc} zGerDanfe
Função que gera a danfe e o xml de uma nota em uma pasta passada por parâmetro
@author Alexandre
@since 25/11/2019
@version 1.0
@param cNota, characters, Nota que será buscada
@param cSerie, characters, Série da Nota
@param cPasta, characters, Pasta que terá o XML e o PDF salvos
@type function
@example u_zGerDanfe("000123ABC", "1", "C:\TOTVS\NF",'email@destino.com.br')
/*/
User Function ROBDANFE(cNota, cSerie, cPasta, ccnpj)
    Local aArea     := GetArea()
    Local cIdent    := ""
    Local cArquivo  := ""
    Local oDanfe    := Nil
    Local lEnd      := .F.
    Local nTamNota  := TamSX3('F2_DOC')[1]
    Local nTamSerie := TamSX3('F2_SERIE')[1]
    Private PixelX
    Private PixelY
    Private nConsNeg
    Private nConsTex
    Private oRetNF
    Private nColAux
    Default cNota   := ""
    Default cSerie  := ""
    Default cPasta  := GetTempPath()
     
    //Se existir nota
    If ! Empty(cNota)
        //Pega o IDENT da empresa
        cIdent := RetIdEnti()
         
        //Se o último caracter da pasta não for barra, será barra para integridade
        If SubStr(cPasta, Len(cPasta), 1) != "\"
            cPasta := cPasta+"\"+ccnpj+"\"
            If !ExistDir(cPasta)
            	Makedir(cPasta)
            EndIf
        Else
        	cPasta := cPasta+ccnpj+"\"
            If !ExistDir(cPasta)
            	Makedir(cPasta)
            EndIf
        EndIf

        cArquivo := cNota 
            
        If !File(cPasta+cArquivo+".xml") 
            //Gera o XML da Nota
            //cArquivo := cNota + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
            u_ROBXML(cNota, cSerie, cPasta + cArquivo  + ".xml", .F.)
        EndIf 

        If !File(cPasta+cArquivo+".pdf") 
            //Define as perguntas da DANFE
            Pergunte("NFSIGW",.F.)
            MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
            MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
            MV_PAR03 := PadR(cSerie, nTamSerie)    //Série da Nota
            MV_PAR04 := 2                          //NF de Saida
            MV_PAR05 := 1                          //Frente e Verso = Sim
            MV_PAR06 := 2                          //DANFE simplificado = Nao
            
            //Cria a Danfe cPasta
            //oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "C:\Temp\", .T.)
            //CONOUT(CPASTA)
            /*cPatSer := '\clientes\cnpj\'+ccnpj
            If !ExistDir(cPatSer)
            	Makedir(cPatSer)
            EndIf*/
            //oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., cPatSer, .T.)
            oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., cPasta, .T.)
            
            //Propriedades da DANFE
            oDanfe:SetResolution(78)
            oDanfe:SetPortrait()
            oDanfe:SetPaperSize(DMPAPER_A4)
            oDanfe:SetMargin(60, 60, 60, 60)
            
            //Força a impressão em PDF
            oDanfe:nDevice  := 6
            oDanfe:cPathPDF := cPasta //"C:\Temp\" 
            oDanfe:lServer  := .F.
            oDanfe:lViewPDF := .F.
            
            //Variáveis obrigatórias da DANFE (pode colocar outras abaixo)
            PixelX    := oDanfe:nLogPixelX()
            PixelY    := oDanfe:nLogPixelY()
            nConsNeg  := 0.4
            nConsTex  := 0.5
            oRetNF    := Nil
            nColAux   := 0
            
            //Chamando a impressão da danfe no RDMAKE
            //RptStatus({|lEnd| StaticCall(DANFEII, DanfeProc, @oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
            u_DanfeProc(@oDanfe, @lEnd, cIdent, , , .F.) //}, "Imprimindo Danfe...")
            oDanfe:Print()
            aArquivos := {}
            //Necessário enviar a copia para o servidor, caso o arquivo seja gerado localmente
            //CPYT2S("C:\temp\"+cArquivo+".pdf",cPasta)
            
            //WinExec("copy c:\totvs\protheus_data\"+cPatSer+"\*.* c:\inetpub\wwwroot\50308\ /y")
            //aAuxFile := Directory(cPasta+'*.*',"D")
        EndIf
		
		
		
    EndIf
     
    RestArea(aArea)
    
Return(cArquivo)


