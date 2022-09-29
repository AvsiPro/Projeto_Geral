#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"                
#INCLUDE "TOPCONN.CH"  
#INCLUDE "RWMAKE.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI116  บAutor  ณAlexandre Venancio  บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina criada para importacao de log sitef                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTEDI116()  
                         
Local nOpca := 0
Local aRegs			:={}
Local aSays 		:= {}
Local aButtons 		:= {}                                            
Local nPed			:= 0
Local cCadastro 	:= "TOKTAKE - Importacao do LOG Sitef"
Local lRet			:= .T.       
Local lGerouPv		:= .T.
Local cQuery		:= ""
Local cNumPed		:= ""  
Local aAreaC5		:= {}
Private cPergCal    := "TTEDI116"   
Private lMsErroAuto		:= .F.
Private lMsHelpAuto 	:= .T.
Private lAutoErrNoFile	:= .F.   
Private cMsg	:=	''
Private cMsg2	:=	''
   
aAdd(aRegs,{cPergCal,"01","Arquivo      ?","","","mv_ch1","C",99,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DIR",""})

//Prepare Environment Empresa "01" Filial "01" //Tables "ZZE" 

If cEmpAnt <> "01"
	Return
EndIf

ValidPerg(aRegs,cPergCal) 
Pergunte(cPergCal,.F.)
             
aAdd(aSays,cCadastro)   
aAdd(aButtons, { 5,.T.,{|| Pergunte(cPergCal,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )          

If nOpca == 1
	Processa({|lEnd| lRet := LerArquivo()},OemToAnsi("Lendo Arquivo"))
    If !Empty(cMsg)
    	U_TTMAILN('microsiga@toktake.com.br','tesouraria@toktake.com.br','Bandeiras SITEF',cMsg,{},.F.)
//	If lRet
//		Distribuir()	
	EndIf         
	If !Empty(cMsg2)
		U_TTMAILN('microsiga@toktake.com.br','tesouraria@toktake.com.br','POS Sem Patrimonio',cMsg2,{},.F.)
	EndIf         
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI116  บAutor  ณAlexandre Venancio  บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao do arquivo                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function LerArquivo()

Local aAux	:=	{}           
Local nCont	:=	1 
Local aCabec:= {}                                                          
Local nHandle 	:= FT_FUse(MV_PAR01)       
Local lRet	:=	.T.   
Local aDiv	:=	{}
Local nRegs := 0
Local nImpOk := 0

// Posiciona na primeria linha
FT_FGoTop()

If nHandle < 0
	MsgAlert("Arquivo nใo encontrado","TTEDI116")
	Return(.F.)
EndIf

DbSelectArea("ZZN")
DbSetOrder(1)

While !FT_FEOF() 
	nRegs++
	FT_FSKIP()
End

ProcRegua( nRegs )

FT_FGoTop()
While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := SEPARA( cLine, ";" , .T. ) //StrTokArr(cLine,";")   
	If nCont > 1
		For nX := 1 to len(aAux)
			aAux[nX] := Strtran(aAux[nX],",",".") 
			aAux[nX] := Strtran(aAux[nX],'"')  
			aAux[nX] := Strtran(UPPER(aAux[nX]),"ว","C")
			aAux[nX] := Strtran(UPPER(aAux[nX]),"ร","A") 
			aAux[nX] := Strtran(UPPER(aAux[nX]),"ี","O")
		Next nX 
		aDiv := diversos( UPPER(aAux[08]),val(aAux[11]),UPPER(aAux[07]),aAux[04] )
		//ZZE_FILIAL+ZZE_PDV+ZZE_NSU+ZZE_DATATR+ZZE_HORATR 
		DbSelectArea("ZZE")
		DbSetOrder(1)
		If !Dbseek( xFilial("ZZE") +Avkey(aAux[04],"ZZE_PDV") +Avkey(aAux[05],"ZZE_NSU") +dtos(ctod(aAux[02]))+aAux[03] )  
			Reclock("ZZE",.T.)
	    	ZZE->ZZE_LOJA	:=	aAux[01]	
	    	ZZE->ZZE_DATATR	:=	ctod(aAux[02])
	    	ZZE->ZZE_HORATR	:=	aAux[03]
	    	ZZE->ZZE_PDV	:=	aAux[04]
	    	ZZE->ZZE_NSU	:=	aAux[05]
	    	ZZE->ZZE_NSUHOS	:=	aAux[06]
	    	ZZE->ZZE_REDE	:=	UPPER(aAux[07])
	    	ZZE->ZZE_PRODUT	:=	UPPER(aAux[08])
	    	ZZE->ZZE_TRANSA	:=	aAux[09]
	    	ZZE->ZZE_DOCTO	:=	aAux[10]
	    	ZZE->ZZE_VLRBRU	:=	val(aAux[11])
	    	ZZE->ZZE_ESTTRA	:=	UPPER(aAux[12])
	    	ZZE->ZZE_CODRES	:=	UPPER(aAux[13])
	    	ZZE->ZZE_AUTORI	:=	aAux[15]
	    	ZZE->ZZE_USUPEN	:=	UPPER(aAux[18])
	    	ZZE->ZZE_DATPEN	:=	ctod(aAux[19])
	    	ZZE->ZZE_HORAPE	:=	aAux[20]
	    	ZZE->ZZE_TMPRED	:=	aAux[21]
	    	ZZE->ZZE_BANDEI	:=	UPPER(aAux[22])
	    	ZZE->ZZE_VLRENC	:=	aDiv[1]
	    	ZZE->ZZE_CSTTEF	:=	aDiv[2]
	    	ZZE->ZZE_VLRLIQ	:=	VAL(aAux[11]) - aDiv[1]
	    	ZZE->ZZE_PATRIM	:=	aDiv[3]
	    	ZZE->(Msunlock())
	    	
	    	nImpOk++
	    Else
	    	If !Empty( aDiv[3] )
		    	Reclock("ZZE",.F.)	
		    	ZZE->ZZE_PATRIM	:=	aDiv[3]
		    	MsUnlock()
	    	EndIf
	    EndIf 
		
	EndIf                                                     
	nCont++
	
	IncProc("")
	
	FT_FSKIP()
End

FT_FUSE()   


MsgInfo( "Total de registros importados: " +cvaltochar(nImpOk) )

Return(lRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI116  บAutor  ณMicrosiga           บ Data ณ  08/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function diversos(cBand,nValor,cRede,cPdv)

Local aArea	:=	GetArea()
Local aRet	:=	{}
Local nTax	:=	0
Local nTar	:=	0 
Local nCtef	:=	0
Local cPatr	:=	''

DbSelectArea("ZZM")
DbSetOrder(1)
If DbSeek(xFilial("ZZM")+cBand)
 	nTax := (ZZM->ZZM_TAXA / 100) * nValor
 	nTar := ZZM->ZZM_TARIFA
 	nCtef:= ZZM->ZZM_CSTTEF
Else
	If !empty(cBand)
		cQuery := "SELECT X5_CHAVE FROM "+RetSQLName("SX5")+" WHERE X5_TABELA='ZV' AND X5_DESCRI LIKE '%"+cRede+"%'"
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf
		  
		MemoWrite("TTATFC07.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		DbSelectArea("TRB")
		
		If Empty(TRB->X5_CHAVE)
		
			cQuery := "SELECT MAX(X5_CHAVE)+1 AS N FROM "+RetSQLName("SX5")+"	WHERE X5_TABELA='ZV'"
			
			If Select("TRB") > 0
				dbSelectArea("TRB")
				dbCloseArea()
			EndIf
			  
			MemoWrite("TTATFC07.SQL",cQuery)
			
			cQuery:= ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
			
			DbSelectArea("TRB")
			
			cNr	:=	STRZERO(TRB->N,6)
			
		    DbSelectArea("SX5")
		    DbSetOrder(1)
			Reclock("SX5",.T.)
			SX5->X5_TABELA := "ZV"
			SX5->X5_CHAVE  := cNr
			SX5->X5_DESCRI := cRede
			SX5->(Msunlock())
		EndIf
		
		DbSelectArea("ZZM")
		Reclock("ZZM",.T.)
		ZZM->ZZM_PRODUT	:=	cBand	
		ZZM->ZZM_DESCRI	:= 	cBand
		ZZM->ZZM_REDE	:=	cRede
		ZZM->ZZM_PROCES	:=	'SITEF' 
		ZZM->(Msunlock())
		cMsg += 'Bandeira contida no arquivo e nใo encontrada no sistema - '+cBand+' - deverแ ser feita a devida manuten็ใo no cadastro'+chr(13)+chr(10)
	EndIf
EndIf                      

DbSelectArea("ZZN")
DbSetOrder(2)
If DbSeek(xFilial("ZZN") +AvKey(cPdv,"ZZN_NRSERI"))
	cPatr := ZZN->ZZN_PATRIM
EndIf
                  
If Empty(cPatr)
	If Empty(ZZN->ZZN_IDPDV)
		cMsg2 += 'POS Nใo cadastrado '+cPdv+'<BR>'
	Else
		cMsg2	+=	'POS sem Patrim๔nio amarrado '+ZZN->ZZN_IDPDV+'<BR>'
	EndIf
EndIf

aRet := {nTax+nTar,nCtef,cPatr}

RestArea(aArea)

Return(aRet)