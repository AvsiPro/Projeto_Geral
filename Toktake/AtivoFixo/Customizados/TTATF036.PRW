#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"
#include "fileio.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTATF036  ºAutor  ³Microsiga           º Data ³  08/23/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTATF036()  

//Local aArea := GetArea()
Local cBase 	:= "0000000005"
Local cItem 	:= "0001"
Local cTipo 	:= "01"
Local cTpSaldo 	:= "1"
Local cBaixa 	:= "0"
Local nQtdAtu 	:= 1
Local nQtdBaixa := 1
Local cMotivo 	:= "20"
Local cMetDepr 	:= '' //GetMV('MV_ATFDPBX')
Local cNumNF 	:= ""
Local cSerieNF 	:= ""
Local nValNF 	:= 0
Local creg01	:=	'c:\01\ATFBX.txt' 
Local cCaminho	:=	'c:\01\'       
Local cArqV		:=	''

Local aCab 		:= {}
Local aAtivo	:= {}
Local aParam 	:= {}           
Local aBkpAtf	:= {}

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private nHandle2	:=	fcreate('c:\01\logbxatf.txt' , FO_READWRITE + FO_SHARED )

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "ATF" TABLES "FN6/SN3"
    
cMetDepr 	:= GetMV('MV_ATFDPBX')

nHandle 	:=	FT_FUse(cReg01) 

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
    
    If Ascan(aBkpAtf,{|x| Alltrim(x) == Alltrim(cLine)}) == 0
    	Aadd(aBkpAtf,cLine)
	    cBase 	:=	cLine //Avkey(cLine,"FN6_CBASE")
	    cItem	:=	"0001"
	    
		aCab := { {"FN6_FILIAL" 	,XFilial("FN6") 	,NIL},;
					{"FN6_CBASE" 	,cBase 				,NIL},;
					{"FN6_CITEM" 	,cItem 				,NIL},;
					{"FN6_MOTIVO" 	,cMotivo 			,NIL},;
					{"FN6_BAIXA" 	,100 				,NIL},;
					{"FN6_QTDBX" 	,nQtdBaixa 			,NIL},;
					{"FN6_DTBAIX" 	,ctod("01/08/2018")	,NIL},;
					{"FN6_DEPREC" 	,cMetDepr 			,NIL}}
		
		aAtivo := {{"N3_FILIAL" 	,XFilial("SN3") 	,NIL},;
					{"N3_CBASE" 	,cBase 				,NIL},;
					{"N3_ITEM" 		,cItem 				,NIL},;
					{"N3_TIPO" 		,cTipo 				,NIL},;
					{"N3_BAIXA" 	,cBaixa 			,NIL},;
					{"N3_TPSALDO" 	,cTpSaldo 			,NIL}}
		
		Begin Transaction
		
		MsExecAuto({|a,b,c,d,e,f|ATFA036(a,b,c,d,e,f)},aCab,aAtivo,3,,.T./*lBaixaTodos*/,aParam)
		
		If lMsErroAuto 
			cCaminho := 'c:\01\'
			MostraErro(cCaminho,'log_'+alltrim(cLine)+'.txt')
			DisarmTransaction()
		Else
			FWrite(nHandle2,Alltrim(cLine)+" / Baixado"+chr(13)+Chr(10),1000)
		EndIf
		
		End Transaction
		
	EndIf
	FT_FSKIP()
End              

FT_FUse()

//RestArea(aArea)

Return                                               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTATF036  ºAutor  ³Microsiga           º Data ³  02/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTATF99
                    
Local cReg01		:=	"c:\00\gu.txt"
Local nHandle 		:=	FT_FUse(cReg01)  
Local aAux			:=	{}
Private nHandle2	:=	fcreate('c:\00\logbxatf'+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+'.txt' , FO_READWRITE + FO_SHARED )

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "ATF" TABLES "FN6/SN3"

/*cDir := cGetFile( '*.txt|*.txt', OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .T., .T.) 

If Empty(cDir)
	Return
EndIf     */

nHandle 	:=	FT_FUse(cReg01) 
cBb := ""
caux := ""

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	caux 	+= cBb + Alltrim(cLine)
	cBb		:= "','"
	FT_FSKIP()
