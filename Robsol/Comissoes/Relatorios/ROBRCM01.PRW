#include "protheus.ch"
#include "topconn.ch"
#include "fileio.ch"
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ROBRCM01ºAutora ³ Alexandre Venancio º Data ³  01/01/2022  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio analitico de comissões por vendedor              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³  Uso     ³ Robsol                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

User Function ROBRCM01()

    Local lRet 	        := .F.

    Private _cUserID 	:= ''
    Private lTemExcel   := ApOleClient( "MsExcel" )
    Private nTotSql     := 0
    Private oDlg01
    Private oFont1
    Private _Vend1      := space(6)
    Private _Vend2      := space(6)
    Private _DtDe       := ctod(' / / ')
    Private _DtAt       := ctod(' / / ')
    Private _cGera      := Space(50)
    Private aDados	    :=	{}
    Private cArquivo    :=  'Comissao_'+dtos(ddatabase)+strtran(time(),":")+'.xml'
    Private nHandleE	:=  fcreate('C:\TEMP\'+cArquivo, FO_READWRITE + FO_SHARED )
    Private nCont	    :=	5
    Private aQuadri     := {} 
    
    Aadd(aQuadri,{1,'1'}) 
    Aadd(aQuadri,{2,'1'}) 
    Aadd(aQuadri,{3,'1'}) 
    Aadd(aQuadri,{4,'1'}) 
    Aadd(aQuadri,{5,'2'}) 
    Aadd(aQuadri,{6,'2'}) 
    Aadd(aQuadri,{7,'2'}) 
    Aadd(aQuadri,{8,'2'}) 
    Aadd(aQuadri,{9,'3'}) 
    Aadd(aQuadri,{10,'3'}) 
    Aadd(aQuadri,{11,'3'}) 
    Aadd(aQuadri,{12,'3'}) 


//@010,010 Say "Este programa ira gerar relatório " Font oFont1 of oDlg01 Pixel
//@020,010 Say "massa de dados relativas a tabela SF2" Font oFont1 of oDlg01 Pixel

Define msDialog oDlg01 From 00,00 To 220,370 Title "Comissões" Pixel &&145
Define Font oFont1 Name "Arial" Size 0,-12 Bold

@025,007 SAY "Vendedor De : " Font oFont1 of oDlg01 Pixel
@025,120 MSGET _Vend1  SIZE 60,9 OF oDlg01 Pixel 

@040,007 SAY "Vendedor Até : " Font oFont1 of oDlg01 Pixel
@040,120 MSGET _Vend2  SIZE 60,9 OF oDlg01 Pixel

@055,007 SAY "Data De : " Font oFont1 of oDlg01 Pixel
@055,120 MSGET _DtDe  SIZE 60,9 OF oDlg01 Pixel 

@070,007 SAY "Data Até : " Font oFont1 of oDlg01 Pixel
@070,120 MSGET _DtAt  SIZE 60,9 OF oDlg01 Pixel

@090,115 BmpButton Type 1 Action(lRet := .T.,Close(oDlg01))
@090,150 BmpButton Type 2 Action(lRet := .F.,Close(oDlg01))

Activate Dialog oDlg01 Centered


If lRet
	begin Transaction

		Processa({||  fProcFat()},"Processando ...")

	End transaction
	
Endif
   

MsgInfo("Finalizou")

Return(lRet)
 
/*
/////
*/
Static Function fProcFat()  

    Local nJE,nXE
    Local aSomaP := {}
    Local _aVend := {}
    Local cVendedor := ''

    _cQuery := "SELECT Z40_PEDIDO AS IDCUPOM,A1_NOME AS RAZAO_SOCIAL,Z40_VLRPED AS VALOR_PEDIDO,"
    _cQuery += "Z40_PRCCOM AS PERCENTUAL,Z40_VLRCOM AS COMISSAO,Z40_DTPEDI AS DATA_PEDIDO,"
    _cQuery += "Z03_DESGRI AS MARCA,Z40_DTFATU AS DATA_STATUS,Z40_QTDITM AS QUANTIDADE,"
    _cQuery += "A1_NREDUZ AS FANTASIA,Z40_DESCON AS DESCONTO,E4_DESCRI AS PAGAMENTO,"
    _cQuery += "Z40_NOTA AS NOTA_FISCAL,A3_NREDUZ AS FANTVEND,A3_NOME AS NOMEVEND,A3_CGC AS DOCTOV,Z40_VENDED"
    _cQuery += " FROM " + RetSqlName("Z40") + " AS Z40"
    _cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 ON A1_FILIAL=Z40_FILIAL AND A1_COD=Z40_CLIENT AND A1_LOJA=Z40_LOJA AND A1.D_E_L_E_T_=' '"
    _cQuery += " INNER JOIN " + RetSqlName("Z03") + " Z03 ON Z03_FILIAL=Z40_FILIAL AND Z03_CODGRI=Z40_MARCA AND Z03.D_E_L_E_T_=' '"
    _cQuery += " INNER JOIN " + RetSqlName("SE4") + " E4 ON E4_FILIAL='"+xFilial("SE4")+"' AND E4_CODIGO=Z40_CONDPG AND E4.D_E_L_E_T_=' '"
    _cQuery += " INNER JOIN " + RetSQLName("SA3") + " A3 ON A3_FILIAL=Z40_FILIAL AND A3_COD=Z40_VENDED AND A3.D_E_L_E_T_=' '"
    _cQuery += " WHERE Z40.D_E_L_E_T_=' '"
    _cQuery += " AND Z40_VENDED BETWEEN '"+_Vend1+"' AND '"+_Vend2+"'"
    _cQuery += " AND Z40_DTPEDI BETWEEN '"+DTOS(_DtDe)+"' AND '"+DTOS(_DtAt)+"'"
    _cQuery += " ORDER BY Z40_VENDED,Z40_PRCCOM DESC,Z40_PEDIDO"

    DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRF2",.F.,.T.)
       
    DbSelectArea("TRF2")                      
    
    TRF2->(DbGotop()) 

    While !Eof()
        
            IncProc("Atualizando - RELATÓRIO DE COMISSOES ...")
            Aadd(aDados,{   Alltrim(TRF2->IDCUPOM),;
                            Alltrim(TRF2->RAZAO_SOCIAL),;
                            TRF2->VALOR_PEDIDO,;
                            cvaltochar(TRF2->PERCENTUAL),;
                            TRF2->COMISSAO,;
                            cvaltochar(stod(TRF2->DATA_PEDIDO)),;
                            Alltrim(TRF2->MARCA),;
                            cvaltochar(stod(TRF2->DATA_STATUS)),;
                            TRF2->QUANTIDADE,;
                            Alltrim(TRF2->FANTASIA),;
                            Transform(TRF2->DESCONTO,"@E 999,999.99"),;
                            Alltrim(TRF2->PAGAMENTO),;
                            TRF2->NOTA_FISCAL,;
                            Alltrim(TRF2->FANTVEND),;
                            Alltrim(TRF2->NOMEVEND),;
                            TRF2->DOCTOV,;
                            TRF2->Z40_VENDED})

            nCont++
            DbSelectArea("TRF2")
            TRF2->(DbSkip())

    Enddo
    
    dbCloseArea()
    
    cCab		:= cabE()
    
    FWrite(nHandleE,cCab+CRLF,100000)
    
    If len(aDados) > 0
        cVendedor := aDados[1,17]
    EndIf

    For nXE := 1 to len(aDados)
        
        If Ascan(_aVend,{|x| x == aDados[nXE,17]}) == 0
                
            If len(_aVend) > 0 .Or. cVendedor <> aDados[nXE,17]
                cCab := RodE(cVendedor)
                FWrite(nHandleE,cCab+CRLF,100000)
                cVendedor := aDados[nXE,17]
            EndIf

            Aadd(_aVend,aDados[nXE,17])
            cCab := Planv(aDados[nXE,14],aDados[nXE,15],aDados[nXE,16],aDados[nXE,17])
            FWrite(nHandleE,cCab+CRLF,100000)
        EndIf

        If Ascan(aSomaP,{|x| x == aDados[nXE,17]+cvaltochar(aDados[nXE,04])}) == 0
            Aadd(aSomaP,aDados[nXE,17]+cvaltochar(aDados[nXE,04]))
            cCab		:= mudperc()
            FWrite(nHandleE,cCab+CRLF,100000)
        ENDIF

        FWrite(nHandleE,'   <Row>'+CRLF,1000)

        For nJE := 1 to len(aDados[nXE])-4
            If valtype(aDados[nXE,nJE]) == "D"
                FWrite(nHandleE,'    <Cell ss:StyleID="s62"><Data ss:Type="DateTime">';
                +Substr(cvaltochar(aDados[nXE,nJE]),7,4)+"-"+Substr(cvaltochar(aDados[nXE,nJE]),4,2)+"-"+Substr(cvaltochar(aDados[nXE,nJE]),1,2);
                +'T00:00:00.000</Data></Cell>'+CRLF,100000)
            ElseIf valtype(aDados[nXE,nJE]) == "N"
                FWrite(nHandleE,'    <Cell><Data ss:Type="String">'+(cvaltochar(Transform(aDados[nXE,nJE],"@E 999,999,999.99")))+'</Data></Cell>'+CRLF,100000)
            Else
                FWrite(nHandleE,'    <Cell><Data ss:Type="String">'+(cvaltochar(aDados[nXE,nJE]))+'</Data></Cell>'+CRLF,100000)
            EndIf
        Next nJE

        FWrite(nHandleE,'   </Row>'+CRLF,1000)
        
    Next nXE
    
    cRodE	:= RodE(cVendedor)
    FWrite(nHandleE,cRodE+CRLF,100000)
    
    cRodE := '</Workbook>'+CRLF

    FWrite(nHandleE,cRodE+CRLF,100000)
    Fclose(nHandleE)

    shellExecute( "Open", "c:\temp\"+cArquivo, " /k dir", "C:\", 1)


	
Return(NIL)


/*-------------------------------------------------------------------
|																	|
|		Cabeçalho   												|
|																	|
-----------------------------------------------------------------*/

Static Function cabE()

Local cCabec:=""

cDtCr   := dtos(ddatabase)
cDtCr   := substr(cDtCr,1,4)+"-"+substr(cDtCr,5,2)+"-"+substr(cDtCr,7,2)

cCabec	:=	'<?xml version="1.0"?>'+CRLF
cCabec	+=	'<?mso-application progid="Excel.Sheet"?>'+CRLF
cCabec	+=	'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF
cCabec	+=	' xmlns:o="urn:schemas-microsoft-com:office:office"'+CRLF
cCabec	+=	' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CRLF
cCabec	+=	' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF
cCabec	+=	' xmlns:html="http://www.w3.org/TR/REC-html40">'+CRLF
cCabec	+=	' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
cCabec	+=	'  <Author>Protheus</Author>'+CRLF
cCabec	+=	'  <LastAuthor>Protheus</LastAuthor>'+CRLF
cCabec	+=	'  <Created>'+cDtCr+'T00:00:00Z</Created>'+CRLF
cCabec	+=	'  <LastSaved>'+cDtCr+'T00:00:00Z</LastSaved>'+CRLF
cCabec	+=	'  <Version>16.00</Version>'+CRLF
cCabec	+=	' </DocumentProperties>'+CRLF
cCabec	+=	' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
cCabec	+=	'  <AllowPNG/>'+CRLF
cCabec	+=	' </OfficeDocumentSettings>'+CRLF
cCabec	+=	' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
cCabec	+=	'  <WindowHeight>12456</WindowHeight>'+CRLF
cCabec	+=	'  <WindowWidth>23256</WindowWidth>'+CRLF
cCabec	+=	'  <WindowTopX>32767</WindowTopX>'+CRLF
cCabec	+=	'  <WindowTopY>32767</WindowTopY>'+CRLF
cCabec	+=	'  <ProtectStructure>False</ProtectStructure>'+CRLF
cCabec	+=	'  <ProtectWindows>False</ProtectWindows>'+CRLF
cCabec	+=	' </ExcelWorkbook>'+CRLF
cCabec	+=	' <Styles>'+CRLF
cCabec	+=	'  <Style ss:ID="Default" ss:Name="Normal">'+CRLF
cCabec	+=	'   <Alignment ss:Vertical="Bottom"/>'+CRLF
cCabec	+=	'   <Borders/>'+CRLF
cCabec	+=	'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
cCabec	+=	'   <Interior/>'+CRLF
cCabec	+=	'   <NumberFormat/>'+CRLF
cCabec	+=	'   <Protection/>'+CRLF
cCabec	+=	'  </Style>'+CRLF
cCabec	+=	'  <Style ss:ID="s16">'+CRLF
cCabec	+=	'   <NumberFormat ss:Format="#,##0"/>'+CRLF
cCabec	+=	'  </Style>'+CRLF
cCabec	+=	'  <Style ss:ID="s17">'+CRLF
cCabec	+=	'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>'+CRLF
cCabec	+=	'   <Interior ss:Color="#305496" ss:Pattern="Solid"/>'+CRLF
cCabec	+=	'  </Style>'+CRLF
cCabec	+=	'  <Style ss:ID="s19">'+CRLF
cCabec	+=	'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CRLF
cCabec	+=	'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF" ss:Bold="1"/>'+CRLF
cCabec	+=	'   <Interior ss:Color="#305496" ss:Pattern="Solid"/>'+CRLF
cCabec	+=	'  </Style>'+CRLF
cCabec	+=	' </Styles>'+CRLF

Return(cCabec)

/*/{Protheus.doc} Planv
    (long_description)
    @type  Static Function
    @author user
    @since 11/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Planv(cNome,cFanta,cCGC,cVend)

Local cCabec := ""

If len(cCGC) > 11
    cCGC := Transform(cCGC,"@R 99.999.999/9999-99")
else
    cCGC := Transform(cCGC,"@R 999.999.999-99")
ENDIF

cCabec	+=	' <Worksheet ss:Name="'+cVend+'">'+CRLF
cCabec	+=	'  <Table ss:ExpandedColumnCount="16" ss:ExpandedRowCount="'+cvaltochar(nCont+30)+'" x:FullColumns="1"'+CRLF
cCabec	+=	'   x:FullRows="1" ss:DefaultRowHeight="14.4">'+CRLF
cCabec	+=	'   <Column ss:Width="78"/>'+CRLF
cCabec	+=	'   <Column ss:Width="69.599999999999994"/>'+CRLF
cCabec	+=	'   <Column ss:AutoFitWidth="0" ss:Width="41.4" ss:Span="1"/>'+CRLF
cCabec	+=	'   <Column ss:Index="5" ss:Width="79.800000000000011"/>'+CRLF
cCabec	+=	'   <Row>'+CRLF
cCabec	+=	'    <Cell><Data ss:Type="String">'+cFanta+'</Data></Cell>'+CRLF
cCabec	+=	'   </Row>'+CRLF
cCabec	+=	'   <Row>'+CRLF
cCabec	+=	'    <Cell><Data ss:Type="String">'+cNome+'</Data></Cell>'+CRLF
cCabec	+=	'   </Row>'+CRLF
cCabec	+=	'   <Row>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s16"><Data ss:Type="String">'+cCGC+'</Data></Cell>'+CRLF
cCabec	+=	'   </Row>'+CRLF

Return(cCabec)

/*/{Protheus.doc} mudperc
    (long_description)
    @type  Static Function
    @author user
    @since 10/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function mudperc()

Local cCabec := ""

cCabec	+=	'   <Row>' + CRLF 
cCabec	+=	'   </Row>'+CRLF

cCabec	+=	'   <Row>' + CRLF 
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">IdCupom</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Razao Social</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Valor do Pedido</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Porcentagem</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Valor da Comissao</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Data do Pedido</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Marca</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Data de Status</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Quantidade</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Fantasia</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Desconto</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Pagamento</Data></Cell>'+CRLF
cCabec	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">Nro. NF</Data></Cell>'+CRLF
cCabec	+=	'   </Row>'+CRLF

Return(cCabec)

/*-----------------------------------------------------------------------------------
|
|
|
------------------------------------------------------------------------------------*/
Static Function RodE(cVendedor)

Local cRodape := ""
Local nCont   := 0
Local nCnt2   := 0
Local nSomEnt := 0
Local nSomNEt := 0
Local nSomTot := 0
Local nSomCom := 0
Local nQuadC  := Ascan(aQuadri,{|x| x[1] == month(_DtDe)})
Local aMetas  := BuscaMet(cVendedor,aQuadri[nQuadC,02])

AEval(aDados,{|x| nSomTot += If(x[17] == cVendedor,x[3],0)})
AEval(aDados,{|x| nSomCom += If(x[17] == cVendedor,x[5],0)})
AEval(aDados,{|x| nSomEnt += If(val(x[4]) == 10 .And. x[17] == cVendedor,x[3],0)})
AEval(aDados,{|x| nSomNEt += If(val(x[4]) <> 10 .And. x[17] == cVendedor,x[3],0)})

cRodape	:=	'    <Row>'+CRLF
cRodape	+=	'   </Row>'+CRLF
cRodape	+=	'    <Row>'+CRLF
cRodape	+=	'   </Row>'+CRLF

cRodape	+=	'    <Row>'+CRLF
cRodape	+=	'    <Cell ss:Index="4" ss:StyleID="s19"><Data ss:Type="String">VENDAS</Data></Cell>'+CRLF
cRodape	+=	'    <Cell ss:StyleID="s19"><Data ss:Type="String">COMISSAO</Data></Cell>'+CRLF
cRodape	+=	'   </Row>'+CRLF

cRodape	+=	'   <Row>'+CRLF
cRodape	+=	'    <Cell ss:Index="4"><Data ss:Type="String">'+Transform(nSomTot,"@E 999,999,999.99")+' Total</Data></Cell>'+CRLF
cRodape	+=	'    <Cell><Data ss:Type="String">'+Transform(nSomCom,"@E 999,999,999.99")+' Comissao Total</Data></Cell>'+CRLF
cRodape	+=	'   </Row>'+CRLF

cRodape	+=	'   <Row>'+CRLF
cRodape	+=	'    <Cell ss:Index="4"><Data ss:Type="String">'+Transform(nSomEnt,"@E 999,999,999.99")+' Entram para bonus</Data></Cell>'+CRLF
cRodape	+=	'    <Cell><Data ss:Type="String"></Data></Cell>'+CRLF
cRodape	+=	'   </Row>'+CRLF

cRodape	+=	'   <Row>'+CRLF
cRodape	+=	'    <Cell ss:Index="4"><Data ss:Type="String">'+Transform(nSomNEt,"@E 999,999,999.99")+' Nao entram para bonus</Data></Cell>'+CRLF
cRodape	+=	'    <Cell><Data ss:Type="String"></Data></Cell>'+CRLF
cRodape	+=	'   </Row>'+CRLF

cRodape	+=	'    <Row>'+CRLF
cRodape	+=	'   </Row>'+CRLF

cRodape	+=	'   <Row>'+CRLF
cRodape	+=	'    <Cell ss:Index="3" ss:MergeAcross="3" ss:StyleID="s19"><Data ss:Type="String">Meta '+cvaltochar(aQuadri[nQuadC,2])+' quadrimestre de '+cvaltochar(year(_DtDe))+'</Data></Cell>'+CRLF
cRodape	+=	'   </Row>'+CRLF
cRodape	+=	'   <Row>'+CRLF
cRodape	+=	'    <Cell ss:Index="3" ss:StyleID="s17"><Data ss:Type="String">Mes</Data></Cell>'+CRLF
cRodape	+=	'    <Cell ss:StyleID="s17"><Data ss:Type="String">Metas</Data></Cell>'+CRLF
cRodape	+=	'    <Cell ss:MergeAcross="1" ss:StyleID="s17"><Data ss:Type="String">Pedidos que entram no Bonus</Data></Cell>'+CRLF
cRodape	+=	'   </Row>'+CRLF

If len(aMetas) > 0
    For nCont := 1 to len(aMetas)
        For nCnt2 := 1 to len(aMetas[nCont])-1 step 2
            cPer1 := substr(aMetas[nCont,nCnt2],3)+substr(aMetas[nCont,nCnt2],1,2)+'01'
            cPer2 := dtos(lastday(stod(substr(aMetas[nCont,nCnt2],3)+substr(aMetas[nCont,nCnt2],1,2)+'01')))
            nVendas := BuscVend(cPer1,cPer2,cVendedor)
            cRodape	+=	'   <Row>'+CRLF
            cRodape	+=	'    <Cell ss:Index="3"><Data ss:Type="String">'+mesextenso(ctod('01/'+substr(aMetas[nCont,nCnt2],1,2)+'/'+substr(aMetas[nCont,nCnt2],3)))+'</Data></Cell>'+CRLF
            cRodape	+=	'    <Cell><Data ss:Type="String">'+Transform(aMetas[nCont,nCnt2+1],"@E 999,999.99")+'</Data></Cell>'+CRLF
            cRodape	+=	'    <Cell><Data ss:Type="String">'+Transform(nVendas,"@E 999,999,999.99")+'</Data></Cell>'+CRLF
            cRodape	+=	'    <Cell><Data ss:Type="String">'+Transform((nVendas/aMetas[nCont,nCnt2+1])*100,"@R 999.99%")+'</Data></Cell>'+CRLF
            cRodape	+=	'   </Row>'+CRLF
        Next nCnt2
    Next nCont
Else
    cRodape	+=	'   <Row>'+CRLF
    cRodape	+=	'    <Cell ss:Index="3"><Data ss:Type="String">Meta nao cadastrada para o periodo</Data></Cell>'+CRLF
    cRodape	+=	'    <Cell><Data ss:Type="Number">0</Data></Cell>'+CRLF
    cRodape	+=	'    <Cell><Data ss:Type="Number">0</Data></Cell>'+CRLF
    cRodape	+=	'   </Row>'+CRLF
EndIf
cRodape	+=	'  </Table>'+CRLF
cRodape	+=	'  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
cRodape	+=	'   <PageSetup>'+CRLF
cRodape	+=	'    <Header x:Margin="0.31496062000000002"/>'+CRLF
cRodape	+=	'    <Footer x:Margin="0.31496062000000002"/>'+CRLF
cRodape	+=	'    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CRLF
cRodape	+=	'     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CRLF
cRodape	+=	'   </PageSetup>'+CRLF
cRodape	+=	'   <Selected/>'+CRLF
cRodape	+=	'   <Panes>'+CRLF
cRodape	+=	'    <Pane>'+CRLF
cRodape	+=	'     <Number>3</Number>'+CRLF
cRodape	+=	'     <ActiveRow>16</ActiveRow>'+CRLF
cRodape	+=	'     <ActiveCol>2</ActiveCol>'+CRLF
cRodape	+=	'    </Pane>'+CRLF
cRodape	+=	'   </Panes>'+CRLF
cRodape	+=	'   <ProtectObjects>False</ProtectObjects>'+CRLF
cRodape	+=	'   <ProtectScenarios>False</ProtectScenarios>'+CRLF
cRodape	+=	'  </WorksheetOptions>'+CRLF
cRodape	+=	' </Worksheet>'+CRLF

Return(cRodape)

/*/{Protheus.doc} BuscaMet(cVendedor,aQuadri[nQuadC,02])
    (long_description)
    @type  Static Function
    @author user
    @since 11/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaMet(cVend,quadr)

Local aArea := GetArea()
Local aAux  := {}
Local cQuery 

cQuery := "SELECT Z31_MSAN01,Z31_VLMS01,Z31_MSAN02,Z31_VLMS02,Z31_MSAN03,Z31_VLMS03,Z31_MSAN04,Z31_VLMS04,Z31_CODVEN"
cQuery += " FROM "+RetSQLName("Z31")
cQuery += " WHERE Z31_CODVEN='"+cVend+"' AND Z31_QUADRI='"+quadr+"' AND D_E_L_E_T_=' '"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !Eof()
    nposic := Ascan(aAux,{|x| x[9] == TRB->Z31_CODVEN}) 
    If nposic == 0
        Aadd(aAux,{ TRB->Z31_MSAN01,TRB->Z31_VLMS01,TRB->Z31_MSAN02,TRB->Z31_VLMS02,;
                    TRB->Z31_MSAN03,TRB->Z31_VLMS03,TRB->Z31_MSAN04,TRB->Z31_VLMS04,;
                    TRB->Z31_CODVEN})
    else
        aAux[nposic,02] += TRB->Z31_VLMS01
        aAux[nposic,04] += TRB->Z31_VLMS02
        aAux[nposic,06] += TRB->Z31_VLMS03
        aAux[nposic,08] += TRB->Z31_VLMS04
    EndIf
    Dbskip()
ENDDO

RestArea(aArea)

Return(aAux)

/*/{Protheus.doc} BuscVend(cPer1,cPer2)escription)
    @type  Static Function
    @author user
    @since 11/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscVend(cPer1,cPer2,cVend)

Local aArea := GetArea()
Local nRet  := 0
Local cQuery 

cQuery := "SELECT CAST( MONTH(F2_EMISSAO) AS VARCHAR ) AS MES,SUM(F2_VALMERC) AS VALOR"
cQuery += " FROM "+RetSQLName("SF2")+" F2"
cQuery += " WHERE F2_FILIAL BETWEEN ' ' AND 'ZZZ' AND F2_VEND1='"+cVend+"'"
cQuery += " AND F2_EMISSAO BETWEEN '"+cPer1+"' AND '"+cPer2+"'"
cQuery += " GROUP BY CAST( MONTH(F2_EMISSAO) AS VARCHAR )"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

nRet := TRB->VALOR

RestArea(aArea)

Return(nRet)
