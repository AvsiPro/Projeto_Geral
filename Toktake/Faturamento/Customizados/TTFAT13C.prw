#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'  
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณTTFAT13C  ณ Autor ณALEXANDRE VENANCIO     ณ Data ณ19/03/2013ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Incluir Estoque Regulador em novas PAs                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTFAT13C()


Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpp		:= 0       
Local cNomPa	:=	''
Private aCols := {}
Private aHeader := {}
Private noBrw1  := 0   
Private aCampos	:= {"B1_COD","B1_DESC","B2_XESTREG"} 
Private cPa		:= space(6)
Private cTab	:= space(3)
Private lAlt	:=	.F.


SetPrvt("oDlg1","oGrp1","oBrw1","oBtn1","oBtn2")
If cEmpAnt <> "01"
	Return
EndIf

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "08" TABLES "SB1/SB2"

If TTFAT13P() == 0 .OR. Empty(cPa)
	Return
EndIf

cNomPa := Alltrim(Posicione("ZZ1",1,xFilial("ZZ1")+cPa,"ZZ1_DESCRI"))

oDlg1      := MSDialog():New( 091,232,528,893,"Inclusใo de Estoque Regulador na PA "+cPa+" - "+cNomPa+if(!empty(cTab)," Tabela "+cTab,""),,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,188,320,"Produtos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
MHoBrw1()
MCoBrw1()																					/*'AllwaysTrue()'*/
oBrw1      := MsNewGetDados():New(016,012,176,312,nOpc,'AllwaysTrue()','AllwaysTrue()',,{'B1_COD','B2_XESTREG'},0,9999,'U_TTFAT13V','','AllwaysTrue()',oGrp1,aHeader,aCols )
oBtn1      := TButton():New( 194,111,"Confirmar",oDlg1,{||oDlg1:end(nOpp:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 194,166,"Cancelar",oDlg1,{||oDlg1:end(nOpp:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpp == 1
  	Grava()
  	U_TTFAT13C()  
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT13C  บAutor  ณMicrosiga           บ Data ณ  03/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criando um aheader                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MHoBrw1()
                  
Local nX	:=	1

DbSelectArea("SX3")
DbSetOrder(2)

For nX := 1 to len(aCampos)
   If DbSeek(aCampos[nX])
      noBrw1++  
          
           	Aadd(aHeader,	{	Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",	SX3->X3_USADO,SX3->X3_TIPO,	;
				If(aCampos[nX]=="B1_COD","SB1PCA",SX3->X3_F3),SX3->X3_CONTEXT,SX3->X3_CBOX,,"",;
				If(aCampos[nX]=="B1_DESC","V",SX3->X3_VISUAL),"", SX3->X3_PICTVAR,SX3->X3_OBRIGAT	})

   EndIf                                      
Next nX

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT13C  บAutor  ณMicrosiga           บ Data ณ  03/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Preenchendo o acols com os dados da tabela ou pa ja existente
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function MCoBrw1()

Local aAux 	:= {}
Local cQuery
            
cQuery := "SELECT B2_COD,B1_DESC,B2_XESTREG FROM "+RetSQLName("SB2")+" B2"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=B2_COD AND B1.D_E_L_E_T_=''"
cQuery += " WHERE B2_FILIAL='"+xFilial("SB2")+"' AND B2_LOCAL ='"+cPa+"' AND B2.D_E_L_E_T_='' ORDER BY B2_COD" //AND B2_XESTREG>0

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

While !EOF()
	Aadd(aCols,Array(noBrw1+1))
	For nI := 1 To noBrw1
	   aCols[len(aCols)][nI] := CriaVar(aHeader[nI][2])
	   aCols[len(aCols)][01] := TRB->B2_COD
	   aCols[len(aCols)][02] := TRB->B1_DESC
	   aCols[len(aCols)][03] := TRB->B2_XESTREG 
	Next
	aCols[len(aCols)][noBrw1+1] := .F.
	DbSkip()
	lAlt := .T.
EndDo

If !lAlt
	cQuery := "SELECT DISTINCT DA1_CODPRO,B1_DESC,0 AS ESTREG FROM "+RetSQLName("DA1")+" DA1"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=DA1_CODPRO AND B1.D_E_L_E_T_=''"
	cQuery += " WHERE DA1_CODTAB = '"+cTab+"' AND DA1.D_E_L_E_T_=''"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf       
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")
	                 
	While !EOF()
		Aadd(aCols,Array(noBrw1+1))
		For nI := 1 To noBrw1
		   aCols[len(aCols)][nI] := CriaVar(aHeader[nI][2])
		   aCols[len(aCols)][01] := TRB->DA1_CODPRO
		   aCols[len(aCols)][02] := TRB->B1_DESC
		   aCols[len(aCols)][03] := TRB->ESTREG
		Next
		aCols[len(aCols)][noBrw1+1] := .F.
		DbSkip()
	EndDo
EndIf


Return                        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT13C  บAutor  ณMicrosiga           บ Data ณ  04/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Parametros iniciais para trazer ou nao dados da PA ou     บฑฑ
ฑฑบ          ณdados da tabela que sera colocada a pa;                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TTFAT13P()

Local oDlg1,oGrp1,oSay1,oSay2,oGet1,oGet2,oBtn1,oBtn2 
Local nOpc	:=	0
Local lPas	:=	.F.

While !lPas

	oDlg1      := MSDialog():New( 091,232,368,700,"Parโmetros - ER",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp1      := TGroup():New( 012,012,096,216,"Informe o C๓digo da PA",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
		oSay1      := TSay():New( 036,047,{||"PA"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet1      := TGet():New( 036,128,{|u|If(Pcount()>0,cPa:=u,cPa)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1","",,)
	
		oSay2      := TSay():New( 064,047,{||"Tabela"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet2      := TGet():New( 064,128,{|u|If(Pcount()>0,cTab:=u,cTab)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DA0","",,)
	
	oBtn1      := TButton():New( 108,052,"Confirmar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 108,144,"Cancelar",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)   
	
	If nOpc == 1
		If Empty(Posicione("ZZ1",1,xFilial("ZZ1")+cPa,"ZZ1_DESCRI"))
			MsgAlert("PA inexistente na filial","TTFAT13C")
			lPas := .F.
		Else
			lPas := .T.
		EndIf 
	Else
		lPas := .T.
	EndIf

EndDo
	
Return(nOpc)        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT13C  บAutor  ณMicrosiga           บ Data ณ  04/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Salva as informacoes sobre o estoque regulador da PA       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Grava()

Local nCont	:=	0
Local nOpc := 3 // inclusao
Private aProduto	:= {}
Private lMsHelpAuto := .t. 
Private lMsErroAuto := .f. 
	

DbSelectArea("SB2")
DbSetOrder(1)
          
If lAlt
	For nCont := 1 to len(oBrw1:aCols)
		If DbSeek(xFilial("SB2")+oBrw1:aCols[nCont,01]+cPa) .And. !Empty(oBrw1:aCols[nCont,01])
			Reclock("SB2",.F.)
			SB2->B2_XESTREG := If(!oBrw1:aCols[nCont,04],oBrw1:aCols[nCont,03],0)
			SB2->(Msunlock())
		Else
			IF !DbSeek(xFilial("SB2")+oBrw1:aCols[nCont,01]+cPa) .And. !Empty(oBrw1:aCols[nCont,01])
				DbSelectArea("SB9")
				DbSetOrder(1)
				If !DbSeek(xFilial("SB9")+oBrw1:aCols[nCont,01]+cPa)                  
					aProduto := {} 
					aadd(aProduto,{"B9_FILIAL"	,     xFilial("SB9") 	,Nil})
					aadd(aProduto,{"B9_COD"		, oBrw1:aCols[nCont,01]	,Nil})
					aadd(aProduto,{"B9_LOCAL"	,     cPa				,Nil})
					aadd(aProduto,{"B9_QINI"	,     0					,Nil})
					aadd(aProduto,{"B9_VINI1"	,     0					,Nil})
					aadd(aProduto,{"B9_MCUSTD"	,     "1"				,Nil})
					     
					MSExecAuto({|x,y| mata220(x,y)},aProduto,nOpc)
					     
					If lMsErroAuto
						Mostraerro()
					EndIf
				EndIf
				DbSelectArea("SB2")
				DbSetOrder(1) 

				Reclock("SB2",.F.)
				//SB2->B2_FILIAL 	:= xFilial("SB2")
				//SB2->B2_COD		:= oBrw1:aCols[nCont,01]
				SB2->B2_XESTREG := oBrw1:aCols[nCont,03] 
				//SB2->B2_LOCAL	:= cPa
				SB2->(Msunlock())     

			EndIf
		EndIf		
	Next nCont
Else
	For nCont := 1 to len(oBrw1:aCols)
		If oBrw1:aCols[nCont,03] > 0
			If !DbSeek(xFilial("SB2")+oBrw1:aCols[nCont,01]+cPa) .And. !Empty(oBrw1:aCols[nCont,01])
				Reclock("SB2",.T.) 
				SB2->B2_COD		:= oBrw1:aCols[nCont,01]
				SB2->B2_XESTREG := oBrw1:aCols[nCont,03] 
				SB2->B2_LOCAL	:= cPa
				SB2->(Msunlock())
			EndIf
			
			DbSelectArea("SB9")
			DbSetOrder(1)
			If !DbSeek(xFilial("SB9")+oBrw1:aCols[nCont,01]+cPa)                  
				aProduto := {} 
				aadd(aProduto,{"B9_FILIAL"	,     xFilial("SB9") 	,Nil})
				aadd(aProduto,{"B9_COD"		, oBrw1:aCols[nCont,01]	,Nil})
				aadd(aProduto,{"B9_LOCAL"	,     cPa				,Nil})
				aadd(aProduto,{"B9_QINI"	,     0					,Nil})
				aadd(aProduto,{"B9_VINI1"	,     0					,Nil})
				aadd(aProduto,{"B9_MCUSTD"	,     "1"				,Nil})
				     
				MSExecAuto({|x,y| mata220(x,y)},aProduto,nOpc)
				     
				If lMsErroAuto
					Mostraerro()
				EndIf
			EndIf
			DbSelectArea("SB2")
			DbSetOrder(1) 
		EndIf
	Next nCont
EndIf

Return                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT13C  บAutor  ณMicrosiga           บ Data ณ  04/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFAT13V()
     
Local lRet	:=	.T.
                          
If TYPE("M->B1_COD") != "U"
	If !existcpo("SB1",M->B1_COD)
		MsgAlert("C๓digo inexistente","TTFAT13C")
		lRet := .F.	
	Else           
		For nX := 1 to len(oBrw1:aCols)
			If M->B1_COD == oBrw1:aCols[nX][1]
				MsgAlert("C๓digo jแ consta na PA","TTFAT13C")
				lRet := .F.
				exit
			EndIf
		Next nX
		
		If lRet 
			oBrw1:aCols[n][2] := Posicione("SB1",1,xFilial("SB1")+M->B1_COD,"B1_DESC")
		EndIf
	EndIf
Else
	oBrw1:aCols[n][3] := aCols[n,03]
EndIf

Return(lRet)