End 
        
cQuery := "SELECT FN6_CBASE,FN6_CITEM,FN6_DTBAIX,"
cQuery += " N3_CBASE,N3_ITEM,N3_TIPO,N3_BAIXA,N3_HISTOR,N3_DTBAIXA,N3_IDBAIXA,N3.R_E_C_N_O_ AS RECN3,"
cQuery += " N1_CBASE,N1_CHAPA,N1_ITEM,N1_DESCRIC,N1_BAIXA,N1_STATUS,N1_XSTATTT,N1_XCLIENT,N1_XLOJA,N1.R_E_C_N_O_ AS RECN1"
cQuery += " FROM SN1010 N1"
cQuery += " LEFT JOIN SN3010 N3 ON N3_FILIAL=N1_FILIAL AND N3_CBASE=N1_CBASE AND N3.D_E_L_E_T_=''"  //AND N3_ITEM=N1_ITEM 
cQuery += " LEFT JOIN FN6010 FN6 ON FN6_CBASE=N3_CBASE AND FN6_CITEM=N3_ITEM AND FN6.D_E_L_E_T_=''"  //
cQuery += " WHERE N1_CBASE IN('"+caux+"')"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

dbSelectArea("TRB")

While TRB->(!EOF())
                            
	cBaixa := If(Empty(TRB->FN6_DTBAIX) .or. Alltrim(TRB->N3_ITEM) <> Alltrim(TRB->FN6_CITEM),"NAO_BAIXADO","BAIXADO")  
	cTexto := cBaixa + "|" +TRB->N3_CBASE+ "|" +TRB->N3_ITEM + "|" + TRB->N3_TIPO+ "|" + TRB->N3_BAIXA+ "|" +TRB->N3_DTBAIXA+ "|" +TRB->N3_IDBAIXA+ "|" 
	cTexto += TRB->N1_BAIXA+ "|" +TRB->N1_STATUS+ "|" +TRB->N1_XSTATTT+ "|" +TRB->N1_XCLIENT+ "|" +TRB->N1_XLOJA
	
	FWrite(nHandle2,cTexto+CRLF,1000)
    
    If (cBaixa == "NAO_BAIXADO" .AND. TRB->N3_ITEM <> TRB->FN6_CITEM) .OR. TRB->RECN1 < 1	
    	Aadd(aAux,{TRB->RECN1,TRB->RECN3,TRB->N3_CBASE,TRB->N3_ITEM,TRB->N3_TIPO,IF(TRB->RECN1<1,.F.,.T.)})
    EndIf
    
	TRB->(dbSkip())
End

For nX := 1 to len(aAux)         
	If aAux[nX,01] < 1 .OR. !aAux[nX,06]
		DbSelectArea("SN3")
		DbGoto(aAux[nX,02])
		Reclock("SN3",.F.)
		DbDelete()
		SN3->(Msunlock())
	Else
		DbSelectArea("SN3")
		Dbgoto(aAux[nX,02])
		Reclock("SN3",.F.)
		SN3->N3_BAIXA 	:=	"0"
		SN3->N3_DTBAIXA	:=	CTOD(" / / ")
		SN3->N3_IDBAIXA	:=	"" 
		SN3->N3_TIPO	:=	"02"
		SN3->(Msunlock())
		DbSelectArea("SN1")
		Dbgoto(aAux[nX,01])
		Reclock("SN1",.F.)   
		SN1->N1_BAIXA	:=	CTOD(" / / ")          
		SN1->N1_STATUS	:=	"1"
		SN1->N1_XSTATTT	:=	"8"
		SN1->(Msunlock())
	EndIF	
Next nX
 
For nX := 1 to len(aAux)     
	If aAux[nX,06] .And. aAux[nX,01] > 0
		Processa( {|| Baixar(aAux[nX,03],aAux[nX,04],aAux[nX,05])}, "Processando "+aAux[nX,03])
	EndIf
Next nX
                 
FT_FUse()
       
Return    

Static Function Baixar(cBase,cItem,cTipo)
                             
