#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCHAMALEARQบAutor  ณMicrosiga           บ Data ณ  10/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CHAMALEARQ()

If cEmpAnt == "10"
	Return
EndIf

Processa({||U_LeArqTxt()})

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLEARQTXT  บAutor  ณMicrosiga           บ Data ณ  10/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LeArqTxt()

Local nTamFile   	:= 0
Local nTamLin    	:= 680
Local nBtLidos   	:= 0
Local nItem       	:= 0
Local nCount        := 0 
Local cQry_1   	    := ""
Local cQry_2   	    := ""
Local cQry_3   	    := ""
Local cQry_4   	    := ""
Local cBuffer   	:= ""
Local cFileOpen 	:= ""
Local cTitulo1 		:= "Selecione o arquivo"
Local cExtens       := "Arquivo TXT | *.txt"
Local nTam 
Local cCodEmp       := SM0->M0_CODIGO
Local cNomEmp		:= SM0->M0_NOME
Local _aItem 		:= {}
Local aNomes        := {}
Local oLeArqTxt

cFileOpen := cGetFile(cExtens,cTitulo1,,"C:\",.T.)

If !File(cFileOpen)
     MsgAlert("Arquivo texto: "+cFileOpen+" nใo localizado",oLeArqTxt)
     Return
Endif

FT_FUSE(cFileOpen)                	//ABRIR
FT_FGOTOP()							//PONTO NO TOPO
ProcRegua(FT_FLASTREC())			//QTOS REGISTROS LER

While !FT_FEOF()

	 IncProc("Incluindo Num Bancario no Cadastro... "+ALLTRIM(cNomEmp))

     cBuffer := FT_FREADLN()                                                                                              
    
    If SUBSTR(cBuffer,14,1) == "A"
        
        cCC         := ALLTRIM(SubStr(cBuffer,037,06))
        cDig        := ALLTRIM(SubStr(cBuffer,043,01))
        cNome  		:= ALLTRIM(SubStr(cBuffer,044,50))
        cDtRef 		:= ALLTRIM(SubStr(cBuffer,094,08))
        cNumBco 	:= ALLTRIM(SubStr(cBuffer,135,15))
        
        cConta      := ALLTRIM(cCC+cDig)
        cData       := SUBS(cDtRef,5,4)+SUBS(cDtRef,3,2)+SUBS(cDtRef,1	,2)
        
        cQry_1 := "SELECT RA_FILIAL,RA_MAT,RA_NOME FROM "+RetSQLName("SRA")
		cQry_1 += " WHERE RA_CTDEPSA = '"+cConta+"'
		cQry_1 += " AND D_E_L_E_T_ <> '*'"    
		
	   
		If Select('TRB_1') > 0
			dbSelectArea('TRB_1')
			dbCloseArea()
		EndIf
		
		MemoWrite("LERARQ_CQUERY_1.SQL",cQry_1)
		
		cQry_1:= ChangeQuery(cQry_1)                                                           
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry_1),"TRB_1",.F.,.T.)   
		
		DbSelectArea("TRB_1")
		
		While !EOF()                   
		
			nCount ++
			
			cQry_2 := "SELECT COUNT(*) AS REGISTROS FROM "+RetSQLName("SZJ")
			cQry_2 += " WHERE ZJ_FILIAL = '"+TRB_1->RA_FILIAL+"'
			cQry_2 += " AND ZJ_MAT = '"+TRB_1->RA_MAT+"'
			cQry_2 += " AND ZJ_NOME LIKE '%"+cNome+"%'    
			cQry_2 += " AND ZJ_NUMBCO = '"+cNumBco+"'
			cQry_2 += " AND ZJ_DTREF = '"+cData+"'   
			cQry_2 += " AND D_E_L_E_T_ <> '*'"    
			 
			If Select('TRB_2') > 0
				dbSelectArea('TRB_2')
				dbCloseArea()
			EndIf
		
			MemoWrite("LERARQ_CQUERY_2.SQL",cQry_2)
			
			cQry_2:= ChangeQuery(cQry_2)                                                           
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry_2),"TRB_2",.F.,.T.)
			
			If TRB_2->REGISTROS > 0 

				ALERT("Funcionแrio: "+cNome+" - N๚mero do Banco: "+cNumBco+" - E perํodo: "+SUBS(cDtRef,1,2)+"/"+SUBS(cDtRef,3,2)+"/"+SUBS(cDtRef,5,4)+" jแ cadastrados")				
			    
			Else	
				 
				BEGIN TRANSACTION
				
				cQry_3 := " SELECT MAX(R_E_C_N_O_+1) AS R_E_C_N_O_
				cQry_3 += "	FROM "+RetSQLName("SZJ")
				
				If Select('TRB_3') > 0
					dbSelectArea('TRB_3')
					dbCloseArea()
				EndIf
				
				cQry_3:= ChangeQuery(cQry_3)                                                           
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry_3),"TRB_3",.F.,.T.) 
				
	   			nR_E_C_N_O_ := TRB_3->R_E_C_N_O_
				
				cQry_4 := "INSERT INTO "+RetSQLName("SZJ")
				cQry_4 += " (ZJ_FILIAL,ZJ_MAT,ZJ_NOME,ZJ_NUMBCO,ZJ_DTREF,D_E_L_E_T_,R_E_C_N_O_ ) "
				cQry_4 += " VALUES "
				cQry_4 += " ('"+TRB_1->RA_FILIAL+"','"+TRB_1->RA_MAT+"','"+cNome+"','"+cNumBco+"','"+cData+"',' ','"+CVALTOCHAR(nR_E_C_N_O_)+"') "
			
				MemoWrite("LERARQ_CQUERY_4.SQL",cQry_4)
				TcSqlExec(cQry_4)
				
				END TRANSACTION
			
			Endif
		
			DbSkip()
		EndDo
		
		DbCloseArea("TRB_1")
		
		If Select('TRB_1') > 0
			FT_FSKIP()
		Else
			AADD(aNomes,{cNome})
			FT_FSKIP()
		Endif	         
    
    Else 
    	FT_FSKIP()
    Endif
    
ENDDO

FT_FUSE()

If Len(aNomes) > 0
	Alert( "Nomes nใo Encontrados - SRA / Enviados por E-mail" )
	U_TITNSRA(aNomes)
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  09/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TITNSRA(aNomes)

Local aArea	   := GetArea()
Local cMailCab := " "

cMailCab = '<br><b><p> <font face="Verdana" size="1"> Nomes nใo encontrados no Cadastro de Funcionแrios </font></p></b><br>'

cMailCab += '<table border="1" width="680" height="40" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">'
cMailCab += '	<tr>'
cMailCab += '		<td width="142,5" bgcolor="#FF9900" height="30"><b><font face="Verdana" size="1">Nomes</font></b></td>'
cMailCab += '	</tr>'

For Nx:= 1 to Len(aNomes)
	
	cMailCab += '	<tr>'
	cMailCab += '		<td width="142,5" height="20"><font face="Verdana" size="1">'+aNomes[Nx][1]+'</font></td>'
	cMailCab += '	</tr>'
	
Next

U_TTMAILN("verf_nomes_holerite@toktake.com.br",GETMV("MV_XLEARQ"),"Nomes nใo Encontrados - SRA",cMailCab,{},.T.)

RestArea(aArea)

Return()
