#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCTBC01   บAutor  ณJackson E. de Deus บ Data ณ  19/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAlteracao de lancamentos contabeis                          บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ19/02/14ณ01.00 |Criacao                               ณฑฑ 
ฑฑณJackson	       ณ17/07/14ณ01.01 |Alteracao no LinOk da Grid            ณฑฑ 
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/


User Function TTCTBC01()

Local oDlg
Local cCadastro		:= "Lan็amento Contแbil"
Local aSize			:= {}
Local cPictVal		:= PesqPict("CT2","CT2_VALOR")
Local aTotais		:= {}
Local lOk			:= .F.
Private aRecnos		:= {}
Private aAlter		:= {"CT2_DC","CT2_DEBITO", "CT2_CREDIT", "CT2_VALOR", "CT2_HIST", "CT2_CCD", "CT2_CCC" }
Private dDataLanc	:= CT2->CT2_DATA	//dDataBase
Private cLote		:= CT2->CT2_LOTE	//CriaVar("CT2_LOTE")
Private cSubLote	:= CT2->CT2_SBLOTE	//CriaVar("CT2_SBLOTE")
Private cDoc		:= CT2->CT2_DOC		//CriaVar("CT2_DOC")
Private aHeader 	:= {}
Private aCols		:= {}
Private nTotDeb		:= 0
Private nTotCre		:= 0
Private aCampos 	:= { "CT2_LINHA", "CT2_DC", "CT2_DEBITO","CT2_DIACTB", "CT2_CREDIT", "CT2_VALOR", "CT2_HP", "CT2_HIST","CT2_CONVER","CT2_CCD",;
						"CT2_CCC", "CT2_ITEMD", "CT2_ITEMC", "CT2_CLVLDB", "CT2_CLVLCR", "CT2_ATIVDE", "CT2_ATIVCR", "CT2_TPSALD", "CT2_ORIGEM",;
						"CT2_VALR02","CT2_VALR03","CT2_VALR04","CT2_VALR05","CT2_DTTX02","CT2_DTTX03","CT2_DTTX04","CT2_DTTX05","CT2_CONFST",;
						"CT2_NODIA","CT2_USRCNF","CT2_DTCONF","CT2_HRCONF","CT2_CONTRO","CT2_CTLSLD","CT2_AT01DB","CT2_AT01CR","CT2_AT02DB",;
						"CT2_AT02CR","CT2_AT03DB","CT2_AT03CR","CT2_AT04DB","CT2_AT04CR","CT2_CLASLP" }

Private cCampos 	:= ""

LoadHeader()
             
aSize := MsAdvSize(,.F.,400)
	
DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
	
	oDlg:lMaximized := .T.

	oPanel1 := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,200,35,.T.,.T. )
	oPanel1:Align := CONTROL_ALIGN_TOP

	oPanel2 := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,200,40,.T.,.T. )
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT

	oPanel3 := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,200,60,.T.,.T. )
	oPanel3:Align := CONTROL_ALIGN_BOTTOM

	DEFINE FONT oFnt 	NAME "Arial" SIZE 0, -11 BOLD

	@ 12 ,5  	Say OemToAnsi("Data") SIZE 30,9 PIXEl OF oPanel1 FONT oFnt						//"Data"
	oData	:= TGet():New( 011,023,{|u| If(PCount()>0,dDataLanc:=u,dDataLanc) },oPanel1,045,010,"99/99/9999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)	
	oData:Disable()
					
	@ 12 ,83   	Say OemToAnsi("Lote") SIZE 30,9 PIXEl	OF oPanel1 FONT oFnt					//"Lote"
	oLote	:= TGet():New( 011,101,{|u| If(PCount()>0,cLote:=u,cLote) },oPanel1,032,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)	
	oLote:Disable()
					
  	@ 12 ,142  	Say OemToAnsi("Sub-Lote") SIZE 40,9 PIXEl	OF oPanel1 FONT oFnt				//"Sub-Lote"
	oSubLote	:= TGet():New( 011,172,{|u| If(PCount()>0,cSubLote:=u,cSubLote) },oPanel1,024,010,"!!!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)	
	oSubLote:Disable()
							
  	@ 12 ,212	Say OemToAnsi("Docto") SIZE 30,9 PIXEl	OF oPanel1	FONT oFnt					//"Docto"
	oDoc	:= TGet():New( 011,234,{|u| If(PCount()>0,cDoc:=u,cDoc) },oPanel1,034,010,"999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)	
	oDoc:Disable()
			
	oGetDB :=	MsNewGetDados():New(0,0,0,0,GD_INSERT+GD_UPDATE+GD_DELETE,"U_TTCTBC03()","U_TTCTBC04()","+CT2_LINHA",aAlter,0,99,'AllwaysTrue()','','AllwaysTrue()',oPanel2,aHeader,aCols,{ || /*TotalVl()*/ })
	oGetDB:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetDB:Disable()    
	
	MontaGrid()
	 
	@ 6  ,8   	SAY OemToAnsi("Descri็ใo da Entidade")	Of oPanel3 PIXEL 	FONT oFnt		//"Descrio da Entidade"
	oDescEnt	:= TSay():New(6,73,{ || ""}			,oPanel3,"",oDlg:oFont,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,150,008)
	//@ 6  ,73 	SAY oDescEnt PROMPT space(50) FONT oDlg:oFont PIXEL COLOR CLR_HBLUE	Of oPanel3
	
   	//@ 20 ,8  	SAY OemToAnsi("Total Informado") Of oPanel3 PIXEL	FONT oFnt				//"Total Informado :"
   	//@ 40 ,8  	SAY OemToAnsi("Total Digitado") Of oPanel3 PIXEL	FONT oFnt				//"Total Digitado  :"
   	//@ 21 ,65 	MSGET oInf 	VAR nTotInf 	Picture cPictVal Of oPanel3 READONLY SIZE 95 ,9 PIXEL
   	//@ 41 ,65 	MSGET oDig 	VAR aTotRdpe[1][1]	Picture cPictVal Of oPanel3 READONLY SIZE 95 ,9 PIXEL
   	@ 20 ,8 	SAY OemToAnsi("Total Debito") Of oPanel3 PIXEL	FONT oFnt				//"Total Debito  :"
   	@ 40 ,8		SAY OemToAnsi("Total Credito") Of oPanel3 PIXEL FONT oFnt				//"Total Credito :"
    oDeb		:= TGet():New( 021,065,{|u| If(PCount()>0,nTotDeb:=u,nTotDeb) },oPanel3,095,009,cPictVal,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)	
    oCred		:= TGet():New( 041,065,{|u| If(PCount()>0,nTotCre:=u,nTotCre) },oPanel3,095,009,cPictVal,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)	
	oDeb:Disable()
	oCred:Disable()

	TotalVl()	// calcula o valor de credito/debito
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{ || lOk := oGetDB:TudoOK(), IIF(lOk, Gravar(),) ,IIF(lOk, oDlg:End(),) },{ || oDlg:End() },,/*aButton*/)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTotalVl  บAutor  ณJackson E. de Deus   บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza os valores totais de debito/credito                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TotalVl()
    
Local nValCT2 := 0
Local nPosVl := AScan( aHeader, { |x| AllTrim(x[2]) == "CT2_VALOR" } ) 
Local nPosTp := AScan( aHeader, { |x| AllTrim(x[2]) == "CT2_DC" } ) 
Local nPosDel := Len(aHeader)+1

nTotDeb := 0
nTotCre := 0

For nI := 1 To Len(oGetDB:aCols)
	If oGetDB:aCols[nI][nPosDel]
		Loop
	EndIf

	nValCt2 := oGetDB:aCols[nI][nPosVL]
	ctipo := oGetDB:aCols[nI][nPostp]
	IF nValCt2 <> 0
		// verifica็ใo de debito e credito
		If ctipo == '3' .OR. ctipo == '1'
			nTotDeb += nValCt2		 		// Valor a Debito
		Endif
		If ctipo == '3' .OR. ctipo == '2'
			nTotCre += nValCt2				// Valor a Credito
		Endif
	Endif     
Next nI

If Type("oDeb") == "O" .And. Type("oCred") == "O"
	oDeb:Refresh()   
	oCred:Refresh()         
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadHeader บAutor ณJackson E. de Deus  บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o aHeader                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadHeader()

Local nI := 0

For nI := 1 To Len(aCampos)
	If nI <> Len(aCampos)
		cCampos += aCampos[nI] +"|"
	Else 
		cCampos += aCampos[nI]
	EndIf	
Next nI

DbSelectArea("SX3")
DbSetOrder(1)            
dbGoTop()
DbSeek("CT2")
While !EOF() .and. SX3->X3_ARQUIVO == "CT2"
   If /*X3Uso(SX3->X3_USADO) .and. */cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ cCampos
      AADD(aHeader,{Trim(X3Titulo()),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						"",;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT,;
						SX3->X3_CBOX })
   EndIf
   DbSkip()
End  


Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCamposGrid บAutor  ณJackson E. de Deus บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o aHeader e aCols                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaGrid()

Local cQuery := ""
Local aDados := {}  


aCols := {}
dbSelectArea("CT2")
dbSetOrder(1)
If !dbSeek( xFilial("CT2") +dtos(dDataLanc) +cLote +cSubLote +cDoc )
	Return
EndIf     

While !EOF() .And. CT2->CT2_DATA == dDataLanc .And. AllTrim(CT2->CT2_LOTE) == cLote .And. AllTrim(CT2->CT2_SBLOTE) == cSubLote .And. AllTrim(CT2->CT2_DOC) == cDoc                  
 	AAdd(aCols, Array(Len(aHeader)+1))
 	nLin := Len(aCols)
	For nI := 1 To Len(aHeader)
		If aHeader[nI][10] == "V"
			aCols[nLin][nI] := CriaVar(aHeader[nI][2],.T.)
		Else
			aCols[nLin][nI] := CT2->&(aHeader[nI][2]) 
		EndIf
	Next nI

	aCols[nLin][Len(aHeader)+1] := .F.		
	
	AAdd(aRecnos, Recno())
	
	dbSkip()
End

oGetDB:Acols := aClone(aCols)
oGetDB:Enable()
oGetDB:Refresh(.T.)
oGetDB:GoTop()	  

TotalVl()	

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCTBC02  บAutor  ณJackson E. de Deus  บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida os campos credito/debito.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCTBC02()

Local lRet := .T.
Local cLinha


If !IsInCallStack("U_TTCTBC01")
	Return lRet
EndIf

cLinha := oGetDB:acols[oGetDB:oBrowse:nAt][1]

dbSelectArea("CT2")	// lancamentos contabeis
dbSetOrder(1)
dbSeek( xFilial("CT2") +dtos(dDataLanc) +cLote +cSubLote +cDoc +cLinha)
		
If __readvar == "M->CT2_DEBITO"
	dbSelectArea("CT1")	// plano de contas
	dbSetOrder(1)
	If !dbSeek( xFilial("CT1") +AvKey(M->CT2_DEBITO,"CT1_CONTA") )
		Aviso("TTCTBC02","A conta informada nใo existe.",{"Ok"})
		lRet := .F.
	Else
		oDescEnt:SetText(CT1->CT1_DESC01)
		If dDataLanc >= CT1->CT1_DTBLIN .And. dDataLanc <= CT1->CT1_DTBLFI
			If AllTrim(CT2->CT2_DEBITO) <> AllTrim(M->CT2_DEBITO)                        
				Aviso("TTCTBC02","Nใo ้ permitida a altera็ใo de conta bloqueada.",{"Ok"})
				lRet := .F.
			EndIf
		EndIf
	EndIf		
ElseIf __readvar == "M->CT2_CREDIT"
	dbSelectArea("CT1")	// plano de contas
	dbSetOrder(1)
	If !dbSeek( xFilial("CT1") +AvKey(M->CT2_CREDIT,"CT1_CONTA") )
		Aviso("TTCTBC02","A conta informada nใo existe.",{"Ok"})
		lRet := .F.
	Else
		oDescEnt:SetText(CT1->CT1_DESC01)	
		If dDataLanc >= CT1->CT1_DTBLIN .And. dDataLanc <= CT1->CT1_DTBLFI
			If AllTrim(CT2->CT2_CREDIT) <> AllTrim(M->CT2_CREDIT)                        
				Aviso("TTCTBC02","Nใo ้ permitida a altera็ใo de conta bloqueada.",{"Ok"})
				lRet := .F.
			EndIf
		EndIf
	EndIf			
EndIf         

Return lRet    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar  บAutor  ณJackson E. de Deus    บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a gravacao das alteracoes.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar()

Local nRecno := 0
Local nLinha := 0
Local nCol := 0
Local nNrCampo := 0
Local nPos := 0


aCols := aClone(oGetDB:aCols)

dbSelectArea("CT2")
For nLinha := 1 To Len(aCols)
	// Alteracao  
	If nLinha <= Len(aRecnos)
		dbGoTo(aRecnos[nLinha])
		If RecLock("CT2",.F.)  
			// Exclusao
			If aCols[nLinha][Len(aHeader)+1]
				CT2->( dbDelete() )
				
			// Alteracao
			Else
				For nCol := 1 To Len(aHeader)
					nPos := 0
					nPos := aScan( aAlter, { |x|, AllTrim(x) == AllTrim(aHeader[nCol][2]) } )
					If nPos > 0
						nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
						FieldPut(nNrCampo, aCols[nLinha][nCol])
						//CT2->&(aHeader[nCol][2]) := aCols[nI][nCol]
					EndIf
				Next nCol
				If FindFunction("U_TTGENC01")
					U_TTGENC01(xFilial("CT2"),"TTCTBC01","LANC CONTAB - ALTERACAO","",cLote,"",cusername,dtos(date()),time(),,"ALTERADOS - RECNO "+CVALTOCHAR(nRecno),,,"CT2")	
				EndIf
			EndIf    
			CT2->( MsUnlock() )
		EndIf
		
	// Inclusao
	Else
		If RecLock("CT2",.T.)
			CT2->CT2_DATA := dDataLanc
			CT2->CT2_LOTE := cLote
			CT2->CT2_SBLOTE := cSubLote
			CT2->CT2_DOC := cDoc
			CT2->CT2_MOEDLC := "01"
			CT2->CT2_EMPORI := cEmpAnt
			CT2->CT2_FILORI := cFilAnt
			CT2->CT2_ROTINA := "TTCTBC01"
		  
			For nCol := 1 To Len(aHeader)
				nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
				FieldPut(nNrCampo, aCols[nLinha][nCol])
				//CT2->&(aHeader[nCol][2]) := aCols[nI][nCol]
			Next nCol
			If FindFunction("U_TTGENC01")
				U_TTGENC01(xFilial("CT2"),"TTCTBC01","LANC CONTAB - ALTERACAO","",cLote,"",cusername,dtos(date()),time(),,"INCLUIDO - RECNO "+CVALTOCHAR(RECNO()),,,"CT2")	
			EndIf
			CT2->( MsUnlock() )
		EndIf
	EndIf
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCTBC03  บAutor  ณJackson E. de Deus  บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLinhaOK() - Valida a linha da MsNewGetDados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCTBC03()
           
Local lRet := .T.
Local nLinha := oGetDB:oBrowse:nAt
Local nPosDel := Len(aHeader)+1
Local nPosCtDeb :=  aScan(aHeader, { |x| AllTrim(x[2]) == "CT2_DEBITO" } )
Local nPosCtCred := aScan(aHeader, { |x| AllTrim(x[2]) == "CT2_CREDIT" } )
Local nPosCCDeb := aScan(aHeader, { |x| AllTrim(x[2]) == "CT2_CCD" } )
Local nPosCCCred := aScan(aHeader, { |x| AllTrim(x[2]) == "CT2_CCC" } )      


If !oGetDB:aCols[nLinha][nPosDel]
	// Valida os centros de custo debito
	If !Empty(oGetDB:aCols[nLinha][nPosCtDeb]) .And. SubStr(oGetDB:aCols[nLinha][nPosCtDeb],1,1) $ "3|4|5"
		If Empty(oGetDB:aCols[nLinha][nPosCCDeb])
			dbSelectArea("CT1")	// plano de contas
			dbSetOrder(1)
			If dbSeek( xFilial("CT1") +AvKey(M->CT2_DEBITO,"CT1_CONTA") )
				If AllTrim(CT1->CT1_CCOBRG) == "1"
					Aviso("","O centro de custo de d้bito nใo foi informado.",{"Ok"})
					lRet := .F.
					Return lRet		
				EndIf
			EndIf
		EndIf
	EndIf
	// Valida os centros de custo credito
	If !Empty(oGetDB:aCols[nLinha][nPosCtCred]) .And. SubStr(oGetDB:aCols[nLinha][nPosCtCred],1,1) $ "3|4|5"
		If Empty(oGetDB:aCols[nLinha][nPosCCCred])
			dbSelectArea("CT1")	// plano de contas
			dbSetOrder(1)
			If dbSeek( xFilial("CT1") +AvKey(M->CT2_CREDIT,"CT1_CONTA") )
				If AllTrim(CT1->CT1_CCOBRG) == "1"
					Aviso("","O centro de custo de cr้dito nใo foi informado.",{"Ok"})
					lRet := .F.                                                       
					Return lRet		
				EndIf
			EndIf
		EndIf
	EndIf
	
	// Valida se a conta de credito eh igual a conta de debito
	If !Empty(oGetDB:aCols[nLinha][nPosCtDeb]) .And. !Empty(oGetDB:aCols[nLinha][nPosCtCred])
		If AllTrim(oGetDB:aCols[nLinha][nPosCtDeb]) == Alltrim(oGetDB:aCols[nLinha][nPosCtCred])
			Aviso("","A conta de cr้dito nใo pode ser igual a conta de d้bito.",{"Ok"})
			lRet := .F.
			Return lRet
		EndIf                                   
	EndIf
	
	TotalVL()
EndIf

Return lRet

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCTBC04  บAutor  ณJackson E. de Deus  บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTUDOOK() - Valida tudo da MsNewGetDados.		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
			  
User Function TTCTBC04()
           
Local lRet := .T.

If nTotDeb <> nToTCre
	ShowHelpDlg("TTCTBC04",{"O lan็amento / Documento Contแbil em questใo nใo estแ batido (D้bito e Cr้dito nใo batem). Este lan็amento nใo poderแ ser confirmado."},5,{"Verifique os valores lan็ados a D้bito e a Cr้dito."},5)
	lRet := .F.
EndIf

Return lRet	                                             