Local cMotivo 	:= "07"
Local aCab		:= {}
Local aAtivo	:= {}      
Local aCab 		:= {}
Local aAtivo	:= {}
Local aParam 	:= {}           
Local aBkpAtf	:= {}    
Local cMetDepr	:= "2"
Local cTpSaldo 	:= "1"
Local cBaixa 	:= "0"

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

ddatabase := ctod("31/12/2018")

aCab := { {"FN6_FILIAL" 	,XFilial("FN6") 	,NIL},;
			{"FN6_CBASE" 	,cBase 				,NIL},;
			{"FN6_CITEM" 	,cItem 				,NIL},;
			{"FN6_MOTIVO" 	,cMotivo 			,NIL},;
			{"FN6_BAIXA" 	,100 				,NIL},;
			{"FN6_QTDBX" 	,0					,NIL},;		
			{"FN6_DTBAIX" 	,ctod("31/12/2018")	,NIL},;
			{"FN6_DEPREC" 	,cMetDepr 			,NIL}}
             //{"FN6_QTDBX" 	,If(cTipo $ "01/03",1,0)	,NIL},;
aAtivo := {{"N3_FILIAL" 	,XFilial("SN3") 	,NIL},;
			{"N3_CBASE" 	,cBase 				,NIL},;
			{"N3_ITEM" 		,cItem 				,NIL},;
			{"N3_TIPO" 		,cTipo 				,NIL},;
			{"N3_BAIXA" 	,cBaixa 			,NIL},;
			{"N3_TPSALDO" 	,cTpSaldo 			,NIL}}

Begin Transaction
        
lMsErroAuto := .F.

MsExecAuto({|a,b,c,d,e,f|ATFA036(a,b,c,d,e,f)},aCab,aAtivo,3,,.T./*lBaixaTodos*/,aParam)

If lMsErroAuto 
	cCaminho := 'c:\00\'
	MostraErro(cCaminho,'log_'+alltrim(cBase)+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+'.txt')
	DisarmTransaction()
Else
	FWrite(nHandle2,Alltrim(cBase)+" / Baixado"+CRLF,1000)
EndIf

End Transaction

Return                

User Function xxgus

Local creg01	:=	'c:\00\proc\gu_original.txt' 
Local nHandle2	:=	fcreate('c:\00\proc\gu_proc.txt' , FO_READWRITE + FO_SHARED )
Local nHandle3	:=	fcreate('c:\00\proc\buga.txt' , FO_READWRITE + FO_SHARED )
Local aJaburu	:=	{}

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "ATF" TABLES "FN6/SN3"

nHandle 	:=	FT_FUse(cReg01) 

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente   
	
	cQuery := "SELECT FN6_CBASE,COUNT(*) AS QTD"
	cQuery += " FROM FN6010"
	cQuery += " WHERE FN6_CBASE='"+Alltrim(cLine)+"'  AND D_E_L_E_T_=''"
	cQuery += " AND FN6_CBASE IN(SELECT N3_CBASE FROM SN3010 WHERE N3_CBASE='"+Alltrim(cLine)+"' AND D_E_L_E_T_='')"
	cQuery += " GROUP BY FN6_CBASE"   //AND FN6_DTBAIX='20181231'

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)
	
	dbSelectArea("TRB")
	
	If TRB->QTD > 0
		FWrite(nHandle2,Alltrim(cLine)+" | PROCESSADO "+cvaltochar(TRB->QTD)+" REGISTROS"+CRLF,1000)
	ELSE
		FWrite(nHandle2,Alltrim(cLine)+" | NÃO PROCESSADO"+CRLF,1000)
		If Ascan(aJaburu,{|x| Alltrim(x) == Alltrim(cLine)}) == 0
			FWrite(nHandle3,Alltrim(cLine)+CRLF,1000)
			Aadd(aJaburu,Alltrim(cLine))
		EndIf
	ENDIF
		
	FT_FSKIP()
End              

FT_FUse()

Return                                                                  

User function xxbeter

Local cReg01		:=	"c:\00\gu.txt"
Local nHandle 		:=	FT_FUse(cReg01)  
Local aAux			:=	{}

nHandle 	:=	FT_FUse(cReg01) 

