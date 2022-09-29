#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
#Include "TOTVS.CH"

#define CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTOK TAKE  บAutor                         บData  ณ 08/03/16	บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotinas para importa็ใo do Ativo Fixo                        บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑบ			 ณ                                                       		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico TOK TAKE          					            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTIMPATF()

Local nX,nY
Local cMsg      := ""
Local nOpc      := 0
Local aPar	    := {}

Private cArqSN1     := ""
Private cArqSN3     := ""
Private lMsErroAuto := .F.
Private aRet	    :={}

mv_par01  := Space(090)
mv_par02  := Space(090)
aAdd(aPar,{6,"CABEวALHO (SN1)",padr('',090),"","FILE(mv_par01)","", 90 ,.T.,"Arquivo .CSV |*.CSV",'',GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
aAdd(aPar,{6,"ITENS (SN3)",padr('',090),"","FILE(mv_par02)","", 90 ,.T.,"Arquivo .CSV |*.CSV",'',GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})

If ParamBox(aPar,"Importa็ใo de Arquivo",@aRet)

	If (nHandle := FT_FUse(AllTrim(aRet[1])))== -1    // erro na abertura do arquivo
		Help("SN1",1,"NOFILEIMPOR")
		Return
	EndIf
   
	If (nHandle := FT_FUse(AllTrim(aRet[2])))== -1    // erro na abertura do arquivo
		Help("SN3",1,"NOFILEIMPOR")
		Return
	EndIf
    
    If MsgBox("Confirma Importa็ใo dos dados para o Ativo?", "Confirma ?", "YesNo")
       Processa({|| Importa()},"Aguarde...","Importando e validando os dados")
    EndIf

EndIf

Return()

////////////////////////////////////////////////
Static Function Importa()
////////////////////////////////////////////////

TTIMPARQ()
TTGRVARQ()

Alert("Importa็ใo de arquivos Concluํda...")

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTOK TAKE  บAutor                         บData  ณ 08/03/16	บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo de Arquivo                                       บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑบ			 ณ                                                       		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico TOK TAKE          					            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TTIMPARQ()

Local nPos      := 0
Local nAt       := 1
Local nCampo    := 0
Local nProc     := 1
Local nTotReg   := 0
Local cLinha    := ""
Local cCampo    := ""
Local cItem     := ""
Local cChapa    := ""
Local cCod      := ""
Local aEstruSN1	:= {}
Local aEstruSN3	:= {}

//Cria Arquivo Temporแrio SN1
FT_FUse(aRet[1])
nTotReg := FT_FLASTREC()
FT_FGOTOP()
cLinha := FT_FREADLN()

While nAt > 0
	nPos++
	nAt	:=	AT(";",cLinha)
	If nAt == 0
		cCampo := cLinha
	Else
		cCampo	:=	Substr(cLinha,1,nAt-1)
	Endif            
    Aadd(aEstruSN1,{cCampo,TamSX3(cCampo)[3],TamSX3(cCampo)[1],TamSX3(cCampo)[2]})
	cLinha	:=	Substr(cLinha,nAt+1)
Enddo

If Select("ARQSN1") > 0
	ARQSN1->(DbCloseArea())
Endif      

cArqSN1 := CriaTrab(aEstruSN1,.T.)
DbUseArea(.T.,,cARQSN1,"ARQSN1",.F.)    
DbSelectArea("ARQSN1")
IndRegua("ARQSN1",cArqSN1,"N1_CHAPA",,,"Selecionando Registros...")
ProcRegua(nTotReg)

FT_FSKIP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	nCampo := 1
	nProc++
	IncProc("Importando os dados SN1 "+StrZero(nProc,5)+"/"+StrZero(nTotReg,5))
	
    // Carrega campos para pesquisa
    cItem  := LeCampo("n1_item",cLinha,aEstruSN1)
    cChapa := LeCampo("n1_chapa",cLinha,aEstruSN1)
    cCod   := LeCampo("n1_cbase",cLinha,aEstruSN1)
    
    DbGotop()
    If !Empty(cChapa) .And. Type(cChapa) != "D"	 //Regras para conter erros na planilha.
       If !DbSeek(cChapa)
	      RecLock("ARQSN1",.T.) 
	         While At(";",cLinha)>0
                If aEstruSN1[nCampo][2] == "N"
		           FieldPut(nCampo,Val(StrTran(Substr(cLinha,1,At(";",cLinha)-1),",",".")))
		        ElseIf aEstruSN1[nCampo][2] == "D"
		           FieldPut(nCampo,CtoD(Substr(cLinha,1,At(";",cLinha)-1)))
		        Else
                   FieldPut(nCampo,Substr(cLinha,1,At(";",cLinha)-1))		   
		        EndIf
		        nCampo ++
		        cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
	         End
	      MsUnlock()
	   EndIf
	EndIf
	FT_FSKIP()
End
FT_FUSE()

//Cria Arquivo Temporแrio SN3
nPos      := 0
nAt       := 1
nCampo    := 0
nProc     := 1
nTotReg   := 0
cLinha    := ""
cCampo    := ""

FT_FUse(aRet[2])
nTotReg := FT_FLASTREC()
FT_FGOTOP()
cLinha := FT_FREADLN()

While nAt > 0
	nPos++
	nAt	:=	AT(";",cLinha)
	If nAt == 0
		cCampo := cLinha
	Else
		cCampo	:=	Substr(cLinha,1,nAt-1)
	Endif            
    Aadd(aEstruSN3,{cCampo,TamSX3(cCampo)[3],TamSX3(cCampo)[1],TamSX3(cCampo)[2]})
	cLinha	:=	Substr(cLinha,nAt+1)
Enddo

If Select("ARQSN3") > 0
	ARQSN3->(DbCloseArea())
Endif      

cArqSN3 := CriaTrab(aEstruSN3,.T.)
DbUseArea(.T.,,cARQSN3,"ARQSN3",.F.)    
DbSelectArea("ARQSN3")
IndRegua("ARQSN3",cArqSN3,"N3_CBASE",,,"Selecionando Registros...")
ProcRegua(nTotReg)

FT_FSKIP()
ARQSN1->(IndRegua("ARQSN1",cArqSN1,"N1_CBASE",,,"Selecionando Registros...",.F.))
While !FT_FEOF()
	cLinha := FT_FREADLN()
	nCampo := 1
    nProc++
	IncProc("Importando os dados da SN3 "+StrZero(nProc,5)+"/"+StrZero(nTotReg,5))
	
    // Carrega campos para pesquisa
    cItem  := LeCampo("n3_item",cLinha,aEstruSN3)
    cCod   := LeCampo("n3_cbase",cLinha,aEstruSN3)
      
    //Procura no SN1 para saber se existe cabe็alho.

    ARQSN1->(DbGotop())
    //ARQSN1->(IndRegua("ARQSN1",cArqSN1,"N1_CBASE",,,"Selecionando Registros...",.F.))
    If ARQSN1->(DbSeek(cCod))
	   RecLock("ARQSN3",.T.)
	      While At(";",cLinha)>0
             If aEstruSN3[nCampo][2] == "N"
		        FieldPut(nCampo,Val(StrTran(Substr(cLinha,1,At(";",cLinha)-1),",",".")))
		     ElseIf aEstruSN3[nCampo][2] == "D" 
		        FieldPut(nCampo,CtoD(Substr(cLinha,1,At(";",cLinha)-1)))
		     Else
		        FieldPut(nCampo,Substr(cLinha,1,At(";",cLinha)-1))
		     EndIf
		     cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
		     nCampo ++
	      End
	   MsUnlock()         
	EndIf
	FT_FSKIP()
End
FT_FUSE()

Return()

////////////////////////////////////////////////
Static Function TTGRVARQ()
////////////////////////////////////////////////
Local nOpc   
Local cTipo
Local dDIniDepr
Local nVlAquis  
Local nTotReg := 0
Local nProc   := 0
Local aCab
Local aItens


DbSelectArea("ARQSN1")
DbGoTop()
nTotReg := RecCount()
ProcRegua(nTotReg)

While ARQSN1->(!EOF())
   nProc++
   IncProc("Gravando os dados do Ativo "+StrZero(nProc,5)+"/"+StrZero(nTotReg,5))
   nVlAquis := 0
   SN1->(DbSetOrder(2))
   SN1->(DbGoTop())
   If SN1->(DbSeek(xFilial("SN1")+ARQSN1->N1_CHAPA))
      If EMPTY(DTOS(SN1->N1_BAIXA)) .AND. Alltrim(SN1->N1_STATUS) != "0"
         RecLock("SN1",.F.)
            SN1->N1_FILIAL  := xFilial("SN1")
            SN1->N1_CBASE   := ARQSN1->N1_CHAPA  
		    SN1->N1_ITEM    := STRZERO((VAL(ARQSN1->N1_ITEM)+1),4)
		    SN1->N1_QUANTD  := ARQSN1->N1_QUANTD	
		    SN1->N1_AQUISIC := ARQSN1->N1_AQUISIC
		    SN1->N1_DESCRIC := ARQSN1->N1_DESCRIC
		    SN1->N1_CHAPA   := ARQSN1->N1_CHAPA	
		    SN1->N1_FORNEC  := ARQSN1->N1_FORNEC	
		    SN1->N1_LOJA    := ARQSN1->N1_LOJA	
  		    SN1->N1_NSERIE  := ARQSN1->N1_NSERIE	
		    SN1->N1_NFISCAL := ARQSN1->N1_NFISCAL
		    SN1->N1_CODCIAP := ARQSN1->N1_CODCIAP
		    SN1->N1_ICMSAPR := ARQSN1->N1_ICMSAPR
		    SN1->N1_CALCPIS := ARQSN1->N1_CALCPIS
		    SN1->N1_MESCPIS := ARQSN1->N1_MESCPIS
		    //SN1->N1_CIAP    := ARQSN1->N1_CIAP	
		    SN1->N1_PRODUTO := ARQSN1->N1_PRODUTO
		    SN1->N1_CSTPIS  := ARQSN1->N1_CSTPIS	
		    SN1->N1_ALIQPIS := ARQSN1->N1_ALIQPIS
		    SN1->N1_CSTCOFI := ARQSN1->N1_CSTCOFI
		    SN1->N1_ALIQCOF := ARQSN1->N1_ALIQCOF
		    SN1->N1_CODBCC  := ARQSN1->N1_CODBCC	
		    SN1->N1_PROJETO := DtoC(dDatabase)
         MsUnlock()
         
         cTipo := "01"
         ARQSN3->(DbSetOrder(1))
         ARQSN3->(DbGoTop())
         ARQSN3->(DbSeek(ARQSN1->N1_CBASE))
         While ARQSN3->N3_CBASE == ARQSN1->N1_CBASE
            SN3->(DbSetorder(11))
            SN3->(DbGoTop())
            IIF(SN3->(DbSeek(xFilial("SN3")+ARQSN1->N1_CHAPA+SPACE(LEN(ARQSN3->N3_CBASE)-LEN(ARQSN1->N1_CHAPA))+SN1->N1_ITEM+cTipo+STRZERO((VAL(ARQSN3->N3_ITEM)+1),3))),lGrv := .F.,lGrv := .T.)
            nVlAquis += ARQSN3->N3_VORIG1
            RecLock("SN3",lGrv)
               SN3->N3_FILIAL  := xFilial("SN3")
               If lGrv                                                                                                                                                    
                  SN3->N3_TIPO    := cTipo
                  SN3->N3_BAIXA   := "0"
                  SN3->N3_TPSALDO := "1"
                  SN3->N3_TPDEPR  := "1"
                  SN3->N3_RATEIO  := "2"
                  SN3->N3_SEQ	  := STRZERO((VAL(ARQSN3->N3_ITEM)+1),3)
               Else
                  cTipo := "02"
               EndIf
               SN3->N3_CBASE   := ARQSN1->N1_CHAPA
               SN3->N3_ITEM    := SN1->N1_ITEM
               SN3->N3_HISTOR  := ARQSN3->N3_HISTOR
			   SN3->N3_CCONTAB := ARQSN3->N3_CCONTAB
			   SN3->N3_CUSTBEM := STRTRAN(ARQSN3->N3_CUSTBEM,".","")
			   SN3->N3_CDEPREC := STRTRAN(ARQSN3->N3_CDEPREC,".","")
			   SN3->N3_CCUSTO  := STRTRAN(ARQSN3->N3_CCUSTO,".","")
		  	   SN3->N3_CCDEPR  := STRTRAN(ARQSN3->N3_CCDEPR,".","")
			   SN3->N3_CCORREC := ARQSN3->N3_CCORREC
			   SN3->N3_DINDEPR := ARQSN3->N3_DINDEPR
			   SN3->N3_VORIG1  := ARQSN3->N3_VORIG1
			   SN3->N3_TXDEPR1 := ARQSN3->N3_TXDEPR1
			   SN3->N3_VRDBAL1 := ARQSN3->N3_VRDBAL1
			   SN3->N3_VRDMES1 := ARQSN3->N3_VRDMES1
			   SN3->N3_VRDACM1 := ARQSN3->N3_VRDACM1
			   SN3->N3_ATVORIG := "Imp-" + DtoC(dDatabase)
			   SN3->N3_AQUISIC := ARQSN3->N3_AQUISIC
            MsUnlock()
            ARQSN3->(DbSkip())
         EndDo
         RecLock("SN1",.F.)
           SN1->N1_VLAQUIS := nVlAquis
         MsUnlock()
      EndIf
   Else
      aCab:={}
      aItens := {}
      aadd(aCab,{ "N1_FILIAL"	, xFilial("SN1")        , NIL})
      aadd(aCab,{ "N1_CBASE"	, ARQSN1->N1_CHAPA      , NIL})
      aadd(aCab,{ "N1_ITEM"	    , STRZERO(VAL(ARQSN1->N1_ITEM),4) 	, NIL}) 
      aadd(aCab,{ "N1_QUANTD"	, ARQSN1->N1_QUANTD		, NIL})
      aadd(aCab,{ "N1_AQUISIC"	, ARQSN1->N1_AQUISIC    , NIL})
      aadd(aCab,{ "N1_DESCRIC"	, ARQSN1->N1_DESCRIC    , NIL})
      aadd(aCab,{ "N1_CHAPA"	, ARQSN1->N1_CHAPA	    , NIL})
      aadd(aCab,{ "N1_FORNEC"	, ARQSN1->N1_FORNEC		, NIL}) 
      aadd(aCab,{ "N1_LOJA"	    , ARQSN1->N1_LOJA		, NIL}) 
      aadd(aCab,{ "N1_NSERIE"	, ARQSN1->N1_NSERIE		, NIL}) 
      aadd(aCab,{ "N1_NFISCAL"	, ARQSN1->N1_NFISCAL	, NIL}) 
      aadd(aCab,{ "N1_CODCIAP"	, ARQSN1->N1_CODCIAP	, NIL}) 
      aadd(aCab,{ "N1_ICMSAPR"	, ARQSN1->N1_ICMSAPR	, NIL}) 
      aadd(aCab,{ "N1_CALCPIS"	, ARQSN1->N1_CALCPIS	, NIL}) 
      aadd(aCab,{ "N1_MESCPIS"	, ARQSN1->N1_MESCPIS	, NIL}) 
      //aadd(aCab,{ "N1_CIAP"   	, ARQSN1->N1_CIAP		, NIL}) 
      aadd(aCab,{ "N1_PRODUTO"	, ARQSN1->N1_PRODUTO	, NIL}) 
      aadd(aCab,{ "N1_CSTPIS"	, ARQSN1->N1_CSTPIS		, NIL}) 
      aadd(aCab,{ "N1_ALIQPIS"	, ARQSN1->N1_ALIQPIS	, NIL}) 
      aadd(aCab,{ "N1_CSTCOFI"	, ARQSN1->N1_CSTCOFI	, NIL}) 
      aadd(aCab,{ "N1_ALIQCOF"	, ARQSN1->N1_ALIQCOF	, NIL}) 
      aadd(aCab,{ "N1_CODBCC"	, ARQSN1->N1_CODBCC		, NIL}) 
      aadd(aCab,{ "N1_PROJETO"	, DtoC(dDatabase)  		, NIL})

      cTipo := "01"
      ARQSN3->(DbSetOrder(1))
      ARQSN3->(DbGoTop())
      ARQSN3->(DbSeek(ARQSN1->N1_CBASE))
      While ARQSN3->N3_CBASE == ARQSN1->N1_CBASE
         IIF(ARQSN3->N3_DINDEPR < ARQSN1->N1_AQUISIC,dDIniDepr := ARQSN1->N1_AQUISIC,dDIniDepr:=ARQSN3->N3_DINDEPR)
         nVlAquis += ARQSN3->N3_VORIG1
         aadd(aItens,{{ "N3_TIPO"	    , cTipo           	                  , NIL},;
                      { "N3_HISTOR"	    , ARQSN3->N3_HISTOR	                  , NIL},;
	   		          { "N3_CCONTAB"	, ARQSN3->N3_CCONTAB	              , NIL},;
			          { "N3_CUSTBEM"	, STRTRAN(ARQSN3->N3_CUSTBEM,".","")  , NIL},;
			          { "N3_CDEPREC"	, STRTRAN(ARQSN3->N3_CDEPREC,".","")  , NIL},;  
    			      { "N3_CCUSTO"	    , STRTRAN(ARQSN3->N3_CCUSTO,".","")	  , NIL},;				
			          { "N3_CCDEPR"	    , STRTRAN(ARQSN3->N3_CCDEPR,".","")   , NIL},;
			          { "N3_CCORREC"	, STRTRAN(ARQSN3->N3_CCORREC,".","")  , NIL},;
			          { "N3_DINDEPR"	, dDIniDepr         	              , NIL},;	
			          { "N3_VORIG1"  	, ARQSN3->N3_VORIG1	                  , NIL},;
			          { "N3_TXDEPR1"	, ARQSN3->N3_TXDEPR1	              , NIL},;                          
		              { "N3_VRDBAL1"	, ARQSN3->N3_VRDBAL1	              , NIL},;
			          { "N3_VRDMES1"	, ARQSN3->N3_VRDMES1	              , NIL},;
			          { "N3_VRDACM1"	, ARQSN3->N3_VRDACM1	              , NIL},;				
			          { "N3_ATVORIG"	, "Imp-"+DtoC(dDatabase)              , NIL},;				
                      { "N3_AQUISIC"	, ARQSN3->N3_AQUISIC                  , NIL}})
         ARQSN3->(DbSkip())
         cTipo := "02"
      ENDDO
      
      //Atualiza o Valor de aquisi็ใo da SN1 baseado no valor de original moeda 1 da SN3.
      aadd(aCab,{ "N1_VLAQUIS"  , nVlAquis              , NIL})          

      MsExecAuto({|x,y,z| ATFA010(x,y,z)}, aCab, aItens, 3)
      If lMsErroAuto
         MostraErro()
      EndIf
	
      lMsErroAuto := .F.
   EndIf
   ARQSN1->(DbSkip())
EndDo

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTOK TAKE  บAutor                         บData  ณ 08/03/16	บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ L๊ Campo na Linha do arquivo                                 บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑบ			 ณ                                                       		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico TOK TAKE          					            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeCampo(cCampo,cLinha,aEstruArq)

Local cRet
Local nItem := aScan(aEstruArq,{ | x | alltrim(x[1]) == cCampo})

For nX:= 1 to nItem
   cRet := Substr(cLinha,1,At(";",cLinha)-1)
   cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
Next

Return (cRet)