#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TTCNTA07  ³ Autor ³ Alexandre Venancio    ³ Data ³09/09/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄ--Ä´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Amarracao de patrimonios com contrato por tipo de servico. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTCNTA07()

Local nOpc := 2 //GD_UPDATE    
Local nOp	:=	0
Local cSel	:=	'' 
Local cBarra	:=	''
Local cTipfCn	:=	''
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private cCampos	:=	"N1_CHAPA/N1_PRODUTO/N1_DESCRIC/N1_XTPSERV/CN9_XCNSEL/CN9_XFATPA"
Private noBrw1  := 0 

SetPrvt("oDlg1","oBrw1","oBtn1","oBtn2")

If cEmpAnt == "01"
	
	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "ATF" TABLES "SN1"   
	
	oDlg1      := MSDialog():New( 091,232,483,927,"Patrimonios",,,.F.,,,,,,.T.,,,.T. )
	MHoBrw1()
	MCoBrw1()                                                                                                                         
	oBrw1      := MsNewGetDados():New(008,004,164,336,nOpc,'AllwaysTrue()','AllwaysTrue()','',{"N1_XTPSERV","CN9_XCNSEL","CN9_XFATPA"},0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1 )
	oBtn1      := TButton():New( 172,104,"Confirmar",oDlg1,{||oDlg1:end(nOp:=1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 172,196,"Sair",oDlg1,{||oDlg1:end(nOp:=0)},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
	
	If nOp == 1
		DbSelectArea("SN1")
		DbSetOrder(2)
		For nX := 1 to len(oBrw1:aCols)
			If DbSeek(xFilial("SN1")+AvKey(cvaltochar(oBrw1:aCols[nX,01]),"N1_CHAPA"))
				Reclock("SN1",.F.)
				SN1->N1_XTPSERV	:=	oBrw1:aCols[nX,04] 
				SN1->(Msunlock())
			EndIf
			If !Empty(oBrw1:aCols[nX,05])
				cSel +=  Alltrim(oBrw1:aCols[nX,05])+"="+Alltrim(CVALTOCHAR(oBrw1:aCols[nX,01]))+"/"		
			EndIf
	        If !Empty(oBrw1:aCols[nX,06])
	        	cTipfCn := oBrw1:aCols[nX,06]
	        EndIf
		Next nX
		
	
		If !Empty(cSel)
			DbSelectArea("CN9")
			Reclock("CN9",.F.)
			CN9->CN9_XCNSEL := cSel
			CN9->(Msunlock())
		EndIf
	    If !Empty(cTipfCn)
			DbSelectArea("CN9")
			Reclock("CN9",.F.)
			CN9->CN9_XFATPA	:= cTipfCn  
			CN9->(Msunlock())
		EndIf
			
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA07  ºAutor  ³Microsiga           º Data ³  09/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MHoBrw1()

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SN1")
While !Eof() .and. SX3->X3_ARQUIVO == "SN1"
   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .AND. Alltrim(SX3->X3_CAMPO) $ cCampos
      noBrw1++
      Aadd(aHoBrw1,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           SX3->X3_TAMANHO,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO } )
   EndIf
   DbSkip()
End        

Asort(aHoBrw1,,,{|x,y| x[2] < y[2]})

DbSeek("CN9")
While !Eof() .and. SX3->X3_ARQUIVO == "CN9"
   If Alltrim(SX3->X3_CAMPO) $ cCampos
      noBrw1++
      Aadd(aHoBrw1,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           3,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO } )
   EndIf
   DbSkip()
End

//SX3->X3_TAMANHO

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA07  ºAutor  ³Microsiga           º Data ³  09/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MCoBrw1()

Local aAux := {}
Local cQuery    
Local cSel	
Local aPSel	:=	If(!Empty(CN9->CN9_XCNSEL),strtokarr(CN9->CN9_XCNSEL,"/"),{}) 
Local cTpPA	:=	CN9->CN9_XTPFAT

cQuery := "SELECT CAST(RTRIM(N1_CHAPA) AS INT) AS N1_CHAPA,N1_PRODUTO,N1_DESCRIC,N1_XTPSERV"
cQuery += " FROM "+RetSQLName("SN1")
cQuery += " WHERE N1_XCLIENT='"+CN9->CN9_CLIENT+"' AND D_E_L_E_T_=''"

If CN9->CN9_XTPFAT == "2"
	cQuery += " AND N1_XLOJA='"+CN9->CN9_LOJACL+"'"
EndIf
 
cQuery += " AND N1_PRODUTO IN(SELECT B1_COD FROM "+RetSQLNAme("SB1")+" WHERE B1_XSECAO='026')"                                        
cQuery += " ORDER BY 1 ASC"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf         
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

While !EOF()
 
	Aadd(aCoBrw1,Array(noBrw1+1))
	For nI := 1 To noBrw1        
		CriaVar(aHoBrw1[nI][2])
	Next
			
	aCoBrw1[LEN(aCoBrw1)][1] := TRB->N1_CHAPA
   	aCoBrw1[LEN(aCoBrw1)][2] := TRB->N1_DESCRIC
   	aCoBrw1[LEN(aCoBrw1)][3] := TRB->N1_PRODUTO
   	aCoBrw1[LEN(aCoBrw1)][4] := TRB->N1_XTPSERV
   	aCoBrw1[LEN(aCoBrw1)][6] := cTpPA
   	
   	If len(aPsel) > 0
   		For nX := 1 to len(aPsel)
   			aAux := strtokarr(aPsel[nX],"=")
   			If !Empty(aAux[1]) .And. len(aAux) > 1
	   			If aAux[2] == Alltrim(cvaltochar(TRB->N1_CHAPA))
	   				cSel := aAux[1]
	   			EndIf              
	   		EndIf
   		Next nX
   		
   		aCoBrw1[LEN(aCoBrw1)][5] := If(!Empty(cSel),cSel,space(2))
   	Else
	   	aCoBrw1[LEN(aCoBrw1)][5] := space(2)
	EndIf
	
	aCoBrw1[LEN(aCoBrw1)][noBrw1+1] := .F.
	Dbskip()
EndDo
	
Return