cBb := ""
caux := ""

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "ATF" TABLES "FN6/SN3"

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	caux 	+= cBb + Alltrim(cLine)
	cBb		:= "','"
	FT_FSKIP()
End 

cQuery := "SELECT N3_CBASE,N3.R_E_C_N_O_ AS RECN3, N1.R_E_C_N_O_  AS RECN1
cQuery += " FROM SN3010 N3
cQuery += " LEFT JOIN SN1010 N1 ON N1_FILIAL=N3_FILIAL AND N1_CBASE=N3_CBASE AND N1.D_E_L_E_T_=''
cQuery += " WHERE N3_CBASE IN('"+caux+"')

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

dbSelectArea("TRB")

While TRB->(!EOF())
    If TRB->RECN1 == 0
    	Aadd(aAux,TRB->RECN3)
    EndIF
	TRB->(dbSkip())
End

For nX := 1 to len(aAux)         
	DbSelectArea("SN3")
	DbGoto(aAux[nX])
	Reclock("SN3",.F.)
	DbDelete()
	SN3->(Msunlock())
Next nX

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTATF036  ºAutor  ³Microsiga           º Data ³  02/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function TTATFA0

Local nQtd 		:= 1
Local dAquisic 	:= dDataBase 
Local dIndDepr 	:= RetDinDepr(dDataBase)
Local nValor 	:= 1000
Local nTaxa 	:= 10
Local nTamBase	:= TamSX3("N3_CBASE")[1]
Local nTamChapa	:= TamSX3("N3_CBASE")[1]
Local cGrupo	:= "0001" 
Local aParam	:= {}
Local cReg01		:=	"c:\00\gu2.txt"
Local nHandle 		:=	FT_FUse(cReg01)  
Local aAux			:=	{}

 
Local aCab 		:= {}
Local aItens 	:= {}

Local nHandle2	:=	fcreate('c:\00\reformas.txt' , FO_READWRITE + FO_SHARED )
 
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.


nHandle 	:=	FT_FUse(cReg01) 

aaux := {}

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	app := strtokarr(cLine,";")
 	Aadd(aaux,app)
    	
	FT_FSKIP()
