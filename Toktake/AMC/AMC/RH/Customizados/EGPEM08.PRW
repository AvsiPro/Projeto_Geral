#INCLUDE "protheus.ch"   
#INCLUDE "RWMAKE.CH"
#Include "TOPCONN.CH"
#Define CRLF Chr(13) + Chr(10) 

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ EGPEM08    ≥ Autor ≥ Equipe TOTVS        ≥ Data ≥ 99.99.99 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Geracao de dados dos Funcionarios                 ->TokTake≥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹*/
User Function EGPEM08()

Local nOpca := 0
Local aRegs	:={}
Local cPerg := Substr("EGPEM08" + SPACE(10),1,10)
Local aSays:={ }, aButtons:= { } //<== arrays locais de preferencia

	cCadastro := OemToAnsi("Geracao de Arquivos - Funcionarios") 
	
	Aadd(aRegs,{cPerg,"01","Data De       ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
	Aadd(aRegs,{cPerg,"02","Data Ate      ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
	aAdd(aRegs,{cPerg,"03","Filial De     ?","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
	aAdd(aRegs,{cPerg,"04","Filial Ate    ?","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
	aAdd(aRegs,{cPerg,"05","Matricula De  ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
	aAdd(aRegs,{cPerg,"06","Matricula Ate ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
	aAdd(aRegs,{cPerg,"07","C.Custo De    ?","","","mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
	aAdd(aRegs,{cPerg,"08","C.Custo Ate   ?","","","mv_ch8","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
	aAdd(aRegs,{cPerg,"09","Item De       ?","","","mv_ch9","C",20,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","CTD",""})
	aAdd(aRegs,{cPerg,"10","Item Ate      ?","","","mv_chA","C",20,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","CTD",""})	
	aAdd(aRegs,{cPerg,"11","Turno De      ?","","","mv_chb","C",03,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SR6",""})
	aAdd(aRegs,{cPerg,"12","Turno Ate     ?","","","mv_chc","C",03,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SR6",""})
	aAdd(aRegs,{cPerg,"13","Funcao De     ?","","","mv_chd","C",05,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SRJ",""})
	aAdd(aRegs,{cPerg,"14","Funcao Ate    ?","","","mv_che","C",05,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","SRJ",""})
	aAdd(aRegs,{cPerg,"15","Verf Afast    ?","","","mv_chf","N",01,0,0,"C","","mv_par15","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","Categorias    ?","","","mv_chg","C",12,0,0,"G","fCategoria","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"17","Nome Arquivo  ?","","","mv_chh","C",30,0,0,"G","NAOVAZIO","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})	
		                                                                                                           
	AjustaSx1(aRegs)   
	
	Pergunte(cPerg,.F.)   
	   
	AADD(aSays,OemToAnsi("Dados dos Funcionarios Consolidados" ) ) 
	
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
		
	FormBatch( cCadastro, aSays, aButtons )
		
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Variaveis utilizadas para parametros                         ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		
	If nOpca == 1
		Processa({|lEnd| GeraArq(),"Geracao"})
	Endif	

Return Nil

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ GeraArq    ≥ Autor ≥ Equipe Microsiga    ≥ Data ≥ 99.99.99 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Geracao de Arquivos                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function GeraArq()

Local cQuery
Local dDataDe       := DtoS(MV_PAR01)
Local dDataAte      := DtoS(MV_PAR02)
Local cFilDe        := MV_PAR03 
Local cFilAte       := MV_PAR04 
Local cMatDe        := MV_PAR05
Local cMatAte  	    := MV_PAR06
Local cCCDe			:= MV_PAR07
Local cCCAte 		:= MV_PAR08
Local cItemDe		:= MV_PAR09
Local cItemAte		:= MV_PAR10
Local cTurnoDe		:= MV_PAR11
Local cTurnoAte		:= MV_PAR12  
Local cFuncaoDe		:= MV_PAR13
Local cFuncaoAte	:= MV_PAR14
Local cVerfAfast   	:= If(MV_PAR15=1,"SIM","NAO")
Local cCategoria 	:= ALLTRIM(MV_PAR16)   
Local cPathArq		:= MV_PAR17   
Local cEmpFunc_		:= GETMV("MV_EMPFUNC")   
Local cAliasSR6		:= "SR6010" //SR6990//Tabela Compartilhada entre Empresas
Local cAliasCTD		:= "CTD010"//CTD990//Tabela Compartilhada entre Empresas
Local cAliasSRJ		:= "SRJ010"//SRJ990//Tabela Compartilhada entre Empresas
Local cAliasSRA		:= ""
Local cAliasCTT		:= ""
Local aEmp_			:= {}   
Local cCat       
Local cCont 		:= ""
Local cDet_			:= ""   
Private	cEmpCod_ 	:= ""
Private	cDescEmp_ 	:= ""
Private	cFil_ 		:= ""
Private	cDescFil_   := ""
Private aDet_		:= {}         
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Trabalha a Variavel cCatFun - ('M','H') ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

cCat := "("
For nx := 1 to Len(cCategoria)
   If Substr(cCategoria,nx,1) != "*"
	   If cCat == "("
    	  cCat += "'"
	   Else
    	  cCat += "','"
	   EndIF
	   cCat += Substr(cCategoria,nx,1)
	EndIF   
Next
cCat += "')"     

fCarEmp_(@aEmp_) // Carrega o SIGAMAT

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Cria o Arquivo TXT  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ   
nHandle	:= FCREATE(cPathArq)
	
IF Ferror() # 0 .AND. nHandle = -1
	cMsg := "Erro de abertura, codigo DOS:" + STR(FERROR(),2) 
	Aviso( "Atencao", cMsg, { "OK" } ) 
    Return
EndIF   

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Criando o Cabecalho do Arquivo .TxT    ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

cCont := "MATRICULA"+ ";" 
cCont += "NOME"+ ";" 
cCont += "CPF"+ ";"  
cCont += "ENDERECO"+ ";"
cCont += "BAIRRO" + ";" 
cCont += "MUNICIPIO" + ";" 
cCont += "ESTADO" + ";"   
cCont += "CEP" + ";"   
cCont += "NASCIMENTO" + ";" 
cCont += "TURNO DE TRABALHO" + ";"
cCont += "ADMISSAO" + ";" 
cCont += "EMAIL"+ ";"    
cCont += "EMPRESA" + ";"  
cCont += "FILIAL" + ";" 
cCont += "COD ITEM"+ ";"
cCont += "DESC ITEM"+ ";"
cCont += "COD C.CUSTO" + ";"
cCont += "DESC C.CUSTO" + ";"
cCont += "DEMISSAO" + ";" 
cCont += "SIT FOLHA" + ";" 
cCont += "FUNCAO" + ";" 
cCont += "SALARIO" + ";" 
cCont += "RG" + ";" 
//cCont += "SUPERIOR" + ";" 
cCont += "TELEFONE" + ";"
cCont += "PIS" + ";"
cCont += "CART. PROFS." + ";"
cCont += "SERIE CART." + ";"
cCont += "COD. VAGA" + ";" 
fWrite(nHandle,cCont+CRLF)	    
  
For NX:=1 To Len(aEmp_)

If (aEmp_[nx,1] $ cEmpFunc_)
    
    /*--------------------------------------------------------------------------- 
    Alterado pois agora as empresas utilizam o mesmo centro de custo da tok take.
    A exceÁ„o È a JGB. 
    Jackson E. de Deus - 07/05/2013
    ---------------------------------------------------------------------------*/
	If aEmp_[nx,1] <> "09" 
		cAliasCTT := "CTT010"	// Centro de Custo Tok Take - empresa 01   
    Else
    	cAliasCTT := "CTT" + Substr(aEmp_[nx,1],1,2) + "0"
    EndIf
    
    cAliasSRA := "SRA" + Substr(aEmp_[nx,1],1,2) + "0"

	cQuery:= "SELECT SRA.RA_FILIAL,SRA.RA_CC,SRA.RA_ITEM,SRA.RA_MAT,SRA.RA_NOMECMP,SRA.RA_CIC,SRA.RA_ADMISSA,SRA.RA_DEMISSA,SRA.RA_SITFOLH,SRA.RA_ENDEREC,SRA.RA_NASC,SRA.RA_EMAIL, " + CRLF
	cQuery+= " SRA.RA_BAIRRO, SRA.RA_ESTADO, SRA.RA_CEP, SRA.RA_MUNICIP, SRA.RA_SALARIO,SRJ.RJ_DESC,CTT.CTT_CUSTO,CTT.CTT_DESC01,SR6.R6_DESC, CTD.CTD_DESC01, " + CRLF
	//cQuery+= " SRA.RA_RG, SRA.RA_XSUPERI, SRA.RA_TELEFON, " + CRLF
	cQuery+= " SRA.RA_RG, SRA.RA_TELEFON, " + CRLF
	
	// Novos campos solicitados por Jakson Hilario Majon em 16/05/2013
	//cQuery+= " SRA.RA_PIS, SRA.RA_NUMCP, SRA.RA_SERCP, SRA.RA_XCODVAG " + CRLF	
	cQuery+= " SRA.RA_PIS, SRA.RA_NUMCP, SRA.RA_SERCP " + CRLF	
	
	cQuery+= " FROM " + cAliasSRA + " SRA, " + cAliasSR6 + " SR6, " + cAliasSRJ + " SRJ, " + cAliasCTT + " CTT, " +  cAliasCTD + " CTD " + CRLF	
	cQuery+= " WHERE SRA.RA_FILIAL >= '" + cFilDe + "' AND SRA.RA_FILIAL <= '" + cFilAte + "'" + CRLF
	cQuery+= " AND SRA.RA_MAT >= '" + cMatDe + "' AND SRA.RA_MAT <=  '" + cMatAte + "'" + CRLF
    cQuery+= " AND SRA.RA_TNOTRAB >= '" + cTurnoDe + "' AND SRA.RA_TNOTRAB <= '" + cTurnoAte + "'" + CRLF
	cQuery+= " AND SRA.RA_CODFUNC >= '" + cFuncaoDe + "' AND SRA.RA_CODFUNC <= '" + cFuncaoAte + "'" + CRLF
	cQuery+= " AND SRA.RA_SITFOLH IN (' ','D')" + CRLF
	cQuery+= " AND SRA.RA_CATFUNC IN" + cCat + CRLF
	cQuery+= " AND SRA.RA_CC >= '" + cCCDe + "' AND SRA.RA_CC <= '" + cCCAte + "'" + CRLF    
	cQuery+= " AND SRA.RA_ITEM >= '" + cItemDe + "' AND SRA.RA_ITEM <= '" + cItemAte + "'" + CRLF
	cQuery+= " AND (SRA.RA_DEMISSA >= '" + dDataDe + "' AND SRA.RA_DEMISSA <='" + dDataAte + "' OR SRA.RA_DEMISSA = ' ') " + CRLF
	cQuery+= " AND SRA.RA_AFASFGT <> '5'" + CRLF     
	cQuery+= " AND CTD.CTD_FILIAL = '  ' " + CRLF
	cQuery+= " AND CTT.CTT_FILIAL = '  ' " + CRLF	
	cQuery+= " AND SR6.R6_FILIAL = '  ' " + CRLF
	cQuery+= " AND SRJ.RJ_FILIAL = '  ' " + CRLF
	cQuery+= " AND SRA.RA_CODFUNC = SRJ.RJ_FUNCAO" + CRLF
	cQuery+= " AND SRA.RA_CC = CTT.CTT_CUSTO" + CRLF
	cQuery+= " AND SRA.RA_TNOTRAB = SR6.R6_TURNO" + CRLF
	cQuery+= " AND SRA.RA_ITEM = CTD.CTD_ITEM" + CRLF	
	cQuery+= " AND SRA.D_E_L_E_T_ <> '*'" + CRLF 
	cQuery+= " AND SR6.D_E_L_E_T_ <> '*'" + CRLF
	cQuery+= " AND CTT.D_E_L_E_T_ <> '*'" + CRLF 	 				         	  
	cQuery+= " AND SRJ.D_E_L_E_T_ <> '*'" + CRLF 
	cQuery+= " AND CTD.D_E_L_E_T_ <> '*'" + CRLF 
	cQuery+= " ORDER BY SRA.RA_FILIAL + SRA.RA_NOMECMP " + CRLF
	cQuery:= ChangeQuery(cQuery)			
		
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Cria alias conforme resultado da query ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
	If Select("ARQTRB") > 0
		dbSelectArea("ARQTRB")
		dbCloseArea("ARQTRB")
	EndIf
	
	TcQuery cQuery new Alias "ARQTRB"
	
	DbSelectArea("ARQTRB")
	DbGotop()	
	While ARQTRB->(!eof())  
	
		cEmpCod_ 	:= Substr(aEmp_[nx,1],1,2)
		cFil_ 		:= Substr(ARQTRB->RA_FILIAL,1,2)
	
		If ( nPos := Ascan(aEmp_, { |x| X[4] ==  cEmpCod_ + cFil_  })) > 0	
			cDescEmp_ 	:= 	aEmp_[nPos,2]	
			cDescFil_   :=  aEmp_[nPos,3]	
		Else		
			cDescEmp_ 	:= "" + ";"
			cDescFil_   := "" + ";"
		EndIF
		        		
		cDet_:= ARQTRB->RA_MAT + ";"
		cDet_+= AllTrim(ARQTRB->RA_NOMECMP) + ";"
		cDet_+= TRansform(ARQTRB->RA_CIC ,"@R 999.999.999-99") + ";"
		cDet_+= ARQTRB->RA_ENDEREC + ";"
		cDet_+= ARQTRB->RA_BAIRRO + ";"
		cDet_+= ARQTRB->RA_MUNICIP + ";"	
		cDet_+= ARQTRB->RA_ESTADO + ";"		
		cDet_+= Transform(ARQTRB->RA_CEP,"@R 99999-999") + ";" 
		cDet_+= TRansform(STOD(ARQTRB->RA_NASC),"@R 99/99/9999") + ";"   
		cDet_+= ARQTRB->R6_DESC + ";"			     
		cDet_+= TRansform(STOD(ARQTRB->RA_ADMISSA),"@R 99/99/9999") + ";" 
		cDet_+= ARQTRB->RA_EMAIL + ";"		
		cDet_+= cDescEmp_ + ";"
		cDet_+= cDescFil_ + ";"
		cDet_+= ARQTRB->RA_ITEM + ";"
		cDet_+= ARQTRB->CTD_DESC01 + ";"
		cDet_+= ARQTRB->RA_CC  + ";"
		cDet_+= ARQTRB->CTT_DESC01 + ";"
		cDet_+= TRansform(STOD(ARQTRB->RA_DEMISSA),"@R 99/99/9999") + ";" 				
		cDet_+= If (ARQTRB->RA_SITFOLH == "A", "AFASTADO", If(ARQTRB->RA_SITFOLH == "F","FERIAS",If(ARQTRB->RA_SITFOLH == " ","ATIVO","DEMITIDO")))+ ";"
		cDet_+= ARQTRB->RJ_DESC + ";"
		cDet_+= Transform(ARQTRB->RA_SALARIO,"@e 9,999,999.99") + ";" 
		cDet_+= ARQTRB->RA_RG  + ";" 
		//cDet_+= GetAdvFval("ZZD","ZZD_NOME",xFilial("ZZD")+ARQTRB->RA_XSUPERI,1) + ";"			// Retirado a pedido de Jakson Hilario Majon em 16/05/2013
		cDet_+= ARQTRB->RA_TELEFON + ";" 
		
		// Novos campos solicitados por Jakson Hilario Majon em 16/05/2013
		cDet_+= ARQTRB->RA_PIS + ";"
		cDet_+= ARQTRB->RA_NUMCP + ";"
		cDet_+= ARQTRB->RA_SERCP + ";"
		//cDet_+= ARQTRB->RA_XCODVAG + ";"

		aAdd(aDet_,{cDet_,aEmp_[nx,1],ARQTRB->RA_MAT}) 				
			   
      ARQTRB->(dbSkip()) //PULA PARA O PROXIMO REGISTRO DO ARQUIVO TEMPORARIO   				       	    	
			
	EndDo 
	 
	If Select("ARQTRB") >0 //FECHO O ARQUIVO TEMPORARIO
		dbSelectArea("ARQTRB")
	    dbCloseArea("ARQTRB")
	EndIf


	If cVerfAfast == "SIM"   // INCLUINDO OS AFASTADOS      
	
	    //cAliasCTT := "CTT" + Substr(aEmp_[nx,1],1,2) + "0"
	    /*--------------------------------------------------------------------------- 
    	Alterado pois agora as empresas utilizam o mesmo centro de custo da tok take.
	    A exceÁ„o È a JGB. 
	    Jackson E. de Deus - 07/05/2013
    	---------------------------------------------------------------------------*/
		If aEmp_[nx,1] <> "09" 
			cAliasCTT := "CTT010"	// Centro de Custo Tok Take - empresa 01   
	    Else
    		cAliasCTT := "CTT" + Substr(aEmp_[nx,1],1,2) + "0"
	    EndIf
    
	    cAliasSRA := "SRA" + Substr(aEmp_[nx,1],1,2) + "0"
   	    cAliasSR8 := "SR8" + Substr(aEmp_[nx,1],1,2) + "0"
			
		cQuery_:= "SELECT SRA.RA_FILIAL,SRA.RA_CC,SRA.RA_ITEM,SRA.RA_MAT,SRA.RA_NOMECMP,SRA.RA_CIC,SRA.RA_ADMISSA,SRA.RA_DEMISSA,SRA.RA_SITFOLH,SRA.RA_ENDEREC,SRA.RA_NASC,SRA.RA_EMAIL, " + CRLF
		cQuery_+= " SRA.RA_BAIRRO, SRA.RA_ESTADO, SRA.RA_CEP, SRA.RA_MUNICIP, SRA.RA_SALARIO,SRJ.RJ_DESC,CTT.CTT_CUSTO,CTT.CTT_DESC01,SR6.R6_DESC, CTD.CTD_DESC01, SR8.R8_TIPO, " + CRLF
		//cQuery_+= " SRA.RA_RG, SRA.RA_XSUPERI, SRA.RA_TELEFON, " + CRLF
		cQuery_+= " SRA.RA_RG, SRA.RA_TELEFON, " + CRLF
	
		// Novos campos solicitados por Jakson Hilario Majon
		//cQuery_+= " SRA.RA_PIS, SRA.RA_NUMCP, SRA.RA_SERCP, SRA.RA_XCODVAG " + CRLF	
		cQuery_+= " SRA.RA_PIS, SRA.RA_NUMCP, SRA.RA_SERCP " + CRLF	
	
		cQuery_+= " FROM " + cAliasSRA + " SRA, " + cAliasSR6 + " SR6, " + cAliasSRJ + " SRJ, " + cAliasCTT + " CTT, " +  cAliasCTD + " CTD, " + cAliasSR8 + " SR8 " + CRLF	
		cQuery_+= " WHERE SRA.RA_FILIAL >= '" + cFilDe + "' AND SRA.RA_FILIAL <= '" + cFilAte + "'" + CRLF
		cQuery_+= " AND SRA.RA_MAT >= '" + cMatDe + "' AND SRA.RA_MAT <=  '" + cMatAte + "'" + CRLF
	    cQuery_+= " AND SRA.RA_TNOTRAB >= '" + cTurnoDe + "' AND SRA.RA_TNOTRAB <= '" + cTurnoAte + "'" + CRLF
		cQuery_+= " AND SRA.RA_CODFUNC >= '" + cFuncaoDe + "' AND SRA.RA_CODFUNC <= '" + cFuncaoAte + "'" + CRLF
		cQuery_+= " AND SRA.RA_CATFUNC IN" + cCat + CRLF
		cQuery_+= " AND SRA.RA_CC >= '" + cCCDe + "' AND SRA.RA_CC <= '" + cCCAte + "'" + CRLF    
		cQuery_+= " AND SRA.RA_ITEM >= '" + cItemDe + "' AND SRA.RA_ITEM <= '" + cItemAte + "'" + CRLF  
		cQuery_+= " AND (SR8.R8_DATAINI >= '" + dDataDe + "' AND SR8.R8_DATAINI <='" + dDataAte + "'" + CRLF
		cQuery_+= " OR SR8.R8_DATAFIM >= '" + dDataDe + "' AND SR8.R8_DATAFIM <='"+ dDataAte + "'" + CRLF
		cQuery_+= " OR SR8.R8_DATAFIM = ' ' OR SR8.R8_DATAFIM > '" + dDataAte + "')" + CRLF
		cQuery_+= " AND SRA.RA_CODFUNC = SRJ.RJ_FUNCAO" + CRLF
		cQuery_+= " AND SRA.RA_CC = CTT.CTT_CUSTO" + CRLF
		cQuery_+= " AND SRA.RA_TNOTRAB = SR6.R6_TURNO" + CRLF
		cQuery_+= " AND SRA.RA_ITEM = CTD.CTD_ITEM" + CRLF
		cQuery_+= " AND CTD.CTD_FILIAL = '  ' " + CRLF
		cQuery_+= " AND CTT.CTT_FILIAL = '  ' " + CRLF	
		cQuery_+= " AND SRA.RA_FILIAL = SR8.R8_FILIAL" + CRLF	
		cQuery_+= " AND SRA.RA_MAT = SR8.R8_MAT" + CRLF		
		cQuery_+= " AND SR6.R6_FILIAL = '  ' " + CRLF
		cQuery_+= " AND SRJ.RJ_FILIAL = '  ' " + CRLF	
		cQuery_+= " AND SRA.D_E_L_E_T_ <> '*'" + CRLF 
		cQuery_+= " AND SR6.D_E_L_E_T_ <> '*'" + CRLF
		cQuery_+= " AND SR8.D_E_L_E_T_ <> '*'" + CRLF
		cQuery_+= " AND CTT.D_E_L_E_T_ <> '*'" + CRLF 	 				         	  
		cQuery_+= " AND CTD.D_E_L_E_T_ <> '*'" + CRLF 	 				         	  
		cQuery_+= " AND SRJ.D_E_L_E_T_ <> '*'" + CRLF 
		cQuery_+= " ORDER BY SRA.RA_FILIAL + SRA.RA_NOMECMP " + CRLF
		cQuery_:= ChangeQuery(cQuery_)	
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Cria alias conforme resultado da query ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
		If Select("ARQTRB_A") > 0
			dbSelectArea("ARQTRB_A")
			dbCloseArea("ARQTRB_A")
		EndIf
		
		TcQuery cQuery_ new Alias "ARQTRB_A"
		
		DbSelectArea("ARQTRB_A")
		DbGotop()	
		While ARQTRB_A->(!eof()) 
		
		cEmpCod_ 	:= Substr(aEmp_[nx,1],1,2)
		cFil_ 		:= Substr(ARQTRB_A->RA_FILIAL,1,2)
	
		If ( nPos := Ascan(aEmp_, { |x| X[4] ==  cEmpCod_ + cFil_  })) > 0	
			cDescEmp_ 	:= 	aEmp_[nPos,2]	
			cDescFil_   :=  aEmp_[nPos,3]	
		Else		
			cDescEmp_ 	:= "" + ";"
			cDescFil_   := "" + ";"
		EndIF
			        		
			cDet_:= ARQTRB_A->RA_MAT + ";"
			cDet_+= AllTrim(ARQTRB_A->RA_NOMECMP) + ";"
			cDet_+= TRansform(ARQTRB_A->RA_CIC ,"@R 999.999.999-99") + ";"
			cDet_+= ARQTRB_A->RA_ENDEREC + ";"
			cDet_+= ARQTRB_A->RA_BAIRRO + ";"
			cDet_+= ARQTRB_A->RA_MUNICIP + ";"	
			cDet_+= ARQTRB_A->RA_ESTADO + ";"		
			cDet_+= Transform(ARQTRB_A->RA_CEP,"@R 99999-999") + ";" 
			cDet_+= TRansform(STOD(ARQTRB_A->RA_NASC),"@R 99/99/9999") + ";"   
			cDet_+= ARQTRB_A->R6_DESC + ";"			     
			cDet_+= TRansform(STOD(ARQTRB_A->RA_ADMISSA),"@R 99/99/9999") + ";" 
			cDet_+= ARQTRB_A->RA_EMAIL + ";"		
			cDet_+= cDescEmp_ + ";"			
			cDet_+= cDescFil_ + ";"			
			cDet_+= ARQTRB_A->RA_ITEM + ";"
			cDet_+= ARQTRB_A->CTD_DESC01 + ";"
			cDet_+= ARQTRB_A->RA_CC  + ";"
			cDet_+= ARQTRB_A->CTT_DESC01 + ";"
			cDet_+= TRansform(STOD(ARQTRB_A->RA_DEMISSA),"@R 99/99/9999") + ";" 				
			cDet_+= If (ARQTRB_A->RA_SITFOLH == "A","AFASTADO" +"-"+ fDesc("SX5","30" + ARQTRB_A->R8_TIPO,"X5DESCRI()") , If(ARQTRB_A->RA_SITFOLH == "F","FERIAS",If(ARQTRB_A->RA_SITFOLH == " ","ATIVO","DEMITIDO")))+ ";"
			cDet_+= ARQTRB_A->RJ_DESC + ";"
			cDet_+= Transform(ARQTRB_A->RA_SALARIO,"@e 9,999,999.99") + ";"	 
			cDet_+= ARQTRB_A->RA_RG + ";"
			//cDet_+= GetAdvFval("ZZD","ZZD_NOME",xFilial("ZZD")+ARQTRB_A->RA_XSUPERI,1) + ";"		// Retirado a pedido de Jakson Hilario Majon em 16/05/2013
  		    cDet_+= ARQTRB_A->RA_TELEFON + ";"

	    	// Novos campos solicitados por Jakson Hilario Majon
			cDet_+= ARQTRB_A->RA_PIS + ";"
			cDet_+= ARQTRB_A->RA_NUMCP + ";"
			cDet_+= ARQTRB_A->RA_SERCP + ";"
			//cDet_+= ARQTRB_A->RA_XCODVAG + ";"

	
			aAdd(aDet_,{cDet_,aEmp_[nx,1],ARQTRB_A->RA_MAT}) 				
				   
	      ARQTRB_A->(dbSkip()) //PULA PARA O PROXIMO REGISTRO DO ARQUIVO TEMPORARIO   				       	    	
				
		EndDo 
		 
		If Select("ARQTRB_A") >0 //FECHO O ARQUIVO TEMPORARIO
			dbSelectArea("ARQTRB_A")
		    dbCloseArea("ARQTRB_A")
		EndIf  
	EndIf

EndIf	
Next nx    

If Len (aDet_) > 0 

	fGrava(aDet_)
	
	MsgAlert("Arquivo gerado com Sucesso no caminho:" + cPathArq) 
	
Else

	MsgAlert("Nao existe dados para geracao deste arquivo:" + cPathArq) 

EndIf
         
FClose(nHandle)
     

Return()   

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø////
////≥ Funcao utilizada para criar as perguntas no SX1  ≥////
////¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ////
////////////////////////////////////////////////////////////                                                                 /
////////////////////////////////////////////////////////////

Static Function AjustaSx1(_aPerg)

Local _n,_aCampos,_nLimite,_x

DbSelectArea("SX1")
DbSetOrder(1)

_aCampos := DbStruct()
_nLimite := Iif(Len(_aPerg[1])<Len(_aCampos), Len(_aPerg[1]), Len(_aCampos))

FOR _n:=1 TO Len(_aPerg)
	IF !DbSeek(_aPerg[_n, 1] + _aPerg[_n, 2], .f.)
		RecLock("SX1", .T.)
			FOR _x:=1 TO _nLimite
				FieldPut(FieldPos(_aCampos[_x, 1]), _aPerg[_n, _x])
			NEXT
		MsUnlock()
	ENDIF
NEXT

RETURN                             

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø////
////≥ Funcao utilizada para gravar os Dados no .TxT    ≥////
////¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ////
////////////////////////////////////////////////////////////                                                                 /
////////////////////////////////////////////////////////////
Static Function fGrava()
    
aSort(aDet_,,,{ |x,y| x[2]+x[3] < y[2]+y[3] })

cMat_ := "xxxxxx"

For n := 1 to Len(aDet_)


	 If cMat_<> aDet_[n,3]


	     fWrite(nHandle,aDet_[N,1] + CRLF)


	 EndIf
	 
 	 cMat_ := aDet_[n,3]


Next n

Return

// Funcao para Carregar o Sigamat.Emp // 

Static Function fCarEmp_(aEmp_) 

Local aArea:=GetArea()

dbSelectArea("SM0")
dbGoTop()
While !EOF()
	aAdd(aEmp_,{SM0->M0_CODIGO,SM0->M0_NOME,SM0->M0_FILIAL,SM0->M0_CODIGO + SM0->M0_CODFIL})
dbSkip()
End

RestArea(aArea)
Return  