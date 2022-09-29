#include "protheus.ch"
#include "topconn.ch"
#include "fileio.ch"
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ROBRFT01ºAutora ³ Alexandre Venancio º Data ³  01/01/2022  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio notas emitidas para a contabilidade              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³  Uso     ³ Robsol                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

User Function ROBRFT01()

    Local lRet 	        := .F.

    Private _cUserID 	:= ''
    Private lTemExcel   := ApOleClient( "MsExcel" )
    Private nTotSql     := 0
    Private oDlg01
    Private oFont1
    Private _Filial1      := space(6)
    Private _Filial2      := space(6)
    Private _DtDe       := ctod(' / / ')
    Private _DtAt       := ctod(' / / ')
    Private _cGera      := Space(50)
    Private aDados	    :=	{}
    Private cArquivo    :=  'Notas_Emitidas_'+dtos(ddatabase)+strtran(time(),":")+'.xml'
    Private nHandleE	
    Private nCont	    :=	5
    Private aQuadri     := {} 
    
    If !ExistDir( "C:\Temp" )
        MakeDir( "C:\Temp" )
    EndIf

    nHandleE	:=  fcreate('C:\TEMP\'+cArquivo, FO_READWRITE + FO_SHARED )

    
Define msDialog oDlg01 From 00,00 To 220,370 Title "Notas Emitidas" Pixel &&145
Define Font oFont1 Name "Arial" Size 0,-12 Bold

@025,007 SAY "Filial De : " Font oFont1 of oDlg01 Pixel
@025,120 MSGET _Filial1  SIZE 60,9 OF oDlg01 Pixel 

@040,007 SAY "Filial Até : " Font oFont1 of oDlg01 Pixel
@040,120 MSGET _Filial2  SIZE 60,9 OF oDlg01 Pixel

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

    _cQuery := "SELECT TOP 5 F2_DOC,F2_EMISSAO,"
    _cQuery += " (SELECT DISTINCT F4_FINALID FROM SD2010 D2 INNER JOIN SF4010 F4 ON F4_FILIAL='01' AND F4_CODIGO=D2_TES AND F4.D_E_L_E_T_=' 'WHERE D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2.D_E_L_E_T_=' ') AS NATOPER,"
    _cQuery += "'' AS ES,A1_NOME,A1_CGC,A1_EST,F2_CHVNFE,F2_VALBRUT,F2_BASEICM,F2_VALIPI,F2_ICMSRET,F2_VALIMP5,F2_VALIMP6,F2_DESPESA,F2_FRETE,F2_DESCONT"
    _cQuery += " FROM "+RetSQLName("SF2")+" F2"
    _cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '"
    _cQuery += " WHERE F2_FILIAL='0101' AND F2_EMISSAO BETWEEN '_DtDe' AND '_DtAt'"
    _cQuery += " AND F2.D_E_L_E_T_=' '"

    DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRF2",.F.,.T.)
       
    DbSelectArea("TRF2")                      
    
    TRF2->(DbGotop()) 

    While !Eof()
        
            IncProc("Atualizando - RELATÓRIO DE NOTAS EMITIDAS ...")
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
    
    For nXE := 1 to len(aDados)
        
        If nXE == 1
                
            If len(_aVend) > 0 .Or. cVendedor <> aDados[nXE,17]
                cCab := RodE(cVendedor)
                FWrite(nHandleE,cCab+CRLF,100000)
                cVendedor := aDados[nXE,17]
            EndIf

            Aadd(_aVend,aDados[nXE,17])
            cCab := Planv(aDados[nXE,14],aDados[nXE,15],aDados[nXE,16],aDados[nXE,17])
            FWrite(nHandleE,cCab+CRLF,100000)
        EndIf

        

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

Local cRetorno:=""
Local cDtCr 

cDtCr   := dtos(ddatabase)
cDtCr   := substr(cDtCr,1,4)+"-"+substr(cDtCr,5,2)+"-"+substr(cDtCr,7,2)

cRetorno +='<?xml version="1.0"?>'+CRLF
cRetorno +='<?mso-application progid="Excel.Sheet"?>'+CRLF
cRetorno +='<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'
cRetorno +=' xmlns:o="urn:schemas-microsoft-com:office:office"'
cRetorno +=' xmlns:x="urn:schemas-microsoft-com:office:excel"'
cRetorno +=' xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"'
cRetorno +=' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'
cRetorno +=' xmlns:html="http://www.w3.org/TR/REC-html40">'+CRLF
cRetorno +=' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
cRetorno +='  <Author>Alexandre Venancio</Author>'+CRLF
cRetorno +='  <LastAuthor>Alexandre Venâncio</LastAuthor>'+CRLF
cRetorno +='  <Created>'+cDtCr+'T00:00:00Z</Created>'+CRLF
cRetorno +='  <LastSaved>'+cDtCr+'T00:00:00Z</LastSaved>'+CRLF
cRetorno +='  <Version>16.00</Version>'+CRLF
cRetorno +=' </DocumentProperties>'+CRLF
cRetorno +=' <CustomDocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
cRetorno +='  <DXVersion dt:dt="string">16.2.5.17068</DXVersion>'+CRLF
cRetorno +=' </CustomDocumentProperties>'+CRLF
cRetorno +=' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
cRetorno +='  <AllowPNG/>'+CRLF
cRetorno +=' </OfficeDocumentSettings>'+CRLF
cRetorno +=' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
cRetorno +='  <WindowHeight>8676</WindowHeight>'+CRLF
cRetorno +='  <WindowWidth>23040</WindowWidth>'+CRLF
cRetorno +='  <WindowTopX>32767</WindowTopX>'+CRLF
cRetorno +='  <WindowTopY>32767</WindowTopY>'+CRLF
cRetorno +='  <ProtectStructure>False</ProtectStructure>'+CRLF
cRetorno +='  <ProtectWindows>False</ProtectWindows>'+CRLF
cRetorno +=' </ExcelWorkbook>'+CRLF
cRetorno +=' <Styles>'+CRLF
cRetorno +='  <Style ss:ID="Default" ss:Name="Normal">'+CRLF
cRetorno +='   <Alignment ss:Vertical="Bottom"/>'+CRLF
cRetorno +='   <Borders/>'+CRLF
cRetorno +='   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
cRetorno +='   <Interior/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='   <Protection/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="m1994878628864">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Fixed"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="m1994878628884">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Fixed"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="m1994878628904">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Fixed"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="m1994878628716">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Fixed"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="m1994878628736">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Fixed"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s63">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Center" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Dash" ss:Weight="1"'
cRetorno +='     ss:Color="#C0C0C0"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="14" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s65">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:ReadingOrder="LeftToRight"'
cRetorno +='    ss:WrapText="1"/>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="12" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s68">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="12" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s70">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Color="#000000" ss:Bold="1" ss:Italic="1"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="@"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s71">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Center" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s72">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Center" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'
cRetorno +='    ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s73">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Center" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s74">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Left" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="00000000"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s75">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Left" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Short Date"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s76">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Left" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="@"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s77">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Left" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s78">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Left" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="&quot;dd/MM/yyyy&quot;"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s79">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Fixed"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s84">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Fixed"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s85">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Center" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="00000000"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s90">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Center" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s91">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Right" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Borders>'+CRLF
cRetorno +='    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'
cRetorno +='     ss:Color="#000000"/>'+CRLF
cRetorno +='   </Borders>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>'+CRLF
cRetorno +='   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CRLF
cRetorno +='   <NumberFormat ss:Format="Fixed"/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +='  <Style ss:ID="s99">'+CRLF
cRetorno +='   <Alignment ss:Horizontal="Center" ss:Vertical="Center"'
cRetorno +='    ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CRLF
cRetorno +='   <Font ss:FontName="Arial" ss:Size="8" ss:Color="#000000" ss:Italic="1"/>'+CRLF
cRetorno +='   <NumberFormat/>'+CRLF
cRetorno +='  </Style>'+CRLF
cRetorno +=' </Styles>'+CRLF

Return(cRetorno)

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
cQuery += " WHERE F2_FILIAL BETWEEN ' ' AND 'ZZZ' AND F2_Filial1='"+cVend+"'"
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


/*
//final cabeçalho


cRetorno +=' <Worksheet ss:Name="Sheet">'+CRLF
cRetorno +='  <Table ss:ExpandedColumnCount="18" ss:ExpandedRowCount="'+cvaltochar(nCont)+'" x:FullColumns="1"'
cRetorno +='   x:FullRows="1" ss:DefaultRowHeight="14.55">'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="50.4"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="54"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="75.600000000000009"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="21"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="195.60000000000002"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="72.599999999999994"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="67.2"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="64.8"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="77.399999999999991"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="52.8"/>'+CRLF
cRetorno +='   <Column ss:Width="49.8"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="15.600000000000001"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="34.199999999999996"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="47.4"/>'+CRLF
cRetorno +='   <Column ss:AutoFitWidth="0" ss:Width="57.6"/>'+CRLF
cRetorno +='   <Column ss:Width="40.200000000000003" ss:Span="1"/>'+CRLF
cRetorno +='   <Column ss:Index="18" ss:AutoFitWidth="0" ss:Width="41.4"/>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="6.75"/>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="33">'+CRLF
cRetorno +='    <Cell ss:MergeAcross="17" ss:StyleID="s63"><Data ss:Type="String">ROB SOL INDUSTRIA LTDA(CNPJ:23824405000140)</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="7.5"/>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="5.25"/>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="16.5">'+CRLF
cRetorno +='    <Cell ss:MergeAcross="4" ss:StyleID="s65"><Data ss:Type="String">Lista de Notas Fiscais Eletrônicas (Por orden de Número)</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s65"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s65"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s65"/>'+CRLF
cRetorno +='    <Cell ss:Index="13" ss:MergeAcross="5" ss:StyleID="s68"><Data ss:Type="String">Data Referência:03/01/2022  a  31/01/2022</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="0.75"/>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="16.5">'+CRLF
cRetorno +='    <Cell ss:Index="13" ss:MergeAcross="5" ss:StyleID="s70"><Data ss:Type="String">Data Emissão:10/02/2022 09:03:40</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="3"/>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="10.5">'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">Número</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">Data</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">Natoriza</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">E/S</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">Razão Social</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s72"><Data ss:Type="String">CNPJ</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s72"><Data ss:Type="String">QUANT</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s72"><Data ss:Type="String">ESTADO</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">Situação</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">V.Nota</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">B. ICMS</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">V.ICMS</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">V.IPI</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">V.ST</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">DESP.</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s71"><Data ss:Type="String">FRETE</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s73"><Data ss:Type="String">DESC.</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF
//final resumo

cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="10.5">'+CRLF
cRetorno +='    <Cell ss:StyleID="s74"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s75"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s77"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s78"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"/>'+CRLF
cRetorno +='    <Cell ss:MergeAcross="1" ss:StyleID="s79"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s84"/>'+CRLF
cRetorno +='   </Row>'+CRLF

cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="12.75">'+CRLF
cRetorno +='    <Cell ss:StyleID="s74"><Data ss:Type="Number">27874</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s75"><Data ss:Type="DateTime">2022-01-04T11:00:42.000</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"><Data ss:Type="String">VENDAS</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s77"><Data ss:Type="Number">1</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"><Data ss:Type="String">DINIZ ANDRADE COMERCIO OPTICO LTDA</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s78"><Data ss:Type="String">AUTORIZADA </Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">4774.17</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">4546.84</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeAcross="1" ss:StyleID="s79"><Data ss:Type="Number">182</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">227.33</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s84"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF



cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="12.75">'+CRLF
cRetorno +='    <Cell ss:StyleID="s74"><Data ss:Type="Number">27875</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s75"><Data ss:Type="DateTime">2022-01-04T11:06:04.000</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"><Data ss:Type="String">VENDAS</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s77"><Data ss:Type="Number">1</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"><Data ss:Type="String">INOVA COMERCIO OPTICO LTDA</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s78"><Data ss:Type="String">AUTORIZADA </Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">5740.74</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">5463.8</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeAcross="1" ss:StyleID="s79"><Data ss:Type="Number">983.69</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">276.94</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s84"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF

cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="12.75">'+CRLF
cRetorno +='    <Cell ss:StyleID="s74"><Data ss:Type="Number">27876</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s75"><Data ss:Type="DateTime">2022-01-04T11:12:51.000</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"><Data ss:Type="String">VENDAS</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s77"><Data ss:Type="Number">1</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"><Data ss:Type="String">LETICIA DINIZ COMERCIO DE ARTIGOS OPTICOS LTDA</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s76"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s78"><Data ss:Type="String">AUTORIZADA </Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">4774.17</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">4546.84</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeAcross="1" ss:StyleID="s79"><Data ss:Type="Number">182</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">227.33</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s79"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s84"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF



cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="12">'+CRLF
cRetorno +='    <Cell ss:MergeAcross="4" ss:StyleID="s85"><Data ss:Type="Number">1186</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s85"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s85"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s85"/>'+CRLF
cRetorno +='    <Cell ss:StyleID="s90"><Data ss:Type="String">TOTAL:</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeDown="1" ss:StyleID="m1994878628716"><Data ss:Type="Number">6052476.4540999997</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeDown="1" ss:StyleID="m1994878628736"><Data ss:Type="Number">4154484.2829900002</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeAcross="1" ss:StyleID="s91"><Data ss:Type="Number">386888.06</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeDown="1" ss:StyleID="m1994878628864"><Data ss:Type="Number">388875.58</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s91"><Data ss:Type="Number">1062.9344100000001</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeDown="1" ss:StyleID="m1994878628884"><Data ss:Type="Number">82081.350000000006</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:MergeDown="1" ss:StyleID="m1994878628904"><Data ss:Type="Number">12017.22</Data></Cell>'+CRLF
cRetorno +='    <Cell ss:StyleID="s91"><Data ss:Type="Number">0</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="11.25"/>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="3"/>'+CRLF
cRetorno +='   <Row ss:AutoFitHeight="0" ss:Height="16.5">'+CRLF
cRetorno +='    <Cell ss:MergeAcross="17" ss:StyleID="s99"><Data ss:Type="String">BW SERVICO DE INFORMÁTICA LTDA.   EV2014. REP. V1.0</Data></Cell>'+CRLF
cRetorno +='   </Row>'+CRLF
cRetorno +='  </Table>'+CRLF
cRetorno +='  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
cRetorno +='   <PageSetup>'+CRLF
cRetorno +='    <Header x:Margin="0.3"/>'+CRLF
cRetorno +='    <Footer x:Margin="0.3"/>'+CRLF
cRetorno +='    <PageMargins x:Bottom="0.228346452116966" x:Left="0.29133856296539301"'
cRetorno +='     x:Right="0.29921260476112399" x:Top="1.38976383209229"/>'+CRLF
cRetorno +='   </PageSetup>'+CRLF
cRetorno +='   <Unsynced/>'+CRLF
cRetorno +='   <NoSummaryRowsBelowDetail/>'+CRLF
cRetorno +='   <Print>'+CRLF
cRetorno +='    <ValidPrinterInfo/>'+CRLF
cRetorno +='    <PaperSizeIndex>77</PaperSizeIndex>'+CRLF
cRetorno +='    <HorizontalResolution>600</HorizontalResolution>'+CRLF
cRetorno +='    <VerticalResolution>600</VerticalResolution>'+CRLF
cRetorno +='   </Print>'+CRLF
cRetorno +='   <Selected/>'+CRLF
cRetorno +='   <DoNotDisplayGridlines/>'+CRLF
cRetorno +='   <Panes>'+CRLF
cRetorno +='    <Pane>'+CRLF
cRetorno +='     <Number>3</Number>'+CRLF
cRetorno +='     <ActiveRow>21</ActiveRow>'+CRLF
cRetorno +='     <ActiveCol>12</ActiveCol>'+CRLF
cRetorno +='    </Pane>'+CRLF
cRetorno +='   </Panes>'+CRLF
cRetorno +='   <ProtectObjects>False</ProtectObjects>'+CRLF
cRetorno +='   <ProtectScenarios>False</ProtectScenarios>'+CRLF
cRetorno +='  </WorksheetOptions>'+CRLF
cRetorno +=' </Worksheet>'+CRLF
cRetorno +='</Workbook>'+CRLF
*/