End 

    
For nOp := 1 to len(aaux)
	cQuery := "SELECT * "
	cQuery += " FROM SN1010 N1 "
	cQuery += " INNER JOIN SN3010 N3 ON N3_FILIAL=N1_FILIAL AND N3_CBASE=N1_CBASE AND N3.D_E_L_E_T_=''"
	cQuery += " WHERE N1_CBASE='"+Alltrim(aaux[nOp,01])+"' ORDER BY N3_SEQ DESC"
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)
	
	dbSelectArea("TRB") 
    
	If !Empty(TRB->N1_CBASE) .And. !Empty(TRB->N3_CBASE)
		aCab := {}
		AAdd(aCab,{"N1_CBASE" 	, TRB->N1_CBASE 	,NIL})
		AAdd(aCab,{"N1_ITEM" 	, TRB->N1_ITEM 		,NIL})
		AAdd(aCab,{"N1_AQUISIC"	, TRB->N1_AQUISIC	,NIL})
		AAdd(aCab,{"N1_DESCRIC"	, TRB->N1_DESCRIC	,NIL})
		AAdd(aCab,{"N1_QUANTD" 	, TRB->N1_QUANTD 	,NIL})
		AAdd(aCab,{"N1_CHAPA" 	, TRB->N1_CHAPA 	,NIL})
		AAdd(aCab,{"N1_PATRIM" 	, TRB->N1_PATRIM 	,NIL})
		AAdd(aCab,{"N1_GRUPO" 	, TRB->N1_GRUPO 	,NIL})
		
		aItens := {}
		//-- Preenche itens
		
		
		AAdd(aItens,{; 
					{"N3_CBASE" 	, TRB->N3_CBASE 	,NIL},;
					{"N3_ITEM" 		, TRB->N3_ITEM 		,NIL},;
					{"N3_TIPO" 		, "02"		 		,NIL},;
					{"N3_HISTOR" 	, "REFORMA" 		,NIL},;
					{"N3_CCONTAB" 	, TRB->N3_CCONTAB 	,NIL},;
					{"N3_CUSTBEM" 	, TRB->N3_CUSTBEM 	,NIL},;
					{"N3_CDEPREC" 	, TRB->N3_CDEPREC 	,NIL},;
					{"N3_CDESP" 	, TRB->N3_CDESP 	,NIL},;
					{"N3_CCORREC" 	, TRB->N3_CCORREC 	,NIL},;
					{"N3_CCUSTO" 	, TRB->N3_CCUSTO	,NIL},;
					{"N3_DINDEPR" 	, STOD(TRB->N3_DINDEPR) 	,NIL},;
					{"N3_VORIG1" 	, round(val(aaux[nOp,02]),2)	,NIL},;
					{"N3_TXDEPR1" 	, TRB->N3_TXDEPR1 	,NIL},;      
					{"N3_BAIXA" 	, TRB->N3_BAIXA 	,NIL},;      
					{"N3_TPSALDO" 	, TRB->N3_TPSALDO 	,NIL},;      
					{"N3_TXDEPR" 	, TRB->N3_TXDEPR 	,NIL},;      
					{"N3_AQUISIC" 	, stod(TRB->N3_AQUISIC) 	,NIL},;      
					{"N3_SEQREAV" 	, TRB->N3_SEQREAV 	,NIL},;      
					{"N3_FILORIG" 	, TRB->N3_FILORIG 	,NIL},;      
					{"N3_INTP" 		, TRB->N3_INTP	 	,NIL},;      
					{"N3_ATFCPR" 	, TRB->N3_ATFCPR 	,NIL},;      
					{"N3_SEQ" 		, STRZERO(VAL(TRB->N3_SEQ)+1,3) ,NIL}})
		
		cLine  := TRB->N1_CBASE
		
		Begin Transaction
		
		DbSelectArea("SN3")
		//DbSetOrder(1)
		Reclock("SN3",.T.)
		For nXz := 1 to  22 //len(aItens)
			If !Empty(aItens[1,nXz,01])
				&("SN3->"+Alltrim(aItens[1,nXz,01])) := aItens[1,nXz,02]
			EndIf
		Next nXz 
		SN3->(Msunlock())
		
		End Transaction
		
		dbSelectArea("TRB")
		FWrite(nHandle2,Alltrim(cLine)+" | PROCESSADO "+CRLF,1000)
		
		/*   
		lMsErroAuto := .F.
		
		MSExecAuto({|x,y,z| Atfa012(x,y,z)},aCab,aItens,4,aParam)
		
		If lMsErroAuto
		
			cCaminho := 'c:\00\'
			MostraErro(cCaminho,'log_'+alltrim(cBase)+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+'.txt')
			DisarmTransaction()
		Else
			FWrite(nHandle2,Alltrim(cLine)+" | PROCESSADO "+CRLF,1000)
		Endif
		*/
		//End Transaction
	EndIf
	
Next nOp

FT_FUse()

RestArea(aArea)

Return 

USER FUNCTION SOROM

Local cReg01		:=	"c:\00\gu2_origem.txt"
Local nHandle 		:=	FT_FUse(cReg01)  
Local aAux			:=	{}
Local nHandle2	:=	fcreate('c:\00\Naopassou.txt' , FO_READWRITE + FO_SHARED )

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "ATF" TABLES "FN6/SN3"
     
While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	app := strtokarr(cLine,";")
 	Aadd(aaux,app)
    	
	FT_FSKIP()
End 

For nX := 1 to len(aaux)
	cQuery := "SELECT N3_CBASE,COUNT(*) AS QTD FROM SN3010
	cQuery += " WHERE N3_CBASE='"+Alltrim(aaux[nX,01])+"' AND D_E_L_E_T_='' AND R_E_C_N_O_>=21720 GROUP BY N3_CBASE"

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)
	
	dbSelectArea("TRB") 
	
	If TRB->QTD < 1
		FWrite(nHandle2,Alltrim(aaux[nX,01])+";"+aaux[nX,02]+CRLF,1000)
	EndIf
Next nX
              
FT_FUse()

Return