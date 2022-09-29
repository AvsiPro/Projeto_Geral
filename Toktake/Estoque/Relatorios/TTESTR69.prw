#include "protheus.ch"
#include "tbiconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO12    ºAutor  ³Microsiga           º Data ³  12/29/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTESTR69() 

Local cDir := ""
Private _cNumeroOS := "" 

prepare environment empresa "01" filial "01"

DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Inventario de OS") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir as quantidades inventariadas") SIZE 268, 8 OF oDlg PIXEL
	@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION fParam() ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1  
	cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	If !Empty(cDir)                                          
		CursorWait()
		Processa( { || fProc(cDir) },"Gerando relatorio, aguarde.." )
		CursorArrow()
	EndIf
EndIf
                        
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTESTR69  ºAutor  ³Microsiga           º Data ³  12/29/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fParam()
                                                                                    
Local aPergs := {}
Local aRet := {}

//aAdd(aPergs ,{1,"OS MOBILE"	,space(TamSx3("ZG_NUMOS")[1]),"@!",".T.","SZG",".T.",100,.F.})
aAdd(aPergs ,{1,"PA"	,space(6),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Data"	,dDatabase,"99/99/99","","","",60,.F.})

ParamBox(aPergs ,"Parametros",@aRet) 
	//_cNumeroOS := aRet[1]
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTESTR69  ºAutor  ³Microsiga           º Data ³  12/29/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fProc(cDir)

Local aDados := {}
Local nI
Local axItens := {}
Local aItens := {}
Local nHdl := 0
Local cQuery := ""
Local cNumeroOS := ""

Local cQuery := ""
Local cQuery2 := ""
Local aProds := {} 

Local dDtFim := Stod("")
Local cHrFim := ""
Local cCodPa := ""
Local dFimSang := Stod("")



/*
POSICAO CONTABIL HOJE = ( POSICAO CONTABIL DO DIA 28 + ENTRADAS ENTRE 28/30 - FATURADOS POSTERIOR AO DIA 28 )

POSICAO CONTABIL DO DIA 28 = ( POSICAO CONTABIL HOJE - ENTRADAS POSTERIORES + FATURADOS POSTERIORES )  

POSICAO FISICA 28 = POSICAO CONTABIL DO DIA 28 - ORCAMENTOS A FATURAR DESDE A ULTIMA SANGRIA ( INFERIOR AO DIA 28 )

*/

/*
1: POSICAO CONTABIL DO DIA 28
( POSICAO CONTABIL HOJE - ENTRADAS POSTERIORES + FATURADOS POSTERIORES )


*/ 


// Inventarios
cQuery := "SELECT ZG_NUMOS,ZG_ROTA FROM SZG010 WHERE ZG_ROTA = '"+MV_PAR01+"' AND ZG_DATAFIM = '"+DTOS(MV_PAR02)+"' AND ZG_FORM = '21' AND ZG_STATUS = 'FIOK' "
//cQuery := "SELECT ZG_NUMOS,ZG_ROTA FROM SZG010 WHERE SUBSTRING(ZG_ROTA,1,1) = 'P' AND ZG_DATAFIM = '"+DTOS(MV_PAR02)+"' AND ZG_FORM = '21' AND ZG_STATUS = 'FIOK' "

MPSYSOPENQUERY(cQuery,"TRB")

dbSelectArea("TRB")
If EOF()  
	MsgAlert("Nenhuma Ordem de Serviço encontrada.")
	Return
EndIf                                             
  
While !EOF()       

	aDados := {}
	axItens := {}

	cNumeroOS := TRB->ZG_NUMOS
	cCodPa := TRB->ZG_ROTA

	dbSelectArea("SZG")
	dbSetOrder(1)
	MsSeek( xFilial("SZG") +AvKey( cNumeroOS,"ZG_NUMOS") )
	
	dDtFim := SZG->ZG_DATAFIM 
	cHrFim := SZG->ZG_HORAFIM
		
	//dDtFimOS := SZG->ZG_DATAFIM
			
	aDados := U_MXML000(SZG->ZG_RESPOST)
	For nI := 1 To Len(aDados)          
		If aDados[nI][1] == "INVENTARIO"
			For nJ := 2 To Len(aDados[nI])
				AADD( axItens, ACLONE(aDados[nI][nJ]) )
			Next nJ
		EndIf	
	Next nI
	
	For nI := 1 To Len(axItens)
		AADD( aProds, { cCodPa,;
						 axitens[nI][1][2],;
						  0,;					// sb2
						  0,;					// sck
						  Val(axItens[nI][2][2]),;	// inventario
						  ALLTRIM(pOSICIONE("SB1",1,xFilial("SB1") +AvKey(axitens[nI][1][2],"B1_COD"),"B1_DESC")),;	// descricao
						  0,;	// quantidade entregue apos a os de inventario
						  0,;	// quantidade faturada apos a os de inventario
						  0,;	// posicao contabil
						  0,; 	// posicao fisica
						  0  } ) // ajuste
						  
		/*nPos := Ascan( aProds, { |x| x[1] == cCodPa .AND. x[2] == axitens[nI][1][2] } )
		If nPOs > 0
			aProds[nPOs][5] := Val(axItens[nI][2][2])
		EndIf*/
		
		//AADD( aItens, { axitens[nI][1][2], Val(axItens[nI][2][2]) } )
		//AADD( aItensDs, { axitens[nI][1][2], Val(axItens[nI][3][2]) } )
	Next nI
		            
   	dbSelectArea("TRB")
	dbSkip()
End
//cNumeroOS := TRB->ZG_NUMOS



cQuery := "SELECT TOP 1 * FROM SZG010 "
cQuery += "INNER JOIN SN1010 ON "
cQuery += "N1_CHAPA = ZG_PATRIM "

cQuery += "WHERE ZG_FORM = '03' "
cQuery += "AND N1_XPA = '"+cCodPa+"' "
cQuery += " AND ZG_DATAFIM < '"+DTOS(dDtFim)+"' "

cQuery += "ORDER BY ZG_DATAFIM DESC"

MPSysOpenQuery(cQuery,"TRBX")
 
 
dbSelectArea("TRBX")
If !EOF()                       
	dFimSang := STOD(TRBX->ZG_DATAFIM)
EndIf
        
        

// orcamentos gerados entre data/hora da ultima sangria e a data/hora da OS de inventario
cQuery := "SELECT CK_LOCAL, CK_PRODUTO, SUM(CK_QTDVEN) TOTAL FROM SCK010 "
cQuery += "INNER JOIN SCJ010 ON "
cQuery += "CJ_FILIAL = CK_FILIAL "
cQuery += "AND CJ_NUM = CK_NUM "
cQuery += "WHERE CJ_FILIAL = '01' "
cQuery += "AND CJ_STATUS = 'A' AND CJ_XNUMPV = '' "
cQuery += "AND CK_LOCAL = '"+MV_PAR01+"' "
cQuery += "AND CJ_EMISSAO > '"+DTOS(dFimSang)+"'  AND CJ_EMISSAO < '"+DTOS(dDtFim)+"' "
cQuery += "GROUP BY CK_LOCAL,CK_PRODUTO "

                                
MPSysOpenQuery(cQuery,"TRB1")

dbSelectArea("TRB1")
While !EOF()
	            
	//AND CJ_HRINC < '"+subStr(cHrFim,1,5)+"' TRATAR HORA -> MENOR QUE A HORA DO INVENTARIO	 
	nPos := Ascan( aProds, { |x| ALLTRIM(x[1]) == ALLTRIM(TRB1->CK_LOCAL) .AND. ALLTRIM(x[2]) == ALLTRIM(TRB1->CK_PRODUTO) } )
	If nPOs > 0
		aProds[nPOs][4] := TRB1->TOTAL
	EndIf
	
	dbSkip()
End               


// posicao contabil da data da OS de inventario - saldo SB2
cQuery2 := "SELECT B2_LOCAL, B2_COD, SUM(B2_QATU) TOTAL "
cQuery2 += "FROM SB2010 "
cQuery2 += "WHERE B2_FILIAL = '01' "
//cQuery2 += "AND SUBSTRING(B2_LOCAL,1,1) = 'P' "
cQuery2 += "AND B2_LOCAL = '"+cCodPa+"' "
cQuery2 += "AND D_E_L_E_T_ = '' "
//cQuery2 += "AND ( B2_QATU > 0 OR B2_QATU < 0 ) "
cQuery2 += "AND B2_LOCAL = '"+MV_PAR01+"' "
cQuery2 += "GROUP BY B2_LOCAL, B2_COD "


MPSysOpenQuery(cQuery2,"TRB2")

dbSelectArea("TRB2")
While !EOF()	
	nPos := Ascan( aProds, { |x| ALLTRIM(x[1]) == ALLTRIM(TRB2->B2_LOCAL) .AND. ALLTRIM(x[2]) == ALLTRIM(TRB2->B2_COD) } )
	If nPOs > 0
		aProds[nPOs][3] := TRB2->TOTAL
	EndIf
	
   	dbSkip()
End

/*                      
cQuery := "SELECT * FROM SZG010 "
cQuery += "INNER JOIN SF2010 ON "
cQuery += "F2_FILIAL = ZG_FILIAL "
cQuery += "AND F2_DOC = ZG_DOC "
cQuery += "AND F2_SERIE = ZG_SERIE "

cQuery += "INNER JOIN SD2010 ON "
cQuery += "D2_FILIAL = F2_FILIAL "
cQuery += "AND D2_DOC = F2_DOC "
cQuery += "AND D2_SERIE = F2_SERIE "
 
cQuery += "WHERE ZG_DATAFIM = '"+dDtFim+"' AND ZG_FORM = '13' "
cQuery += "AND ZG_HORAFIM > '"+cHrFim+"' "
cQuery += "AND F2_XCODPA = '"+cCodPa+"' "
*/
       
// notas entregues apos inventario
cQuery := "SELECT F2_XCODPA, D2_COD, SUM(D2_QUANT) TOTAL FROM SD2010 "
cQuery += " INNER JOIN SF2020 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE "
cQuery += "INNER JOIN SZG010 ON "
cQuery += "D2_FILIAL = ZG_FILIAL "
cQuery += "AND D2_DOC = ZG_DOC  "
cQuery += "AND D2_SERIE = ZG_SERIE "
cQuery += "WHERE  "
cQuery += "ZG_FORM = '13' AND ZG_DATAFIM = '"+DTOS(dDtFim)+"' AND ZG_ROTA = '"+cCodPa+"' "
cQuery += "AND ZG_HORAFIM > '"+cHrFim+"' "
cQuery += "GROUP BY F2_XCODPA, D2_COD "

MpSysOpenQuery(cQuery,"TRBY")

dbSelectARea("TRBY")
While !EOF()

	nPos := Ascan( aProds, { |x| ALLTRIM(x[1]) == ALLTRIM(TRBY->D2_LOCAL) .AND. ALLTRIM(x[2]) == ALLTRIM(TRBY->D2_COD) } )
	If nPOs > 0
		aProds[nPOs][6] := TRBY->TOTAL
	EndIf
	
	dbSkip()
End


// consulta faturamento nota para PA com data/hora posterior ao inventario
cQuery := "SELECT D2_LOCAL, D2_COD, SUM(D2_QUANT) TOTAL FROM SD2010 SD2"
cQuery += " INNER JOIN SF2010 ON "
cQuery += " F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE "
cQuery += "WHERE "
cQuery += " F2_XFINAL = '2' AND D2_LOCAL = '"+cCodPA+"' AND SD2.D_E_L_E_T_ = '' "
cQuery += " AND F2_EMISSAO >= '"+DTOS(dDtFim)+"' " 
cQuery += " GROUP BY D2_LOCAL, D2_COD"

MpSysOpenQuery(cQuery,"TRBZ")

dbSelectARea("TRBZ")
While !EOF()

	nPos := Ascan( aProds, { |x| ALLTRIM(x[1]) == ALLTRIM(TRBZ->D2_LOCAL) .AND. ALLTRIM(x[2]) == ALLTRIM(TRBZ->D2_COD) } )
	If nPOs > 0
		aProds[nPOs][7] := TRBZ->TOTAL
	EndIf
	
	dbSkip()
End
           

For nI := 1 To Len(aProds)
       
	nTotSB2 := aProds[nI][3]
	nTotSCK := aProds[nI][4]
	nTotInv := aProds[nI][5]
	nTotEnt := aProds[nI][7]
	nTotFat := aProds[nI][8] 
	
	nPosCont := ( nTotSB2 - nTotEnt + nTotFat )
	nPosFis := ( nPosCont - nTotSCK )
			
	aProds[nI][9] := nPosCont
	aProds[nI][10] := nPosFis
	
	// ajuste -> inventario - fisico
	nAjuste := ( nTotInv - nPosFis )
	aProds[nI][11] := nAjuste	
Next nI


//POSICAO CONTABIL DIA INVENTARIO -> POSICAO ONLINE HOJE - ENTREGAS + FATURAMENTO
//POSICAO FISICA -> POSICAO CONTABIL DIA INVENTARIO - ORCAMENTOS DATA SANGRIA-INVENTARIO
// 



nHdl := Fcreate(cDir +"\" +"inventarios.csv")				                           

FWrite(nHdl, "PA;CODIGO;DESCRICAO;SALDO_SB2;TOT_ORCAMENTO;INVENTARIO;ENTREGUE_POS;FATURADOS_POS;POS_CONTABIL;POS_FISICA;AJUSTAR"  +CRLF)	

For nI := 1 To Len( aProds )
	FWrite(nHdl, aProds[nI][1] +";" +alltrim(aProds[nI][2]) +";" +aProds[nI][6] +";" +cvaltochar(aProds[nI][3]) ;
			 +";" +cvaltochar(aProds[nI][4]) +";" +cvaltochar(aProds[nI][5]) +";" +cvaltochar(aProds[nI][7]) ;
			 +";" +cvaltochar(aProds[nI][8]) +";" +cvaltochar(aProds[nI][9]) +";" +CVALTOCHAR(aProds[nI][10]) ;
			 +";" +cvaltochar(aProds[nI][11]) +CRLF)	
Next nI                                                                                                              

Fclose(nHdl)

MsgInfo( "Arquivo gerado: " +cDir +"\" +"inventarios.csv" )


Return